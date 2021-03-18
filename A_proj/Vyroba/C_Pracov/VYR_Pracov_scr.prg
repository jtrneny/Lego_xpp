/*==============================================================================
  VYR_Pracov_scr.PRG
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
*
********************************************************************************
CLASS VYR_Pracov_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled

ENDCLASS

*
********************************************************************************
METHOD VYR_Pracov_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('cNazPol4' )
RETURN self

*
********************************************************************************
METHOD VYR_Pracov_SCR:drgDialogStart(drgDialog)

  C_PRACOV->( DbSetRelation( 'cNazPol4' , {|| Upper(C_PRACOV->cNazPol4) } ,'Upper(C_PRACOV->cNazPol4)'))
  C_PRACOV->( DbSetRelation( 'C_Stred'  , {|| Upper(C_PRACOV->cStred) }   ,'Upper(C_PRACOV->cStred)'))
  C_PRACOV->( DbSetRelation( 'C_PracZa' , {|| Upper(C_PRACOV->cPracZar) } ,'Upper(C_PRACOV->cPracZar)'))
  C_PRACOV->( DbSetRelation( 'DruhyMzd' , {|| C_PRACOV->nDruhMzdy },'C_PRACOV->nDruhMzdy'))
RETURN self

*
********************************************************************************
METHOD VYR_Pracov_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      IF drgIsYESNO(drgNLS:msg( 'Zruöit vybranÈ pracoviötÏ < & >  ?' , C_PRACOV->cOznPrac) )
        If C_PRACOV->( sx_RLock())
          C_PRACOV->( DbDelete(), DbUnlock() )
          oXbp:cargo:refresh()
        ENDIF
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
RETURN .T.

********************************************************************************
*
********************************************************************************
CLASS VYR_PRACOV_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  OnSave

HIDDEN
  VAR dm

ENDCLASS

*
********************************************************************************
METHOD VYR_PRACOV_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)

  drgDBMS:open('C_PRACOVw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF ::lNewREC
    C_PRACOVw->(dbAppend())
    C_PRACOVw->nViceStroj := 1
    C_PRACOVw->nKoefViSt  := 1
    C_PRACOVw->nViceObslu := 1
    C_PRACOVw->nKoefViOb  := 1
    C_PRACOVw->nKoefSmCas := 1
  ELSE
    mh_COPYFLD('C_PRACOV', 'C_PRACOVw', .T.)
  ENDIF

RETURN self

*
********************************************************************************
METHOD VYR_PRACOV_CRD:drgDialogStart(drgDialog)

  ::dm := ::drgDialog:dataManager
  *
  IF UPPER( drgDialog:parent:formName) $ 'VYR_KALK_MZD'
    drgDialog:SetReadOnly( .T.)
  ENDIF
RETURN self
*
********************************************************************************
METHOD VYR_PRACOV_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

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
METHOD VYR_PRACOV_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cNAMe := UPPER(oVar:name), nRec, cMsg

  IF lValid
    DO CASE
    CASE cName = 'C_PRACOVw->cOznPrac'
      IF( lOK := ControlDUE( oVar) )
        nRec := C_PRACOV->( RecNo())
        IF ( lOK := C_PRACOV->( dbSeek( xVar)) )
          cMsg := 'DUPLICITA !;; PracoviötÏ s tÌmto oznaËenÌm jiû existuje !'
          drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
        ENDIF
        C_PRACOV->( dbGoTo( nRec))
        lOK := !lOK
        IF( lOK, ::dm:set( 'C_PRACOVw->cOznPrac', xVar ), NIL )
      ENDIF

    CASE cName = 'C_PRACOVw->nViceStroj'
      ::dm:set( 'C_PRACOVw->nKoefViSt',  1 / xVar )

    CASE cName = 'C_PRACOVw->nViceObslu'
      ::dm:set( 'C_PRACOVw->nKoefViOb', xVar )

    ENDCASE
  ENDIF
RETURN lOK

*
*******************************************************************************
METHOD VYR_PRACOV_CRD:OnSave(lIsCheck,lIsAppend,drgDialog)
  LOCAL nREC

    IF ! ::drgDialog:dialogCtrl:isReadOnly
*      ::dm:save()
      ::drgDialog:dataManager:save()
      IF( ::lNewREC, C_PRACOV->( DbAppend()), Nil )
      IF C_PRACOV->(sx_RLock())
         mh_COPYFLD('C_PRACOVw', 'C_PRACOV' )
         C_Pracov->cOznPracN  := C_Pracov->cOznPrac
  *       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
         nREC := C_Pracov->( RecNo())
         C_PRACOV->( dbUnlock())
         nREC := C_Pracov->( RecNo())
*         ::drgDialog:parent:dialogCtrl:oaBrowse:refresh()
      ENDIF
    ENDIF
*/
RETURN .T.

*
*******************************************************************************
METHOD VYR_PRACOV_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC      :=  ;
  ::dm           :=  Nil

  C_PRACOVw->( dbCloseArea())
RETURN self

*****************************************************************
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
//    ::drgGet := oXbp:cargo
    ::drgGet := if( oxbp:cargo:className() = 'drgGet', oxbp:cargo, nil )
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