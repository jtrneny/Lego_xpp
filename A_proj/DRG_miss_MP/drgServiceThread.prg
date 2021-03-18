************************************************************************
*  drgServiceThread.PRG
*
*   Copyright:
*        DRGS d.o.o., (c) 2003. All rights reserved.
*
*  Contents:
*       Object drgServiceThread takes care for backgroud actions which are needed \
*       for DRG object to work normal. These actions are:
*       - animating actions on icon bar, action bar and pushButton object
*       - displaying tooltips
*       - displaying and calculating progress bar when requested
*
*
*  Remarks:
*
************************************************************************

#include "Common.ch"
#include "Appevent.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

CLASS drgServiceThread FROM Thread
PROTECTED:
  METHOD  atStart, execute, atEnd

EXPORTED:
  VAR     dialog

  METHOD  setActiveThread

  METHOD  progressStart
  METHOD  progressInc
  METHOD  progressEnd

HIDDEN:
  VAR     actionInFocus
  VAR     actThread
  VAR     oTip
  VAR     lastTipped
  VAR     members

  VAR     progressMax                        // Maximum progress value
  VAR     progressCurr                       // Current progress value
  VAR     progressCount                      // Number of squares displayed on progress bar
  VAR     progressStart                      // Time when progress started

  VAR     progressBorder
  VAR     progressText
  VAR     progressTime

  METHOD  activateAction
  METHOD  deActivateAction
  METHOD  showTip
  METHOD  hideTip

  METHOD  progressRefresh
ENDCLASS


METHOD drgServiceThread:atStart()
LOCAL oBord
  ::setInterval( 0 )

  ::members := {}
* Create dialog for progress bar and also for receiving external messages
  ::dialog := XbpDialog():new( AppDesktop(), , {1,1}, {220, drgINI:fontH*2 + 30},,.F.)
  ::dialog:border   := XBPDLG_DLGBORDER
  ::dialog:taskList := .F.
  ::dialog:titleBar := .F.
  ::dialog:alwaysOnTop := .T.  //new

  ::dialog:create()
  AADD(::members, ::dialog)

* Create border for displaying progress squares
  ::progressBorder := XbpStatic():new(::dialog:drawingArea,, {2,2}, {210,17})
  ::progressBorder:type  := XBPSTATIC_TYPE_RECESSEDBOX
  ::progressBorder:create()
  ::progressBorder:clipChildren := .T.
  AADD(::members, ::progressBorder)

* Create text for displaying remaining time
  ::progressTime := XbpStatic():new(::dialog:drawingArea,, {2,20}, {210, drgINI:fontH-4} )
  ::progressTime:options  := XBPSTATIC_TEXT_CENTER
  ::progressTime:create()
  ::progressTime:setColorFG(GRA_CLR_BLUE)   //GRA_CLR_WHITE)
  AADD(::members, ::progressTime)

* Small line
  oBord := XbpStatic():new(::dialog:drawingArea,, {2,20+drgINI:fontH}, {210,2})
  oBord:type  := XBPSTATIC_TYPE_RECESSEDLINE
  oBord:create()
  AADD(::members, oBord)

* Create text for displaying coment
  ::progressText := XbpStatic():new(::dialog:drawingArea,, {2,22+drgINI:fontH}, {210, drgINI:fontH-4} )
  ::progressText:options  := XBPSTATIC_TEXT_CENTER
  ::progressText:create()
  AADD(::members, ::progressText)

* Point to itself at start
  ::actThread   := 0
  ::progressMax := NIL

RETURN self

************************************************************************
* Execution part of thread.
*
* \bParameters:b\
* \b<threadType>b\    : string  : Type of program for execuition.
* \b[aTask]b\         : object Of schTask : task definition
************************************************************************
METHOD drgServiceThread:execute()
LOCAL nEvent, oXbp, mp1, mp2, cargo
LOCAL waitTime := 0, lastmp := {0, 0}, lastmp2

  WHILE .T.
* Handle service thread events
    WHILE (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) != xbe_None
      IF nEvent = xbeP_Close
* End thread on CLOSE event
        ::setInterval( NIL )
        RETURN
      ENDIF
      oXbp:handleEvent( nEvent, mp1, mp2 )
    ENDDO

* Refresh progress bar if progress active
    IF ::progressMax != NIL
      ::progressRefresh()
    ENDIF
* SLEEP for a WHILE
    SLEEP(5)
    IF ::actThread > 0
      nEvent := LastAppEvent(@mp1, @mp2, @oXbp, ::actThread)
* Mouse motion event
      IF nEvent == xbeM_Motion
* Nothing happend and mouse is not moved
        IF (mp1[1] = lastmp[1] .AND. mp1[2] = lastmp[2])
          waitTime++
        ELSE
* Check if cargo object is pointing to drgAction
          cargo := oXbp:cargo
          IF cargo = NIL .OR. VALTYPE(cargo) != 'O'
            ::deactivateAction()
          ELSEIF cargo:IsDerivedFrom('DrgAction')
* Current active action differs from last active
            IF ::actionInFocus != cargo .OR. ::actionInFocus:frameState != 2
              ::deactivateAction()
              ::activateAction(cargo)
            ENDIF
          ELSE
* Motion was on some other object
          ::deactivateAction()
          ENDIF
* Reset tooltip waitTime
          lastmp   := ACLONE(mp1)
          waitTime := 0
          ::hideTip()
        ENDIF
* Mouse button down
      ELSEIF nEvent == xbeM_LbDown
* Is action stil in focus and it is the same action
        cargo := oXbp:cargo
        IF cargo != NIL .AND. VALTYPE(cargo) = 'O' .AND. cargo:IsDerivedFrom('DrgAction')
          IF ::actionInFocus != cargo
            ::deactivateAction()
          ENDIF

          IF cargo:oXbp != NIL              // win 2000 problem
            ::actionInFocus := cargo
            ::actionInFocus:frameState := 3
            ::actionInFocus:drawFrame()
          ENDIF
        ELSE
          ::deactivateAction()
        ENDIF
* Mouse click
      ELSEIF nEvent == xbeM_LbClick .OR. nEvent == xbeM_LbUp  //.OR. nEvent == xbeM_LbDblClick
* Is action stil in focus and it is the same action
        IF ::actionInFocus != NIL
          cargo := oXbp:cargo
          IF cargo = ::actionInFocus
* Activate action
            PostAppEvent(drgEVENT_ACTIVATE,::actionInFocus,,::actionInFocus:oXbp)
*            ::actionInFocus:activate()
*            ::activateAction(cargo)
*            ::actionInFocus := NIL
          ELSE
            ::deactivateAction()
          ENDIF
        ENDIF
* Something else has happend. Hide tip
      ELSE
* won't show the tip again if mouse is not moved to other object
        waitTime := 100
        ::hideTip()
      ENDIF
* 0.5 second has past and nothing happend. Show the tip
      IF waitTime = 10
        ::showTip(oXbp, lastmp)
      ENDIF
* 2  second have past and nothing happend. Hide the tip
      IF waitTime = 60
        ::hideTip(oXbp, lastmp)
      ENDIF

    ENDIF
  ENDDO
  ::setInterval( NIL )
RETURN

**********************************************************************
* Deactivate currently active action if action was previously active.
**********************************************************************
METHOD drgServiceThread:deactivateAction()
  IF ::actionInFocus != NIL
* This happends when dialog window is already closed
    IF ::actionInFocus:oXbp != NIL
      ::actionInFocus:frameState := 1
      ::actionInFocus:drawFrame()
    ENDIF
    ::actionInFocus  := NIL
  ENDIF
RETURN

**********************************************************************
* Set currently active action if action was previously active.
**********************************************************************
METHOD drgServiceThread:activateAction(cargo)
  ::actionInFocus := cargo
  ::actionInFocus:frameState := 2
  ::actionInFocus:drawFrame()
RETURN

**********************************************************************
* Paint tooltip if tipText variable is present.
* Method is copied from "Markus Reuscher" toolbar.PRG. Thanks Markus.
*
* \bParameters:b\
* \b< oXbp >b\     : object of type xbpXXX : last active object
**********************************************************************
METHOD drgServiceThread:showTip(oXbp, lastmp)
LOCAL aAttr, oPS
LOCAL aPoints
LOCAL aSize := {0,0}, aPos
LOCAL aAttrLine[ GRA_AL_COUNT ]
LOCAL cargo, cText
* Don't show twice on same object
  IF oXbp = ::lastTipped; RETURN; ENDIF
* Get cargo of object and RETURN if not set
  cargo := oXbp:cargo
  IF cargo = NIL .OR. VALTYPE(cargo) != 'O'; RETURN; ENDIF
* Has cargo object a tipText member variable
  IF !IsMemberVar( cargo, 'tipText' ); RETURN; ENDIF
* Get tooltip text and RETURN if EMPTY
  cText := cargo:tipText
  IF cText = NIL .OR. EMPTY(cText)
    RETURN
  ENDIF
* Calculate absolute position on the screen
  aPos  := calcAbsolutePosition(lastmp, oXbp)
  aPos[1] += 6
  aPos[2] -= (33)
* Static for holding tooltip
  ::oTip := XbpStatic():new()
  ::oTip:options := XBPSTATIC_TYPE_FGNDFRAME
  ::oTip:create(AppDesktop(),AppDesktop(), aPos, {0, 0})
*
  oPS := ::oTip:lockPS()
  aPoints := GraQueryTextBox( oPS, cText)
  ::oTip:unlockPS()

  aSize[1] := (aPoints[3,1] - aPoints[1,1]) + 8
  aSize[2] := (aPoints[1,2] - aPoints[2,2]) + 4

  ::oTip:setSize(aSize,.F.)
  oPS := ::oTip:lockPS()

* Background color
  aAttr := Array( GRA_AA_COUNT )
  aAttr [ GRA_AA_COLOR ] := XBPSYSCLR_INFOBACKGROUND
  GraSetAttrArea( oPS, aAttr )
  GraBox( oPS, { 1, 1}, { aSize[ 1] + 4, aSize[ 2] + 4}, GRA_FILL) // , 20, 20)

* Tooltip Frame
  aAttrLine[GRA_AL_COLOR] := GRA_CLR_DARKGRAY
  oPS:setAttrLine( aAttrLine )

  GraLine( oPS, {0,0}, {0,aSize[2]-1} )
  GraLine( oPS, NIL  , {aSize[1]-1,aSize[2]-1} )
  aAttrLine[GRA_AL_COLOR] := GRA_CLR_BLACK
  oPS:setAttrLine( aAttrLine )
  GraLine( oPS, NIL, {aSize[1]-1,0 } )
  GraLine( oPS, NIL, {0,0} )

* Write text
  aAttr := Array( GRA_AA_COUNT )
  aAttr [ GRA_AA_COLOR ] := GRA_CLR_BLACK
  GraSetAttrArea( oPS, aAttr )
//   GraBox( oPS, {0,1}, {aSize[1]-1,aSize[2]})

  GraStringAt( oPS, {4,4}, cText)
  ::oTip:unLockPS( oPS)
  ::lastTipped := oXbp
RETURN

**********************************************************************
* Hide the tip if it is shown.
**********************************************************************
METHOD drgServiceThread:hideTip()
  IF ::oTip != NIL
    ::oTip:hide()
    ::oTip:destroy()
    ::oTip := NIL
  ENDIF
RETURN

**********************************************************************
* Set curently active window thread. So the service thread knows who to \
* listen to.
**********************************************************************
METHOD drgServiceThread:setActiveThread(thread)
  IF ::actionInFocus != NIL
    ::deactivateAction()
    ::actionInFocus := NIL
  ENDIF
  ::lastTipped := NIL
  ::actThread  := thread

RETURN self

***********************************************************************
* PROGRESS methods implementation
***********************************************************************

***********************************************************************
* Start progressBar
***********************************************************************
METHOD drgServiceThread:progressStart(comment, maxValue, parentDialog)
LOCAL aPos
  ::progressMax   := maxValue
  ::progressStart := SECONDS()
  ::progressCurr  := 0
  ::progressCount := 0
*  ::dialog:title  := comment
  ::progressText:setCaption(comment)

  aPos := _CenterPos(::dialog, parentDialog)
  ::dialog:setPos(aPos)
  ::dialog:show()
  ::dialog:toFront()

RETURN self

***********************************************************************
* Increment progress bar value
***********************************************************************
METHOD drgServiceThread:progressInc()
  ::progressCurr++
RETURN self

***********************************************************************
* Call when progress bar has ended
***********************************************************************
METHOD drgServiceThread:progressEnd()
  ::progressMax := NIL
  ::dialog:hide()
RETURN self

***********************************************************************
* Refreshes contents of progressBar
***********************************************************************
METHOD drgServiceThread:progressRefresh()
LOCAL tmp, oPS, xPos, elapsedTime, timeLeft
LOCAL aAttr [ GRA_AA_COUNT ]

* No need yet to display another square
  IF (tmp := INT(20*::progressCurr/::progressMax)) = ::progressCount
    RETURN
  ENDIF
* Calculate time left to end progress
  elapsedTime := SECONDS() - ::progressStart
  timeLeft    := INT(elapsedTime*20/tmp - elapsedTime)
  ::progressTime:setCaption(drgNLS:msg("& seconds left", ALLTRIM(STR(timeLeft)) ))

* Display squares needed
  oPS  := ::progressBorder:lockPS()
  aAttr [ GRA_AA_COLOR ] := GRA_CLR_BLUE
  GraSetAttrArea( oPS, aAttr )
  WHILE ::progressCount < tmp
    xPos := 4 + ::progressCount*10    // size 6 + 2 spaces
    GraBox( oPS, {xPos,4}, {xPos+8, 12}, GRA_FILL )
    ::progressCount++
  ENDDO

  ::progressBorder:unlockPS( oPS )
RETURN self

**********************************************************************
* CleanUP
**********************************************************************
METHOD drgServiceThread:atEnd()
LOCAL x
  FOR x := LEN(::members) TO 1 STEP -1
    ::members[x]:destroy()
  NEXT x

  ::actionInFocus   := ;
  ::actThread       := ;
  ::oTip            := ;
  ::lastTipped      := ;
  ::members         := ;
  ::progressMax     := ;
  ::progressCurr    := ;
  ::progressCount   := ;
  ::progressStart   := ;
  ::progressBorder  := ;
  ::progressText    := ;
  ::progressTime    := ;
  ::dialog          := ;
                       NIL
RETURN

**********************************************************************
* Calculates absolute position of last mouse event on the screen.
**********************************************************************
STATIC FUNCTION calcAbsolutePosition(aPos, oXbp)
LOCAL aAbsPos  := AClone(aPos)
LOCAL oParent  := oXbp
LOCAL oDesktop := AppDesktop()

  DO WHILE oParent <> oDesktop
    aAbsPos[1] += oParent:currentPos()[1]
    aAbsPos[2] += oParent:currentPos()[2]
    oParent := oParent:setParent()
  ENDDO
RETURN aAbsPos