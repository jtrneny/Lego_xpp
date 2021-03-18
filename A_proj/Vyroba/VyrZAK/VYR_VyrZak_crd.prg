/*==============================================================================
  VYR_VyrZak_CRD.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_SetCisPARAM()    SetCisPARAM()      VZ.Prg

==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "DRGres.Ch'
#include "..\VYROBA\VYR_Vyroba.ch"

#define  tab_ZAKLADNI     1
#define  tab_DODACI       2
#define  tab_DALSI        3
#define  tab_KALKULACE    4
#define  tab_PARAMETRY    5
#define  tab_POPIS        6

STATIC   nMnPotVyr

*****************************************************************
*
*****************************************************************
CLASS VYR_VyrZak_CRD FROM drgUsrClass
EXPORTED:
  VAR     lOpravy, cPicturZak

  METHOD  Init, Destroy
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  PostValidate
  METHOD  OnSave
  METHOD  VYR_VYRPOL_SEL, VYR_Firmy_sel, VYR_Osoby_sel

  METHOD  Opravy_Emise
  METHOD  ObjToVyrZAK
  METHOD  PARAM_inZak    // pøehled zakázek s daným parametrem
  METHOD  ZAK_Polozky    // pøehled položek zakázky  VYR_VYRZAKIT_SCR

HIDDEN:
  VAR     dc, dm, msg, isF4
  VAR     lNewREC,lNewKALKUL, lNewPARAM, tabNUM
  VAR     lCopyREC, cVyrPol_org
  var     len_cnazPol3, obtn_zak_Polozky
  var     lgenKusZak

  var     omle_popisZak, omle_popisZak2

  METHOD  SetCisZAKAZ
  METHOD  CondOfSTAV, RefreshBrow, Valid_NS
  METHOD  Kalkul_CRD

ENDCLASS

*****************************************************************
*
*****************************************************************
METHOD VYR_VyrZak_CRD:init(parent)
  Local  aNs
  local  cargo_usr := if( ismemberVar( parent, 'cargo_usr'), isnull( parent:cargo_usr, ''), '' )
  local  ccisZakaz, cfirst_Day, clast_Day, cflt_vyrZak, ncnt

  ::drgUsrClass:init(parent)
  ::lCopyREC   := ( parent:cargo = drgEVENT_APPEND2)
  ::lNewREC    := ( parent:cargo = drgEVENT_APPEND)
  ::lNewKALKUL := .F.
  ::lNewPARAM  := .F.
  ::tabNUM     := tab_ZAKLADNI
  *
  ::cPicturZak := AllTrim( SysCONFIG( 'Vyroba:cPicturZak'))
  ::lgenKusZak := SysConfig('Vyroba:lGenKusZak')
  *
  *
  ** bude se mìnit cnazPol3 z C8 -> C36
  odesc := drgDBMS:getFieldDesc('vyrZak', 'cnazPol3')
  ::len_cnazPol3 := odesc:len

  aNs := asize( listAsArray( allTrim( SysCONFIG( 'Vyroba:cNStoVZak'))), 6 )
  aeval( aNs, {|x,n| aNs[n] := isNull(x,'') })

  drgDBMS:open('VyrPol'   )
  drgDBMS:open('cNazPol2' )
  drgDBMS:open('C_VniUct' )
  drgDBMS:open('C_StreOd' )
  drgDBMS:open('ListIT'   )
  drgDBMS:open('Osoby'    )
  drgDBMS:open('VyrPOL' ,,,,, 'VyrPOLa'  )

  drgDBMS:open('vyrZak'  )
  drgDBMS:open('vyrZakIT')

  drgDBMS:open('VYRPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRZAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF ::lNewREC
    VYRZAKw->(dbAppend())
    VYRZAKw->cCisZakaz  :=  ::SetCisZakaz()
    VYRZAKw->nVarCis    := 1
    VYRZAKw->nMnozPlano := 1
    VYRZAKw->dZapis     := DATE()
    VYRZAKw->cNazPol1   := aNS[ 1]   //  z CFG
    VYRZAKw->cNazPol2   := aNS[ 2]
    VYRZAKw->cNazPol3   := aNS[ 3]
    VYRZAKw->cNazPol4   := aNS[ 4]
    VYRZAKw->cNazPol5   := aNS[ 5]
    VYRZAKw->cNazPol6   := aNS[ 6]
    VYRZAKw->cPriorZaka := '1 '    // normální
    VYRZAKw->cStavZakaz := '1 '    // nová

    if ( lower(cargo_usr) = 'from_kustree')
      ::lgenKusZak := .t.

      ccisZakaz   := allTrim(kusTree->cvyrPol) +'-' +mh_OBD_MM_YY(date())
      cfirst_Day  := dtoc( BoM( date() ))
      clast_Day   := dtoc( EoM( date() ))
      cflt_vyrZak := format( "ccisZakaz = '%%' and ( dzapis >= '%%' and dzapis <= '%%')", { ccisZakaz, cfirst_Day, clast_Day } )

      drgDBMS:open('vyrZak' ,,,,, 'vyrZakA'  )
      vyrZakA->( ordSetFocus('VYRZAK1')    , ;
                 ads_setAof(cflt_vyrZak)   , ;
                 ncnt := ads_getKeyCount(1), ;
                 dbcloseArea()               )

      vyrZakW->ccisZakaz  := allTrim(kusTree->cvyrPol) +'-' +mh_OBD_MM_YY(date()) +'.' +allTrim( str(ncnt +1))
      vyrZakW->cnazevzak1 := kusTree->cnazev
      vyrZakW->ctypZak    := vyrZak->ctypZak
      vyrzakW->cvyrPol    := kusTree->cvyrPol

      vyrPol->( dbSEEK( upper(kusTree->cvyrPol),, 'VYRPOL4'))
      mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
      VYRPOLw->cCisZakaz  := vyrZakW->ccisZakaz

      vyrZakW->ctypZak    := 'I'

      vyrZakW->nMnozPlano := KusTree->nmnozZadan
      vyrZakW->czkratJedn := 'ks'

      vyrZakW->nmnozZadan := KusTree->nmnozZadan
      vyrZakW->nautoPlan  := 1

      vyrZakW->dodvedZaka := date() +1
      vyrZakW->dmozODVzak := date() +1
    endif

  ELSEIF ::lCopyREC ; SetCopyREC()
  ELSE              ; mh_COPYFLD('VYRZAK', 'VYRZAKw', .T.)
  ENDIF
  ::lNewREC := ( ::lNewREC .OR. ::lCopyREC)
  ::lOpravy := ( SysCONFIG( 'Vyroba:cVyrZakBut') = 2)  // .t.  Nadstavba Opravy,emise
  C_StreOD->( mh_SetScope( StrZERO( VYRZAKw->nCisFirmy, 5 )))
  *
  IF !::lNewREC
    ::cVyrPOL_org := VYRZAKw->cVyrPol
  ENDIF
RETURN self

*
********************************************************************************
METHOD VYR_VyrZAK_CRD:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN
*
********************************************************************************
METHOD VYR_VyrZak_CRD:drgDialogStart(drgDialog)
 LOCAL  members := ::drgDialog:oActionBar:Members, x
 Local  aCFG    := ListAsArray( SysCONFIG( 'Vyroba:cKarZakaz'))
 LOCAL  isEdit  := ::CondOfStav( VyrZAKw->cStavZakaz, 7 )
 LOCAL  nZakIT  := VYR_isZakIT(), isINFO

 aCfg   := AEVAL( aCFG, {|X,i| aCFG[i] := (X = '1')} )
 ::dc   := drgDialog:dialogCtrl
 ::dm   := drgDialog:dataManager
 ::msg  := drgDialog:parent:oMessageBar
 ::isF4 := .F.
 *
 ::omle_popisZak  := ::dm:has('vyrZakW->mpopisZak' , .f. )
 ::omle_popisZak2 := ::dm:has('vyrZakW->mpopisZak2', .f. )


 IF ::lNewRec
   * Nastavíme vzor zakázky - pro èíselný vzor to znamená, že znaková zakázka
   * se chová jako numerická ( lze editovat pouze èís.údaje)
   ::dm:has('VyrZAKw->cCisZakaz'):odrg:oxbp:picture := ::cPicturZAK
 ENDIF
 *
 IsEditGET( 'VyrZAKw->cCisZakaz' , drgDialog, ::lNewREC)
 IsEditGET( 'VyrZAKw->cNazPOL1'  , drgDialog, aCFG[ 1] )
 IsEditGET( 'VyrZAKw->cNazPOL3'  , drgDialog, aCFG[ 3] )
 IsEditGET( 'VyrZAKw->cNazPOL4'  , drgDialog, aCFG[ 4] )
 IsEditGET( 'VyrZAKw->cTypZAK'   , drgDialog, VyrZAKw->nMnozFAKT == 0 )
 IsEditGET( 'VyrZAKw->cNazPOL2'  , drgDialog, VyrZAKw->nMnozFAKT == 0 .and. aCFG[ 2] )

 * Pokud existují položky, nesmí jít opravit mn. na HLA. Lze jej ovlivòovat již jen pøes Pol.
 if .not. ::lnewRec
   IsEditGET( 'VyrZAKw->nMnozPlano', drgDialog, isEdit .and.;
                                                IF( VyrZAKw->nPolZAK = 2, nZakIT = DRG_ICON_SELECTF, nZakIT = 0 ))
 endif

 if ( ::lnewRec .and. vyrZakW->nautoPlan = 1 )
   isEditGet( {'vyrZakW->nMnozPlano', 'vyrZakW->czkratJedn' }, drgDialog, .f. )
 endif


 IsEditGET( {'VyrZAKw->nPlanPruZa'  ,;
              'VyrZAKw->dZapis'      ,;
             'VyrZAKw->dOdvedZaka'  ,;
             'VyrZAKw->dMozOdvZak'  ,;
             'VyrZAKw->cPriorZaka'} ,  drgDialog, isEdit )
 IsEditGET( {'VyrZAKw->cStavZakaz'  ,;
             'VyrZAKw->cNazFirmy'   ,;
             'VyrZAKw->cUlice'      ,;
             'VyrZAKw->cSidlo'      ,;
             'VyrZAKw->nIco'        ,;
             'VyrZAKw->cDIC'        },  drgDialog, .F. )
 *
 isINFO := ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
 IF( isINFO, drgDialog:SetReadOnly( .T.), NIL )
 *
 FOR x := 1 TO LEN( Members)
   IF members[x]:event = 'OPRAVY_EMISE'
     members[x]:oXbp:visible := ::lOpravy
     members[x]:oXbp:configure()
   ENDIF

   IF members[x]:event = 'SEPARATOR' .or. ;
      ( members[x]:event = 'ZAK_POLOZKY' .and. isINFO )
     members[x]:oXbp:visible := .F.
     members[x]:oXbp:configure()
   ENDIF

   if( members[x]:event = 'ZAK_POLOZKY', ::obtn_zak_Polozky := members[x], nil )
 NEXT
 *
 ZAKAPAR->( mh_SetScope( UPPER( VYRZAKw->cCisZakaz )))
 *
 ::tabSelect( , ::tabNUM)

RETURN self

*
********************************************************************************
METHOD VYR_VyrZak_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK, nCisParam, oDialog, nExit


  if nevent = drgEVENT_ACTION
    if isNumber(mp1)
      if mp1 = drgEVENT_SAVE
        ::omle_popisZak:set( ::omle_popisZak:odrg:oxbp:getData() )
        ::omle_popisZak2:set( ::omle_popisZak2:odrg:oxbp:getData() )
      endif
    endif
  endif


  DO CASE
  CASE  nEvent = drgEVENT_EDIT
    IF ( ::tabNUM = tab_KALKULACE, ::Kalkul_CRD( nEvent), NIL )
    IF  ::tabNUM = tab_PARAMETRY
       ::lNewPARAM := .F.
       ::drgDialog:oForm:setNextFocus( 'ZAKAPAR->nCisAtribZ',, .t. )
    ENDIF

  CASE  nEvent = drgEVENT_APPEND
    IF( ::lNewKALKUL := ( ::tabNUM = tab_KALKULACE), ::Kalkul_CRD( nEvent), NIL )
    IF ::lNewPARAM := ( ::tabNUM = tab_PARAMETRY)
      nCisPARAM := VYR_SetCisPARAM()
      ZAKAPAR->( dbGoTO(-1) )
      ::dm:refresh()
      ::drgDialog:oForm:setNextFocus( 'ZAKAPAR->nCisAtribZ',, .t. )
      ::dm:set('ZAKAPAR->nCisAtribZ', nCisPARAM )
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_DELETE
    IF ::tabNUM = tab_PARAMETRY
      IF drgIsYESNO(drgNLS:msg('Zrušit vybraný parametr < & >  ?', ZAKAPAR->cAtrib ) )
        If ZAKAPAR->( DbRLock())
          ZAKAPAR->( DbDelete(), DbUnlock() )
          ::drgDialog:dialogCtrl:oaBrowse:refresh()
          ::dm:refresh()
        ENDIF
      ENDIF
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_SAVE
    IF ::tabNUM = tab_KALKULACE .or. ::tabNUM = tab_PARAMETRY
      ::OnSave( .F.,  ::lNewREC )
    ELSE
      ::OnSave( .F.,  ::lNewREC )
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

*      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    ENDIF
    RETURN .T.

  /*
*    ::DoSave( .F., ::lNewREC )
    IF ( ::tabNUM = 1 .or. ::tabNUM = 2 .or. ::tabNUM = 5)
*      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      PostAppEvent(xbeP_Close, nEvent ,,oXbp)
    ENDIF
    RETURN .T.
  */


  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      IF ( ::tabNUM = tab_PARAMETRY)
        /*
        ZAKAPAR->( dbGoTOP() )
        ::drgDialog:dataManager:refresh()
        ::drgDialog:dialogCtrl:oaBrowse:refresh()
        */
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
      ELSE
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      ENDIF

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_VyrZak_CRD:tabSelect( tabPage, tabNumber)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *
  FOR x := 1 TO LEN( Members)
    IF Upper(members[x]:event) $ 'ZAK_COPYPRM,PARAM_INZAK'
      members[x]:oXbp:visible := ( tabNumber = tab_PARAMETRY)
      members[x]:oXbp:configure()
    ENDIF

  NEXT
  *
  IF tabNumber = tab_KALKULACE
    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
    KALKUL->( mh_SetScope( UPPER( VYRZAKw->cCisZakaz )))
    ::RefreshBrow( 'KALKUL')
  ELSEIF  tabNumber = tab_PARAMETRY
    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
    ZAKAPAR->( mh_SetScope( UPPER( VYRZAKw->cCisZakaz )))
    ::RefreshBrow( 'ZAKAPAR')

  ELSEIF  tabNumber = tab_DODACI .or. tabNumber = tab_DALSI .or. tabNumber = tab_POPIS
    ::dm:save()
*    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
  ENDIF
  ::tabNUM := tabNumber
RETURN .T.
*
********************************************************************************
METHOD VYR_VyrZak_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-'), cKey, cTag
  LOCAL  nREC, cStav
  LOCAL  nEvent := mp1 := mp2 := nil

   nEvent := LastAppEvent(@mp1,@mp2)

*  IF lValid
    DO CASE
    CASE cName = 'VYRZAKW->CCISZAKAZ'
      IF lOK := EMPTY(xVar)
         drgMsgBox(drgNLS:msg('Oznaèení výrobní zakázky: ... údaj musí být vyplnìn !'),, ::drgDialog:dialog)
      ELSEIF lValid
        VYRZAK->( AdsSetOrder( 1))
        IF lOK := VYRZAK->(dbSEEK( Upper( xVar)))
          drgMsgBox(drgNLS:msg('DUPLICITA -  Výrobní zakázka < & > s tímto oznaèením již existuje !',;
                                VYRZAK->cCisZakaz ), XBPMB_WARNING )
        ENDIF
      Endif
      lOK := !lOK

      IF lOK  // .AND. nVyrZakBut == STS_PRUNEROV
*        IF EMPTY( ::dm:get('VyrZAKw->cNazPol3'))
        ::dm:set('VyrZAKw->cNazPol3', LEFT( xVar, ::len_cnazPol3))
*        ENDIF
*         G[ NazPOL3]:VarPUT( LEFT( xVAL, LenNazPol3()  ))
      ENDIF

    CASE cName = 'VYRZAKW->CTYPZAK' .OR. cName = 'VYRZAKW->CNAZPOL2'
      If lValid
        cKEY := IF( cName = 'VYRZAKW->CTYPZAK', VyrZAKw->cNazPol2 + xVAR,;
                                                xVar + VyrZAKw->cTypZak )
        C_VniUCT->( dbSEEK( UPPER( cKEY)))
        VyrZAKw->cUcetVnitr := C_VniUCT->cUcetVnitr
        IF cName = 'VYRZAKW->CNAZPOL2'
           ListIT_NS2( ::dm)
        ENDIF
      EndIf

    CASE cName = 'VYRZAKW->CVYRPOL'
      IF !EMPTY( xVar) .and. lChanged
        lOK := ::VYR_VYRPOL_SEL()
      ENDIF

      /*
      IF lValid
        lOK := ControlDUE( oVar, .F.)
        IF ::isF4
          ::isF4 := .F.
        ELSE
          lOK := ::VYR_VYRPOL_SEL( self)
        ENDIF

      ENDIF
      */

      /*
      IF lValid  // lChanged
        lOK := ControlDUE( oVar, .F.)
        IF !EMPTY( xVar)
          lKeyFound := VYRPOL->(dbSEEK( Upper(::dm:get( 'VyrZAKw->cCisZakaz')) + Upper(xVar),, 1))
          lOK := ::VYR_VYRPOL_SEL( self, lKeyFound )
          xVar := IF( lOK, ::dm:get( 'VyrZAKw->cVyrPOL'), xVar )
        ENDIF
        IF lOK
          lOK := .F.
          IF ::lNewREC .OR. ( !::lNewREC .AND. ALLTRIM( VyrZAKw->cStavZAKAZ) $ '1234' )
*            cKEY := Upper( VyrZAKw->cCisZakaz) + Upper( xVar) + StrZero( VyrZAKw->nVarCis, 3 )
            cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + Upper( xVar) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
            IF ! VyrPol->( dbSeek( cKey,,1))
              cKey := EMPTY_ZAKAZ + Upper( xVar) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
              * Pokud existuje nezakázková VyrPOL, vytvoø z ní novou zakázkovou pol.
              IF VyrPol->( dbSeek( cKey,,1))
                mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
                VYRPOLw->cCisZakaz := ::dm:get( 'VyrZAKw->cCisZakaz') // VYRZAKw->cCisZakaz
              ENDIF
            ENDIF
          ELSEIF !::lNewREC .AND. ALLTRIM(  ::dm:get( VyrZAKw->cStavZAKAZ)) $ '5678U'
            drgMsgBox(drgNLS:msg('NELZE ZMÌNIT -  Výrobní zakázka < & > není v odpovídajícím stavu ( 1,2,3,4)... !',;
                                  VyrZAKw->cCisZakaz ), XBPMB_WARNING )
            lOK := YES
          ENDIF
        ENDIF

        IF ( lOK := !lOK )
          // pøednastaví stav zakázky
          cStav := IF( EMPTY(VyrPOLw->cCisZakaz), VyrPOL->cStav, VyrPOLw->cStav)
          ::dm:set( 'VyrZAKw->cStavZakaz', IF( Empty( cStav), '1 ',;
                                           IF( 'A' $ Upper( cStav), '4 ', '3 ' )))
          // vynuluje mn. plánované z objednávek
          ::dm:set( 'VyrZAKw->nMnozPlano', 1 )
        ENDIF
      ENDIF
      */
    CASE cName = 'VYRZAKW->NMNOZPLANO'
      If lValid // .and. AllTrim( G[ 3]:VarGet()) == 'O'   // z Objedn vky
         If ( xVar < 0 )
           drgMsgBox(drgNLS:msg('Hodnota musí být nezáporná !'),, ::drgDialog:dialog)
           lOK := FALSE
         ElseIf ( xVar < VyrZAKw->nMnozFakt )
           drgMsgBox(drgNLS:msg('Plánované množství < & > nesmí být menší, než již vyfakturované množství < & > !',;
                                 xVar, VyrZAKw->nMnozFakt  ),, ::drgDialog:dialog)
           lOK := FALSE
         Else
           nMnPotVyr := 0
           If Select( 'ObjZakW') <> 0
              SUM ObjZakW->nMnPotVyrZ TO nMnPotVyr
           Endif
           // nSuma := xVal + G[ 9]:VarGet() - G[ 8]:VarGet()
           lOK := ( nMnPotVyr <= xVar )
           If !lOK
             drgMsgBox(drgNLS:msg('Chyba pøi kontrolním výpoètu !;;' + ;
                                  'Suma z objednávek [ & ]  <=  Plánováno [ & ]',;
                                   nMnPotVyr, xVar ), XBPMB_WARNING )
             lOK := FALSE
           EndIf
         EndIf
      Endif

    CASE cName = 'VYRZAKW->NPLANPRUZA'
      If lValid  .and. ( xVar < 0 )
        drgMsgBox(drgNLS:msg('Hodnota musí být nezáporná !'),, ::drgDialog:dialog)
        lOK := FALSE
      EndIf

    case(cName = 'VYRZAKW->dodvedzaka')
*      if empty(xVar)
*        ::msg:writeMessage('Datum ovedení požadované je povinný údaj ...',DRG_MSG_WARNING)
*        lOK := .f.
*      else
        if empty(::dm:get('vyrzakw->dmozodvzak'))
          ::dm:set('vyrzakw->dmozodvzak',xVar)
          vyrzakw->nrokODV   := year(xVar)
          vyrzakw->nmesicODV := month(xVar)
          vyrzakw->ntydenODV := mh_weekOfYear(xVar)
        endif
*      endif

** DODACÍ údaje
    CASE cName = 'VYRZAKW->nCisFirmy' .or. cName = 'VYRZAKW->nCisFirDoa'     //
      IF ! EMPTY(xVar)
        lOK := ::VYR_Firmy_sel(, cName)
      ENDIF

    CASE cName = 'VYRZAKW->NCENAMJ'       // Cna za MJ
     IF lChanged
       ::dm:set( 'VYRZAKW->NCENACELK' , ::dm:get('VYRZAKw->NMNOZPLANO') * xVar)
       ::dm:set( 'VYRZAKW->NCENZAKCEL', ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100) )
       /*
       VyrZAKw->nCenaCELK  := ::dm:get('VYRZAKw->NMNOZPLANO') * xVar
       ::dm:has( 'VYRZAKW->NCENACELK'):refresh()
       VyrZAKw->nCenZakCEL := ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100)
       ::dm:has( 'VYRZAKW->NCENZAKCEL'):refresh()
       */
     ENDIF

    CASE cName = 'VYRZAKW->NCENACELK' .OR.;    // Celkem bez DPH
         cName = 'VYRZAKW->NKLICDPH'
      ::dm:set( 'VYRZAKW->NCENZAKCEL', ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100))
       /*
       VyrZAKw->nCenZakCEL := ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100)
       ::dm:has( 'VYRZAKW->NCENZAKCEL'):refresh()
       */
*    CASE cName = 'ZAKAPAR->NCISATRIBZ'

** DALŠÍ údaje
    CASE cName = 'VYRZAKw->cJmeOsZAL' .or. cName = 'VYRZAKw->cJmeOsODP'
      IF ! EMPTY(xVar)
        lOK := ::VYR_Osoby_sel(, cName)
      ENDIF

    CASE cName = 'ZAKAPAR->NCISATRIBZ'
      IF lChanged
        cKey := VyrZak->cCisZakaz + StrZero( xVar, 5)
        nREC := ZAKAPAR->( RecNO())
        IF ZakaPAR->( dbSEEK( Upper( cKey)))
          drgMsgBox(drgNLS:msg('DuplicitnÍ èíslo atributu !'),, ::drgDialog:dialog)
          lOK := .F.
        ENDIF
        ZakaPAR->( dbGoTo( nRec))
      ENDIF

    CASE cName = 'ZAKAPAR->nHodnAtrN'
      IF( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
**        PostAppEvent(xbeP_Close,drgEVENT_SAVE,,oXbp)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    ENDCASE
*  ENDIF


   if('VYRZAKW' $ cname .and. lok, oVAR:save(),nil)

   ::obtn_zak_Polozky:oxbp:disable()

   if .not. empty( vyrZakw->ccisZakaz)      .and. ;
                   vyrZakw->npolZak     = 2 .and. ;
                   vyrZakw->nmnozPlano <> 0 .and. ;
      .not. empty( vyrZakw->czkratJedn)

     ::obtn_zak_Polozky:oxbp:enable()
   endif
RETURN lOK

*
********************************************************************************
METHOD VYR_VyrZak_CRD:OnSave(isBefore, isAppend)
  Local  lOK, dOdvedHLP, cKey, oMoment
  Local  dc     := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager
  local  cTitle := 'Uložení výrobní zakázky ...'
  local  cInfo  := 'Promiòte prosím,'                           +CRLF +CRLF + ;
                   'opravdu požadujete uložit výrobní zakázku ' +CRLF +       ;
                   'a vygenerovat zakázkový kusovník ...'


  mpopisZak  := ::dm:get( 'vyrZakW->mpopisZak'  )
  mpopisZak2 := ::dm:get( 'vyrZakW->mpopisZak2' )


  IF ::drgDialog:dialogCtrl:isReadOnly
    RETURN .T.
  ENDIF

  if ::lgenKusZak
     nsel := confirmBox( ,cinfo      , ;
                          ctitle     , ;
                          XBPMB_YESNO, ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

     if nsel = XBPMB_RET_NO
       return .t.
     endif
  endif

  *
*  IF isBefore   // Pøed uložením
*  ELSE          // Po uložení
    IF     ::tabNUM = tab_KALKULACE
    ELSEIF ::tabNUM = tab_PARAMETRY
      IF ( lOK := if( ::lNewPARAM, AddREC('ZAKAPAR'), ReplREC('ZAKAPAR')) )
        ZAKAPAR->cCisZakaz  := VYRZAKw->cCisZakaz
        ZAKAPAR->nCisAtribZ := dm:get('ZAKAPAR->nCisAtribZ')
        ZAKAPAR->cAtrib     := dm:get('ZAKAPAR->cAtrib')   // PADL( ALLTRIM( dm:get('ZAKAPAR->cAtrib')), 20)
        ZAKAPAR->cHodnAtrC  := dm:get('ZAKAPAR->cHodnAtrC')
        ZAKAPAR->nHodnAtrN  := dm:get('ZAKAPAR->nHodnAtrN')
        ** mh_WRTzmena( 'ZAKAPAR', ::lNewPARAM)
        ZAKAPAR->( dbUnlock())
        dc:oaBrowse:refresh()
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        ::drgDialog:DataManager:refresh()
      ENDIF
    ELSE
      oMoment := SYS_MOMENT( '=== UKLÁDÁM DOKLAD ===' )


      ::drgDialog:DataManager:save()
      IF ( lOK := if( ::lNewREC .or. ::lCopyREC, AddREC('VyrZAK'), ReplREC('VyrZAK')) )

        vyrZakW->mpopisZak  := ::dm:get( 'vyrZakW->mpopisZak'  )
        vyrZakW->mpopisZak2 := ::dm:get( 'vyrZakW->mpopisZak2' )

        mh_COPYFLD( 'VYRZAKw', 'VYRZAK')
        dOdvedHLP := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        VyrZak->dZacatPrac := dOdvedHLP
  *        VyrZak->cCisPlan   := IF( EMPTY( dOdvedHLP), VyrZAK->cCisPLAN,;
  *                                  STRZERO( WEEK( dOdvedHLP), 2) + '/' + STR( YEAR( dOdvedHLP), 4) )
        VyrZak->cZkratMENY := IF( ::lNewRec, SysConfig( 'Finance:cZaklMena'), VyrZak->cZkratMenZ )
        VyrZak->cZkratMENY := IF( ::lNewRec, SysConfig( 'Finance:cZaklMena'), VyrZak->cZkratMeny )
        VyrZAK->lPolZAK    := C_TypZAK->lPolZAK
        VyrZAK->nPolZAK    := C_TypZAK->nPolZAK
        VyrZAK->( dbUnlock())

        * Pokud existuje nezakázková vyr.položka založí z ní zakázkovou
        cKEY := Upper( VyrZAK->cCisZakaz) + Upper( VyrZAK->cVyrPol) + StrZero( VyrZAK->nVarCis, 3 )
        IF ! VyrPol->( dbSeek( cKey,,'VYRPOL1'))
          IF !EMPTY(VyrPOLw->cCisZakaz)
            IF AddREC('VyrPOL')
              mh_COPYFLD( 'VYRPOLw', 'VYRPOL')
              VyrPOL->nStavKalk := -1
              VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
              mh_WRTzmena( 'VYRPOL', .T.)
              VyrPOL->( dbUnlock())
              *
              IF ::lgenKusZak
                ::msg:WriteMessage('Probíhá generování zakázkového kusovníku ...', DRG_MSG_INFO)
                *
                ** vyr_lib.VYR_GenKusovZAK
                *
                **   cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol)
                **   if Kusov->( dbSeek(cKey)) )    - ok existuje zakázkový kusovník
                **   else
                **     cKey := EMPTY_ZAKAZ + VyrZak->cVyrPol
                **     if Kusov->( dbSeek(cKey)) )  - ok existuje neZakázkový kusovník, udìláme zakáznový
                **       VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES )
                **   else
                **   ERR neexistuje existuje zakázkový, ano neZakázkový kusovník
                *
                VYR_GenKusovZAK( .F.)
                ::msg:WriteMessage( ,0)
              ENDIF
              *
            ENDIF
          ENDIF
        ENDIF
        * Vždy vygeneruje VyrZakIT pro "nepoložkovou zakázku"
        IF VyrZAK->nPolZAK <> 2
          *
          IF ::lNewRec
            lOK := .T.
          ELSEIF lOK := VyrZakIT->( dbSEEK( Upper( VyrZak->cCisZakaz),,'ZAKIT_1'))
             lOK := VyrZAKIT->( dbRLock())
          ENDIF

          IF lOK
            mh_COPYFLD( 'VYRZAK', 'VYRZAKIT', ::lNewREC )
            VyrZAKIT->nOrdItem   := 0
            VyrZAKIT->cCisZakazI :=  ALLTRIM(VyrZAKIT->cCisZakaz)  //+'/0'
            VyrZAKIT->( dbRUnlock())
          ENDIF
        ENDIF

        /* Pokud je vyplnìné cVyrPol doplní ho i do VyrZakIT  ORIG
        IF !EMPTY( VyrZak->cVyrPol) .and. !::lNewRec
          VyrZakIT->( AdsSetOrder( 1),;
                      mh_SetScope( Upper( VyrZak->cCisZakaz)) )
          DO WHILE !VyrZakIT->( Eof())
            IF EMPTY( VyrZakIT->cVyrPol)
              IF VyrZakIT->( dbRLock())
                VyrZakIT->cVyrPol := VyrZak->cVyrPol
                VyrZakIT->( dbRUnLock())
              ENDIF
            ENDIF
            VyrZakIT->( dbSkip())
          ENDDO
          VyrZakIT->( mh_ClrScope())
        ENDIF
        */
        * NEW
        * Pokud je vyplnìné cVyrPol doplní ho i do VyrZakIT
        * Pokud není vyplnìné cVyrPol vyprázdní ho i ve VyrZakIT
        IF !::lNewRec .and.  (::cVyrPol_org <> VyrZak->cVyrPol)
          VyrZakIT->( AdsSetOrder( 1),;
                      mh_SetScope( Upper( VyrZak->cCisZakaz)) )
          DO WHILE !VyrZakIT->( Eof())
            IF EMPTY( VyrZakIT->cVyrPol)
              IF VyrZakIT->( dbRLock())
                VyrZakIT->cVyrPol := VyrZak->cVyrPol
                /*
                IF !EMPTY( ::cVyrPol_org) .and. EMPTY( VyrZak->cVyrPol)
                  cKey := Upper( VyrZAK->cCisZakaz) + Upper( ::cVyrPol_org) + StrZero( VyrZAK->nVarCis, 3 )
                  IF VyrPOL->( dbSEEK( cKey,, 1)
                     VyrPol_onDelete()

                  ENDIF
                ENDIF
                */
                VyrZakIT->( dbRUnLock())
              ENDIF
            ENDIF
            VyrZakIT->( dbSkip())
          ENDDO
          VyrZakIT->( mh_ClrScope())
        ENDIF
        *
        ::Valid_NS()
        *
        ::lNewREC := IF( ::lNewREC, .f., ::lNewREC )

        if( isObject(oMoment), oMoment:destroy(), nil )

      ELSE
        drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
      ENDIF
    ENDIF
*  ENDIF

RETURN .t.

* Výbìr výrobní zakázky do karty výrobní zakázky
********************************************************************************
METHOD VYR_VyrZak_CRD:VYR_VYRPOL_SEL( oDlg)
  LOCAL oDialog, nExit, cStav
  LOCAL Value := Upper( ::dm:get('VyrZAKw->cVyrPOL'))
  Local cKey := Upper(::dm:get( 'VyrZAKw->cCisZakaz')) + Value + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
  LOCAL lOK := ( !Empty(value) .and. VYRPOL->( dbSEEK( cKey,, 'VYRPOL1')) )

  IF !lOK
    cKey := EMPTY_ZAKAZ + Value + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
    lOK := ( !Empty(value) .and. VYRPOL->( dbSEEK( cKey,, 'VYRPOL1')) )
  ENDIF
  *
  IF IsObject( oDlg) .or. ! lOk
    ::isF4 := IsObject( oDlg)
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
*    ::drgDialog:oForm:setNextFocus( 'VYRZAKw->cVyrPol',, .t. )
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'VYRZAKw->cVyrPOL', VYRPOL->cVyrPOL )
    ::dm:set( 'VYRZAKw->nVarCis', VYRPOL->nVarCis )
    ::dm:refresh()

    IF lOK
      lOK := .F.
      IF ::lNewREC .OR. ( !::lNewREC .AND. ALLTRIM( VyrZAKw->cStavZAKAZ) $ '1234' )
//        cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + Upper( Value) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
        cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + Upper( ::dm:get( 'VyrZAKw->cVyrPol')) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
        IF ! VyrPol->( dbSeek( cKey,,'VYRPOL1'))
//          cKey := EMPTY_ZAKAZ + Upper( Value) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
          cKey := EMPTY_ZAKAZ + Upper( ::dm:get( 'VyrZAKw->cVyrPol')) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
          * Pokud existuje nezakázková VyrPOL, vytvoø z ní novou zakázkovou pol.
          IF VyrPol->( dbSeek( cKey,,'VYRPOL1'))
            mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
            VYRPOLw->cCisZakaz := ::dm:get( 'VyrZAKw->cCisZakaz')
          ELSE
            cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + Upper( ::dm:get( 'VyrZAKw->cVyrPol')) + '001'
            * Pokud existuje zakázková VyrPOL ve variantì '001', vytvoø z ní novou zakázkovou pol. = KOVAR
            IF VyrPol->( dbSeek( cKey,,'VYRPOL1'))
              mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
              VYRPOLw->cCisZakaz := ::dm:get( 'VyrZAKw->cCisZakaz')
            ENDIF
          ENDIF
        ENDIF
        *
      ELSEIF !::lNewREC .AND. ALLTRIM(  ::dm:get( 'VyrZAKw->cStavZAKAZ')) $ '5678U'
        drgMsgBox(drgNLS:msg('NELZE ZMÌNIT -  Výrobní zakázka < & > není v odpovídajícím stavu ( 1,2,3,4)... !',;
                              VyrZAKw->cCisZakaz ), XBPMB_WARNING )
        lOK := YES
      ENDIF
    ENDIF
   *
    IF ( lOK := !lOK )
      // pøednastaví stav zakázky
      cStav := IF( EMPTY(VyrPOLw->cCisZakaz), VyrPOL->cStav, VyrPOLw->cStav)
      ::dm:set( 'VyrZAKw->cStavZakaz', IF( Empty( cStav), '1 ',;
                                       IF( 'A' $ Upper( cStav), '4 ', '3 ' )))
      // vynuluje mn. plánované z objednávek
      ::dm:set( 'VyrZAKw->nMnozPlano', 1 )
    ENDIF

  ENDIF
RETURN lOK

* Výbìr Firmy objednavatele / Dodací adresa
********************************************************************************
METHOD VYR_VyrZak_CRD:VYR_FIRMY_SEL( oDlg, cName)
  LOCAL oDialog, nExit, cKey
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  LOCAL Value := ::dm:get( cItem)
  LOCAL lOK := ( !Empty(value) .and. FIRMY->( dbSEEK( Value,, 'FIRMY1')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( cItem, Firmy->nCisFirmy )
    IF cItem = 'VyrZAKw->nCisFirmy'
      ::dm:set( 'VYRZAKw->cNazFirmy', Firmy->cNazev )
      ::dm:set( 'VYRZAKw->cUlice'   , Firmy->cUlice )
      ::dm:set( 'VYRZAKw->cSidlo'   , Firmy->cSidlo )
      ::dm:set( 'VYRZAKw->nIco'     , Firmy->nIco   )
      ::dm:set( 'VYRZAKw->cDic'     , Firmy->cDic   )

      vyrZakW->cpsc := firmy->cpsc
    ELSE
      ::dm:set( 'VYRZAKw->cNazevDoa', Firmy->cNazev )
      ::dm:set( 'VYRZAKw->cUliceDoa', Firmy->cUlice )
      ::dm:set( 'VYRZAKw->cSidloDoa', Firmy->cSidlo )
    ENDIF
    ::dm:refresh()
  ENDIF
RETURN lOK


* Výbìr Osoby do položek: Založila osoba, Zodpovídá osoba
********************************************************************************
METHOD VYR_VyrZak_CRD:VYR_OSOBY_SEL( oDlg, cName)
  LOCAL oDialog, nExit, cKey
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  LOCAL Value := Upper(::dm:get( cItem))
  LOCAL lOK := ( !Empty(value) .and. OSOBY->( dbSEEK( Value,, 'OSOBY02')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'OSB_OSOBY_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                   EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. !lOK )
    lOK := .T.
    ::dm:set( cItem, AllTrim(Osoby->cOsoba ) )
    /*
    IF cItem = 'VyrZAKw->nCisOsZAL'
      ::dm:set( 'VYRZAKw->cJmeOsZal', AllTrim(Osoby->cOsoba ))
    ELSE
      ::dm:set( 'VYRZAKw->cJmeOsOdp', AllTrim(Osoby->cOsoba ))
    ENDIF
    */
    ::dm:refresh()
  ENDIF
RETURN lOK


*
********************************************************************************
METHOD VYR_VyrZak_CRD:Opravy_Emise
  LOCAL oDialog
*  drgMsgBox(drgNLS:msg('Opravy a emise ...'),, ::drgDialog:dialog)

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_ZakOprav_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
********************************************************************************
METHOD VYR_VyrZak_CRD:ZAK_Polozky
  LOCAL oDialog

  DRGDIALOG FORM 'VYR_VYRZAKIT_SCR' PARENT ::drgDialog MODAL DESTROY
RETURN self
*
********************************************************************************
METHOD VYR_VyrZak_CRD:PARAM_inZak
  LOCAL oDialog
  LOCAL cTag  := ZAKAPAR->( OrdSetFocus()), nRecNo  := ZAKAPAR->( RecNO())
  LOCAL cTag2 := VyrZAK->( OrdSetFocus()) , nRecNo2 := VYRZAK->( RecNO())


  DRGDIALOG FORM 'VYR_PARZAK_inZAK' PARENT ::drgDialog MODAL DESTROY
*  dbSelectArea( cAlias)
  IF( cTag <> '' , ZAKAPAR->( AdsSetOrder( cTag)), NIL )
  IF( nRecNo <> 0, ZAKAPAR->( dbGoTO( nRecNo))   , NIL )
  VYRZAK->( AdsSetOrder( cTag2), dbGoTO( nRecNo2) )

RETURN self
*
********************************************************************************
METHOD VYR_VyrZak_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::lCopyREC := ::lOpravy := ;
  ::lNewKALKUL   :=  ;
  ::lNewPARAM    :=  ;
  ::isF4         :=  ;
  ::cPicturZAK   :=  ;
  ::tabNUM       := NIL
RETURN self

*
**HIDDEN************************************************************************
METHOD VYR_VyrZak_CRD:Kalkul_CRD( nEvent)
  LOCAL oDialog, nExit, cKEY

  cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + ;
          Upper( ::dm:get( 'VyrZAKw->cVyrPol')) + ;
          StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
  VYRPOL->( dbSEEK( cKEY))
  DRGDIALOG FORM 'VYR_KALKUL_CRD' PARENT ::drgDialog CARGO nEvent MODAL DESTROY ;
                                   EXITSTATE nExit
  ::drgDialog:dialogCtrl:oaBrowse:refresh()
RETURN self

*
**HIDDEN************************************************************************
METHOD VYR_VyrZak_CRD:RefreshBrow( cFILE)
  Local oBrowse := ::drgDialog:dialogCtrl:oBrowse

  FOR x := 1 TO LEN( oBrowse)
    IF oBrowse[ x]:cFile = cFile
       oBrowse[x]:oXbp:refreshAll()
    ENDIF
  NEXT
RETURN self


*
********************************************************************************
METHOD VYR_VyrZak_CRD:SetCisZAKAZ()
  Local xRET := ''
  Local N, cPicturNUM := '', nLenPict := LEN( ::cPicturZAK), nMAX := 0

  drgDBMS:open('VyrZAK'  ,,,,, 'VyrZAKa'  )
  FOR N := 1 TO nLenPict
    cPicturNUM += '9'
  NEXT
  IF ::cPicturZAK == cPicturNUM
    *  Pro èís. vzory pøednastavujeme o 1 vyšší
    VyrZAKa->( AdsSetOrder( 0), dbGoBOTTOM())
    VyrZAKa->( dbEVAL( {|| nMAX := MAX( nMAX, VAL( VyrZAKa->cCisZakaz))  }))
    xRet := PADR( ALLTRIM( STR( nMAX + 1, nLenPict )), nLenPict, ' ' )
  ENDIF
  VyrZAKa->( dbCloseArea())
RETURN xRET

*
********************************************************************************
METHOD VYR_VyrZak_CRD:CondOfStav( cStav, nCount, lEdit)
  Local lOK

  Default lEdit To YES
  IF !::lNewRec  ;   lOK := ( AllTrim( cStav) $ Left( '1234567', nCount) )
  ELSE           ;   lOK := lEdit
  ENDIF
RETURN( lOK)

*
*-------------------------------------------------------------------------------
METHOD VYR_VyrZak_CRD:Valid_NS()
  Local cKey, cKey1, cKey2, cKey3, cKey4, lOK

  drgDBMS:open('cNazPol1' )
  drgDBMS:open('cNazPol2' )
  drgDBMS:open('cNazPol3' )
  drgDBMS:open('cNazPol4' )
  drgDBMS:open('c_NaklSt' )
  * Validace cNazPOL1
  cKey1 := Upper( ::dm:get('VyrZAKw->cNazPol1'))
  IF !::dm:has( 'VyrZAKw->cNazPol1'):oDrg:isEdit
    IF !cNazPol1->( dbSEEK( cKey1,, AdsCtag(1)))
      cNazPol1->( dbAppend())
      cNazPol1->cNazPol1 := cKey1
    ENDIF
  ENDIF
  * Validace cNazPOL2
  cKey2 := Upper( ::dm:get('VyrZAKw->cNazPol2'))
  IF !::dm:has( 'VyrZAKw->cNazPol2'):oDrg:isEdit
    IF !cNazPol2->( dbSEEK( cKey2,, AdsCtag(1)))
      cNazPol2->( dbAppend())
      cNazPol2->cNazPol2 := cKey2
    ENDIF
  ENDIF
  * Validace cNazPOL3
  cKey3 := Upper( ::dm:get('VyrZAKw->cNazPol3'))
  IF !::dm:has( 'VyrZAKw->cNazPol3'):oDrg:isEdit
    IF cNazPol3->( dbSEEK( Upper( cKey3,,AdsCtag(1))))
      IF cNazPol3->cNazev <> ::dm:get('VyrZAKw->cNazevZak1')
         IF cNazPol3->( dbRLock())
           cNazPol3->cNazev := ::dm:get('VyrZAKw->cNazevZak1')
           cNazPol3->( dbRUnLock())
         ENDIF
      ENDIF
    ELSEIF AddREC( 'cNazPOL3')
      cNazPol3->cNazPol3 := cKey3
      cNazPol3->cNazev   := ::dm:get('VyrZAKw->cNazevZak1')
      mh_WRTzmena( 'cNazPol3', .t.)
      cNazPol3->( dbUnlock())
    ENDIF
  ENDIF
  * Validace cNazPOL4
  cKey4 := Upper( ::dm:get('VyrZAKw->cNazPol4'))
  IF !::dm:has( 'VyrZAKw->cNazPol4'):oDrg:isEdit
    IF !cNazPol4->( dbSEEK( cKey4,, AdsCtag(1)))
      cNazPol4->( dbAppend())
      cNazPol4->cNazPol4 := cKey4
      cNazPol4->cNazev   := VyrPol->cNazev
    ENDIF
  ENDIF

  cKey := cKey1 + cKey2 + cKey3 + cKey4
  lOK := C_NaklSt->( dbSEEK( Upper( cKey),, 'C_NAKLST1'))
  IF( lOK := IF( lOK, ReplREC( 'C_NaklSt'), AddREC( 'C_NaklSt') ))
     C_NaklSt->cNazPol1 := cKey1
     C_NaklSt->cNazPol2 := cKey2
     C_NaklSt->cNazPol3 := cKey3
     C_NaklSt->cNazPol4 := cKey4
     C_NaklSt->( dbUnlock())
  ENDIF

RETURN Nil

*
********************************************************************************
METHOD VYR_VyrZak_CRD:ObjToVyrZAK()

*  drgMsgBox( 'Testováno ...')

  DRGDIALOG FORM 'VYR_OBJZAK_SCR' PARENT ::drgDialog MODAL DESTROY
RETURN self

*
*===============================================================================
STATIC FUNCTION SetCopyREC()
  LOCAL nPos, aFld
  LOCAL cFld := 'cNazevZak1,cCisloObj,cTypZak,cPriorZaka,cVyrobCisl, cVyrPol,nVarCis,' + ;
                'nPlanPruZa,dZpraDokPL,dZpraDokSK,dOdvedZaka,' + ;
                'cNazPol2,nCisFirmy,cTypCeny,cZkratMenZ,cZkrTypUhr,nKlicDph,'  + ;
                'cStred_odb,cStroj_odb,cCisPlan,cZapis'

  aFld :=  ListAsArray( cFld)
  VyrZAKw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := VyrZAK->( FieldPos( X))             , ;
                If( nPos <> 0, VyrZAKw->( FieldPut( nPos, VyrZAK->( FieldGet( nPos)) )), Nil ) ) } )
RETURN NIL

*
*===============================================================================
STATIC FUNCTION ListIT_NS2( dm)
  Local cTAG := ListIT->( AdsSetOrder( 6))
  Local cZakaz := dm:get('VYRZAKw->cCisZAKAZ'), cNazPol2 := dm:get('VYRZAKw->cNazPol2')

  ListIT->( mh_SetScope( UPPER( cZAKAZ)) )
  DO WHILE !ListIT->( EOF())
    IF ReplREC( 'ListIT')
      ListIT->cNazPol2 := cNazPol2
      ListIT->( dbUnlock())
    ENDIF
    ListIT->( dbSKIP())
  ENDDO
  ListIT->( MH_ClrScope(), AdsSetOrder( cTAG))
RETURN NIL

*
*===============================================================================
FUNCTION VYR_SetCisPARAM()
  Local nCisParam, nRec := ZakaPAR->( RecNo())

  ZakaPAR->( dbGoBottom())
  nCisParam := ZakaPAR->nCisAtribZ + 1
  ZakaPAR->( dbGoTO( nRec))
RETURN( nCisParam)


********************************************************************************
* Varianta karty výr.zakázky
********************************************************************************
CLASS VYR_VYRZAK_TST FROM VYR_VYRZAK_CRD
/*
EXPORTED:
  INLINE METHOD  Init(parent)
    ::HIM_MAJ_SCR:init( parent, 'ZVI' )
  RETURN self
*/
ENDCLASS