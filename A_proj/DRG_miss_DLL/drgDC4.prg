////////////////////////////////////////////////////////////////////
//
//  drgDC4.PRG
//
//  Copyright:
//    DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//    Implementation of controller with multiple browsers.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

CLASS drgDC4 FROM drgDialogController
EXPORTED:
  VAR     aData

  METHOD  init

  METHOD  eventHandled
  METHOD  registerBrowser
  METHOD  browseInFocus

ENDCLASS

*********************************************************************
*********************************************************************
METHOD drgDC4:init(oParent)
  ::drgDialogController:init(oParent)
  ::oBrowse := {}
RETURN self

***********************************************************************
* Check if browser is in focus
***********************************************************************
METHOD drgDC4:browseInFocus()
RETURN ASCAN( ::oBrowse, {|x| ::drgDialog:oForm:oLastDrg = x} )

*********************************************************************
* Register drgBrowse object. Basic controler can handle only single browser and \
* will set primary dataArea.
*
* \bParameters:b\
* \b< oDrgBrowse >b\    : drgBrowse : object of type drgBrowse to register.
*********************************************************************
METHOD drgDC4:registerBrowser(oDrgBrowse)
  AADD(::oBrowse, oDrgBrowse)
RETURN self

****************************************************************************
****************************************************************************
METHOD drgDC4:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL n
* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Non drg events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  ENDIF

* Handle action events
  DO CASE
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
*    IF ::browseInFocus()
*      ::drgDialogFind()
*    ENDIF

* Browser movement if browser in focus.
  CASE nEvent = drgEVENT_NEXT
    IF ( n := ::browseInFocus() ) > 0
      PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oBrowse[n]:oXbp)
      ::oBrowse[n]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_PREV
    IF ( n := ::browseInFocus() ) > 0
      PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oBrowse[n]:oXbp)
      ::oBrowse[n]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_TOP
    IF ( n := ::browseInFocus() ) > 0
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oBrowse[n]:oXbp)
      ::oBrowse[n]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_BOTTOM
    IF ( n := ::browseInFocus() ) > 0
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oBrowse[n]:oXbp)
      ::oBrowse[n]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_SAVE
    ::drgDialog:dataManager:save()
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  CASE nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.



