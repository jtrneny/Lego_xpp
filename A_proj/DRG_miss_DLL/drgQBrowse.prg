//////////////////////////////////////////////////////////////////////
//
//  drgQBrowse.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgQBrowse class manages a single xbpQBrowse object in a form.
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

***********************************************************************
* drgQBrowse Class declaration
***********************************************************************
CLASS drgQBrowse FROM drgObject
  EXPORTED:
    VAR     oBord

    METHOD  refreshDAC
    METHOD  keyboard
    METHOD  setFocus
    METHOD  postValidate
    METHOD  setInputFocus

  EXPORTED:
    VAR     arCol, arCap, arLen, arType, aFile

    METHOD  create
    METHOD  destroy
ENDCLASS

***********************************************************************
* drgQBrowse Class declaration
***********************************************************************
METHOD drgQBrowse:create(aDesc)
LOCAL aPos := {1,1}, size, bBlock, aSize, fPos, app := {}
LOCAL x, aHead, sArea, aLen, aFld
LOCAL oBord, initBlock, oHlp
LOCAL fields, colType, parsed, al, ac, ap, act, af
LOCAL aFile, aName, isFile
  oBord := ::parent:getActiveArea()

* Position of the field on the screen
  size  := ACLONE(oBord:currentSize())
  aSize := ACLONE(aDesc:size)
* Size of a browser border in pixels
  aSize[1] := aSize[1]*drgINI:fontW
  aSize[2] := aSize[2]*drgINI:fontH //+ 4

  fPos := ACLONE(aDesc:fpos)
  aPos[1] := fPos[1]*drgINI:fontW
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset // + 4

* IF browser is on TAB page
  IF ::parent:topOffset >= drgINI:fontH
    aPos[1]  += 1
    aSize[2] -= 1
  ENDIF

* Create nice little border around browser
  ::oBord      := XbpStatic():new( oBord, , aPos, aSize)
  ::oBord:type := XBPSTATIC_TYPE_RAISEDBOX
  ::oBord:create()

  aSize[1] -= 8
  aSize[2] -= 8
  aPos     := {4,4}
* PP parameters
  aPP := drgPP_PP_BROWSE1
  aPP += aDesc:pp - 1

*  AADD(aPP, {XBP_PP_COL_DA_CELLHEIGHT, 28} )
  ::oXbp := XbpQuickBrowse():new( ::oBord, , aPos, aSize,drgPP:getPP(aPP),.T.)
  ::oXbp:cursorMode := aDesc:cursorMode
  ::oXbp:style := XBP_STYLE_SYSTEMDEFAULT

  ::aFile := IIF(aDesc:file = NIL, ::drgDialog:formHeader:file, aDesc:file)
  ::aFile := UPPER(::aFile)
  isFile  := .NOT. ( LEFT(::aFile, 3) = 'ARR' .OR. LEFT(::aFile, 3) = 'OBJ' )
  IF isFile
    drgDBMS:open(::aFile)
  ENDIF

* A good old fools trap is still working. a:=b:={} points to same array
  ::arCol  := {}
  ::arCap  := {}
  ::arLen  := {}
  ::arType := {}

  fields  := aDesc:fields
  colType := aDesc:colType
  WHILE !EMPTY( af := drgParse(@fields,',') )
**************************
* Parse index
**************************
    parsed := UPPER( ALLTRIM( drgParse(@af,':') ) )
    IF !isFile
* For safety porpuses. Index 0 will result in error
      IF VAL(parsed) = 0
        LOOP
      ENDIF
      AADD(::arCol, VAL(parsed) )                  // Add to columns array
    ELSE
      IF AT('->',parsed) = 0
        parsed := ::aFile + '->' + parsed          // FILE->FieldName
      ENDIF
      aFile := drgParse(parsed,'-')                // Get FILE
      aName := drgParseSecond(parsed,'>')          // Get FieldName
      AADD(::arCol, parsed )                       // Add to columns array
    ENDIF
**************************
* Parse caption
**************************
    parsed := ALLTRIM( drgParse(@af,':') )
* Search for caption in description
    IF EMPTY(parsed) .AND. isFile
      parsed := drgDBMS:getDBD(aFile):getFieldDesc(aName):caption
    ENDIF
    AADD(::arCap, drgNLS:msg( parsed ))
**************************
* Parse length
**************************
    parsed := ALLTRIM( drgParse(@af,':') )
    IF EMPTY(parsed) .AND. isFile
      parsed := STR(drgDBMS:getDBD(aFile):getFieldDesc(aName):len)
    ENDIF
    al := IIF(EMPTY(parsed), 10*drgINI:fontW, VAL(parsed)*drgINI:fontW )
    AADD(::arLen, al)
  ENDDO

* Aditional columnType definitions
  IF colType != NIL
    WHILE !EMPTY( (af := drgParse(@colType,',') ) )
      ac := VAL( drgParse(@af,':') )
      IF ac > 0
        al := drgParse(@af,':')
* DEFAULT TYPE FOR DISPLAY TYPE IS XBPCOL_TYPE_TEXT
        IF (act := VAL(drgParse(@af,':') ) ) = 0
          act := XBPCOL_TYPE_TEXT
        ENDIF
* Picture
        IF EMPTY( (ap := drgParse(@af,':') ) )
          ap := NIL
        ENDIF
        AADD(::arType, {ac, al, act, ap })
      ENDIF
    ENDDO
  ENDIF
  IF !isFile
    ::oXbp:dataLink := DacPagedDataStore():new(&(::aFile), ::arCol)
  ELSE
    ::oXbp:dataLink := DacPagedDataStore():new(ALIAS(), ::arCol)
  ENDIF

* Create an configure browser
  ::oXbp:setFont(drgPP:getFont())
*  ::oXbp:create(,,,,drgPP:getPP(aPP))
  ::oXbp:create()

  ::oXbp:setHeader( ::arCap )
  AEVAL(::arLen, { |a,x| ::oXbp:setColWidth(::arLen[x], x) } )
  AEVAL(::arType,{ |t|   ::oXbp:setColType(t[1], t[2], t[3], t[4]) } )
  ::oXbp:setRowHeight(drgINI:fontH + 2)
  ::oXbp:cargo := self
*  ::oXbp:XbpMultiCellGroup:cargo := self

* Call backs
* Set pre & post validation codeblocks, althow they make little sence here
  ::postBlock := ::drgDialog:getMethod( aDesc:post )
  ::preBlock  := ::drgDialog:getMethod( aDesc:pre )
  ::tipText   := drgNLS:msg(aDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm')
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp
*
  ::oXbp:keyboard      := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
* Dont hilite on first show
  ::oXbp:deHilite()
  ::oXbp:show()
  IF (initBlock := ::drgDialog:getMethod(aDesc:browseInit,'browseInit') ) != NIL
    EVAL(initBlock, self)
  ENDIF

  IF (initBlock := ::drgDialog:getMethod(aDesc:itemSelected,'browseItemSelected') ) != NIL
    ::oXbp:itemSelected := initBlock
  ENDIF

  IF (initBlock := ::drgDialog:getMethod(aDesc:itemMarked,'browseItemMarked') ) != NIL
    ::oXbp:itemMarked := initBlock
  ENDIF

RETURN self

**************************************************************************
* Refreshes dacPagedDataStore
**************************************************************************
METHOD drgQBrowse:refreshDAC()
  /*
   * Create a new DacPagedDataStore and
   * adjust its cache size according to the visible rows in the browser
   */
  ::oXbp:dataLink := DacPagedDataStore():new(&(::aFile), ::arCol)
  ::oXbp:dataLink:SetAbsolutePagesize( ::oXbp:RowCount )
  ::oXbp:refreshAll()

*  ::oXbp:setPointer( NIL, XBPSTATIC_SYSICON_ARROW, XBPWINDOW_POINTERTYPE_SYSPOINTER )
RETURN

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgQBrowse:keyBoard(nKey, mp2, oXbp)

  IF ! ( nKey == xbeK_UP .OR. nKey == xbeK_DOWN )
    IF ::parent:keyHandled(nKey) .AND. ::postValidate()
      ::oXbp:deHilite()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
    ENDIF
  ENDIF

RETURN .T.

***************************************************************************
* Called by controller when drgObject can receive focus
***************************************************************************
METHOD drgQBrowse:setFocus(mp1, mp2, oXbp)
  IF !::preValidate()
    PostAppEvent(drgEVENT_OBJEXIT,,, ::oXbp)
  ELSE
    ::oXbp:hilite()
    SetAppFocus( ::oXbp )
  ENDIF
RETURN

***************************************************************************
* Dummy set input focus, but must be created because of editable browse.
***************************************************************************
METHOD drgQBrowse:setInputFocus(mp1, mp2, oXbp)
  IF ::parent:ok4Focus(self, oXbp)
    ::setFocus(mp1, mp2, oXbp)
  ENDIF
RETURN

****************************************************************************
* Default postValidation method of drgObject.
****************************************************************************
METHOD drgQBrowse:postValidate(endCheck)
LOCAL ret
  IF (ret := ::drgObject:postValidate(endCheck) )
    ::oXbp:deHilite()
  ENDIF
RETURN ret

**************************************************************************
* Clean UP
**************************************************************************
METHOD drgQBrowse:destroy()
  ::drgObject:destroy()
  ::oBord:destroy()

  ::oBord   := ;
  ::arCol   := ;
  ::arCap   := ;
  ::arLen   := ;
  ::aFile   := ;
  ::arType  := NIL
RETURN

************************************************************************
************************************************************************
*
* Browse type definition class
*
************************************************************************
************************************************************************
CLASS _drgQBrowse FROM _drgObject
  EXPORTED:

  VAR     btype
  VAR     colType
  VAR     fields
  VAR     browseInit
  VAR     itemSelected
  VAR     itemMarked
  VAR     cursorMode

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgQBrowse:init(line)
  ::type := 'qbrowse'
  ::parse(line)
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgQBrowse:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'BTYPE'
      ::btype  := _getNum(value)
    CASE keyWord == 'COLTYPE'
      ::colType:= _getStr(value)
    CASE keyWord == 'FIELDS'
      ::fields := _getStr(value)
    CASE keyWord == 'BROWSEINIT'
      ::browseInit := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'
      ::itemSelected := _getStr(value)
    CASE keyWord == 'ITEMMARKED'
      ::itemMarked := _getStr(value)
    CASE keyWord == 'CURSORMODE'
      ::cursorMode := _getNum(value)

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
  DEFAULT ::fPos  TO {0, 0}
  DEFAULT ::size  TO {10, 10}
  DEFAULT ::cursorMode TO XBPBRW_CURSOR_ROW
  DEFAULT ::pp    TO 1
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgQBrowse:destroy()
  ::_drgObject:destroy()

  ::btype        := ;
  ::colType      := ;
  ::fields       := ;
  ::browseInit   := ;
  ::itemSelected := ;
  ::itemMarked   := ;
  ::cursorMode   := ;
                    NIL
RETURN


