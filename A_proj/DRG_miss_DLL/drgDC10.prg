////////////////////////////////////////////////////////////////////
//
//  drgDC10.PRG
//
//  Copyright:
//       misDRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//    Implementation of dialog controller with browser and separated dialog window.
//    Secondary edit dialog window is created from primary browser dialog.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "Set.ch"
#include "Gra.ch"

#include "..\Asystem++\Asystem++.ch"

****************************************************************************
CLASS drgDC10 FROM drgDialogController
EXPORTED:
  VAR     isChild
  VAR     oaBrowse                     // aktivní BROw
  var     on_ItemMarked_autoRefresh
  VAR     dbAreaStack readonly

  METHOD  init
  METHOD  registerBrowser
  METHOD  browseInFocus
  METHOD  browseRefresh

  METHOD  eventHandled

  METHOD  chkDuplicates
  METHOD  editData
  method  refreshPostDel

  inline method sp_resetActiveArea( oDBrow, lrefreshAll, isActive )
    default lrefreshAll to .t., ;
            isActive    to .t.

    ::oaBrowse := oDBrow
    if( lrefreshAll, oDBrow:oxbp:refreshAll(), nil )

    ::resetActiveArea(oDBrow:oxbp, isActive)
    return self

HIDDEN:
  var     isStable, isDBrowse
  METHOD  onItemMarked, pushArea, popArea, showCell

  var     oBitmap

  inline method resetActiveArea(oxbp, isActive)
*    local  nclr := if( isActive, GRA_CLR_WHITE, GraMakeRGBColor( {233, 233, 230} ) )
    local  nclr := if( isActive, ACTIVE_BRO_COLOR, NOACTIVE_BRO_COLOR )
    local  ncol, ocol

    for ncol := 1 to oxbp:colCount step 1
      ocol := oxbp:getColumn(ncol):dataArea
      ocol:setColorBG( nclr )
    next
    return .t.

  return self
ENDCLASS


METHOD drgDC10:init(oParent)
  ::drgDialogController:init(oParent)
  ::oBrowse                   := {}
  ::isStable                  := .f.
  ::isDBrowse                 := .t.
  ::on_ItemMarked_autoRefresh := .t.
RETURN self

METHOD drgDC10:registerBrowser(oDrgBrowse)
  Aadd(::oBrowse, oDrgBrowse)

  ::oaBrowse := ::oBrowse[1]
  ::dbArea   := ::oaBrowse:dbArea
RETURN self

METHOD drgDC10:browseInFocus()
  Local  nIn

  IF( nIn := ASCAN( ::oBrowse, {|x| ::drgDialog:oForm:oLastDrg = x} )) <> 0
    ::oaBrowse := ::oBrowse[nIn]
  ENDIF
RETURN nIn <> 0

METHOD drgDc10:browseRefresh()
  IF ::oaBrowse != NIL
    ::oaBrowse:oXbp:refreshAll()
  ENDIF
RETURN

//
METHOD drgDC10:onItemMarked(oXbp,nPAGE)
  LOCAL  nBRo, nCOLn := 1
  local  aMembers, nLastDrgIx, nIn, nPos
  *
  local  oxbp_a, oColumn

  IF LEN( ::oBrowse) > 0
    IF IsNIL(nPAGE)
      BEGIN SEQUENCE
        FOR nBRo := 1 TO LEN(::oBrowse)
          FOR nCOLn := 1 TO ::oBrowse[nBRo]:oXbp:colCount
            IF ::oBrowse[nBRo]:oXbp:getColumn(nCOLn) = oXbp
      BREAK
            ENDIF
          NEXT
        NEXT
      END SEQUENCE
    ELSE
      aMembers   := ::drgDialog:oForm:aMembers
      nLastDrgIx := ::drgDialog:oForm:nLastDrgIx

      nin := ascan( aMembers, { |o| o:oxbp:className() = 'XbpBrowse' }, nLastDrgIx )

      * našel kam se má postavit
      if nin <> 0
        if (nPos := ascan( ::oBrowse, { |o| o = aMembers[nin] })) <> 0
          nBRo := nPos
          *
          ** bro není na pøepnuté záložce
          if ::obrowse[nbro]:oxbp:parent <> oxbp
            return .t.
          endif
        endif
      else
        return .t.
      endif
    ENDIF
    *
    ** pøepl si oblast ?
    if nBRo <= len(::oBrowse) .and. isObject(::oaBrowse)
      if ::oaBrowse <> ::oBrowse[nBRo]
        ::resetActiveArea(::oaBrowse:oxbp     , .F. ) // , isActive)
        ::resetActiveArea(::oBrowse[nBRo]:oxbp, .T. ) // , isActive)

        postAppEvent(drgEVENT_REFRESH,,,::oBrowse[nBRo]:oxbp)
      else
        if ::oabrowse:oXbp:colPos <> ncoln
          oxbp_a  := ::oabrowse:oXbp
          oColumn := oXbp_a:getColumn(oxbp_a:colPos):invalidateRect()
        endif

        ::oabrowse:oXbp:colPos := ncoln
        ::showCell()
      endif
    endif

    if nBRo <= len(::oBrowse)
      ::oaBrowse                             := ::oBrowse[nBRo]
      ::drgDialog:oForm:oLastDrg             := ::oaBrowse
      ::dataManager:drgDialog:lastXbpInFocus := ::oaBrowse:oXbp
      ::dbArea                               := ::oaBrowse:dbArea
      ::obrowse[nbro]:oxbp:colPos            := isNull(ncoln,1)

      IF( IsNIL(nPAGE), NIL, SetAppFocus(::oaBrowse:oXbp))
    endif
  ENDIF
RETURN


****************************************************************************
****************************************************************************
method drgDC10:eventHandled(nEvent, mp1, mp2, oXbp)

  *
  * on XbpTabPage click set focus to XbpBrowse for this page as INPUT
  IF nEvent = xbeP_SetInputFocus .and. ( oXbp:ClassName() = 'XbpTabPage' .or.  oXbp:ClassName() = 'XbpImageTabPage' )
    if empty(oxbp:cargo:subs)
      ::onItemMarked(oxbp, oxbp:cargo:tabNumber)
    endif
  ENDIF

  * Call default controller eventHandled method
  IF ::drgDialogController:eventHandled(nEvent, mp1, mp2, oXbp)
    RETURN .T.
  ENDIF

  If nEvent = xbeBRW_ItemMarked                   // 400  BROW/BROW/INFO etc.
    if( isArray(mp1) .or. isNull(mp1), ::showCell(), nil )

    if oXbp:ClassName() = 'XbpCellGroup'
      ::onItemMarked(oXbp:parent)
      ::isStable := .f.
    endif

    if ::on_ItemMarked_autoRefresh
      ::drgDialog:dataManager:refresh()
    endif

    if .not. IsNull( ::drgDialog:udcp)
      if(isMethod(::drgDialog:udcp,'post_drgEvent_Refresh'), ::drgDialog:udcp:post_drgEvent_Refresh(), nil)
    endif
  endif

  IF nEvent = xbeP_Keyboard
    IF(mp1 = xbeK_INS, nEvent := drgEVENT_APPEND, ;
      IF(mp1 =  xbeK_ENTER, nEvent := drgEVENT_EDIT, ;
        IF(mp1 == xbeK_CTRL_DEL, nEvent := drgEVENT_DELETE, ;
          IF(mp1 == xbeK_ESC, nEvent := drgEVENT_QUIT, NIL ))))

    if oxbp:className() = 'xbpComboBox' .and. oxbp:listBoxFocus()
      nEvent := xbeP_Keyboard
    endif
  endif

  * Non drg events are not of our interest
  if nEvent < drgEVENT_MIN .OR. nEvent > drgEVENT_MAX
    RETURN .F.
  else
    ::isChild := EMPTY(::drgDialog:formHeader:cargo)
  endif

  *
  ** Handle action events
  DO CASE
  CASE nEvent = drgEVENT_ACTION
    ::handleAction(nEvent, mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_PRINT
    ::drgDialogPrint()

  CASE nEvent = drgEVENT_FIND
   IF ::browseInFocus()
      ::drgDialogFind()
      ::browseRefresh()
    ENDIF

  CASE nEvent = drgEVENT_FORMDRAWN
    ::isChild := EMPTY(::drgDialog:formHeader:cargo)
    IF ::isChild
      IF ::drgDialog:cargo = drgEVENT_APPEND2
      ENDIF
      ::isAppend  := ::drgDialog:cargo != drgEVENT_EDIT
    ENDIF
    RETURN .F.                      // Must also be processed in drgDialog

  case nevent = drgEVENT_STABLEBLOCK
    if( isNil(::oaBrowse), ::oaBrowse := oxbp:cargo, nil)

    ::drgDialog:dataManager:refresh()

    for x := 1 to len(::obrowse) step 1
      if ::obrowse[x]:oxbp <> oxbp
        ::obrowse[x]:oxbp:refreshAll()
      endif
    next

    ::isStable := .t.
    ::showCell()

    if(isMethod(::drgDialog:udcp,'post_drgEvent_Refresh'), ::drgDialog:udcp:post_drgEvent_Refresh(), nil)
  return .t.

  CASE nEvent = drgEVENT_REFRESH
    ** refresh for NON-active BROWs
    if isObject(::oaBrowse)
       if .not. ::isStable
          ::drgDialog:dataManager:refresh()
          for x := 1 to len(::oBrowse) step 1
            if .not. ::obrowse[x]:oxbp:forceStable()
              ::obrowse[x]:oxbp:deHilite()
              ::obrowse[x]:oxbp:refreshAll()
            endif
          next
         ::isStable := .t.
         ::showCell()

         if .not. IsNull( ::drgDialog:udcp)
           if(isMethod(::drgDialog:udcp,'post_drgEvent_Refresh'), ::drgDialog:udcp:post_drgEvent_Refresh(), nil)
         endif
       endif
    endif
    return .t.

  CASE nEvent = drgEVENT_NEXT
    PostAppEvent(xbeP_Keyboard, xbeK_PGDN, , ::oaBrowse:oXbp)

  CASE nEvent = drgEVENT_PREV
    PostAppEvent(xbeP_Keyboard, xbeK_PGUP, , ::oaBrowse:oXbp)

  CASE nEvent = drgEVENT_TOP
    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGUP, , ::oaBrowse:oXbp)

  CASE nEvent = drgEVENT_BOTTOM
    PostAppEvent(xbeP_Keyboard, xbeK_CTRL_PGDN, , ::oaBrowse:oXbp)

  CASE nEvent = drgEVENT_EDIT
    IF !::isChild .AND. ::browseInFocus() .AND. !(::dbArea)->( EOF() )
      ::editData(nEvent)
    ELSE
      RETURN .F.                                                                // pohyb ENTER ve FRM
    ENDIF

  CASE nEvent = drgEVENT_APPEND .OR. nEvent = drgEVENT_APPEND2
    IF !::isChild .AND. ::browseInFocus() .AND. !::isReadOnly
      ::editData(nEvent)
    ELSE
      RETURN .F.
    ENDIF

  CASE nEvent = drgEVENT_DELETE
    IF !::isReadOnly .AND. ::browseInFocus() .and. (SetAppFocus():className() = 'XbpBrowse')
      ConfirmBox( ,'Zrušení záznamu v této èinnosti není povoleno !', ;
                   'Kontaktujte prosím distributora ...'            , ;
                    XBPMB_OK                                        , ;
                    XBPMB_INFORMATION+XBPMB_APPMODAL+XBPMB_MOVEABLE   )

    ENDIF


  CASE nEvent = drgEVENT_SAVE
    IF ::evalBlock(::cbSave, .T., ::isAppend)    // Check IF OK save
      ::browseRefresh()
      PostAppEvent(drgEVENT_MSG,,nEvent, oXbp)
    ENDIF

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    ::isChild := NIL

* Not processed
  OTHERWISE

    RETURN .F.
  ENDCASE
return .f.


* Creates new drgDialog. Dialog name is defined by cargo value in dialogs form header.
***********************************************************************
METHOD drgDC10:editData(nEvent)
  LOCAL  cform, cformi, odialog
  LOCAL  adialog, childDialog, cbSave
  *
  local  cfile      := ::oBrowse[1]:cFile
  local  keyData    := (cfile)->( sx_keyData())
  local  refreshAll := .f.

  * Don't want to have runtime error
  if Empty(::drgDialog:formHeader:cargo)
    drgMsg(drgNLS:msg('Edit dialog not defined!'),,::drgDialog)
    RETURN .F.
  endif

  * Pøi INSertu má pøedcházet specifická èinnost ( napø. výbìrový formuláø, ap.)
  cform  := ::drgDialog:formHeader:cargo
  cformi := drgINI:dir_RSRC + cform + 'I'
  if nEvent = drgEVENT_APPEND .and. FILE( cformi + '.frm')
    ::drgDialog:pushArea()
    DRGDIALOG FORM cForm + 'I' PARENT ::drgDialog MODAL DESTROY
    ::drgDialog:popArea()
    return self
  endif

  ::isAppend  := nEvent != drgEVENT_EDIT
  if(::isAppend, ::oBrowse[1]:oXbp:refreshCurrent():DeHilite(), NIL)
  ::pushArea()

  * Appending empty record. Goto RECNO 0 and fill with empty values
// JS  IF( nEvent = drgEVENT_APPEND, (::dbArea)->( DBGOTO(-1)), NIL )

**  if( nevent = drgEVENT_APPEND, (::dbArea)->(AdsGotoRecord(0)), nil )

  ::evalBlock(::cbLoad, ::isAppend)               // evaluate usr LOAD block

  * Create edit dialog
  adialog := drgDialog():new(::drgDialog:formHeader:cargo, ::drgDialog)
  adialog:cargo := nEvent                         // interchange parameter
  adialog:create(,,.T.)


  * Save or EXIT was selected and not readonly
  if !( ::isReadOnly .OR. aDialog:exitState = drgEVENT_QUIT)
     ::popArea(.T.)

    * na kartì je øešeno uložení dat *
    childDialog := aDialog:dialogCtrl
*    cbSave      := childDialog:cbSave
    cbSave      := if( isMemberVar( childDialog, 'cbSave'), childDialog:cbSave, nil )

    if IsBlock(cbSave) .and. childDialog:evalBlock(cbSave,.T., ::isAppend,self)

    elseif ::evalBlock(::cbSave, .T., ::isAppend,aDialog)
      IF( ::isAppend, ::appendBlankRecord(), NIL )

      * Save
      IF (::dbArea)->( drgLockOK() )
        aDialog:dataManager:save()                  // will save data to file
        ::evalBlock(::cbSave, .F., ::isAppend)      // evaluate usr SAVE block
        (::dbArea)->( DBUNLOCK() )
      ENDIF

      * Refresh browser
      (::dbArea)->( DBCOMMIT() )
    endif
  else
    ::popArea(.F.)
  endif

  (aDialog:destroy(), aDialog := NIL)

  if ::isAppend
    ::oBrowse[1]:oXbp:FirstCol()
    ::oBrowse[1]:oXbp:forceStable()
    ::oBrowse[1]:oXbp:refreshAll()
  else
    ::obrowse[1]:setFocus()

    do case
    case .not. empty( (cfile)->( ads_getAof()))
      if .not. (cfile)->( ads_isRecordinAOF( (cfile)->( recNo()) ))
        refreshAll := .t.
      endif
    endcase

    if ( keyData <> (cfile)->( sx_keyData()) ) .or. refreshAll
      ::obrowse[1]:oxbp:refreshAll()
    else
      ::obrowse[1]:oxbp:refreshCurrent()
    endif
    * refresh for NON-active BROWs
    AEval(::oBrowse, {|X| IF( X = ::oaBrowse .or. X:cFILE = ::oaBrowse:cFILE, NIL, X:oXbp:gotop():refreshAll() ) }, 2)
    PostAppEvent(xbeBRW_ItemMarked,,,::obrowse[1]:oxbp)
  endif

  ::drgDialog:dataManager:refresh()
RETURN SELF

*
**
METHOD drgDC10:pushArea()
  LOCAL  mfile := ::oBrowse[1]:cFile

  ::dbAreaStack := { mfile, (mfile) ->(OrdSetFocus()), (mfile) ->(RecNo()) }
RETURN


METHOD drgDC10:popArea(onSave)
  LOCAL mfile := ::dbAreaStack[1]

  DbSelectArea(mfile)
  (mfile) ->(AdsSetOrder(::dbAreaStack[2]))

  if( (mfile)->(eof()), (mfile) ->(DbGoTo(::dbAreaStack[3])), nil )
RETURN


* Checks for duplicate records.
***********************************************************************
METHOD drgDC10:chkDuplicates(isAppend)
/*
  ::drgDialog:pushArea()
  ::drgDialog:popArea()
*/
RETURN .T.


method drgDC10:refreshPostDel()

  * pøepnul se do child tabulky?, musím rátit master
  if ::oaBrowse <> ::oBrowse[1]
    ::oaBrowse                             := ::oBrowse[1]
    ::drgDialog:oForm:oLastDrg             := ::oaBrowse
    ::dataManager:drgDialog:lastXbpInFocus := ::oaBrowse:oXbp
    ::dbArea                               := ::oaBrowse:dbArea

    SetAppFocus(::oaBrowse:oXbp)
  endif

  ::dbArea  := ::oaBrowse:dbArea
  ::oBrowse[1]:oXbp:refreshAll()

  if (::dbArea)->(eof())
**  if ::oaBrowse:oxbp:rowPos = 1  .or. (::dbArea)->(eof())
    ::oaBrowse:oxbp:up():forceStable()
    ::oaBrowse:oxbp:refreshAll()
  endif

  PostAppevent(xbeBRW_ItemMarked,,,::oBrowse[1]:oxbp)
return


* {0,6}
* {0,6,210}
*
method drgDC10:showCell()
  local  odbrowse := ::drgDialog:odbrowse
  local  nXD, nYD, nXH, nYH
  local  aPos, aSize, aRect
  //
  local  oColumn, oPS, nRBGColor, aRBG
  local  df      := ::drgDialog:oForm
  local  lastXbp := ::drgdialog:oform:olastdrg:oxbp
  local  oxbp         // tady to nìkdy padne na nos ==>  := ::oaBrowse:oxbp
  *
  local  aColors := {6,0} //,210}
*  LOCAL  aColors := {GraMakeRGBColor({153,255,202}),;
*                            GraMakeRGBColor({255,202,153}),;
*                            GraMakeRGBColor({153,202,255}),;
*                            GRA_CLR_RED}
*   local aColors  := {GRA_CLR_GREEN, GRA_CLR_RED, GRA_CLR_YELLOW}
*   local aColors  := {GRA_CLR_GREEN, GRA_CLR_YELLOW, GRA_CLR_RED}
*   local aColors  := {GRA_CLR_YELLOW, GRA_CLR_RED } //, GRA_CLR_BLUE}



  if isObject(::oaBrowse)
    oxbp    := ::oaBrowse:oxbp

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