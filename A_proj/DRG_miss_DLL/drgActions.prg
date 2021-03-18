//////////////////////////////////////////////////////////////////////
//
//  drgActions.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Object is used for showing actions and icon bars which is the same \
//       from programing view.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Appevent.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "XbpPack1.ch"

#include "ActiveX.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


/*
* This function calculates the absolute position
* from a given position relative to an XbasePART
*/
STATIC FUNCTION calcAbsolutePosition(aPos,oXbp)
   LOCAL aAbsPos := AClone(aPos)
   LOCAL oParent := oXbp
   LOCAL oDesktop := AppDesktop()

   DO WHILE oParent <> oDesktop
      aAbsPos[1] += oParent:currentPos()[1]
      aAbsPos[2] += oParent:currentPos()[2]
      oParent := oParent:setParent()
   ENDDO
RETURN(aAbsPos)


CLASS drgActions
  EXPORTED:

  VAR     drgDialog
  VAR     oBord
  VAR     members
  VAR     lastPos
  VAR     topOffset
  VAR     aMenu             // actions menu
  VAR     is_TabToolBar, oToolBar
  *
  METHOD  init
  METHOD  create
  METHOD  addAction
  METHOD  getActiveArea
  METHOD  addAction2Menu
  METHOD  resize
  METHOD  destroy


  inline method ToolButtonClick(oButton)
    local  event    := oButton:cargo:event
    local  preValid := oButton:cargo:preValid
    local  oxbp     := oButton:ToolBar

    PostAppEvent(drgEVENT_ACTION, event, preValid, oXbp)
    PostAppEvent(drgEVENT_ACTION, self,, oXbp)
  return self
ENDCLASS

**********************************************************************
* Object initialization.
*
* \bParameters:b\
* \b< oDrgDialog >b\  : object of type drgDialog : drgDialog that created action bar.
*
* \bReturn:b\ : oDrgActions : self
**********************************************************************
METHOD drgActions:init(oDrgDialog, is_toolBar)
  ::drgDialog := oDrgDialog
  ::members       := {}
  ::topOffset     := -1
  ::is_TabToolBar := isNull( is_toolBar, .f.)
RETURN self

**********************************************************************
* Creates action bar.
*
* \bParameters:b\
* \b< oBord >b\  : object of type drawing area : drgDialog drawing area.
* \b< pos  >b\   : ARRAY(2) of numeric : Position of the action bar in coordinates
* \b< size >b\   : ARRAY(2) of numeric : Size of the action bar
*
* \bReturn:b\ : oDrgActions : self
**********************************************************************
METHOD drgActions:create(oBord, pos, size)
  local  hwnd

  if ::is_TabToolBar
    ::oBord       := XbpStatic():new( oBord, ,pos, size )
    ::oBord:create()

    ::oToolBar       :=  XbpToolBar():new( ::oBord,, {0,2}, size )
    ::oToolBar:CLSID :=  "MSComctlLib.Toolbar"

    ::oToolBar:create()

    ::oToolBar:allowCustomize   := .T.                   // .F.
//    ::oToolBar:appearance       := XBP_APPEARANCE_3D     // XBP_APPEARANCE_FLAT
//    ::oToolBar:borderStyle      := XBPFRAME_NONE         // XBPFRAME_RECT
//    ::oToolBar:style            := XBPTOOLBAR_STYLE_FLAT // XBPTOOLBAR_STYLE_STANDARD

    ::oToolBar:appearance       := XBP_APPEARANCE_FLAT
    ::oToolBar:borderStyle      := XBPFRAME_NONE
    ::oToolBar:style            := XBPTOOLBAR_STYLE_FLAT

    ::oToolBar:showToolTips     := .t.
    ::oToolBar:wrappable        := .T.
    ::oToolBar:imageWidth       := 16
    ::oToolBar:imageHeight      := 16

    ::oToolbar:ButtonClick := {|oButton| ::ToolButtonClick(oButton)}

  else
    ::oBord       := XbpStatic():new( oBord, ,pos, size )
    IF ::drgDialog:hasBorder
      ::oBord:type  := XBPSTATIC_TYPE_RAISEDBOX
    ENDIF
    ::oBord:create()
    ::lastPos := ::oBord:currentSize()[2]
  endif

RETURN self

**********************************************************************
METHOD drgActions:addAction(xPos, aSize, nType, nIcon1, nIcon2, cExtDll, cCaption, ;
                            cTipText, mEvent, lIsAction, cPre)
  LOCAL action
* Passed as object. It is on the action area

  default lisAction to .f.

  IF VALTYPE(xPos) = 'O'
    ::lastPos -= drgINI:fontH + 4
    xPos:pos  := {0, ::lastPos}
    xPos:size  := {12*drgINI:fontW, drgINI:fontH + 4}
*    isAction  := .F.
** 20.12.2012 odstranìno menu Akce     ::addAction2Menu(xPos:caption, xPos:Event, xPos:Pre)
  ENDIF

  IF VALTYPE(xPos) = 'O'
    action := drgPushButton():new(self)
    action:create(xPos, aSize, nType, nIcon1, nIcon2, cExtDll, cCaption, ;
                  cTipText, mEvent, lIsAction, cPre)
    AADD(::members, action)

  else

    if ::is_TabToolBar
      action := drgAction():new(self)
      action:create_TabToolBar(xPos, aSize, nType, nIcon1, nIcon2, cExtDll, cCaption, ;
                               cTipText, mEvent, lIsAction, cPre                      )
      AADD(::members, action)

    else
      action := drgAction():new(self)
      action:create(xPos, aSize, nType, nIcon1, nIcon2, cExtDll, cCaption, ;
                    cTipText, mEvent, lIsAction, cPre                      )
      AADD(::members, action)

    endif
  endif
RETURN


**********************************************************************
* Every drgObject asks its parent to return the drawingArea where it will be drawn. \
* If action is on IconBar or ActionBar this method will be called.
**********************************************************************
METHOD drgActions:getActiveArea()
RETURN ::oBord

**********************************************************************
* Adds action to menu bar if menubar is installed.
**********************************************************************
METHOD drgActions:addAction2Menu(cCaption, mEvent, cPre )
LOCAL oMenuBar, n
* Only if menu sistem is installed
  IF ::drgDialog:hasMenuArea  .and. mEvent <> 'separator'
    oMenuBar := ::drgDialog:dialog:menuBar()
* Install action menu on MenuBar
    IF cCaption = NIL
      IF ::aMenu != NIL
        oMenuBar:insItem(oMenuBar:numItems(), {::aMenu, NIL })
      ENDIF
    ELSE
* Create submenu if not yet created
      IF ::aMenu = NIL
        ::aMenu  := XbpMenu():new(oMenuBar)
        ::aMenu:title := drgNLS:msg('~Actions')
        ::aMenu:create()
      ENDIF
* Add new menu item to submenu
      ::aMenu:addItem( {drgNLS:msg(cCaption), ;
                     {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, mEvent, cPre, ::drgDialog:dialog) }} )
    ENDIF
  ENDIF

RETURN self

**********************************************************************
* Called when window resize is requested.
**********************************************************************
METHOD drgActions:resize(aOld, aNew)
  LOCAL nX, nY, aPos, lIsIconBar,x
  LOCAl newX, newY
  *
  local odrg

  nX := aNew[1] - aOld[1]
  nY := aNew[2] - aOld[2]
  aPos := ::oBord:currentPos()
  lIsIconBar := aPos[1] = 0
* New Border size
  newX := IIF(lIsIconBar, ::oBord:currentSize()[1] + nX, ::oBord:currentSize()[1] )
  newY := IIF(lIsIconBar, ::oBord:currentSize()[2], ::oBord:currentSize()[2] + nY )
  ::oBord:setSize( {newX,newY}, .F.)
* New border POS
  newX := IIF(lIsIconBar, ::oBord:currentPos()[1], ::oBord:currentPos()[1]+nX )
  newY := IIF(lIsIconBar, ::oBord:currentPos()[2]+nY, ::oBord:currentPos()[2] )
  ::oBord:setPos( {newX,newY}, .F.)
*
  IF !lIsIconBar
    FOR x := LEN(::members) TO 1 STEP -1
      newX := ::members[x]:oXbp:currentPos()[1]
      newY := ::members[x]:oXbp:currentPos()[2]+nY
      ::members[x]:oXbp:setPos( {newX,newY}, .F.)
    NEXT x

  else
    *
    ** musíme repozicovat období, pokud je na FRM
    odrg := atail( ::members )
    if isCharacter( odrg:event )
      if lower( odrg:event ) = 'uct_ucetsys_inlib'
        newX := odrg:oXbp:currentPos()[1] +nX
        newY := odrg:oXbp:currentPos()[2]
        odrg:oXbp:setPos( {newX,newY}, .F.)
      endif
    endif

  ENDIF
RETURN self

**********************************************************************
METHOD drgActions:destroy()
LOCAL x
  FOR x := LEN(::members) TO 1 STEP -1
    ::members[x]:destroy()
  NEXT x
  if( isObject( ::oBord), ::oBord:destroy(), nil )

  ::topOffset := ;
  ::lastPos   := ;
  ::members   := ;
  ::oBord     := ;
  ::drgDialog := ;
  ::aMenu     := ;
                  NIL
RETURN

**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
CLASS drgAction
  EXPORTED:

  VAR     parent
  VAR     oXbp
*  VAR     oForm
  VAR     oIcon
  VAR     oText
  VAR     icon1
  VAR     icon2
  VAR     icon3
  VAR     extDll
  VAR     caption
  VAR     tipText
  VAR     event
  VAR     type
  VAR     disabled
  VAR     frameState
  VAR     isAction
  VAR     preValid
  VAR     oldFrameState
  VAR     drgGet                                                                // miss

  METHOD  init
  METHOD  create
  method  create_TabToolBar
  METHOD  destroy
  METHOD  drawFrame
  METHOD  activate
  METHOD  disable
  METHOD  enable
  METHOD  preValidate
  *
  method  showToolTip
ENDCLASS

**********************************************************************
METHOD drgAction:init(parent)
  ::parent   := parent
  ::disabled := .F.
RETURN self

**********************************************************************
METHOD drgAction:create(pos, size, aType, icon1, icon2, extDll, caption, ;
                        tipText, event, isAction, preValid, drgGet)
LOCAL small, iconSize, fPos, fLen, oBord
LOCAL tOpt, iPos := NIL, tPos := NIL, aPos
  DEFAULT isAction TO .T.
  DEFAULT preValid TO '0'

  ::isAction := isAction
  oBord := ::parent:getActiveArea()

* Create separator line
  IF aType = 0
    ::oXbp          := XbpStatic():new( oBord, , pos, size)
    ::oXbp:type     := XBPSTATIC_TYPE_RAISEDBOX
    ::oXbp:create()
    RETURN self
  ENDIF

  IF VALTYPE(pos) = 'O'
    size := oBord:currentSize()
    fPos := ACLONE( pos:pos )
    IF pos:size[1] < 40
      aPos := {(fPos[1])*drgINI:fontW, ;
                size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset}
    ELSE
      aPos := ACLONE(fPos)
    ENDIF
* Length of the field
    size[1] := IIF(pos:size[1] < 40, pos:size[1]*drgINI:fontW, pos:size[1])
    size[2] := IIF(pos:size[1] < 40, pos:size[2]*drgINI:fontH, pos:size[2])

    aType   := pos:aType
    icon1   := pos:icon1
    icon2   := pos:icon2
    caption := pos:caption
    tipText := pos:tipText
    event   := pos:event
    preValid:= pos:pre
  ELSE
    aPos    := ACLONE(pos)
  ENDIF

  DEFAULT size TO {22,22}
  DEFAULT aType TO 1
  DEFAULT caption TO 'mis'

  ::icon1 := icon1
  ::icon2 := icon2
  DEFAULT ::icon2 TO ::icon1

  ::event    := event
  ::tipText  := drgNLS:msg( tipText )
  ::preValid := preValid
  ::drgGet   := drgGet                                                          // miss

* Funny. So much trouble how to make object without frame.
  * line separator
  if atype = 0 .or. atype = 5
    ::oXbp          := XbpStatic():new( oBord, , apos, asize)
    ::oXbp:type     := XBPSTATIC_TYPE_RAISEDBOX
    ::oXbp:create()

    if( atype = 5, ::oxbp:setSize({0,0}), nil )
    return self

  else
    ::oxbp := XbpImageButton():new( obord,, apos, size )
  endif


  do case
  case ( atype = 1 )
    oIcon:= XbpIcon():new():create()
    oIcon:load( NIL, icon1 )

    ::oXbp:caption       := ' '
    ::oxbp:image         := oIcon
    ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
    ::oxbp:ImageAlign    := XBPALIGN_HCENTER+XBPALIGN_TOP

    ::caption            := caption

  case ( atype = 3 )
    if .not. empty(::icon1)
       oIcon:= XbpIcon():new():create()
       oIcon:load( NIL, ::icon1 )

       ::oxbp:image      := oIcon
    endif

    ::oxbp:caption       := caption
    ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
    ::oXbp:TextAlign     := XBPALIGN_HCENTER+XBPALIGN_VCENTER

    ::caption            := caption
  endcase

  ::oxbp:activate    := {|| ::activate(.f.) }
  ::oxbp:create()

  ::disabled      := .F.
  ::frameState    := 1
  ::oldFrameState := 0

RETURN self


method drgAction:create_TabToolBar(pos, size, aType, icon1, icon2, extDll, caption, ;
                                   tipText, event, isAction, preValid, drgGet        )
  local   oicon1, oicon2, otb
  local   obord    := ::parent:getActiveArea()
  local   citemKey

  default preValid TO '0'

  ::icon1 := icon1
  ::icon2 := icon2
  DEFAULT ::icon2 TO ::icon1

  ::event    := event
  ::tipText  := drgNLS:msg( tipText )
  ::preValid := preValid

  do case
  case( aType = 0 )
    ::parent:oToolBar:addItem( ,,,,,XBPTOOLBAR_BUTTON_SEPARATOR)
    return self

  case( aType = 1 )

     do case
     case isNumber(event)     ;  citemKey := allTrim( str( event))
     case isCharacter(event)  ;  citemKey := event
     otherwise                ;  citemKey := ''
     endcase

//     drgDump( citemKey )


     if ::parent:oToolBar:numItems() = 1
       oIcon_1 := xbpIcon():new():create()

       oIcon_1:load( , icon1, 128, 128 )

       obitMap                := oIcon_1:getBitMap()
       obitmap:transparentClr := obitmap:getDefaultBGColor()

       ::oxbp := ::parent:oToolBar:addItem("", obitMap)
       ::oxbp:tooltipText := tipText

       * ikona pro BROREFRESH
       if icon1 = 460
         ::oxbp:visible := .f.

         oIcon_1:load( , icon1 )
         ::oxbp := ::parent:oToolBar:addItem("", oIcon_1,,,,, NIL )
         ::oxbp:tooltipText := tipText
       endif
     else
       oIcon_1 := xbpIcon():new():create()
       oIcon_1:load( , icon1 )

       ::oxbp := ::parent:oToolBar:addItem("", oIcon_1,,,,, NIL )
       ::oxbp:tooltipText := tipText
     endif

     ::oxbp:cargo := self

  case( aType = 3 )

   ::oxbp := XbpImageButton():new( obord,, pos, size )

   if .not. empty(icon1)
     oIcon:= XbpIcon():new():create()
     oIcon:load( NIL, icon1 )
     ::oxbp:image      := oIcon
   endif

    ::oxbp:caption       := caption
    ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
    ::oXbp:TextAlign     := XBPALIGN_HCENTER+XBPALIGN_VCENTER

    ::caption            := caption

    ::oxbp:activate    := {|| ::activate(.f.) }
    ::oxbp:create()
  endcase
return self

*
** tooltipText
method drgAction:showToolTip(mp1, mp2, oXbp, lastmp)
  LOCAL aAttr, oPS
  LOCAL aPoints
  LOCAL aSize := {0,0}, aPos
  LOCAL aAttrLine[ GRA_AL_COUNT ]
  LOCAL cargo, cText

  if .not. empty( oxbp:tooltipText)
    if isArray( oxbp:tooltipText )
      oxbp:toolTipText[2]:hide()
      oxbp:toolTipText[2]:destroy()
      oxbp:toolTipText := oxbp:toolTipText[1]

      return .t.
    endif

    aPos  := calcAbsolutePosition({0,0}, oXbp)
    aPos[1] += 20   // 6
    aPos[2] -= ( 18 )  // (33)

    * Static for holding tooltip
    oTip := XbpStatic():new()
    oTip:options := XBPSTATIC_TYPE_FGNDFRAME
    oTip:create(AppDesktop(),AppDesktop(), aPos, {0, 0})

    ctext := oxbp:tooltipText
    oPS := oTip:lockPS()
    aPoints := GraQueryTextBox( oPS, cText)
    oTip:unlockPS()

    aSize[1] := (aPoints[3,1] - aPoints[1,1]) + 8
    aSize[2] := (aPoints[1,2] - aPoints[2,2]) + 4

    oTip:setSize(aSize,.F.)
    oPS := oTip:lockPS()

* Background color
    aAttr := Array( GRA_AA_COUNT )
    aAttr [ GRA_AA_COLOR ] := XBPSYSCLR_INFOBACKGROUND
    GraSetAttrArea( oPS, aAttr )
    GraBox( oPS, { 1, 1}, { aSize[ 1] + 4, aSize[ 2] + 4}, GRA_FILL)

* Tooltip Frame
    aAttrLine[GRA_AL_COLOR] := GRA_CLR_DARKGRAY
    oPS:setAttrLine( aAttrLine )

    GraLine( oPS, {0,0}, {0,aSize[2]-1} )
    GraLine( oPS, NIL  , {aSize[1]-1,aSize[2]-1} )
    aAttrLine[GRA_AL_COLOR] := GRA_CLR_BLACK
    oPS:setAttrLine( aAttrLine )
    GraLine( oPS, NIL, {aSize[1]-1,0 } )
    GraLine( oPS, NIL, {0,0} )

    GraEdge( oPS, aPos, asize, GRA_EDGESTYLE_SUNKEN, GRA_EDGEELEMS_FILLEDRECT )

* Write text
    aAttr := Array( GRA_AA_COUNT )
    aAttr [ GRA_AA_COLOR ] := GRA_CLR_BLACK
    GraSetAttrArea( oPS, aAttr )

    GraStringAt( oPS, {4,4}, cText)
    oTip:unLockPS( oPS)

    oxbp:tooltipText := { oxbp:tooltipText, oTip }
  endif
return .t.



**********************************************************************
* Draw a frame around action area. Style of frame is determined by \
* ::frameState variable.
**********************************************************************
METHOD drgAction:drawFrame()
LOCAL oPS, aSize, oBMP
LOCAL aALine[ GRA_AL_COUNT ], aOldALine
LOCAL aAArea[GRA_AA_COUNT], aOldAArea
LOCAL clr := {}, fclr

* If icon is disabled frame state is unchanged
  IF ::disabled; ::frameState := 1; ENDIF

* Old fashion way
  IF ::isAction .OR. drgINI:iconBarType = 1

  IF ::isAction
    AADD(clr, {GRA_CLR_DARKGRAY, GRA_CLR_WHITE } )
  ELSE
    AADD(clr, {XBPSYSCLR_3DFACE, XBPSYSCLR_3DFACE } )
  ENDIF
  AADD(clr, {GRA_CLR_DARKGRAY, GRA_CLR_WHITE } )
  AADD(clr, {GRA_CLR_WHITE, GRA_CLR_DARKGRAY } )

* request microPS and set attributes
  oPS  := ::oXbp:lockPS()
  IF !EMPTY(oPS)
*    oBMP := xbpBitmap():new():create(oPS)
*    oBMP:load(::extDll, ::icon1)
*    oBMP:draw(oPS, {3, 3} )

    // Size of border object
    aSize := ::oXbp:currentSize()
    aSize[1] -= 1; aSize[2] -= 1
* BOTTOM AND RIGHT
    aALine[ GRA_AL_COLOR ] := clr[::frameState, 1]
    aOldALine := oPS:setAttrLine( aALine )

    GraLine( oPS, {0, 0}, {aSize[1], 0} )                 // --
    GraLine( oPS, {aSize[1], 0}, {aSize[1], aSize[2]} )   //  |
*
    IF ::isAction
      aALine[ GRA_AL_COLOR ] := IIF(::frameState = 2,  GRA_CLR_BLACK, XBPSYSCLR_3DFACE)
      oPS:setAttrLine( aALine )
      GraLine( oPS, { 1, 1}, { aSize[1]-1, 1} )
      GraLine( oPS, { aSize[1]-1, 1}, { aSize[1]-1, aSize[2]-1} )
    ENDIF

* TOP and LEFT
    aALine[ GRA_AL_COLOR ] := clr[::frameState, 2]
    oPS:setAttrLine( aALine )
    GraLine( oPS, {aSize[1], aSize[2]}, {0, aSize[2]} )     // --
    GraLine( oPS, {0, aSize[2]}, {0, 0} )                   // |
*
    IF ::isAction
      aALine[ GRA_AL_COLOR ] := IIF(::frameState = 2,  XBPSYSCLR_INFOBACKGROUND, XBPSYSCLR_3DFACE)
      oPS:setAttrLine( aALine )
      GraLine( oPS, { 1, 1}, { 1, aSize[2]-1} )
      GraLine( oPS, { 1, aSize[2]-1}, { aSize[1]-1, aSize[2]-1} )
    ENDIF

/*
    IF ::isAction
      fclr := IIF(::frameState = 1, GRA_CLR_BLACK, XBPSYSCLR_3DFACE)

      aSize[1] -= 2; aSize[2] -= 2
      aALine[ GRA_AL_COLOR ] := fclr
      aALine[ GRA_AL_TYPE  ] := GRA_LINETYPE_DOT  // Until DOT is set right

      oPS:setAttrLine( aALine )
*      GraBox( oPS, { 2, 2}, { aSize[1], aSize[2]},,5,5) // GRA_OUTLINE) // , 20, 20)
    ENDIF
*/
    oPS:setAttrLine( aOldALine )
    ::oXbp:unlockPS( oPS )

* Also set proper ICON
      IF ::icon1 != ::icon2
        ::oIcon:setCaption( IIF(::frameState = 1, ::icon2, ::icon1) )
      ENDIF
    ENDIF
  ELSE
    clr := { XBPSYSCLR_3DFACE, ;
             GraMakeRGBColor( {212, 212, 255} ), ;
             GraMakeRGBColor( {143 ,107, 255} ) }
    oPS   := ::oXbp:lockPS()
    aSize := ::oXbp:currentSize()
    --aSize[1]; --aSize[2]
* Frame
    aALine[ GRA_AL_COLOR ] := IIF(::frameState = 1, XBPSYSCLR_3DFACE, GRA_CLR_DARKBLUE )
    aOldALine := oPS:setAttrLine( aALine )
    GraBox( oPS, {1, 1}, aSize )
* Inner space
    --aSize[1]; --aSize[2]
    aAArea[ GRA_AA_COLOR ] := clr[::frameState]
    aOldAArea := oPS:setAttrArea( aAArea )
    GraBox( oPS, {2, 2}, aSize, GRA_FILL )
* Restore old values
    oPS:setAttrLine( aOldALine )
    oPS:setAttrArea( aOldAArea )
    ::oXbp:unlockPS( oPS )
* Change icon
    IF ::oIcon != NIL
      IF ::icon1 != ::icon2
        ::oIcon:setCaption( IIF(::disabled, ::icon2, ::icon1 ) )
      ENDIF
      ::oIcon:setPresParam({ {XBP_PP_BGCLR, clr[::frameState]} })
    ENDIF
*
    IF ::oText != NIL
      ::oText:setCaption( ::oText:caption )
      ::oText:setPresParam({ {XBP_PP_BGCLR, clr[::frameState]} })
    ENDIF
  ENDIF
  clr := NIL
  ::oldFrameState := ::frameState
RETURN self

**********************************************************************
* Activate event holding by this action.
**********************************************************************
METHOD drgAction:activate(drawFrame)
  local  lastDrg, className

  DEFAULT drawFrame   TO .T., ;
          ::disabled  to .f.

  className := if( isObject(::oxbp:cargo), ::oXbp:cargo:ClassName(), '' )

  if drawFrame
    drawFrame := .not. ( className = 'drgPushButton' )
  endif

  IF !::disabled
    ::frameState := 3
    IF( drawFrame, ::drawFrame(), NIL )
   *  IF ::preValidate()
    IF ISNIL(::drgGet)                                                          // miss
      IF className = 'drgGet'
        IF ::oXbp:cargo:isEdit
          ::oXbp:cargo:oXbp:setInputFocus()
          SetAppFocus(::oXbp:cargo:oXbp)

          ::oxbp:cargo:drgDialog:lastXbpInFocus := ::oXbp:cargo:oXbp

          PostAppEvent(drgEVENT_ACTION, ::event, ::preValid, ::oXbp)
          PostAppEvent(drgEVENT_ACTION,self,,::oXbp)
        ENDIF
      ELSE
        PostAppEvent(drgEVENT_ACTION, ::event, ::preValid, ::oXbp)
        PostAppEvent(drgEVENT_ACTION,self,,::oXbp)
      ENDIF
    ELSE
      IF ::drgGet:isEdit
        if(lastDrg := ::drgGet:drgDialog:oForm:oLastDrg) <> ::drgGet
          if IsMemberVar(lastDrg,'clrfocus')
            lastDrg:oxbp:setcolorbg(lastDrg:clrfocus)
          endif
        endif

        ::drgGet:drgDialog:oForm:oLastDrg := ::drgGet
        ::drgGet:oXbp:setInputFocus()
        SetAppFocus(::drgGet:oXbp)

        ::drgGet:drgDialog:lastXbpInFocus := ::drgGet:oXbp

        ::drgGet:preValidate(.T.)
        ::drgGet:postValidateRelate(,.T.)
      ENDIF
    ENDIF
  ENDIF
RETURN

**********************************************************************
* Prevalidation if this action can post event
**********************************************************************
METHOD drgAction:preValidate()
  IF ::disabled
    RETURN .F.
  ENDIF
* Prevalidation might be declared as function or number. If declared as string \
* than prevalidate function is evaluated otherwise post field or post form \
* controls are in place.
  IF ISDIGIT(::preValid)
    IF ::preValid = '1'
      RETURN ::parent:drgDialog:oForm:postValidateField()
    ELSEIF ::preValid = '2'
      RETURN ::parent:drgDialog:oForm:postValidateForm()
    ELSE
      RETURN .T.
    ENDIF
  ELSE
  ENDIF
RETURN .T.

**********************************************************************
* Disables this action
**********************************************************************
METHOD drgAction:disable()
  IF !::disabled
    ::disabled := !::disabled

    if ::oxbp:className() = 'XbpImageButton'
      ::oxbp:disable()
    else
      ::drawFrame()
    endif
  ENDIF
RETURN self

**********************************************************************
* Disables this action
**********************************************************************
METHOD drgAction:enable()
  IF ::disabled
    ::disabled := !::disabled

    if ::oxbp:className() = 'XbpImageButton'
      ::oxbp:enable()
    else
      ::drawFrame()
    endif
  ENDIF
RETURN self

**********************************************************************
* CleanUP
**********************************************************************
METHOD drgAction:destroy()
  IF ::oText != NIL; ::oText:destroy(); ENDIF
  IF ::oIcon != NIL; ::oIcon:destroy(); ENDIF
  if ::oxbp  != NIL; ::oXbp:destroy() ; endIf

*  ::oForm      := ;
  ::parent     := ;
  ::oXbp       := ;
  ::oIcon      := ;
  ::oText      := ;
  ::icon1      := ;
  ::icon2      := ;
  ::extDll     := ;
  ::caption    := ;
  ::tipText    := ;
  ::event      := ;
  ::type       := ;
  ::disabled   := ;
  ::frameState := ;
  ::isAction   := ;
  ::preValid   := ;
  ::oldFrameState := ;
                  NIL
RETURN

************************************************************************
************************************************************************
*
* Action type definition class
*
************************************************************************
************************************************************************

CLASS _drgAction
  EXPORTED:

  VAR     type
  VAR     aType
  VAR     pos
  VAR     size
  VAR     caption
  VAR     event
  VAR     icon1
  VAR     icon2
  VAR     icon3
  VAR     res
  VAR     tipText
  VAR     pre

  METHOD  init
  METHOD  destroy

  HIDDEN:
  METHOD  parse

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgAction:init(line)
  ::type := 'action'
  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::size  TO {10, 1.3}
  DEFAULT ::aType TO 4
  DEFAULT ::pre   TO '0'

RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgAction:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'ATYPE'
      ::aType    := _getNum(value)
    CASE keyWord == 'POS'
      ::pos     := _getNumArr(value)
    CASE keyWord == 'SIZE'
      ::size     := _getNumArr(value)
    CASE keyWord == 'CAPTION'
      ::caption  := _getStr(value)
    CASE keyWord == 'EVENT'
      IF IsDigit(value)
        ::event   := _getNum(value)
      ELSE
        ::event   := _getStr(value)
      ENDIF
    CASE keyWord == 'ICON1'
      ::icon1   := _getNum(value)
    CASE keyWord == 'ICON2'
      ::icon2   := _getNum(value)
    CASE keyWord == 'RES'
      ::res     := _getStr(value)
    CASE keyWord == 'TIPTEXT'
      ::tipText := _getStr(value)
    CASE keyWord == 'TYPE'
      ::type := LOWER(_getStr(value))
    CASE keyWord == 'PRE'
      ::pre := ALLTRIM( _getStr(value) )
*    CASE ::parsed(keyWord, value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgAction:destroy()
  ::pre     := ;
  ::tipText := ;
  ::res     := ;
  ::icon2   := ;
  ::icon1   := ;
  ::event   := ;
  ::caption := ;
  ::size    := ;
  ::pos     := ;
  ::aType   := ;
  ::type    := ;
               NIL
RETURN

************************************************************************
************************************************************************
*
* PushButton is just another type of Action
*
************************************************************************
************************************************************************
CLASS drgPushButton FROM drgAction, drgObject
  EXPORTED:

  INLINE METHOD init(parent)
    ::parent      := parent
    ::drgDialog   := parent:drgDialog
    ::oXbp        := ::drgDialog:dialog
    ::isEdit      := .T.
    ::isGroup     := .F.
    ::isContainer := .F.
    ::canResize   := .F.
  RETURN .T.

************************************************************************
************************************************************************
  INLINE METHOD postValidate()
    ::frameState := 1
// SL1    ::drawFrame()
  RETURN .T.

************************************************************************
************************************************************************
  INLINE METHOD setFocus()
    IF ::disabled
      PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp)     // Just exit if disabled
    ELSE
      ::frameState := 2                                 // Animation
// SL1      ::drawFrame()
* Capture keyboard. Point to inner keyboard method
      ::oXbp:keyBoard := { |mp1, mp2, obj| ::keyboard( mp1, mp2, obj ) }
      SetAppFocus(::oXbp)
    ENDIF
  RETURN .T.

************************************************************************
* Push button keyboard method
************************************************************************
  INLINE METHOD keyBoard(nKey, mp2, oXbp)
    IF nKey = xbeK_ENTER .OR. nKey = xbeK_SPACE
      ::frameState := 3
// SL1      ::drawFrame()
      SLEEP(5)                                 // Just to see the motion
      ::activate()
      ::frameState := 1
    ELSEIF ::parent:keyHandled(nKey)
      PostAppEvent(drgEVENT_OBJEXIT, self,, ::oXbp)
      ::frameState := 1
    ELSE
    ::frameState := 2
    ENDIF
// SL1    ::drawFrame()
  RETURN .T.

************************************************************************
************************************************************************
  INLINE METHOD destroy()
    ::drgAction:destroy()
    ::drgObject:destroy()
  RETURN


  inline method create( pos, size, aType, icon1, icon2, extDll, caption, ;
                        tipText, event, isAction, preValid, drgGet)

    local  oBord, apos, asize, oIcon

    default preValid to '0'

    oBord := ::parent:getActiveArea()


    IF VALTYPE(pos) = 'O'
      size := oBord:currentSize()
      fPos := ACLONE( pos:pos )
      IF pos:size[1] < 40
        aPos := {(fPos[1])*drgINI:fontW, ;
                  size[2] - (fPos[2]+1)*drgINI:fontH - ::parent:topOffset}
      ELSE
        aPos := ACLONE(fPos)
      ENDIF

* Length of the field
      size[1] := IIF(pos:size[1] < 40, pos:size[1]*drgINI:fontW, pos:size[1])
      size[2] := IIF(pos:size[1] < 40, pos:size[2]*drgINI:fontH, pos:size[2])

      aType   := pos:aType
      icon1   := pos:icon1
      icon2   := pos:icon2
      caption := pos:caption
      tipText := pos:tipText
      event   := pos:event
      preValid:= pos:pre
    ELSE
      aPos    := ACLONE(pos)
    ENDIF

    *
    **
    DEFAULT size TO {22,22}
    ::event    := event

    ::icon1 := icon1
    ::icon2 := icon2
    DEFAULT ::icon2 TO ::icon1

    ::tipText  := drgNLS:msg( tipText )
    ::preValid := preValid
    ::drgGet   := drgGet
    ::disabled := .f.

    * line separator
    if atype = 0 .or. atype = 5
      ::oXbp          := XbpStatic():new( oBord, , apos, asize)
      ::oXbp:type     := XBPSTATIC_TYPE_RAISEDBOX
      ::oXbp:create()

      if( atype = 5, ::oxbp:setSize({0,0}), nil )
      return self

    else
      if isObject( drgGet )
        ::oxbp := XbpPushButton():new( obord,, apos, size )
      else
        ::oxbp := XbpImageButton():new( obord,, apos, size )
      endif
    endif

    if isObject( drgGet )
      ::oxbp:caption       := caption
      ::caption            := caption

    else
      do case
      case ( atype = 1 )
        oIcon:= XbpIcon():new():create()
        oIcon:load( NIL, icon1 )

        ::oXbp:caption       := ' '
        ::oxbp:image         := oIcon
        ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
        ::oxbp:ImageAlign    := XBPALIGN_HCENTER+XBPALIGN_TOP

        ::caption            := caption

      * 31  image + text
      * 33  text  + image
      case ( atype = 3 .or. atype = 31 .or. atype = 33 )
        if .not. empty(::icon1)
          oIcon:= XbpIcon():new():create()
          oIcon:load( NIL, ::icon1 )

          ::oxbp:image      := oIcon
          if     atype = 31
            ::oxbp:ImageAlign := XBPALIGN_HCENTER+XBPALIGN_LEFT
          elseif atype = 33
            ::oxbp:ImageAlign := XBPALIGN_HCENTER+XBPALIGN_RIGHT
          endif
        endif

        ::oxbp:caption       := caption
        ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
        ::oXbp:TextAlign     := XBPALIGN_HCENTER+XBPALIGN_VCENTER

        ::caption            := caption

      otherwise
        ::oxbp:caption       := caption

        ::oxbp:CaptionLayout := XBPALIGN_HCENTER+XBPALIGN_VCENTER
        ::oXbp:TextAlign     := XBPALIGN_HCENTER+XBPALIGN_VCENTER

        ::caption            := caption
      endcase
    endif

    if .not. empty( ::tipText )
      ::oxbp:ToolTipText := ::tipText
// ne      ::oxbp:enter       := {|mp1, mp2, obj| ::showToolTip(mp1, mp2, obj) }
// ne      ::oxbp:leave       := {|mp1, mp2, obj| ::showToolTip(mp1, mp2, obj) }
    endif


    ::oxbp:activate := {|| ::activate(.f.) }
    ::oxbp:create()

    ::oxbp:cargo := self
  return self

  * dost speciální metoda jedná se o tlaèítko, kde se programovì pøehodí
  * parent na oIconBar
  * zapne     canResize := .t no a pokud šolichá s oknem tlaèítko blbne
  inline method resize(aOld, aNew)
    local nX, nY
    local newX, newY

    nX := aNew[1] - aOld[1]
    nY := aNew[2] - aOld[2]

    newX := ::oXbp:currentPos()[1] +nX
    newY := ::oXbp:currentPos()[2]
    ::oxbp:setPos( {newX,newY}, .F.)
    return self

ENDCLASS

//////////////////////////////////////////////////////////////////////
//
//  drgPushButton class
//
//  Copyright:
//       Damjan Rems, (c) 2001. All rights reserved.
//
//  Contents:
//
//////////////////////////////////////////////////////////////////////
CLASS _drgPushButton FROM _drgAction
INLINE METHOD init(line)
  ::_drgAction:init(line)
  ::type := 'pushButton'
RETURN self
ENDCLASS

//////////////////////////////////////////////////////////////////////
//
//  drgActionManager class
//
//  Copyright:
//       Damjan Rems, (c) 2001. All rights reserved.
//
//  Contents:
//       Action manager is part of every dialog. It's purpose is to disable or anable \
//       perticular actions and to manage shortcuts.
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

CLASS drgActionManager
  EXPORTED:

  VAR     parent
  VAR     members

  METHOD  init
  METHOD  collect
  METHOD  disableActions
  METHOD  enableActions
  METHOD  shortcut
  METHOD  destroy
ENDCLASS

**********************************************************************
METHOD drgActionManager:init(parent)
  ::parent  := parent
  ::members := {}
RETURN self

***********************************************************************
* Collects all actions curently active in a drgDialog and sets members array
**********************************************************************
METHOD drgActionManager:collect()
  ::members := {}
  IF ::parent:hasIconArea
    AEVAL(::parent:oIconBar:members, {|a| AADD(::members, a) } )
  ENDIF
  IF ::parent:hasActionArea
    AEVAL(::parent:oActionBar:members, {|a| AADD(::members, a) } )
  ENDIF
  ::parent:oForm:collectActions(@::members)
RETURN

***********************************************************************
* Disables specified actions on the current form.
*
* \bParameters: b\
* \b< daArr >b\    : Array  : one dimensional array with supplied list of actions to disable. \
*  Elements of array may be numeric or string depending on event which is fired by action.
* \b< recolect >b\ : Boolean  : If action list is to be recolected befor disabling is done. \
* This is usualy needed with wizard type of form.
************************************************************************
METHOD drgActionManager:disableActions(daArr, recolect)
LOCAL x, i, cType
  DEFAULT recolect TO .F.
  IF recolect
    ::collect()
  ENDIF
* Run through action list
  FOR x := 1 TO LEN(::members)
* Only same type of events will be compared
    cType = VALTYPE(::members[x]:event)
    FOR i := 1 TO LEN(daArr)
      IF cType = VALTYPE(daArr[i]) .AND. daArr[i] = ::members[x]:event
**        ::members[x]:disable()
        ::members[x]:disabled := .t.
        EXIT
      ENDIF
    NEXT
  NEXT
RETURN

***********************************************************************
* Enables specified Actions on the current form.
*
* \bParameters: b\
* \b< daArr >b\    : Array  : one dimensional array with supplied list of actions to disable. \
*  Elements of array may be numeric or string depending on event which is fired by action.
* \b< recolect >b\ : Boolean  : If action list is to be recolected befor disabling is done. \
* This is usualy needed with wizard type of form.
************************************************************************
METHOD drgActionManager:enableActions(daArr, recolect)
LOCAL x, i, cType, isPushButton

  DEFAULT recolect TO .F.
  IF recolect
    ::collect()
  ENDIF
* Run through action list
  FOR x := 1 TO LEN(::members)
* Only same type of events will be compared
    cType = VALTYPE(::members[x]:event)
    FOR i := 1 TO LEN(daArr)
      IF cType = VALTYPE(daArr[i]) .AND. daArr[i] = ::members[x]:event
**        ::members[x]:enable()
        ::members[x]:disabled := .f.
      ENDIF
    NEXT
  NEXT
RETURN

***********************************************************************
* Checks if pressed key is a shortcut to action. Method checks if pressed key, \
* which must be pressed together with ALT key, is a shortcut key to an Action.
*
* \bParameters: b\
* \b< key >b\    : Numeric : Value of pressed key.
************************************************************************
METHOD drgActionManager:shortcut(nKey)
LOCAL aKey, x, i, m, isPushButton

* Ignore non ALT_xx keys
  IF nKey < xbeK_ALT_A .OR. nKey > xbeK_ALT_Z
    RETURN .F.
  ENDIF
* konvert key to ascii value
  aKey := CHR(nKey - xbeK_ALT_A + 65)
  FOR x := 1 TO LEN(::members)
    m := ::members[x]

* Not disabled, not NIL and has ~
    IF !m:disabled .AND. !EMPTY(m:caption) .AND. (i := AT('~', m:caption) ) > 0
      IF UPPER(m:caption[i+1] ) = aKey

       isPushButton := (::members[x]:className() = 'drgPushButton')

        m:activate( .not. isPushButton )
        RETURN .T.
      ENDIF
    ENDIF
  NEXT x
RETURN .F.

**********************************************************************
METHOD drgActionManager:destroy()

  ::members := ;
  ::parent  := NIL
RETURN