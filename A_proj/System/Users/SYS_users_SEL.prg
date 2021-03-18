********************************************************************************
*
* SYS_USERS_SEL.PRG    .... Do SYS
*
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


********************************************************************************
* SYS_USERS_SEL ...
********************************************************************************
CLASS SYS_users_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  EventHandled
  METHOD  itemMarked
  METHOD  itemSelected

ENDCLASS

*
********************************************************************************
METHOD SYS_users_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('USERS')
  users->( dbSeek(usrName,, AdsCtag(1) ))
RETURN self

*
********************************************************************************
METHOD SYS_users_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

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
METHOD SYS_users_SEL:itemMarked()

RETURN self


*
********************************************************************************
METHOD SYS_users_SEL:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

RETURN self