////////////////////////////////////////////////////////////////////
//
//  drgDC6.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//  Implementation of dialog controller for wizard type of dialogs.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

CLASS drgDC6 FROM drgDialogController
EXPORTED:
  VAR     nPage
  VAR     nMaxPage
  VAR     cbOnNext
  VAR     cbOnPrev
  VAR     cbOnCreate

  METHOD  init
  METHOD  eventHandled
  METHOD  setDisabledActions
  METHOD  showTabPage

ENDCLASS

*********************************************************************
*********************************************************************
METHOD drgDC6:init(oParent)
  ::drgDialog := oParent
  ::members   := {}

  ::cbOnNext   := ::drgDialog:getMethod('onNext')
  ::cbOnPrev   := ::drgDialog:getMethod('onPrev')
  ::cbOnCreate := ::drgDialog:getMethod('onCreate')
RETURN self

***********************************************************************
* Set disabled actions on a dialog. Called when dialog is started.
*
* \bParameters:b\
* \b< oActionManager >b\   :object : dialogs drgActionManager object
***********************************************************************
METHOD drgDC6:setDisabledActions(oActionManager)
  oActionManager:disableActions( {drgEVENT_PREV, drgEVENT_EXIT} )
* Initialize page number
  ::nPage := 1
RETURN

****************************************************************************
* Event handled method for this type of controller.
****************************************************************************
METHOD drgDC6:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL nNext

* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Non drg events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  ENDIF


*  drgDump(::nPage,'::nPage')
*  drgDump(::nMaxPage,'::nMaxPage')
*  drgDump(nEvent,'nEvent')
  DO CASE
* Handle action events
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

***********************************************************
* NEXT
***********************************************************
  CASE nEvent = drgEVENT_NEXT  .AND. ::nPage < ::nMaxPage
    IF ( nNext := ::evalBlock(::cbOnNext, ::nPage) ) > 0            // Check IF OK continue
      ::nPage := nNext
      ::showTabPage()
    ENDIF
*    drgDump(nNext,'nNext')

***********************************************************
* PREVIOUS
***********************************************************
  CASE nEvent = drgEVENT_PREV .AND. ::nPage > 1
    IF ( nNext := ::evalBlock(::cbOnPrev, ::nPage) ) > 0           // Check IF OK continue
      ::nPage := nNext
      ::showTabPage()
    ENDIF

* BOTTOM reached
***********************************************************
  CASE nEvent = drgEVENT_BOTTOM
    ::drgDialog:oForm:setNextFocus(LEN(::drgDialog:oForm:aMembers) - 4)
*    PostAppEvent(drgEVENT_OBJEXIT,,,::drgDialog:dialog)

* Post record append event if table is empty
***********************************************************
  CASE nEvent = drgEVENT_FORMDRAWN
    ::nMaxPage := LEN(::drgDialog:oForm:tabPageManager:members)
    RETURN .F.

***********************************************************
  CASE nEvent = drgEVENT_SAVE
* Call create callback and close dialog if OK
    IF ::evalBlock(::cbOnCreate)
      ::drgDialog:dataManager:save()
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

* Not processed
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

***********************************************************************
* Ensures that selected tabPage is displayed and moves coursor to the first \
* field on the tabPage.
***********************************************************************
METHOD drgDC6:showTabPage()
LOCAL oDrg, aEnable, aDisable, n
* Enable disable action butttons
  DO CASE
  CASE ::nPage = 1
    aDisable := {drgEVENT_PREV}
    aEnable  := {drgEVENT_NEXT}
  CASE ::nPage = ::nMaxPage
    aEnable  := {drgEVENT_EXIT, drgEVENT_PREV}
    aDisable := {drgEVENT_NEXT}
  OTHERWISE
    aEnable  := {drgEVENT_NEXT, drgEVENT_PREV}
  ENDCASE
*
  IF !EMPTY(aDisable)
    ::drgDialog:actionManager:disableActions(aDisable)
  ENDIF
  IF !EMPTY(aEnable)
    ::drgDialog:actionManager:enableActions(aEnable)
  ENDIF
* Display proper page
  oDrg := ::drgDialog:oForm:tabPageManager:members[::nPage]
  n := ASCAN( ::drgDialog:oForm:aMembers, {|e| oDrg = e} )
  n++
  ::drgDialog:oForm:tabPageManager:showPage(::nPage)
  ::drgDialog:oForm:setNextFocus(n)
* This will ensure that first object will get focus
  PostAppEvent(drgEVENT_OBJEXIT,,,::drgDialog:dialog)
RETURN .T.


