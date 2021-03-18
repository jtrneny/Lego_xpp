//////////////////////////////////////////////////////////////////////
//
//  drgCheckBox.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      my implementation of xbpCheckBox.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
*#include "Font.ch"
#include "Gra.ch"
#include "xbp.ch"
#include "drg.ch"

* Class declaration
***********************************************************************
CLASS drgCheckBox FROM drgObject
  EXPORTED:
    VAR     value                     // Internal .T./.F. value of this object
    var     obord
    VAR     cbItemSelected

    METHOD  create
    METHOD  destroy
    METHOD  getSet
    METHOD  keyBoard
    METHOD  postValidate
    METHOD  refresh

*-  HIDDEN:
    VAR     values                    // alowed values

    inline method setInputFocus(mp1,mp2,obj)
      local  asize := ::obord:currentSize()

*      ::obord:type := XBPSTATIC_TYPE_FGNDFRAME
*      ::obord:setSize({asize[1] -6, asize[2]})
*      ::obord:configure()

      if obj:cargo:className() = 'drgCheckBox'
        ::obord:setcolorBG(GraMakeRGBColor( {255, 255, 200} ))
      else

* XBPSTATIC_TYPE_TEXT
* XBPSTATIC_TYPE_FGNDRECT                 -  èerný
* XBPSTATIC_TYPE_BGNDRECT                 -  tmavo šedý podklad
* XBPSTATIC_TYPE_FGNDFRAME                -  èerný rámeèek          -  OK
* XBPSTATIC_TYPE_BGNDFRAME                -  tmavo šedý rámeèek     -  OK
* XBPSTATIC_TYPE_HALFTONERECT             -  bílý podklad
* XBPSTATIC_TYPE_HALFTONEFRAME            -  šedý vystouplý podklad
* XBPSTATIC_TYPE_RAISEDBOX                -  box nemá barvu
* XBPSTATIC_TYPE_RAISEDRECT               -  box nemá barvu
* XBPSTATIC_TYPE_RAISEDLINE               -  èárka z leva nahoru
* XBPSTATIC_TYPE_RECESSEDLINE             -  dtto

        if ::oxbp:parent:className() <> 'XbpCellGroup'
          ::obord:parent:type := XBPSTATIC_TYPE_TEXT
          ::obord:parent:setcolorBG(GraMakeRGBColor( {255, 255, 200} ))
          ::obord:parent:configure()
        endif

      endif
    return self


    inline method killInputFocus(mp1,mp2,obj)
      local  asize := ::obord:currentSize()

*      ::obord:type :=   XBPSTATIC_TYPE_TEXT
*      ::obord:setSize({asize[1] +6, asize[2]})
*      ::obord:configure()

      if obj:cargo:className() = 'drgCheckBox'
        ::obord:setcolorBG(XBPSYSCLR_3DFACE)
      else
        if ::oxbp:parent:className() <> 'XbpCellGroup'
          ::obord:parent:type := XBPSTATIC_TYPE_RECESSEDBOX
          ::obord:parent:configure()
        endif
      endif
    return self

ENDCLASS



**************************************************************************
METHOD drgCheckBox:create(oDesc)
LOCAL aPos := {1,1}, fLen, fPos, size, aPP, x
LOCAL cFile, cName
LOCAL nColor  := GraMakeRGBColor( {255 , 255 , 236} )
LOCAL oBord, oHlp
*
local nIn

  oBord := ::parent:getActiveArea()

* Position of the field on the screen
  size := ACLONE(oBord:currentSize() )
  fPos := ACLONE(oDesc:fPos)
  aPos[1] := fPos[1]*drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset + 1 //- fPos[2]
* Length of the field
  fLen := oDesc:fLen * drgINI:fontW

 * Position of the field on the screen
  cPos  := ACLONE(oDesc:fPos)
  aSize := {fLen, drgINI:fontH}
  aPos[1] := cPos[1]* drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - cPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset //- cPos[2]

  ::oBord := XbpStatic():new( oBord,, aPos,  aSize )
  ::oBord:create()
  ::oXbp := XbpCheckBox():new( ::oBord, ,{2,1},  {fLen -10, drgINI:fontH -2} )

  ::oxbp:setInputFocus  := {|mp1,mp2,obj| ::setInputFocus(mp1,mp2,obj)}
  ::oxbp:killInputFocus := {|mp1,mp2,obj| ::killInputFocus(mp1,mp2,obj)}

* Get memory variable
  cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name := cFile + '->' + cName
  drgLog:cargo := 'CheckBox: ' + ::name
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self

* Initial value
  ::values := _getBoxValues(oDesc, self)
  *
  aeval(::values, {|x| if( x[2] = '.', x[2] := '', nil )})

  ::value := ::oVar:get()
  ::oXbp:selected  := {|mp1, mp2, o| ::getSet(mp1) }
  ::oXbp:selection := ::getSet()

* Set pre & post validation codeblocks
  ::setPreValidate(oDesc)
  ::setPostValidate(oDesc)
  ::tipText := drgNLS:msg(oDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink   := oHlp

* Set caption of CheckBox
  IF oDesc:caption != NIL
    ::oXbp:caption := drgNLS:msg( oDesc:caption )
  ELSEIF LEN(::values) > 0

** JS 28.10.2011
** pøi startu zobrazoval text k TRUE, nebo k první volbì
    nIn := AScan(::values, {|a| a[1] == ::value} )
    nin := if( nin <> 0, nin, 1)

    ::oXbp:caption := drgNLS:msg(::values[nin,2])    // values for true only
  ENDIF
  ::oXbp:tabStop := .F.
  ::oXbp:setFont(drgPP:getFont())

  ::oXbp:create()
*  ::oXbp:SetColorBG( nColor )

  ::oXbp:cargo := self
* Set keyboard and inputFocus callbacks
  ::oXbp:keyboard      := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }

* Set readOnly flag
  drgLog:cargo := NIL

* Standard calback blocks
  ::cbItemSelected  := ::drgDialog:getMethod(oDesc:itemSelected,'CheckItemSelected')
RETURN self

****************************************************************************
* Returns codeBlock for checkBox field
****************************************************************************
METHOD drgCheckBox:getSet(a)
LOCAL  nIn
LOCAL  aType

  aType := VALTYPE(::value)
* GET VALUE
  IF a = NIL
* Set default value if current values is not between allowed
    IF ( nIn := AScan(::values, {|a| a[1] == ::value} )) = 0
      ::value := ::values[2,1]
    ENDIF
    IF( aType = 'L' .and. nIn <> 0 .and. ::oxbp:parent:className() <> 'XbpCellGroup', ;
        ::oXbp:setCaption(::values[nIn,2]), NIL )   // miss

    nin := if( nin <> 0, nin, 1)

    RETURN IIF(aType = 'L', ::value, ::value == ::values[nin,1] )
* SET VALUE
  ELSE
    IF aType = 'L'
      ::value := a                                              // Boolean
      IF (nIn := AScan(::values, {|X| X[1] == ::value })) <> 0  // miss
        if ::oxbp:parent:className() <> 'XbpCellGroup'
          ::oXbp:setCaption(::values[nIn,2])
        endif
// JS 7.7.2011
        ::oVar:Value := ::value
      ENDIF
    ELSE
*      drgDump(::values,'values')
      ::value := IIF(a, ::values[1,1], ::values[2,1])           // Character string
    ENDIF
  ENDIF

  IF ::cbItemSelected != NIL
    EVAL(::cbItemSelected, self)
  ENDIF
RETURN .F.

***************************************************************************
* Refresh value of object on a screen
***************************************************************************
METHOD drgCheckBox:refresh(newValue)
  IF !( ::value == newValue )
    ::value := newValue
    ::oXbp:setData( ::getSet() )
  ENDIF
RETURN

***************************************************************************
* Default drgObject keyboard callback behaviour
***************************************************************************
METHOD drgCheckBox:keyBoard(nKey, mp2, oXbp)
* TAB and SH_TAB events are processed automaticly by checkBox.
*  IF ! (nKey = xbeK_TAB .OR. nKey == xbeK_SH_TAB)
    IF ::parent:keyHandled(nKey) .AND. ::postValidate()
**      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
      PostAppEvent(drgEVENT_OBJEXIT,,, oXbp)
    ENDIF
RETURN .T.

***************************************************************************
* Default postValidation method of drgObject
***************************************************************************
METHOD drgCheckBox:postValidate(endCheck)
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
  ::oVar:getSet(::value )
* Call postvalidate
  IF ::postBlock != NIL
    ret := EVAL(::postBlock, ::oVar)
  ENDIF
* Check if on tab page
  IF !ret
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF
  ::postValidOK := ret
RETURN ret

****************************************************************************
* Destroys all internal data.
****************************************************************************
METHOD drgCheckBox:destroy()
  ::drgObject:destroy()

  ::value     := ;
  ::values    := ;
              NIL
RETURN self

************************************************************************
************************************************************************
*
* CheckBox type definition class
*
************************************************************************
************************************************************************
CLASS _drgCheckBox FROM _drgObject
  EXPORTED:
  VAR     caption
  VAR     values
  VAR     itemSelected

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgCheckBox:init(line)
  ::type := 'checkbox'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fLen    TO 1
  DEFAULT ::fPos    TO {1, 1}
*  DEFAULT ::caption TO ' '
  DEFAULT ::PP      TO 1
  DEFAULT ::rOnly   TO .F.
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgCheckBox:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'CAPTION'
      ::caption := _getStr(value)
    CASE keyWord == 'VALUES'
      ::values := _getStr(value)
    CASE keyWord == 'ITEMSELECTED'
      ::itemSelected := _getStr(value)

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgCheckBox:destroy()
  ::_drgObject:destroy()
  ::values  := ;
  ::caption := NIL
RETURN