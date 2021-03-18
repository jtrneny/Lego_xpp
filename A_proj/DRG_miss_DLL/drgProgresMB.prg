//////////////////////////////////////////////////////////////////////
//
//  drgProgressMB.PRG
//
//  Copyright:
//       Yedro d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgProgressMB class takes care of message line at the bottom of the form.
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
CLASS drgProgressMB

EXPORTED:
  METHOD  init
  METHOD  create
  METHOD  destroy
  METHOD  resize

  METHOD  writeMessage
  METHOD  progressStart
  METHOD  progressInc
  METHOD  progressEnd
  METHOD  progressRefresh

HIDDEN:
  VAR     members
  VAR     parent
  VAR     progressMax
  VAR     progressCurr
  VAR     progressStep
  VAR     progressTMP

  VAR     msgPercent
  VAR     msgSquare

  METHOD  doResize
ENDCLASS

*************************************************************************
* Initialization of message line
*
* Parameters:
* \b<parentForm>b\    : drgForm : Form that holds this drgProgressMB
*
* \bReturns:b\        : self
*************************************************************************
METHOD drgProgressMB:init(parent)
  ::parent  := parent
  ::members := {}
RETURN self

***********************************************************************
* Create status line
***********************************************************************
METHOD drgProgressMB:create(oXbp)
LOCAL oBord, size:={0,0}, aPos:={0,0}
LOCAL oCorn, pos
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

* Create squares border 3
  aPos[1] -= 5*drgINI:fontW
  size[1] := ::parent:dataAreaSize[1] - (drgINI:fontH + 2 + 5*drgINI:fontW)
  size[2] := drgINI:fontH + 1

  ::msgSquare := XbpStatic():new( oXbp, , { 5*drgINI:fontW, 0} , size )
  ::msgSquare:type   := XBPSTATIC_TYPE_RAISEDBOX
  ::msgSquare:create()
  AADD(::members, ::msgSquare)

* Message status icon border 4
  size[1] := 5*drgINI:fontW
  size[2] := drgINI:fontH + 1
  oBord := XbpStatic():new( oXbp, , {0,0}, size )
  oBord:type   := XBPSTATIC_TYPE_RAISEDBOX
  oBord:create()
  AADD(::members, oBord)

* Message status object 5
  size[1] -= 5
  size[2] := drgINI:fontH - 4
  ::msgPercent        := XbpStatic():new( oBord, , {3,1}, size)
  ::msgPercent:type   := XBPSTATIC_TYPE_TEXT
  ::msgPercent:options  := XBPSTATIC_TEXT_CENTER
  ::msgPercent:create()
  AADD(::members, ::msgPercent)

RETURN self

*************************************************************************
* Write message to the message line. Dummy.
*
* Parameters:
* \b< msg >b\     : String  : Message to be displayed
* \b< msgType >b\ : Numeric : Message type.
*
* \bReturns:b\        : self
*************************************************************************
METHOD drgProgressMB:writeMessage(msg, msgType)
RETURN self

*************************************************************************
* Set maximal value for progress bar and initialize bar.
*
* Parameters:
* \b< nMaxValue >b\ : Numeric : Maximal increment to be reached.
*
* \bReturns:b\     : self
*************************************************************************
METHOD drgProgressMB:progressStart(nMaxValue)
LOCAL n
  ::progressMax  := IIF(nMaxValue > 0, nMaxValue, 0)
  ::progressTMP  := 0
  ::progressCurr := 0
* Count number of steps per square
  n := INT(::msgSquare:currentSize()[1] / (drgINI:fontH - 4) )
  IF (::progressStep  := INT(nMaxValue/n) ) = 0
    ::progressStep++
  ENDIF

  ::members[3]:invalidateRect()
RETURN self

*************************************************************************
* Increment progress status.
*
* Parameters:
* \b< nIncrement >b\ : Numeric : Number of increments.
*
* \bReturns:b\     : self
*************************************************************************
METHOD drgProgressMB:progressInc(nIncrement)
  DEFAULT nIncrement TO 1
  ::progressTMP  += nIncrement
* If number of increments has reached
  IF ::progressTMP > ::progressStep
    ::progressCurr += ::progressTMP
    ::progressRefresh()
    ::progressTMP  := 0
  ENDIF
*  drgDump(::progressCurr, STR(::progressMax) )
RETURN self

*************************************************************************
* Clear progress status line.
*
* Parameters:
* \b< nIncrement >b\ : Numeric : Number of increments.
*
* \bReturns:b\     : self
*************************************************************************
METHOD drgProgressMB:progressEnd(nIncrement)
  ::progressMax := 0
  ::msgPercent:setCaption('')
  ::members[3]:invalidateRect()
RETURN self

*************************************************************************
* Clear progress status line.
*
* Parameters:
* \b< nIncrement >b\ : Numeric : Number of increments.
*
* \bReturns:b\     : self
*************************************************************************
METHOD drgProgressMB:progressRefresh()
LOCAL n, prc, x
LOCAL oPS, xPos
LOCAL aAttr [ GRA_AA_COUNT ]
  n := INT(::progressCurr/::progressStep)
* No more than maximum
  IF ::progressCurr > ::progressMax
    ::progressCurr := ::progressMax
  ENDIF
*
  prc := ALLTRIM( STR( INT(100*::progressCurr/::progressMax) )) + '%'
  ::msgPercent:setCaption(prc)
* Display squares needed
  oPS  := ::msgSquare:lockPS()
  aAttr [ GRA_AA_COLOR ] := GRA_CLR_BLUE
  GraSetAttrArea( oPS, aAttr )
  xPos := 2
  FOR x := 1 TO n
    GraBox( oPS, {xPos,4}, {xPos + drgINI:fontH - 8, drgINI:fontH - 4}, GRA_FILL )
    xPos += (drgINI:fontH - 4)
  NEXT
  ::msgSquare:unlockPS( oPS )
RETURN self

*********************************************************************
* Resize drgProgressMB
*********************************************************************
METHOD drgProgressMB:resize(aOld, aNew)
LOCAL nX, nY
  nX := aNew[1] - aOld[1]
  ::doResize(nX, 3, .T.)
  ::doResize(nX, 1, .F.)
RETURN self

*********************************************************************
* Destroys drgProgressMB internal objects
*********************************************************************
METHOD drgProgressMB:doResize(nX, nPos, lResize)
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
* Destroys drgProgressMB internal objects
*********************************************************************
METHOD drgProgressMB:destroy
LOCAL x
  FOR x := LEN(::members) TO 1 STEP - 1
    ::members[x]:destroy()
  NEXT x
  ::members       := ;
  ::parent        := ;
  ::progressMax   := ;
  ::progressCurr  := ;
  ::progressStep  := ;
  ::progressTMP   := ;
  ::msgPercent    := ;
  ::msgSquare     := ;
                      NIL
RETURN self



