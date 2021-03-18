//////////////////////////////////////////////////////////////////////
//
//  drgMessageBar.PRG
//
//  Copyright:
//       Yedro d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgMessageBar class takes care of message line at the bottom of the form.
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
#include "Drgres.ch"

* Class declaration
***********************************************************************
CLASS drgMessageBar

  EXPORTED:
    METHOD    init
    METHOD    create
    METHOD    destroy
    METHOD    resize

    METHOD    writeMessage

    VAR       picStatus
    VAR       msgStatus
    VAR       editState
    var       can_writeMessage

  HIDDEN:
    VAR       members
    VAR       parent
**    VAR       picStatus
**    VAR       msgStatus
**    VAR       editState

    VAR       warnCount

    METHOD    doResize
ENDCLASS

*************************************************************************
* Initialization of message line
*
* Parameters:
* \b<parentForm>b\    : drgForm : Form that holds this drgMessageBar
*
* \bReturns:b\        : self
*************************************************************************
METHOD drgMessageBar:init(parent)
  ::parent           := parent
  ::members          := {}
  ::warnCount        := 0
  ::can_writeMessage := .t.
RETURN self

***********************************************************************
* Create status line
***********************************************************************
METHOD drgMessageBar:create(oXbp)
LOCAL oBord, size:={0,0}, aPos:={0,0}
LOCAL oCorn, pos
*  oXbp := ::parent
* Right corner border 1
  aPos := ACLONE( ::parent:dataAreaSize )
  aPos[1] -= (drgINI:fontH + 2)
  aPos[2] := 0
  size    := {drgINI:fontH+2,drgINI:fontH+1}

  oBord := XbpStatic():new( oXbp, , aPos, size )
  oBord:type   := XBPSTATIC_TYPE_RAISEDBOX
  oBord:create()
  AADD(::members, oBord)

* Litle corner picture 2
  oCorn         := XbpStatic():new( oBord, , {drgINI:fontH - 15,1}, {16, 16} )
  oCorn:type    := XBPSTATIC_TYPE_ICON
  oCorn:caption := DRG_ICON_CORNER
  oCorn:create()
  AADD(::members, oCorn)

* Right corner border 3
  aPos[1] -= (drgINI:fontH + 2)

  oBord := XbpStatic():new( oXbp, , aPos, size )
  oBord:type   := XBPSTATIC_TYPE_RAISEDBOX
  oBord:create()
  AADD(::members, oBord)

* Form's edit status 4
  pos := INT((drgINI:fontH-16)/2) + 1
  ::editState   := XbpStatic():new( oBord, , {pos,pos}, {16,16} )
  ::editState:type    := XBPSTATIC_TYPE_ICON
  ::editState:caption := gDRG_ICON_EDIT
  ::editState:create()
  AADD(::members, ::editState)

* Create message border 5
  aPos[1] -= (drgINI:fontH + 2)
  size[1] := ::parent:dataAreaSize[1] - (drgINI:fontH + 2)*3
  size[2] := drgINI:fontH + 1

  oBord := XbpStatic():new( oXbp, , {drgINI:fontH + 2, 0} , size )
  oBord:type   := XBPSTATIC_TYPE_RAISEDBOX
  oBord:create()
  AADD(::members, oBord)

* Message status object 6
  size[1] -= 5
  size[2] := drgINI:fontH - 4
  ::msgStatus      := XbpStatic():new( oBord, , {3,1}, size)
  ::msgStatus:type := XBPSTATIC_TYPE_TEXT
  ::msgStatus:create()
  AADD(::members, ::msgStatus)

* Message status icon border 7
  oBord := XbpStatic():new( oXbp, , {0,0}, {drgINI:fontH + 2, drgINI:fontH + 1} )
  oBord:type   := XBPSTATIC_TYPE_RAISEDBOX
  oBord:create()
  AADD(::members, oBord)

* Message status picture 8
  ::picStatus    := XbpStatic():new( oBord, , {pos,pos}, {16,16})
  ::picStatus:type    := XBPSTATIC_TYPE_ICON
  ::picStatus:caption := DRG_ICON_MSGWARN
  ::picStatus:create()
  ::picStatus:hide()
  AADD(::members, ::picStatus)

RETURN self

*************************************************************************
* Write message to the message line.
*
* Parameters:
* \b< msg >b\     : String  : Message to be displayed
* \b< msgType >b\ : Numeric : Message type.
*
* \bReturns:b\        : self
*************************************************************************
METHOD drgMessageBar:writeMessage(msg, msgType)
  DEFAULT msg     TO ''
  DEFAULT msgType TO DRG_MSG_INFO


  * nechchceme zobrazovat zprávy
  if .not. ::can_writeMessage
    return self
  endif


  DO CASE
  CASE msgType = DRG_MSG_INFO
* Warning usualy means that edited field is left. But then logic of the form will
* clear message line immediately after new field is positioned. The result would be
* just a flash in a message line. This will preserve the warning to be on at least for
* one field more.
    IF EMPTY(msg) .AND. ::picStatus:caption = DRG_ICON_MSGWARN .AND. ::warnCount++ = 0
      RETURN self
    ENDIF
    ::msgStatus:setCaption(msg)
    ::picStatus:hide()

  CASE msgType = DRG_MSG_ERROR
    ::picStatus:setCaption(DRG_ICON_MSGERR)
    ::msgStatus:setCaption(msg)
    ::picStatus:show()
    Tone(150,3)

  CASE msgType = DRG_MSG_WARNING
    ::warnCount := 0
    ::msgStatus:setCaption(msg)
    ::picStatus:setCaption(DRG_ICON_MSGWARN)
    ::picStatus:show()
    Tone(500,3)

  CASE  ::parent:dialogCtrl:isReadOnly .OR. msgType = drgEVENT_FIND
    IF ::editState:caption != DRG_ICON_FIND
      ::editState:setCaption(DRG_ICON_FIND)
    ENDIF

  CASE msgType = drgEVENT_EDIT
    IF ::editState:caption = gDRG_ICON_EDIT
      ::editState:setCaption(DRG_ICON_EDIT)
    ENDIF

  CASE msgType = drgEVENT_APPEND
    ::editState:setCaption(DRG_ICON_APPEND)

  CASE msgType = drgEVENT_APPEND2
    ::editState:setCaption(DRG_ICON_APPEND2)

  CASE msgType = drgEVENT_SAVE
    IF ::editState:caption != gDRG_ICON_EDIT
      ::editState:setCaption(gDRG_ICON_EDIT)
    ENDIF

  OTHERWISE
    ::picStatus:hide()
    ::msgStatus:setCaption('')
  ENDCASE
RETURN self

*********************************************************************
* Destroys drgMessageBar internal objects
*********************************************************************
METHOD drgMessageBar:resize(aOld, aNew)
LOCAL nX, nY
  nX := aNew[1] - aOld[1]
  ::doResize(nX, 5, .T.)
  ::doResize(nX, 6, .T.)
  ::doResize(nX, 3, .F.)
  ::doResize(nX, 1, .F.)
RETURN self

*********************************************************************
* Destroys drgMessageBar internal objects
*********************************************************************
METHOD drgMessageBar:doResize(nX, nPos, lResize)
LOCAL newX, newY
* New Border size
  IF lResize
    newX := ::members[nPos]:currentSize()[1]+nX
    newY := ::members[nPos]:currentSize()[2]
    ::members[nPos]:setSize( {newX,newY}, .F.)
  ELSE
* New border position
    newX := ::members[nPos]:currentPos()[1]+nX
    newY := ::members[nPos]:currentPos()[2]
    ::members[nPos]:setPos( {newX,newY}, .F.)
  ENDIF
RETURN self

*********************************************************************
* Destroys drgMessageBar internal objects
*********************************************************************
METHOD drgMessageBar:destroy
LOCAL x
  FOR x := LEN(::members) TO 1 STEP - 1
    ::members[x]:destroy()
  NEXT x
  ::members   := ;
  ::parent    := ;
  ::picStatus := ;
  ::msgStatus := ;
  ::editState := ;
  ::warnCount := ;
                  NIL
RETURN self