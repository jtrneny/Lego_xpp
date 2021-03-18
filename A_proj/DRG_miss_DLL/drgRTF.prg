#include "Appevent.ch"
#include 'Common.ch'
#include "DLL.CH"
#include "Font.ch"
#include 'gra.ch'
#include "Xbp.ch"

#include '..\DRG_miss_DLL\drgRTF.ch'
#include 'ot4xb.ch'

#include "..\Asystem++\Asystem++.ch"

#pragma library( "ot4xb.lib"   )
#pragma library( "ascom10.lib" )
#PRAGMA LIBRARY( "XPPUI2.LIB"  )

#define PROTECTED_MODE



procedure rtfEdit( drgDialog )
  local  oForm
  local  nEvent := mp1 := mp2 := oXbp := NIL
  local  ahotKeys := HOT_keys, npos, oButton
  local  pa
  *
  local  oOwner   := drgDialog:dialog, oLastFocus, odrg
  *
  ** pomocný v TMP pro naètení do RTF
  local  sName    := drgINI:dir_USERfitm +userWorkDir() +'\'
  local  ctextRTF := ''

  nEvent     := LastAppEvent(@mp1,@mp2,@oXbp)
  pa         := ListAsArray( oXbp:cargo:caption )
  oLastFocus := oXbp

  do case
  case( val(pa[2]) = 1 )       // naèítáme z hlavièky
    ctextRTF := DBGetVal( pa[1] )
*    memoWrit( sName +'_rtf.rtf', DBGetVal( pa[1] ))

  otherwise                    // naèítáme z pomocné položky MLE
    if isobject(odrg := drgDialog:dataManager:has(pa[1]))
      ctextRTF := odrg:Value
*      memoWrit( sName +'_rtf.rtf', odrg:Value )
    endif
  endcase
  memoWrit( sName +'_rtf.rtf', ctextRTF )

  oForm := RTFForm():new( AppDesktop(), oOwner )
    oForm:visible       := .F.
    oForm:minSize       := {700,400}
    oForm:create()

    oForm:oRTF:loadFile( sName +'_rtf.rtf' )
    oForm:setModalState( XBP_DISP_APPMODAL)

    oForm:close         := {|u1, u2, obj| appQuit( obj )}
    oForm:SetInputFocus := {|| SetAppFocus(oForm:oRTF)}
    CenterControl( oForm )

  oForm:show()
  SetAppFocus( oForm:oRTF )

  nEvent := xbe_None
  DO WHILE nEvent != xbeP_Quit
    nEvent := AppEvent( @mp1, @mp2, @oXbp )

    if nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        appQuit( oForm )

      otherwise
        if( npos := ascan( ahotKeys,{ |pa| pa[1] = mp1 })) <> 0
          oButton := oForm:oToolbar:GetItem( ahotKeys[npos,2] )
          oForm:ToolButtonClick( oButton )
        endif
      endcase
    endif

    oXbp:handleEvent( nEvent, mp1, mp2 )
  ENDDO

  if oForm:saveData
    do case
    case( val(pa[2]) = 1 )       // ukládáme na hlavièce
      DBPutVal( pa[1], oForm:oRTF:textRTF )

    otherwise                    // ukládáme do pomocné položky MLE
     if isobject(odrg := drgDialog:dataManager:has(pa[1]))
        odrg:value := oForm:oRTF:textRTF
      endif
    endcase
  endif

  * musíme smazat pomocný RTF soubor
  ferase( sName +'_rtf.rtf' )

  setAppFocus( oLastFocus )

  oForm:setModalState( XBP_DISP_MODELESS )
  oForm:destroy()

  oLastFocus:setInputFocus()
  setAppFocus( oLastFocus )
return

static procedure appQuit( obj )
  local nsel := XBPMB_RET_YES

  if obj:oRTF:changed
    nsel := confirmBox(,'Promiòte prosím ...' +CRLF + ;
                        'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                        'Data nebudou uložena ...'                     , ;
                         XBPMB_YESNO                                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                         XBPMB_DEFBUTTON2                                )
  endif

  if nsel = XBPMB_RET_YES
    PostAppEvent( xbeP_Quit,,, obj )
  endif
RETURN



CLASS RtfForm FROM XbpDialog, MyRTF
   EXPORTED:
   var    oToolBar, oFontSize, oFontName, oStatusBar, oRTF
   var    cFileName
   var    saveData

   method  Init, Create
   method  getFileName, insertImage
   METHOD  Refresh
   method  reSize, toolbarResize
   method  toolButtonClick, buttonMenuClick

   INLINE METHOD GetColor( nColor, oDlg )
   **************************************
      LOCAL oColorStruct, paColors

      STATIC cCustColors:= nil

      DEFAULT nColor TO 0, ;
              oDlg   TO SetAppWindow()

      IF cCustColors = nil
         cCustColors:= Replicate( L2Bin( 16777215 ), 16 )
      ENDIF
      paColors:= _xGrab( cCustColors )

      IF paColors != 0
         oColorStruct:= COLORSTRUC():new()
            oColorStruct:lStructSize   := 36
            oColorStruct:hwnd          := oDlg:getHWND()
            oColorStruct:hInstance     := 0
            oColorStruct:rgbResult     := nColor
            oColorStruct:lpCustColors  := paColors
            oColorStruct:flags         := xCC_RGBINIT + xCC_FULLOPEN + IIF( 'Windows 9' $ Os(), xCC_SOLIDCOLOR, 0 )
            oColorStruct:lCustData     := 0
            oColorStruct:lpfnHook      := 0
            oColorStruct:lpTemplateName:= 0

         IF @COMDLG32:ChooseColorA( oColorStruct ) = 1
            nColor:= oColorStruct:rgbResult
         ENDIF
         cCustColors:= PeekStr( paColors, 0, 64 )
         _xfree( paColors )
      ENDIF
   RETURN nColor


   INLINE METHOD ChooseFGcolor
   ***************************
      LOCAL nOldColor:= ::oRTF:selColor
      LOCAL nNewColor:= ::getColor( nOldColor, self )

      IF nOldColor != nNewColor
        ::oRTF:selColor := AutomationTranslateColor(nNewColor,.t.)
      ENDIF
*      ::setFocus()
   RETURN self
ENDCLASS



METHOD RtfForm:init( oParent, oOwner, aPos, aSize, aPP, lVisible )

  DEFAULT oParent  TO AppDesktop(), ;
          aPos     TO {599,253}, ;
          aSize    TO {700,400}, ;
          lVisible TO .F.

   DEFAULT aPP TO {}

   ::saveData := .f.

   AAdd ( aPP, { XBP_PP_COMPOUNDNAME, "8.Arial" } )

   ::XbpDialog:init( oParent, oOwner, aPos, aSize, aPP, lVisible )
     ::drawingArea:clipChildren := .T.
     ::taskList                 := .T.
     ::title                    := TXT_TITLE_MAIN

   ::oToolbar   := XbpToolBar():new( ::drawingArea, , {0,336}, {aSize[1],40} )

   ::oFontName  := XbpComboBox():new( ::oToolbar, , {8,-150}, {200,172}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } } )
     ::oFontName:tabstop := .T.

   ::oFontSize  := XbpComboBox():new( ::oToolbar, , {244,-150}, {56,172}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } } )
     ::oFontSize:tabstop := .T.

   ::oStatusbar := XbpStatusBar():new( ::drawingArea, , {0,0}, {592,28} ,, .T. )

   * Preparations of callback slots
   ::oFontName:ItemSelected := { || ::oRtf:SelFontName := Trim(::oFontName:XbpSLE:GetData()) }
   ::oFontSize:ItemSelected := { || ::oRtf:SelFontSize := Val(::oFontSize:XbpSLE:GetData()+".00") }
   ::Close                  := { || ::Destroy() }
   ::oToolbar:resize        := { |aOld,aNew| ::toolbarResize(aOld,aNew) }
RETURN self


METHOD RtfForm:create( oParent, oOwner, aPos, aSize, aPP, lVisible )
  local  aFonts, aFontNames, aFontSizes, oButton, oPanel, bError, oError, lExact

  ::XbpDialog:create( oParent, oOwner, aPos, aSize, aPP, lVisible )

  aSize:= ::drawingArea:currentSize()

  ::oToolbar:create()
    ::oToolbar:allowCustomize := .F.
    ::oToolbar:Style          := XBPTOOLBAR_STYLE_FLAT
    ::oToolbar:BorderStyle    := XBPFRAME_RECT

  ::oFontSize:create()
  ::oFontName:create()

  ::oStatusbar:create()
    ::oStatusbar:Caption      := "Panel"

  ::oToolbar:LoadImageSet( XBPTOOLBAR_STDIMAGES_SMALL )
    ::oToolbar:ButtonClick     := {|oButton| ::ToolButtonClick(oButton) }
    ::oToolBar:buttonMenuClick := {|oMenu  | ::buttonMenuClick(oMenu)   }

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := STD_IMAGE_FILEOPEN
    oButton:Key         := KEY_OPEN
    oButton:tooltipText := TIP_OPEN

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := STD_IMAGE_FILESAVE
    oButton:style       := XBPTOOLBAR_BUTTON_DROPDOWN
    oButton:Key         := KEY_SAVE
    oButton:tooltipText := TIP_SAVE

    oButton:addItem( 'Uložit (CTRL + S)', KEY_SAVE   )
    oButton:addItem( 'Uložit jako'      , KEY_SAVEAS )

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := STD_IMAGE_PRINT
    oButton:Key         := KEY_PRINT
    oButton:tooltipText := TIP_PRINT

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_PLACEHOLDER
    oButton:key         := KEY_FONTNAME
    ::oFontName:setPos( {oButton:Left, oButton:Top - oButton:Height} )
    oButton:width       := ::oFontName:CurrentSize()[1]

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_PLACEHOLDER
    oButton:key         := KEY_FONTSIZE
    ::oFontSize:setPos( {oButton:Left, oButton:Top - oButton:Height} )
    oButton:width       := ::oFontSize:CurrentSize()[1]

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_BOLD
    oButton:Key         := KEY_BOLD
    oButton:tooltipText := TIP_BOLD

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_ITALIC
    oButton:Key         := KEY_ITALIC
    oButton:tooltipText := TIP_ITALIC

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_UNDERLINE
    oButton:Key         := KEY_UNDERLINE
    oButton:tooltipText := TIP_UNDERLINE

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_FGCLR
    oButton:key         := KEY_FGCLR
    oButton:tooltipText := TIP_FGCLR

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_INSERTIMAGE
    oButton:key         := KEY_INSERTIMAGE
    oButton:tooltipText := TIP_INSERTIMAGE

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_LEFT
    oButton:Style       := XBPTOOLBAR_BUTTON_BUTTONGROUP
    oButton:Key         := KEY_LEFT
    oButton:tooltipText := TIP_LEFT

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_CENTER
    oButton:Style       := XBPTOOLBAR_BUTTON_BUTTONGROUP
    oButton:Key         := KEY_CENTER
    oButton:tooltipText := TIP_CENTER

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_RIGHT
    oButton:Style       := XBPTOOLBAR_BUTTON_BUTTONGROUP
    oButton:Key         := KEY_RIGHT
    oButton:tooltipText := TIP_RIGHT

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:AddItem()
    oButton:Image       := BMP_BULLET
    oButton:Key         := KEY_BULLET
    oButton:tooltipText := TIP_BULLET

  oButton               := ::oToolbar:AddItem()
    oButton:Style       := XBPTOOLBAR_BUTTON_SEPARATOR

  oButton               := ::oToolbar:addItem()
    oButton:image       := STD_IMAGE_UNDO
    oButton:key         := KEY_UNDO
    oButton:tooltipText := TIP_UNDO

  oButton               := ::oToolbar:addItem()
    oButton:image       := STD_IMAGE_REDO
    oButton:key         := KEY_REDO
    oButton:tooltipText := TIP_REDO

  oPanel                := ::oStatusbar:GetItem( 1 )
    oPanel:AutoSize     := XBPSTATUSBAR_AUTOSIZE_SPRING

  oPanel                := ::oStatusbar:AddItem()
    oPanel:Style        := XBPSTATUSBAR_PANEL_CAPSLOCK
    oPanel:Alignment    := XBPALIGN_HCENTER
    oPanel:AutoSize     := XBPSTATUSBAR_AUTOSIZE_CONTENTS
    oPanel:Width        -= 50

  oPanel                := ::oStatusbar:AddItem()
    oPanel:Style        := XBPSTATUSBAR_PANEL_NUMLOCK
    oPanel:Alignment    := XBPALIGN_HCENTER
    oPanel:AutoSize     := XBPSTATUSBAR_AUTOSIZE_CONTENTS
    oPanel:Width        -= 50

  oPanel                := ::oStatusbar:AddItem()
    oPanel:Style        := XBPSTATUSBAR_PANEL_INSERT
    oPanel:Alignment    := XBPALIGN_HCENTER
    oPanel:AutoSize     := XBPSTATUSBAR_AUTOSIZE_CONTENTS
    oPanel:Width        -= 50

   aFonts := XbpFont():New(::LockPS()):List()
     ::unlockPS()
     aFontNames := {}
     AEval( aFonts, { |o| IF( AScan(aFontNames,o:familyName)==0 , ;
                              AAdd(aFontNames,o:familyName), nil) } )

     lExact:= Set( _SET_EXACT, .T. )
     ASort( aFontNames )
     Set( _SET_EXACT, lExact )

     AEval( aFontNames, { |c| ::oFontName:addItem( c ) } )

     aFontSizes := { "6" ,  "8", "10", "11", "12", "14", "16", "18", "20", ;
                     "22", "24", "32", "36", "48", "52", "72"              }
     AEval( aFontSizes, { |c| ::oFontSize:AddItem( c ) } )

     aPos       := { 0, ::oToolBar:currentSize()[ 2 ] }
     aSize[ 2 ] -= aPos[ 2 ] + 28

#ifdef PROTECTED_MODE
      bError := ErrorBlock( {|e| Break( e ) } )
      BEGIN SEQUENCE
#endif

      ::oRTF := MyRTF():new():create( ::drawingArea,, aPos, aSize)

#ifdef PROTECTED_MODE
      RECOVER USING oError
         MsgBox( IIF( oError:subCode == 6500, TXT_ERR_CREATION1, TXT_ERR_CREATION2 + Ltrim( Str( oError:subCode ) ) + ')'  ), TXT_TITLE_MAIN )
         QUIT

      END SEQUENCE
      ErrorBlock( bError )
#endif

*   ::drawingArea:resize:= {|aOld, aNew | ::reSize( aOld, aNew ) }

   ::oRTF:Scrollbars   := XBP_SCROLLBAR_HORIZ+XBP_SCROLLBAR_VERT
   ::oRtf:bulletIndent := 10
   ::oRtf:SelChange    := { || ::Refresh() }
   ::Refresh()

   ::oRTF:changed      := .f.
RETURN self


METHOD RtfForm:Refresh()
  LOCAL xTmp, nCol, nLine
   //
   // Display the current line and column in the statusbar
   //
   nLine := ::oRTF:GetLineFromChar( ::oRTF:SelStart )
   nCol  := ::oRTF:SelStart - ::oRTF:GetLineStart( nLine )

   xTmp  := "Line: "  + LTrim( Str(nLine +1) ) + ;
            "   Column: " + LTrim( Str(nCol +1) )

   ::oStatusbar:GetItem(1):Caption := xTmp

   //
   // Update the toolbar elements with respect to the current
   // selection in the edit control. Note that the value NIL
   // may be returned for conflicting properties. If both
   // italic and non-italic text had been selected, for
   // for instance, ":SelItalic" contains the value NIL.
   //
   xTmp := ::oRtf:SelFontName
   IF Empty(xTmp) == .T.
      ::oFontName:XbpSle:SetData( "" )
   ELSE
      ::oFontName:XbpSle:SetData( xTmp )
   ENDIF
   xTmp := ::oRtf:SelFontSize
   IF Empty(xTmp) == .T.
      ::oFontSize:XbpSle:SetData( "" )
   ELSE
      ::oFontSize:XbpSle:SetData( AllTrim( Str( Int(xTmp) ) ) )
   ENDIF

   xTmp := ::oRtf:SelBold
   IF xTmp == NIL
      ::oToolbar:GetItem("Bold"):MixedState := .T.
   ELSE
      ::oToolbar:GetItem("Bold"):MixedState := .F.
      ::oToolbar:GetItem("Bold"):Pressed    := xTmp
   ENDIF

   xTmp := ::oRtf:SelItalic
   IF xTmp == NIL
      ::oToolbar:GetItem("Italic"):MixedState := .T.
   ELSE
      ::oToolbar:GetItem("Italic"):MixedState := .F.
      ::oToolbar:GetItem("Italic"):Pressed    := xTmp
   ENDIF

   xTmp := ::oRtf:SelUnderline
   IF xTmp == NIL
      ::oToolbar:GetItem("Underline"):MixedState := .T.
   ELSE
      ::oToolbar:GetItem("Underline"):MixedState := .F.
      ::oToolbar:GetItem("Underline"):Pressed    := xTmp
   ENDIF

   xTmp := ::oRtf:SelAlignment
   IF xTmp == NIL
      ::oToolbar:GetItem("Left"):MixedState   := .T.
      ::oToolbar:GetItem("Right"):MixedState  := .T.
      ::oToolbar:GetItem("Center"):MixedState := .T.
   ELSE
      ::oToolbar:GetItem("Left"):MixedState   := .F.
      ::oToolbar:GetItem("Right"):MixedState  := .F.
      ::oToolbar:GetItem("Center"):MixedState := .F.
      IF xTmp == XBPRTF_ALIGN_LEFT
         ::oToolbar:GetItem("Left"):Pressed := .T.
      ELSEIF xTmp == XBPRTF_ALIGN_RIGHT
         ::oToolbar:GetItem("Right"):Pressed := .T.
      ELSEIF xTmp == XBPRTF_ALIGN_CENTER
         ::oToolbar:GetItem("Center"):Pressed := .T.
      ENDIF
   ENDIF

   xTmp := ::oRtf:SelBullet
   IF xTmp == NIL
      ::oToolbar:GetItem("Bullet"):MixedState := .T.
   ELSE
      ::oToolbar:GetItem("Bullet"):MixedState := .F.
      ::oToolbar:GetItem("Bullet"):Pressed    := xTmp
   ENDIF

RETURN self


method RtfForm:ToolButtonClick( oButton )

   DO CASE
   CASE oButton:Key == KEY_OPEN           ;  ::oRtf:LoadFile(::GetFileName(.T.))
   CASE oButton:Key == KEY_SAVE           ;  ::saveData := .t.
                                             PostAppEvent( xbeP_Quit,,, self )
*                                            ::oRtf:SaveFile(::GetFileName(.F.))

   CASE oButton:Key == KEY_PRINT          ;  ::oRtf:Print()

   CASE oButton:Key == KEY_BOLD           ;  ::oRtf:SelBold      := .not. ::oRtf:selBold
   CASE oButton:Key == KEY_ITALIC         ;  ::oRtf:Selitalic    := .not. ::oRtf:selItalic
   CASE oButton:Key == KEY_UNDERLINE      ;  ::oRtf:SelUnderline := .not. ::oRtf:SelUnderline

   CASE oButton:key == KEY_FGCLR          ;  ::chooseFGcolor()
   CASE oButton:key == KEY_INSERTIMAGE    ;  ::insertImage()

   CASE oButton:Key == KEY_LEFT           ;  ::oRtf:SelAlignment := XBPRTF_ALIGN_LEFT
   CASE oButton:Key == KEY_CENTER         ;  ::oRtf:SelAlignment := XBPRTF_ALIGN_CENTER
   CASE oButton:Key == KEY_RIGHT          ;  ::oRtf:SelAlignment := XBPRTF_ALIGN_RIGHT
   CASE oButton:Key == KEY_BULLET         ;  ::oRtf:SelBullet    := .not. ::oRtf:SelBullet

   CASE oButton:Key == KEY_UNDO           ;  ::oRtf:undo()
   CASE oButton:Key == KEY_REDO           ;  ::oRtf:undo()
   ENDCASE

   ::Refresh()
RETURN self


method RtfForm:buttonMenuClick( oMenu )
  local  oButton

  do case
  case oMenu:key == KEY_SAVE
    oButton := ::oToolbar:GetItem(KEY_SAVE)
    ::ToolButtonClick( oButton )

  case oMenu:key == KEY_SAVEAS
    ::oRtf:SaveFile(::GetFileName(.F.))

  endCase
return self


method RtfForm:getFileName(lOpen)
  local  oDlg       := XbpFileDialog():New():Create(self)

  oDlg:center       := .T.
  oDlg:defExtension := "RTF"
  oDlg:fileFilters  := { { "RTF    (.rtf)"       , "*.rtf" } }
  oDlg:title        := convToOemCP( if( lOpen, 'Otevøít soubor', 'Uložit soubor' ))

  if lOpen
    ::cFileName := oDlg:Open()
    if( .not. File( ::cFileName ), ::cFileName := '', nil )

  else
    ::cFileName := oDlg:SaveAs(::cFileName)

  endif

  oDlg:Destroy()
  if( Empty( ::cFileName ), ::cFileName := '', nil )
RETURN ::cFileName


method RtfForm:insertImage()
   local oDlg   := XbpFileDialog():New():Create(self)
   local oClip
   local oBmp   := XbpBitmap():new():create()
   *
   local cFileName := ''

   oDlg:center       := .T.
   oDlg:defExtension := "BMP"
   oDlg:fileFilters  := { { "GIF    (.gif)"               , "*.gif"                          }, ;
                          { "JPEG   (.jpg, .jpeg)"        , "*.jpg;*.jpeg"                   }, ;
                          { "PGN    (.pgn)"               , "*.pgn"                          }, ;
                          { "BitMap (.bmp)"               , "*.bmp"                          }, ;
                          { convToOemCP("Všechny obrázky"), "*.gif;*.jpg;*.jpeg;*.pgn;*.bmp" }  }
   oDlg:title        := convToOemCP( 'Vložit obrázek' )

   if .not. empty( cFileName := oDlg:open())
     oBmp:loadFile( cFileName )

     oclip  := XbpClipBoard():new():create()
     oclip:open()
     oclip:clear()
     oclip:setBuffer( oBMP, XBPCLPBRD_BITMAP)
     oclip:close()

     ::oRTF:paste()
   endif

   oDlg:destroy()
   oBmp:destroy()
return self

/*
method RtfForm:reSize( aOldSize, aNewSize )
  local aPos, oButton, nYPos

  ::oToolbar:setSize( { aNewSize[ 1 ], ::oToolbar:currentSize()[ 2 ] } )

  aPos   := { 0, ::oToolBar:currentSize()[ 2 ] }
  oButton:= ::oToolbar:getItem( KEY_FONTNAME )
  nYPos  := aPos[ 2 ] - ::oFontName:currentSize()[ 2 ] + Int( abs( oButton:height - ::oFontName:sleSize()[ 2 ] ) / 2 )

  ::oFontName:setPos( { oButton:left, nYPos } )
  ::oFontSize:setPos( { ::oToolbar:getItem( KEY_FONTSIZE ):left, nYPos } )

  ::oRTF:setPosAndSize( aPos, { aNewSize[ 1 ], aNewSize[ 2 ] - aPos[ 2 ] - 28 } )

  ::oStatusbar:setPosAndSize( { 0, aNewSize[ 2 ] - 28 }, { aNewSize[ 1 ], 28 } )
return self
*/


METHOD RtfForm:Resize(aOldSize, aNewSize)
 LOCAL oButton
 LOCAL nTmp
 LOCAL nSLEY
 LOCAL cTmp
 LOCAL aSizeDA   := ::CalcClientRect( {0,0,aNewSize[1],aNewSize[2]} )
 LOCAL aSizeTBar := ::oToolbar:CurrentSize()
 LOCAL aSizeSBar := ::oStatusbar:CurrentSize()

   aSizeDA := {aSizeDA[3] - aSizeDA[1],aSizeDA[4] - aSizeDA[2]}

   ::oToolbar:SetSize( {aSizeDA[1], aSizeTBar[2]} )
   ::oToolbar:SetPos( {0, aSizeDA[2]-aSizeTBar[2]} )

   oButton := ::oToolbar:GetItem("Save")

   nSLEY   := ::oFontSize:CurrentSize()[2] - (::oFontSize:ListBoxSize()[2] -2)
   nTmp    := ::oToolbar:CurrentSize()[2]  - nSLEY
   nTmp    -= (::oFontSize:ListBoxSize()[2]- 2)
   nTmp    -= abs(oButton:Height - nSLEY) /2

   cTmp := ::oFontName:XbpSle:GetData()
   ::oFontName:SetPos( {::oFontName:CurrentPos()[1],nTmp} )
   ::oFontName:XbpSle:SetData( cTmp )

   cTmp := ::oFontSize:XbpSle:GetData()
   ::oFontSize:setPos( {::oFontSize:CurrentPos()[1],nTmp} )
   ::oFontSize:XbpSle:SetData( cTmp )

   ::oStatusbar:SetSize( { aSizeDA[1], aSizeSBar[2] } )
   ::oRtf:SetSize( { aSizeDA[1], aSizeDA[2]-aSizeTBar[2]-aSizeSBar[2] } )

RETURN self


******************************************************************************
* Toolbar object was resized, possibly due to a button row wrapping around.
* Realign all controls in the form.
******************************************************************************
METHOD RtfForm:ToolbarResize(aOldSize, aNewSize)

 LOCAL aSize

   IF aOldSize[2] != aNewSize[2]
      aSize := ::currentSize()
      ::Resize( aSize, aSize )
   ENDIF
RETURN self



static class MyRTF from xbpRTF
exported:

  inline method Create( oParent, oowner, aPos, aSize, aPP, lVisible )
    ::xbpRTF:create( oParent, oowner, aPos, aSize, aPP, lVisible )
    return self

  inline method Destroy()
    ::xbpRTF:destroy()
    return self

endClass


**************************
BEGIN STRUCTURE COLORSTRUC
**************************
   MEMBER DWORD  lStructSize
   MEMBER HWND   hwnd
   MEMBER HWND   hInstance
   MEMBER DWORD  rgbResult
   MEMBER LPSTR  lpCustColors
   MEMBER DWORD  Flags
   MEMBER LPARAM lCustData
   MEMBER LONG   lpfnHook
   MEMBER LPSTR  lpTemplateName
END STRUCTURE