//////////////////////////////////////////////////////////////////////
//
//  drgSearch.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgSearch is used for searching fields in a browser maner.
//
//  Remarks: returnState holds the return state of drgSearch
//           value holds the value of the selected field
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "xbp.ch"


CLASS drgSearch FROM drgUsrClass
EXPORTED:
  var     exitState, exitValue, dbSearch, srchDBD, mySrchFld, mySrchOrd, dbAlias

  METHOD  destroy             // release all resources used by this object

  method  getForm, drgDialogStart, drgDialogEnd
  METHOD  recordSelected
  METHOD  eventHandled
  METHOD  refresh
  method  drgUsrIconBar, drgUsrDialogMenu

HIDDEN:
  var     srchFields, srchReturn
  METHOD  getSize

ENDCLASS

**********************************************************************
* Returns form for this drgSearch dialog.
**********************************************************************
METHOD drgSearch:getForm()
LOCAL fCnt, st, fArr, size, oDrg
*
local pa

  st := ::drgDialog:cargo
* Parse parameters left by calling object
  ::dbSearch  := drgParse(@st, TAB)
  ::mySrchFld := RTRIM(drgParse(@st, TAB))
  ::mySrchOrd := drgParse(@st, TAB)
  ::dbAlias   := drgParse(@st, TAB)
*
  ::srchDBD := drgDBMS:getDBD(::dbSearch)
  size      := ::getSize()

* Save current active file where search is performed
  ::drgDialog:pushArea()
  SELECT(::dbAlias)
* Save current index order in file where search is performed
  ::drgDialog:pushArea()
* Set dialog title and Icon
  ::dialogTitle := ::srchDBD:description
  ::dialogIcon  := DRG_ICON_FIND
*
  fCnt := drgFormContainer():new()
* drgForm
  oDrg := _drgDrgForm():new()
  oDrg:size     := {size,15}
  oDrg:guiLook  := 'Action:N,Message:N'
  oDrg:isReadOnly := .T.
  fCnt:addLine(oDrg)
* Browser
  oDrg := _drgDBrowse():new()
  oDrg:size         := {size,15}
  oDrg:popupMenu    := 'y'

  oDrg:file         := ::dbSearch
  oDrg:fields       := ::srchFields

  oDrg:indexord     := IIF( EMPTY(::mySrchOrd), ::srchDBD:srchOrder, VAL(::mySrchOrd) )
  oDrg:pp           := 7
  oDrg:cursorMode   := 3
  oDrg:itemSelected := 'recordSelected'
  fCnt:addLine(oDrg)
RETURN fCnt

**********************************************************************
* Called when dialog has started. This will move file pointer to starting position \
* specified with passed parameter.
**********************************************************************
METHOD drgSearch:drgDialogStart(drgDialog)
  ::refresh()
RETURN self

**********************************************************************
* Calculates size of dialog to display.
**********************************************************************
METHOD drgSearch:getSize()
  LOCAL  nIn
  LOCAL  sf, st, x
  LOCAL  aName, aCap, aLen, aFile
  LOCAL  ret := 0, pa

  IF( nIn := AScan(::srchDBD:srchDef, {|X| X:srchOrder == VAL(::mySrchOrd) })) <> 0
    ::srchFields := ::srchDBD:srchDEF[nIn]:srchFields
    ::srchReturn := ::srchDBD:srchDEF[nIn]:srchReturn

    sf := ::srchFields
  ENDIF

**  sf := ::srchDBD:srchFields

  WHILE !EMPTY( st := drgParse(@sf) )
**************************
* Parse name
**************************
    aName := ALLTRIM( drgParse(@st,':') )
    IF (x := AT('->', aName)) > 0
      aFile := drgParse(aName,'-')
      aName := drgParseSecond(aName,'>')
    ELSE
      aFile := ::dbSearch
    ENDIF
**************************
* Parse caption
**************************
    aCap  := ALLTRIM( drgParse(@st,':') )
    IF EMPTY(aCap)
      aCap  := drgDBMS:getFieldDesc(aFile, aName):caption
    ENDIF
**************************
* Parse length
**************************
    aLen := ALLTRIM( drgParse(@st,':') )
    IF EMPTY(aLen)
      aLen := STR(drgDBMS:getFieldDesc(aFile, aName):len + 1)  // 2 STR because of VAL
      aLen  := IIF(EMPTY(aLen), 10, VAL(aLen) )
      ret  += IIF(LEN(aCap) > aLen, LEN(aCap), aLen)
    ELSE
      ret  += VAL(aLen)
    ENDIF
  ENDDO
  ret += 2

* Can't be larger than 100 and less then 40
  ret := IIF(ret >  90, ret, min(ret,90) )
  ret := IIF(ret <= 40, 40, ret)

RETURN ret

**********************************************************************
* Event routine for events spicific for drgSearch class.
**********************************************************************
METHOD drgSearch:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL  aVal, oDialog

  DO CASE
* Select and exit icon or menu was selected.
  CASE nEvent = drgEVENT_EXIT
    ::recordSelected()

  CASE nEvent = drgEVENT_EDIT
    if oXbp:className() = 'XbpBrowse'
      ::recordSelected()
      return .t.
    else

      ::drgDialog:pushArea()       // save current workArea
      IF ( oDialog := drgDialog():new(::dbSearch, ::drgDialog) ) != NIL
        oDialog:create(,,.T.)
        oDialog:destroy()
      ELSE
        drgMsgBox(drgNLS:msg('Default edit form for table & not found!', ::dbSearch) )
      ENDIF
      oDialog := NIL
      ::drgDialog:popArea()        // restore workArea

      ::drgDialog:dialogCtrl:oBrowse:oXbp:refreshAll()
      SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
    endif

  CASE nEvent = xbeP_Keyboard
    DO CASE
* Select QUIT when escape is pressed
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

    case mp1 = xbeK_RETURN
      ::recordSelected()
      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE

* For safety purposes
    CASE nEvent = drgEVENT_FORMDRAWN
      _clearEventLoop()           // safe way
      SetAppFocus(::drgDialog:dialogCtrl:oBrowse:oXbp)
      RETURN .F.                  // might be used somewhere else

  OTHERWISE
    RETURN .F.
  ENDCASE
* Event was processed
RETURN .T.

**********************************************************************
* Repositions file pointer acording to tmp. search velue and refreshes browser.
**********************************************************************
METHOD drgSearch:refresh()
  LOCAL  xKy  := &(IndexKey())
  LOCAL  xSEa := ::mySrchFld
  *
  local  od_Bro := ::drgDialog:dialogCtrl:oBrowse

  IF VALTYPE(xKy) == 'N' ; xSEa := VAL(::mySrchFld)
  else                   ; xsea := upper(::mySrchFld)
  ENDIF

  DbSeek(xSEa,.T.)
  if( (::dbAlias)->( eof()), (::dbAlias)->( dbgoTop()), nil )

  ::drgDialog:dialogCtrl:browseRefresh()
  ::drgDialog:dataManager:refresh()
RETURN self

**********************************************************************
* Called whin dialog is closed. Restore indexord state of searched WorkArea.
**********************************************************************
METHOD drgSearch:drgDialogEnd()

  if .not. empty((::dbAlias)->(ads_getAof()))
    (::dbAlias)->( ads_clearAof())
  endif

  ::drgDialog:popArea()
RETURN self

**********************************************************************
* Called when record was selected. Method fills up drgDialog:cargo with return value \
* and post xbeP_Close event.
**********************************************************************
METHOD drgSearch:recordSelected()

  if ::dbSearch <> ::dbAlias
    (::dbAlias) ->(DBGoTo((::dbSearch)->(RecNo())))
  endif

  ::drgDialog:cargo := &(::dbSearch + '->' + ::srchReturn)
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN  self

**********************************************************************
* Creates dialog IconBar for drgSearch usr defined class.
**********************************************************************
METHOD drgSearch:drgUsrIconBar(parent)
LOCAL iconBar, size, pos, ms, editSize, oBord
  oBord := parent:dialog:drawingArea

  ms := drgNLS:msg('Quit dialog,Select and Exit,Run edit dialog,Help')

* Get size of drawing area
  size := ACLONE( parent:dataAreaSize )
  size[2] := 24

* Get position of iconBar area
  pos  := ACLONE( parent:dataAreaSize )
  pos[1] := 0
  pos[2] += 0

* create iconBar = drgActions object
  iconBar := drgActions():new(parent)
  iconBar:create(oBord, pos, size)
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 5
*
  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_EXIT, gDRG_ICON_EXIT,,, drgParse(@ms),drgEVENT_EXIT,.F.)
  pos[1] += 24
  editSize := size[1]+6*drgINI:fontW
  iconBar:addAction( pos, {editSize, size[2]}, 3, DRG_ICON_EDIT, gDRG_ICON_EDIT,,drgNLS:msg('Edit'), drgParse(@ms),drgEVENT_EDIT,.F.)
  pos[1] += editSize
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

RETURN iconBar

**********************************************************************
* Creates dialog Menu for drgSearch usr defined class.
**********************************************************************
METHOD drgSearch:drgUsrDialogMenu( myMenuBar )
LOCAL myMenu, ms

  ms := drgNLS:msg('~Dialog,Select and E~xit,~Quit,~Help,Help on search')

  myMenu       := XbpMenu():new(myMenuBar)
  myMenu:title := drgParse(@ms)
  myMenu:create()

  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+X", ;
                   {|mp1,mp2,obj| PostAppEvent( drgEVENT_EXIT, mp1, mp2, obj ) }} )
  myMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+Q", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_QUIT, mp1, mp2, obj ) }} )

  myMenuBar:addItem( {myMenu, NIL} )

* Help menu
  myMenu := XbpMenu():new(myMenuBar)
  myMenu:title := drgParse(@ms)
  myMenu:create()

  myMenu:addItem( {drgParse(@ms)+TAB+"F1", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_HELP, mp1, mp2, obj ) }} )

  myMenuBar:addItem( {myMenu, NIL} )
RETURN

*********************************************************************
* Destroys drgSearch object
*********************************************************************
METHOD drgSearch:destroy
  ::drgUsrClass:destroy()

  ::exitState  := ;
  ::exitValue  := ;
  ::dbSearch   := ;
  ::srchDBD    := ;
  ::mySrchFld  := ;
  ::mySrchOrd  := ;
  ::srchFields := ;
  ::srchReturn := ;
                 NIL
RETURN self

*********************************************************************
* Performs drgSearch call.
*
* /bParameters:b/
* /b< drgDialog >b/   : drgDialog object : drgDialog object from where search has been called
* /b< aFile >b/       : String   : ALIAS of file name on which search is to be performed.
* /b[startValue]b/    : String   : Optional. Searching start value
* /b[order]b/         : String   : Optional. Searching starting order
*
* /bReturns:b/       : anyType  : Value of return field which is defind on SEARCH
* section of database description. NIL if Close was selected.
*********************************************************************
FUNCTION drgCallSearch(drgDialog, aFile, startValue, order )
LOCAL srchDialog, ret
  DEFAULT order TO ''

  srchDialog := drgDialog():new('&drgSearch', drgDialog)
  srchDialog:cargo := ALLTRIM(aFile) + TAB + startValue  + TAB + order + TAB + ALLTRIM(aFile)
  srchDialog:create(,,.T.)

  ret := IIF(srchDialog:exitState != drgEVENT_QUIT, srchDialog:cargo, NIL)
  srchDialog:destroy()
  srchDialog := NIL

RETURN ret