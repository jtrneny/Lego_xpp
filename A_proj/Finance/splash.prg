// splash.PRG
#include "XBP.CH"
#include "FONT.CH"
#include "GRA.CH"

STATIC oStartUp

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