
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*****************************************************************
* VYR_VYRPOL_se_SEL ...
*****************************************************************
CLASS VYR_VYRPOL_se_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
  METHOD  doAppend

  inline method drgDialogStart(drgDialog)

    ::brow := drgDialog:dialogCtrl:oBrowse[1]:oxbp

    if ::nsid_vyrPol <> 0
      vyrPol_s->( dbseek( ::nsid_vyrPol,,'ID' ))
    endif
  return self

  var     nsid_vyrPol, brow
ENDCLASS

*****************************************************************
METHOD VYR_VYRPOL_se_SEL:init(parent)

  ::drgUsrClass:init(parent)
  ::nsid_vyrPol :=  if( isNumber(parent:cargo_usr), parent:cargo_usr, 0 )
RETURN self

**********************************************************************
METHOD VYR_VYRPOL_se_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
*  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    ::doAppend( nEvent)

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

********************************************************************************
METHOD VYR_VYRPOL_se_SEL:doAppend( nEvent)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_VYRPOL_CRD', ::drgDialog)
  oDialog:cargo := nEvent   // drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  ::drgDialog:dialogCtrl:refreshPostDel()

  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.