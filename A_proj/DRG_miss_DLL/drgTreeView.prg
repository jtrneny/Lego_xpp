//////////////////////////////////////////////////////////////////////
//
//  drgTreView.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgTreeView class manages a xbpTreeView object in a form.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"

***********************************************************************
* drgTreeView Class declaration
***********************************************************************
CLASS drgTreeView FROM drgObject
  EXPORTED:
  var     oColumn, oItems
  VAR     keyboardExit
  VAR     oBord
  VAR     cbItemSelected
  VAR     cbItemMarked

  METHOD  create
  METHOD  destroy
  METHOD  keyBoard
  METHOD  itemMarked
  METHOD  itemSelected
  METHOD  resize

ENDCLASS

**************************************************************************
METHOD drgTreeView:create(oDesc)
LOCAL aPos := {1,1}, fLen, fPos, size, aSize
LOCAL cName, aVal, c1, c2
LOCAL oBord, oHlp
LOCAL oItem, initBlock
  oBord := ::parent:getActiveArea()
  size := ACLONE( oBord:currentSize() )
* Size of TreeView
  aSize    := ACLONE(oDesc:size)
  aSize[1] := aSize[1]*drgINI:fontW
  aSize[2] := aSize[2]*drgINI:fontH
* Position of the field on the screen
  fPos := ACLONE(oDesc:fpos)
  aPos[1] := fPos[1]*drgINI:fontW
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset

* On tabPage
  IF ::parent:topOffset >= drgINI:fontH
    aPos[1]  += 1
  ENDIF
* Create nice little border around view
  ::oBord      := XbpStatic():new( oBord, , aPos, aSize)
  ::oBord:type := XBPSTATIC_TYPE_RAISEDBOX
  ::oBord:create()
* resize
  ::canResize := .T.
  ::optResize := oDesc:resize
*
  aSize[1] -= 6
  aSize[2] -= 6
  aPos    := {3,3}


* Create treeView
  ::oXbp := XbpTreeView():new(::oBord, , aPos, aSize )
  ::oXbp:hasLines    := oDesc:hasLines
  ::oXbp:hasButtons  := oDesc:hasButtons
  ::oXbp:alwaysShowSelection        := .T.
  ::oXbp:setFont(drgPP:getFont())
  ::oXbp:create()

  ::oXbp:cargo := self

* Set pre & post validation codeblocks, althow they make little sence here
  ::postBlock := ::drgDialog:getMethod( oDesc:post )
  ::preBlock  := ::drgDialog:getMethod( oDesc:pre )

  ::tipText   := drgNLS:msg(oDesc:tipText)
  ::name := IIF(oDesc:name = NIL, 'TREEVIEW', oDesc:name)

* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:formName + '.htm#' + ::name )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp

* Standard calback blocks

  ::cbItemSelected    := ::drgDialog:getMethod(oDesc:itemSelected,'TreeItemSelected')
  ::oXbp:itemSelected := { |mp1, mp2, o| ::itemSelected( mp1, mp2, o ) }
  ::cbItemMarked      := ::drgDialog:getMethod(oDesc:itemMarked,'TreeItemMarked')
  ::oXbp:itemMarked := { |mp1, mp2, o| ::itemMarked( mp1, mp2, o ) }
* Set keyboard and inputFocus callbacks
  ::oXbp:keyboard      := { |mp1, mp2, o| ::keyboard( mp1, mp2, o ) }
  ::oXbp:setInputFocus := { |mp1, mp2, o| ::setInputFocus( mp1, mp2, o ) }
  ::keyboardExit := .F.

* Initialization callback
  IF (initBlock := ::drgDialog:getMethod(oDesc:treeInit,'TreeViewInit') ) != NIL
    EVAL(initBlock, self)
  ENDIF
RETURN self

***************************************************************************
* Keyboard control for TreView. Control posts item selected when ENTER is pressed \
* otherwise its behaviour is same as other drg objects.
***************************************************************************
METHOD drgTreeView:keyBoard(nKey, mp2, oXbp)
  ::keyboardExit := .T.
  IF nKey = xbeK_ENTER .AND. ::postValidate()
    PostAppEvent(xbeTV_ItemSelected, ::oXbp:getData(),,::oXbp)
  ELSEIF nKey = xbeK_TAB .AND. ::postValidate()
    PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
  ENDIF
RETURN .T.

***************************************************************************
* treeView itemSelected callBack
***************************************************************************
METHOD drgTreeView:itemSelected(oItem, aRect, oXbp)
  ::keyboardExit := .F.
  IF ::parent:ok4Focus(self)
    IF !::preValidate()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
      RETURN self
    ENDIF
  ENDIF
* Evaluate user itemSelected callback
  IF ::cbItemSelected != NIL
    EVAL(::cbItemSelected, oItem)
  ENDIF
RETURN .T.

***************************************************************************
* treeView itemMarked callBack
***************************************************************************
METHOD drgTreeView:itemMarked(oItem, aRect, oXbp)
  ::keyboardExit := .F.
  IF ::parent:oLastDrg != self           // NOT FULLY TESTED. Was too much calls to preValidate
    IF ::parent:ok4Focus(self)
      IF !::preValidate()
        PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
        RETURN self
      ENDIF
    ENDIF
  ENDIF
* Evaluate user itemMarked callback
  IF ::cbItemMarked != NIL
    EVAL(::cbItemMarked, oItem, aRect, oXbp)
  ENDIF
RETURN self

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgTreeView:resize(aOld, aNew)
LOCAL nX, nY, newX, newY
  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
*   New Border size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oBord:currentSize()[1]+nX, ;
                                             ::oBord:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oBord:currentSize()[2]+nY, ;
                                             ::oBord:currentSize()[2] )
  ::oBord:setSize( {newX,newY}, .F.)
*   New border position
  newX := IIF(SUBSTR(::optResize,1,1) = 'n', ::oBord:currentPos()[1]+nX, ::oBord:currentPos()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'n', ::oBord:currentPos()[2]+nY, ::oBord:currentPos()[2] )
  ::oBord:setPos( {newX,newY}, .F.)
*   New TreeView size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
  ::oXbp:setSize( {newX,newY}, .F.)
RETURN self

************************************************************************
* Clean up
************************************************************************
METHOD drgTreeView:destroy()
  ::drgObject:destroy()
  ::oBord:destroy()

  ::keyboardExit  := ;
  ::oBord         := ;
  ::cbItemSelected:= ;
  ::cbItemMarked  := ;
                    NIL
RETURN

************************************************************************
************************************************************************
*
* TreeView type definition class
*
************************************************************************
************************************************************************
CLASS _drgTreeView
  EXPORTED:

  VAR     type
  VAR     name
  VAR     fPos
  VAR     size
  VAR     tipText
  VAR     treeInit
  VAR     itemSelected
  VAR     itemMarked
  VAR     pre
  VAR     post
  VAR     hasLines
  VAR     hasButtons
  VAR     resize

  METHOD  init
  METHOD  destroy

  HIDDEN:
  METHOD  parse

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgTreeView:init(line)
  ::type := 'TreeView'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fPos  TO {0, 0}
  DEFAULT ::size  TO {10, 10}
  DEFAULT ::hasLines    TO .F.
  DEFAULT ::hasButtons  TO .F.
  DEFAULT ::resize      TO 'yy'

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgTreeView:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'FPOS'
      ::fPos     := _getNumArr(value)
    CASE keyWord == 'SIZE'
      ::size     := _getNumArr(value)
    CASE keyWord == 'TIPTEXT'
      ::tipText := _getStr(value)
    CASE keyWord == 'TREEINIT'
      ::treeInit := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'
      ::itemSelected := _getStr(value)
    CASE keyWord == 'ITEMMARKED'
      ::itemMarked := _getStr(value)
    CASE keyWord == 'PRE'
      ::pre       := _getStr(value)
    CASE keyWord == 'POST'
      ::post      := _getStr(value)
    CASE keyWord == 'HASLINES'
      ::hasLines  := UPPER(_getStr(value)) = 'Y'
    CASE keyWord == 'HASBUTTONS'
      ::hasButtons   := UPPER(_getStr(value)) = 'Y'
    CASE keyWord == 'RESIZE'
      ::resize    := LOWER(_getStr(value) )
    CASE keyWord == 'NAMERESIZE'
      ::name      := UPPER(_getStr(value) )

*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgTreeView:destroy()
  ::type        := ;
  ::name        := ;
  ::fPos        := ;
  ::size        := ;
  ::tipText     := ;
  ::treeInit    := ;
  ::itemSelected:= ;
  ::itemMarked  := ;
  ::pre         := ;
  ::post        := ;
  ::hasLines    := ;
  ::hasButtons  := ;
  ::resize      := ;
                   NIL
RETURN