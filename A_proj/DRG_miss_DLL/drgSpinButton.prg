//////////////////////////////////////////////////////////////////////
//
//  drgSpinButton.PRG
//
//  Copyright:
//       Damjan Rems, (c) 2001. All rights reserved.
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
*#include "Gra.ch"
#include "xbp.ch"
#include "drg.ch"

* Class declaration
***********************************************************************
CLASS drgSpinButton FROM drgObject
  EXPORTED:
    VAR     value
    VAR     outLen

    METHOD  create
    METHOD  destroy
    METHOD  postValidate
    METHOD  keyBoard
    METHOD  endSpin
    METHOD  refresh

ENDCLASS

**************************************************************************
METHOD drgSpinButton:create(aDesc)
LOCAL aPos := {1,1}, fLen, fPos, size
LOCAL oBord, value, aPP
LOCAL cFile, cName, oHlp
  oBord := ::parent:getActiveArea()

* Position of the field on the screen
  size := ACLONE(oBord:currentSize() )
  fPos := ACLONE(aDesc:fPos)
  aPos[1] := fPos[1]*drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset //- fPos[2]
* Length of the field
  fLen := (aDesc:fLen + 1)*drgINI:fontW
* Create field
  aPP := aDesc:pp + drgPP_PP_EDIT1 - 1
  ::oXbp := XbpSpinButton():new( oBord, , aPos, {fLen, drgINI:fontH}, drgPP:getPP(aPP))
* Get field real name and file
  IF AT('->', aDesc:name) = 0
    cFile := IIF(aDesc:file = NIL, ::drgDialog:dbName, aDesc:file)
    cName := aDesc:name
    cFile := IIF(EMPTY(cFile),'M',cFile)
  ELSE
    cFile := drgParse(aDesc:name,'-')
    cName := drgParseSecond(aDesc:name,'>')
  ENDIF
  ::name  := cFile + '->' + cName
  drgLog:cargo := 'SpinButton: ' + ::name
* Get memory variable
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self
* Set pre & post validation codeblocks
  ::setPreValidate(aDesc)
  ::setPostValidate(aDesc)
  ::tipText := drgNLS:msg(aDesc:tipText)
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp

* Make spin button work for char fields also
  IF ( ::value := ::oVar:get() ) = NIL
    ::value := aDesc:limits[1]
  ENDIF

  ::outLen := 0
  IF VALTYPE( ::value ) = 'C'
    IF ::oVar:ref != NIL
      ::outLen := ::oVar:ref:len
    ELSE
      ::outLen := LEN(ALLTRIM(STR(aDesc:limits[2])))
    ENDIF
    value := VAL(ALLTRIM(::value))
// A BUG
*    ::oXbp:padWithZeros	:= .T.
  ELSE
    value := ::value
  ENDIF

* Initial values
  ::oXbp:tabStop := .F.
  ::oXbp:create()
  ::oXbp:cargo := self
  ::oXbp:setData(value)
  ::oXbp:setNumLimits(aDesc:limits[1], aDesc:limits[2])
  ::oXbp:helpLink := oHlp

* Set keyboard and inputFocus callbacks
  ::oXbp:keyboard      := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
  ::oXbp:endSpin       := { |mp1, mp2, obj| ::endSpin( mp1, mp2, obj ) }
RETURN self

***************************************************************************
* Refresh value of object on a screen
***************************************************************************
METHOD drgSpinButton:refresh(newValue)
  IF ::outLen = 0
    IF !( ::oXbp:getData() == newValue )
      ::oXbp:setData(newValue)
    ENDIF
  ELSE
    ::oXbp:setData(VAL(newValue) )
  ENDIF
RETURN

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgSpinButton:keyBoard(nKey, mp2, oXbp)
* TAB and SH_TAB events are processed automaticly by comboBox.
*  IF ! (nKey = xbeK_TAB .OR. nKey == xbeK_SH_TAB .OR. ;
  IF ! ( nKey == xbeK_UP .OR. nKey == xbeK_DOWN )
    IF ::parent:keyHandled(nKey) .AND. ::postValidate()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
    ENDIF
  ENDIF
RETURN .T.

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgSpinButton:endSpin()
  IF !::preValidate()
    ::oXbp:setData(::oVar:get())
  ENDIF
RETURN self

***************************************************************************
* Default postValidation method of drgObject
***************************************************************************
METHOD drgSpinButton:postValidate(endCheck)
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
  IF ::outLen = 0
    ::oVar:getSet(::oXbp:getData())
  ELSE
    ::oVar:getSet( drgPADL( ::oXbp:getData(), ::outLen ) )
  ENDIF
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

****************************************************************************
* Destroys all internal data.
****************************************************************************
METHOD drgSpinButton:destroy()
  ::drgObject:destroy()
  ::outLen := ;
  ::value  := ;
              NIL
RETURN self

************************************************************************
************************************************************************
*
* SpinButton type definition class
*
************************************************************************
************************************************************************
CLASS _drgSpinButton FROM _drgObject
  EXPORTED:
  VAR     limits

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgSpinButton:init(line)
  ::type := 'spinbutton'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fLen   TO 1
  DEFAULT ::fPos   TO {1, 1}
  DEFAULT ::limits TO {0, 1}
  DEFAULT ::PP     TO 1
  DEFAULT ::rOnly TO .F.

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgSpinButton:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'LIMITS'
      ::limits := _getNumArr(value)

    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgSpinButton:destroy()
  ::_drgObject:destroy()
  ::limits := NIL
RETURN


