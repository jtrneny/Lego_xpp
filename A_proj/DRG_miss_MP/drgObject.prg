//////////////////////////////////////////////////////////////////////
//
//  drgObject.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgObject class is a superclass to all drgGet objects. It also
//      implements methods common to all drgGet objects.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "drg.ch"
#include "Common.ch"
#include "appevent.ch"


* Class declaration
***********************************************************************
CLASS drgObject
  EXPORTED:

  VAR     parent
  VAR     name
  VAR     drgDialog
  VAR     oXbp
  VAR     oVar
  VAR     postValidOK
  VAR     tipText
  VAR     isReadOnly
  VAR     isEdit
  VAR     isGroup
  VAR     isContainer
  VAR     canResize
  VAR     optResize
  VAR     disabled
  VAR     Groups                                                                // miss
  VAR     isedit_inrev
  var     AdsSetOrder, recPosFocus


  VAR     preBlock
  VAR     postBlock

  INLINE METHOD init(parent)
    ::parent       := parent
    ::drgDialog    := ::parent:drgDialog
    ::isReadOnly   := ::drgDialog:dialogCtrl:isReadOnly
    ::isEdit       := .T.
    ::isGroup      := .F.
    ::isContainer  := .F.
    ::canResize    := .F.
    ::disabled     := .F.
    ::Groups       := ''
    ::isedit_inrev := .T.
  RETURN self
  METHOD destroy

  INLINE METHOD create()
  RETURN self

  INLINE METHOD refresh(newValue)
*    oXbp:setValue(newValue)
  RETURN self

  METHOD setPreValidate
  METHOD preValidate
  METHOD setPostValidate
  METHOD postValidate
*  METHOD postValidValues

  METHOD setFocus
  METHOD keyBoard
  METHOD setInputFocus

ENDCLASS

****************************************************************************
* Destroys all internal data.
****************************************************************************
METHOD drgObject:destroy()
  IF ::oXbp != NIL
    * editaèní objekty mohou být souèástí BROWSE *
    IF ::oXbp:parent:className() <> 'XbpCellGroup'
      ::oXbp:destroy()
    ENDIF
  ENDIF
*
  ::parent       := ;
  ::name         := ;
  ::drgDialog    := ;
  ::oXbp         := ;
  ::oVar         := ;
  ::postValidOK  := ;
  ::tipText      := ;
  ::isReadOnly   := ;
  ::isEdit       := ;
  ::isGroup      := ;
  ::isContainer  := ;
  ::canResize    := ;
  ::optResize    := ;
  ::disabled     := ;
  ::preBlock     := ;
  ::postBlock    := ;
  ::Groups       := ;
  ::isedit_inrev := ;
                   NIL
RETURN

***************************************************************************
* Default drgObject keyboard callback behaviour
***************************************************************************
METHOD drgObject:keyBoard(nKey, mp2, oXbp)

/*
  IF ::drgDialog:oForm:oLastDrg = self
    if ::drgDialog:oForm:nexitState = GE_ENTER
      return self
    endif
*    drgDump('stejný objekt - stejná klávesa ?' +str(nKey) + ;
*      str( ::drgDialog:oForm:nexitState ) )
  ENDIF
*/

  IF ::parent:keyHandled(nKey,mp2,oxbp) .AND. ::postValidate()
*    drgDump('drgObject:keyboard')
    PostAppEvent(drgEVENT_OBJEXIT, self,, oXbp)

  ELSE
    IF nKEy = xbeK_F4
       IF IsObject(oXbp:cargo) .and. oXbp:cargo:ClassName() = 'drgGet'
         IF IsObject(oXbp:cargo:pushGet) .and. oXbp:cargo:pushGet:ClassName() = 'drgPushButton'
           oXbp:cargo:pushGet:activate(.F.)
           RETURN .T.
         ENDIF
       ENDIF
    ENDIF
  ENDIF
RETURN self

***************************************************************************
* Default drgObject setInputFocus callback behaviour
***************************************************************************
METHOD drgObject:setInputFocus(mp1, mp2, oXbp)
*  drgDump(self)
**************** POZOR na prvi IF. Še ni testiran
  IF ::drgDialog:oForm:oLastDrg != self
    IF ::parent:ok4Focus(self, oXbp)
      ::setFocus(mp1, mp2, oXbp)
    ENDIF
  ENDIF
RETURN self

***************************************************************************
* Called by Form controller when drgObject can receive focus
***************************************************************************
METHOD drgObject:setFocus(mp1, mp2, oXbp)
  local  aMembers := ::drgDialog:oForm:aMembers
  local  oLastDrg := ::drgDialog:oForm:oLastdrg

  IF !::preValidate()
    PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp)
  ELSE
*** JS ***
*   ver 1.1

   if isobject(oXbp) .and. oXbp:className() <> 'xbpComboBox'
     npos := ascan( aMembers, { |o| o:oXbp = oXbp } )

     if npos <> 0

       if aMembers[npos]:isEdit
         ::drgDialog:oForm:oLastdrg   := aMembers[npos]
         ::drgDialog:oForm:nLastDrgIx := npos
         ::drgDialog:oForm:oLastDrg:setFocus()

         _clearEventLoop(.t.)

         if oLastDrg <> ::drgDialog:oForm:oLastdrg .or. oXbp:cargo:className() = 'drgEBrowse'

           postAppEvent(drgEVENT_OBJENTER, self,, aMembers[npos]:oXbp)
           setAppFocus( ::oXbp )
         endif
       endif

       return self
     endif
   endif


* ver 1.1
*   tohle tady musí být páè comboBox by se zapomìn s kurzorem,
**  ono je to valstnì okno s fokusem
    postAppEvent(drgEVENT_OBJENTER, self,, oXbp)
    SetAppFocus( ::oXbp )

  ENDIF
RETURN self

****************************************************************************
* Sets default prevalidation codeblock for drgObject
****************************************************************************
METHOD drgObject:setPreValidate(aDesc)
LOCAL aName, pre
  aName := IIF(AT('->', aDesc:name) = 0, aDesc:name, drgParseSecond(aDesc:name,'>') )
* Replace colon with underscore, since colon canno't be part of function name
  aName := STRTRAN(aName,':','_')
  pre   := IIF(aDesc:pre != NIL, aDesc:pre, ::drgDialog:formHeader:pre)
  ::preBlock := ::drgDialog:getMethod( pre, 'pre' + aName)

* Set also pointer to reference if exists
  IF aDesc:ref != NIL
    ::oVar:ref := drgREF:getRef(aDesc:name)
  ENDIF
*
  ::disabled := aDesc:rOnly
RETURN self

****************************************************************************
* Default preValidation method of drgObject.
****************************************************************************
METHOD drgObject:preValidate()
LOCAL ret := .T.
/*
  if ::oxbp:isDerivedFrom('xbpGet')
    drgDump(::oXbp:getData(), 'prevalid' )
    drgDump(::oVar:name,'name')
  endif
*/
*
* NI TESTIRANO. Tudi kot kaže neuporabno.
*  IF ::drgDialog:oForm:oLastDrg = self
*    RETURN .T.
*  ENDIF
*
  IF ::disabled
    ret := .F.
  ELSEIF ::preBlock != NIL
    ret := EVAL(::preBlock, ::oVar)
  ENDIF
* Set postValidOK flag to true if prevalidation fails.
  ::postValidOK := NIL
RETURN ret

****************************************************************************
* Sets default postvalidation codeblock for drgObject
****************************************************************************
METHOD drgObject:setPostValidate(aDesc)
LOCAL aName, post
  aName := IIF(AT('->', aDesc:name) = 0, aDesc:Name, drgParseSecond(aDesc:Name,'>') )
* Replace colon with underscore, since colon can't be part of function name
  aName := STRTRAN(aName,':','_')
  post := IIF(aDesc:post != NIL, aDesc:post, ::drgDialog:formHeader:post)
  ::postBlock := ::drgDialog:getMethod( post, 'post' + aName)
RETURN self

****************************************************************************
* Default postValidation method of drgObject.
****************************************************************************
METHOD drgObject:postValidate(endCheck)
LOCAL ret := .T.
  DEFAULT endCheck TO .F.
* End check. On form closing all objects must be postvalidated.
  IF endCheck .AND. ::postValidOK != NIL
    ret := ::postValidOK
* Call postvalidate
  ELSEIF ::postBlock != NIL
    ret := EVAL(::postBlock, ::oVar)
  ENDIF
  ::postValidOK := ret
* Clear event loop if postValidation failed
  IF !ret
*    _clearEventLoop()
  ENDIF
RETURN ret


************************************************************************
************************************************************************
*
* Abstract definition of line in a drgForm.
*
************************************************************************
************************************************************************
CLASS _drgObject
  EXPORTED:

  VAR     type
  VAR     name
  VAR     file
  VAR     ref
  VAR     fPos
  VAR     fLen
  VAR     picture
  VAR     fCaption
  VAR     caption
  VAR     cPos
  VAR     cLen
  VAR     cType
  VAR     pre
  VAR     post
  VAR     postEval
  VAR     pp
  VAR     clrFG
  VAR     clrBG
  VAR     tipText
  VAR     size
  VAR     font
  VAR     resize
  VAR     rOnly
  VAR     bgnd                  // ker se pojavlja pri definiciji vseh polj
  VAR     groups                // miss
  VAR     isedit_inrev
  VAR     isbit_map

*  METHOD  init
  METHOD  parsed
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
*METHOD _drgObject:init()
*RETURN self

************************************************************************
* Init
************************************************************************
METHOD _drgObject:parsed(keyWord, value)
  DO CASE
  CASE keyWord == 'FILE'
    ::file := UPPER( _getStr(value) )
  CASE keyWord == 'NAME'
    ::name := UPPER(_getStr(value) )
  CASE keyWord == 'FPOS'
    ::fPos := _getNumArr(value)
  CASE keyWord == 'FLEN'
    ::fLen := _getNum(value)
  CASE keyWord == 'CAPTION'
    ::caption := _getStr(value)
  CASE keyWord == 'FCAPTION'
    ::fCaption := _getStr(value)
  CASE keyWord == 'CPOS'
    ::cPos := _getNumArr(value)
  CASE keyWord == 'CLEN'
    ::cLen := _getNum(value)
  CASE keyWord == 'CTYPE'
    ::cType := _getNum(value)
  CASE keyWord == 'PICTURE'
    ::picture := _getStr(value)
  CASE keyWord == 'CLRFG'
    ::clrFG := _getNum(value)
  CASE keyWord == 'CLRBG'
    ::clrBG := _getNum(value)
  CASE keyWord == 'PRE'
    ::pre := _getStr(value)
  CASE keyWord == 'POST'
    ::post := _getStr(value)
  CASE keyWord == 'POSTEVAL'
    ::postEval := _getStr(value)
  CASE keyWord == 'REF'
    ::ref := ALLTRIM( _getStr(value) )
  CASE keyWord == 'TIPTEXT'
    ::tipText := _getStr(value)
  CASE keyWord == 'SIZE'
    ::size := _getNumArr(value)
  CASE keyWord == 'PP'
    ::pp   := _getNum(value)
  CASE keyWord == 'FONT'
    ::font := _getNum(value)
  CASE keyWord == 'RESIZE'
    ::resize := LOWER(_getStr(value) )
  CASE keyWord == 'READONLY'
    ::rOnly := _getLogical(value)
  CASE keyWord == 'BGND'
    ::bgnd := _getNum(value)
  CASE keyWord == 'GROUPS'                        // miss
    ::groups := _getStr(value)

  case keyWord == 'NOREVISION'
    ::isedit_inrev := .F.
  case keyWord == 'BITMAP'
    ::isbit_map := .T.

  CASE keyWord == 'TYPE'
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

************************************************************************
* CleanUP
************************************************************************
METHOD _drgObject:destroy()
  ::type         := ;
  ::name         := ;
  ::file         := ;
  ::ref          := ;
  ::fPos         := ;
  ::fLen         := ;
  ::picture      := ;
  ::fCaption     := ;
  ::caption      := ;
  ::cPos         := ;
  ::cLen         := ;
  ::cType        := ;
  ::pre          := ;
  ::post         := ;
  ::postEval     := ;
  ::pp           := ;
  ::clrFG        := ;
  ::clrBG        := ;
  ::tipText      := ;
  ::size         := ;
  ::font         := ;
  ::resize       := ;
  ::rOnly        := ;
  ::bgnd         := ;
  ::groups       := ;
  ::isedit_inrev := NIL
RETURN