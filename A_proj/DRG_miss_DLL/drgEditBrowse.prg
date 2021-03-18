//////////////////////////////////////////////////////////////////////
//
//  drgEditBrowse.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgEditBrowse class manages editable xbpBrowse object in a form.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#pragma Library( "XppUI2.LIB" )

***********************************************************************
* drgEditBrowse Class declaration
***********************************************************************
CLASS drgEditBrowse FROM drgBrowse
  EXPORTED:

  VAR     editArr
  VAR     exitState
  VAR     topOffset
  VAR     leftOffset
  VAR     oBord
  VAR     oVScroll
  VAR     lastCol
  VAR     lastRow
  VAR     lastRecNo
  VAR     stevc

  VAR     cbBrowseRowIn
  VAR     cbBrowseRowOut
  VAR     cbBrowseRowPre
  VAR     cbBrowseRowPost
  VAR     cbBrowseRowDelete
  VAR     cbBrowseRowAppend

*  METHOD  refreshDAC
  METHOD  keyboard
  METHOD  addDesc

  METHOD  getActiveArea
  METHOD  keyHandled
  METHOD  eventHandled
  METHOD  ok4Focus
  METHOD  setFocus
  METHOD  setInputFocus

  METHOD  postValidate
  METHOD  preValidateCell
  METHOD  postValidateCell
  METHOD  postValidateRow
  METHOD  preValidateRow
  METHOD  resetValidation
  METHOD  refresh

  METHOD  loadEditRow
  METHOD  saveEditRow
  METHOD  saveEdited
  METHOD  startEdit

  METHOD  create
  METHOD  destroy
  METHOD  resize
ENDCLASS

***********************************************************************
* drgEditBrowse Class declaration
***********************************************************************
METHOD drgEditBrowse:create(aDesc)
  ::drgBrowse:create(aDesc)
  ::oVScroll := ::oXbp:ChildList()[2]
*  drgDump(::oVScroll,'1')
  ::oVScroll := ::oXbp:ChildList()[1]
*  drgDump(::oVScroll,'2')
*  drgDump(::oXbp:ChildList())

* Set callbacks to this object
  ::oXbp:keyboard      := NIL //{ |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
  ::oXbp:setInputFocus := { |mp1, mp2, obj| ::setInputFocus( mp1, mp2, obj ) }
*  ::oXbp:navigate      := { |mp1, mp2, obj| ::navigate( mp1, mp2, obj ) }

* Default edit browser callbacks
  ::cbBrowseRowIn     := ::drgDialog:getMethod(,'browseRowIn')
  ::cbBrowseRowOut    := ::drgDialog:getMethod(,'browseRowOut')
  ::cbBrowseRowPre    := ::drgDialog:getMethod(,'browseRowPre')
  ::cbBrowseRowPost   := ::drgDialog:getMethod(,'browseRowPost')
  ::cbBrowseRowDelete := ::drgDialog:getMethod(,'browseRowDelete')
  ::cbBrowseRowAppend := ::drgDialog:getMethod(,'browseRowAppend')

* Register self to controller for traping events
  ::drgDialog:dialogCtrl:register(self)
  ::drgDialog:dialogCtrl:registerBrowser(self)

* Description array's size equals to size of columns in QBrowse
  ::editArr     := ARRAY(::oXbp:colCount, 2)
  ::lastCol     := 0
  ::lastRow     := 0
  ::stevc       := 0
  ::topOffset   := 1
  ::leftOffset  := 0
  ::isContainer := .T.

  DBGOTOP()
* Initial load
  ::lastRecNo := 0  // RECNO()
RETURN

***********************************************************************
* Sets description for editable browser column.
*
* \b< Parameters: >b\
* \b< aDesc > b\    : object : of form line description
***********************************************************************
METHOD drgEditBrowse:addDesc(aDesc)
LOCAL oDrg, oBord, oColumn, name
  ::lastCol := aDesc:fPos[1]
  oColumn   := ::oXbp:getColumn(::lastCol)             // column object
* Create border for docking xbp
  oBord      := xbpStatic():new(oColumn:dataArea,,{1,1}, {1, drgINI:fontH},,.F.)
  oBord:type := XBPSTATIC_TYPE_BGNDRECT
  oBord:create()
* Set border to edit array so edit object will know its border upon creation
  ::editArr[::lastCol, 1] := oBord

* Set fPos to 0, so object will be painted correctly
  aDesc:fPos := {0,0}
  name := '{ |a| ' + 'drg' + aDesc:type + '():new(a) }'
  oDrg := EVAL(&name, self)
  oDrg:create(aDesc)
*  oDrg:oXbp:hide()
  ::editArr[::lastCol, 2] := oDrg
RETURN

***************************************************************************
* Keyboard callback implementation
***************************************************************************
METHOD drgEditBrowse:keyBoard(nKey, mp2, oXbp)
RETURN .T.

***********************************************************************
* drgObject will be calling this method upon creation. Method returns border \
* object where it will be positioned.
*
* \b< Returns: >b\  : xbpDrawingArea :  currently active drawing area
***********************************************************************
METHOD drgEditBrowse:getActiveArea()
RETURN ::editArr[::lastCol, 1]

*************************************************************************
* Last object posted exiting event. Position to another object.
*************************************************************************
METHOD drgEditBrowse:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL column, aRect, aPos, aSize, x, nRecNO

*
* Last edited object has exited. Locate next object for edit
************************************************************
  IF nEvent = xbeBRW_Navigate
*    WHILE .T.
* Save last edited object to file and hide last edited.
* At the begining lastCol = 0. Avoid save.
      IF ::lastCol != 0 .AND. ::editArr[::lastCol, 1] != NIL
        ::saveEdited()
        ::refresh(.T.)               // also refreshes file POS
      ENDIF
* Record reposition
*      drgDump(mp1,'mp1')
      IF mp1 <= XBPBRW_Navigate_Skip .OR. mp1 = XBPBRW_Navigate_GoPos
        nRecNO := EVAL(::oXbp:phyPosBlock )     //  (::dbArea)->( RECNO() )
        IF ::postValidateRow()
          ::saveEditRow()
          DO CASE
          CASE mp1 = XBPBRW_Navigate_NextLine
            ::oXbp:down()
          CASE mp1 = XBPBRW_Navigate_PrevLine
            ::oXbp:up()
            IF mp2 != NIL                     // SH_TAB and line back is requested
              mp1 := mp2
            ENDIF
          CASE mp1 = XBPBRW_Navigate_NextPage
            ::oXbp:pageDown()
          CASE mp1 = XBPBRW_Navigate_PrevPage
            ::oXbp:pageUp()
          CASE mp1 = XBPBRW_Navigate_GoTop
            ::oXbp:goTop()
          CASE mp1 = XBPBRW_Navigate_GoBottom
            ::oXbp:goBottom()
          CASE mp1 = XBPBRW_Navigate_GoPos
            (::dbArea)->( DBGOTO(nRecNo) )
            ::refresh(.T.)
*            drgDump(mp1,'XBPBRW_Navigate_GoPos')
          ENDCASE

          ::refresh(.T.)             // also refreshes file POS
          ::loadEditRow()
        ELSE
          ::refresh(.T.)             // also refreshes file POS
        ENDIF
* Column repositions
      ELSE
        DO CASE
        CASE mp1 = XBPBRW_Navigate_NextCol
          IF ::oXbp:colCount > ::oXbp:colPos        // Not in last column
            ::oXbp:right()
          ELSE
*            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_FirstCol,, ::oXbp)
            ::oXbp:firstCol()
            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_NextLine,, ::oXbp)
            RETURN .T.
          ENDIF
*
        CASE mp1 = XBPBRW_Navigate_PrevCol
          IF ::oXbp:colPos > 1                  // Not in first column
            ::oXbp:left()
          ELSE
*            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_LastCol,, ::oXbp)
            ::oXbp:lastCol()
            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_PrevLine, XBPBRW_Navigate_PrevCol, ::oXbp)
            RETURN .T.
          ENDIF
*
        CASE mp1 = XBPBRW_Navigate_FirstCol
          ::oXbp:firstCol()
          WHILE ::editArr[::oXbp:colPos, 1] = NIL
            ::oXbp:right()
          ENDDO
*
        CASE mp1 = XBPBRW_Navigate_LastCol
          ::oXbp:lastCol()
          WHILE ::editArr[::oXbp:colPos, 1] = NIL
            ::oXbp:left()
          ENDDO
*
        CASE mp1 = XBPBRW_Navigate_SkipCols
          WHILE mp2 != 0
            IF mp2 > 0
              ::oXbp:right()
              mp2--
            ELSE
              ::oXbp:left()
              mp2++
            ENDIF
          ENDDO

        ENDCASE
      ENDIF
*
      ::oXbp:refreshCurrent()                   // It never hurts doing it again
*      ::lastRecNo := (::dbArea)->( RECNO() )
      ::lastRecNo := EVAL(::oXbp:phyPosBlock )
      ::lastCol   := ::oXbp:colPos
      ::lastRow   := ::oXbp:rowPos
* If is editable column, display objects, prevalidate and if OK set focus
      IF ::editArr[::lastCol, 1] != NIL
        IF ::preValidateCell()
          PostAppEvent(drgEVENT_MSG,,, ::oXbp)                // clear msgLine

          column := ::oXbp:getColumn(::lastCol)               // column object
          aRect := column:dataArea:cellRect( ::oXbp:rowPos )  // presentation space
          aPos  := { aRect[1], aRect[2] }                     // position
          aSize := { aRect[3]-aRect[1], aRect[4]-aRect[2] }   // and size of object

          ::editArr[::lastCol, 1]:setPos ( aPos  )            // set position
          ::editArr[::lastCol, 1]:setSize( aSize )            // and size
          IF drgArrayDif(aSize,::editArr[::lastCol, 2]:oXbp:currentSize())
            ::editArr[::lastCol, 2]:oXbp:setSize( aSize )     // size also xbpObject
          ENDIF
*
**          ::editArr[::lastCol, 1]:show()
**          ::editArr[::lastCol, 2]:oXbp:show()
**          SetAppFocus(::editArr[::lastCol, 2]:oXbp)
*         EXIT
* Position to next editable field
        ELSE
          IF mp1 = XBPBRW_Navigate_PrevCol
            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_PrevCol,, ::oXbp)
          ELSE
            PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_NextCol,, ::oXbp)
          ENDIF
        ENDIF
* Just go to next column if column is not editable
      ELSE
*        drgDump(::lastCol,'::lastCol')
        IF mp1 = XBPBRW_Navigate_PrevCol
          PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_PrevCol,, ::oXbp)
        ELSE
          PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_NextCol,, ::oXbp)
        ENDIF
      ENDIF
*    ENDDO
* Return from drgEVENT_COBJEXIT
    RETURN .T.
* Scroll events in xBase are still buggy.
  ELSEIF nEvent = xbeSB_Scroll
    IF mp1[2] = XBPSB_ENDTRACK .AND. oXbp = ::oVScroll
*    drgDump(mp1[1],'mp1[1]')

      EVAL(::oXbp:goPosBlock, mp1[1] )
      PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_GoPos,, ::oXbp)
      RETURN .T.
    ENDIF
  ENDIF

RETURN .F.

*************************************************************************
* Object asking if it can get focus. It must get false in return otherwise \
* object would be calling its preValidation and posibly post OBJECTEXIT event \
* which would be processed by form and not by editBrowser object. Prevalidation \
* will be done in eventHandled method above.
*************************************************************************
METHOD drgEditBrowse:ok4Focus()
RETURN .F.

*************************************************************************
* Refresh browser display. If dbf index order is 0 than only current record is refreshed \
* otherwise refreshAll is invoked.
*
* \b[ all ]b\  : boolean : If refresh all is requested. Default value is false.
*************************************************************************
METHOD drgEditBrowse:refresh(lAll)
  DEFAULT lAll TO .F.

  IF lAll .OR. (::dbArea)->( INDEXORD() ) > 0
*    ::oXbp:refreshCurrent()
    ::oXbp:refreshAll()
  ELSE
    ::oXbp:refreshCurrent()
  ENDIF
RETURN .F.

*************************************************************************
* Has key been handled by this forms controller. Container controller should ;
* always return false, otherwise object will post OBJECT_EXIT event which ;
* will be processed by form and would result in invalid positioning of next ;
* drgObject on a form.
*************************************************************************
METHOD drgEditBrowse:keyHandled(nKey)
LOCAL nEvent
  DO CASE
  CASE nKey == xbeK_TAB
    nEvent := XBPBRW_Navigate_NextCol

  CASE nKey == xbeK_SH_TAB
    nEvent := XBPBRW_Navigate_PrevCol

  CASE nKey == xbeK_ENTER
    nEvent := XBPBRW_Navigate_NextCol

  CASE nKey == xbeK_DOWN
    nEvent := XBPBRW_Navigate_NextLine

  CASE nKey == xbeK_UP
    nEvent := XBPBRW_Navigate_PrevLine

  CASE nKey == xbeK_CTRL_HOME
    nEvent := XBPBRW_Navigate_FirstCol

  CASE nKey == xbeK_CTRL_END
    nEvent := XBPBRW_Navigate_LastCol

  CASE nKey == xbeK_PGUP
    nEvent := XBPBRW_Navigate_PrevPage

  CASE nKey == xbeK_PGDN
    nEvent := XBPBRW_Navigate_NextPage

  CASE nKey == xbeK_CTRL_PGUP
    nEvent := XBPBRW_Navigate_GoTop

  CASE nKey == xbeK_CTRL_PGDN
    nEvent := XBPBRW_Navigate_GoBottom

* other keys are not of our interest
  OTHERWISE
    RETURN .F.
  ENDCASE

* IF postvalidation is OK, drgObject will exit. Post event to self
  (::dbArea)->( DBGOTO(::lastRecNO) )
*  EVAL(::oXbp:goPosBlock, ::lastRecNO )
  IF ::postValidateCell(.F.)
*    _clearEventLoop()
    PostAppEvent(xbeBRW_Navigate,nEvent,, ::oXbp)
  ENDIF
RETURN .F.

***************************************************************************
* Called by formController when drgObject can receive focus
***************************************************************************
METHOD drgEditBrowse:setFocus(mp1, mp2, oXbp)
  IF !::preValidate()
*    PostAppEvent(drgEVENT_OBJEXIT,,, ::oXbp)
    PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_NextCol,, ::oXbp)
  ELSE
* Set cursor to last edit position
    DBSelectArea(::dbArea)
    ::oXbp:refreshCurrent()                        // refresh so recno is correct

    IF ::lastRecNO != EVAL(::oXbp:phyPosBlock )
      ::loadEditRow()
    ENDIF
*    ::exitState := GE_NOEXIT
    PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_SkipCols, 0, ::oXbp)
  ENDIF
*  ::lastCol := 0
* This will terminate program
  IF ::stevc++ > 10
*    drgDUmp(::asasa)
  ENDIF
RETURN self

***************************************************************************
* Implementation of setInputFocus callback.
***************************************************************************
METHOD drgEditBrowse:setInputFocus(mp1, mp2, oXbp)
LOCAL tmpRec
* Mouse clicks on browser
  IF ::parent:oLastDrg = self
* First postvalidate last object edited on the screen
    (::dbArea)->( DBGOTO(::lastRecNO) )
    IF !::postValidateCell(.F.)
* Browser colPos must be set back to where it was
      IF ::oXbp:colPos > ::lastCol
        WHILE ::oXbp:colPos > ::lastCol
          ::oXbp:left()
        ENDDO
      ELSEIF ::oXbp:colPos < ::lastCol
        WHILE ::oXbp:colPos < ::lastCol
          ::oXbp:right()
        ENDDO
      ENDIF
* Browser rowPos must be set back to where it was
      IF ::oXbp:rowPos > ::lastRow
        WHILE ::oXbp:rowPos > ::lastRow
          ::oXbp:up()
          ::oXbp:refreshCurrent()             // must be done
        ENDDO
      ELSEIF ::oXbp:rowPos < ::lastRow
        WHILE ::oXbp:rowPos < ::lastRow
          ::oXbp:down()
          ::oXbp:refreshCurrent()             // must be done
        ENDDO
      ENDIF
      ::oXbp:refreshAll()
* Won't save to file yet
      (::dbArea)->( DBGOTO(::lastRecNO) )
*      ::lastCol   := ::oXbp:colPos
*      _clearEventLoop()
      PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_SkipCols, 0, ::oXbp)
      RETURN
    ENDIF
*
    ::oXbp:refreshCurrent()                        // refresh so recno is correct
    tmpRec := EVAL(::oXbp:phyPosBlock )            // save current position
*
    IF ::lastRecNO != tmpRec                       // record pos has changed
      (::dbArea)->( DBGOTO(::lastRecNO) )
      ::saveEdited()
*      ::oXbp:getColumn(::lastCol):drawRow(::lastRow)
      ::oXbp:refreshCurrent()                     // refresh so display is correct
      IF ::postValidateRow()                       // IF postvalid OK
        ::saveEditRow()                            // SAVE
        (::dbArea)->( DBGOTO(tmpRec) )             // return to previous position
        ::loadEditRow()                            // LOAD new row values
        PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_SkipCols, 0, ::oXbp)
      ENDIF
    ELSE
      ::saveEdited()
      PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_SkipCols, 0, ::oXbp)
    ENDIF
*
* Focus gained from other drgObject
* Ask form controller for focus
*
  ELSEIF ::parent:ok4Focus(self, oXbp)
    ::setFocus(mp1, mp2, oXbp)
  ENDIF
RETURN

****************************************************************************
* Postvalidation method for editBrowser. This one is called by form.
****************************************************************************
METHOD drgEditBrowse:postValidate(lEndCheck)
LOCAL ret := .T.
  DEFAULT lEndCheck TO .F.
* End check. On form closing all objects must be postvalidated.
  IF lEndCheck .AND. ::postValidOK != NIL
    RETURN ::postValidOK
  ENDIF
* PostValidate row
  ret := ret .AND. ::postValidateRow()
* Call browser postvalidation
  IF ret .AND. ::postBlock != NIL
    ret := EVAL(::postBlock, self)
  ENDIF
* save row
  IF ret
    ::saveEditRow()
  ELSE
    ::drgDialog:oForm:checkTabPage(self)
  ENDIF
  ::postValidOK := ret
RETURN ret

**************************************************************************
* PreValidate current cell. This is done prior coursor entering the cell.
**************************************************************************
METHOD drgEditBrowse:preValidateCell()
RETURN ::editArr[::lastCol, 2]:preValidate()

**************************************************************************
* PostValidate current cell. This is done when cursor must move to next cell.
**************************************************************************
METHOD drgEditBrowse:postValidateCell(endCheck)
LOCAL lRet
  lRet := IIF( ::editArr[::lastCol, 1] = NIL, .T., ;
               ::editArr[::lastCol, 2]:postValidate(endCheck) )
RETURN lRet

**************************************************************************
* PreValidate if coursor is to be stoped in this row
**************************************************************************
METHOD drgEditBrowse:preValidateRow()
RETURN ::drgDialog:dialogCtrl:browseRowPre(self)

**************************************************************************
* Postvalidate all editable elements of row
**************************************************************************
METHOD drgEditBrowse:postValidateRow()
LOCAL ret := .T., x
* Postvalidate every editable column
  (::dbArea)->( DBGOTO(::lastRecNO) )
  FOR x := 1 TO LEN(::editArr)
    IF ret .AND. ::editArr[x,1] != NIL
      ret := ::editArr[x,2]:postValidate(.T.)
    ENDIF
  NEXT
* Check user defined postValidation
  ret := ret .AND. ::drgDialog:dialogCtrl:browseRowPost(self)
  IF ret; _clearEventLoop(); ENDIF
RETURN ret

**************************************************************************
* Reset validation
**************************************************************************
METHOD drgEditBrowse:resetValidation()
  ::postValidOK := NIL
RETURN

**************************************************************************
* Save cell value to file. Also hides editing object
**************************************************************************
METHOD drgEditBrowse:saveEdited()
  IF ::editArr[::lastCol, 1] = NIL
    RETURN
  ENDIF
*
  IF ::editArr[::lastCol, 2]:oVar:changed()
    (::dbArea)->( DBGOTO(::lastRecNO) )
    IF (::dbArea)->( drgLockOK() )
      ::editArr[::lastCol, 2]:oVar:save()
      (::dbArea)->( DBUNLOCK() )
      (::dbArea)->( DBCOMMIT() )
    ENDIF
  ENDIF
  ::editArr[::lastCol, 2]:oXbp:hide()
  ::editArr[::lastCol, 1]:hide()
RETURN

**************************************************************************
* Save edited row
**************************************************************************
METHOD drgEditBrowse:saveEditRow()
  ::drgDialog:dialogCtrl:browseRowOut(self)
RETURN .T.

**************************************************************************
* Load one row from file
**************************************************************************
METHOD drgEditBrowse:loadEditRow()
LOCAL ret := .T., x
*  IF lockOK()
* CALL to RowIn callBack
    ::drgDialog:dialogCtrl:browseRowIn(self)

    FOR x := 1 TO LEN(::editArr)
      IF ::editArr[x,1] != NIL
        ::editArr[x,2]:oVar:refresh()
      ENDIF
    NEXT
*    ::lastRecNO := (::dbArea)->( RECNO() )
    ::lastRecNo := EVAL(::oXbp:phyPosBlock )

*    DBUNLOCK()
*  ENDIF
RETURN ret

***************************************************************************
*
***************************************************************************
METHOD drgEditBrowse:startEdit(lfirstCol)
DEFAULT lFirstCol TO .F.
  IF lFirstCol
*    ::oXbp:firstCol()
*    ::oXbp:refreshAll()                         // also refreshes file POS
*    ::lastCol   := 0                            // will select first editable field
*    ::exitState := GE_NOEXIT                    // no additional moveing
    PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_FirstCol,, ::oXbp)   // will force coursor move
  ELSE
*    ::oXbp:refreshAll()                         // also refreshes file POS
*    ::exitState := GE_NOEXIT                    // no additional moveing
    PostAppEvent(xbeBRW_Navigate, XBPBRW_Navigate_SkipCols,0, ::oXbp)   // will force coursor move
  ENDIF
RETURN

***************************************************************************
* Method is called on dialog window resize event.
***************************************************************************
METHOD drgEditBrowse:resize(aOld, aNew)
LOCAL nX, nY, column
LOCAL aRect, aPos, aSize
  ::drgBrowse:resize(aOld, aNew)
  IF ::lastCol != 0 .AND. ::editArr[::lastCol, 1] != NIL
    column := ::oXbp:getColumn(::lastCol)               // column object
    aRect := column:dataArea:cellRect( ::oXbp:rowPos )  // presentation space
    aPos  := { aRect[1], aRect[2] }                     // position
    aSize := { aRect[3]-aRect[1], aRect[4]-aRect[2] }   // and size of object

    ::editArr[::lastCol, 1]:setPos ( aPos  )            // set position
    ::editArr[::lastCol, 1]:setSize( aSize )            // and size
  ENDIF
RETURN self

**************************************************************************
* Clean UP
**************************************************************************
METHOD drgEditBrowse:destroy()
LOCAL x
  FOR x := 1 TO LEN(::editArr)
    IF ::editArr[x,1] != NIL
      ::editArr[x,2]:destroy()
      ::editArr[x,1]:destroy()
    ENDIF
  NEXT

  ::drgBrowse:destroy()

  ::editArr           := ;
  ::exitState         := ;
  ::topOffset         := ;
  ::leftOffset        := ;
  ::oBord             := ;
  ::lastCol           := ;
  ::lastRow           := ;
  ::lastRecNo         := ;
  ::stevc             := ;
  ::cbBrowseRowIn     := ;
  ::cbBrowseRowOut    := ;
  ::cbBrowseRowPre    := ;
  ::cbBrowseRowPost   := ;
  ::cbBrowseRowDelete := ;
  ::cbBrowseRowAppend := ;
                         NIL
RETURN

************************************************************************
************************************************************************
*
* editBrowse type definition class
*
************************************************************************
************************************************************************
CLASS _drgEditBrowse FROM _drgBrowse
  EXPORTED:

  INLINE METHOD init(line)
    ::_drgBrowse:init(line)
    ::type := 'editbrowse'
  RETURN self

ENDCLASS

