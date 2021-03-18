/*==============================================================================
  VYR_KapacityDEN_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* Kapacity  LidskÈ na DEN - p¯ehled
********************************************************************************
CLASS VYR_KAPL_DEN_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled
ENDCLASS

********************************************************************************
METHOD VYR_KAPL_DEN_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_KAPL_DEN_SCR:drgDialogStart(drgDialog)
RETURN self

********************************************************************************
METHOD VYR_KAPL_DEN_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      IF drgIsYESNO(drgNLS:msg( 'Zruöit z·znam o kapacitÏ profese < & >  ?' , KAPL_DEN->cPraczar) )
        If KAPL_DEN->( sx_RLock())
          KAPL_DEN->( DbDelete(), DbUnlock() )
          oXbp:cargo:refresh()
        ENDIF
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
* Kapacity  LidskÈ na DEN - edit. karta
********************************************************************************
CLASS VYR_KAPL_DEN_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, cDenBlok

  METHOD  Init, Destroy, drgDialogStart, EventHandled, PostValidate
  METHOD  OnSave

HIDDEN
  VAR dm

ENDCLASS

********************************************************************************
METHOD VYR_KAPL_DEN_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC  := !( parent:cargo = drgEVENT_EDIT)
  ::cDenBlok := ''

  drgDBMS:open('KAPL_DENw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF ::lNewREC
    KAPL_DENw->(dbAppend())
  ELSE
    mh_COPYFLD('KAPL_DEN', 'KAPL_DENw', .T.)
    ::cDenBlok := CDow( KAPL_DENw->dVyhotPlan)
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_KAPL_DEN_CRD:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  IsEditGET( {'KAPL_DENw->nTydKapBlo',;
              'KAPL_DENw->nObdobi'   ,;
              'KAPL_DENw->nRokVytvor' }, drgDialog, .F.)
  /*
  IF UPPER( drgDialog:parent:formName) $ 'VYR_KALK_MZD'
    drgDialog:SetReadOnly( .T.)
  ENDIF
  */
RETURN self

********************************************************************************
METHOD VYR_KAPL_DEN_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
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
METHOD VYR_KAPL_DEN_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), cField := lower( drgParseSecond( cName, '>' ))
  LOCAL nRec, cMsg, cPracZar
  *
  IF lValid
    cPracZar   := ::dm:get( 'KAPL_DENw->cPraczar')
    dVyhotPlan := ::dm:get( 'KAPL_DENw->dVyhotPlan')
    DO CASE
    CASE cName = 'KAPL_DENw->dVyhotPlan'
      IF( lOK := ControlDUE( oVar, .t.) )
        ::dm:set( 'M->cDenBlok'          , ::cDenBlok := CDow( xVar)  )
        ::dm:set( 'KAPL_DENw->nTydKapBlo', mh_WeekOfYear( xVar) )
        ::dm:set( 'KAPL_DENw->nObdobi'   , Month( xVar) )
        ::dm:set( 'KAPL_DENw->nRokVytvor', Year(xVar) )

        IF ::lNewRec .and. !EMPTY( cPracZar)
          cKey := DTOS( xVar) + Upper( cPracZar)
          IF KAPL_DEN->( dbSeek( cKey,, 'KAPL_1'))
            cMsg := 'DUPLICITA !;; Na tento den + profesi jiû byla kapacita zad·na !'
            drgMsgBox(drgNLS:msg( cMsg))
          ENDIF
        ENDIF
      ENDIF

    CASE cName = 'KAPL_DENw->cPraczar'
      IF( lOK := ControlDUE( oVar, .t.) )
        IF ::lNewRec .and. !EMPTY( DTOS( dVyhotPlan))
          cKey := DTOS( dVyhotPlan) + Upper( xVar)
          IF KAPL_DEN->( dbSeek( cKey,, 'KAPL_1'))
            cMsg := 'DUPLICITA !;; Na tento den + profesi jiû byla kapacita zad·na !'
            drgMsgBox(drgNLS:msg( cMsg))
            lOK := .F.
          ENDIF
        ENDIF
      ENDIF

    CASE cField $ 'npracodoba,npocetlidi,npocsmen'
      ::dm:set( 'KAPL_DENw->nKapacNhod', ::dm:get('KAPL_DENw->nPracoDoba') * ;
                                         ::dm:get('KAPL_DENw->nPocetLidi') * ::dm:get('KAPL_DENw->nPocSmen') )
      ::dm:set( 'KAPL_DENw->nVolnaKapa', ::dm:get('KAPL_DENw->nKapacNhod') - ::dm:get('KAPL_DENw->nBlokaceNh'))

    CASE cField $ 'nkapacnhod,nblokacenh'
      ::dm:set( 'KAPL_DENw->nVolnaKapa', ::dm:get('KAPL_DENw->nKapacNhod') - ::dm:get('KAPL_DENw->nBlokaceNh'))
    ENDCASE
  ENDIF
  */
RETURN lOK

*
*******************************************************************************
METHOD VYR_KAPL_DEN_CRD:OnSave(lIsCheck,lIsAppend,drgDialog)
  LOCAL nREC

    IF ! ::drgDialog:dialogCtrl:isReadOnly
*      ::dm:save()
      ::drgDialog:dataManager:save()
      IF( ::lNewREC, KAPL_DEN->( DbAppend()), Nil )
      IF KAPL_DEN->(sx_RLock())
         mh_COPYFLD('KAPL_DENw', 'KAPL_DEN' )
  *       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
         nREC := KAPL_DEN->( RecNo())
         KAPL_DEN->( dbUnlock())
         nREC := KAPL_DEN->( RecNo())
*         ::drgDialog:parent:dialogCtrl:oaBrowse:refresh()
      ENDIF
    ENDIF
*
RETURN .T.

*
*******************************************************************************
METHOD VYR_KAPL_DEN_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC      :=  ;
  ::dm           :=  Nil

  KAPL_DENw->( dbCloseArea())
RETURN self
*


********************************************************************************
* Kapacity  StrojnÌ na DEN - p¯ehled
********************************************************************************
CLASS VYR_KAPP_DEN_SCR FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled
ENDCLASS

********************************************************************************
METHOD VYR_KAPP_DEN_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

********************************************************************************
METHOD VYR_KAPP_DEN_SCR:drgDialogStart(drgDialog)
RETURN self

********************************************************************************
METHOD VYR_KAPP_DEN_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      IF drgIsYESNO(drgNLS:msg( 'Zruöit z·znam o kapacitÏ pracoviötÏ < & >  ?' , KAPP_DEN->cOznPrac) )
        If KAPP_DEN->( sx_RLock())
          KAPP_DEN->( DbDelete(), DbUnlock() )
          oXbp:cargo:refresh()
        ENDIF
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
* Kapacity  StrojnÌ na DEN - edit. karta
********************************************************************************
CLASS VYR_KAPP_DEN_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, cDenBlok

  METHOD  Init, Destroy, drgDialogStart, EventHandled, PostValidate
  METHOD  OnSave

HIDDEN
  VAR dm

ENDCLASS

*
********************************************************************************
METHOD VYR_KAPP_DEN_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC  := !( parent:cargo = drgEVENT_EDIT)
  ::cDenBlok := ''

  drgDBMS:open('KAPP_DENw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF ::lNewREC
    KAPP_DENw->(dbAppend())
*    C_PRACOVw->nViceStroj := 1
*    C_PRACOVw->nKoefViSt  := 1
  ELSE
    mh_COPYFLD('KAPP_DEN', 'KAPP_DENw', .T.)
    ::cDenBlok := CDow( KAPP_DENw->dVyhotPlan)
  ENDIF

RETURN self

*
********************************************************************************
METHOD VYR_KAPP_DEN_CRD:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  IsEditGET( {'KAPP_DENw->nTydKapBlo',;
              'KAPP_DENw->nObdobi'   ,;
              'KAPP_DENw->nRokVytvor' }, drgDialog, .F.)
  /*
  IF UPPER( drgDialog:parent:formName) $ 'VYR_KALK_MZD'
    drgDialog:SetReadOnly( .T.)
  ENDIF
  */
RETURN self
*
********************************************************************************
METHOD VYR_KAPP_DEN_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
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
METHOD VYR_KAPP_DEN_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), cField := lower( drgParseSecond( cName, '>' ))
  LOCAL nRec, cMsg, cOznPrac
  *
  IF lValid
    cOznPrac   := ::dm:get( 'KAPP_DENw->cOznPrac')
    dVyhotPlan := ::dm:get( 'KAPP_DENw->dVyhotPlan')
    DO CASE
    CASE cName = 'KAPP_DENw->dVyhotPlan'
      IF( lOK := ControlDUE( oVar, .t.) )
        ::dm:set( 'M->cDenBlok'          , ::cDenBlok := CDow( xVar)  )
        ::dm:set( 'KAPP_DENw->nTydKapBlo', mh_WeekOfYear( xVar) )
        ::dm:set( 'KAPP_DENw->nObdobi'   , Month( xVar) )
        ::dm:set( 'KAPP_DENw->nRokVytvor', Year(xVar) )

        IF ::lNewRec .and. !EMPTY( cOznPrac)
          cKey := DTOS( xVar) + Upper( cOznPrac)
          IF KAPP_DEN->( dbSeek( cKey,, 'KAPL_1'))
            cMsg := 'DUPLICITA !;; Na tento den + pracoviötÏ jiû byla kapacita zad·na !'
            drgMsgBox(drgNLS:msg( cMsg))
          ENDIF
        ENDIF
      ENDIF

    CASE cName = 'KAPP_DENw->cOznPrac'
      IF( lOK := ControlDUE( oVar, .t.) )
        IF ::lNewRec .and. !EMPTY( DTOS( dVyhotPlan))
          cKey := DTOS( dVyhotPlan) + Upper( xVar)
          IF KAPP_DEN->( dbSeek( cKey,, 'KAPL_1'))
            cMsg := 'DUPLICITA !;; Na tento den + pracoviötÏ jiû byla kapacita zad·na !'
            drgMsgBox(drgNLS:msg( cMsg))
            lOK := .F.
          ENDIF
        ENDIF
      ENDIF

    CASE cField $ 'npracodoba,npocetstro,npocsmen'
      ::dm:set( 'KAPP_DENw->nKapacNhod', ::dm:get('KAPP_DENw->nPracoDoba') * ;
                                         ::dm:get('KAPP_DENw->nPocetStro') * ::dm:get('KAPP_DENw->nPocSmen') )
      ::dm:set( 'KAPP_DENw->nVolnaKapa', ::dm:get('KAPP_DENw->nKapacNhod') - ::dm:get('KAPP_DENw->nBlokaceNh'))

    CASE cField $ 'nkapacnhod,nblokacenh'
      ::dm:set( 'KAPP_DENw->nVolnaKapa', ::dm:get('KAPP_DENw->nKapacNhod') - ::dm:get('KAPP_DENw->nBlokaceNh'))
    ENDCASE
  ENDIF
  */
RETURN lOK

*
*******************************************************************************
METHOD VYR_KAPP_DEN_CRD:OnSave(lIsCheck,lIsAppend,drgDialog)
  LOCAL nREC

    IF ! ::drgDialog:dialogCtrl:isReadOnly
*      ::dm:save()
      ::drgDialog:dataManager:save()
      IF( ::lNewREC, KAPP_DEN->( DbAppend()), Nil )
      IF KAPP_DEN->(sx_RLock())
         mh_COPYFLD('KAPP_DENw', 'KAPP_DEN' )
  *       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
         nREC := KAPP_DEN->( RecNo())
         KAPP_DEN->( dbUnlock())
         nREC := KAPP_DEN->( RecNo())
*         ::drgDialog:parent:dialogCtrl:oaBrowse:refresh()
      ENDIF
    ENDIF
*
RETURN .T.

*
*******************************************************************************
METHOD VYR_KAPP_DEN_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC      :=  ;
  ::dm           :=  Nil

  KAPP_DENw->( dbCloseArea())
RETURN self


/*****************************************************************
* VYR_PRACOV_SEL ... V˝bÏr z ËÌselnÌku pracoviöù
*****************************************************************
CLASS VYR_PRACOV_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  getForm

HIDDEN:
  VAR     drgGet
  METHOD  doAppend
ENDCLASS

*
*****************************************************************
METHOD VYR_PRACOV_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  *

RETURN self

*
**********************************************************************
METHOD VYR_PRACOV_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
     ::doAppend()
  CASE nEvent = drgEVENT_FORMDRAWN
  CASE nEvent = drgEVENT_DELETE

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
METHOD VYR_PRACOV_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .T.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

*
********************************************************************************
METHOD VYR_PRACOV_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF( .not. C_PRACOV->(DbSeek(::drgGet:oVar:value,,'C_PRAC1')), C_PRACOV->(DbGoTop()), NIL )
    drgDialog:dialogCtrl:browseRefresh()
  ENDIF
RETURN self

*
********************************************************************************
METHOD VYR_PRACOV_SEL:doAppend()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_PRACOV_CRD', ::drgDialog)
  oDialog:cargo := drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
*    ::OnSave(,, oDialog )
    oDialog:dataManager:save()
    IF( oDialog:dialogCtrl:isAppend, C_PRACOV->( DbAppend()), Nil )
    IF C_PRACOV->(sx_RLock())
       mh_COPYFLD('C_PRACOVw', 'C_PRACOV' )
       C_Pracov->cOznPracN  := C_Pracov->cOznPrac
*       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
       nREC := C_Pracov->( RecNo())
       C_PRACOV->( dbUnlock())
       nREC := C_Pracov->( RecNo())
       ::drgDialog:dialogCtrl:browseRefresh()
    ENDIF

  ENDIF
  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.

*
********************************************************************************
METHOD VYR_PRACOV_SEL:getForm()
  LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 55, 14 DTYPE '10' TITLE 'Seznam pracoviöù - V›BÃR' ;
                                            FILE 'C_PRACOV'                   ;
                                            GUILOOK 'All:N,Border:Y'
  DRGTEXT INTO drgFC CAPTION 'Vyber poûadovanÈ pracoviötÏ ... ' CPOS 0,13 CLEN 55 PP 2 BGND 15

  DRGBROWSE INTO drgFC SIZE 55,13 ;
                       FIELDS 'cOznPrac, cNazevPrac, cNazPol4'  ;
                       INDEXORD 1 SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC

*/