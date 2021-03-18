//////////////////////////////////////////////////////////////////////
//
//  drgComboBox.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgComboBox is a replacement for xbpCheckBox class.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Appevent.ch"
#include "GRA.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Set.ch"

********************************************************************************
* Ownerdraw Combobox Class                                                     *
********************************************************************************
// Defines for the spacing between the individual
// elements that make up a listbox entry
#define COLOR_BOX_SPACING    2
#define COLOR_BOX_STRSPACING 4   // 8


class XbpDrgComboBox from XbpComboBox
  exported:
  var colors
  var n_DISABLED_FGCLR, n_DISABLED_BGCLR

  inline method init( oParent, oOwner, aPos, aSize, aPP, lVisible )
    local npos

    ::XbpComboBox:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )
    ::DrawMode     := XBP_DRAW_OWNER
    ::Type         := XBPCOMBO_DROPDOWNLIST
    ::adjustHeight := .t.

    ::n_DISABLED_FGCLR := GraMakeRGBColor( {201, 201, 201} )
    ::n_DISABLED_BGCLR := GraMakeRGBColor( {  0,  64,  64} )

    if( npos := ascan( aPP, { |x| x[1] = XBP_PP_DISABLED_FGCLR })) <> 0
      ::n_DISABLED_FGCLR := aPP[npos,2]
    endif

    if( npos := ascan( aPP, { |x| x[1] = XBP_PP_DISABLED_BGCLR })) <> 0
      ::n_DISABLED_BGCLR := aPP[npos,2]
    endif
  return self

  inline method Create( oParent, oOwner, aPos, aSize, aPP, lVisible )
    ::XbpComboBox:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )
    ::setData(1)
  return self

  inline method MeasureItem( mp1, mp2 )
    LOCAL oPS
    LOCAL oFont, oFontPrev
    LOCAL aBox
*
    LOCAL nHeight := min( ::SleSize() [2], 21 )

    local aSize := ::currentSize()

*   ::sleSize( { aSize[1], 15 } )

    oPS    := AppDesktop():lockPS()
    oFont  := ::SetFont()
    IF oFont != NIL
      GraSetFont( oPS, oFont )
      ::sleSize( { aSize[1], max( oFont:Height +4, 21 )} )
    ENDIF

    aBox   := GraQueryTextBox( oPS, ::getItem(mp1) )
    AppDesktop():unlockPS()

    mp2[2]  := 16  // aBox[3][2] - aBox[2][2] + COLOR_BOX_SPACING *4
    mp2[1]  := mp2[2] *2
  return ::XbpComboBox:MeasureItem(mp1, mp2)


  inline method DrawItem( mp1, mp2 )
    LOCAL aPosStart
    LOCAL aPosEnd
    LOCAL aAreaAttrs   := Array( GRA_AA_COUNT )
    LOCAL aAreaAttrs2  := Array( GRA_AA_COUNT )
    LOCAL aStringAttrs := Array( GRA_AS_COUNT )
    LOCAL oFont
    LOCAL nItem
    LOCAL nHeight      := mp2[4][4] - mp2[4][2] - COLOR_BOX_SPACING *2
    *
    local color        := GraMakeRGBColor({200 -(mp2[1]*10), 200 -(mp2[1] *10), 255} )

    // Select background color depending on
    // the item's selection state and render
    // the background. Selected items are
    // rendered using a special background
    // color.
    IF BAND(mp2[3],XBP_DRAWSTATE_SELECTED) != 0
      aAreaAttrs2[GRA_AA_COLOR] := XBPSYSCLR_HILITEBACKGROUND

    ELSEIF BAND( mp2[3], XBP_DRAWSTATE_DISABLED ) != 0
      if( ::n_DISABLED_BGCLR <> 0, aAreaAttrs2[ GRA_AA_COLOR ] := ::n_DISABLED_BGCLR, nil )

    ELSE
      aAreaAttrs2[GRA_AA_COLOR] := XBPSYSCLR_WINDOW
    ENDIF

    GraSetAttrArea( mp1, aAreaAttrs2 )
    GraBox( mp1, {mp2[4][1],mp2[4][2]}, {mp2[4][3],mp2[4][4]}, GRA_FILL )

    // Draw a focus rectangle if the listbox
    // currently has the input focus.
    IF BAND(mp2[3],XBP_DRAWSTATE_FOCUS) != 0
      mp1:drawFocusRect( {mp2[4][1],mp2[4][2]},{mp2[4][3],mp2[4][4]}   )
    ENDIF

    // Draw a colored rectangle and output the
    // name of the color next to it.
    IF mp2[1] == 0
      RETURN self
    ENDIF

    aPosStart := {mp2[4][1]    + COLOR_BOX_SPACING, ;
                  mp2[4][2]    + COLOR_BOX_SPACING}
    aPosEnd   := {aPosStart[1] + 2      , ;
                  aPosStart[2] + nHeight  }

    aAreaAttrs[GRA_AA_COLOR] := color
    GraSetAttrArea( mp1, aAreaAttrs )
    GraBox( mp1, aPosStart, aPosEnd, GRA_OUTLINEFILL )

    aPosStart[1] := aPosEnd[1] + COLOR_BOX_STRSPACING
    aPosStart[2] += (aPosEnd[2] - aPosStart[2]) /2

    IF BAND(mp2[3],XBP_DRAWSTATE_DISABLED) != 0
*      aStringAttrs[GRA_AS_COLOR] := XBPSYSCLR_INACTIVETITLETEXT

      aStringAttrs[ GRA_AS_COLOR ]    := GRA_CLR_RED
*      aStringAttrs[ GRA_AS_BACKCOLOR] := GRA_CLR_BLUE
    ELSEIF BAND(mp2[3],XBP_DRAWSTATE_SELECTED) != 0
      aStringAttrs[GRA_AS_COLOR] := XBPSYSCLR_WINDOW
    ENDIF
    aStringAttrs[GRA_AS_VERTALIGN] := GRA_VALIGN_HALF
    GraSetAttrString( mp1, aStringAttrs )

    oFont := ::SetFont()
    IF oFont != NIL
      GraSetFont( mp1, oFont )
    ENDIF

    aPosStart[ 1 ] := aPosEnd[ 1 ] + COLOR_BOX_STRSPACING
    aPosStart[ 2 ] += ( aPosEnd[ 2 ] - aPosStart[ 2 ] ) / 2
    aPosStart[ 2 ] -= 2

    GraStringAt( mp1, aPosStart, ::getItem( mp2[ XBP_DRAWINFO_ITEM ] ) )
  return ::XbpComboBox:DrawItem(mp1, mp2)




/*
  inline method MeasureItem( nItem, aDim )
    local oPs, oFont, aBox
*    local a_sleSize := ::sleSize()
    local nHeight := ::SleSize() [2] - 4

    aDim[ 1 ] := nHeight * 2 + COLOR_BOX_STRSPACING

*    ::sleSize( { a_sleSize[1], ::sleSize()[2] - 4 } )

    oPS   := AppDesktop():LockPS()
    oFont := ::SetFont()
    IF oFont != NIL
      GraSetFont( oPS, oFont )
    ENDIF

    aBox := GraQueryTextBox( oPS, ::getItem( nItem ) )
    AppDesktop():UnlockPS()

    aDim[ 1 ] += aBox[ 3 ] [ 1 ] - aBox[ 2 ] [ 1 ]
    aDim[ 2 ] := nHeight -2  // ::sleSize()[2]- 4
    return ::XbpComboBox:MeasureItem( nItem, aDim )


  inline method DrawItem( oPs, aInfo )
    local aposStart, aposEnd
    local aareaAttrs   := Array( GRA_AA_COUNT )
    local aareaAttrs2  := ARRAY( GRA_AA_COUNT )
    local astringAttrs := ARRAY( GRA_AS_COUNT )

    local aStart, aEnd
    local nHeight      := aInfo[ XBP_DRAWINFO_RECT ][4] - aInfo[ XBP_DRAWINFO_RECT ][2] - COLOR_BOX_SPACING *2

*    nHeight := aInfo[ XBP_DRAWINFO_RECT ] [ 4 ] -aInfo[ XBP_DRAWINFO_RECT ] [ 2 ]
*    nHeight -= 6

    // Select background color depending on the item's selection state and render
    // the background. Selected items are rendered using a special background color.
    if     BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_FOCUS )    != 0
       aAreaAttrs2[ GRA_AA_COLOR ] := drgPP:getPP(drgPP_PP_EDIT3)[2,2]  // GRA_CLR_WHITE

    ELSEIF BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_SELECTED ) != 0
      aAreaAttrs2[ GRA_AA_COLOR ] := XBPSYSCLR_HILITEBACKGROUND

* podklad pøi výbìru položky i pokud není rozbaleno combo a stojím na nìm
* aAreaAttrs2[ GRA_AA_COLOR ] := GRA_CLR_WHITE

    ELSEIF BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_DISABLED ) != 0
      if( ::n_DISABLED_BGCLR <> 0, aAreaAttrs2[ GRA_AA_COLOR ] := ::n_DISABLED_BGCLR, nil )

    ELSE

      aAreaAttrs2[ GRA_AA_COLOR ] := ::setColorBG()
    ENDIF


    GraSetAttrArea( oPS, aAreaAttrs2 )
    GraBox( oPS, { aInfo[ XBP_DRAWINFO_RECT ] [ 1 ], aInfo[ XBP_DRAWINFO_RECT ] [ 2 ] }, ;
                 { aInfo[ XBP_DRAWINFO_RECT ] [ 3 ], aInfo[ XBP_DRAWINFO_RECT ] [ 4 ] }, GRA_FILL )

    // Draw a focus rectangle if the listbox currently has the input focus.
//    IF BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_FOCUS) != 0
//      oPs:drawFocusRect( { aInfo[ XBP_DRAWINFO_RECT ] [ 1 ], aInfo[ XBP_DRAWINFO_RECT ] [ 2 ] }, ;
//                         { aInfo[ XBP_DRAWINFO_RECT ] [ 3 ], aInfo[ XBP_DRAWINFO_RECT ] [ 4 ] }  )
//    ENDIF

    // Draw a colored rectangle and output the name of the color next to it.
    IF aInfo[ XBP_DRAWINFO_ITEM ] == 0
      RETURN self
    ENDIF

** news **
    aPosStart := {aInfo[ XBP_DRAWINFO_RECT ] [ 1 ] + COLOR_BOX_SPACING, ;
                  aInfo[ XBP_DRAWINFO_RECT ] [ 2 ] + COLOR_BOX_SPACING  }
    aPosEnd   := {aPosStart[1] + nHeight *2,  aPosStart[2] + nHeight }

    * vypoèteme pozici
    aStart := { aInfo[ XBP_DRAWINFO_RECT ] [ 1 ], aInfo[ XBP_DRAWINFO_RECT ] [ 2 ] }
    aEnd   := { aStart[ 1 ] + nHeight * 2       , aStart[ 2 ] + nHeight }


    * pøepoèet pozice
    aStart[ 1 ] += 2
    aStart[ 2 ] += 2

    * nastaví String Attribut
*    aStringAttrs[ GRA_AS_HORIZALIGN ] := GRA_HALIGN_CENTER // GRA_HALIGN_LEFT
*    aStringAttrs[ GRA_AS_VERTALIGN  ] := GRA_VALIGN_STANDARD
*    GraSetattrstring( oPS, aStringAttrs )

    IF BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_DISABLED ) != 0
      aStringAttrs[ GRA_AS_COLOR ]    := GRA_CLR_RED // PALEGRAY
      aStringAttrs[ GRA_AS_BACKCOLOR] := GRA_CLR_BLUE

    ELSEIF BAND( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_SELECTED ) != 0
      aStringAttrs[ GRA_AS_COLOR ]    := GRA_CLR_BLACK // GRA_CLR_WHITE // GRA_CLR_BLUE

**** nic      aStringAttrs[ GRA_AS_BACKCOLOR] := GRA_CLR_WHITE // GRA_CLR_BLUE  // WHITE
    ENDIF
*    aStringAttrs[ GRA_AS_VERTALIGN  ] := GRA_VALIGN_HALF
*    aStringAttrs[ GRA_AS_HORIZALIGN ] := GRA_VALIGN_STANDARD // GRA_HALIGN_CENTER
    GraSetattrstring( oPS, aStringAttrs )

    * nastaví font
    oFont := ::SetFont()
    oFont:Height := 20
    if( oFont != NIL, GraSetFont( oPS, oFont ), nil )
    GraStringAt( oPS, aStart, ::getItem( aInfo[ XBP_DRAWINFO_ITEM ] )  )

    IF Band( aInfo[ XBP_DRAWINFO_STATE ], XBP_DRAWSTATE_FOCUS ) != 0
     GraFocusRect( oPS, { aInfo[ XBP_DRAWINFO_RECT ] [ 1 ], aInfo[ XBP_DRAWINFO_RECT ] [ 2 ] },;
                         { aInfo[ XBP_DRAWINFO_RECT ] [ 3 ], aInfo[ XBP_DRAWINFO_RECT ] [ 4 ] } )
    ENDIF
    return ::XbpComboBox:DrawItem( oPS, aInfo )
*/

endClass


***********************************************************************
* Class declaration
***********************************************************************
CLASS drgComboBox FROM drgObject
  EXPORTED:

    VAR     value                     // Internal value of this object
    VAR     values                    // alowed values
    VAR     cbItemSelected
    VAR     cbItemMarked
    *
    var     search

    METHOD  create
    METHOD  destroy
    METHOD  keyBoard
    METHOD  postValidate
    METHOD  getValue
    METHOD  setValue
    METHOD  refresh
    METHOD  itemMarked
    METHOD  itemSelected
ENDCLASS

************************************************************************
METHOD drgComboBox:create( oDesc )
LOCAL aPos:={1,1}, fPos, fLen, size, aHeight
LOCAL bBlock, cFile, cName
LOCAL oBord, aPP, oHlp, initBlock

  oBord    := ::parent:getActiveArea()
  ::search := ''

//  ::Group  := oDesc:group  // miss

* Position of the field on the screen
  size := ACLONE(oBord:currentSize() )
* Length of the field
  fLen := oDesc:fLen * drgINI:fontW
* Get memory variable
  cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name := cFile + '->' + cName
  drgLog:cargo := 'ComboBox: ' + ::name
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self

* Set values befor determining size of dropDown
  ::values := _getBoxValues(oDesc, self)
**  ::values := ASort( ::values,,, {|aX,aY| aX[2] < aY[2] } )  // miss tøídìní by mìlo být možnost ANO/NE
*  ::setValues(oDesc)

  aHeight := len(::values) +if(isNil(oDesc:values),4,1)
* Don't allow height greater then 10
  aHeight := IIF(aHeight > 6, 6, aHeight)

* Position of the field on the screen
  fPos    := ACLONE(oDesc:fPos)
  aPos[1] := fPos[1]*drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - ( fPos[2] + aHeight)*drgINI:fontH - ::parent:topOffset //- fPos[2]
  size    := { fLen, aHeight*drgINI:fontH }
* Create combo box
  aPP     := oDesc:pp + drgPP_PP_EDIT1 - 1

*  if .not. isWorkVersion
    ::oXbp  := XbpComboBox():new( oBord, , aPos, size, drgPP:getPP(aPP))
*  else
*    ::oXbp  := XbpDrgComboBox():new( oBord, , aPos, size, drgPP:getPP(aPP))
*  endif

* Set pre & post validation codeblocks
  ::setPreValidate(oDesc)
  ::setPostValidate(oDesc)
  ::tipText := drgNLS:msg(oDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp

* Set common values
  ::oXbp:border  := .F.
  ::oXbp:tabStop := .F.
  ::oXbp:type    := XBPCOMBO_DROPDOWNLIST
//  ::oXbp:setFont( drgPP:getFont(oDesc:font) )

  ::oXbp:setFont(drgPP:getFont())
*  ::oXbp:SetColorBG( nColor )

  ::oXbp:create()
  ::oXbp:cargo := self
* Set comboBox items
  AEVAL(::values, { |a| ::oXbp:addItem( a[2] ) } )

* Set initial data
  ::value := ::oVar:get()
  ::oXbp:xbpSLE:setData( ::getValue() )

* Standard calback blocks
  ::cbItemSelected     := ::drgDialog:getMethod(oDesc:itemSelected,'ComboItemSelected')
  ::oXbp:itemSelected  := { |mp1, mp2, o| ::itemSelected( mp1, mp2, o ) }
  ::cbItemMarked       := ::drgDialog:getMethod(oDesc:itemMarked,'ComboItemMarked')
  ::oXbp:itemMarked    := { |mp1, mp2, o| ::itemMarked( mp1, mp2, o ) }
  ::oXbp:keyboard      := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }


* Initialization callback
  IF (initBlock := ::drgDialog:getMethod(,'ComboBoxInit') ) != NIL
    EVAL(initBlock, self)
    ::oXbp:xbpSLE:setData( ::getValue() )

*   JS 23.4.2008
    ::ovar:initValue := ::ovar:prevValue := ::ovar:value := ::value
  ENDIF
  drgLog:cargo := NIL
RETURN self


*********************************************************************
* Gets value from array with allowed values.
*
* \bParameters:b\
* \b<aVal>b\    : String or numeric : Value returned by :datalink. The value must be passed \
* because method must know the type of field.
*
* \bReturns:b\  : String : Combined value from values array
*********************************************************************
METHOD drgComboBox:getValue()
LOCAL x
  IF (x := ASCAN(::values, {|a| a[1] == ::value } ) ) = 0
    x := 1
    ::value := ::values[1, 1]
  ENDIF
RETURN ::values[x, 2]

*  ELSE
// This should result in runtime error
*  ENDIF
*RETURN '**'

*********************************************************************
* Set internal value variable acording to xbpComboBox state. This function is \
* for itemMarked and itemSelected callbacks.
*********************************************************************
METHOD drgComboBox:setValue()
LOCAL aVal, x
  aVal := ::oXbp:xbpSLE:getData()           // get value from xbp
  IF (x := ASCAN(::values, {|a| a[2] == aVal} ) ) = 0
    x := 1
  ENDIF
  ::value := ::values[x, 1]
  ::oVar:getSet(::value)
RETURN

*********************************************************************
* Refresh field in a screen with new value.
*********************************************************************
METHOD drgComboBox:refresh(newValue)
  IF !( newValue == ::value )
    IF( IsNIL(::value), ::value := newValue, IF( IsNIL(newValue),NIL,::value := newValue))  //miss
//    ::value := newValue
    ::oXbp:xbpSLE:setData( ::getValue() )             // update xbp
  ENDIF
RETURN

***************************************************************************
* ComboBox itemSelected callBack
***************************************************************************
METHOD drgComboBox:itemSelected()
  ::setValue()
  * Evaluate user itemSelected callback
  IF ::cbItemSelected != NIL
    EVAL(::cbItemSelected, self)
  ENDIF
RETURN .T.

***************************************************************************
* ComboBox itemMarked callBack
***************************************************************************
METHOD drgComboBox:itemMarked()
  ::setValue()
  * Evaluate user itemMarked callback
  IF ::cbItemMarked != NIL
    EVAL(::cbItemMarked, self)
  ENDIF
RETURN self


***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgComboBox:keyBoard(nKey, mp2, oXbp)
  local pos, noKy := {xbeK_UP,xbeK_DOWN,xbeK_LEFT,xbeK_RIGHT}
  local nin, prevValue

  do case
  case(ascan(noKy,{|x| x = nkey}) <> 0 .and. .not. oxbp:listBoxFocus())

    * musíme vrátit pùvodní hodndotu
    prevValue := ::ovar:prevValue
    nin := ascan(::values,{|x| x[1] = prevValue })
    if(nin = 0,nin := 1,nil)

    ::value := if(valtype(::value) = 'N',  0 ,;
               if(valtype(::value) = 'L', .F.,  ''))
    ::refresh(::values[nin,1])
    PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)

  otherwise
    if .not. (nKey == xbeK_UP .OR. nKey == xbeK_DOWN)
      if ::parent:keyHandled(nKey) .AND. ::postValidate()
        PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
        if(nkey = xbeK_RETURN, ::itemSelected(), nil)
      endif
    endif
  endcase
RETURN .T.


***************************************************************************
* PostValidation method for drgObject
***************************************************************************
METHOD drgComboBox:postValidate(endCheck)
LOCAL ret := .T.
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
  ::oVar:getSet(::value)
* Call postvalidate
  IF ::postBlock != NIL
    ret := EVAL(::postBlock, ::oVar)
  ENDIF
* Check if on tab page
  IF !ret
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF

  ::postValidOK := ret

  *
  if(ret,(::ovar:prevValue := ::ovar:value, ::search := ''), nil)
RETURN ret

*********************************************************************
* Destroy drgComboBox object
*********************************************************************
METHOD drgComboBox:destroy()
  ::drgObject:destroy()

  ::value          := ;
  ::values         := ;
  ::cbItemSelected := ;
  ::cbItemMarked   := ;
                     NIL
RETURN self

************************************************************************
************************************************************************
*
* ComboBox type definition class
*
************************************************************************
************************************************************************
CLASS _drgComboBox FROM _drgObject
  EXPORTED:
  VAR     values
  VAR     comboInit
  VAR     itemSelected
  VAR     itemMarked

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgComboBox:init(line)
  ::type := 'combobox'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::PP    TO 1
  DEFAULT ::fLen  TO 10
  DEFAULT ::rOnly TO .F.
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgComboBox:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE ::parsed(keyWord, value)

    CASE keyWord == 'VALUES'
      ::values       := _getStr(value)
    CASE keyWord == 'COMBOINIT'
      ::comboInit    := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'
      ::itemSelected := _getStr(value)
    CASE keyWord == 'ITEMMARKED'
      ::itemMarked   := _getStr(value)

*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgComboBox:destroy()
  ::_drgObject:destroy()

  ::values      := ;
  ::comboInit    := ;
  ::itemSelected:= ;
  ::itemMarked  := ;
                   NIL
RETURN