//////////////////////////////////////////////////////////////////////
//
//  drgListBrowse.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgListBrowse class manages browser objects with ability to add delete records.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#pragma Library( "XppUI2.LIB" )

CLASS drgListBrowse FROM drgBrowse
EXPORTED:
  VAR     oBordBG
  VAR     arEdit

  METHOD  keyboard
  METHOD  setFocus
  METHOD  postValidate
  METHOD  setInputFocus
  METHOD  itemSelected
  METHOD  resize
  METHOD  create
  METHOD  refresh
  METHOD  fromContext
  METHOD  destroy

HIDDEN
  VAR     isEmpty
  VAR     arButtons
  VAR     nButtonPos
  VAR     cEditDialog
  VAR     nRecNOSave
  VAR     menuItems

  METHOD  createContextMenu
  METHOD  createButton
  METHOD  loadData

ENDCLASS

***********************************************************************
* drgListBrowse Class declaration
***********************************************************************
METHOD drgListBrowse:create(oDesc)
LOCAL aPos := {1,1}, size, bBlock, aSize, fPos, nPP
LOCAL x, aHead, sArea, aLen, aFld
LOCAL initBlock, oHlp
LOCAL ar, cFile, cName
LOCAL st, c, oBord

  ::nRecNOSave := 1
  ::isEmpty    := .F.
  ::nButtonPos := 0
  ::menuItems := drgNLS:msg('~Edit,~Add,~Delete,~Up,D~own')

  oBord := ::parent:getActiveArea()
* Position of the field on the screen
  size  := ACLONE(oBord:currentSize())
* Size of a browser border in pixels
  IF oDesc:size = NIL
    aSize := ACLONE(size)
  ELSE
    aSize  := ACLONE(oDesc:size)
    aSize[1] := aSize[1]*drgINI:fontW
    aSize[2] := aSize[2]*drgINI:fontH
  ENDIF
* Position of browser
  fPos := ACLONE(oDesc:fpos)
  aPos[1] := fPos[1]*drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset
/*
  aSize[1] -= 1
  aSize[2] -= 1
  aPos[1]  += 1
  aPos[2]  += 1
*/
* Create nice little border around browser
  ::oBordBG      := XbpStatic():new( oBord, , aPos, aSize)
  ::oBordBG:type := XBPSTATIC_TYPE_TEXT
  ::oBordBG:create()
*
  aSize[2] -= 2*drgINI:fontH
  aPos     := {0,2*drgINI:fontH}

* Create nice little border around browser
  ::oBord      := XbpStatic():new( ::oBordBG, , aPos, aSize)
  ::oBord:type := XBPSTATIC_TYPE_RAISEDBOX
  ::oBord:create()
* resize
  ::canResize := .T.
  ::optResize := oDesc:resize

  aSize[1] -= 8
  aSize[2] -= 8
  aPos     := {4,4}
* PP parameters
  nPP := IIF(EMPTY(oDesc:pp), drgPP_PP_BROWSE2, oDesc:pp)
*
  ::oXbp := XbpBrowse():new( ::oBord, , aPos, aSize, drgPP:getPP(nPP),.T.)
  ::oXbp:cursorMode := oDesc:cursorMode

* Set font and create
  ::oXbp:setFont(drgPP:getFont())
  ::scroll := oDesc:scroll
  ::oXbp:hScroll := SUBSTR(::scroll, 1, 1) = 'y'
  ::oXbp:vScroll := SUBSTR(::scroll, 2, 1) = 'y'
  ::oXbp:create()
* Get memory variable
  cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name := cFile + '->' + cName
  drgLog:cargo := 'ListBrowse: ' + ::name
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg   := self
  ::cEditDialog := IIF(EMPTY(oDesc:edit), '_listBrowseEdit', oDesc:edit)

* Get definitions from FIELDS keyword
  ::isFile := .F.
  ::arDef  := _getBrowseFields(oDesc, self)
* Fill internal data Array
  ::loadData(::oVar:get())
* Create empty line if no data
* Set columns values
  ::nRECNO := 1
  ::oXbp:GoTopBlock    := {|| ::nRECNO := 1 }
  ::oXbp:GoBottomBlock := {|| ::nRECNO := LEN(::arData) }
  ::oXbp:PhyPosBlock   := {|| ::nRECNO }
  ::oXbp:SkipBlock     := {|nSkip| ::arraySkip(nSkip) }

  ::oXbp:FirstPosBlock := {|| 1 }
  ::oXbp:LastPosBlock  := {|| LEN(::arData) }
  ::oXbp:PosBlock      := {|| ::nRECNO }

  FOR x := 1 TO LEN(::arDef)
    ::oXbp:addColumn(::createColumn( ::arDef[x,1], ::arDef[x,2], ::arDef[x,3], ::arDef[x,4], ::arDef[x,5] ) )
  NEXT x

  ::oXbp:cargo := self
* Background color of browser background
  x := AScan( ::oXbp:ChildList(), { | o | o:IsDerivedFrom(XbpStatic()) } )
  IF ::oXbp:hScroll; x++; ENDIF      // If not HScroll than add 1
  ::oXbp:ChildList()[x]:Type := XBPSTATIC_TYPE_TEXT
  ::oXbp:ChildList()[x]:Configure()
  ::oXbp:ChildList()[x]:SetColorBG( drgPP:getPP(nPP)[6,2]) //XBPSYSCLR_3DFACE )

* Call backs
* Set pre & post validation codeblocks, althow they make little sence here
  ::postBlock := ::drgDialog:getMethod( oDesc:post )
  ::preBlock  := ::drgDialog:getMethod( oDesc:pre )
  ::tipText   := drgNLS:msg(oDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp

  ::oXbp:keyboard      := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
  ::oXbp:killInputFocus := { |mp1, mp2, obj| ::killInputFocus( mp1, mp2, obj ) }

* Don't hilite on first show
*  ::scroll := oDesc:scroll
*  ::setScroll(.T.)
  ::oXbp:show()
  ::oXbp:deHilite()
*
  ::createContextMenu(oDesc:operation)
  IF (initBlock := ::drgDialog:getMethod(oDesc:browseInit,'browseInit') ) != NIL
    EVAL(initBlock, self)
  ENDIF

  IF (initBlock := ::drgDialog:getMethod(oDesc:itemSelected,'browseItemSelected') ) != NIL
    ::oXbp:itemSelected := initBlock
  ELSE
    ::oXbp:itemSelected := { |a| ::fromContext(1) }
  ENDIF

  IF (initBlock := ::drgDialog:getMethod(oDesc:itemMarked,'browseItemMarked') ) != NIL
    ::oXbp:itemMarked := initBlock
  ENDIF
  ::oXbp:itemRbDown := { |mp1, mp2, obj| ::oContextMenu:popup( obj, mp1 ) }

* Create buttons
  ::arButtons := {}
  st := ::menuItems
  FOR x := 1 TO 5
    c := drgParse(@st)
    IF LOWER(SUBSTR(oDesc:operation, x, 1) ) = 'y'
      ::createButton(c, x)
    ENDIF
  NEXT

RETURN self

***************************************************************************
* Create buttons under the browser
***************************************************************************
METHOD drgListBrowse:createButton(cTxt, nIx)
LOCAL aSize, aPos, oXbp
  aSize := { (LEN(cTxt) + 1)*drgINI:FontW, drgINI:FontH }
  aPos  := {::nButtonPos*drgINI:FontW, drgINI:FontH/2}
  ::nButtonPos += LEN(cTxt) + 2
*
  oXbp  := XbpPushButton():new()
  oXbp:caption := cTxt
  oXbp:create( ::oBordBG , , aPos, aSize )
  oXbp:pointerFocus := .F.
  oXbp:activate := { |a| ::fromContext(nIx) }
  oXbp:cargo := nIx
*
  AADD(::arButtons, oXbp)
RETURN .T.

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgListBrowse:keyBoard(nKey, mp2, oXbp)

  IF ! ( nKey == xbeK_UP .OR. nKey == xbeK_DOWN )
    IF ::parent:keyHandled(nKey) .AND. ::postValidate()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
    ENDIF
  ENDIF

RETURN .T.

***************************************************************************
* Called by controller when drgObject can receive focus
***************************************************************************
METHOD drgListBrowse:setFocus(mp1, mp2, oXbp)
LOCAL n
  IF !::preValidate()
    PostAppEvent(drgEVENT_OBJEXIT,,, ::oXbp)
  ELSE
    IF ::drgDialog:lastXbpInFocus != self
      n := ::nRecNO
      ::nRecNO := ::nRecNOSave
      ::oXbp:refreshCurrent()
      ::nRecNO := n
      ::oXbp:hilite()
      ::oXbp:refreshAll()
      SetAppFocus( ::oXbp )
    ENDIF
  ENDIF
RETURN self

***************************************************************************
*
***************************************************************************
METHOD drgListBrowse:setInputFocus(mp1, mp2, oXbp)
  IF ::parent:oLastDrg != self
    IF ::parent:ok4Focus(self, oXbp)
      ::setFocus(mp1, mp2, oXbp)
    ENDIF
  ENDIF
RETURN self

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgListBrowse:resize(aOld, aNew)
LOCAL nX, nY, newX, newY
  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
*   New Border size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oBordBG:currentSize()[1]+nX, ;
                                             ::oBordBG:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oBordBG:currentSize()[2]+nY, ;
                                             ::oBordBG:currentSize()[2] )
  ::oBordBG:setSize( {newX,newY}, .F.)
*   New border position
  newX := IIF(SUBSTR(::optResize,1,1) = 'n', ::oBordBG:currentPos()[1]+nX, ::oBordBG:currentPos()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'n', ::oBordBG:currentPos()[2]+nY, ::oBordBG:currentPos()[2] )
  ::oBordBG:setPos( {newX,newY}, .F.)
* Browse background size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oBord:currentSize()[1]+nX, ::oBord:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oBord:currentSize()[2]+nY, ::oBord:currentSize()[2] )
  ::oBord:setSize( {newX,newY}, .F.)
* Browse size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
  ::oXbp:setSize( {newX,newY}, .F.)
*  ::setScroll(.F.)
  ::oXbp:refreshAll()
RETURN self

****************************************************************************
* Default postValidation method of drgObject.
****************************************************************************
METHOD drgListBrowse:postValidate(endCheck)
LOCAL ret := .T., nx, ny, c, c1
  DEFAULT endCheck TO .F.

  IF ::isReadOnly
    ::oVar:recall()
    RETURN .T.
  ENDIF

* End check. On form closing all objects must be postvalidated.
  IF endCheck .AND. ::postValidOK != NIL
    RETURN ::postValidOK
  ENDIF
* Set data to memvar
  c := ''
  IF !::isEmpty
    FOR nx := 1 TO LEN(::arData)
      c1 := ''
      FOR ny := 1 TO LEN(::arData[nx])
        c1 += IIF(ny > 1, ':', '') + ALLTRIM( ::arData[nx, ny] )
      NEXT
* Remove nonexisting elements
      c1 := RTRIM(c1)
      WHILE LEN(c1) > 0 .AND. RIGHT(c1, 1) = ':'
        c1 := RTRIM(LEFT(c1, LEN(c1) - 1) )
      ENDDO
      c += IIF(nx > 1, ',', '') + c1
    NEXT
  ENDIF
  ::oVar:getSet(c)
* Call postvalidate
  IF ::postBlock != NIL
    ret := EVAL(::postBlock, ::oVar)
  ENDIF
  ::postValidOK := ret
*
  IF ret
    ::oXbp:deHilite()
*    ::oXbp:refreshCurrent()
    ::nRecNOSave  := ::nRecNO
  ELSE
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF
RETURN ret

***************************************************************************
* Item selected. Inform dialog to go to edit state.
***************************************************************************
METHOD drgListBrowse:itemSelected()
  ::fromContext(1)
RETURN self


***************************************************************************
* Refresh internal browser values
***************************************************************************
METHOD drgListBrowse:refresh(xNewValue)
  ::loadData(xNewValue)
  ::nRecNo := 1
  ::oXbp:RefreshAll()
  IF ::parent:oLastDrg = self
    ::oXbp:Hilite()
  ELSE
    ::oXbp:deHilite()
  ENDIF

RETURN

***************************************************************************
* Transforms string data into array
***************************************************************************
METHOD drgListBrowse:loadData(cVal)
LOCAL ar, c, cLine, x
  ::arData := {}
  IF EMPTY(cVal)
    ::isEmpty := .T.
    ar := {}
    AEVAL(::arDef, {|el| AADD(ar,'') } )
    AADD(::arData, ar)
  ELSE
    ::isEmpty := .F.
    WHILE !EMPTY( cLine := drgParse(@cVal) )
      ar := {}
      FOR x := 1 TO LEN(::arDef)
* Parse elements and ensure length
        IF EMPTY( c := drgParse(@cLine,':') )
          c := ' '
        ENDIF
        AADD(ar, c)
      NEXT
      AADD(::arData, ar)
    ENDDO
  ENDIF
RETURN

****************************************************************************
* Run from context menu and when button is selected
****************************************************************************
METHOD drgListBrowse:fromContext(nChoice)
LOCAL ar, cEdit, x
LOCAL oDialog, nExit
* Must be selected before can be updated
  IF ::parent:oLastDrg != self
    SetAppFocus(::parent:oLastDrg:oXbp)
    RETURN
  ENDIF
*
  SetAppFocus(::oXbp)
  DO CASE
* EDIT
    CASE nChoice = 1 .AND. !::isEmpty
      ::arEdit := ACLONE(::arData[::nRECNO])
* Dialog may not be defined
      nExit := drgEVENT_QUIT
      DRGDIALOG FORM ::cEditDialog CARGO self EXITSTATE nExit  PARENT ::drgDialog MODAL DESTROY
      IF nExit != drgEVENT_QUIT
        ::arData[::nRECNO] := ACLONE(::arEdit)
      ENDIF
      ::oXbp:RefreshAll()

* ADD
    CASE nChoice = 2
      ::arEdit := {}
      AEVAL(::arDef, {|el| AADD(::arEdit,'') } )
* Dialog may not be defined
      nExit := drgEVENT_QUIT
      DRGDIALOG FORM ::cEditDialog CARGO self EXITSTATE nExit PARENT ::drgDialog MODAL DESTROY
      IF nExit != drgEVENT_QUIT
* If was empty update 1'st blank record
        IF ::isEmpty
          ::arData[1] := ACLONE(::arEdit)
        ELSE
          ar := ACLONE(::arData)
          ::arData := {}
          FOR x := 1 TO LEN(ar)
            AADD(::arData, ACLONE(ar[x]) )
            IF x = ::nRECNO
              AADD(::arData, ACLONE(::arEdit))
            ENDIF
          NEXT
        ENDIF
        ::isEmpty := .F.
      ENDIF
      ::oXbp:RefreshAll()
      ::oXbp:down()
      ::oXbp:RefreshAll()

* DELETE
    CASE nChoice = 3 .AND. !::isEmpty
      ar := ACLONE(::arData)
      ::arData := {}
      AEVAL(ar, { |el, n| IIF(n = ::nRECNO,,AADD(::arData, el)) } )
* Last deleted. Add blank.
      IF LEN(::arData) = 0
        ar := {}
        AEVAL(::arDef, {|el| AADD(ar,'') } )
        AADD(::arData, ar)
        ::isEmpty := .T.
      ENDIF
      ::oXbp:RefreshAll()

* UP
    CASE nChoice = 4 .AND. ::nRECNO > 1
      ar := ACLONE(::arData[::nRECNO - 1])
      ::arData[::nRECNO - 1] := ACLONE(::arData[::nRECNO])
      ::arData[::nRECNO]     := ACLONE(ar)
      ::oXbp:RefreshAll()
      ::oXbp:up()
      ::oXbp:RefreshAll()

* DOWN
    CASE nChoice = 5.AND. ::nRECNO < LEN(::arData)
      ar := ACLONE(::arData[::nRECNO + 1])
      ::arData[::nRECNO + 1] := ACLONE(::arData[::nRECNO])
      ::arData[::nRECNO]     := ACLONE(ar)
      ::oXbp:RefreshAll()
      ::oXbp:down()
      ::oXbp:RefreshAll()
  ENDCASE
RETURN self


****************************************************************************
* Create List browser context menu
****************************************************************************
METHOD drgListBrowse:createContextMenu(cOPer)
LOCAL x, st, c
  ::oContextMenu := XbpMenu():new( ::oXbp ):create()
  st := ::menuItems
  x := 0
  WHILE !EMPTY( c := drgParse(@st) )
    IF SUBSTR(cOper, ++x, 1) = 'y'
      ::oContextMenu:addItem( { c, _browseContext( self, x ) } )
    ENDIF
  ENDDO

RETURN self

****************************************************************************
* Destroy
****************************************************************************
METHOD drgListBrowse:destroy()
  AEVAL(::arButtons, { |e| e:destroy() } )
  ::drgBrowse:destroy()
  ::oBordBG:destroy()

  ::isEmpty     := ;
  ::arButtons   := ;
  ::nButtonPos  := ;
  ::cEditDialog := ;
  ::oBordBG     := ;
  ::arEdit      := ;
                   NIL

RETURN self


**************************************************************************
* Clean UP
**************************************************************************
/*
METHOD drgListBrowse:destroy()
  ::drgBrowse:destroy()
RETURN
*/
************************************************************************
************************************************************************
*
* ListBrowse type definition class
*
************************************************************************
************************************************************************
CLASS _drgListBrowse FROM _drgBrowse
EXPORTED

  VAR edit
  VAR operation

  METHOD init
  METHOD parse
  METHOD destroy
ENDCLASS
************************************************************************
* Init
************************************************************************
METHOD _drgListBrowse:init(line)
  ::type := 'listBrowse'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fPos  TO {0, 0}
  DEFAULT ::cursorMode TO XBPBRW_CURSOR_ROW
  DEFAULT ::pp         TO 1
  DEFAULT ::scroll     TO 'yy'
  DEFAULT ::resize     TO 'yy'
  DEFAULT ::operation  TO 'yyyyy'

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgListBrowse:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'FIELDS'
      ::fields := _getStr(value)
    CASE keyWord == 'BROWSEINIT'
      ::browseInit := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'
      ::itemSelected := _getStr(value)
    CASE keyWord == 'ITEMMARKED'
      ::itemMarked := _getStr(value)
    CASE keyWord == 'LOAD'
      ::itemMarked := _getStr(value)
    CASE keyWord == 'CURSORMODE'
      ::cursorMode := _getNum(value)
    CASE keyWord == 'INDEXORD'
      ::indexord  := _getNum(value)
    CASE keyWord == 'SCROLL'
      ::scroll    := LOWER( _getStr(value) )
    CASE keyWord == 'OPERATION'
      ::operation := LOWER( _getStr(value) )
    CASE keyWord == 'EDIT'
      ::edit      := _getStr(value)

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgListBrowse:destroy()
  ::_drgBrowse:destroy()
  ::operation := ;
  ::edit      := ;
                 NIL
RETURN

************************************************************************
* Default editor dialog for listBrowse object
************************************************************************
CLASS _listBrowseEdit from drgUsrClass
EXPORTED:
  VAR     oClass
  VAR     arEdit

  METHOD  getForm
  METHOD  destroy

ENDCLASS

************************************************************************
* myPrintDialog initialization method.
************************************************************************
METHOD _listBrowseEdit:getForm()
LOCAL n, cSize, aForm
LOCAL cLen, cPic, c, cPos
  aForm := {}
  ::oClass := ::drgDialog:cargo
  ::arEdit := ::oClass:arEdit
*
  cSize := 'SIZE(50,' + STR( LEN(::oClass:arEdit) + 2) + ')'
  AADD(aForm,'TYPE(DRGFORM) DTYPE(0) GUILOOK(All:N,Action:Y) ' + cSize)
  AADD(aForm, 'TYPE(ACTION) CAPTION(Save) EVENT(140000001) PRE(2) ATYPE(3) ICON1(101) ICON2(201)')
  AADD(aForm, 'TYPE(ACTION) CAPTION(Cancel) EVENT(140000002)  ATYPE(3) ICON1(102) ICON2(202)')

  n := 1
  FOR n := 1 TO LEN(::oClass:arDef)
    cPos := ALLTRIM(STR(n))
*   Fix length to 32
    cLen := ALLTRIM( STR(IIF(::oClass:arDef[n,3] > 32, 32, ::oClass:arDef[n,3] )) )
    cPic := ALLTRIM( STR(::oClass:arDef[n,3]) )
    c := 'TYPE(GET) NAME(arEdit:'+ ALLTRIM(STR(n)) +')' + ;
         'FPOS(15,' + cPos + ')' + ;
         'FLEN(' + cLen + ')PICTURE(&' + cPic + 'X)' + ;
         'CPOS(1,'   + cPos + ')' + ;
         'FCAPTION(' + ::oClass:arDef[n,1] + ')'

    AADD(aForm, c)
  NEXT

RETURN drgFormContainer():new(aForm)

************************************************************************
* Cleanup
************************************************************************
METHOD _listBrowseEdit:destroy()
  ::drgUsrClass:destroy()
  ::oClass  := ;
  ::arEdit  := ;
              NIL
RETURN

