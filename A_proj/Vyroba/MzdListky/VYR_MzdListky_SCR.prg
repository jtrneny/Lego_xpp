/*==============================================================================
  VYR_MzdListky_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION ML_uzavren()
*RETURN IF( ListHD->lUzv, 'Uzav�en', '')
RETURN IF( ListHD->lUzv, DRG_ICON_SELECTT, DRG_ICON_SELECTF)

function ML_stavZakaz()
  ZAKa->( dbSEEK( Upper(ListHD->cCisZakaz),, 'VYRZAK1'))
RETURN if(ZAKa->cStavZakaz = 'U', MIS_ICON_OK, 0)

FUNCTION NazevZakaz()
  ZAKa->( dbSEEK( Upper(ListHD->cCisZakaz),, 'VYRZAK1'))
RETURN ZAKa->cNazevZak1

********************************************************************************
*  Mzdov� l�stky - dle l�stk�
********************************************************************************
CLASS VYR_MListHD_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  ItemMarked
  METHOD  OnSave
  METHOD  ctrlKonTarLi

HIDDEN:
  var     brow, dm, dc, df
  VAR     tabNUM
ENDCLASS

********************************************************************************
METHOD VYR_MListHD_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('VyrZAK'  )
  drgDBMS:open('PolOper' )
  drgDBMS:open('Osoby'   )

  * pro info
  drgDBMS:open('VyrZAK',,,,, 'ZAKa'  )

  ::tabNUM  := 1
RETURN self

********************************************************************************
METHOD VYR_MListHD_SCR:drgDialogStart(drgDialog)
  local  x, odrg, members := drgDialog:oForm:aMembers
  local  pa := { 'listhd->nKusyCelk' , 'listhd->nKusyHotov', ;
                 'listhd->nNhNaOpePl', 'listhd->nNhNaOpeSK', ;
                 'listhd->nNmNaOpePl', 'listhd->nNmNaOpeSK', ;
                 'listhd->nKcNaOpePl', 'listhd->nKcNaOpeSK'  }

  ::brow     := drgDialog:dialogCtrl:oBrowse
  ::dm       := drgDialog:dataManager             // dataMananager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // dialogForm
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  isEditGet( pa, drgDialog, .f. )

  *
  LISTHD->( DbSetRelation( 'C_Stred' , {|| Upper(LISTHD->cStred) }    ,'Upper(LISTHD->cStred)'))
  LISTHD->( DbSetRelation( 'C_Pracov', {|| Upper(LISTHD->cOznPrac) }  ,'Upper(LISTHD->cOznPrac)'))
  *
RETURN self

********************************************************************************
METHOD VYR_MListHD_SCR:drgDialogEnd(drgDialog)
  *
RETURN self

********************************************************************************
METHOD VYR_MListHD_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local cAlias

  DO CASE
  CASE nEvent = drgEVENT_DELETE
    cAlias := lower(::dc:oaBrowse:cfile)

    IF     cAlias = 'listhd' ;   VYR_MListHD_DEL()
    ELSEIF cAlias = 'listit' ;   VYR_MListIT_DEL()
    ENDIF
    AEval( ::drgDialog:oDBrowse, {|oB| oB:REFRESH() } )
    ::dataManager:refresh()

  /*
    IF drgIsYESNO(drgNLS:msg( 'Zru�it vybran� pracovi�t� < & >  ?' , C_PRACOV->cOznPrac) )
      If C_PRACOV->( sx_RLock())
        C_PRACOV->( DbDelete(), DbUnlock() )
        oXbp:cargo:refresh()
      ENDIF
    ENDIF
  */
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_MListHD_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
  IF ::tabNUM = 2  // Polo�ky  ML
    ::drgDialog:dialogCtrl:oBrowse[2]:refresh()
  ENDIF
RETURN .T.

********************************************************************************
METHOD VYR_MListHD_SCR:ItemMarked()

*  IF ::tabNUM = 2   // Polo�ky  ML
    ListIT->( mh_SetScope( StrZERO( ListHD->nRokVytvor, 4)+ StrZERO( ListHD->nPorCisLis, 12) ))
*  ENDIF
RETURN SELF

*******************************************************************************
METHOD VYR_MListHD_SCR:OnSave()
RETURN .F.


method VYR_MListHD_SCR:ctrlKonTarLi()
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok,cobd
  local  nprocprem
  local  ntarif
  LOCAL  SKL,DIS

  local  cc
  local  lrozd

  cobd := uctOBDOBI:VYR:COBDOBI
  cc   := ''

  drgDBMS:open( 'listit',,,,,'listitS')
  drgDBMS:open( 'msprc_mo')
  drgDBMS:open( 'osoby',,,,,'OSOBY_S')
//  drgDBMS:open( 'vyrpol',,,,,'vyrpola')

  cfiltr := Format("cobdobi= '%%'", {cobd})
  listitS->(ads_setaof(cfiltr), dbGoTop())
  lrozd := .f.


  IF drgIsYESNO(drgNLS:msg( "Prov�st kontrolu sazeb tarif� a procent pr�mi� u ML ?"))
    cc := ' Zji�t�n� rozd�ly o proti p�ednastven�m sazb�m !!!' + CRLF
    cc += ' =================================================' + CRLF
    cc += CRLF

    do while .not. listitS->( Eof())
      ntarif    := 0
      nprocprem := 0
      do case
      case listitS->nporpravzt > 0
        if msprc_mo->( dbseek( StrZero(listitS->nrok,4) +              ;
                                 StrZero(listitS->nobdobi,2) +         ;
                                  StrZero(listitS->noscisprac,5) +     ;
                                   StrZero(listitS->nporpravzt,3),,'MSPRMO01'))

          nTarif    := fSazTar( listitS->dVyhotSkut )[1]
          nProcPrem := fSazZam('PRCPREHLCI',listitS->dVyhotSKUT,'listitS')
        endif

      case listitS->nporpravzt = 0
        if OSOBY_S->( dbseek( listitS->ncisosoby,, 'Osoby01'))
          nTarif := fSazTar( listitS->dVyhotSkut, 'OSOBY_S' )[1]
        endif

      endcase

      if ( Round(nTarif,4) <> Round(listitS->ntarsazhod,4) .and. ntarif <> 0 ) .or. ;
            (Round(nProcPrem,4) <> Round(listitS->nsazprepr,4))

        cc += 'Pracovn�k: ' + Str(listitS->noscisprac) +    ;
               '�.l�stku: ' + Str(listitS->nporcislis) +    ;
                'Sazba tar/l�s: '+ Str(nTarif,8,2) + '/' + Str(listitS->ntarsazhod,8,2) + ;
                 'Pr�mie saz/l�s: '+ Str(nProcPrem,8,2) + '/' + Str(listitS->nsazprepr,8,2) + CRLF

        lrozd := .t.

      endif

      listitS->( dbSkip())
    enddo

    if lrozd
      drgDump(cc)
      drgMsgBox( cc )

    else
      drgMsgBox( "Nebyly zji�t�ny ��dn� rozd�ly o proti p�ednastaven�m sazb�m." )
    endif
  endif

  drgMsgBox( "Konec kontroly")


return .t.

********************************************************************************
* Mzdov� l�stky - dle pln�n�
********************************************************************************
CLASS VYR_MListIT_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  ItemMarked

  METHOD  ML_Rozdelit, ML_Planovat

HIDDEN:
  VAR     tabNUM
ENDCLASS

********************************************************************************
METHOD VYR_MListIT_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('Osoby' )
  drgDBMS:open('VyrZAK' )
  ::tabNUM := 1
RETURN self

********************************************************************************
METHOD VYR_MListIT_SCR:drgDialogStart(drgDialog)

  ListHD->( AdsSetOrder( 1))
  LISTIT->( DbSetRelation( 'VyrZAk'   , {|| Upper(ListIT->cCisZakaz)  },'Upper(ListIT->cCisZakaz)'))
  LISTIT->( DbSetRelation( 'Osoby' ,    {|| LISTIT->nCisOsoby }        ,'LISTIT->nCisOsoby'))
  LISTIT->( DbSetRelation( 'C_PracZa' , {|| Upper(LISTIT->cPracZar)   },'Upper(LISTIT->cPracZar)'))
  LISTIT->( DbSetRelation( 'C_TarStu' , {|| Upper(LISTIT->cTarifStup) },'Upper(LISTIT->cTarifStup)'))
  LISTIT->( DbSetRelation( 'C_TarTri' , {|| Upper(LISTIT->cTarifTrid) },'Upper(LISTIT->cTarifTrid)'))
  LISTIT->( DbSetRelation( 'DruhyMzd' , {|| LISTIT->nDruhMzdy }        ,'LISTIT->nDruhMzdy'))
  LISTIT->( DbSetRelation( 'C_TypLis' , {|| UPPER(LISTIT->cTypListku) },'UPPER(LISTIT->cTypListku)'))
RETURN self

********************************************************************************
METHOD VYR_MListIT_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_MListIT_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.

********************************************************************************
METHOD VYR_MListIT_SCR:ItemMarked()

  IF ::tabNUM = 3    // Hlavi�ka l�stku
    ListHD->( mh_SetScope( StrZero( ListIT->nRokVytvor, 4) + StrZero( ListIT->nPorCisLis, 12) ) )
  ENDIF
RETURN SELF

* Rozd�len� polo�ky mzdov�ho l�stku
********************************************************************************
METHOD VYR_MListIT_SCR:ML_Rozdelit()
  VYR_ML_Rozdelit( ::drgDialog)
RETURN

* Zapl�nov�n� polo�ky mzdov�ho l�stku
********************************************************************************
METHOD VYR_MListIT_SCR:ML_Planovat()
  VYR_ML_Planovat( ::drgDialog)
RETURN


********************************************************************************
*
********************************************************************************
CLASS VYR_MListZAK_SCR FROM drgUsrClass
EXPORTED:
  VAR     msg

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  ItemMarked

  METHOD  VYR_MListZAK_del, btn_VyrZakIT

HIDDEN:
  VAR     tabNUM
ENDCLASS

*
********************************************************************************
METHOD VYR_MListZAK_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('ListIT'  )
  drgDBMS:open('PolOper' )
  ::tabNUM := 1
RETURN self

********************************************************************************
METHOD VYR_MListZAK_SCR:drgDialogStart(drgDialog)

  VYRZAK->( DbSetRelation( 'VyrPOL' , {|| Upper(VYRZAK->cVyrPol) },'Upper(VYRZAK->cVyrPol)'))
  ::msg := ::drgDialog:oMessageBar
RETURN self

********************************************************************************
METHOD VYR_MListZAK_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE

      IF drgIsYESNO(drgNLS:msg( 'Zru�it mzdov� l�stky na zak�zku < & >  ?' , VyrZAK->cCisZakaz) )
      /*
        If C_PRACOV->( sx_RLock())
          C_PRACOV->( DbDelete(), DbUnlock() )
          oXbp:cargo:refresh()
        ENDIF
      */
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_MListZAK_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
  IF ::tabNUM = 2  // Hlavi�ka ML
   ::drgDialog:dialogCtrl:oBrowse[2]:refresh()
  ENDIF
RETURN .T.

********************************************************************************
METHOD VYR_MListZAK_SCR:ItemMarked()

  IF ::tabNUM = 2    // Hlavi�ka ML
    ListHD->( mh_SetScope( UPPER( VYRZAK->cCisZakaz) ))
  ENDIF
RETURN SELF

********************************************************************************
METHOD VYR_MListZAK_SCR:VYR_MListZAK_del()
  LOCAL oDialog, nExit, nDavka := 0, nHlp
  LOCAL cMsg := 'Zru�it mzdov� l�stky na zak�zku < & > ?'

  IF NazPOL1_TST( 'VyrZAK', xbeK_DEL, '3')
    IF drgIsYESNO(drgNLS:msg( cMsg, VyrZAK->cCisZakaz) )

      DRGDIALOG FORM 'DAVKA_zak' PARENT ::drgDialog CARGO nDavka EXITSTATE nExit MODAL

      IF nExit != drgEVENT_QUIT
        nDavka := oDialog:UDCP:nDavka
        MListZAK_del( oDialog, nDavka)
      ENDIF
      oDialog:destroy()
      oDialog := NIL
    ENDIF
  ENDIF
RETURN self

* Polo�ky zak�zky
********************************************************************************
METHOD VYR_MListZAK_SCR:btn_VyrZakIT
  LOCAL oDialog, nTypEvidIT := 2, Filter

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'VYR_MListZakIT_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
  /*
  ::drgDialog:pushArea()
  DO CASE
  CASE nTypEvidIT = 0    // bez polo�ek k zak�zce
    drgMsgBox(drgNLS:msg('K zak�zce se neeviduj� polo�ky !'))
  CASE nTypEvidIT = 1    // std
  CASE nTypEvidIT = 2    // KOVAR
*    Filter := FORMAT("cCisZakaz = '%%'",{  ALLTRIM(VyrZAK->cCisZakaz) } )
*    VyrZakIT->( mh_SetFilter( Filter))
    DRGDIALOG FORM 'VYR_VyrZakIT_SCR' PARENT ::drgDialog MODAL DESTROY
    ::RefreshBROW('VyrZAK')
*    VyrZakIT->( mh_ClrFilter())
  ENDCASE
  ::drgDialog:popArea()
  */
RETURN self

*  Ru�en� ML na zak�zku nebo na polo�ku zak�zky
*===============================================================================
STATIC FUNCTION MListZAK_del( oDlg, nDavka)
  Local cFILE := oDlg:parent:dbName
  Local cItem // := IF( cFile = 'VYRZAK', VyrZAK->cCisZAKAZ, VyrZAKIT->cCisZAKAZI )
  Local cKEY := VyrZAK->cCisZAKAZ, nTag
  Local cTAG, cTAG1 := ListIT->( AdsSetOrder( 1))
  Local cTAG2 := PolOPER->( AdsSetOrder( 5)), cTAG3 := VyrPOL->( AdsSetOrder( 1))
  Local nSUMA, aRECs := {}, lOK
  Local msg := oDlg:parent:UDCP:msg

  cItem := IF( cFile = 'VYRZAK', VyrZAK->cCisZAKAZ, VyrZAKIT->cCisZAKAZI )
  nTag  := IF( cFile = 'VYRZAK',                 3,                    9 )
  cTAG  := ListHD->( AdsSetOrder( nTag))

  ListHD->( mh_SetScope( UPPER( cITEM) ))
  /*
  IF ListHD->nPorCisLis = 0
   ( ListHD->( AdsSetOrder( cTAG))  , ListIT->( AdsSetOrder( cTAG1)),;
   PolOPER->( AdsSetOrder( cTAG2)), VyrPOL->( AdsSetOrder( cTAG3)) )
   drgMsgBox(drgNLS:msg('Mzdov� l�stky neexistuj� - nen� co ru�it !'))
   RETURN NIL
  ENDIF
  */
  msg:WriteMessage('Prob�h� ru�en� mzdov�ch l�stk� na zak�zku ...', DRG_MSG_INFO)

  DO WHILE !ListHD->( EOF())     //  Hlavi�ky ML
    // nDAVKA == 0  ... zru�it v�echny d�vky
    // nDAVKA <> 0  ... zru�it konkr�tn� d�vku
    lOK := IF( nDAVKA == 0, YES, ListHD->nPocCeZapZ == nDavka )
    IF lOK
      nSUMA := ListHD->nNhNaOpeSK + ListHD->nKusyHOTOV + ListHD->nKcNaOpeSK
      IF nSUMA == 0   //  Podm�nka zru�en� !!!
         cKEY := StrZERO( ListHD->nRokVytvor, 4) + StrZERO( ListHD->nPorCisLis, 12)
         ListIT->( mh_SetScope( cKEY ))
         VYR_ListHD_del()
         ListIT->( mh_ClrScope())
      ELSE
         AADD( aRECs, ListHD->( RecNO()) )
      ENDIF
    ENDIF
    ListHD->( dbSKIP())
  ENDDO

  VYR_PolOPERZ_MODI( VyrZAK->cCisZakaz, nDAVKA )
  ListHD->( mh_ClrScope())

  * Aktualizace VyrPOL
  msg:WriteMessage('Aktualizace vyr�b�n�ch polo�ek k zak�zce ...', DRG_MSG_INFO)
  VyrPOL->( mh_SetScope( UPPER( VYRZAK->cCisZakaz) ))
  VyrPOL->( dbEval( {|| AADD( aRECs, VyrPOL->( RecNO())) }))
  lOK := IF( LEN( aRECs) = 0, .F., VyrPOL->( sx_RLock( aRECs)))
  IF lOK
    FOR n := 1 TO LEN( aRECs)
      VyrPOL->( dbGoTO( aRECs[ n]) )
*      VyrPOL->nMnZadVA := 0
*      VyrPOL->nMnZadVK := 0
    NEXT
    VyrPOL->( dbUnlock())
  ENDIF
  VyrPOL->( mh_ClrScope())

  /* Zobrazit nezru�en� ML
  IF LEN( aREC) > 0
    BrowseML( aREC)
  ENDIF
  */
 ( ListHD->( AdsSetOrder( cTAG))  , ListIT->( AdsSetOrder( cTAG1)),;
   PolOPER->( AdsSetOrder( cTAG2)), VyrPOL->( AdsSetOrder( cTAG3)) )
  msg:WriteMessage(,0)
RETURN NIL


********************************************************************************
*
********************************************************************************
CLASS VYR_MListZAKIT_SCR FROM drgUsrClass
EXPORTED:
  VAR     msg, Filter

  METHOD  Init, Destroy, drgDialogStart, EventHandled, tabSelect
  METHOD  ItemMarked

  METHOD  MListZAKIT_del

HIDDEN:
  VAR     tabNUM
ENDCLASS

********************************************************************************
METHOD VYR_MListZAKIT_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('ListHD'  )
*  drgDBMS:open('PolOper' )
  ::tabNUM := 1
RETURN self

********************************************************************************
METHOD VYR_MListZAKIT_SCR:drgDialogStart(drgDialog)

  ::Filter := FORMAT("cCisZakaz = '%%'",{ VyrZAK->cCisZakaz } )
  VyrZakIT->( mh_SetFilter( ::Filter), dbGoTOP() )

*  VYRZAK->( DbSetRelation( 'VyrPOL' , {|| Upper(VYRZAK->cVyrPol) },'Upper(VYRZAK->cVyrPol)'))
  ::msg := drgDialog:oMessageBar
RETURN self

********************************************************************************
METHOD VYR_MListZAKIT_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE

      IF drgIsYESNO(drgNLS:msg( 'Zru�it mzdov� l�stky na polo�ku zak�zky < & >  ?' , VyrZAKIT->cCisZakazI) )
      /*
      */
      ENDIF
    *
    CASE nEvent = xbeP_SetDisplayFocus
      VyrZakIT->( mh_SetFilter( ::Filter), dbGoTOP() )   // !!!
      RETURN .F.
    *
    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_MListZAKIT_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
  IF ::tabNUM = 1  // Hlavi�ka ML
   ::drgDialog:dialogCtrl:oBrowse[2]:refresh()
  ENDIF
RETURN .T.
*
********************************************************************************
METHOD VYR_MListZAKIT_SCR:ItemMarked()
*  IF ::tabNUM = 1    // Hlavi�ka ML
    ListHD->( mh_SetScope( UPPER( VYRZAKIT->cCisZakazI) ))
*  ENDIF
RETURN SELF

********************************************************************************
METHOD VYR_MListZAKIT_SCR:MListZAKIT_del()
  LOCAL oDialog, nExit, nDavka := 0, nHlp
  LOCAL cMsg := 'Zru�it mzdov� l�stky na polo�ku zak�zky < & > ?'

  IF NazPOL1_TST( 'VyrZAK', xbeK_DEL, '3')
    IF drgIsYESNO(drgNLS:msg( cMsg, VyrZAKIT->cCisZakazI) )

      DRGDIALOG FORM 'DAVKA_zak' PARENT ::drgDialog CARGO nDavka EXITSTATE nExit MODAL

      IF nExit != drgEVENT_QUIT
        nDavka := oDialog:UDCP:nDavka
        MListZAK_del( oDialog, nDavka)
        ::drgDialog:dialogCtrl:oBrowse[2]:refresh()
      ENDIF
      oDialog:destroy()
      oDialog := NIL
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_MListZakIT_SCR:destroy()
  ::drgUsrClass:destroy()
  ::tabNUM := ::Filter := NIL
  VyrZakIT->( mh_ClrFilter())
RETURN self


********************************************************************************
*
********************************************************************************
CLASS DAVKA_zak FROM drgUsrClass
EXPORTED:
  VAR     nDavka

  METHOD  getForm, destroy
ENDCLASS

****************************************************************************
METHOD DAVKA_zak:getForm()
LOCAL drgFC, oDrg
  drgFC  := drgFormContainer():new()
  ::nDavka := ::drgDialog:cargo

  DRGFORM INTO drgFC SIZE 30,5 DTYPE '0' TITLE 'Zadej ��slo d�vky';
    GUILOOK 'ALL:N'

  DRGGET nDavka INTO drgFC FPOS 15,1 FLEN 5 FCAPTION 'Ru�en� d�vka:' CPOS 1,1 PICTURE '@N 999'

  DRGPUSHBUTTON INTO drgFC CAPTION 'OK' EVENT drgEVENT_SAVE PRE '0' SIZE 12,1.2 POS 2,3 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION 'Cancel' EVENT drgEVENT_QUIT PRE '0' SIZE 12,1.2 POS 16,3 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

********************************************************************************
METHOD DAVKA_zak:destroy()
  ::drgUsrClass:destroy()
  ::nDavka := ;
              NIL
RETURN