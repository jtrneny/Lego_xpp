***************************************************************************
* VYR_VYRZAK_SEL.PRG
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*****************************************************************
* VYR_VYRZAK_SEL ...
*****************************************************************
CLASS VYR_VYRZAK_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
  METHOD  RecordSelected
  METHOD  VyrZAKAZKY
ENDCLASS

*****************************************************************
METHOD VYR_VYRZAK_SEL:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

**********************************************************************
METHOD VYR_VYRZAK_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    ::recordSelected()

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
*****************************************************************
METHOD VYR_VYRZAK_SEL:RecordSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN SELF

*
*****************************************************************
METHOD VYR_VYRZAK_SEL:VyrZAKAZKY()
  DRGDIALOG FORM 'VYR_VYRZAK_SCR' PARENT ::drgDialog DESTROY
RETURN self

* VYR_VYRZAKIT_SEL ...
*****************************************************************
CLASS VYR_VYRZAKIT_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
ENDCLASS

*****************************************************************
METHOD VYR_VYRZAKIT_SEL:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

**********************************************************************
METHOD VYR_VYRZAKIT_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
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

