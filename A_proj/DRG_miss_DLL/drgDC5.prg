////////////////////////////////////////////////////////////////////
//
//  drgDC5.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//  Implementation of dialog controller with editable browser.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

CLASS drgDC5 FROM drgDialogController
EXPORTED:
  VAR     lastDrgEvent

  METHOD  destroy
  METHOD  eventHandled
  METHOD  browseInFocus

  METHOD  postValidateField
  METHOD  postValidateForm

  METHOD  browseRowIn
  METHOD  browseRowOut
  METHOD  browseRowPre
  METHOD  browseRowPost
  METHOD  browseRowDelete
  METHOD  browseRowAppend
ENDCLASS

****************************************************************************
* Browser informs that new row has been entered.
****************************************************************************
METHOD drgDC5:browseRowIn()
  ::isAppend := ::lastDrgEvent = drgEVENT_APPEND .OR. ;
                ::lastDrgEvent = drgEVENT_APPEND2
  ::evalBlock(::oBrowse:cbBrowseRowIn, ::oBrowse)
RETURN .T.

****************************************************************************
* Browser informs that row has been left.
****************************************************************************
METHOD drgDC5:browseRowOut()
  ::evalBlock(::oBrowse:cbBrowseRowOut, ::oBrowse)
RETURN .T.

****************************************************************************
* Row is to be (or was) deleted.
****************************************************************************
METHOD drgDC5:browseRowDelete(isBefore)
RETURN ::evalBlock(::oBrowse:cbBrowseRowDelete, isBefore, ::oBrowse)

****************************************************************************
* New row has been appended.
****************************************************************************
METHOD drgDC5:browseRowAppend()
  ::evalBlock(::oBrowse:cbBrowseRowAppend, ::oBrowse)
RETURN .T.

****************************************************************************
* Browser postValidate row callback.
****************************************************************************
METHOD drgDC5:browseRowPost()
RETURN ::evalBlock(::oBrowse:cbBrowseRowPost, ::oBrowse)

****************************************************************************
* Browser preValidate row callback.
****************************************************************************
METHOD drgDC5:browseRowPre()
RETURN ::evalBlock(::oBrowse:cbBrowseRowPre, ::oBrowse)

****************************************************************************
* Dialog controller no.5 specific events handler.
****************************************************************************
METHOD drgDC5:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL data, nXbp

* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Quit event should be handled separately
*  IF nEvent = xbeP_Close
*    RETURN .F.
*  ENDIF

* Non DRG events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  ENDIF

***********************************
* Handle action events
***********************************
  IF nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp, self)
    RETURN .T.
  ELSEIF nEvent = drgEVENT_PRINT
    ::drgDialogPrint()
    RETURN .T.
  ELSEIF nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    RETURN .T.
  ENDIF

* Edit browser is not in focus. No use of handeling events
  IF !::browseInFocus()
    RETURN .F.
  ENDIF

  DO CASE
***********************************************************
  CASE nEvent = drgEVENT_APPEND .OR. nEvent = drgEVENT_APPEND2
*    ::isAppend := .T.
* First postvalidate last edited object
    (::dbArea)->( DBGOTO(::oBrowse:lastRecNO) )
    IF !::isReadOnly .AND. ::oBrowse:postValidateCell(.T.)
* Save last edited oXbp
      ::oBrowse:saveEdited()
      IF ::oBrowse:postValidateRow()
        ::oBrowse:saveEditRow()
* Copy record if APPEND2
        IF nEvent = drgEVENT_APPEND2
          data := (::dbArea)->( drgScatter() )
          (::dbArea)->( DBAPPEND() )
          (::dbArea)->( drgGather(data) )
        ELSE
          (::dbArea)->( DBAPPEND() )
        ENDIF
        ::browseRowAppend()

        ::oBrowse:loadEditRow()
        ::oBrowse:lastRow2Bottom(.T.)
        ::oBrowse:startEdit(.T.)
      ENDIF
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly .AND. drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
* Ask UDCP IF ok to delete
      IF ::browseRowDelete(.T.)
        IF (::dbArea)->( drgLockOK() )
          (::dbArea)->( DBDELETE() )
          (::dbArea)->( DBUNLOCK() )
* Record deleted. Anything else to do
          ::browseRowDelete(.F.)
* When all records are deleted, new blank record must be appended
          ::oBrowse:lastRecNO := (::dbArea)->( RECNO() )
          (::dbArea)->( DBGOTOP() )
          IF (::dbArea)->( EOF() )
* Post record append event if file is empty
            PostAppEvent(drgEVENT_APPEND,,,::oBrowse:oXbp)
            RETURN .T.
          ELSE
            (::dbArea)->( DBGOTO( ::oBrowse:lastRecNO ) )
          ENDIF

*          ::oBrowse:oXbp:refreshAll()                 // also refreshes file POS
*          ::oBrowse:refresh(.T.)                       // also refreshes file POS
          ::oBrowse:loadEditRow()
          ::oBrowse:startEdit(.T.)
        ENDIF
      ENDIF
    ENDIF

***********************************************************
* Let the editBrowse do all movement stuff
***********************************************************
  CASE nEvent = drgEVENT_NEXT
    PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oBrowse:oXbp)

***********************************************************
  CASE nEvent = drgEVENT_PREV
    PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oBrowse:oXbp)

***********************************************************
  CASE nEvent = drgEVENT_TOP
    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oBrowse:oXbp)

***********************************************************
  CASE nEvent = drgEVENT_BOTTOM
    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oBrowse:oXbp)

* Edit has no meaning
***********************************
  CASE nEvent = drgEVENT_EDIT

***********************************************************
  CASE nEvent = drgEVENT_SAVE
* Save IF changed and data entered is OK
    IF !::isReadOnly .AND. ::drgDialog:dataManager:changed() .AND. ::oBrowse:postValidateRow()
      ::oBrowse:saveEditRow()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EXIT
    IF ::drgDialog:dataManager:changed()
      IF !::isReadOnly .AND. ::oBrowse:postValidateRow()
        ::oBrowse:saveEditRow()
        PostAppEvent(xbeP_Close, nEvent,,oXbp)
      ENDIF
    ELSE
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_FORMDRAWN
    (::dbArea)->( DBGOTOP() )
    IF (::dbArea)->( EOF() )
       PostAppEvent(drgEVENT_APPEND,,,oXbp)
    ENDIF
    RETURN .F.              // must be processed somewhere else

***********************************************************
  OTHERWISE
    RETURN .F.
  ENDCASE

  ::lastDrgEvent := nEvent
RETURN .T.

***********************************************************************
* Postvalidate form method. Called on action event.
***********************************************************************
METHOD drgDC5:postValidateForm()
RETURN ::oBrowse:postValidateRow()

***********************************************************************
* Postvalidate field method. Called on action event.
***********************************************************************
METHOD drgDC5:postValidateField()
RETURN ::oBrowse:postValidateCell()

***********************************************************************
* Check if editBrowser is in focus.
***********************************************************************
METHOD drgDC5:browseInFocus()
* this is done by asking form object for active oDrg
RETURN ::drgDialog:oForm:oLastDrg = ::oBrowse

***********************************************************************
* Clean up
***********************************************************************
METHOD drgDC5:destroy()
  ::drgDialogController:destroy()

  ::lastDrgEvent   := ;
                NIL
RETURN

