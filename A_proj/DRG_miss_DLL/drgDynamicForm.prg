//////////////////////////////////////////////////////////////////////
//
//  drgDynamicForm.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgForm class processes .FRM definition file and creates a form of the \
//       dialog.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"

CLASS drgDynamicForm FROM drgForm
  EXPORTED:
  VAR     oDForm

  METHOD  init
  METHOD  create
  METHOD  destroy
  METHOD  displayPage
  METHOD  eventHandled
  METHOD  getLine
*  METHOD  setDisabledActions

ENDCLASS

***********************************************************************
* Initialization. Display initial form first.
***********************************************************************
METHOD drgDynamicForm:init(parent)
LOCAL st, oDummy
  st := 'TYPE(GET) NAME(dummy) FPOS(100,100) FLEN(1)'
  oDummy := _drgGet():new(st)
  ::oDForm := parent:formObject
  ::oDForm:addLine(oDummy)
*
  ::drgForm:init(parent)
RETURN self

***********************************************************************
* Create wizard form
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgDynamicForm:create()
  ::displayPage()
RETURN

***********************************************************************
* Gets new line from form description.
*
* \b< Returns: >b\  : _drgObject class description line
***********************************************************************
METHOD drgDynamicForm:getLine()
RETURN ::oDForm:getLine()

***********************************************************************
* Display single wizard page
*
* \b< Parameters: >b\
* \b< page > b\    : numeric : page number to display
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgDynamicForm:displayPage(page)
LOCAL st, oDummy

* Clear page unless at startup
  IF ::aMembers != NIL
    ::clearAll()
  ELSE
    ::oDForm:destroy()
    ::oDForm := NIL
  ENDIF
/*
* Check if this page can be displayed
  WHILE !ret
* Initialization callback
    ::wizHeader := ::descArr[page]:getLine()
    IF (initBlock := ::drgDialog:getMethod(::wizHeader:pre,'preWizPage') ) != NIL
      ret := EVAL(initBlock, page)
    ENDIF
* first or last page don't care for check
    IF page = 1 .OR. page = LEN(::descArr)
      EXIT
    ENDIF

    IF !ret
      ::descArr[page]:resetPos()                  // reset position
      page := IIF(::goNEXT, ++page, --page)
    ENDIF
  ENDDO
*/
  ::oDForm := ::drgDialog:UDCP:getDynamicForm()

  st := 'TYPE(GET) NAME(dummy) FPOS(80,1) FLEN(1) PRE(preLastField)'
  oDummy := _drgGet():new(st)
  ::oDForm:addLine(oDummy)

  ::drgForm:create()
RETURN self

*************************************************************************
* Handle events associated with wizard form
*************************************************************************
METHOD drgDynamicForm:eventHandled(nEvent, mp1, mp2, oXbp)
* First check for common form events
  IF ::drgForm:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ELSEIF nEvent = drgEVENT_NEXT
*    IF EVAL(postBlock, ::page)
      ::displayPage()
      RETURN .T.
*    ENDIF
  ENDIF

RETURN .F.

/*
***********************************************************************
* Set disabled actions on a form.
*
* \bParameters:b\
* \b< aManager >b\   : _object : of type drgActionManager
***********************************************************************
METHOD drgDynamicForm:setDisabledActions(aManager)
* Disable prev and next action when first or last page is shown.
  IF ::page = 1
    aManager:disableActions( {drgEVENT_PREV} )
    aManager:disableActions( {drgEVENT_SAVE} )
  ELSEIF ::page = LEN(::descArr)
    aManager:disableActions( {drgEVENT_NEXT} )
  ENDIF
RETURN
*/

***********************************************************************
* Releases this objects internal variables.
*************************************************************************
METHOD drgDynamicForm:destroy()
LOCAL x
  ::drgForm:destroy()
  ::oDForm:destroy()

  ::oDForm  := ;
               NIL
RETURN .T.

