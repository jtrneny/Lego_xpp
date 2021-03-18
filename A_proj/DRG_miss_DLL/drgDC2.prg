////////////////////////////////////////////////////////////////////
//
//  drgDC2.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//  Implementation of controller with single browser. This type of controller uses \
//  browser to browse data and displays edit controls for editing data.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "Gra.ch"


CLASS drgDC2 FROM drgDialogController
EXPORTED:
  VAR     aData

  METHOD  eventHandled
  METHOD  chkDuplicates
  METHOD  loadData
  METHOD  saveData
*  METHOD  postLastField

HIDDEN
  VAR     RecNO, o_lastDrgVar
  var     oBitMap
  method  showCell
ENDCLASS

****************************************************************************
* Event handled method for this type of controller.
****************************************************************************
METHOD drgDC2:eventHandled(nEvent, mp1, mp2, oXbp)
  local  aColumns, ncolPos

  * on XbpTabPage click set focus to XbpBrowse for this page as INPUT
  IF nEvent = xbeP_SetInputFocus .and. ( oXbp:ClassName() = 'XbpTabPage' .or.  oXbp:ClassName() = 'XbpImageTabPage' )
    PostAppEvent(drgEVENT_REFRESH,,,::oBrowse:oxbp)
  ENDIF


  * Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

  If nEvent = xbeBRW_ItemMarked
    PostAppEvent(drgEVENT_REFRESH,,,::oBrowse:oxbp)

    if oXbp:ClassName() = 'XbpCellGroup'
      aColumns := ::oBrowse:oxbp:aColumns
      if( ncolPos := ascan( aColumns, oxbp:parent ) ) <> 0
        ::oBrowse:oxbp:colPos := ncolPos
      endif
    endif
  endif

  IF nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC
      * on ESC key in list TabPage 1 ... miss
      IF oXbp:ClassName() = 'XbpBrowse'
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)
      ELSE
      * on ESC key in edit TabPage 2 ... miss
*        IF ::drgDialog:dialogCtrl:isAppend
        IF !IsNull(::drgDialog:dialogCtrl:isAppend) .and. ::drgDialog:dialogCtrl:isAppend
          IF( IsNull( ::RecNO), nil, (::dbArea)->( dbGoTO(::RecNO )) )
        ENDIF
        ::members[1]:tabPageManager:members[1]:setFocus(1)
        ::browseRefresh()
        RETURN .T.
      ENDIF

    elseif mp1 = xbeK_RETURN
      if isObject( ::o_lastDrgVar)
        if oXbp = ::o_lastDrgVar:odrg:oxbp
          PostAppEvent(drgEVENT_SAVE,,,::oBrowse:oxbp)
        endif
      endif
    ENDIF
  ENDIF

* Non drg events are not of our interest
  IF nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  ENDIF

  DO CASE
* Handle action events
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

***********************************************************
* Refresh event on browse:itemMarked event
  CASE nEvent = drgEVENT_REFRESH
    IF ::saveData()
      ::browseRefresh()
      ::loadData()

      ::showCell()
// ne      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_NEXT
    IF ::saveData()
      IF ::browseInFocus()
        PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oBrowse:oXbp)
      ELSE
        (::dbArea)->( DBSKIP() )
        IF (::dbArea)->( EOF() )
          drgMsg(drgNLS:msg('Last record reached!'), DRG_MSG_WARNING, oXbp )
          (::dbArea)->( DBGOBOTTOM() )
        ENDIF
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_PREV
    IF ::saveData()
      IF ::browseInFocus()
        PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oBrowse:oXbp)
      ELSE
        (::dbArea)->( DBSKIP(-1) )
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_TOP
    IF ::saveData()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oBrowse:oXbp)
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_BOTTOM
    IF ::saveData()
      PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oBrowse:oXbp)
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EDIT
    IF ::saveData()
      IF ::browseInFocus()
        ::browseRefresh()
        PostAppEvent(drgEVENT_OBJEXIT,::oBrowse, ,oXbp)   // Jump to next field
      ENDIF
      ::loadData()
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND
    IF ::saveData(.T.)
      ::browseRefresh()
      ::RecNO := (::dbArea)->( RecNO())
// NE       (::dbArea)->( DBGOTO(-1) )
      ::loadData(.T.)

      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
      IF ::browseInFocus()
        PostAppEvent(drgEVENT_OBJEXIT,::oBrowse,,oXbp)   // Jump to next field
      ENDIF
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_APPEND2
    IF ::saveData()
      ::loadData(.T.,.T.)
      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
      IF ::browseInFocus()
        PostAppEvent(drgEVENT_OBJEXIT,,,oXbp)   // Jump to next field
      ENDIF
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly
      IF drgIsYESNO(drgNLS:msg('Delete record!;;Are you sure?') )
        (::dbArea)->( DBSKIP(-1) )
        ::RecNO := IF( (::dbArea)->( BOF()), 0, (::dbArea)->( RECNO()) )
        IF( (::dbArea)->( BOF()), (::dbArea)->( DBGOTOP()), (::dbArea)->( DBSKIP()) )
* Ask user function IF ok to delete
        IF ::evalBlock(::cbDelete, .T.)
          IF ::deleteRecord()
            ::evalBlock(::cbDelete, .F.)
          ENDIF
        ENDIF
* cursor reposition
        IF( ::RecNO = 0, (::dbArea)->( DBGOTOP()) ,;
                         (::dbArea)->( DBGOTO( ::RecNO)) )
      ENDIF
      ::browseRefresh()
      ::loadData()
    ENDIF
***********************************************************
  CASE nEvent = drgEVENT_SAVE
    IF ::saveData(.F.)
      ::browseRefresh()
      ::loadData()
      ::members[1]:tabPageManager:members[1]:setFocus(1) //MP
      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
    ENDIF

***********************************************************
  CASE nEvent = drgEVENT_EXIT
    IF ::saveData(.F.)
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ENDIF

  CASE nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

***********************************************************
  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
    IF !::drgDialog:dataManager:changed()
      IF ::browseInFocus()
        ::drgDialogFind()
        ::browseRefresh()
      ENDIF
    ELSE
      drgMsg(drgNLS:msg('Save changes before using find!'), DRG_MSG_WARNING, oXbp )
    ENDIF

* Post record append event if table is empty
***********************************************************
  CASE nEvent = drgEVENT_FORMDRAWN
    ::o_lastDrgVar := ::dataManager:vars:getLast()

    (::dbArea)->( DBGOTOP() )
    IF (::dbArea)->( EOF() )
**MP      drgMsgBox(drgNLS:msg('Table is empty. New record has been appended automatically.') )
      ::loadData(.T.)
      PostAppEvent(drgEVENT_OBJEXIT,,,oXbp)
      PostAppEvent(drgEVENT_MSG,,drgEVENT_APPEND, oXbp)
    ENDIF
    RETURN .F.              // must be processed somewhere else

* Not processed
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

***********************************************************************
* Saves last edited data from internal memManager structure to variables used \
* by dialog. If variables used are from file they are saved to file if variables \
* used are stored in memory they are stored to their memory locations.
*
* \b< Parameters: b\
* \b< chkIfChanged >b\ : Logical : If program should ask if last edited data is saved. \
* this usualy happeds when Exit dialog is selected and data is not saved yet.
***********************************************************************
METHOD drgDC2:saveData(lChkIfChanged)
  LOCAL tmpRECNO, ok

  DEFAULT lChkIfChanged TO .T.
  tmpRECNO := (::dbArea)->( RECNO() )

* Do nothing if readonly
  IF ::isReadOnly
    RETURN .T.
  ENDIF

* Data is not changed
  IF !::drgDialog:dataManager:changed()
    RETURN .T.
  ENDIF

* PostValidate all fields on form
  IF !::drgDialog:oForm:postValidateForm()
    RETURN .F.
  ENDIF

* ON exit OR record change without SAVE
  IF lChkIfChanged //.AND. !drgIsYESNO(drgNLS:msg('Data has been changed.;; Save changes?') )
    RETURN .T.
  ENDIF

* Check for duplicate keys
  IF !::chkDuplicates(::isAppend)
    RETURN .F.
  ENDIF

* Restore record pointer
  (::dbArea)->( DBGOTO(::lastRECNO) )

* Save changes
  IF ::evalBlock(::cbSave, .T., ::isAppend)            // Check IF OK to save
    IF ::isAppend
      (::dbArea) ->( dbAppend() )
**      ::appendBlankRecord()

    ELSE
* Check if data was changed during edit session
      IF drgArrayDif(::aData, (::dbArea)->( drgScatter() ) ) .AND. !drgIsYesNO( drgNLS:msg( ;
        'Another user has changed record while record was edited!;;' + ;
        'Save data anyway?;;' + ;
        'Select YES to save your data.;' + ;
        'Select NO to retain current data.'),,XBPMB_WARNING )
* Return IF No was selected
          RETURN .F.
      ENDIF
    ENDIF
*
    ok := if( ::isAppend, .t., (::dbArea)->( drgLockOK()) )

    if ok
**    IF (::dbArea)->( drgLockOK() )
      ::drgDialog:dataManager:save()
      ::evalBlock(::cbSave, .F., ::isAppend)           // Inform record has been saved
      mh_WRTzmena( Alias(::dbArea), ::isAppend)
      (::dbArea)->( DBUNLOCK() )
    ELSE
      RETURN .F.
    ENDIF
  ELSE
    RETURN .F.
  ENDIF

/* Restore record position.................MP
  IF tmpRECNO != ::lastRECNO
    (::dbArea)->( DBGOTO(tmpRECNO) )
  ENDIF
*/
RETURN .T.

***********************************************************************
* Loads data into memManager structure.
***********************************************************************
METHOD drgDC2:loadData(isAppend, withCopy)
LOCAL st, main_File := (::dbArea)->( ALIAS())

  DEFAULT isAppend  TO .F.
  DEFAULT withCopy  TO .F.
  ::isAppend := isAppend

*  ::drgDialog:dataManager:refresh()
  if( ::isAppend, ::drgDialog:dataManager:refreshandsetempty(main_File),;
                  ::drgDialog:dataManager:refresh() )
  ::lastRECNO := (::dbArea)->( RECNO() )
  ::aData := (::dbArea)->( drgScatter() )
  ::evalBlock(::cbLoad, isAppend)
* Mark all field as changed. This is because ::save saves only changed fields
  IF withCopy
    ::drgDialog:dataManager:markChanged( (::dbArea)->( ALIAS() ) + '->' )
  ENDIF
  ::drgDialog:oForm:resetValidation()
  PostAppEvent(drgEVENT_MSG,,drgEVENT_SAVE, ::drgDialog:dialog)

RETURN

***********************************************************************
* Checks for duplicate records.
***********************************************************************
METHOD drgDC2:chkDuplicates(isAppend)
/*
  ::drgDialog:pushArea()


  ::drgDialog:popArea()
*/
RETURN .T.


* {0,6}
* {0,6,210}
*
method drgDC2:showCell()
  local  nXD, nYD, nXH, nYH
  local  aPos, aSize, aRect
  //
  local  oColumn, oPS, nRBGColor, aRBG
  local  df      := ::drgDialog:oForm
  local  lastXbp := ::drgdialog:oform:olastdrg:oxbp
  local  oxbp         // tady to nìkdy padne na nos ==>  := ::oBrowse:oxbp
  *
  local  aColors := {6,0} //,210}
*  LOCAL  aColors := {GraMakeRGBColor({153,255,202}),;
*                            GraMakeRGBColor({255,202,153}),;
*                            GraMakeRGBColor({153,202,255}),;
*                            GRA_CLR_RED}
*   local aColors  := {GRA_CLR_GREEN, GRA_CLR_RED, GRA_CLR_YELLOW}
*   local aColors  := {GRA_CLR_GREEN, GRA_CLR_YELLOW, GRA_CLR_RED}
*   local aColors  := {GRA_CLR_YELLOW, GRA_CLR_RED } //, GRA_CLR_BLUE}



  if isObject(::oBrowse)
    oxbp    := ::oBrowse:oxbp

    if oxbp:className() = 'XbpBrowse'
      *
      ** EBrowse v INS / EDIT nerámeèkujeme
      if oxbp:cargo:className() = 'drgEBrowse'
        if oxbp:cargo:state <> 0
          return self
        endif
      endif

      if  isWorkVersion

        if oXbp:currentState() = 1 // forceStable()

          ocol := oxbp:getColumn(oxbp:colPos):dataArea
          type := ocol:parent:type
          xval := ocol:getCell(oxbp:rowPos)

          oPS       := ocol:lockPS()
          aRect     := ocol:cellRect(oXbp:rowPos)
          nRBGColor := oxbp:getColumn(oxbp:colPos):DataAreaLayout[XBPCOL_DA_HILITE_BGCLR]

          if isArray( aRBG := GraGetRGBIntensity(nRBGColor) )
            aRBG[2] += 40
            aRBG[3] += 40
          else
            aRBG := { 0, abs(nRBGColor) +40, abs(nRBGColor) +40 }
          endif

          aColors   := { GraMakeRGBColor(aRBG), nRBGColor }

          do case
          case type = XBPCOL_TYPE_ICON
          case type = XBPCOL_TYPE_BITMAP
            if( isNull( ::oBitmap), ::oBitmap := XbpBitmap():New():Create(), nil )
            ::oBitmap:load( ,xVal)
            ::oBitmap:TransparentClr := ::oBitmap:GetDefaultBGColor()

            GraEdge( oPS,{aRect[1] +1,aRect[2] +1}, {aRect[3] -1,aRect[4] -1}, GRA_EDGESTYLE_SUNKEN, GRA_EDGEELEMS_FILLEDRECT )
            GraGradient( oPS, {aRect[1] +2,aRect[2] +2}, {{aRect[3] -2,aRect[4] -2}}, aColors, GRA_GRADIENT_HORIZONTAL)
            ::oBitmap:draw( oPS, {aRect[1] +2,aRect[2] +2, aRect[3] -2,aRect[4] -2} )

          case type = XBPCOL_TYPE_SYSICON
          case type = XBPCOL_TYPE_TEXT
            GraEdge( oPS,{aRect[1] +1,aRect[2] +1}, {aRect[3] -1,aRect[4] -1}, GRA_EDGESTYLE_SUNKEN, GRA_EDGEELEMS_FILLEDRECT )
            GraGradient( oPS, {aRect[1] +2,aRect[2] +2}, {{aRect[3] -2,aRect[4] -2}}, aColors, GRA_GRADIENT_HORIZONTAL)

            xVal := if( valType(xval) = 'L', if( xval, 'Ano', 'Ne ' )     , ;
                    if( valType(xval) = 'D', dtos( xval )                 , ;
                    if( valType(xval) = 'N', str( xval), isNull(xval, '') ) ) )

            xval := if( valType(xVal) = 'M', left( memoTran(xVal, ' ', ' '), 20), xVal )

            nRBGColor  := oxbp:getColumn(oxbp:colPos):DataAreaLayout[XBPCOL_DA_HILITE_FGCLR]
            graSetColor( ops, nRBGColor, GRA_CLR_GREEN )
            GraCaptionStr( oPS, {aRect[1] +3,aRect[2] +1}, {aRect[3],aRect[4]}, xval )

          case type = XBPCOL_TYPE_MULTILINETEXT
            GraEdge( oPS,{aRect[1] +1,aRect[2] +1}, {aRect[3] -1,aRect[4] -1}, GRA_EDGESTYLE_SUNKEN, GRA_EDGEELEMS_FILLEDRECT )
            GraGradient( oPS, {aRect[1] +2,aRect[2] +2}, {{aRect[3] -2,aRect[4] -2}}, aColors, GRA_GRADIENT_HORIZONTAL)

            xVal := if( valType(xval) = 'L', if( xval, 'Ano', 'Ne ' )     , ;
                    if( valType(xval) = 'D', dtos( xval )                 , ;
                    if( valType(xval) = 'N', str( xval), isNull(xval, '') ) ) )

             xval := if( valType(xVal) = 'M', left( memoTran(xVal, ' ', ' '), 20), xVal )

            nRBGColor  := oxbp:getColumn(oxbp:colPos):DataAreaLayout[XBPCOL_DA_HILITE_FGCLR]
            graSetColor( ops, nRBGColor, GRA_CLR_GREEN )

            if CRLF $ xval
              GraCaptionStr( oPS, {aRect[1] +3,aRect[2] +1}, {aRect[3],aRect[4]}, xval, XBPALIGN_TOP +XBPALIGN_WORDBREAK )
            else
              GraCaptionStr( oPS, {aRect[1] +3,aRect[2] +1}, {aRect[3],aRect[4]}, xval )
            endif
          endcase

          ocol:unlockPS(oPS)
        endif

      else

        if oXbp:forceStable()
          oColumn := oXbp:getColumn(oxbp:colPos)

          oPS     := oColumn:dataArea:lockPS()
          aRect   := oColumn:dataArea:cellRect(oXbp:rowPos)

          aPos    := { aRect[1]         , aRect[2]          }
          aSize   := { aRect[3]-aRect[1], aRect[4]-aRect[2] }

          nXD     := aRect[1] +1                       ; nYD := aRect[4] -1
          nXH     := aRect[1] +(aRect[3] -aRect[1]) -2 ; nYH := aRect[2] +1

          graSetColor( ops, GRA_CLR_YELLOW, GRA_CLR_GREEN )
          graBox( oPS, {nXD  , nYD  }, {nXH  ,nYH  }, GRA_OUTLINE, 5, 5)
          graBox( oPS, {nXD  , nYD  }, {nXH-1,nYH-1}, GRA_OUTLINE, 5, 5)
          oColumn:dataArea:unlockPS(oPS)
       endif
     endif

    endif
  endif
return self

*
*===============================================================================
FUNCTION postLastField_2( oVar )
  LOCAL dc := oVar:drgDialog:dialogCtrl

  IF !dc:browseInFocus()
    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_S,, oVar:oDrg:oXbp )
  ENDIF
RETURN .T.