/////////////////////////////////////////////////////////////////////
//
//  drgDialogController.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Dialog controller defines standard behaviour of dialog. How the dialog \
//       respondes to click on IconBar or selection from menu. Basic controller class \
//       is abstract class which defines no action, but collects all interested \
//       parts of dialog and transfers messages to them when they are registered \
//       with controller.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

****************************************************************************
****************************************************************************
*
* drgDialogController abstract definition
*
****************************************************************************
****************************************************************************
CLASS drgDialogController
EXPORTED:
  VAR     drgDialog               // drgDialog controlled by this controller
  VAR     dataManager             // drgDialog's data manager
  VAR     members                 // array of elements registered for eventHandled method
  VAR     dbArea                  // primary database area involved in the controller
  VAR     oBrowse                 // registered oBrowse object
  VAR     lastRECNO               // last record number
  VAR     isAppend                // is adding of record in progress
  VAR     isReadOnly              // is this dialog ReadOnly

  VAR     cbSave                  // record save callBack block
  VAR     cbLoad                  // record load callBack block
  VAR     cbDelete                // record delete callBack block

  METHOD  init
  METHOD  destroy
  METHOD  register
  METHOD  registerBrowser
  METHOD  browseRefresh
  METHOD  browseInFocus
  METHOD  eventHandled
  METHOD  handleAction
  METHOD  shortcut
  METHOD  evalBlock

  METHOD  appendBlankRecord
  METHOD  deleteRecord
  METHOD  setDisabledActions
  METHOD  drgDialogPrint
  METHOD  drgDialogFind
ENDCLASS

*********************************************************************
*********************************************************************
METHOD drgDialogController:init(oParent)
  ::drgDialog   := oParent
  ::dataManager := oParent:dataManager
  ::members     := {}

  ::cbLoad   := ::drgDialog:getMethod(::drgDialog:formHeader:cbLoad,'onLoad')
  ::cbSave   := ::drgDialog:getMethod(::drgDialog:formHeader:cbSave,'onSave')
  ::cbDelete := ::drgDialog:getMethod(::drgDialog:formHeader:cbDelete,'onDelete')
RETURN self

*********************************************************************
* Check if event is to be handled by other objects registered to this dialogController. \
* Althow this method is always overwritten by further controller objects it must \
* always be called implicitly at the beginnig of custom dialog controller method.
*********************************************************************
METHOD drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL x
  FOR x := 1 TO LEN(::members)
    IF ::members[x]:eventHandled(nEvent, mp1, mp2, oXbp)
      RETURN .T.
    ENDIF
  NEXT x
RETURN .F.

*********************************************************************
* Handles action event. Actions requirers checking whether it can be \
* launched. Type of checking is provided by mp2 parameter which indicates if \
* current field must be validated or all fields on a form must be validated \
* before action is lounched. It is also possible to define usr defined function \
* or method for postvalidation.
*
* \bParameters:b\
* \b< nEvent, mp1, mp2, oXbp > : Standard event parameters.
* \b[ mp1 ] : Action to take place.
* \b[ mp2 ] : Type of postvalidation performed before action will be called.
* \b[ oValidator ]b\ : object : object which implements postValidateField and \
* postValidateForm methods. Default validator is dialogs form object.
*********************************************************************
METHOD drgDialogController:handleAction(nEvent, mp1, mp2, oXbp, oValidator)
LOCAL ret := .F., aFunc

  DEFAULT oValidator TO ::drgDialog:oForm
* Reset Action frame when action has terminated
  IF mp2 = NIL .AND. mp1 != NIL
    if oxbp:ClassName() = 'XbpImageButton' .or. oxbp:ClassName() = 'XbpToolBar'
      return .t.
    endif

    IF IsMemberVar( mp1, 'frameState')
// ne      mp1:frameState := 1
// ne      mp1:drawFrame()
      RETURN .T.
    ENDIF
  ELSE

* Perform check prior action activation. Type of prevalidation is in mp2
    IF ISDIGIT(mp2)
* Type = '1' postvalidate current field then call
      IF mp2 = '1' .AND. !oValidator:postValidateField()
        ret := .T.
* Type = '2' postvalidate all fields on form then call
      ELSEIF mp2 = '2' .AND. !oValidator:postValidateForm()
        ret := .T.
      ENDIF
* Usr defined Postvalidation function
    ELSEIF ( aFunc := ::drgDialog:getMethod(mp2) ) != NIL
      IF !EVAL(aFunc, ::drgDialog)
        ret := .T.
      ENDIF
    ENDIF
  ENDIF

* Action to perform. If chartype then function or method is called
  IF !ret
    IF VALTYPE(mp1) = 'C'
      IF ( aFunc := ::drgDialog:getMethod(mp1) ) != NIL
        EVAL(aFunc, ::drgDialog)
      ENDIF
* Otherwise it is send as another event
    ELSEIF mp1 != NIL                           // NIL is only during development time
* Numeric events and System events
      if ISNUMBER(mp1)
        if mp1 = misEVENT_BROREFRESH .and. oxbp:className() <> 'XbpBrowse'
          _clearEventLoop()
          return .t.
        endif
      endif

      PostAppEvent(mp1,,,oXbp)
    ENDIF
  ENDIF
* Deactivate action
RETURN .T.

*********************************************************************
* Print icon was selected on icon bar aka drgEVENT_PRINT was posted. \
* Call default print method.
*********************************************************************
METHOD drgDialogController:drgDialogPrint()
  LOCAL oDialog, c, nRecNo

  * Print dialog is defined in FORM header
  IF EMPTY(c := ::drgDialog:formHeader:print)
    c := 'SYS_tiskform_CRD'

    IF ClassObject(c) = NIL
      * NOPE. Return.
      drgMsgBox(drgNLS:msg('Default print program not defined!'))
      RETURN .T.
    ENDIF

    * Printout header file HDR must be specified
    c += ',' + ::drgDialog:dbName
  ENDIF

  * Invoke print dialog
  DRGDIALOG FORM c PARENT ::drgDialog MODAL DESTROY
RETURN .T.

*********************************************************************
* Print icon was selected on icon bar aka drgEVENT_PRINT was posted. \
* Call default print method.
*********************************************************************
METHOD drgDialogController:drgDialogFind()
LOCAL oDialog
  DRGDIALOG FORM drgIni:stdDialogFind PARENT ::drgDialog MODAL DESTROY
RETURN .T.

*********************************************************************
* Register drgObjectxx part so it can receive events. Basic parts which can receive \
* and handle events are drgForm, EditBrowse, UDCP. End user may register its \
* own object which will also receive all events and process events that are of its interest.
*
* \bParameters:b\
* \b< drgPart >b\     : oObject : object registering for events
*********************************************************************
METHOD drgDialogController:register(drgPart)
  IF drgPart != NIL
    AADD(::members, drgPart)
  ENDIF
RETURN self

*********************************************************************
* Register drgBrowse object. Basic controler can handle only single browser and \
* will set primary dataArea.
*
* \bParameters:b\
* \b< oDrgBrowse >b\    : drgBrowse : object of type drgBrowse to register.
*********************************************************************
METHOD drgDialogController:registerBrowser(oDrgBrowse)
  ::dbArea  := oDrgBrowse:dbArea
  ::oBrowse := oDrgBrowse
RETURN self

***********************************************************************
* Refreshes browser contents if browser is present.
***********************************************************************
METHOD drgDialogController:browseRefresh()
  IF ::oBrowse != NIL
    ::oBrowse:oXbp:refreshAll()
  ENDIF
RETURN

***********************************************************************
* Check if browser is in focus
***********************************************************************
METHOD drgDialogController:browseInFocus()
RETURN ::drgDialog:oForm:oLastDrg = ::oBrowse

*********************************************************************
* Evaluates codeBlock if it exists. Used for evaluating callback callblocks.\
* Callback blocks are called only if not NIL.
*
* \bParameters:b\
* \b< block >b\     : callBlock object : codeBlock to call
*********************************************************************
METHOD drgDialogController:evalBlock(block, xParm1, xParm2, xParm3)
  IF block != NIL
    RETURN EVAL(block, xParm1, xParm2, xParm3)
  ENDIF
RETURN .T.

***********************************************************************
* Set disabled actions on a dialog.
*
* \bParameters:b\
* \b< oActionManager >b\   :object : dialogs drgActionManager object
***********************************************************************
METHOD drgDialogController:setDisabledActions(oActionManager)
*  oActionManager:disableActions( ;
*    {drgEVENT_APPEND, drgEVENT_APPEND2, drgEVENT_EDIT, drgEVENT_DELETE} )
RETURN

***********************************************************************
* Checks if key is a shortcut for drgEVENT_xxxx events
*
* \bParameters:b\
* \b< aKey >b\   : _numeric : code of the pressed key
* \b< oXbp >b\   : _object of xbpXXX : object which generated keyCode
***********************************************************************
METHOD drgDialogController:shortcut(aKey, oXbp)
  Local  lOk := ( !::isReadOnly .and. (oXbp:className() = 'XbpBrowse') )
  local  actkey
  *
  local  appKey := { , , }

*  appKey[1] := AppKeyState( xbeK_SHIFT )
*  appKey[2] := AppKeyState( xbeK_CTRL  )
*  appKey[3] := AppKeyState( xbeK_ALT   )


  actkey := ::drgDialog:asysAct

  DO CASE
*** Menu dialog   ****************************************************
  CASE aKey = xbeK_CTRL_S
    PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'2',oXbp)
  CASE aKey = xbeK_ALT_X
    PostAppEvent(drgEVENT_ACTION, drgEVENT_EXIT,'2',oXbp)
  CASE aKey = xbeK_CTRL_P
    PostAppEvent(drgEVENT_ACTION, drgEVENT_PRINT,'2',oXbp)
  CASE aKey = xbeK_CTRL_Q
    PostAppEvent(drgEVENT_ACTION, drgEVENT_QUIT,'0',oXbp)
  CASE aKey = xbeK_ALT_F4
    PostAppEvent(xbeP_Close,,,oXbp)

*** Menu editace   ****************************************************
  CASE aKey = xbeK_ENTER    .AND. lOk                                           // !::isReadOnly xbeK_CTRL_E
    PostAppEvent(drgEVENT_ACTION, drgEVENT_EDIT,'2',oXbp)
  CASE aKey = xbeK_F3       .AND. lOk                                           // !::isReadOnly xbeK_CTRL_D
    PostAppEvent(drgEVENT_ACTION, drgEVENT_APPEND2,'2',oXbp)
  CASE aKey = xbeK_INS      .AND. lOk                                           // !::isReadOnly xbeK_CTRL_A
    PostAppEvent(drgEVENT_ACTION, drgEVENT_APPEND,'0',oXbp) // ???  '2'
  CASE aKey = xbeK_CTRL_DEL .AND. lOk                                           // !::isReadOnly xbeK_CTRL_K
    PostAppEvent(drgEVENT_ACTION, drgEVENT_DELETE,'0',oXbp)

*** Menu nástroje   ****************************************************
  CASE aKey = xbeK_CTRL_R .and. oxbp:className() = 'XbpBrowse'
    PostAppEvent(drgEVENT_ACTION, misEVENT_BROREFRESH,'0',oXbp)

  CASE aKey = xbeK_CTRL_F
    PostAppEvent(drgEVENT_ACTION, drgEVENT_FIND,'2',oXbp)

  CASE aKey = xbeK_F7
    PostAppEvent(drgEVENT_ACTION, misEVENT_SORT,'2',oXbp)
  CASE aKey = xbeK_F8
    PostAppEvent(drgEVENT_ACTION, misEVENT_FILTER,'2',oXbp)
  CASE aKey = xbeK_CTRL_F8
    PostAppEvent(drgEVENT_ACTION, misEVENT_KILLFILTER,'2',oXbp)
  CASE aKey = xbeK_CTRL_D
    PostAppEvent(drgEVENT_ACTION, misEVENT_DOCUMENTS,'2',oXbp)
  CASE aKey = xbeK_CTRL_K
    PostAppEvent(drgEVENT_ACTION, misEVENT_DATACOM,'2',oXbp)
  CASE aKey = xbeK_CTRL_W
    PostAppEvent(drgEVENT_ACTION, misEVENT_SWHELP,'2',oXbp)

*** hot key obnovu formuláøe v z distribuèního ************************
*  case ( chr(aKey) = 'O' .and. appKey[1] = APPKEY_DOWN .and. ;
*                               appKey[2] = APPKEY_DOWN .and. ;
*                               appKey[3] = APPKEY_DOWN       )

**    PostAppEvent(drgEVENT_ACTION, misEVENT_RESTFORM,'2',oXbp)

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

***********************************************************************
* Appends new blank record to file. If recycle is requested and empty record \
* is find then record gets recycled.
***********************************************************************
METHOD drgDialogController:appendBlankRecord()
LOCAL lDeleted
**  ::drgDialog:pushArea()
  DBSELECTAREA(::dbArea)
  IF drgINI:recycleDeleted
* Save current area and select edited area
* Save deleted flag, set it to false, go top and if deleted record found
* recalls it otherwise append blank record
    lDeleted := SET(_SET_DELETED, .F.)
    DBGOTOP()
    IF DELETED() .AND. drgLockOK()
      DBRECALL()
      DBUNLOCK()
    ELSE
      DBAPPEND()
    ENDIF
* Restore deleted flag and work area
    SET(_SET_DELETED, lDeleted)
  ELSE
    DBAPPEND()           // append new record if not edit
  ENDIF
**  ::drgDialog:popArea(.T.)
RETURN self

***********************************************************************
* Performs deletion of current active record. If recycle is defined then \
* all fields of record are filled with empty values before record is deleted.
*
* Return : lSuccess : True if record was deleted.
***********************************************************************
METHOD drgDialogController:deleteRecord()
LOCAL nRec, aData, lRet := .T.
  ::drgDialog:pushArea()
  SELECT(::dbArea)
*
  IF drgINI:recycleDeleted
    nRec := RECNO()       // save current record position
    DBGOTO(-1)
    aData := drgScatter() // Fill aData with empty values
    DBGOTO(nRec)
    IF drgLockOK()
      drgGather(aData)    // Replace data with empty values
      DBDELETE()          // delete record
      DBUNLOCK()
    ELSE
      lRet := .F.
    ENDIF
  ELSEIF drgLockOK()
    DBDELETE()            // delete record
    DBUNLOCK()
  ELSE
    lRet := .F.
  ENDIF
  DBCOMMIT()
*
  ::drgDialog:popArea()
RETURN lRet

*********************************************************************
* Clean up
*********************************************************************
METHOD drgDialogController:destroy()
  ::drgDialog   := ;
  ::dataManager := ;
  ::members     := ;
  ::dbArea      := ;
  ::oBrowse     := ;
  ::lastRECNO   := ;
  ::isAppend    := ;
  ::isReadOnly  := ;
  ::cbSave      := ;
  ::cbLoad      := ;
  ::cbDelete    := ;
                   NIL
RETURN

****************************************************************************
****************************************************************************
*
* Simpliest controller doesn't include any database motion. But it knows \
* How to handle ACTION events and launches Close event when EXIT is selected.
*
****************************************************************************
****************************************************************************
CLASS drgDC0 FROM drgDialogController
EXPORTED:
  METHOD  eventHandled
ENDCLASS

****************************************************************************
****************************************************************************
METHOD drgDC0:eventHandled(nEvent, mp1, mp2, oXbp)

* Call drgDialogController eventHandled method which handles all
* objects registered for handling events.
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

* Handle action events
  DO CASE
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
    IF ::browseInFocus()
      ::drgDialogFind()
    ENDIF

* Browser movement if browser in focus.
  CASE nEvent = drgEVENT_NEXT
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oBrowse:oXbp)
    ENDIF

  CASE nEvent = drgEVENT_PREV
    IF ::browseInFocus()
      PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oBrowse:oXbp)
    ENDIF

  CASE nEvent = drgEVENT_TOP
    IF ::browseInFocus()
      (::dbArea)->( DBGOTOP() )
      ::browseRefresh()
    ENDIF

  CASE nEvent = drgEVENT_BOTTOM
    IF ::browseInFocus()
      (::dbArea)->( DBGOBOTTOM() )
      ::browseRefresh()
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