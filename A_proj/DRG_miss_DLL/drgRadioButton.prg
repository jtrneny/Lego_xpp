//////////////////////////////////////////////////////////////////////
//
//  drgRadioButton.PRG
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
#include "Gra.ch"
#include "xbp.ch"
#include "drg.ch"


* Class declaration
***********************************************************************
CLASS drgRadioButton FROM drgObject
  EXPORTED:
    VAR     value
    VAR     values
    VAR     members, ao_bord
    VAR     tmpActive
    var     rbItemSelected

    METHOD  create
    METHOD  destroy
    METHOD  getValue
    METHOD  selected
    METHOD  setFocus
    METHOD  keyBoard
    METHOD  refresh
    METHOD  postValidate

    inline method setInputFocus(mp1,mp2,obj)
      local  obord := obj:parent, asize, pos_in_ao

      asize     := obord:currentSize()
      pos_in_ao := ascan(::members, obj)
      obord     := ::ao_bord[pos_in_ao]

*      obord:type := XBPSTATIC_TYPE_FGNDFRAME
*      obord:setSize({asize[1] -6, asize[2]})
*      obord:configure()

      obord:setcolorBG(GraMakeRGBColor( {255, 255, 200} ))
    return self


    inline method killInputFocus(mp1,mp2,obj)
      local  obord := obj:parent, asize, pos_in_ao

      asize     := obord:currentSize()
      pos_in_ao := ascan(::members, obj)
      obord     := ::ao_bord[pos_in_ao]

*      obord:type :=   XBPSTATIC_TYPE_TEXT
*      obord:setSize({asize[1] +6, asize[2]})
*      obord:configure()

      obord:setcolorBG(XBPSYSCLR_3DFACE)
    return self

ENDCLASS

**************************************************************************
METHOD drgRadioButton:create(oDesc)
LOCAL aPos:={1,1}, aSize, fPos, fLen, size, aHeight
LOCAL oBord, x, i, cFile, cName, oHlp, oXbp

  ::members := {}
  oBord := ::parent:getActiveArea()

* Position of the field on the screen
  size := ACLONE(oBord:currentSize() )

* Get memory variable
  cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name  := cFile + '->' + cName
  drgLog:cargo := 'RadioButton: ' + ::name
  ::oVar      := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self
* Set values
  ::values := _getBoxValues(oDesc, self)

  fPos    := ACLONE(oDesc:fPos)
  aPos[1] := fPos[1]*drgINI:fontW + 4
  aPos[2] := size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset
* Length of the field
  aSize   := ACLONE(oDesc:size)
  fLen := (aSize[1] + 1)*drgINI:fontW
  size := { fLen, drgINI:fontH }
* Set pre & post validation codeblocks
  ::setPreValidate(oDesc)
  ::setPostValidate(oDesc)
  ::tipText := drgNLS:msg(oDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp

* Set initial data. IF EMPTY set to first value of allowed values array
  ::value   := ::oVar:get()
* Set default value if current values is not between allowed
  IF ASCAN(::values, {|a| a[1] == ::value} ) = 0
    ::value := ::values[1,1]
  ENDIF


* Create radioButtons
  i := 0
  ::ao_bord := array(len(::values))

  FOR x := 1 TO LEN(::values)
    ::ao_bord[x] := XbpStatic():new( oBord,, aPos,  size )
    ::ao_bord[x]:create()

    oXbp := XbpRadioButton():new( ::ao_bord[x], ,{2,1},  {fLen -10, drgINI:fontH -2} )

* Set common values
    oXbp:caption := ::values[x, 2]
    oXbp:tabStop := .F.
    oXbp:setFont(drgPP:getFont())

    oXbp:create()
    oXbp:cargo   := self

** nesmí se nastavit ve Vistách to ztuhne u XP je to ok v obou variantách
*    oXbp:setData( ::getValue(x) )
**
    oXbp:helpLink := oHlp

* Standard calback blocks
    ::rbItemSelected    := ::drgDialog:getMethod(oDesc:itemSelected,'radioItemSelected')

* Assign callback methods
    oXbp:selected       := { |mp1, mp2, obj| ::selected( mp1, mp2, obj ) }
    oXbp:keyboard       := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }

    oXbp:setInputFocus  := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
    oxbp:killInputFocus := { |mp1, mp2, obj| ::killInputFocus(mp1,mp2,obj)}

    AADD(::members, oXbp )

    aPos[2] -= drgINI:fontH
* Max size is reached. Go back to first row
    IF ++i = aSize[2]
      aPos[1] += size[1]
      aPos[2] += i*drgINI:fontH
      i := 0
    ENDIF
  NEXT

// JS
  ::oxbp := ::members[1]

RETURN self

*********************************************************************
* Gets value from array with allowed values.
*
* \bParameters:b\
* \b< mVal >b\  : c or n : Value returned by :datalink. The value must be passed \
* because method must know the type of field.
*
* \bReturns:b\  : String : Combined value from values array
*********************************************************************
METHOD drgRadioButton:getValue(x)
RETURN ::values[x,1] == ::value

*********************************************************************
* Set internal value variable acording to xbpComboBox state. This function is \
* for itemMarked and itemSelected callbacks.
*********************************************************************
METHOD drgRadioButton:selected(mp1, mp2, oXbp)
  LOCAL x, members := ::members
* This gets called too many times. Only when selected is OK
  IF oXbp:getData()
    aeval(members, {|o| if( o = oxbp, nil, o:setData(.f.)) })

    x := ASCAN(::members, oXbp)
    ::value := ::values[x, 1]
    ::oXbp := oXbp

     * Evaluate user itemSelected callback
    if ::rbItemSelected != NIL
      EVAL(::rbItemSelected, self)
    endif
  ENDIF
RETURN

***************************************************************************
* Called by controller when drgObject can receive focus
***************************************************************************
METHOD drgRadioButton:setFocus(mp1, mp2, oXbp)
LOCAL x
  IF !::preValidate()
    PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp)
  ELSE
* Call from form controll
    IF oXbp = NIL
* Find out which button was last active
      IF (x := ASCAN(::values, ::value) ) = 0
        x := 1
      ENDIF
      ::oXbp := ::members[x]
    ELSE
* Call is inside RadioButton group
      ::oXbp := oXbp
    ENDIF
    SetAppFocus( ::oXbp )
  ENDIF
RETURN

*********************************************************************
* Refresh field in a screen with new value.
*********************************************************************
METHOD drgRadioButton:refresh(newValue)
LOCAL x, valOK := .F., tmpAct

  IF !( newValue == ::value ) 
    ::value := newValue
    FOR x := 1 TO LEN(::values)
      IF ::values[x, 1] == ::value
        ::members[x]:setData(.T.)
        valOK  := .T.
        tmpAct := x
      ELSE
        ::members[x]:setData(.F.)
      ENDIF
    NEXT
* Invalid value. Set first button to selected
    IF !valOK
      tmpAct := 1
      ::value := ::values[1 ,1]
      ::members[1]:setData(.T.)
    ENDIF
* IF in focus also set currently selected
    IF ::drgDialog:oForm:oLastDrg = self
      ::oXbp := ::members[tmpAct]
      SetAppFocus(::oXbp)
      _clearEventLoop()
    ENDIF
  ENDIF
RETURN

***************************************************************************
* Default postValidation method of drgObject
***************************************************************************
METHOD drgRadioButton:postValidate(endCheck)
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
  ::oXbp := NIL
* Call postvalidate
  IF ::postBlock != NIL
    ret := EVAL(::postBlock, ::oVar)
  ENDIF
* Check if on tab page
  IF !ret
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF
*
  ::postValidOK := ret
RETURN ret

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgRadioButton:keyBoard(nKey, mp2, oXbp)
LOCAL stepTo := 0, x
* TAB and SH_TAB events are processed automaticly by comboBox.
*  IF ! (nKey = xbeK_TAB .OR. nKey == xbeK_SH_TAB .OR. ;
  IF nKey == xbeK_UP
    stepTo := -1
  ELSEIF nKey == xbeK_DOWN
    stepTo := 1
  ELSEIF nKey = xbeK_SPACE
*    ::selected(::tmpActive)
  ELSEIF ::parent:keyHandled(nKey) .AND. ::postValidate()
    PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
  ENDIF

  IF stepTo != 0
    FOR x := 1 TO LEN(::members)
      IF ::members[x] = ::oXbp
        EXIT
      ENDIF
    NEXT
    x += stepTo
    IF x > LEN(::members)
      x := 1
    ELSEIF x = 0
      x := LEN(::members)
    ENDIF
    ::oXbp      := ::members[x]
    ::tmpActive := x
    setAppFocus(::oXbp)
  ENDIF
RETURN .T.

****************************************************************************
* Destroys all internal data.
****************************************************************************
METHOD drgRadioButton:destroy()
  AEVAL(::members, { |m| m:destroy() } )
* Set ::oXpb to NIL so it won't be destroyed twice
  ::oXbp := NIL
  ::drgObject:destroy()

  ::members   := ;
  ::values    := ;
  ::value     := ;
  ::tmpActive := ;
                 NIL
RETURN self

************************************************************************
************************************************************************
*
* RadioButton type definition class
*
************************************************************************
************************************************************************
CLASS _drgRadioButton FROM _drgComboBox
EXPORTED:
  INLINE METHOD init(line)
    ::_drgComboBox:init(line)
    ::type := 'radioButton'
    DEFAULT ::size TO {10,5}

  RETURN self
ENDCLASS