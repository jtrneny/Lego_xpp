//////////////////////////////////////////////////////////////////////
//
//  drgForm.PRG
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

#include "Appevent.ch"
#include "Common.ch"
#include "Font.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"

#pragma Library( "XppUI2.LIB" )
#pragma Library( "Asystem_1.Lib")

***********************************************************************
* Class declaration
***********************************************************************
CLASS drgForm
  EXPORTED:

  VAR     drgDialog             // pointer to dialog which uses this form
  VAR     aMembers              // all object created by this form

  VAR     topOffset
  VAR     leftOffset
  VAR     nExitState
  VAR     oLastDrg
  VAR     nLastDrgIx
  VAR     repeatFocus
  VAR     tabPageManager
  VAR     nextFocus

  var     a_scrpos_ok
  var     in_postvalidateForm

  METHOD  init
  METHOD  create
  METHOD  clearAll
  METHOD  destroy

  METHOD  addArea2Stack
  METHOD  getActiveArea
  METHOD  keyHandled
  METHOD  eventHandled
  METHOD  ok4Focus
  METHOD  getLine
  METHOD  collectActions
  METHOD  setDisabledActions
  METHOD  postValidateField           // postvalidate last active field on form
  METHOD  postValidateUntil           // postvalidate all fields until current active
  METHOD  postValidateForm            // postvalidate all fierlds on form
  METHOD  resetValidation
  METHOD  checkTabPage
  METHOD  setNextFocus
  METHOD  resize

HIDDEN:
  VAR     aStackArea
  VAR     nStackIndex
  VAR     oContainer

  VAR     nResizeCount                // Initial resize has been done
  VAR     arSizeMinimized             // windows size when minimized


  inline method drgForm_newItem( ctype )
    local  odrg, cname

    do case
    case( ctype = 'dbrowse'     )  ;  odrg := drgDBrowse():new( self )
    case( ctype = 'ebrowse'     )  ;  odrg := drgEBrowse():new( self )
    case( ctype = 'browse'      )  ;  odrg := drgBrowse():new( self )
    case( ctype = 'combobox'    )  ;  odrg := drgComboBox():new( self )
    case( ctype = 'dc10'        )  ;  odrg := drgDC10():new( self )
    case( ctype = 'get'         )  ;  odrg := drgGet():new( self )
    case( ctype = 'mle'         )  ;  odrg := drgMle():new( self )
    case( ctype = 'radiobutton' )  ;  odrg := drgRadioButton():new( self )
    case( ctype = 'static'      )  ;  odrg := drgStatic():new( self )
    case( ctype = 'tabpage'     )  ;  odrg := drgTabPage():new( self )
    case( ctype = 'text'        )  ;  odrg := drgText():new( self )
    case( ctype = 'treeview'    )  ;  odrg := drgTreeView():new( self )
    case( ctype = 'checkbox'    )  ;  odrg := drgCheckBox():new( self )
    case( ctype = 'pushbutton'  )  ;  odrg := drgPushButton():new( self )
    case( ctype = 'spinbutton'  )  ;  odrg := drgSpinButton():new( self )
    otherwise
      cName := '{ |a| ' + 'drg' + ctype + '():new(a) }'
      oDrg := EVAL(&cName, self)
    endcase
  return odrg

ENDCLASS

***********************************************************************
* Initialization part of drgForm object.
*
* \b< Parameters: >b\
* \b< parent > b\    : drgDialog object : This drgForm's object parent
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgForm:init(parent)
  ::drgDialog           := parent
  ::repeatFocus         := 0
  ::in_postValidateForm := .f.
  ::create()
RETURN self

***********************************************************************
* Create elements of the form.
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgForm:create()
  LOCAL aLine, oDrg, cName, oDrg_GET
  LOCAL aPos, aSize
  LOCAL nEvent, mp1, mp2, lIn_REV

  ::nStackIndex  := 0
  ::aMembers     := {}
  ::aStackArea   := {}
  ::nLastDrgIx   := 0
  ::nextFocus    := NIL
  ::nResizeCount := 0

  ::tabPageManager := drgTabManager():new(self)

  nEvent  := LastAppEvent(@mp1,@mp2)
    If(ISNUMBER(mp1), NIL, mp1 := 0)                                            // m1/mp2 variable is optional
    If(ISNUMBER(mp2), NIL, mp2 := 0)

  lin_rev := (nEvent == drgEVENT_EDIT) .or. (mp1 == xbeK_RETURN) .or. (mp2 == drgEVENT_EDIT) .or. ;
             (nevent == xbeBRW_ItemSelected)

  if isObject(::drgDialog)
    if( isMemberVar( ::drgDialog, 'cargo' ) )
      if isNumber(::drgDialog:cargo)
        if( isNull(::drgDialog:cargo, 0) = drgEVENT_EDIT, lin_rev := .t., nil )
      endif
    endif
  endif


* Set first active area
  ::addArea2Stack(::drgDialog:oBord)
  WHILE (aLine := ::getLine() ) != NIL
    IF LEFT(aLine:type, 3) = 'end'
* IF last object was oContainer end adding objects to oContainer
* else it was group. Restore previous bord area.
      IF ::oContainer != NIL
        ::oContainer := NIL
      ELSE
        ::nStackIndex--
      ENDIF
    ELSE
* oContainer creates objects that it contains. Add descriptions objects to oContainer.
      IF ::oContainer != NIL
        ::oContainer:addDesc(aLine)
        LOOP
      ENDIF
* Actions go to action bar
      IF aLine:type = 'action'
        ::drgDialog:oActionBar:addAction(aLine)
        LOOP
      ENDIF

******************************************************************************
* This might be one of the most crazy things that could be done in Alaska. But it works.
*
* It should be read as oXbp := drgXXXXX():new(self).
*
* Of course drgXXXXX class must exist at run time otherwise runtime error ocurs.
******************************************************************************
      cName := '{ |a| ' + 'drg' + aLine:type + '():new(a) }'
// JS      oDrg := EVAL(&cName, self)       // Macro operator is essential

      odrg := ::drgForm_newItem( lower(aLine:type) )
      oDrg:create(aLine)

      if odrg:isDerivedFrom('drgObject') .and. isMemberVar(aline, 'isedit_inrev')
        odrg:isedit_inrev := IsNull(aline:isedit_inrev,.T.)
        if(lin_rev, odrg:isedit := odrg:isedit_inrev, NIL )
        if(lin_rev .and. .not. odrg:isedit_inrev, odrg:oxbp:disable(), nil)
      endif

      If (Upper(aLine:Type) == 'GET')                                           // miss
        If( lIn_REV .and. aLine:revTYPE == 1, oDrg:isEdit := .F., NIL )
        oDrg_GET := oDrg
      Else
        oDrg_GET := NIL
      EndIf


* Objects that group other objects on its drawing area
      IF oDrg:isGroup
        ::addArea2Stack(oDrg:oXbp)
* Inform tabpage it's position on the form
        IF aLine:type = 'tabpage'
          oDrg:onFormIndex := LEN(::aMembers) + 1
        ENDIF
      ENDIF
* This object is oContainer. All lines until TYPE=END reached will be send to it.
      IF oDrg:isContainer
        ::oContainer := oDrg
      ENDIF

* Assign Groups prom all object drg... that inherid from drgObject               // miss
      IF IsMemberVar(aLine, 'Groups') .and. IsMemberVar(oDrg, 'Groups')
        IF !Empty(aLine:Groups)
          oDrg:Groups := aLine:Groups
        ENDIF
      ENDIF

      AADD(::aMembers, oDrg)
* Create drgStatic if fCaption != NIL
      IF IsMemberVar(aLine, 'fCaption')
        IF aLine:fCaption != NIL
          cName := '{ |a| ' + 'drgText():new(a) }'
          oDrg := EVAL(&cName, self)
          oDrg:create(aLine)
          AADD(::aMembers, oDrg)
        ENDIF
      ENDIF

* Create drgPushButton if push != NIL only for GET                              // miss
      IF ISOBJECT(oDrg_GET) .and. IsMemberVar(aLine, 'PUSH')
        IF aLine:push != NIL .or. oDrg_GET:IsrelTO
          cName := '{ |a| ' + 'drgPushButton():new(a) }'
          oDrg  := EVAL(&cName,self)

          aPos  := oDrg_GET:oxbp:currentPos()
          aSize := oDrg_GET:oxbp:currentSize()
*          aPos[1]  += aSize[1] -aSize[2] -2
*          aPos[2]  += 1

**          oDrg:create(aPos,{aSize[2] +1,aSize[2] -3},4,,,,'...',,aLine:push,,,IF(ISNIL(aLine:push),oDrg_GET, NIL ))

          aPos[1] += aSize[1] -aSize[2] -1
          aPos[2] += 1

          oDrg:create(aPos,{aSize[2],aSize[2]-1},4,,,,'...',,aLine:push,,,IF(ISNIL(aLine:push),oDrg_GET, NIL ))
          oDrg:isEdit      := .F.
          oDrg:Disabled    := !oDrg_GET:IsEdit
          oDrg:oXbp:cargo  := oDrg_GET                                          //9.7.2005
          oDRG_GET:pushGet := oDrg                                              //16.9.2005

          AADD(::aMembers, oDrg)
        ENDIF
      ENDIF

    ENDIF


  ENDDO
  ::oLastDrg  := ::aMembers[1]
* Will force Action manager to collect actions on form and maybe some more in the future
  PostAppEvent(drgEVENT_FORMDRAWN, , , ::drgDialog:dialog)
* Will force focus to first editable field on a form
  PostAppEvent(drgEVENT_OBJEXIT, , , ::drgDialog:dialog)
*  SetAppFocus(::oLastDrg:oXbp)
RETURN

***********************************************************************
* Return new line from form description.
*
* \b< Returns: >b\  : _drgObject class description line
***********************************************************************
METHOD drgForm:getLine()
RETURN ::drgDialog:formObject:getLine()

***********************************************************************
* Collects curent actions (pushButtons) on a form. Actions are added to existing array \
* which includes other collected actions (icons, actionBar).
*
* \bParameters:b\
* \b< aArr >b\     : _array : of actions objects
* \b< dialog >b\   : _xbpDialog : actions manager dummy dialog to receive focus
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgForm:collectActions(aArr, dialog)
LOCAL x
  FOR x := 1 TO LEN(::aMembers)
    IF ::aMembers[x]:isDerivedFrom('drgPushButton')
*      ::aMembers[x]:dialog := ::drgDialog:dialog
      AADD(aArr, ::aMembers[x])
    ENDIF
  NEXT
RETURN self

***********************************************************************
* Set disabled actions on a form.
*
* \bParameters:b\
* \b< aManager >b\   : _object : of type drgActionManager
***********************************************************************
METHOD drgForm:setDisabledActions(aManager)
// SL1  aEval(aManager:members, {|X| IF( IsNIL(X:frameState), NIL, X:drawFrame()) })
RETURN

***********************************************************************
* Adds newly created object to drawingAreaStack.
*
* \b< Parameters: >b\
* \b< oXbp > b\    : xbpObject : Xbp Object
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgForm:addArea2Stack(oXbp)
  IF ++::nStackIndex > LEN(::aStackArea)
    AADD(::aStackArea, oXbp)
  ELSE
    ::aStackArea[::nStackIndex] := oXbp
  ENDIF
RETURN

***********************************************************************
* When initialy painting objects on the screen, some object may be painted \
* directly on the windows drawing area, some objects may be painted on tabPage \
* drawing area, some objects may have its own border (groups of objects). \
* drawingAreaStack holds stack of last active drawing areas, so next object \
* knows which its drgDialog drawingArea is.
*
* \b< Parameters: >b\
*
* \b< Returns: >b\  : xbpDrawingArea :  currently active drawing area
***********************************************************************
METHOD drgForm:getActiveArea()
LOCAL oXbp
  IF ::nStackIndex = 0
    oXbp := ::drgDialog:dialog
  ELSE
    oXbp := ::aStackArea[::nStackIndex]
  ENDIF

* Change topOffset value if TabPage
  IF oXbp:isDerivedFrom( "XbpTabPage" )
    ::topOffset   := oXbp:tabHeight + 1
    ::leftOffset  := 1
  ELSE
    ::leftOffset  := 0
    ::topOffset   := 0
  ENDIF
RETURN oXbp

*************************************************************************
* drgForm's own eventHandled method.
*************************************************************************
METHOD drgForm:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL stepto, x, lastIX := ::nLastDrgIx, isChanged
  local apos, asize, hwnd
// JS
  local myEv := {drgEVENT_OBJEXIT,drgEVENT_HELP,drgEVENT_FORMDRAWN,xbeP_Resize}

  if .not. (nevent $ myEv)
    return .f.
  endif


  IF nEvent = drgEVENT_OBJEXIT
* Trying to prevent cycling focus. NIL is at start.
    IF mp1 != ::oLastDrg .AND. mp1 != NIL
      RETURN .T.
    ENDIF
*
    stepto := IIF(::nExitState = GE_UP, -1, 1)
    x := lastIX
    WHILE .T.
      IF ::nextFocus != NIL               // direct position is required
        x := ::nextFocus
        ::nextFocus := NIL                // in case that field can't get focus
      ELSE
        x += stepto
        IF x > LEN(::aMembers)
          x := 1
        ELSEIF x <= 0
          x := LEN(::aMembers)
        ENDIF
      ENDIF
*      drgDump(x,'x')
      IF ::aMembers[x]:isEdit
* Send edit event
        isChanged := ::oLastDrg:oVar != NIL .AND. ::oLastDrg:oVar:changed()
* Actions set focus to main dialog. Reset mainDialog keyboard callback
        ::drgDialog:dialog:keyBoard := NIL
        ::oLastDrg  := ::aMembers[x]
* Set index in aMembers array
        ::nLastDrgIx := x
        ::oLastDrg:setFocus()
        ::drgDialog:lastXbpInFocus := ::oLastDrg:oXbp
        PostAppEvent(drgEVENT_OBJENTER,,, ::drgDialog:dialog)
* Clear Message line
        IF isChanged
           PostAppEvent(drgEVENT_MSG,,drgEVENT_EDIT, ::drgDialog:dialog)
        ENDIF
        PostAppEvent(drgEVENT_MSG,,, ::drgDialog:dialog)
        EXIT
      ENDIF
    ENDDO

* Start help request
  ELSEIF nEvent == drgEVENT_HELP
    ::oLastDrg:oXbp:helpRequest()

* Messages from objects drawn on screen
  elseif nEvent = drgEVENT_FORMDRAWN
    apos          := ::drgDialog:dialog:currentPos()
    asize         := ::drgDialog:dialog:currentSize()
    hWnd          := ::drgDialog:dialog:getHwnd()

    ::a_scrpos_ok := {apos[1], apos[2], asize[1], asize[2], IsZoomed(hwnd)}
    return .f.

* Resize window event
  ELSEIF nEvent == xbeP_Resize
    IF oXbp:className() = 'XbpDialog'     // resize event of xbpDialog
      IF ++::nResizeCount > 1             // not on initial resize when created
* Events when Y coordinate is smaler than 90 are always Minimize, Miximize or Restore from Minimized.
* Resize is not needed.
        IF ( mp1[2] > 90 .AND. mp2[2] > 90 )
          ::resize(mp1, mp2)
        ELSE

* Remember size when frame is minimized.
          IF ::drgDialog:dialog:getFrameState() = XBPDLG_FRAMESTAT_MINIMIZED
            ::arSizeMinimized := ACLONE(mp1)


* If maximized from minimized then 1st parameter should be size of window when minimized
          ELSEIF ::drgDialog:dialog:getFrameState() = XBPDLG_FRAMESTAT_MAXIMIZED
** asi nemusím            ::resize(::arSizeMinimized, mp2)

          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ELSE
    RETURN .F.                // Event is of no interest of drgForm
  ENDIF
RETURN .T.

*************************************************************************
* New drgObject has got focus this might be from mouse. What to do
*************************************************************************
METHOD drgForm:ok4Focus(oDrg)

* Object is the same. Probably is focus return from hide or msgbox.
  IF oDrg = ::oLastDrg
* IF same object is asking for focus then it might be hang problem
    RETURN .T.
  ENDIF
  ::repeatFocus := 0
* IF last object is editable and object post validation is OK then resume
  IF oDrg:isEdit .AND. ::oLastDrg:postValidate() // .OR. !isEdit
    IF ::oLastDrg:oVar != NIL .AND. ::oLastDrg:oVar:changed()
      PostAppEvent(drgEVENT_MSG,,drgEVENT_EDIT, ::drgDialog:dialog)
    ENDIF
    ::nExitState  := GE_DOWN                      // next exit state will be down
    ::nextFocus   := NIL                           // reset next focus since it is of no use
    ::oLastDrg    := oDrg
* Set index in aMembers array
    ::nLastDrgIx:= ASCAN( ::aMembers, {|x| oDrg = x} )
    ::drgDialog:lastXbpInFocus := ::oLastDrg:oXbp

*   Clear Message line
    PostAppEvent(drgEVENT_MSG,,, ::drgDialog:dialog)

    RETURN .T.
  ENDIF
* Post validation failed. Set focus back to last drg object
  ::oLastDrg:setFocus()
  _ClearEventLoop(.T.)
RETURN .F.

*************************************************************************
* \bParameters:b\
* \b<mField>b\    : String or Numeric : If passed field will be searched by its name. \
* If numeric is passed then next focusable field will be field number acording \
* to order found in description file. If isSkip parameter is true then number \
* of fields will be skipped forward or backward depending if aField parameter is positive \
* or negative.
* \b[lSkip]b\    : Logical : If passed and true, parameter defines number of fields to skip \
* otherwise next field will be absolute field number to skip to. Default is false.
* \b[lForceExit]b\ : Logical : Force immediate exit of current edited field. \
* Will immediatly set next focus.
*
* \bReturn:b\     : self
*
* \bExample:b\
* METHOD myFormA:postValue(oVar)
*   IF oVar:value = 0
*     ::drgDialog:oForm:setNextFocus(-3, .T.)
*   ELSE
*     ::drgDialog:oForm:setNextFocus('DBF->CustNO')
*   ENDIF
* RETURN self
*************************************************************************
METHOD drgForm:setNextFocus(mField, lSkip, lForceExit )
LOCAL oVar
  DEFAULT lSkip TO .F.
  DEFAULT lForceExit TO .F.
* IF fieldname is requested

*  drgDump( drgDumpCallStack() )
  IF VALTYPE(mField) = 'C'
    IF (oVar := ::drgDialog:dataManager:get(mField, .F.) ) != NIL
      ::nextFocus := ASCAN( ::aMembers, {|x| oVar:oDrg = x} )
    ENDIF
* IF skip is in requested
  ELSE
    if isObject(mField)
      ::nextFocus := AScan(::aMembers, {|x| x = mField})
    else
      ::nextFocus := IIF(lSkip, ASCAN( ::aMembers, {|x| ::oLastDRG = x} ) + mField, mField)
    endif
  ENDIF
*
  IF lForceExit
    PostAppEvent(drgEVENT_OBJEXIT, ::oLastDRG,, ::oLastDRG:oXbp)
  ENDIF
RETURN self

*************************************************************************
* Checks that field on the tabPage will be dispalyed properly. When postvalidation
* fails it may be the field that is currently not on the selected page. This method
* ensures that tabPage is selected.
*
* \bParameters:b\
* \b< oDrg >b\    : drgObject object :
*
* \bReturn:b\     : self
*************************************************************************
METHOD drgForm:checkTabPage( oDrg )
LOCAL n
  IF ::tabPageManager:active != NIL                   // tabPages exist
    n := ASCAN( ::aMembers, {|x| oDrg = x} )          // find FORM element
    WHILE n > 0                                       // find it's tabPage object
      IF ::aMembers[n]:isDerivedFrom( "drgTabPage" )
        ::tabPageManager:showPage(::aMembers[n])      // activate when found
        EXIT
      ENDIF
      n--
    ENDDO
  ENDIF
RETURN self

*************************************************************************
* Key handled routine for drgForm. Key handled routine checks if pressed key \
* is a key which results in fieldExit from current field.
*************************************************************************
METHOD drgForm:keyHandled(nKey)
  DO CASE
  CASE nKey == xbeK_TAB
    ::nExitState := GE_DOWN

  CASE nKey == xbeK_SH_TAB
    ::nExitState := GE_UP

  CASE nKey == xbeK_ENTER
    ::nExitState := GE_ENTER

  CASE nKey == xbeK_DOWN
    ::nExitState := GE_DOWN

  CASE nKey == xbeK_UP
    ::nExitState := GE_UP

  CASE nKey == xbeK_CTRL_HOME
    ::nExitState := GE_UP
*    ::nExitState := GE_TOP

  CASE nKey == xbeK_CTRL_END
*    ::nExitState := GE_BOTTOM
    ::nExitState := GE_DOWN
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*************************************************************************
* Postvalidate all fields on a form
*************************************************************************
METHOD drgForm:postValidateForm()
  LOCAL x

  ::in_postvalidateForm := .t.

  FOR x := 1 TO LEN(::aMembers) step 1
    if ::amembers[x]:IsDerivedFrom('drgObject') .and. ::amembers[x]:isEdit
      IF !( ::aMembers[x]:postValidate(.T.) )
        ::aMembers[x]:setFocus()

        ::in_postvalidateForm := .f.
        RETURN .F.
      ENDIF
    endif
  NEXT

  ::in_postvalidateForm := .f.
RETURN .T.

*************************************************************************
* Postvalidate all fields on form until currently active field.
*************************************************************************
METHOD drgForm:postValidateUntil(oUntilField)
LOCAL x
  DEFAULT oUntilField TO ::oLastDrg
  FOR x := 1 TO LEN(::aMembers)
    IF !( ::aMembers[x]:postValidate(.T.) )
      ::aMembers[x]:setFocus()
      RETURN .F.
    ENDIF
* Currently active field reached
    IF ::aMembers[x] = oUntilField
      EXIT
    ENDIF
  NEXT
RETURN .T.

*************************************************************************
* Resets post validate status. This is usualy called when new data has been \
* read from file and displayed on screen.
*************************************************************************
METHOD drgForm:resetValidation()
LOCAL x
  FOR x := 1 TO LEN(::aMembers)
    IF ::aMembers[x]:isContainer
      ::aMembers[x]:resetValidation()
    ELSEIF ::aMembers[x]:isEdit
      ::aMembers[x]:postValidOK := NIL
    ENDIF
  NEXT
RETURN

*************************************************************************
* Postvalidate active field on a form
*************************************************************************
METHOD drgForm:postValidateField()
  IF !::oLastDrg:postValidate(.F.)
    ::oLastDrg:setFocus()
    RETURN .F.
  ENDIF
RETURN .T.

*************************************************************************
* Postvalidate active field on a form
*************************************************************************
METHOD drgForm:resize(aOld, aNew)
  LOCAL x, nX, nY, newX, newY
  local  apos, asize, hwnd

* New Border size
  IF aOld[1] > 1000
*    RETURN self
  ENDIF
*
  IF aOld[1] + aOld[2]  = 0 .OR. aNew[1] + aNew[2] = 0
    RETURN self
  ENDIF

*
  newX := aNew[1] - aOld[1] + ::drgDialog:oBord:currentSize()[1]
  newY := aNew[2] - aOld[2] + ::drgDialog:oBord:currentSize()[2]
  ::drgDialog:oBord:setSize( {newX,newY}, .F. )
* Inform Bars on the screen
  IF ::drgDialog:oIconBar != NIL
    ::drgDialog:oIconBar:resize(aOld, aNew)
  ENDIF
  IF ::drgDialog:oActionBar != NIL
    ::drgDialog:oActionBar:resize(aOld, aNew)
  ENDIF
  IF ::drgDialog:oMessageBar != NIL
    ::drgDialog:oMessageBar:resize(aOld, aNew)
  ENDIF
* Inform all interested members
  FOR x := 1 TO LEN(::aMembers)
    IF ::aMembers[x]:canResize

      if ::aMembers[x]:className() $ 'drgTabPage,drgMle'
        ::aMembers[x]:oxbp:lockUpdate(.t.)
      endif

      ::aMembers[x]:resize(aOld, aNew)

      if ::aMembers[x]:className() $ 'drgTabPage,drgMle'
        ::aMembers[x]:oxbp:lockUpdate(.f.)
      endif
    ENDIF
  NEXT

* Repaint
  ::drgDialog:dialog:drawingArea:invalidateRect()

* nové koordináty
  apos          := ::drgDialog:dialog:currentPos()
  asize         := ::drgDialog:dialog:currentSize()
  hWnd          := ::drgDialog:dialog:getHwnd()

  ::a_scrpos_ok := {apos[1], apos[2], asize[1], asize[2], IsZoomed(hwnd)}
RETURN self

***********************************************************************
* Clear all aMembers created by this form
*************************************************************************
METHOD drgForm:clearAll()
LOCAL x

  FOR x := LEN(::aMembers) TO 1 STEP -1

    * editaèní objekty mohou být souèástí BROWSE *
    IF IsObject(::aMembers[x]:oXbp)
      IF ::aMembers[x]:oXbp:parent:className() <> 'XbpCellGroup'
        ::aMembers[x]:destroy()
      ENDIF
    ENDIF
  NEXT

  ::tabPageManager:destroy()
  ::drgDialog:dialog:keyBoard := NIL

  ::aMembers      := ;
  ::aStackArea    := ;
  ::nStackIndex   := ;
  ::topOffset     := ;
  ::nExitState    := ;
  ::oLastDrg      := ;
  ::nLastDrgIx    := ;
  ::repeatFocus   := ;
  ::oContainer    := ;
  ::tabPageManager:= ;
  ::leftOffset    := ;
  ::nextFocus     := ;
  ::nResizeCount  := ;
                      NIL
RETURN

***********************************************************************
* Releases this objects internal variables.
*************************************************************************
METHOD drgForm:destroy()
  ::clearAll()
  ::drgDialog := NIL
RETURN .T.

*************************************************************************
*
* Wizard form class definition
*
*************************************************************************
CLASS drgWizardForm FROM drgForm
  EXPORTED:
  VAR     descArr
  VAR     wizHeader
  VAR     page
  VAR     wizAdds
  VAR     addsIndex
  VAR     goNEXT

  METHOD  init
  METHOD  create
  METHOD  destroy
  METHOD  displayPage
  METHOD  eventHandled
  METHOD  getLine
  METHOD  setDisabledActions

ENDCLASS


METHOD drgWizardForm:init(parent)
LOCAL st, xPos, yPos
  ::descArr := {}
  ::wizAdds := {}
  st := 'TYPE(Group) FPOS(0,2) SIZE('+STR(parent:formHeader:size[1])+',0) ATYPE(17)'
  AADD(::wizAdds, _drgStatic():new(st) )
  AADD(::wizAdds, _drgEnd():new('TYPE(End)') )
  st := 'TYPE(Group) FPOS(0)'+ ALLTRIM(STR(parent:formHeader:size[2]-2)) + ;
        ')SIZE('+STR(parent:formHeader:size[1])+',0) ATYPE(17)'

  AADD(::wizAdds, _drgStatic():new(st) )
  AADD(::wizAdds, _drgEnd():new('TYPE(End)') )
*
  xPos := parent:formHeader:size[1] - 45
  yPos := STR(parent:formHeader:size[2]-0.5, 5,1)
  st := 'TYPE(PushButton) APOS(' + STR(xPos)    + ',' + yPos + ')SIZE(10,1.2)CAPTION(< ~Prev)EVENT(140000003) PRE(2)'
  AADD(::wizAdds, _drgAction():new(st) )
  st := 'TYPE(PushButton) APOS(' + STR(xPos+11) + ',' + yPos + ')SIZE(10,1.2)CAPTION(~Next >)EVENT(140000004) PRE(2)'
  AADD(::wizAdds, _drgAction():new(st) )
  st := 'TYPE(PushButton) APOS(' + STR(xPos+22) + ',' + yPos + ')SIZE(10,1.2)CAPTION(~Finish)EVENT(140000001) PRE(2)'
  AADD(::wizAdds, _drgAction():new(st) )
  st := 'TYPE(PushButton) APOS(' + STR(xPos+33) + ',' + yPos + ')SIZE(10,1.2)CAPTION(~Cancel)EVENT(140000002) PRE(2)'
  AADD(::wizAdds, _drgAction():new(st) )
  ::addsIndex := 0
  ::drgForm:init(parent)
* Create wizard standard controlls
RETURN self

***********************************************************************
* Create wizard form
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgWizardForm:create()
LOCAL pageIndex := 0, x, aLine
* Read form definition and split pages to _wizPage objects
  WHILE (aLine := ::drgDialog:formObject:getLine() ) != NIL
    IF aLine:type = 'wizardpage'

      IF pageIndex > 0
        FOR x := 1 TO LEN(::wizAdds)
          ::descArr[pageIndex]:addLine(::wizAdds[x])
        NEXT x
*        AEVAL(::wizAdds, {|a| ::descArr[pageIndex]:addLine(a) } )
      ENDIF
      pageIndex++
      AADD(::descArr, _drgWizardForm():new(pageIndex) )
    ENDIF
    ::descArr[pageIndex]:addLine(aLine)
  ENDDO
  FOR x := 1 TO LEN(::wizAdds)
    ::descArr[pageIndex]:addLine(::wizAdds[x])
  NEXT x
*  AEVAL(::wizAdds, {|a| ::descArr[pageIndex]:addLine(a) } )
  ::goNEXT := .T.
  ::displayPage(1)
RETURN

***********************************************************************
* Gets new line from form description.
*
* \b< Returns: >b\  : _drgObject class description line
***********************************************************************
METHOD drgWizardForm:getLine()
RETURN ::descArr[::page]:getLine()

***********************************************************************
* Display single wizard page
*
* \b< Parameters: >b\
* \b< page > b\    : numeric : page number to display
*
* \b< Returns: >b\  : self
***********************************************************************
METHOD drgWizardForm:displayPage(page)
LOCAL preBlock, aDesc, ret := .F., initBlock
* Clear page unless at startup
  IF ::aMembers != NIL
    ::clearAll()
  ENDIF
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
  ::page := page
  ::drgForm:create()
RETURN

*************************************************************************
* Handle events associated with wizard form
*************************************************************************
METHOD drgWizardForm:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL stepto, x, lastIX := ::nLastDrgIx, postBlock
* First check for common form events
  IF ::drgForm:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

  IF nEvent = drgEVENT_ACTION .AND. ValTYPE(mp1) = 'N'
    IF ( postBlock := ::drgDialog:getMethod(::wizHeader:post,'postWizPage') ) = NIL
* No complication with NIL chechking
      postBlock := { || drgAlwaysTrue() }
    ENDIF

    DO CASE
    CASE mp1 = drgEVENT_NEXT
* Call post page display controll
      IF EVAL(postBlock, ::page)
        ::goNEXT := .T.
        ::displayPage(++::page)
      ENDIF

    CASE mp1 = drgEVENT_PREV
      IF EVAL(postBlock, ::page)
        ::goNEXT := .F.
        ::displayPage(--::page)
      ENDIF

    CASE mp1 = drgEVENT_SAVE
      IF EVAL(postBlock, ::page)
        IF EVAL(postBlock, 0)
*          ::drgDialog:dataManager:save()
          PostAppEvent(xbeP_Close, , , ::drgDialog:dialog)
        ENDIF
      ENDIF

    CASE mp1 = drgEVENT_QUIT
      PostAppEvent(xbeP_Close, , , ::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE
  ELSE
    RETURN .F.
  ENDIF
RETURN .T.

***********************************************************************
* Set disabled actions on a form.
*
* \bParameters:b\
* \b< aManager >b\   : _object : of type drgActionManager
***********************************************************************
METHOD drgWizardForm:setDisabledActions(aManager)
* Disable prev and next action when first or last page is shown.
  IF ::page = 1
    aManager:disableActions( {drgEVENT_PREV} )
    aManager:disableActions( {drgEVENT_SAVE} )
  ELSEIF ::page = LEN(::descArr)
    aManager:disableActions( {drgEVENT_NEXT} )
  ENDIF
RETURN

***********************************************************************
* Releases this objects internal variables.
*************************************************************************
METHOD drgWizardForm:destroy()
LOCAL x
  ::drgForm:destroy()
  AEVAL(::descArr, { |a| a:destroy() } )
  ::descArr   := ;
  ::wizHeader := ;
  ::page      := ;
  ::wizAdds   := ;
  ::addsIndex := ;
  ::goNEXT    := ;
               NIL
RETURN .T.

************************************************************************
*
* A wizard page definition
*
************************************************************************
CLASS _drgWizardForm
  EXPORTED:
  VAR     index
  VAR     len
  VAR     pos
  VAR     aMembers

  METHOD  init
  METHOD  destroy
  METHOD  addLine
  METHOD  getLine
  METHOD  resetPos
ENDCLASS

************************************************************************
* Initialization part
************************************************************************
METHOD _drgWizardForm:init(index)
  ::index   := index
  ::pos     := 0
  ::len     := 0
  ::aMembers := {}
RETURN self

************************************************************************
* Adds new form line to wizard page
************************************************************************
METHOD _drgWizardForm:addLine(aLine)
  AADD(::aMembers, aLine)
  ::len++
RETURN

************************************************************************
* Returns next form line
************************************************************************
METHOD _drgWizardForm:getLine()
  IF ++::pos > ::len
    ::resetPos()
    RETURN NIL
  ENDIF
RETURN ::aMembers[::pos]

************************************************************************
* Resets curently returned position inside wizPage. Usualy because of failed \
* pre or post validation controll.
************************************************************************
METHOD _drgWizardForm:resetPos()
  ::pos := 0
RETURN

************************************************************************
* Clean up
************************************************************************
METHOD _drgWizardForm:destroy()
  ::index   := ;
  ::len     := ;
  ::pos     := ;
  ::aMembers := NIL
RETURN