********************************************************************************
* ZVI_zsbPOHYBY_crd.PRG  ... Pohyby zásobových zvíøat
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

********************************************************************************
* ZVI_zsbPOHYBY_CRD ... Tvorba pohybových dokladù
********************************************************************************
CLASS ZVI_zsbPOHYBY_crd FROM drgUsrClass, ZVI_Main
EXPORTED:
  VAR     cNazSTRED, cNazSTAJ, cNazKATEG
  VAR     NazTypEvid, cNazFirmy, cNazVykon
  VAR     cTASK, parentForm, nEvent, cObdobi
  VAR     nKARTA, nDrPohyb, cTypPohybu, lNewREC, lVzrust
  VAR     varsORG, membORG
  VAR     nDokladUsr

  METHOD  Init, Destroy
  METHOD  ItemMarked
  METHOD  drgDialogInit, drgDialogStart, eventHandled
  METHOD  postValidate, OnSave
  METHOD  Evid_Individ
  METHOD  C_TypPoh_SEL,  Firmy_sel, LikvDOKL // DrPohyb_SEL

HIDDEN
  VAR     dm, dc, df, abMembers, oBro
  VAR     nPorZmeny, cDenik, cUserAbb//, nZmenVstCU_org, nZmenOprU_org
  VAR     nLenINVCIS, lSave

  METHOD  modiCard, DoZmena, CtrlDoklad, CtrlInvCis
  METHOD  CmpCenaCelk, CmpVzrustPR

  METHOD  CisDokl_UO
  METHOD  AllOK, LastItem, ShowActions, PrevodToZS

*  INLINE METHOD RowPosZME()
*    RETURN ::dc:oBrowse[1]:oXbp:rowPos

ENDCLASS

********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:init(parent)

  ::drgUsrClass:init(parent)
  ::ZVI_Main:Init( parent)
  *
  drgDBMS:open( 'C_TypPoh')
  drgDBMS:open( 'CNAZPOL1')
  drgDBMS:open( 'CNAZPOL4')
  drgDBMS:open( 'KATEGZVI')
  drgDBMS:open( 'FIRMY'   )
  drgDBMS:open( 'ZvZmenHDw' ,.T.,.T.,drgINI:dir_USERfitm)

  drgDBMS:open( 'ZvZmenHDw1',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'ZvZmenHDw2',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'ZvZmenIT')
  drgDBMS:open( 'ZvZmenITw' ,.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open( 'ZvKarty',,,,, 'ZvKarty_a' )
  drgDBMS:open( 'KategZvi',,,,,'KategZvi_a')
  *
  ::cNazSTRED  := cNazPOL1->cNazev
  ::cNazSTAJ   := cNazPOL4->cNazev
  ::cNazKATEG  := KategZvi->cNazevKat
  ::cObdobi    := AllTrim( Str( ::nAktObd)) + '/' + AllTrim( Str( ::nAktRok))
  ::NazTypEvid := IF( ZvKarty->cTypEvid = 'S', 'Skupinová', 'Individuální' )
  ::cNazFirmy  := ::cNazVykon := ''
  ::nKARTA     := 999
  ::cTypPohybu := ''
  ::lVzrust    := KategZvi->lVzrust // indikace, zda pro danou kateg. generovat vzrùst.pøírùstek
  ::nPorZmeny  := 0
  *
  ::nEvent     := parent:cargo
  ::lNewREC    := ( ::nEvent <> drgEVENT_EDIT)
  ::parentForm := parent:parent:formName
  ::cUserAbb   :=  SysConfig( 'System:cUserAbb')
  *
  IF  ::parentForm = 'Zvi_zsbPohyby_scr' .and. ::lNewRec
    ::cNazSTRED := ::cNazSTAJ := ::cNazKATEG := ::NazTypEvid := ''
  ENDIF
  *
  IF ::lNewREC
    ZvZmenHDw->( dbZAP())
    ZvZmenITw->( dbZAP())
  ELSE
    ZvZmenITw->( dbZAP())
    cKey := StrZero( ZvZmenHD->nDoklad, 10)
    ZvZmenIT->( AdsSetOrder( 2),;
                mh_setScope( cKey),;
                dbEval( {|| mh_CopyFld( 'ZvZmenIT', 'ZvZmenITw', .t.)}))
    ZvZmenITw->( dbGoTOP())
  ENDIF

RETURN self

********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:drgDialogInit(drgDialog)
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, aPos
RETURN

********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:drgDialogStart(drgDialog)
  Local  members  := drgDialog:dialogCtrl:members[1]:aMembers, x, isDisabled

*  ColorOfText(  members)
  ::dm         := drgDialog:dataManager
  ::dc         := drgDialog:dialogCtrl
  ::df         := drgDialog:oForm
  ::abMembers  := drgDialog:oActionBar:Members
  ::membORG    := ::dc:members[1]:aMembers
  ::varsORG    := ::dm:vars
  *
  isDisabled := IF( ::parentForm = 'Zvi_zsbPohyby_scr', .T., ZvKarty->cTypEvid = 'S' )
  ::ShowActions( isDisabled)
  *
  IsEditGET( 'ZvZmenHDw->nDoklad' , ::drgDialog, .F.      )
  *
  ::DoZmena()
  *
RETURN self

*
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:EventHandled(nEvent, mp1, mp2, oXbp)
  DO CASE
    CASE  nEvent = drgEVENT_SAVE
      IF ::ctrlInvCis()
        ::onSave()
        PostAppEvent(xbeP_Close, nEvent,, ::drgDialog:dialog)
      ENDIF

    CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
      PostAppEvent(xbeP_Close,nEvent,,oXbp)

    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)
        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

* HIDDEN************************************************************************
METHOD ZVI_zsbPOHYBY_crd:doZmena()
  Local  nPohyb, cMsg

  DO CASE
  CASE ::nEvent = drgEVENT_EDIT
    mh_COPYFLD( 'ZvZmenHD', 'ZvZmenHDw', .t.)
    ::nKARTA := ZvZmenHDw->nKarta
    ::modiCard()
    IsEditGET( 'ZvZmenHDw->cTypPohybu', ::drgDialog, .F.)
    ::df:setNextFocus( 'ZvZmenHDw->dDatZmen',, .T. )
    ::dm:refresh()

  CASE ::nEvent = drgEVENT_APPEND
      ZvZmenHDw->( dbAppend())
      ::nKARTA     := 999
      ::nDokladUsr := 0
      ::modiCard()
      *
      IF ::parentForm = 'Zvi_zsbPohyby_scr'
        ZvZmenHDw->cNazPol1  := ''
        ZvZmenHDw->cNazPol4  := ''
        ZvZmenHDw->nZvirKat  := 0
        ::cNazSTRED  := '' // cNazPOL1->cNazev
        ::cNazSTAJ   := '' // cNazPOL4->cNazev
        ::cNazKATEG  := '' //  KategZvi->cNazevKat
      ELSE
        ::dm:set( 'ZvZmenHDw->cNazPol1', ZvZmenHDw->cNazPol1  := ZvKarty->cNazPol1)
        ::dm:set( 'ZvZmenHDw->cNazPol4', ZvZmenHDw->cNazPol4  := ZvKarty->cNazPol4)
        ::dm:set( 'ZvZmenHDw->nZvirKat', ZvZmenHDw->nZvirKat  := ZvKarty->nZvirKat)
*        ZvZmenHDw->cNazPol1  := ZvKarty->cNazPol1
*        ZvZmenHDw->cNazPol4  := ZvKarty->cNazPol4
*        ZvZmenHDw->nZvirKat  := ZvKarty->nZvirKat
** 4.4.2008        PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( 'ZvZmenHDw->nDrPohyb'):oDrg:oXbp )
        ::df:setNextFocus( 'ZvZmenHDw->cTypPohybu',, .T. )

      ENDIF
      *
      ::dm:refresh()

  ENDCASE

RETURN SELF

********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:Evid_Individ()
  LOCAL oDialog, nExit, aSize,  aPos[2]
  Local oParent := ::drgDialog:parentdialog
  Local oOwner  := ::drgDialog:dialog
  Local Kusy := ::dm:has( 'ZvZmenHDw->nKusyZV')

  IF  (( Upper( ZvKarty->cTypEvid) = 'I' .or. ;
       ( Upper( ZvKarty->cTypEvid) = 'S' .and. ::nKARTA = 610 )) .and. isObject( Kusy) )

    oDialog := drgDialog():new('ZVI_zsbZvZmenIT_SCR', oOwner)
    oDialog:create(, oOwner,.t.)
    nExit := oDialog:exitState

    oDialog:destroy(.T.)
    oDialog := Nil
  ELSE
    ::lSave := .T.
  ENDIF
  *
RETURN self

* Poèáteèní èíslo doklad pro úèetní odpisy
* HIDDEN************************************************************************
METHOD ZVI_zsbPOHYBY_crd:CisDokl_UO()
  Local nDoklad, nRec, cTag
/*
  ( nRec := (::fiZMAJU)->( RecNo()), cTag := (::fiZMAJU)->( AdsSetOrder( 3)) )
    (::fiZMAJU)->( dbGoBottom())
    nDoklad := If( (::fiZMAJU)->nDoklad < 900000, 900000, (::fiZMAJU)->nDoklad  )
  ( (::fiZMAJU)->( AdsSetOrder( cTag)), (::fiZMAJU)->( dbGoTo( nRec)) )
*/
RETURN nDoklad

* Pøi pohybu v seznamu
*****************************************************************
METHOD ZVI_zsbPOHYBY_crd:ItemMarked()
/*
  Local nPohyb := Int( (::fiZMAJUw)->nKarta / 100 )
  Local lEdit

  IF ::nKARTA <> (::fiZMAJUw)->nKARTA
    ::nKARTA := IF( (::fiZMAJUw)->nKARTA <> 0, (::fiZMAJUw)->nKARTA, ::nKARTA)
    ::modiCARD()
  ENDIF
  *
*  lEdit := ( (::fiZMAJUw)->( RecNO()) = ::TopRecNO .and. (::fiMAJ)->nZnAkt <> VYRAZEN )  .and. ;
*             nPohyb <> 0
  lEdit := ( ::RowPosZME() = 1 .and. (::fiMAJ)->nZnAkt <> VYRAZEN )  .and. ;
             nPohyb <> 0
  *
  DO CASE
    CASE ::nKARTA = 201 .or. ::nKARTA = 202
      IsEditGET( CRD_201_202, ::drgDialog, lEdit)
    CASE ::nKARTA = 203
      IsEditGET( CRD_203    , ::drgDialog, lEdit)
    CASE ::nKARTA = 204 .or. ::nKARTA = 100
      IsEditGET( CRD_204    , ::drgDialog, .F.)
    CASE ::nKARTA = 301
      IsEditGET( CRD_301    , ::drgDialog, lEdit)
  ENDCASE
  IsEditGET( ::fiZMAJUw + '->nDrPohyb', ::drgDialog, .F.)
  *
  ::dm:refresh()
  *
*/
RETURN SELF

*
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:PostValidate( oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lOK := .T.  // , lSave := .F.
  LOCAL cName := Lower(oVar:Name), cKey
  Local nPos, nPohyb := ::dm:get('ZvZmenHDw->cTypPohybu')
  Local cNazpol1 := ::dm:get( 'zvzmenhdw->cnazpol1')
  Local cNazpol4 := ::dm:get( 'zvzmenhdw->cnazpol4')
  Local nZvirkat := ::dm:get( 'zvzmenhdw->nzvirkat')
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)
  ::lSave := .F.

  DO CASE
    CASE cName $ 'zvzmenhdw->cnazpol1, zvzmenhdw->cnazpol4, zvzmenhdw->nzvirkat'
       IF ! (lOK := ControlDUE( oVar))
         PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
       ENDIF
       ::cNazSTRED := IF( cName = 'zvzmenhdw->cnazpol1', cNazPol1->cNazev   , ::cNazSTRED)
       ::cNazSTAJ  := IF( cName = 'zvzmenhdw->cnazpol4', cNazPol4->cNazev   , ::cNazSTAJ )
       ::cNazKATEG := IF( cName = 'zvzmenhdw->nzvirkat', KategZvi->cNazevKat, ::cNazKATEG)
       ::lVzrust   := IF( cName = 'zvzmenhdw->nzvirkat', KategZvi->lVzrust  , ::lVzrust  )
       *
       IF !Empty( cNazpol1) .and. !Empty( cNazpol4) .and. !Empty( nZvirKat )
         cKey := Upper( cNazPol1) + Upper( cNazPol4) + StrZero( nZvirKat, 6)
         IF  ZvKarty->( dbSeek( cKey,, 'ZVKARTY_01' ))
           ::ShowActions( ZvKarty->cTypEvid = 'S')
           ::NazTypEvid := IF( ZvKarty->cTypEvid = 'S', 'Skupinová', 'Individuální' )
         ELSE
           drgMsgBox(drgNLS:msg( 'Karta zvíøete neexistuje, nelze na ni vykázat pohyb !'))
           IF cName = 'zvzmenhdw->nzvirkat'
             ::df:setNextFocus( 'ZvZmenHDw->cNazPol1',, .T. )
           ENDIF
         ENDIF
       ENDIF

    CASE cName = 'ZvZmenHDw->cTypPohybu'
       lOK := ::C_TypPoh_SEL()
*       lOK := IF( lChanged, ::C_TypPoh_SEL(), lOK)
    CASE cName = 'ZvZmenHDw->nDoklad'
      IF lOK := ControlDUE( oVar)
         lOK := ::CtrlDOKLAD( xVal)
      ENDIF

    CASE cName = 'ZvZmenHDw->dDatZmZv'
      lOK := ( ::nAktObd = MONTH( xVar)  .AND. ::nAktRok = YEAR( xVar) )
      If !lOK
        drgMsgBox(drgNLS:msg( 'Datum zmìny [ & ] je mimo aktuální období [ & ] ...', xVar, ::cAktOBD))
        lOK := YES
      Endif

    CASE ::nKARTA = 400    //;  lOK := KarVld_400( G, N, xVal)
      Do Case
        Case cName $ 'zvzmenhdw->nkusyzv, zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::CmpCenaCELK()
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

    CASE ::nKARTA = 410
      Do Case
        Case cName = 'ZvZmenHDw->nCisFirmy'
*          IF (lOK := ControlDUE( oVar) )
            lOK := ::Firmy_SEL()
            If ( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or.  mp1 = xbeK_DOWN ))
              ::df:setNextFocus(  'ZvZmenHDw->nKusyZV',, .T. )
            ENDIF
*          ENDIF
        Case cName $ 'zvzmenhdw->nkusyzv, zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::CmpCenaCELK()
        Case cName = 'ZvZmenHDw->nCenaCZV'
          ::dm:set( 'ZvZmenHDw->nCenaSZV', xVar / IF( KategZvi->nTypVypCel = 1, ::dm:get( 'ZvZmenHDw->nMnozsZV'),;
                                                                                ::dm:get( 'ZvZmenHDw->nKusyZV' )))
          ::LastItem( cName, nEvent, mp1)
          /*
          IF( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or. mp1 = xbeK_DOWN ))
            ::Evid_Individ()
            ::df:setNextFocus( cName,, .F. )
          ENDIF
          */
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

   CASE ::nKARTA = 420
      Do Case
        Case cName $ 'zvzmenhdw->nkusyzv, zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::CmpCenaCELK()
          IF( cName = 'zvzmenhdw->nmnozszv', ::LastItem( cName, nEvent, mp1), NIL )
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

    CASE ::nKARTA = 430 .or. ::nKARTA = 431
      Do Case
        Case cName = 'ZvZmenHDw->cNazPol2'
          IF Empty( xVar)
            PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
          ENDIF
          ::df:setNextFocus( 'ZvZmenHDw->nKusyZV',, .T. )
          ::cNazVykon := cNazPol2->cNazev
        Case cName $ 'zvzmenhdw->nkusyzv, zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::CmpCenaCELK()
          IF( cName = 'zvzmenhdw->nmnozszv', ::LastItem( cName, nEvent, mp1), NIL )
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

    CASE ::nKARTA == 440
      Do Case
        Case cName $ 'zvzmenhdw->nkd, zvzmenhdw->ncenaszv'
          ::dm:set('ZvZmenHDw->nCenacZV', ::dm:get( 'ZvZmenHDw->nCenasZV') * ::dm:get( 'ZvZmenHDw->nKd'))
          ::lSave := ( cName = 'zvzmenhdw->nkd' )
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

    CASE ::nKARTA == 450
      Do Case
        Case cName = 'ZvZmenHDw->cNazPol2'
          IF Empty( xVar)
            PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
          ENDIF
          ::df:setNextFocus( 'ZvZmenHDw->nMnozsZV',, .T. )
          ::cNazVykon := cNazPol2->cNazev
        Case cName $ 'zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::dm:set('ZvZmenHDw->nCenacZV', ::dm:get( 'ZvZmenHDw->nCenasZV') * ::dm:get( 'ZvZmenHDw->nMnozsZV'))
          ::lSave := ( cName = 'zvzmenhdw->nmnozszv' )
      EndCase
 *      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

    CASE nPos := ASCAN( { 500,510,511}, ::nKARTA ) > 0
      Do Case
        Case cName = 'ZvZmenHDw->cVarSym'
          IF ::nKarta = 510
            ::df:setNextFocus(  'ZvZmenHDw->nKusyZV',, .T. )
          ENDIF
        Case cName = 'ZvZmenHDw->nCisFirmy'
          IF ::nKarta = 511 .and.  ::cTypPohybu <> '72'  // Výdej s vazbou na odbìratele
*            IF (lOK := ControlDUE( oVar) )
            IF lOK := ::Firmy_SEL()
              ::df:setNextFocus(  'ZvZmenHDw->nKusyZV',, .T. )
            ENDIF
          ENDIF
        Case cName $ 'zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          IF ( cName = 'zvzmenhdw->nmnozszv' .and. xVar > ZvKarty->nMnozsZV .and. KategZvi->nTypVypCel = 1 )
            drgMsgBox(drgNLS:msg( 'Zadané množství pøesahuje stav na kartì zvíøete.;;' + ;
                                  'Množství i cena pùjdou do minusu !'))
          ENDIF
          ::CmpCenaCELK()
          IF( cName = 'zvzmenhdw->nmnozszv', ::LastItem( cName, nEvent, mp1), NIL )

        Case cName = 'zvzmenhdw->nkusyzv'
          IF xVar = 0
            drgMsgBox(drgNLS:msg( 'Nebyl zadán poèet kusù !'))
            lOK := .F.
          ELSEIF xVar > ZvKarty->nKusyZV
            drgMsgBox(drgNLS:msg( 'Poèet kusù k dispozici je pouze [ & ] !', ZvKarty->nKusyZV ))
            lOK := .F.
          ELSE
            ::CmpVzrustPR() // Pøepoèet skl.ceny pøi výdeji u kategorie se vzrùst. pøírùstkem
            ::CmpCenaCELK()
          ENDIF
      EndCase
*      G[ CENAMJ]:preBlock := {|| N >= CENAMJ-1 .and. LASTKEY() == K_UP }

*    CASE nPos := ASCAN( { 512,513,514}, ::nKARTA ) > 0
*       nevalidujeme

    CASE ::nKARTA = 515
      Do Case
        Case cName = 'ZvZmenHDw->cNazPol2'
          IF Empty( xVar)
            PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
          ENDIF
          ::df:setNextFocus( 'ZvZmenHDw->nMnozsZV',, .T. )
          ::cNazVykon := cNazPol2->cNazev
      EndCase
      ::lSave := ( cName = 'zvzmenhdw->nkusyzv' )
      /* 8.6.2011 - zatim blokneme, než se vyjasní pohyby "zmetání" a "mrtvì naroz."
      if cName = 'zvzmenhdw->nkusyzv'
        ::LastItem( cName, nEvent, mp1)
      endif
      **/
    CASE nPos := ASCAN( { 600,610,620}, ::nKARTA ) > 0
      Do Case
        Case cName $ 'zvzmenhdw->cnazpol1_n,zvzmenhdw->cnazpol4_n,zvzmenhdw->nzvirkat_n,zvzmenhdw->cnazpol2_n'
          IF Empty( xVar)
            PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
          ENDIF
          IF cName = 'zvzmenhdw->nzvirkat_n'
            cKey := Upper( ::dm:get('zvzmenhdw->cnazpol1_N')) + ;
                    Upper( ::dm:get('zvzmenhdw->cnazpol4_N')) + StrZero( xVar, 6)
            IF !ZvKarty_a->( dbSeek( cKey,,'ZVKARTY_01'))
              lOK := .F.
              drgMsgBox(drgNLS:msg( 'Pøevod nelze uskuteènit, nebo cílová karta neexistuje;' + ;
                                    'a musíte ji nejprve založit !'))
              ::df:setNextFocus( 'ZvZmenHDw->cNazPol1_N',, .T. )
            ELSEIF ZvKarty->( RecNO()) = ZvKarty_a->( RecNO())
              lOK := .F.
              drgMsgBox(drgNLS:msg( 'Pøevod nelze uskuteènit, nebo provádíte pøevod;' + ;
                                    'na identickou organizaèní jednotku !'))
            ELSEIF ::nKarta = 610
              * V KategZvi musí být naplnìny položky pro zápis do souboru MAJ(Z)
              KategZvi_a->( dbSeek( xVar,,'KATEGZVI_1'))
              lOK := ( KategZvi_a->nOdpiSk   <> 0  .and. KategZvi_a->nOdpiSkD  <> 0  .and. ;
                       KategZvi_a->cOdpiSk   <> '' .and. KategZvi_a->cOdpiSkD  <> '' .and. ;
                       KategZvi_a->nTypDOdpi <> 0  .and. KategZvi_a->nTypUOdpi <> 0 )
              IF !lOK
                drgMsgBox(drgNLS:msg( 'Kategorie zvíøete [ & ] nemá naplnìny položky, nutné pro založení záznamu do základního stáda !', xVar))
                RETURN .F.
              ENDIF
            ENDIF
          ENDIF

        Case cName $ 'zvzmenhdw->nmnozszv, zvzmenhdw->ncenaszv'
          ::CmpCenaCELK()
          IF( cName = 'zvzmenhdw->nmnozszv', ::LastItem( cName, nEvent, mp1), NIL )

        Case cName = 'zvzmenhdw->nkusyzv'
          IF xVar = 0
            lOK := .F.
            drgMsgBox(drgNLS:msg( 'Nebyl zadán poèet kusù !'))
          ENDIF
          IF xVar > ZvKarty->nKusyZV
            lOK := .F.
            drgMsgBox(drgNLS:msg( 'Nelze pøevést více kusù než je na kartì !;' + ;
                                  'Kusy na kartì = [ & ]', ZvKarty->nKusyZV ))
          ENDIF
          IF lOK
            ::CmpVzrustPR() // Pøepoèet skl.ceny pøi výdeji u kategorie se vzrùst. pøírùstkem
            ::CmpCenaCELK()
            IF ::nKarta = 610
              lOK := ::PrevodToZS()
            ENDIF
          ENDIF
          *
      EndCase
      ::lSave := ( cName = 'zvzmenhdw->nmnozszv' )

  ENDCASE
  *
  ::dm:refresh()
  *
**  If( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN .and. ::lSave )
**    PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
*  Uložení na posl.položce není žádoucí (JCH), nebo doklad se uloží a zmizí a nelze ho pøekontrolovat
**  EndIf

RETURN lOK

*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:PrevodToZS()
  Local nMin := IF( KategZvi->nKcPrevBot = 0, SysCONFIG('Zvirata:nKcPrevBot'), KategZvi->nKcPrevBot )
  Local nMax := IF( KategZvi->nKcPrevTop = 0, SysCONFIG('Zvirata:nKcPrevTop'), KategZvi->nKcPrevTop )
  Local nCenaMJ := ::dm:get( 'ZvZmenHDw->nCenasZV'), lOK

  lOK := ( nCenaMJ > nMin)
  IF !lOK
    drgMsgBox(drgNLS:msg( 'Cena zvíøete [ & ] nesplòuje podmínku pro pøevod zvíøete do ZS !;' + ;
                          '( Je nastavena èástka  &  a vyšší )', nCenaMJ, nMin ))
    RETURN .F.
  ENDIF
RETURN lOK

*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:LastItem( cName, nEvent, mp1)
  *
  IF( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or. mp1 = xbeK_DOWN ))
    ::Evid_Individ()
    ::df:setNextFocus( cName,, .F. )
  ENDIF
RETURN NIL

*
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:OnSAVE( isBefore, isAppend )
  Local zsbMODI, nRec, cKey, uctLikv

  ::dm:save()
  IF ::nEvent =  drgEVENT_APPEND
    ZvZmenHD->( dbAppend())
    *
    cKEY := Z_DOKLADY + Upper( ZvZmenHDw->cTypPohybu)        // ALLTRIM( STR( ZvZmenHD->nDrPohyb ))
    lOK  := C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
    ZvZmenHD->cTypDoklad := IF( lOK, C_TypPoh->cTypDoklad, '???' )
    ZvZmenHD->cTypPohybu := IF( lOK, C_TypPoh->cTypPohybu, '???' )
    ZvZmenHD->nDrPohyb   := val( C_TypPoh->cTypPohybu)
    ZvZmenHD->nKarta     := val(right(alltrim( C_TypPoh->cTypDoklad), 3))
    ZvZmenHD->lProdukce  := C_TypPoh->lProdukce
    ZvZmenHD->nTypPohyb  := C_TypPoh->nTypPohyb

    mh_CopyFld( 'ZvKarty'  , 'ZvZmenHD' )
    ZvZmenHD->cUcetSkup := ALLTRIM(STR( ZvZmenHD->nUcetSkup))
*    mh_CopyFld( 'C_TypPoh' , 'ZvZmenHD' )
    IF ZvZmenHD->cTypZVR == 'V'
      ZvZmenHD->nDrPohybP := C_TypPoh->nDrPohPlPr
    ENDIF
    *
    ZvZmenHD->cUloha     := 'Z'
    ZvZmenHD->cDenik     := ::cDenikZvZ
    ZvZmenHD->nRok       := ::nAktROK
    ZvZmenHD->nObdobi    := ::nAktOBD
    ZvZmenHD->nPorZmeny  := ZVI_GETPorZme()  // nPorZmeny
    ZvZmenHD->nOrdItem   := zm_ZAKLADNI  // 1
    ZvZmenHD->lZmenaZAKL := YES
    * Nuluje hodnotové položky
    ZvZmenHD->nCenaSZV   := 0
    ZvZmenHD->nKusyZV    := 0
    ZvZmenHD->nMnozSZV   := 0
    ZvZmenHD->nKD        := 0
    ZvZmenHD->nCenaCZV   := 0
    *
  ELSE
    ZvZmenHD->( dbRLock())
    mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw1', .t.)
  ENDIF
*  mh_CopyFld( 'ZvZmenHDw', 'ZvZmenHD' )
  mh_CopyFldarr( 'ZvZmenHDw', 'ZvZmenHD',,,,, ::dm:vars )
  *
  ZvZmenHD->cObdobi    := StrZERO( ZvZmenHD->nObdobi, 2) + '/' + ;
                          RIGHT( StrZERO( ZvZmenHD->nRok, 4), 2)
  KategZvi->( dbSeek( ZvZmenHD->nZvirKAT,,'KATEGZVI_1'))
  ZvZmenHD->nTypVypCel := KategZvi->nTypVypCel
  ZvZmenHD->nKusyZV    := IIF( ::nKARTA == 450, 0, ZvZmenHD->nKusyZV )
  ZvZmenHD->nKD        := IIf( ::nKARTA == 440, ZvZmenHD->nKD,;
                          IIF( ::nKARTA == 450 .OR. ::nKARTA == 514,  0,;
    ( mh_LastDayOM( ZvZmenHD->dDatZmZv) - DAY( ZvZmenHD->dDatZmZv) + 1 ) * ZvZmenHD->nKusyZV))
  ZvZmenHD->dDatZmeny  := DATE()
  ZvZmenHD->cCasZmeny  := TIME()
  ZvZmenHD->cUserAbb   := ::cUserAbb
  ::nDokladUsr         := ZvZmenHD->nDokladUsr
  ZvZmenHD->cFarma     := PADR( ALLTRIM( STR( ZVI_CisFARMY( ZvZmenHD->cNazPol4, YES, 1 ))), 10)  /// 7.5.02
  *
  IF ZvZmenHD->nKarta = 431  // narozeni
    ZvZmenHD->cNazPol2_N := ZvKarty->cNazPol2
  ENDIF
  *
  zsbMODI := ZVI_zsbMODI():new( self)
  *
  nRec := ZvZmenHD->( RecNO())
  zsbMODI:genVzrust( zm_ZAKLADNI_VZRUST)    // ( 2)
  IF !::lNewREC
    ZvZmenHDw2->( dbZAP())
    mh_CopyFld( 'ZvZmenHDw1', 'ZvZmenHDw2', .t.)
  ENDIF
  ZvZmenHD->( dbGoTO( nREC))
  *
  zsbMODI:m_Zvirata()
  zsbMODI:m_ZvKarty()
**  zsbMODI:m_ZvKarObd()
**  zsbMODI:m_ZvZmObd()
  *
  uctLikv := UCT_likvidace():New(Upper( ZvZmenHD->cUloha) + Upper( ZvZmenHD->cTypDoklad),.T.)
  *
  zsbMODI:genPrevod()
  zsbMODI:m_ZaklStado()
  *
  ZvZmenHD->( dbUnlock())
RETURN .T.

********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:destroy()
  ::drgUsrClass:destroy()
  *
  ::cTask := ::cObdobi := ::lNewRec := ::nKarta := ::parentForm := ::nEvent := ;
  ::varsOrg := membOrg := ::NazTypEvid := ::cNazFirmy := ::cNazVykon := ;
  NIL
  ZvZmenHDw->( dbCloseArea())
  ZvZmenHDw1->( dbCloseArea())
  ZvZmenHDw2->( dbCloseArea())
  /*
  (::fiZMajUw)->( dbCloseArea())
  (::fiCIS)->( dbClearFilter())
*  oDialog:parent:dialogCtrl:refreshPostDel()
  *
  ::cTASK := ::isHIM := ::fiMAJ := ::fiZMAJU := ::fiZMAJUw := ::fiCIS :=  ;
  ::dm := ::dc := ::df := ::nKARTA := ::lNewREC := ::varsORG := ::membORG := ;
  ::nRoundOdpi := ::cAktObd := ::nAktOBD := ::nAktROK := ;
  ::nPorZmeny := ::cDenik := ::cUserAbb := ::fiSUMMAJ :=  ;
  ::nZmenVstCU_org := ::nZmenOprU_org := ::nLenINVCIS := ;
   Nil
   */
RETURN self

/* Zavolá výbìr druhu pohybu
*****************************************************************
METHOD ZVI_zsbPOHYBY_crd:DrPohyb_SEL( oDlg)
  LOCAL oDialog, nExit, nPos
  LOCAL Value := ::dm:get( 'ZvZmenHDw->nDrPohyb')
  LOCAL lOK  // := ( value <> 0) .and. C_DrPohZ->( dbSEEK( Value,, 1))

  C_DrPohZ->( dbSetFilter( COMPILE( 'nKarta >= 400')), dbGotop())
  lOK   := ( value <> 0) .and. C_DrPohZ->( dbSEEK( Value,, 'DRPOHZ1'))

  IF IsObject( oDlg) .or. ! lOK
    DRGDIALOG FORM   'ZVI_DrPohyb_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF  nExit = drgEVENT_QUIT
*    PostAppEvent( xbeP_Keyboard, xbeK_ESC,,::dm:has( ::fiZMAJUw +'->nDrPohyb'):oDrg:oXbp)
*    RETURN .F.
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
*    IsEditGET( {'ZvZmenHDw->nDrPohyb'}, ::drgDialog, .F.)
    *
    IF ::nKARTA <> C_DrPohZ->nKARTA
      ::nKARTA   := C_DrPohZ->nKARTA
      ::nDrPohyb := C_DrPohZ->nDrPohyb
      ::modiCARD()
      *
      ::dm:set( 'ZvZmenHDw->nDrPohyb' , C_DrPohZ->nDrPOHYB  )
*      ::dm:set( 'ZvZmenHDw->cNazevPoh', C_DrPohZ->cNazevPoh )
      IF ::lNewREC
        ::dm:set( 'ZvZmenHDw->dDatPoriz' , DATE()  )
        ::dm:set( 'ZvZmenHDw->nDokladUsr', ::nDokladUsr )
        ::dm:set( 'ZvZmenHDw->nDoklad'   , ZVI_NewDokl() )   // NewDokl()  )
        ::dm:set( 'ZvZmenHDw->dDatZmZv'  , DATE()  )
        *
        IF !IsNULL( ::dm:has( 'ZvZmenHDw->nCenaSZV' ) )
          ::dm:set( 'ZvZmenHDw->nCenaSZV', IF( c_DrPohZ->nDrPohyb = 22, ZvKarty->nCenaV1ZV,;
                                                                        ZvKarty->nCenaSZV ) )
        ENDIF
        IF ::nKARTA == 410
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , 0 )
        ENDIF
        IF ::nKARTA == 431   // Karta narozeni
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , ZvKarty->nCenaV1ZV )
        ENDIF
        *
        IF ::nKARTA == 450   //Ä
          ::dm:set( 'ZvZmenHDw->cNazPol2' , ZvKarty->cNazPol2 )
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , ZvKarty->nCenaV2ZV )
          ::cNazVykon := cNazPol2->cNazev
*          IsEditGET( {'ZvZmenHDw->nCenacZV'}, ::drgDialog, .F.)
        ENDIF
        IF ::nKARTA == 600
          ::dm:set( 'ZvZmenHDw->nZvirKat_N' , ZvKarty->nZvirKat )
          ::dm:set( 'ZvZmenHDw->cNazPol2_N' , ZvKarty->cNazPol2 )
        ENDIF
        IF ::nKARTA == 610 .or. ::nKARTA == 620
          ::dm:set( 'ZvZmenHDw->nZvirKat_N' , ZvKarty->nZvirKatPr )
          ::dm:set( 'ZvZmenHDw->cNazPol2_N' , ZvKarty->cNazPol2Pr )
        ENDIF

      ENDIF
    ENDIF
    * Cena celkem - needitovatelná
    IF nPos := ASCAN( { 450,500,510,511}, ::nKarta ) > 0
      IsEditGET( {'ZvZmenHDw->nCenacZV'}, ::drgDialog, .F.)
    ENDIF
    *
    ::dm:refresh()
  ENDIF
  C_DrPohZ->( dbClearFilter())
RETURN lOK
*/

* Zavolá výbìr druhu pohybu
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:C_TypPoh_SEL( oDlg)
  LOCAL oDialog, nExit, nPos
  LOCAL Value := ::dm:get( 'ZvZmenHDw->cTypPohybu')
  LOCAL lOK   := ( !Empty(value) .and. C_TypPoh->(dbseek( Z_DOKLADY + value,,'C_TYPPOH02')))

  IF IsObject( oDlg) .or. ! lOK

    cFilter := "cUloha = 'Z' .and. Val(Right(AllTrim( cTypDoklad),3)) >= 400 "
    C_TypPoh->( mh_ClrFilter(), mh_SetFilter( cFilter))
    *
    DRGDIALOG FORM 'C_TypPOH_sel' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF  nExit = drgEVENT_QUIT
    PostAppEvent( xbeP_Keyboard, xbeK_ESC,,::dm:has( 'ZvZmenHDw->cTypPohybu'):oDrg:oXbp)
    RETURN .F.
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
*    IsEditGET( {'ZvZmenHDw->nDrPohyb'}, ::drgDialog, .F.)
    IF ::nKARTA <> Val(Right(AllTrim( C_TypPOH->cTypDoklad),3))   // C_TypPOH->nKARTA   // (::fiCIS)->nKARTA
      ::nKARTA := Val(Right(AllTrim( C_TypPOH->cTypDoklad),3))  // C_TypPOH->nKARTA // (::fiCIS)->nKARTA
      ::modiCARD()
      *
      ::dm:set( 'ZvZmenHDw->cTypPohybu', C_TypPoh->cTypPohybu )
*      ::dm:set( 'ZvZmenHDw->cTypDoklad', C_TypPoh->cTypDoklad )
*      ::dm:set( 'ZvZmenHDw->nDrPohyb'  , VAL(C_TypPoh->cTypPohybu) )
      *
      IF ::lNewREC
        ::dm:set( 'ZvZmenHDw->dDatPoriz' , DATE()  )
        ::dm:set( 'ZvZmenHDw->nDokladUsr', ::nDokladUsr )
        ::dm:set( 'ZvZmenHDw->nDoklad'   , ZVI_NewDokl() )
        ::dm:set( 'ZvZmenHDw->dDatZmZv'  , DATE()  )
        *
        IF !IsNULL( ::dm:has( 'ZvZmenHDw->nCenaSZV' ) )
          ::dm:set( 'ZvZmenHDw->nCenaSZV', IF( C_TypPoh->cTypPohybu = '22', ZvKarty->nCenaV1ZV,;
                                                                            ZvKarty->nCenaSZV ) )
        ENDIF
        IF ::nKARTA == 410
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , 0 )
        ENDIF
        IF ::nKARTA == 431   // Karta narozeni
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , ZvKarty->nCenaV1ZV )
        ENDIF
        *
        IF ::nKARTA == 450   //Ä
          ::dm:set( 'ZvZmenHDw->cNazPol2' , ZvKarty->cNazPol2 )
          ::dm:set( 'ZvZmenHDw->nCenaSZV' , ZvKarty->nCenaV2ZV )
          ::cNazVykon := cNazPol2->cNazev
*          IsEditGET( {'ZvZmenHDw->nCenacZV'}, ::drgDialog, .F.)
        ENDIF
        IF ::nKARTA == 600
          ::dm:set( 'ZvZmenHDw->nZvirKat_N' , ZvKarty->nZvirKat )
          ::dm:set( 'ZvZmenHDw->cNazPol2_N' , ZvKarty->cNazPol2 )
        ENDIF
        IF ::nKARTA == 610 .or. ::nKARTA == 620
          ::dm:set( 'ZvZmenHDw->nZvirKat_N' , ZvKarty->nZvirKatPr )
          ::dm:set( 'ZvZmenHDw->cNazPol2_N' , ZvKarty->cNazPol2Pr )
        ENDIF

      ENDIF
    ENDIF
    * Cena celkem - needitovatelná
    IF nPos := ASCAN( { 450,500,510,511}, ::nKarta ) > 0
      IsEditGET( {'ZvZmenHDw->nCenacZV'}, ::drgDialog, .F.)
    ENDIF
    *
    ::dm:refresh()
  ENDIF
  C_TypPoh->( mh_ClrFilter())

RETURN lOK

* Zavolá výbìr druhu pohybu
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:Firmy_SEL( oDlg)
  LOCAL oDialog, nExit, nPohyb, lRetVal
  LOCAL Value := ::dm:get( 'ZvZmenHDw->nCisFirmy')
  LOCAL lOK   := ( value <> 0) .and. FIRMY->( dbSEEK( Value,, 'FIRMY1'))

  IF IsObject( oDlg) .or. ! lOK
    DRGDIALOG FORM   'FIR_FIRMY_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'ZvZmenHDw->nCisFirmy' , Firmy->nCisFirmy  )
    ::cNazFirmy := Firmy->cNazev
    /* ZATÍM REMnem
    IF ZvKarty->cTypEvid = 'I'
      nPohyb := ::dm:get( 'ZvZmenHDw->nDrPohyb')
      IF !( ::nKARTA = 511 .AND. nPohyb = 72 )
        IF !( lRetVAL := ( Firmy->nCisREG <> 0))
          drgMsgBox(drgNLS:msg( 'Firma nemá pøidìleno registraèní èíslo ...'))
        ENDIF
      ENDIF
    ENDIF
    */
    ::dm:refresh()
  ENDIF
RETURN lOK

* Likvidace dokladu
********************************************************************************
METHOD ZVI_zsbPOHYBY_crd:LikvDokl( oDlg)
/*
  LOCAL  oDialog, nExit
  Local  nREC := (::fiZMAJUw)->( RecNO())
  Local  Filter := Format("nDoklad = %%", { (::fiZMAJUw)->nDoklad })

  (::fiZMAJU)->( dbSetFILTER( COMPILE( filter)))
  *
  oDialog := drgDialog():new('HIM_LikvDOK_SCR',self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  * Obnoví nastavení souboru
  (::fiZMAJU)->( dbClearFILTER(), dbGoTO( nREC))
  ::itemMarked()
  */
RETURN self

*
*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:modiCARD()
  Local  membCRD := {}, varsCRD := drgArray():new()
  Local  oVar, x

  For x := 1 TO Len( ::membORG)
    oVar := ::membORG[x]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
        If oVAR:Groups <> '' .and. oVAR:Groups <>'clrINFO'.and. oVAR:Groups <>'clrHEAD'
          oVAR:IsEDIT := .F.
          oVAR:oXbp:Hide()
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:hide()
          EndIf
        EndIf
      EndIf
    Endif
  Next
*
  For x := 1 TO Len( ::membORG)
    oVar := ::membORG[x]
    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        IF  EMPTY(  oVAR:Groups) .OR. ALLTRIM( str(::nKARTA)) $ oVAR:Groups
          IF oVAR:ClassName() $ 'drgGet,drgComboBox'
            oVAR:IsEDIT := .t.
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
            If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
              oVar:pushGet:oxbp:show()
            EndIf
          ELSE
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ENDIF
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:show()
          EndIf
        ELSEIf ! EMPTY( oVAR:Groups)
          If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
            oVar:pushGet:oxbp:hide()
          EndIf
        EndIf
      EndIf
    ELSE
      AADD( membCRD, oVar)
    ENDIF
  Next
  *
  For x := 1 To LEN( ::varsORG:values)
    IF ! IsNIL( ::varsORG:values[x, 2] )
      oVAR := ::varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. ( ALLTRIM( str(::nKARTA)) $ oVar:Groups)
          varsCRD:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ENDIF
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( membCRD)
    IF membCRD[x]:ClassName() = 'drgTabPage'
      membCRD[x]:onFormIndex := x
    ENDIF
  NEXT
  *
  ::df:aMembers := membCRD
  ::dm:vars     := varsCRD
  *
  IsEditGET( {'ZvZmenHDw->cNazPol1'  ,;
              'ZvZmenHDw->cNazPol4'  ,;
              'ZvZmenHDw->nZvirKat'  }, ::drgDialog, ::parentForm = 'Zvi_zsbPohyby_scr')

  IsEditGET( {'ZvZmenHDw->nDoklad'   }, ::drgDialog, .F.)
  *
  IsEditGET( {'ZvZmenHDw->nCenaCZV'  }, ::drgDialog,;
               !( AllTrim(Str(::nKarta)) $ '420,430,431,440,450,500,510,511,600,610,620') )

RETURN self


*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:ctrlDoklad( nDoklad)
  Local lOK := YES

  drgDBMS:open( 'ZvZmenHD',,,,, 'ZvZmenHD_a')
  IF( lOK := ZvZmenHD_a->( dbSeek( StrZero( nDoklad, 10),, 'ZVZMENHD03')))
    drgMsgBox(drgNLS:msg( 'Duplicitní èíslo dokladu ...'))
  ENDIF
  lOK := !lOK
  ZvZmenHD_a->( dbCloseArea())
RETURN lOK

* Kontrola na správné vyplnìní inv.èísel dle poètu kusù.
*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:ctrlInvCis()
  Local lOK := YES, nKs
  Local cText := 'Chybnì vyplnìna inventární èísla !'
  Local n := ASCAN( { 410, 420, 430, 431, 500, 510, 511, 600, 610, 620 },;
                    {|X| X == ::nKARTA } )
  Local lInvCis := ( Upper( ZvKarty->cTypEvid) == 'I' .and. n <> 0 ) .or. ;
                     ::nKARTA == 610
  IF lInvCis
    * V edit. kartách 440, 450 a 512 nefiguruje položka kusy, a proto se u nich
    * neprovádí kontrola na správné vyplnìní inv.èísel dle poètu kusù.
    nKs := ::dm:get( 'ZvZmenHDw->nKusyZV')
    If nKs == 0
       lOK := NO
       cText := 'Nebyl zadán poèet kusù !'
    ElseIf ZvZmenITw->(LastRec()) = 0
      lOK := NO
      cText := 'Nebyla vyplnìna inventární èísla !'
    ElseIf nKs = ZvZmenITw->(LastRec())
       ZvZmenITw->( dbGoTOP(),;
                    dbEval( {|| lOK := IF( ZvZmenITw->nInvCis > 0, lOK, NO)}) )
    Else
      lOK := NO
    Endif
  ENDIF
  If !lOK
    drgMsgBox(drgNLS:msg( cText + ' ...'))
  Endif
RETURN lOK

/*
STATIC FUNC CTRLinvcis( G)
  Local lOK := YES, nKs
//  Local lKartaOK := ( nKARTA <> 440) .AND. ( nKARTA <> 450) .AND.;
//                    ( nKARTA <> 512)
  Local cText := 'ChybnØ vyplnØna invent rn¡ Ÿ¡sla !'

//  IF ( UPPER( ZvKarty->cTypEvid) == 'I' .and. lKartaOK ) .or. ;
//     ( UPPER( ZvKarty->cTypEvid) == 'S' .and. nKARTA == 610 )
  IF lInvCis
    //Ä V edit. kart ch 440, 450 a 512 nefiguruje polo§ka kusy, a proto se u nich
    //  neprov d¡ kontrola na spr vn‚ vyplnØn¡ inv.Ÿ¡sel dle poŸtu kus….
    nKs := ABS( G[ KUSY]:VarGet() )
    If nKs == 0             ; lOK := NO
                              cText := 'Nebyl zad n poŸet kus… !'
    ElseIf Empty( aA)       ; lOK := NO
                              cText := 'Nebyla vyplnØna invent rn¡ Ÿ¡sla !'
    ElseIf nKs == Len( aA)
      AEval( aA, {|X| lOK := If( VAL( SUBSTR( X, 4, 10)) > 0, lOK, NO)  })
    Else                    ; lOK := NO
    Endif
  ENDIF
  If !lOK  ; Box_Alert( cEM, cText, acWAIT,, 13 )
  Endif
RETURN lOK
*/

*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:CmpCenaCELK()
  Local nVal, nRec

  IF ::nKARTA = 600 .or. ::nKARTA = 610 .or. ::nKARTA = 620
    nRec := KategZvi->( RecNo())
    KategZvi->( dbSeek( ZvKarty->nZvirKat,, 'KATEGZVI_1'))
    nVal := If( KategZvi->nTypVypCel = 1, ::dm:get( 'ZvZmenHDw->nMnozsZV'),;
                                          ::dm:get( 'ZvZmenHDw->nKusyZV' ))
    KategZvi->( dbGoTo( nRec))
  ELSE
    nVal := If( KategZvi->nTypVypCel = 1, ::dm:get( 'ZvZmenHDw->nMnozsZV'),;
                                          ::dm:get( 'ZvZmenHDw->nKusyZV' ))
  ENDIF
  ::dm:set( 'ZvZmenHDw->nCenacZV', ::dm:get( 'ZvZmenHDw->nCenasZV') * nVal )
RETURN Nil

* Pøepoèet Ceny/MJ u kategorie se vzrùst.pøírùstkem
*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:CmpVzrustPR()
  Local nKD, nCenacZV, nCenaSZV
  Local dDatZmZv := ::dm:get( 'ZvZmenHDw->dDatZmZV')

  IF ::lVzrust  // KatVZRUST()
    nKD      := ( mh_LastDayOM( dDatZmZv) - Day( dDatZmZv) + 1 )
    nCenaCZV := ZvKarty->nCenav2ZV * nKD * ZvKarty->nKusyZV
    nCenaSZV := Round( ( ZvKarty->nCenaCZV - nCenaCZV) / ZvKarty->nKusyZV, 3 )
    ::dm:set( 'ZvZmenHDw->nCenaSZV', nCenaSZV )
  ENDIF
RETURN Nil

/*
//ÄÄÄ< PýepoŸet Ceny/MJ u kategorie se vzr…stovìm pý¡r…stkem >ÄÄÄ//
STATIC FUNC CmpVzrustPR( G)
  Local nKD, nCenacZV, nCenaSZV
  IF KatVZRUST()
     nKD := ( LastDayOM( G[ DATZME]:VarGet()) - DAY( G[ DATZME]:VarGet()) + 1 ) // G[ KUSY]:VarGet()
     nCenaCZV := ZvKarty->nCenav2ZV * nKD * ZvKarty->nKusyZV  // 10.3.2000
     nCenaSZV := ROUND( ( ZvKarty->nCenaCZV - nCenaCZV) / ZvKarty->nKusyZV, 3 )
     G[ CENAMJ]:VarPUT( nCenaSZV)
     G[ CENAMJ]:Display()
  ENDIF
RETURN Nil
*/



*
*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:AllOK()
  Local lOK := .T.
  /*
  Local lOk := .F.
  Local cObd := If( Empty( ZmajU->cObdobi), cObdobi, ZmajU->cObdobi )

  DEFAULT  lNewDokl To NO
  If lNewDokl             //Ä Novì doklad
    If UcetSysObd( cObd)     // zadan‚ obdob¡ ji§ existuje v UcetSys
      lOk := .T.
    Endif
  Else                    //Ä Oprava a ruçen¡ dokladu
    If UcetSysObd( cObd)     // zadan‚ obdob¡ ji§ existuje v UcetSys
      If !IsUzv()            // doklad neproçel £Ÿetn¡ uzv. ( exportem)
        If !UctoUZV( cObd)
          lOk := .T.
        Endif
      EndIf
    Endif
  EndIf
  */
RETURN lOK

*
*HIDDEN*************************************************************************
METHOD ZVI_zsbPOHYBY_crd:ShowActions( isDisabled)
  Local  x

  FOR x := 1 TO LEN( ::abMembers)
    IF ::abMembers[x]:event $ 'EVID_INDIVID'
      IF ::abMembers[x]:event = 'EVID_INDIVID'
        IF( isDisabled, ::abMembers[x]:oXbp:disable(), ::abMembers[x]:oXbp:enable() )

      ENDIF
      ::abMembers[x]:oXbp:setColorFG( If( isDisabled, GraMakeRGBColor({128,128,128}),;
                                                      GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
RETURN NIL