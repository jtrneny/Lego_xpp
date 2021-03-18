#include "FONT.CH"
#include "GRA.CH"

#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"


STATIC oStartUp


function splash_for_dialog()
  local oXbp, aSize, aRect
  *
  local osplash_for_dialog

  osplash_for_dialog := XbpDialog():New( ,,,{ 1, 1 },, .F. )
  osplash_for_dialog:MinButton   := .F.
  osplash_for_dialog:MaxButton   := .F.
  osplash_for_dialog:HideButton  := .F.
  osplash_for_dialog:TitleBar    := .F.
  osplash_for_dialog:SysMenu     := .F.
  osplash_for_dialog:TaskList    := .F.

// JS aù n·m tam nesvÌtÌ pokud testujem
  if .not. isWorkVersion
    osplash_for_dialog:alwaysOnTop := .T.
  endif

  osplash_for_dialog:Border      := XBPDLG_DLGBORDER
  osplash_for_dialog:Title       := ""
  osplash_for_dialog:Create()

  osplash_for_dialog:DrawingArea:setColorBG(XBPSYSCLR_TRANSPARENT)

  oXbp := XbpStatic():New( osplash_for_dialog:DrawingArea,,,,, .F. )
  oXbp:Type         := XBPSTATIC_TYPE_BITMAP
  oXbp:Caption      := 532
  oXbp:AutoSize     := .T.
  oXbp:ClipChildren := .F.
  oXbp:Create()
  oXbp:Show()

  aSize := oXbp:CurrentSize()
  aRect := osplash_for_dialog:CalcFrameRect( { 0, 0, aSize[1], aSize[2] } )
  osplash_for_dialog:SetSize ( { aRect[3] - aRect[1], aRect[4] - aRect[2] } )

  CenterXbp ( osplash_for_dialog )
return osplash_for_dialog


function splash_for_start( oDlg )
  local  oXbp, aSize, aRect
  *
  local  osplash_for_start

  osplash_for_start := XbpDialog():New( ,,,{ 1, 1 },, .F. )
  osplash_for_start:MinButton   := .F.
  osplash_for_start:MaxButton   := .F.
  osplash_for_start:HideButton  := .F.
  osplash_for_start:TitleBar    := .F.
  osplash_for_start:SysMenu     := .F.
  osplash_for_start:TaskList    := .F.

**  osplash_for_start:alwaysOnTop := .T.

  osplash_for_start:Border      := XBPDLG_DLGBORDER
  osplash_for_start:Title       := ""
  osplash_for_start:Create()

  osplash_for_start:DrawingArea:setColorBG(XBPSYSCLR_TRANSPARENT)

  oXbp := XbpStatic():New( osplash_for_start:DrawingArea,,,,, .F. )
  oXbp:Type         := XBPSTATIC_TYPE_BITMAP
  oXbp:Caption      := 533
  oXbp:AutoSize     := .T.
  oXbp:ClipChildren := .F.
  oXbp:Create()
  oXbp:Show()

  aSize := oXbp:CurrentSize()
  aRect := osplash_for_start:CalcFrameRect( { 0, 0, aSize[1], aSize[2] } )
  osplash_for_start:SetSize ( { aRect[3] - aRect[1], aRect[4] - aRect[2] } )

  CenterXbp ( osplash_for_start )
return osplash_for_start


FUNCTION DisplayLogo()
   LOCAL oLogo, aPos, aSize, drawingArea   //:= SetAppWindow():drawingArea

   drawingArea := SetAppWindow()


   aSize              := drawingArea:currentSize()
   aPos               := { (aSize[1]-600)/2, aSize[2]-200 }
   oLogo              := XbpStatic():new( drawingArea,,aPos,{600,200})
   oLogo:type         := XBPSTATIC_TYPE_BITMAP
   oLogo:caption      := 533
   oLogo:AutoSize     := .T.
   oLogo:ClipChildren := .T.

   CenterXbp ( oLogo )

   oLogo:create()
RETURN oLogo



PROCEDURE ShowSplashScreen(BITMAPID)
  LOCAL oXbp, aSize, aRect

  oStartUp := XbpDialog():New(,,,{ 1, 1 },, .F. )
  oStartUp:MinButton  := .F.
  oStartUp:MaxButton  := .F.
  oStartUp:HideButton := .F.
  oStartUp:TitleBar   := .F.
  oStartUp:SysMenu    := .F.
  oStartUp:TaskList   := .F.
  oStartUp:Border     := XBPDLG_DLGBORDER // XBPDLG_NO_BORDER
  oStartUp:Title      := ""
  oStartUp:Create()

**  oStartUp:DrawingArea:SetColorBG ( -255 )

  oStartup:DrawingArea:setColorBG(XBPSYSCLR_TRANSPARENT)

  oXbp := XbpStatic():New( oStartUp:DrawingArea,,,,, .F. )
  oXbp:Type := XBPSTATIC_TYPE_BITMAP
  oXbp:Caption := BITMAPID
  oXbp:AutoSize := .T.
  oXbp:ClipChildren := .F.
  oXbp:Create()
  oXbp:Show()

  aSize := oXbp:CurrentSize()
  aRect := oStartUp:CalcFrameRect( { 0, 0, aSize[1], aSize[2] } )
  oStartUp:SetSize ( { aRect[3] - aRect[1], aRect[4] - aRect[2] } )

  CenterXbp ( oStartUp )
  oStartUp:Show()
  oStartUp:ToFront()
RETURN

PROCEDURE RemoveSplashScreen()
  oStartUp:Destroy()
RETURN

STATIC FUNCTION CenterXbp ( oXbp )
  LOCAL aSizeParent, aSize, aPos

  aSizeParent := oXbp:SetParent():CurrentSize()
  aSize := oXbp:CurrentSize()
  aPos := Array(2)
  aPos[1] := ( aSizeParent[1] - aSize[1] ) / 2
  aPos[2] := ( aSizeParent[2] - aSize[2] ) / 2
  oXbp:SetPos ( aPos )
RETURN aPos





