//////////////////////////////////////////////////////////////////////
//
//  drgTabPage.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgTabPage class holds and manages tabPages located on the current form.
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



* Class declaration
***********************************************************************
CLASS drgTabPage FROM drgObject
EXPORTED:
  VAR       onFormIndex, tabNumber, tabBrowse
  var       subTabs, subs
  *
  var       is_show

  METHOD    init
  METHOD    create
  METHOD    destroy
  METHOD    resize

  METHOD    setFocus
  METHOD    firstEditTab
  METHOD    preValidate
  METHOD    setPreValidate

HIDDEN:
  VAR       tabManager, tabExt   // , is_show
  method    set_subTabs

ENDCLASS

*************************************************************************
* Initialization of TabPage
*
* Parameters:
* \b<parentForm>b\    : drgForm : Form that holds this drgTabPage
*
* \bReturns:b\        : self
*************************************************************************
METHOD drgTabPage:init(parent)
  ::drgObject:init(parent)
RETURN self

*************************************************************************
* Adds new tabPage to drgTabPage.
*
* Parameters:
* \b<aDesc>b\     : drgField : drgField line description
*
* \bReturns:b\    : self
*************************************************************************
METHOD drgTabPage:create(aDesc)
  LOCAL aPos :={1,1}, tpSize, tpPos, size, tabNum, aArea
  local nlen := 1
  *
  local obmp_bookOpen := XbpBitMap():new():create()
  local obmp_edit     := XbpBitMap():new():create()

  ::isGroup := .T.

  ::tabManager := ::parent:tabPageManager
  ::tabExt     := adesc:tabExt
  ::subTabs    := adesc:subTabs
  ::subs       := adesc:subs

  aArea := ::parent:getActiveArea()
* Position of the tabpage on the screen
  size := ACLONE( aArea:currentSize() )
  IF aDesc:size != NIL
* Size of a TabPage in pixels
    tpSize := ACLONE(aDesc:size)
    tpSize[1] := tpSize[1]*drgINI:fontW + 2
    tpSize[2] := tpSize[2]*drgINI:fontH + 2
* Position of TabPage
    tpPos   := ACLONE(aDesc:fpos)
    aPos[1] := tpPos[1] * drgINI:fontW - 1
    aPos[2] := size[2] - tpPos[2]*drgINI:fontH - tpSize[2] + 1
  ELSE
    tpSize    := size
    tpSize[1] += 2
    tpSize[2] += 2
    aPos      := {-1,-1}
  ENDIF

//  ::oXbp := XbpTabPage():new( aArea,, aPos, tpSize )
  ::oXbp := XbpImageTabPage():new( aArea,, aPos, tpSize )

  ::tabManager:add(self)
* Set first tab to maximized when created
  IF (tabNum := LEN(::tabManager:members)) = 1
    ::oXbp:setColorFG( GRA_CLR_BLUE)
    ::oXbp:minimized    := .F.
    ::tabManager:active := self
    ::is_show           := .t.
  ELSE
    ::oXbp:minimized := ::set_subTabs()
    ::is_show        := .not. ::oXbp:minimized
  ENDIF

  nlen := if( tabNum < 10, 1, 2)
  ::oXbp:caption := '~' + STR(tabNum,nlen,0) + ':' + drgNLS:msg( aDesc:caption )

  * DC2 - bmp
  if isObject(::drgDialog:dialogCtrl)
    if ::drgDialog:dialogCtrl:className() = 'drgDC2'
      if tabNum = 1
        obmp_bookOpen:load( ,303)
        obmp_bookOpen:TransparentClr := obmp_bookOpen:GetDefaultBGColor()

        ::oxbp:setImage(obmp_bookOpen)
      else
        obmp_edit:load( ,315)
        obmp_edit:TransparentClr := obmp_edit:GetDefaultBGColor()

        ::oxbp:setImage(obmp_edit)
      endif
    endif
  endif

* Prevalidates if it can get focus
  ::setPreValidate(aDesc)
* Other stuff
  ::oXbp:tabHeight := aDesc:tabHeight*drgINI:fontH
  ::oXbp:preOffset := aDesc:offset[1]
  ::oXbp:postOffset:= aDesc:offset[2]
  ::oXbp:type      := aDesc:ttype
  ::oXbp:setFont(drgPP:getFont())
  ::oXbp:cargo     := self
  ::oXbp:create()
* resize
  ::canResize := .T.
  ::optResize := aDesc:resize
  ::tabNumber := tabNum
  ::tabBrowse := aDesc:tabBrowse
*
*  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setFocus( tabNum ) }

  ::oXbp:TabActivate  := {|a| ::setFocus(tabNum) }
RETURN


method drgTabPage:set_subTabs(in_setFocus)
  local  x, tab, is_minimized := .t., pos

  if .not. empty(::subs)
     ::oXbp:setColorFG( GRA_CLR_BLACK)
     for x := 1 to len(::tabManager:members) step 1
       if .not. empty(tab := ::tabManager:members[x]:subTabs)
         pos          := ascan(tab,::subs)
         is_minimized := (pos <> 1)
       endif
     next
  endif
return is_minimized



***********************************************************************
* Called on tab activate event
* Parameters:
* \b<tabNum>b\    : number  : TabPage number to activate
*
* \bReturns:b\    : boolean : True if succeided
*************************************************************************
METHOD drgTabPage:setFocus(tabNum, lsetFocus)
LOCAL x, or_tabnum := ::tabNumber, ok, new_subs, subs

default lsetFocus   to .t.

* Multiple clicks on already active TAB
  IF ::tabManager:active = self .AND. tabNum != NIL

     if isObject(::drgDialog:lastXbpInFocus)
       setAppFocus( ::drgDialog:lastXbpInFocus )
     endif

    RETURN self
  ENDIF
* Tab page was clicked or selected via shortkey
  IF tabNum != NIL
    IF !::parent:ok4Focus(self, ::oXbp) .OR. !::preValidate(tabNum)
* Return focus back
      SetAppFocus(::drgDialog:oForm:oLastDrg:oXbp)
      RETURN self
    ENDIF
  ELSE
* Check if can be selected
    tabNum := IIF(::tabNumber = 1, 1, ::tabNumber - 1)
    IF !::preValidate(tabNum)
*      SetAppFocus(::drgDialog:oForm:oLastDrg:oXbp)
      RETURN self
    ENDIF
* Going back. Activate previous tabpage
    IF ::drgDialog:oForm:nExitState = GE_UP
* Problem when first next object doesn't get prevalidation OK
**      ::drgDialog:oForm:nExitState = GE_DOWN
    ELSE
      tabNum := ::tabNumber
    ENDIF
  ENDIF

* Minimize currently active if not on initialization
  ok := if( ::tabExt, ;
          (tabNum <> or_tabNum .or. ::tabManager:members[tabNum]:oXbp:minimized), .t.)
  ok := (ok .and. .not. ::tabManager:members[tabNum]:is_show)

  if ok
    * Maximize selected TABPAGE and set next focusable field
    ::drgDialog:oForm:setNextFocus(::tabManager:members[tabNum]:onFormIndex + 1)
*****
*****    ::tabManager:members[tabNum]:oXbp:setColorFG( GRA_CLR_BLUE)
*****
    ::tabManager:members[tabNum]:oXbp:maximize()
    new_subs := ::tabManager:members[tabNum]:subs
    *
    **
    if .not. empty(new_subs)
      for x := 1 TO len(::tabManager:members) step 1
        if .not. empty(subs := ::tabManager:members[x]:subs)
          if subs <> new_subs
****            ::tabManager:members[x]:oxbp:minimize()
            ::tabManager:members[x]:is_show := .f.
            ::tabManager:members[x]:oXbp:setColorFG(GRA_CLR_BLACK)
          endif
        endif
      next
    else
      for x := 1 TO len(::tabManager:members) step 1
        if empty(::tabManager:members[x]:subs)
          if ::tabManager:members[tabNum] <> ::tabManager:members[x]
            ::tabManager:members[x]:oxbp:setColorFG(GRA_CLR_BLACK)
            ::tabManager:members[x]:oxbp:minimize()
            ::tabManager:members[x]:is_show := .f.
          endif
        endif
      next
    endif
    *
    **
    ::tabManager:active := ::tabManager:members[tabNum]
    ::tabManager:active:is_show := .t.

    if .not. empty(::subTabs)
      BEGIN SEQUENCE
        for x := 1 TO len(::tabManager:members) step 1
          if .not. empty(subs := ::tabManager:members[x]:subs)
            pos          := ascan(::subTabs,subs)
            if pos = 1
              ::tabManager:members[x]:oxbp:maximize()
      BREAK
            endif
          endif
       next
      END SEQUENCE
    endif
  else
    ::tabManager:active := ::tabManager:members[tabNum]
  endif

  if lsetFocus
    PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp) // send exit message to form
  endif
RETURN self



***********************************************************************
* Activates first TAB page with editable elements on.
*
* \bReturns:b\    : boolean : True if succesfull.
*************************************************************************
METHOD drgTabPage:firstEditTab()
RETURN ::setFocus(2)

***********************************************************************
* Activates first TAB page with editable elements on.
*
* \bParameters:b\
* \b< TabNum >b\  : number : activating tabPage number
*
* \bReturns:b\    : boolean : True if succesfull.
*************************************************************************
METHOD drgTabPage:preValidate(tabNum)
LOCAL ret := .T.
  IF ::preBlock != NIL
    ret := EVAL(::preBlock, self, tabNum)
  ENDIF
* Set postValidOK flag to true if prevalidation fails.
  ::postValidOK := NIL
RETURN ret

****************************************************************************
* Sets default prevalidation codeblock for drgObject
****************************************************************************
METHOD drgTabPage:setPreValidate(aDesc)
  IF aDesc:pre != NIL
    ::preBlock := ::drgDialog:getMethod(aDesc:pre)
  ENDIF
RETURN self

***************************************************************************
* Method is called on window object resize event.
***************************************************************************
METHOD drgTabPage:resize(aOld, aNew)
  LOCAL nX, nY, newX_pos , newY_pos
  local         newX_size, newY_size

  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]

* New tabPage size
  newX_size := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY_size := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
*  ::oXbp:setSize( {newX,newY}, .F.)

* New tabPage Pos
  newX_pos := IIF(SUBSTR(::optResize,1,1) = 'n', ::oXbp:currentPos()[1]+nX, ::oXbp:currentPos()[1] )
  newY_pos := IIF(SUBSTR(::optResize,2,1) = 'n', ::oXbp:currentPos()[2]+nY, ::oXbp:currentPos()[2] )
*  ::oXbp:setPos( {newX,newY}, .F.)

  ::oxbp:setPosAndSize( {newX_pos,newY_pos}, {newX_size,newY_size}, .f. )
RETURN self

***********************************************************************
* Releases this objects internal variables.
*************************************************************************
METHOD drgTabPage:destroy()
  ::drgObject:destroy()

  ::tabManager  := ;
  ::tabNumber   := ;
  ::onFormIndex := ;
                    NIL
RETURN .T.

************************************************************************
************************************************************************
*
* TabPage type definition class
*
************************************************************************
************************************************************************
static function _getStrArr(cList,cDelimiter)
  LOCAL nPos
  LOCAL aList := {}

  DEFAULT cDelimiter To ','
  Do While (nPos := aT( cDelimiter, cList)) != 0
    aAdd( aList, SubStr( cList, 1, nPos - 1))
    cList := SubStr( cList, nPos +Len( cDelimiter) )
  EndDo
  aAdd(aList, cList)
return(aList)



CLASS _drgTabPage
  EXPORTED:

  VAR     type
  VAR     ttype
  VAR     caption
  VAR     fpos
  VAR     size
  VAR     pre
  VAR     post
  VAR     offset
  VAR     tabHeight
  VAR     resize
  VAR     tipText
  VAR     tabBrowse                                                             // miss
  var     tabExt
  var     subTabs, subs

  METHOD  init
  METHOD  destroy

  HIDDEN:
  METHOD  parse

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgTabPage:init(line)
  ::type := 'tabpage'
  ::offSet := {0,84}

  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::ttype     TO 4
  DEFAULT ::fpos      TO {0, 0}
  DEFAULT ::tabHeight TO 1
  DEFAULT ::resize    TO 'yy'
  DEFAULT ::caption   TO ''
  default ::tabExt    to .f.
  default ::subTabs   to {}
  default ::subs      to ''
  default ::tabBrowse to ''

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgTabPage:parse(line)
LOCAL keyWord, value

  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'TTYPE'
      ::ttype    := _getNum(value)
    CASE keyWord == 'CAPTION'
      ::caption  := _getStr(value)
    CASE keyWord == 'FPOS'
      ::fpos     := _getNumArr(value)
    CASE keyWord == 'SIZE'
      ::size    := _getNumArr(value)
    CASE keyWord == 'OFFSET'
      ::offset  := _getNumArr(value)
    CASE keyWord == 'PRE'
      ::pre  := _getStr(value)
    CASE keyWord == 'POST'
      ::post := _getStr(value)
    CASE keyWord == 'TIPTEXT'
      ::tipText := _getStr(value)
    CASE keyWord == 'TABHEIGHT'
      ::tabHeight := _getNum(value)
    CASE keyWord == 'RESIZE'
      ::resize    := LOWER(_getStr(value) )
    CASE keyWord == 'TABBROWSE'
      ::tabBrowse := UPPER(_getStr(value) )
    case keyWord == 'EXT'
      ::tabExt    := .t.
    CASE keyWord == 'SUBTABS'
      ::subTabs   := _getStrArr(value)
    CASE keyWord == 'SUB'
      ::subs      := _getStr(value)

*    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgTabPage:destroy()

  ::type      := ;
  ::ttype     := ;
  ::caption   := ;
  ::fpos      := ;
  ::size      := ;
  ::pre       := ;
  ::post      := ;
  ::offset    := ;
  ::tabHeight := ;
  ::resize    := ;
  ::tipText   := ;
  ::subTabs   := ;
  ::subs      := ;
  ::tabBrowse := ;
                 NIL
RETURN


***************************************************************************
***************************************************************************
* drgTabManager
***************************************************************************
***************************************************************************
CLASS drgTabManager
EXPORTED:
  VAR     members, oForm, active

  METHOD  init
  METHOD  add
  METHOD  shortcut
  METHOD  toFront
  METHOD  showPage
  METHOD  destroy
ENDCLASS

******************************************************************
* drgTabManager initialization
******************************************************************
METHOD drgTabManager:init(oParent)
  ::oForm := oParent
  ::members  := {}
RETURN self

******************************************************************
* Add new drgTabPage to manager.
******************************************************************
METHOD drgTabManager:add(tab)
  AADD(::members, tab)
RETURN


******************************************************************
* Check if keypressed is a shortcut to tabPage. If so activate selected tabpage.
******************************************************************
METHOD drgTabManager:shortcut(nKey)
LOCAL aKey
  IF nKey < xbeK_ALT_1 .OR. nKey > xbeK_ALT_9
    RETURN .F.
  ENDIF

* konvert key to ascii value
  aKey := nKey - xbeK_ALT_1 + 1
RETURN ::toFront(aKey)

******************************************************************
* Forces tabPage to be activated to front
******************************************************************
METHOD drgTabManager:toFront(pageNum)
* If greater than length than do nothing
  IF pageNum > LEN(::members)
    RETURN .F.
  ENDIF
* Already selected. Do nothing
  IF ::members[pageNum] = ::active
    RETURN .T.
  ENDIF
* Activate proper tabPage
  postAppEvent(xbeTab_TabActivate,,,::members[pageNum]:oxbp )
//  ::members[pageNum]:setFocus(pageNum)
RETURN .T.

******************************************************************
* Displays requested page. Page is displayed without focus beeing transfered \
* to first editable field on a tabPage. This method is usefull when tabPage is \
* displayed without tabs and pages are selected with program.
******************************************************************
METHOD drgTabManager:showPage(nPageNum, lSetFocus)
LOCAL n
  DEFAULT lSetFocus TO .F.
  IF VALTYPE(nPageNum) = 'O'
* Already selected. Do nothing
    IF nPageNum = ::active
      RETURN .T.
    ENDIF
*
    IF (n := ASCAN( ::members, {|x| nPageNum = x} ) ) > 0
      nPageNum := n
    ELSE
      RETURN .F.
    ENDIF
  ENDIF
*
  IF nPageNum > LEN(::members)
* If greater than length than do nothing
    RETURN .F.
  ENDIF
*
* Already selected. Do nothing
  if ::members[nPageNum] != ::active
    ::members[nPageNum]:setFocus(nPageNum,lsetFocus)
  endif


/*
  IF ::members[nPageNum] != ::active
*    RETURN .T.
*  ENDIF
* Activate proper tabPage
    IF ::active != NIL
      ::active:oXbp:setColorFG( GRA_CLR_BLACK)
      ::active:oXbp:minimize()
    ENDIF
    ::members[nPageNum]:oXbp:setColorFG( GRA_CLR_BLUE)
    ::active := ::members[nPageNum]
    ::active:oXbp:maximize()
  ENDIF
*
  IF lSetFocus
*    ::toFront(nPageNum)
    ::oForm:setNextFocus(::active:onFormIndex + 1)
    PostAppEvent(drgEVENT_OBJEXIT, ::active,, ::active:oXbp) // send exit message to form
  ENDIF
*/
RETURN .T.

******************************************************************
* Cleanup
******************************************************************
METHOD drgTabManager:destroy()
  ::members := ;
  ::active  := ;
  ::oForm   := ;
               NIL
RETURN