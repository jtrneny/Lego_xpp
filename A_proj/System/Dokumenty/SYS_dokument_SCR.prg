********************************************************************************
*  SYS_Dokument_SCR
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"

*-------------------------------------------------------------------------------
FUNCTION existFile()
   Local nIcon
   nIcon := If( Empty( Dokument->cSoubor), MIS_NO_RUN,;
                If( FILE(Dokument->cSoubor), 0, MIS_ICON_ERR ))
RETURN nIcon

********************************************************************************
*
********************************************************************************
CLASS SYS_Dokument_SCR FROM drgUsrClass

EXPORTED:
  VAR     nTask_filter

  METHOD  Init, eventHandled, drgDialogStart, comboItemSelected
HIDDEN
  VAR     mainBro

ENDCLASS

********************************************************************************
METHOD SYS_Dokument_SCR:init(parent)

  ::drgUsrClass:init(parent)
  *
  ::nTask_filter := ''  // 1
  drgDBMS:open('VazDOKUM'  )
RETURN self

********************************************************************************
METHOD SYS_Dokument_SCR:drgDialogStart(drgDialog)
  *
  ::mainBro := drgDialog:odBrowse[1]
RETURN SELF

********************************************************************************
METHOD SYS_Dokument_SCR:comboItemSelected( Combo)
  Local Filter

  ::nTask_filter := alltrim(Combo:value)
  Do Case
  Case Combo:value = ''               // Všechny úlohy
    IF( EMPTY(Dokument->(ads_getAof())), NIL, Dokument->(ads_clearAof(),dbGoTop()) )

  otherwise                          // konkrétní úloha
*    Filter := "cTask = %%"
*    nRok   := VAL( RIGHT( ALLTRIM( Combo:values[Combo:value, 2]), 4))
*    Filter := Format( Filter, { nRok } )
*    CenZb_ps->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.

*
********************************************************************************
METHOD SYS_Dokument_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
*  Local dc := ::drgDialog:dialogCtrl
  Local Filter, aRECs := {}, cMsg, Dok_isLock, Vaz_isLock

  DO CASE
//    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    CASE nEvent = drgEVENT_DELETE
      *
//      Filter := FORMAT( "Upper( VazDOKUM->cOuUniqId) = '%%'", { Upper( Dokument->cUniqIdRec )})
      Filter := FORMAT( "VazDOKUM->dokument = %%", { isNull( Dokument->sID, 0) })
      VazDOKUM->( AdsSetOrder( 2),;
                  mh_SetFilter( Filter) ,;
                  dbEVAL( {|| Aadd( aRECs, VazDokum->( RecNo()) )  }))
      cMsg := If( LEN( aRECs) > 0, ' - ( existují vazby na jiné soubory )', '')
      IF drgIsYesNO(drgNLS:msg('Požadujete zrušit tento záznam o dokumentu ? ' + cMsg))
         Dok_isLock :=  DOKUMENT->( sx_RLock())
         Vaz_isLock := IF( LEN( aRECs) > 0, VazDOKUM->( sx_RLock( aRECs )), .T. )
         IF Dok_isLock .and. Vaz_isLock
            AEval( aRECs, {|nREC| VazDOKUM->(DbGoTo(nREC), dbDelete()) } )
            VazDOKUM->( dbUnlock())
            DOKUMENT->( dbDelete(), dbUnlock())
            ::mainBro:oxbp:refreshAll()
         ENDIF
      ENDIF
      RETURN .T.
      *
    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

********************************************************************************
*
********************************************************************************
CLASS SYS_Dokument_CRD FROM drgUsrClass, SYS_Dokument_SCR

EXPORTED:
  VAR     lMainScr, usrFile

  METHOD  Init, drgDialogStart, EventHandled, PostValidate, Destroy
  METHOD  selFile

HIDDEN
  VAR     lNewREC, dm, dc
ENDCLASS

********************************************************************************
METHOD SYS_Dokument_CRD:Init(parent)

  ::drgUsrClass:init(parent)
  ::SYS_Dokument_SCR:init(parent)
  ::lNewREC := ( parent:cargo = drgEVENT_APPEND)
  ::lMainScr := ( parent:parent:formName = 'Sys_Dokument_scr' )
  ::usrFile  := If( ::lMainScr, '', parent:parent:udcp:mainFile )
  *
  drgDBMS:open('DOKUMENTw',.T.,.T.,drgINI:dir_USERfitm);  ZAP
  IF ::lNewREC  ;  DOKUMENTw->(dbAppend())
  ELSE          ;  mh_COPYFLD('DOKUMENT', 'DOKUMENTw', .T.)
  ENDIF
RETURN self

*
********************************************************************************
METHOD SYS_Dokument_CRD:drgDialogStart(drgDialog)
  Local isReadOnly //:= drgParseSecond( drgDialog:InitParam)
*  Local aInitParam :=  ListAsArray( drgDialog:InitParam, ',' ), aSetGet, lNewSet

  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  /*
  IF LEN( aInitParam) > 1
    isReadOnly := aInitParam[2]
    isReadOnly := &isReadOnly
    drgDialog:SetReadOnly( isReadOnly)
  ENDIF
  IF LEN( aInitParam) > 2
    aInitParam[3] :=  STRTRAN( aInitParam[3], ';', ',' )
    aSetGET := aInitParam[3]
    aSetGET := &aSetGET
    ::dm:set( 'FIXNAKLw->nRokVyp' , aSetGET[ 1] )
    ::dm:set( 'FIXNAKLw->cNazPol1', aSetGET[ 2] )
    ::dm:set( 'FIXNAKLw->nObdMes' , aSetGET[ 3] )
    ::dm:set( 'FIXNAKLw->cNazPol2', aSetGET[ 4] )
  ENDIF
  lNewSet := ! IsNil( aSetGET)
  */
  IsEditGET( {'DOKUMENTw->nIdDokum'   ,;
              'DOKUMENTw->cIdDokum'} ,  drgDialog, ::lNewRec )
RETURN self

*
********************************************************************************
METHOD SYS_Dokument_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  Local  lDok, lVazDok

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    IF ! ::drgDialog:dialogCtrl:isReadOnly
      ::dm:save()
      lDok    := DOKUMENT->(sx_RLock())
      lVazDok := If( ::lMainScr, .T., VazDOKUM->(sx_RLock()) )
      IF lDok .and. lVazDok
        mh_COPYFLD('DOKUMENTw', 'DOKUMENT', ::lNewREC )
        If !::lMainScr
          VazDOKUM->( dbAppend())
/// upravit na novou vazbu sID

/*
           If EMPTY( (::usrFile)->cUniqIdRec )
             If (::usrFile)->( sx_RLock())
               (::usrFile)->( mh_GetLastUniqID())
               VazDOKUM->cInUniqId  := (::usrFile)->cUniqIdRec
               (::usrFile)->( dbUnLock())
             EndIf
           ELSE
             VazDOKUM->cInUniqId  := (::usrFile)->cUniqIdRec
           ENDIF
           VazDOKUM->cOuUniqId  := Dokument->cUniqIdRec
*/

          VazDOKUM->cTABLE   := Upper(Padr(AllTrim(::usrFile),10)) +StrZero(isNull( (::usrFile)->sID, 0),10)
          VazDOKUM->dokument := isNull( Dokument->sID, 0)
          VazDOKUM->( dbUnlock())

           *
           ::drgDialog:parent:udcp:setFilter()
        EndIF
        DOKUMENT->( dbUnlock())
      ELSE
        drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
      ENDIF
    ENDIF
    PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
    ::drgDialog:parent:dialogCtrl:browserefresh()

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD SYS_Dokument_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cName := UPPER(oVar:name)

  DO CASE
  CASE cName = 'DOKUMENTw->cSoubor'
     lOK := ::selFile( xVar)

  CASE cName = 'DOKUMENTw->cZkrDokum'

  ENDCASE
RETURN lOK

********************************************************************************
METHOD SYS_Dokument_CRD:selFile( xVar)
  Local lOK := FILE( ::dm:get( 'DOKUMENTw->cSoubor')), cSoubor

  If IsObject( xVar) .or. !lOK
    cSoubor := selFILE( '*', '*')
    If( IsNil( cSoubor), nil, ::dm:set( 'DOKUMENTw->cSoubor', cSoubor ) )
    lOK := .T.
  EndIf
  *
RETURN lOK

*
********************************************************************************
METHOD SYS_Dokument_CRD:destroy()
  ::drgUsrClass:destroy()

  ::lNewREC := ::dm  := ::dc := ;
   NIL
RETURN self


********************************************************************************
* SYS_Dokument_SEL ...
********************************************************************************
CLASS SYS_Dokument_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
  METHOD  RecordEdit
ENDCLASS

*
********************************************************************************
METHOD SYS_Dokument_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('DOKUMENT')
RETURN self

*
********************************************************************************
METHOD SYS_Dokument_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

*  CASE nEvent = drgEVENT_APPEND
*    ::recordEdit()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*
********************************************************************************
METHOD SYS_Dokument_SEL:RecordEdit()
*  DRGDIALOG FORM 'SKL_CENZBOZ_SCR' PARENT ::drgDialog DESTROY
RETURN self