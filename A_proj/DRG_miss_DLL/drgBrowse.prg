//////////////////////////////////////////////////////////////////////
//
//  drgBrowse.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgBrowse class manages a single xbpQBrowse object in a form.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
#pragma Library( "XppUI2.LIB" )


# DEFINE    COMPILE(c)         &("{||" + c + "}")
#define xbeUser_Eval   xbeP_User + 1

***********************************************************************
* drgBrowse Class declaration
***********************************************************************
CLASS drgBrowse FROM drgObject
  EXPORTED:
    VAR     oBord
    VAR     dbArea
    VAR     isFile
    VAR     oContextMenu
    VAR     oSortMenu
    VAR     nRECNO
    VAR     arData
    VAR     arSELECT
    VAR     popupMenu
    VAR     cIncSearch
    VAR     Colored
    VAR     selCol

    METHOD  keyboard
    METHOD  setFocus
    METHOD  postValidate
    METHOD  setInputFocus
    METHOD  killInputFocus
    METHOD  createColumn
    METHOD  itemSelected
    METHOD  itemMarked
    METHOD  processWheel
    METHOD  createContextMenu
    METHOD  fromContext
    METHOD  refresh
    METHOD  lastRow2Bottom
    METHOD  arraySkip
    METHOD  objectSkip
    METHOD  getObjSize
    METHOD  setScroll
    METHOD  HeaderRbDown

*  EXPORTED:
    VAR     cFile, arDef
    VAR     scroll

    METHOD  create
    METHOD  destroy
    METHOD  resize

    METHOD  dlgSearch                 // miss
ENDCLASS

***********************************************************************
* drgBrowse Class declaration
***********************************************************************
METHOD drgBrowse:create(oDesc)
LOCAL aPos := {1,1}, size, bBlock, aSize, fPos, aPP
LOCAL aOrd, n, cAlias
LOCAL x, aHead, sArea, aLen, aFld
LOCAL oBord, initBlock, oHlp
LOCAL cFile, cName, aDBD, arFreeze
  oBord := ::parent:getActiveArea()
  drgLog:cargo := 'Browse:AT START'
  ::nRECNO     := 1
  ::selCol     := 0
  ::arSELECT   := {}
  ::popupMenu  := IF( IsMemberVar( oDesc, 'popupMenu'), oDesc:popupMenu, 'yy' )
  ::cIncSearch := ''

  ::Colored    := IF( LEN( oDesc:colored) > 0, ListAsArray( oDesc:colored),;
                                               {'-54', '-34', '1'} )
  IF( LEN( ::Colored) = 2, AADD( ::Colored, '1' ), NIL )

  IF (initBlock := ::drgDialog:getMethod(oDesc:browseInit,'browseInit') ) != NIL
    EVAL(initBlock, self)
  ENDIF

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
  aPos[1] := fPos[1]*drgINI:fontW  + ::parent:leftOffset
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset

* Create nice little border around browser
  ::oBord      := XbpStatic():new( oBord, , aPos, aSize)
  ::oBord:type := XBPSTATIC_TYPE_RAISEDBOX
  ::oBord:create()
* resize
  ::canResize := .T.
  ::optResize := oDesc:resize
*
  aSize[1] -= 8
  aSize[2] -= 8
  aPos     := {4,4}
* PP parameters
  aPP := IIF(LEFT(oDesc:type, 2) = 'ed', drgPP_PP_BROWSE4, drgPP_PP_BROWSE1 )
  aPP := IIF(EMPTY(oDesc:pp), aPP, oDesc:pp)
*
  ::oXbp := XbpBrowse():new( ::oBord, , aPos, aSize , drgPP:getPP(aPP) ) //PRESPARAM_SYSTEM)
  ::oXbp:cursorMode := oDesc:cursorMode
* Get file name
  ::cFile  := IIF(oDesc:file = NIL, ::drgDialog:formHeader:file, oDesc:file)
  ::isFile := .NOT. ( UPPER( LEFT(::cFile, 3) ) = 'ARR' .OR. UPPER( LEFT(::cFile, 3) ) = 'OBT' )
* Open file and set working index
  IF ::isFile
*    drgDump(::cFile)
    aDBD := drgDBMS:getDBD(::cFile)
    aDBD:open()                                      // open db File
    ::dbArea := SELECT()   // ALIAS( SELECT())                             // get area number

    cAlias   := Lower( Alias(::dbArea))           // nastavení uloženého tøídìní
*-    aOrd := GetSaveDialogPos(::drgDialog:formName,::drgDialog:parentDialog, .T., .T.)
*-    if .not. Empty(aOrd)
*-      if Len(aOrd) == 5
*-        if ( n := At(cAlias+'.', aOrd[5]))> 0
*-          oDesc:indexord := Val( Substr(aOrd[5], n+Len(cAlias)+2, 3))
*-        endif
*-      endif
*-    endif

    AdsSetOrder(oDesc:indexord)
    DBGOTOP()
  ENDIF
  ::drgDialog:dialogCtrl:registerBrowser(self)
  ::arDef  := _getBrowseFields(oDesc, self)
* Set font and create
  ::oXbp:setFont(drgPP:getFont())
  ::scroll := oDesc:scroll
  ::oXbp:hScroll := SUBSTR(::scroll, 1, 1) = 'y'
  ::oXbp:vScroll := SUBSTR(::scroll, 2, 1) = 'y'
  ::oXbp:create()
* This may come handy with post and prevalidation of Browser.
* Otherwise oVar is not needed.
  ::oVar := ::oXbp
  drgLog:cargo  := 'Browse: ' + ::cFile

* Create navigation codeblocks
  IF ::isFile
* navigation codeblocks for browsing file
    aDBD:setBrowseCodeBlocks(::oXbp, ::dbArea)
    FOR x := 1 TO LEN(::arDef)
      ::oXbp:addColumn(::createColumn( ::arDef[x,1], ::arDef[x,2], ::arDef[x,3], ::arDef[x,4], ::arDef[x,5]))
    NEXT x
*    ::createContextMenu(oDesc, aDBD)

  ELSEIF LEFT(::cFile, 3) = 'ARR'
* navigation codeblocks for browsing array
    ::oVar := ::drgDialog:dataManager:add(,::cFile)
    ::oVar:oDrg := self
    ::arData    := ::oVar:get()
*
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

  ELSEIF LEFT(::cFile, 3) = 'OBT'
* navigation codeblocks for browsing object
    ::oVar      := ::drgDialog:dataManager:add(,::cFile)
    ::oVar:oDrg := self
    ::arData    := ::oVar:get()
*
    ::oXbp:GoTopBlock    := {|| ::nRECNO := 1 }
    ::oXbp:GoBottomBlock := {|| ::nRECNO := ::getObjSize() }
    ::oXbp:PhyPosBlock   := {|| ::nRECNO }
    ::oXbp:SkipBlock     := {|nSkip| ::objectSkip(nSkip) }
*
    ::oXbp:FirstPosBlock := {|| 1 }
    ::oXbp:LastPosBlock  := {|| ::getObjSize() }
    ::oXbp:PosBlock      := {|| ::nRECNO }
    FOR x := 1 TO LEN(::arDef)
      ::oXbp:addColumn(::createColumn( ::arDef[x,1], ::arDef[x,2], ::arDef[x,3], ::arDef[x,4], ::arDef[x,5] ) )
    NEXT x
  ENDIF

* Freezed columns
  IF !EMPTY(oDesc:lFreeze)
    ::oXbp:setLeftFrozen(GetFreeze(oDesc:lFreeze) )
  ENDIF
  IF !EMPTY(oDesc:rFreeze)
    ::oXbp:setRightFrozen(GetFreeze(oDesc:rFreeze) )
  ENDIF

  ::oXbp:cargo := self
* Background color of browser background
  x := AScan( ::oXbp:ChildList(), { | o | o:IsDerivedFrom(XbpStatic()) } )

  IF ::oXbp:hScroll; x++; ENDIF      // If not HScroll than add 1
  ::oXbp:ChildList()[x]:Type := XBPSTATIC_TYPE_TEXT
  ::oXbp:ChildList()[x]:Configure()
  ::oXbp:ChildList()[x]:SetColorBG( drgPP:getPP(aPP)[6,2]) //XBPSYSCLR_3DFACE )


* Call backs
* Set pre & post validation codeblocks, althow they make little sence here
  ::postBlock := ::drgDialog:getMethod( oDesc:post )
  ::preBlock  := ::drgDialog:getMethod( oDesc:pre )
  ::tipText   := drgNLS:msg(oDesc:tipText)
  ::name := IIF(oDesc:name = NIL, 'BROWSE', oDesc:name)

* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + ::name )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp

  ::oXbp:keyboard       := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus  := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
  ::oXbp:killInputFocus := { |mp1, mp2, obj| ::killInputFocus( mp1, mp2, obj ) }

* Don't hilite on first show
*  ::scroll := oDesc:scroll
*  ::setScroll(.T.)
  ::oXbp:show()
*  ::oXbp:deHilite()

  drgLog:cargo := 'Browse:CALLBACKS '
*  IF (initBlock := ::drgDialog:getMethod(oDesc:browseInit,'browseInit') ) != NIL
*    EVAL(initBlock, self)
*  ENDIF

* ItemSelected callback
  IF (initBlock := ::drgDialog:getMethod(oDesc:itemSelected,'browseItemSelected') ) = NIL
    initBlock := { |a| ::itemSelected(self) }
  ENDIF
  ::oXbp:itemSelected := initBlock
* ItemMarked callback
  IF (initBlock := ::drgDialog:getMethod(oDesc:itemMarked,'browseItemMarked') ) = NIL
    initBlock := { |a| ::itemMarked(self) }
  ENDIF
  ::oXbp:itemMarked := initBlock
*
  IF ::isFile
    ::oXbp:itemRbDown := { |mp1, mp2, obj|(::createContextMenu(oDesc, aDBD), ::oContextMenu:popup( obj, mp1 )) }
  ENDIF
  ::oXbp:HeaderRbDown := { |mp1, mp2, obj| ::HeaderRbDown( mp1, mp2, obj ) }
  ::oXbp:wheel      := { |mp1, mp2, obj| ::processWheel( mp1, mp2, obj ) }

  drgLog:cargo := NIL
RETURN self

**************************************************************************
* Creates xbpBrowse column
**************************************************************************
METHOD drgBrowse:createColumn(hCaption, cName, cLen, cPic, cType)
LOCAL oColumn, cBlock, cc, n
* No use of setting HA height
LOCAL aPP := { { XBP_PP_COL_HA_CAPTION      , ""  } , ;
               { XBP_PP_COL_DA_ROWWIDTH     , 7   } , ;
               { XBP_PP_COL_DA_ROWHEIGHT    , drgINI:fontH - 8} }

//Local aCOL_h := { XBPSYSCLR_HILITEFOREGROUND , XBPSYSCLR_HILITEBACKGROUND }
//Local aCOL_d := { XBPSYSCLR_WINDOWSTATICTEXT , XBPSYSCLR_DIALOGBACKGROUND}
Local aCOL_h := { GRA_CLR_RED  ,}
*Local aCOL_h := { GRA_CLR_BLUE  , XBPSYSCLR_SHADOWHILITEBGND }
Local aCOL_d := { GRA_CLR_BLACK  , XBPSYSCLR_DIALOGBACKGROUND}


*Ikonca. Višina naj bo 18
/* Zelo slabo
  IF cType != NIL .AND. cType = 1
    aPP[3,2] := 16
  ENDIF
*/
  cLen := cLen*drgINI:fontW
  aPP[1,2] := hCaption
  aPP[2,2] := cLen

* Set codeblock
  IF !::isFile

* ARRAY
    IF ::cFile = NIL .OR. LEFT(::cFile, 3) = 'ARR'
      IF VALTYPE(cName) = 'N'
        cc := {|| ::arData[::nRECNO, cName] }   // array cb
      ELSE
        cName := STRTRAN(cName,';',',')         // function
        cc := &('{|a, b, c|' + cName + ' }')
      ENDIF

* OBJECT
    ELSEIF LEFT(::cFile, 3) = 'OBT'
      cc := {|| ::arData:getSetNth(::nRecNO, cName) }
    ENDIF

* DB FILE
  ELSEIF AT('(',cName) = 0
    cc := ::drgDialog:getVarBlock(cName)    // field cb
  ELSE
    cName := STRTRAN(cName,';',',')         // function
    cc := &('{|a, b, c|' + cName + ' }')
  ENDIF
* Set picture
  IF EMPTY(cPic)
    cBlock := cc
  ELSE
    cBlock := {|a| IIF(a = NIL, drg2String(cc, cPic),'') }
    IF VALTYPE( EVAL(cc) ) = 'N'
      AADD( aPP, { XBP_PP_COL_DA_CELLALIGNMENT, XBPALIGN_RIGHT } )
    ENDIF
  ENDIF
*
  oColumn           := XbpColumn():new(,,,, aPP)
  oColumn:dataLink  := cBlock
  oColumn:cargo     := cName
  oColumn:type      := cType
// ADT   oColumn:DataAreaLayout[XBPCOL_DA_CHARWIDTH] := cLen
/*
  if (::parent:drgDialog:formName <> 'drgSearch') .and. ( LEFT(::cFile, 3) <> 'ARR')
  // tohle je pìkná blbost, ale barvy mì nebaví //
    oColumn:colorBlock := {|X| If( AScan(::arSELECT,(::dbArea) ->(RECNO())) <> 0, aCOL_h, aCOL_d) }
  endif
*/
/*
  IF (::parent:drgDialog:formName <> 'drgSearch') .and. ( LEFT(::cFile, 3) <> 'ARR')
    oColumn:colorBlock := {|X| If( AScan(::arSELECT,(::dbArea) ->(RECNO())) <> 0, aCOL_h,;
                               IF( LEN( ::colored) = 0, aCOL_d,;
                                   If( MOD( (::dbArea) ->(OrdKeyNO()), 2) = 0, { GRA_CLR_BLACK, VAL(::colored[1]) },;
                                                                               { GRA_CLR_BLACK, VAL(::colored[2]) }) )) }
  ENDIF
*/


* šedá/ std
  IF (::parent:drgDialog:formName <> 'drgSearch') .and. ( LEFT(::cFile, 3) <> 'ARR')
    oColumn:colorBlock := {|X| If( AScan(::arSELECT,(::dbArea) ->(RECNO())) <> 0, aCOL_h,;
                                   If( MOD( (::dbArea) ->(OrdKeyNO()), 2) = 0,;
                                           {, VAL(::colored[1]) },;
                                           {, VAL(::colored[2]) }) ) }
  ENDIF



*  oColumn:create()
*  oColumn:rbDown := { |mp1, mp2, obj| ::oContetMenu:popup( obj, mp1 ) }
*  oColumn:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
RETURN oColumn

******************************************************************************
* Method to determine no of records to skip when array is beeing browsed.
* \bParameters:b\
* \b<nSkip>b\   : number : no of positions to skip
*
* \bReturn:b\   : actual no. of positions to skip
******************************************************************************
METHOD drgBrowse:arraySkip( nSkip )
LOCAL nCanSkip

  IF ::nRECNO + nSkip < 1                  // "BoF"
    nCanSkip := 1 - ::nRECNO
*    TONE ( 1000 )
  ELSEIF ::nRECNO + nSkip > LEN(::arData)  // "EoF"
    nCanSkip := LEN(::arData) - ::nRECNO
*    TONE ( 500 )
  ELSE
    nCanSkip := nSkip
  ENDIF
  ::nRECNO += nCanSkip
RETURN nCanSkip

******************************************************************************
* Method to determine no of records to skip when array is beeing browsed.
* \bParameters:b\
* \b<nSkip>b\   : number : no of positions to skip
*
* \bReturn:b\   : actual no. of positions to skip
******************************************************************************
METHOD drgBrowse:objectSkip( nSkip )
LOCAL nCanSkip

  IF ::nRECNO + nSkip < 1                  // "BoF"
    nCanSkip := 1 - ::nRECNO
*    TONE ( 1000 )
  ELSEIF ::nRECNO + nSkip > ::getObjSize()  // "EoF"
    nCanSkip := ::getObjSize() - ::nRECNO
*    TONE ( 500 )
  ELSE
    nCanSkip := nSkip
  ENDIF
  ::nRECNO += nCanSkip
*
  IF ::nRECNO = 0; ::nRECNO := 1; ENDIF
RETURN nCanSkip

******************************************************************************
* Returns object size if browsing object. The routine fools browser and
* returns 1 of object has no records.
*
* \bReturn:b\   : size (number of records) of object
******************************************************************************
METHOD drgBrowse:getObjSize()
LOCAL nSize
  IF ( nSize := ::arData:getSize() ) = 0
    nSize++
  ENDIF
RETURN nSize


******************************************************************************
* Method to determine no of records to skip when array is beeing browsed.
* \bParameters:b\
* \b<nSkip>b\   : number : no of positions to skip
*
* \bReturn:b\   : actual no. of positions to skip
******************************************************************************
METHOD drgBrowse:setScroll(lInitialy)
LOCAL lOldH, lOldV
  RETURN self
  DEFAULT lInitialy TO .F.
  lOldH := ::oXbp:hScroll
  lOldV := ::oXbp:vScroll
*
  IF lInitialy
    ::oXbp:hScroll := SUBSTR(::scroll, 1, 1) = 'y'
    ::oXbp:vScroll := SUBSTR(::scroll, 2, 1) = 'y'
  ENDIF

  IF SUBSTR(::scroll, 1, 1) = 'x'
  ENDIF
* Should scroll be shown
  IF SUBSTR(::scroll, 2, 1) = 'x'
    IF ::isFile
      ::oXbp:vScroll := ::oXbp:rowCount < (::dbArea)->( LASTREC() )
    ELSE
      ::oXbp:vScroll := ::oXbp:rowCount < LEN(::arData)
    ENDIF
  ENDIF
*
  IF lOldH != ::oXbp:hScroll .OR. lOldV != ::oXbp:vScroll
    ::oXbp:configure()
    ::oXbp:invalidateRect()
  ENDIF
RETURN self

***************************************************************************
* Refresh
***************************************************************************
METHOD drgBrowse:refresh(lAll)
  DEFAULT lAll TO .T.

* Refresh from VAR. It is possible
  IF valType(lAll) != 'L'
    RETURN self
  ENDIF

  IF lAll
    ::oXbp:refreshAll()
  ELSE
    ::oXbp:refreshCurrent()
  ENDIF
RETURN self

***************************************************************************
* Ensures that last row is displayed at the bottom of browser.
***************************************************************************
METHOD drgBrowse:lastRow2Bottom()
  IF (::dbArea)->( INDEXORD() ) = 0
/*
    (::dbArea)->( DBGOBOTTOM() )
    ::oXbp:refreshAll()
    FOR x := 1 TO ::oXbp:rowCount - 2
      ::oXbp:up()
    NEXT
*    ::oXbp:refreshAll()

    FOR x := 1 TO ::oXbp:rowCount - 2
      ::oXbp:down()
      ::oXbp:refreshCurrent()
    NEXT
*/
*    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oXbp)
    ::oXbp:goBottom()
  ENDIF
  ::oXbp:refreshAll()
RETURN self

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgBrowse:keyBoard(nKey, mp2, oXbp)
  Local  nPOs

  IF nKey == xbeK_TAB .OR. nKey == xbeK_SH_TAB
    IF ::parent:keyHandled(nKey) .AND. ::postValidate()
*      ::oXbp:deHilite()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
    ENDIF
  ELSEIf nKey == xbeK_SPACE
    ::fromContext()
    ::oXbp:refreshCurrent()

  ELSEIF nKey > 31 .AND. nKey < 256
    ::DlgSearch( nKey, oXbp )
    ::oXbp:refreshCurrent()
  ENDIF

RETURN .F.


***************************************************************************
* Práce se sloupcem browse
***************************************************************************
METHOD drgBrowse:HeaderRbDown(nKey, mp2, oXbp)
  LOCAL oX

  if ::selCol = 0
    ::selCol := mp2
  else
    if mp2 <> ::selCol
      oXbp:insColumn( mp2, oXbp:delColumn(::selCol))
      oXbp:refreshAll()
    endif
    ::selCol := 0
  endif

RETURN self



***************************************************************************
* Called by controller when drgObject can receive focus
***************************************************************************
METHOD drgBrowse:setFocus(mp1, mp2, oXbp)
  IF !::preValidate()
    PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp)
  ELSE
    SetAppFocus( ::oXbp )
    IF ::isFile
*      DBSelectArea(::dbArea)
    ENDIF
*    ::oXbp:hilite()
*    ::oXbp:invalidateRect()
    ::oXbp:refreshAll()
*    ::oXbp:refreshCurrent()
* Item marked event is not generated upon focus
    EVAL(::oXbp:itemMarked)
  ENDIF
RETURN self

***************************************************************************
* Dummy set input focus, but must be created because of editable browser.
***************************************************************************
METHOD drgBrowse:setInputFocus(mp1, mp2, oXbp)
*  IF ::parent:ok4Focus(self, oXbp)
*    ::setFocus(mp1, mp2, oXbp)
*  ENDIF
RETURN self

***************************************************************************
* Dummy set input focus, but must be created because of editable browser.
***************************************************************************
METHOD drgBrowse:killInputFocus(mp1, mp2, oXbp)
*  ::oXbp:deHilite()
*  ::oXbp:refreshAll()
RETURN self

***************************************************************************
* Wheel event callback.
***************************************************************************
METHOD drgBrowse:processWheel(mp1, mp2, oXbp)
* LOCAL  nRowsToScroll := Int( nRowCount * mp2[2] / 360)
*  drgDump(nRowsToScroll, 'wheel')
RETURN self

***************************************************************************
* On item marked event dialog must be informed so it will refresh fields on screen.
***************************************************************************
METHOD drgBrowse:itemMarked()
  IF !::isFile .OR. !(::dbArea)->( EOF() )
*-    PostAppEvent(drgEVENT_REFRESH,,, ::oXbp)
  ENDIF
RETURN self

***************************************************************************
* Item selected. Inform dialog to go to edit state.
***************************************************************************
METHOD drgBrowse:itemSelected()
  PostAppEvent(drgEVENT_EDIT,,, ::oXbp)
RETURN self

****************************************************************************
* Default postValidation method of drgObject.
****************************************************************************
METHOD drgBrowse:postValidate(endCheck)
LOCAL ret
  IF (ret := ::drgObject:postValidate(endCheck) )
*    ::oXbp:refreshAll()
*    ::oXbp:deHilite()
  ENDIF
*
  IF !ret
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF
RETURN ret

****************************************************************************
* Change indexorder of browsed file
****************************************************************************
METHOD drgBrowse:fromContext(aOrder, nMENU)
  Local  nPOs   := AScan(::arSELECT,(::dbArea)->(RECNO()))
  Local  cFILTR := ''
  Local  aMembers := ::drgDialog:dialogCTRL:members[1]:aMembers ,N, cTAG
  Local  value

  DEFAULT aOrder TO IF( nPOS == 0, 1, 2)
  DEFAULT nMENU  TO 0

  IF nMENU = 0 .and. SUBSTR(::popupmenu, 1, 1) = 'y'          // ... basic menu
    Do CAse
    Case( aOrder == 1 )                                                           // Oznaè záznam
      If(nPOs == 0, AAdd(::arSELECT, (::dbArea)->(RECNO()) ), NIL )
    Case( aOrder == 2 )                                                           // Zruší oznaèení záznamu
      If(nPOs <> 0, (ADel(::arSELECT,nPOs), ASize(::arSELECT,LEN(::arSELECT)-1)), NIL )
    Case( aOrder == 3 )                                                           // Zruší oznaèení všech záznamù
      ::arSELECT := {}
    Case( aOrder == 4 )                                                           // Zobraz oznaèené záznamy
      AEval( ::arSELECT, {|X| cFILTR += 'RECNO() = ' +STR(X) +' .or. ' })
      cFILTR := LEFT(cFILTR, LEN(cFILTR) -6)
      cTAG := (::dbArea) ->( AdsSetOrder(0))
      (::dbArea)->(ads_setaof(cFILTR))
      (::dbArea) ->( AdsSetOrder( cTAG))
    Case( aOrder == 5 )
      (::dbArea) ->(ads_clearaof())                                                         // Zobraz vše
    EndCase

    * Pokud existuje Browse nad stejným souborem, aktualizuj jeho arSELECT
    IF aOrder >= 1 .and. aOrder <= 3
      FOR N := 1 TO LEN( aMembers)
        IF( aMembers[ n]:isDerivedFrom('drgBrowse') .AND. ;
            aMembers[N]:cFile == ::cFile)
           aMembers[n]:arSELECT := ::arSELECT
        ENDIF
      NEXT
    ENDIF

  ELSEIF nMENU = 1 .and. SUBSTR(::popupmenu, 2, 1) = 'y'    // ... SubMenu  SORTED
    ::oSortMenu:checkItem( (::dbArea) ->(INDEXORD()), .F. )
    (::dbArea)->( AdsSetOrder(aOrder) )

    value := Lower(Alias(::dbArea)) +'.'+ StrZero(aOrder,3)
    GetSaveDialogPos(::drgDialog:formName, value, .F., .T.)

    ::oSortMenu:checkItem( aOrder, .T. )
  ENDIF

  ::oXbp:refreshAll()

RETURN self


****************************************************************************
* Create browsers context menu
****************************************************************************
METHOD drgBrowse:createContextMenu(oDesc, aDBD)
LOCAL x, st
  IF !::isFile
    RETURN self
  ENDIF

  ::oContextMenu := XbpMenu():new( ::oXbp ):create()
  IF  SUBSTR(::popupmenu, 1, 1) = 'y'
    ::oContextMenu:addItem( { 'Oznaè záznam'                , _browseContext( self, 1 ) } )
    ::oContextMenu:addItem( { 'Zruší oznaèení záznamu'      , _browseContext( self, 2 ) } )
    ::oContextMenu:addItem( { 'Zruší oznaèení všech záznamù', _browseContext( self, 3 ) } )
    ::oContextMenu:addItem( {NIL, NIL , XBPMENUBAR_MIS_SEPARATOR, 0} )
    ::oContextMenu:addItem( { 'Zobraz oznaèené záznamy'     , _browseContext( self, 4 ) } )
    ::oContextMenu:addItem( { 'Zobraz vše'                  , _browseContext( self, 5 ) } )
    ::oContextMenu:addItem( {NIL, NIL , XBPMENUBAR_MIS_SEPARATOR, 0} )

    If LEN(::arSELECT) == 0
      ::oContextMenu:disableItem(2)
      ::oContextMenu:disableItem(3)
      ::oContextMenu:disableItem(5)
      ::oContextMenu:disableItem(6)
    Else
     If( (::dbArea) ->(DbFilter()) <> '', ::oContextMenu:disableItem(5), NIL )
     If( (::dbArea) ->(DbFilter()) == '', ::oContextMenu:disableItem(6), NIL )
    EndIf

  *  If( (::dbArea) ->(DbFilter()) == '', ::oContextMenu:disableItem(6), ;
  *    If( LEN(::arSELECT) <> 0, ::oContextMenu:disableItem(5), NIL )    )
  ENDIF
* SubMenu SORTED ...  Is there any index defined for this file
  IF SUBSTR(::popupmenu, 2, 1) = 'y'
    IF LEN(aDBD:indexDef) > 0
      ::oSortMenu := XbpMenu():new( ::oContextMenu):create()
      ::oSortMenu:title := drgNLS:msg('Sorted')
      FOR x := 1 TO LEN( aDBD:indexDef )
        st := STR(x,2) + ': ' + aDBD:indexDef[x]:cCaption
        ::oSortMenu:addItem( { st, _browseContext( self, x, 1 ),,XBPMENUBAR_MIA_CHECKED } )
        ::oSortMenu:checkItem( x, .F. )
      NEXT
      ::oSortMenu:checkItem( (::dbArea) ->(INDEXORD()), .T. )
    ENDIF

    ::oContextMenu:addItem( { ::oSortMenu, NIL } )
  ENDIF

RETURN self

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgBrowse:resize(aOld, aNew)
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
*   New browse size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
  ::oXbp:setSize( {newX,newY}, .F.)
  ::setScroll(.F.)
  ::oXbp:refreshAll()
RETURN self

**************************************************************************
* Clean UP
**************************************************************************
METHOD drgBrowse:destroy()


  IF ::oContextMenu  != NIL
    ::oContextMenu:destroy()
  ENDIF
  ::drgObject:destroy()
  ::oBord:destroy()

  ::oBord         := ;
  ::dbArea        := ;
  ::isFile        := ;
  ::oContextMenu  := ;
  ::nRECNO        := ;
  ::arData        := ;
  ::cFile         := ;
  ::arDef         := ;
  ::scroll        := ;
  ::oSortMenu     := ;
  ::popupMenu     := ;
  ::colored       := ;
                     NIL
RETURN

FUNCTION _browseContext(obj, ix, nMENU)
RETURN {|| obj:fromContext( ix, nMENU) }

************************************************************************
************************************************************************
*
* Browse type definition class
*
************************************************************************
************************************************************************
CLASS _drgBrowse FROM _drgObject
  EXPORTED:

  VAR     fields
  VAR     browseInit
  VAR     itemSelected
  VAR     itemMarked
  VAR     cursorMode
  VAR     indexord
  VAR     scroll
  VAR     lFreeze
  VAR     rFreeze
  VAR     PopupMenu
  VAR     Colored

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgBrowse:init(line)
  ::type := 'browse'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fPos  TO {0, 0}
  DEFAULT ::cursorMode TO XBPBRW_CURSOR_CELL
  DEFAULT ::indexord   TO 1
  DEFAULT ::scroll     TO 'yy'
  DEFAULT ::resize     TO 'yy'
  DEFAULT ::popupmenu  TO 'nn'
  DEFAULT ::colored    TO {}

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgBrowse:parse(line)
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
      ::indexord := _getNum(value)
    CASE keyWord == 'SCROLL'
      ::scroll  := LOWER( _getStr(value) )
    CASE keyWord == 'LFREEZE'
      ::lFreeze  := LOWER( _getStr(value) )
    CASE keyWord == 'RFREEZE'
      ::rFreeze  := LOWER( _getStr(value) )
    CASE keyWord == 'POPUPMENU'
      ::popupmenu := LOWER( _getStr(value) )
    CASE keyWord == 'COLORED'
      ::colored := LOWER( _getStr(value) )

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgBrowse:destroy()
  ::_drgObject:destroy()

  ::fields       := ;
  ::browseInit   := ;
  ::itemSelected := ;
  ::itemMarked   := ;
  ::cursorMode   := ;
  ::indexord     := ;
  ::scroll       := ;
  ::lFreeze      := ;
  ::rFreeze      := ;
  ::popupmenu    := ;
  ::colored      := ;
                    NIL
RETURN

STATIC FUNCTION GetFreeze(cDesc)
LOCAL ar := {}
LOCAL c
  WHILE !EMPTY( c := drgParse(@cDesc) )
    AADD(ar, VAL(c) )
  ENDDO
RETURN ar

*
********************************************************************************
METHOD drgBrowse:dlgSearch( nKey, oBrowse)
   Local nEvent, mp1 := Nil, mp2 := Nil
   Local oDlg, oXbp, drawingArea, oGroup, aPos:={}, oSeek := Nil
   Local aSize, aPSize
   Local cFile := self:cFile, cSeaCaption := '', cIndexKey := ''
   Local aDBD := drgDBMS:getDBD( cFile)
   *
   local indexDef, ctag, npos

   aSize  := {419,143}    // {419,143}
   aPSize := AppDesktop():currentSize()
   aPos   := { (aPSize[1] - aSize[1]) / 2, ;
               (aPSize[2] - aSize[2]) / 2  }

   oDlg:=XbpDialog():new(AppDesktop(), SetAppWindow(), aPos, aSize, , .F.)
   oDlg:icon:= DRG_ICON_FIND
   oDlg:taskList:=.T.
   oDlg:border:=XBPDLG_RAISEDBORDERTHIN_FIXED
   oDlg:close:={|mp1,mp2,obj| PostAppEvent(xbeP_Close) }
   oDlg:title:="Hledej..."
   oDlg:create()
   oDlg:setModalState(XBP_DISP_APPMODAL)
   drawingArea:=oDlg:drawingArea
   drawingArea:setFontCompoundName("8.Arial CE")
   //
   oGroup := XbpStatic():new(drawingArea, , {12,10}, {384,95})
   oGroup:clipSiblings:=.T.
   oGroup:type:=XBPSTATIC_TYPE_GROUPBOX
   oGroup:create()

   IF LEN(indexDef := aDBD:indexDef) > 0
     ctag := upper( (cfile) ->( ordSetFocus()) )
     npos := ascan( indexDef, { |x| upper(x:cname) = ctag } )

     if( npos = 0, npos := 1, nil )

     cSeaCaption := aDBD:indexDef[ npos ]:cCaption
     cIndexKey   := aDBD:indexDef[ npos ]:cIndexKey
   ENDIF
   oXbp:=XbpStatic():new(oGroup, , {12,60}, {350,24})
   oXbp:caption:= cSeaCaption
   oXbp:clipSiblings:=.T.
   oXbp:options:=XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_LEFT
   oXbp:create()

   oSeek:=XbpSLE():new(oGroup, , {12,35}, {350,24}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } })
   oSeek:tabStop:=.T.
   oSeek:create()
   oSeek:setData( CHR( nKey))
   oSeek:setMarked( {2,2} )
   oSeek:keyBoard:={| nKey, uNIL, self | IncSearch( nKey, oSeek, oBrowse, cIndexKey ) }
   oDlg:show()

   SetAppFocus(oSeek)
   IncSearch( nKey, oSeek, oBrowse, cIndexKey )

   nEvent:=xbe_None
   Do While nEvent<>xbeP_Close  // +1000
      nEvent:=AppEvent(@mp1, @mp2, @oXbp)

      IF nEvent == xbeUser_Eval
         Eval( mp1, oXbp )
         oBrowse:cargo:drgDialog:dataManager:refresh()
         PostAppEvent( xbeBRW_ItemMarked,,, oBrowse )

      ELSEIF nEvent == xbeBRW_ItemMarked
         PostAppEvent( xbeBRW_ItemMarked,,, oBrowse )
      ELSE
         oXbp:handleEvent( nEvent, mp1, mp2 )
      ENDIF

   EndDo

   oDlg:destroy()
   SetAppFocus(oBrowse)

RETURN

*
*===============================================================================
PROCEDURE IncSearch( nKey, oSle, oBrowse, cIndexKey )
   LOCAL xSeaValue  := oBrowse:cargo:cIncSearch + Upper( AllTrim( oSle:editBuffer() ) )
   LOCAL nRecno, bGoTo
   Local cFile := oBrowse:cargo:cFile, cTypSearch, cHlp := ALIAS()

   IF nKey == xbeK_ESC .or. nKey == xbeK_ENTER
      PostAppEvent( xbeP_Close, nKey, NIL, oBrowse )
      RETURN
   ENDIF

   cTypSearch := VALTYPE( (cFile)->( &( cIndexKey)))
   IF cTypSearch == 'N'
      xSeaValue := VAL( xSeaValue)
   ENDIF

   (cFile)->( dbSeek( xSeaValue, .T.))

   IF ( cFile)->( Found()) .OR. cTypSearch == 'N'
      nRecno := ( cFile)->( Recno())
      bGoTo  := {|o| ( cFile)->( DbGoto(nRecno)), o:refreshAll() }
      PostAppEvent( xbeUser_Eval, bGoTo, NIL, oBrowse )
   ELSE
      Tone(1000)
   ENDIF
RETURN