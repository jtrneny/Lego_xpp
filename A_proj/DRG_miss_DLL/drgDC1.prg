////////////////////////////////////////////////////////////////////
//
//  drgDC1.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//    Implementation of dialog controller with browser and separated dialog window.
//    Secondary edit dialog window is created from primary browser dialog.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "Set.ch"

****************************************************************************
CLASS drgDC1 FROM drgDialogController
EXPORTED:
  VAR     isChild

  METHOD  eventHandled
  METHOD  chkDuplicates
  METHOD  editData

ENDCLASS

****************************************************************************
****************************************************************************
METHOD drgDC1:eventHandled(nEvent, mp1, mp2, oXbp)

* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Non drg events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  ENDIF

  DO CASE
* Handle action events
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
    IF ::browseInFocus()
      ::drgDialogFind()
      ::browseRefresh()
    ENDIF

*************************************************************
* Mark all records changed when append with copy is selected
  CASE nEvent = drgEVENT_FORMDRAWN
    ::isChild := EMPTY(::drgDialog:formHeader:cargo)
    IF ::isChild
      IF ::drgDialog:cargo = drgEVENT_APPEND2
        ::drgDialog:dataManager:markChanged( ALIAS() + '->' )
      ENDIF
      ::isAppend  := ::drgDialog:cargo != drgEVENT_EDIT
    ENDIF
    RETURN .F.                      // Must also be processed in drgDialog

***********************************************************
  CASE nEvent = drgEVENT_NEXT
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oBrowse:oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_PREV
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oBrowse:oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_TOP
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oBrowse:oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_BOTTOM
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oBrowse:oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EDIT
    IF !::isChild .AND. ::browseInFocus() .AND. !(::dbArea)->( EOF() )
      ::editData(nEvent)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND .OR. ;
       nEvent = drgEVENT_APPEND2
    IF !::isChild .AND. ::browseInFocus()
      ::editData(nEvent)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly .AND. ::browseInFocus()
      IF drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
* Ask user function IF ok to delete
        IF ::evalBlock(::cbDelete, .T.)
          IF ::deleteRecord()
* Record deleted. Anything else to do
            ::evalBlock(::cbDelete, .F.)
          ENDIF
        ENDIF
      ENDIF
* coursor reposition
    (::dbArea)->( DBSKIP(-1) )
    IF (::dbArea)->( RECNO() ) = 0
      (::dbArea)->( DBGOTOP() )
    ENDIF
    ::browseRefresh()
  ENDIF

* EXIT, SAVE and QUIT are treated equaly
***********************************************************
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_SAVE .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ::isChild := NIL

* Not processed
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

***********************************************************************
* Creates new drgDialog. Dialog name is defined by cargo value in dialogs form header.
***********************************************************************
METHOD drgDC1:editData(nEvent)
LOCAL aDialog, aData
* Don't want to have runtime error
  IF EMPTY(::drgDialog:formHeader:cargo)
    drgMsg(drgNLS:msg('Edit dialog not defined!'),,::drgDialog)
    RETURN .F.
  ENDIF
*
  ::browseRefresh()                              // will refresh last data
  ::isAppend  := nEvent != drgEVENT_EDIT
*
  ::drgDialog:pushArea()                          // save current workarea
  ::lastRECNO := (::dbArea)->( RECNO() )          // save current RECNO
  aData       := (::dbArea)->( drgScatter() )     // save current record
* Appending empty record. Goto RECNO 0 and fill with empty values
  IF nEvent = drgEVENT_APPEND
    (::dbArea)->( DBGOTO(-1) )
  ENDIF
  ::evalBlock(::cbLoad, ::isAppend)               // evaluate usr LOAD block
* Create edit dialog
  aDialog := drgDialog():new(::drgDialog:formHeader:cargo, ::drgDialog)
  aDialog:cargo := nEvent                         // interchange parameter
  aDialog:create(,,.T.)

  ::drgDialog:popArea()                           // restore AREA
  (::dbArea)->( DBGOTO(::lastRECNO) )             // restore RECNO
* Save or EXIT was selected and not readonly
  IF !( ::isReadOnly .OR. aDialog:exitState = drgEVENT_QUIT)
    IF ::evalBlock(::cbSave, .T., ::isAppend)
      IF ::isAppend
        ::appendBlankRecord()
      ELSE
* Check if data was changed during edit session
        IF drgArrayDif(aData, (::dbArea)->( drgScatter() ) ) .AND. !drgIsYesNO( drgNLS:msg( ;
          'Another user has changed record while record was edited!;;' + ;
          'Save data anyway?;;' + ;
          'Select YES to save your data.;' + ;
          'Select NO to retain current data.'),,XBPMB_WARNING )
* Return IF NO was selected
          aDialog:destroy()
          aDialog := NIL
          RETURN self
        ENDIF
      ENDIF
* Save
      IF (::dbArea)->( drgLockOK() )
        aDialog:dataManager:save()                  // will save data to file
        ::evalBlock(::cbSave, .F., ::isAppend)      // evaluate usr SAVE block
        (::dbArea)->( DBUNLOCK() )
      ENDIF
* Refresh browser
      (::dbArea)->( DBCOMMIT() )
      IF ::isAppend
        ::oBrowse:lastRow2Bottom()
      ELSE
        ::browseRefresh()
      ENDIF
    ENDIF
  ENDIF
* Clean UP
  aDialog:destroy()
  aDialog := NIL
RETURN self

***********************************************************************
* Checks for duplicate records.
***********************************************************************
METHOD drgDC1:chkDuplicates(isAppend)
/*
  ::drgDialog:pushArea()


  ::drgDialog:popArea()
*/
RETURN .T.

