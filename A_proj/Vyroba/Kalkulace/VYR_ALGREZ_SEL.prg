***************************************************************************
*
* VYR_ALGREZ_SEL.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*****************************************************************
* VYR_ALGREZ_SEL ...
*****************************************************************
CLASS VYR_ALGREZ_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  getForm

HIDDEN:
  VAR  drgGet
ENDCLASS

*
*****************************************************************
METHOD VYR_ALGREZ_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
RETURN self

*
**********************************************************************
METHOD VYR_ALGREZ_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
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
METHOD VYR_ALGREZ_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

*
********************************************************************************
METHOD VYR_ALGREZ_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF( .not. C_ALGREZ ->(DbSeek(::drgGet:oVar:value,,'C_ALGREZ1')), C_ALGREZ ->(DbGoTop()), NIL )
    drgDialog:dialogCtrl:browseRefresh()
  ENDIF
RETURN self

*
********************************************************************************
METHOD VYR_ALGREZ_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75, 8 DTYPE '10' TITLE 'Algoritmy rozpouštìní režií - VÝBÌR' ;
                                           FILE 'C_ALGREZ'                   ;
                                           GUILOOK 'All:N,Border:Y'

  DRGBROWSE INTO drgFC SIZE 75,7.8 ;
                       FIELDS 'nAlgRezie, cPopisAlg'  ;
                       SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC
