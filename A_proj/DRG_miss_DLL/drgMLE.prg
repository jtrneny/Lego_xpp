//////////////////////////////////////////////////////////////////////
//
//  drgMLE.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgMLE class handles xbpMLE field definition.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "appEvent.ch"

CLASS drgMLE FROM drgObject
  EXPORTED:
  VAR     pushGet, isRelTo
  VAR     picture
  VAR     oBord
  VAR     scroll
  VAR     clrFocus

  METHOD  create
  METHOD  keyBoard
  METHOD  refresh
  METHOD  postValidate
  METHOD  preValidate
  METHOD  destroy
  METHOD  resize

  hidden:
  var     pocZnaku
ENDCLASS

****************************************************************************
* Creates drgGet object for data input in a form.
*
* /bParameters:b/
* /b<oDesc>b/   : object : drgFormField object containing field description
* /b<aForm>b/   : object : drgForm where xbpGet is to be created
*
* /bReturn:b/   : object : newly created xbpGetField
****************************************************************************
METHOD drgMLE:create(oDesc)
LOCAL aPos:={1,1}, aPP , fPos, size, aSize
LOCAL cName, cFile, bBlock
LOCAL oBord, oHlp
  oBord := ::parent:getActiveArea()
* Position of the MLE on the screen
  size  := ACLONE(oBord:currentSize())
  aSize := ACLONE(oDesc:size)

* Size of MLE in pixels
  aSize[1] := aSize[1]*drgINI:fontW
  aSize[2] := aSize[2]*drgINI:fontH

* Position of the field on the screen
  fPos := ACLONE(oDesc:fpos)
  aPos[1] := fPos[1]*drgINI:fontW + ::parent:leftOffset
  aPos[2] := size[2] - fPos[2]*drgINI:fontH - aSize[2] - ::parent:topOffset

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
  aPos     := {3,3}

  ::pocZnaku := asize[1] / drgINI:fontW

* Get memory variable
  cFile := _getcFilecName(@cName, oDesc, ::drgDialog:dbName)
  ::name := cFile + '->' + cName
  drgLog:cargo := 'MLE: ' + ::name
  ::oVar := ::drgDialog:dataManager:add(cFile, cName)
  ::oVar:oDrg := self

  aPP := oDesc:pp + drgPP_PP_EDIT1 - 1
  ::clrFocus := drgPP:getPP(aPP)[2,2]
  ::IsrelTO  := .F.

* Create xbpGet field
  ::oXbp := XbpMLE():new( ::oBord, , aPos, aSize, drgPP:getPP(aPP))
  ::oXbp:dataLink := {|a| IIF(EMPTY(a), RTRIM(::oVar:get()), ::oVar:set(a) ) }
* Set pre & post validation codeblocks
  ::setPreValidate(oDesc)
  ::setPostValidate(oDesc)
  ::tipText := drgNLS:msg(oDesc:tipText)
* Set readOnly flag
  ::oXbp:editable := !::disabled
  ::disabled := .F.                   // readonly sets disabled flag
  ::scroll := oDesc:scroll
  ::oXbp:horizScroll := SUBSTR(::scroll, 1, 1) = 'y'
  ::oXbp:vertScroll  := SUBSTR(::scroll, 2, 1) = 'y'
* HelpLink for window
  oHlp := XbpHelpLabel():new():create( ::drgDialog:helpName + '.htm#' + cName )
  oHlp:helpObject := drgHelp
  ::oXbp:helpLink := oHlp
* Create object
  ::oXbp:tabStop   := .F.
  ::oXbp:ignoreTab := .T.
  ::oXbp:setFont( drgPP:getFont() )
*
* není to nikde v popisu ale FORMAT := 3 umožní zobrazit RTF
  if( oDesc:format <> 0, ::oxbp:Format := oDesc:format, nil )
*
  ::oXbp:create()
  ::oXbp:setData()
  ::oXbp:cargo := self
* Set keyboard and inputFocus callbacks
  ::oXbp:keyboard      := { |mp1, mp2, o| ::keyboard( mp1, mp2, o ) }
  ::oXbp:setInputFocus := { |mp1, mp2, o| ::setInputFocus( mp1, mp2, o ) }
* Initialization callback, after create

  IF (bBlock := ::drgDialog:getMethod(,'MleInit') ) != NIL
    EVAL(bBlock, self)
  ENDIF
*
  drgLog:cargo := NIL
RETURN self

***************************************************************************
* PostValidation control for this object
***************************************************************************
METHOD drgMLE:postValidate(endCheck)
LOCAL ret := .T.
  DEFAULT endCheck TO .F.

* No sense if readOnly or !editable
  IF ::disabled .OR. ::isReadOnly
    ::oXbp:undo()
    RETURN .T.
  ENDIF

  IF ::oXbp:editable
* End check. On form closing all objects must be postValidated.
    IF endCheck .AND. ::postValidOK != NIL
      RETURN ::postValidOK
    ENDIF
* Update memVar value
    ::oVar:getSet( ::oXbp:getData() )

* Normal postvalidation control
    IF ::postBlock != NIL
      IF !( ret := EVAL(::postBlock, ::oVar) )
*        ::oXbp:home()
      ENDIF
    ENDIF
 ENDIF
 ::postValidOK := ret
 IF !endCheck .AND. ret
   ::oXbp:setColorBG( ::clrFocus )
 ENDIF
RETURN ret

***************************************************************************
* Prevalidation method for MLE
***************************************************************************
METHOD drgMLE:preValidate()
LOCAL ret := ::drgObject:preValidate()
  IF ret .AND. !::disabled .AND. !::isReadOnly
    ::oXbp:setColorBG((drgPP:getPP(drgPP_PP_EDIT3)[2,2]))
  ENDIF
RETURN ret

***************************************************************************
* Default drgObject keyboard callback behaviour
***************************************************************************
METHOD drgMLE:keyBoard(nKey, mp2, oXbp)
* TAB and SH_TAB events are processed automaticly by checkBox.
*  IF !::oXbp:editable
    IF  (nKey = xbeK_TAB .OR. nKey == xbeK_SH_TAB) .AND. ::parent:keyHandled(nKey) .AND. ::postValidate()
      PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)
    ENDIF
*  ENDIF
RETURN .t.

***************************************************************************
* Refresh this object with new value
***************************************************************************
METHOD drgMLE:refresh(newValue)
  ::oXbp:setData()
RETURN

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgMLE:resize(aOld, aNew)
  LOCAL nX, nY, newX, newY
  *
  **  EBrowse se editujeme memo, nesmí se provést reSize
  if ::oxbp:parent:className() = 'XbpCellGroup'
    return self
  endif

  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
*   New Border size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oBord:currentSize()[1]+nX, ;
                                             ::oBord:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oBord:currentSize()[2]+nY, ;
                                             ::oBord:currentSize()[2] )
  ::oBord:setSize( {newX,newY}, .F.)
*   New MLE position
  newX := IIF(SUBSTR(::optResize,1,1) = 'n', ::oBord:currentPos()[1]+nX, ::oBord:currentPos()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'n', ::oBord:currentPos()[2]+nY, ::oBord:currentPos()[2] )
  ::oBord:setPos( {newX,newY}, .F.)
*   New MLE size
  newX := IIF(SUBSTR(::optResize,1,1) = 'y', ::oXbp:currentSize()[1]+nX, ::oXbp:currentSize()[1] )
  newY := IIF(SUBSTR(::optResize,2,1) = 'y', ::oXbp:currentSize()[2]+nY, ::oXbp:currentSize()[2] )
  ::oXbp:setSize( {newX,newY}, .F.)
RETURN self


***************************************************************************
* Refresh this object
***************************************************************************
METHOD drgMLE:destroy()
  ::drgObject:destroy()
  ::oBord:destroy()

  ::scroll    := ;
  ::picture   := ;
  ::oBord     := ;
  ::clrFocus  := ;
                 NIL
RETURN

************************************************************************
************************************************************************
*
* Get type definition class
*
************************************************************************
************************************************************************
CLASS _drgMLE FROM _drgObject
  EXPORTED:
  VAR     push
  VAR     scroll
  VAR     mleInit
  VAR     format

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgMLE:init(line)
  ::type := 'mle'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::fPos        TO {0, 0}
  DEFAULT ::size        TO {10, 10}
  DEFAULT ::PP          TO 1
  DEFAULT ::rOnly       TO .F.
  DEFAULT ::resize      TO 'yy'
  DEFAULT ::scroll      TO 'yy'
  DEFAULT ::format      TO 0

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgMLE:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'MLEINIT'
      ::MLEInit    := _getStr(value)
    CASE keyWord == 'SCROLL'
      ::scroll  := LOWER( _getStr(value) )
    CASE keyWord == 'FORMAT'
      ::format := _getNum(value)

    CASE ::parsed(keyWord, value)
    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgMLE:destroy()
  ::_drgObject:destroy()

  ::mleInit    := ;
  ::scroll     := ;
                  NIL
RETURN