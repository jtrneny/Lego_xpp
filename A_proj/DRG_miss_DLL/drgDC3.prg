////////////////////////////////////////////////////////////////////
//
//  drgDC3.PRG
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

CLASS drgDC3 FROM drgDialogController
EXPORTED:
  VAR     lastDrgEvent
  VAR     aData
  VAR     aKeyList

  METHOD  init
  METHOD  destroy
  METHOD  eventHandled

  METHOD  postValidateField
  METHOD  postValidateForm

  METHOD  browseRowIn
  METHOD  browseRowOut
  METHOD  browseRowPre
  METHOD  browseRowPost
  METHOD  browseRowDelete
  METHOD  browseRowAppend
  METHOD  ok2CloseDialog
  METHOD  validateDupKeys
  METHOD  undoRecordOperation
ENDCLASS

****************************************************************************
****************************************************************************
METHOD drgDC3:init(parent)
  ::drgDialogController:init(parent)
RETURN self

****************************************************************************
* Browser informs that new row has been entered.
****************************************************************************
METHOD drgDC3:browseRowIn()
  ::isAppend := ::lastDrgEvent = drgEVENT_APPEND .OR. ;
                ::lastDrgEvent = drgEVENT_APPEND2
  ::validateDupKeys(2)                            // load key values
  ::aData := drgScatter()                         // load initial record values
  ::evalBlock(::oBrowse:cbBrowseRowIn, ::oBrowse)
RETURN .T.

****************************************************************************
* Browser informs that row has been left.
****************************************************************************
METHOD drgDC3:browseRowOut()
  ::evalBlock(::oBrowse:cbBrowseRowOut, ::oBrowse)
RETURN .T.

****************************************************************************
* Row is to be (or was) deleted.
****************************************************************************
METHOD drgDC3:browseRowDelete(isBefore)
  IF isBefore
    IF ::evalBlock(::oBrowse:cbBrowseRowDelete, isBefore, ::oBrowse)
      ::deleteRecord()
    ELSE
      RETURN .F.
    ENDIF
  ELSE
    ::evalBlock(::oBrowse:cbBrowseRowDelete, isBefore, ::oBrowse)
  ENDIF
RETURN .T.

****************************************************************************
* New row has been appended.
****************************************************************************
METHOD drgDC3:browseRowAppend()
  ::evalBlock(::oBrowse:cbBrowseRowAppend, ::oBrowse)
RETURN .T.

****************************************************************************
* Browser postValidate row callback.
****************************************************************************
METHOD drgDC3:browseRowPost()
LOCAL lRet
  lRet := ::validateDupKeys(3) .AND. ;
          ::evalBlock(::oBrowse:cbBrowseRowPost, ::oBrowse)
RETURN lRet

****************************************************************************
* Browser preValidate row callback. Currently ignored.
****************************************************************************
METHOD drgDC3:browseRowPre()
LOCAL lRet
  lRet := ::evalBlock(::oBrowse:cbBrowseRowPre, ::oBrowse)
RETURN lRet

****************************************************************************
* Is it OK to close dialog. If record was just appended and no data was \
* entered it is probably not OK to close dialog. Checking must be done \
* to close dialog.
****************************************************************************
METHOD drgDC3:ok2CloseDialog()
LOCAL lOK
  IF (lOK := ::oBrowse:postValidateRow() )     // Post validate if can quit
    ::oBrowse:saveEditRow()
  ENDIF
RETURN lOK

****************************************************************************
* Undo the last record operation if operation was not confirmed.
****************************************************************************
METHOD drgDC3:undoRecordOperation()
  ::drgDialog:pushArea()
  SELECT(::dbArea)
* If record was appended, delete appended record
  IF ::isAppend
    ::deleteRecord()
    DBSKIP()
  ELSE
* Fill fields from aData array with values before record update
    IF drgLockOK()
      drgGather(::aData)
      DBUNLOCK()
    ENDIF
  ENDIF
  DBCOMMIT()
  ::oBrowse:loadEditRow()
  ::oBrowse:startEdit(.F.)
*
  ::drgDialog:popArea()
RETURN self

****************************************************************************
* Check for duplicate key values. If index key in a DB dictionary doesn't \
* allow duplicate values then record can't be added or modified. Method \
* implements three tasks, depending on parameter passed.
*
* /b< nWhat >b/ : numeric : Requested task number.
* 1. Collect duplicate keys
* 2. Fill values array with current key values
* 3. Check if key value has been changed
****************************************************************************
METHOD drgDC3:validateDupKeys(nWhat)
LOCAL o, n, bBlock, nRec, lRet := .T.

  IF nWhat = 1 .or. IsNull(::aKeyList)
    ::aKeyList := {}
* Create list of keys with not allowed duplicate values
    o := drgDBMS:getDBD(::oBrowse:cFile)
    FOR n := 1 TO LEN(o:indexDef)
* Add index number, description and definition to index list array
      IF !o:indexDef[n]:lDupKeys
        AADD( ::aKeyList,{n, o:indexDef[n]:cCaption, o:indexDef[n]:cIndexKey, ''} )
      ENDIF
    NEXT n
    RETURN lRet
  ENDIF
* Don't bother if all keys can have duplicate values
  IF LEN(::aKeyList) = 0
    RETURN .T.
  ENDIF
*
* Save active area and current record
  ::drgDialog:pushArea()
  SELECT(::dbArea)
  nRec := RECNO()

* Fill with values before editing
  IF nWhat = 2
    FOR n := 1 TO LEN(::aKeyList)
      AdsSetOrder(::aKeyList[n,1])
      bBlock := &('{ || ' + ::aKeyList[n,3] + '}')
      ::aKeyList[n, 4] := EVAL(bBlock)
    NEXT n
* Check for duplicate keys
  ELSEIF nWhat = 3
    FOR n := 1 TO LEN(::aKeyList)
      AdsSetOrder(::aKeyList[n,1])
      bBlock := &('{ || ' + ::aKeyList[n,3] + '}')
      o := EVAL(bBlock)
* If append, then check if key already exists
      IF ::isAppend
        IF DBSEEK(o,.F.) .AND. RECNO() != nRec
          drgMsgBox(drgNLS:msg('Data conflict! Index "&"!;;Duplicate value!',::aKeyList[n,2] ) )
          lRet := .F.
          EXIT
        ENDIF
* If edit. Check if key field values have been changed
      ELSE
        IF !(o == ::aKeyList[n,4] )
          drgMsgBox(drgNLS:msg('Data conflict! Index "&"!;;Index key value can not be changed!',::aKeyList[n,2] ) )
          lRet := .F.
          EXIT
        ENDIF
      ENDIF
    NEXT n
  ENDIF
* Restore active record and data area
  DBGOTO(nRec)
  ::drgDialog:popArea()
RETURN lRet

****************************************************************************
* Dialog controller no.5 specific events handler.
****************************************************************************
METHOD drgDC3:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL data

* Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Quit event should be handled separately
  IF nEvent = xbeP_Close
* IF not OK act as event was handled.
    IF !::ok2CloseDialog()
      IF drgIsYesNo(drgNLS:msg('Undo last record update operation?') )
        ::undoRecordOperation()
      ENDIF
      RETURN .T.
    ELSE
      RETURN .F.
    ENDIF
  ENDIF

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
  ELSEIF nEvent = drgEVENT_QUIT .OR. nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    RETURN .T.
  ENDIF

* Edit browser is not in focus. No use of handling events
  IF !::browseInFocus()
    RETURN .F.
  ENDIF
  ::lastDrgEvent := nEvent

  DO CASE
***********************************************************
  CASE nEvent = drgEVENT_APPEND .OR. nEvent = drgEVENT_APPEND2
*    ::isAppend := .T.
* First postvalidate last edited object
    (::dbArea)->( DBGOTO(::oBrowse:lastRecNO) )
    IF ::oBrowse:postValidateCell(.T.)
* Save last edited oXbp
      ::oBrowse:saveEdited()
      IF ::oBrowse:postValidateRow()
        ::oBrowse:saveEditRow()
* Copy record if APPEND2
        IF nEvent = drgEVENT_APPEND2
          data := (::dbArea)->( drgScatter() )
          ::appendBlankRecord()
          IF (::dbArea)->( drgLockOK() )
            (::dbArea)->( drgGather(data) )
            (::dbArea)->( DBUNLOCK() )
          ENDIF
        ELSE
          ::appendBlankRecord()
        ENDIF
        (::dbArea)->( DBCOMMIT() )
* Call record appended callback
        ::browseRowAppend()

        ::oBrowse:loadEditRow()
        ::oBrowse:lastRow2Bottom(.T.)
        ::oBrowse:startEdit(.T.)
      ENDIF
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly .AND. drgIsYESNO(drgNLS:msg('Delete record!;; Are you sure?') )
* Ask user function IF ok to delete
      IF ::browseRowDelete(.T.)
        IF ::deleteRecord()
* Record deleted. Anything else to do
          ::browseRowDelete(.F.)
          (::dbArea)->( DBSKIP() )
          ::oBrowse:lastRecNO := (::dbArea)->( RECNO() )
* When all records are deleted, new blank record must be appended
          (::dbArea)->( DBGOTOP() )
          IF (::dbArea)->( EOF() )
* Post record append event if file is empty
            PostAppEvent(drgEVENT_APPEND,,,::oBrowse:oXbp)
            RETURN .T.
          ELSE
* Return to saved record number
            (::dbArea)->( DBGOTO( ::oBrowse:lastRecNO ) )
          ENDIF
* Load new edited row
          ::oBrowse:loadEditRow()
          ::oBrowse:startEdit(.F.)
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
    IF ::oBrowse:postValidateRow()
      ::oBrowse:saveEditRow()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EXIT
      IF ::oBrowse:postValidateRow()
        ::oBrowse:saveEditRow()
        PostAppEvent(xbeP_Close, nEvent,,oXbp)
      ENDIF

***********************************************************
  CASE nEvent = drgEVENT_FORMDRAWN
    ::validateDupKeys(1)          // load key values
* IF empty append record
    (::dbArea)->( DBGOTOP() )
    IF (::dbArea)->( EOF() )
       PostAppEvent(drgEVENT_APPEND,,,oXbp)
    ENDIF
    RETURN .F.              // must be processed somewhere else

***********************************************************
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

***********************************************************************
* Postvalidate form method. Called when action event is lounched.
***********************************************************************
METHOD drgDC3:postValidateForm()
RETURN ::oBrowse:postValidateRow()

***********************************************************************
* Postvalidate field method. Called when action event is lounched.
***********************************************************************
METHOD drgDC3:postValidateField()
RETURN ::oBrowse:postValidateCell()

***********************************************************************
* Clean up
***********************************************************************
METHOD drgDC3:destroy()
  ::drgDialogController:destroy()

  ::lastDrgEvent  := ;
  ::aData         := ;
  ::aKeyList      := ;
                NIL
RETURN
