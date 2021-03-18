//////////////////////////////////////////////////////////////////////
//
//  Copyright:
//        Alaska Software, (c) 2009. All rights reserved.
//
//  Contents:
//        Implementation of the "XbpImageButton" class
//
//////////////////////////////////////////////////////////////////////
#include "Xbp.CH"
#include "Gra.CH"
#include 'dll.ch'
#include "XbpPack1.CH"



#define GRA_CLR_BLUE1     GRA_CLR_WHITE
#define GRA_CLR_BLUE2     33016209       // GraMakeRgbColor( { 145, 201, 247 } )
#define GRA_CLR_BLUE3     GRA_CLR_BLUE2
#define GRA_CLR_BLUE4     GRA_CLR_BLUE1

#define GRA_CLR_GRAY1     GRA_CLR_WHITE
#define GRA_CLR_GRAY2     30922711       // GraMakeRgbColor( { 215, 215, 215 } )
#define GRA_CLR_GRAY3     GRA_CLR_GRAY2
#define GRA_CLR_GRAY4     GRA_CLR_GRAY1


DLLFUNCTION CreateRoundRectRgn( nX1, nY1, nX2, nY2, nW, nH ) USING STDCALL FROM GDI32.DLL
DLLFUNCTION SetWindowRgn( nHwnd, nRgn, lRedraw             ) USING STDCALL FROM USER32.DLL
DLLFUNCTION DeleteObject( nObject                          ) USING STDCALL FROM GDI32.DLL
DLLFUNCTION CreateEllipticRgn( nLeftRect, nTopRect, nRightRect, nBottomRect ) USING STDCALL FROM GDI32.DLL


//////////////////////////////////////////////////////////////////////
///   Declaration of the "XbpImageButton" class
//////////////////////////////////////////////////////////////////////
CLASS XbpImageButton FROM XbpPushButton
 PROTECTED:
                 // GRA string attributes for button elements
   VAR           TextAttrs
   VAR           AreaAttrs
                 // Rectangles for button element alignment, see
                 // ::ComputeLayout()
   VAR           ImageRect
   VAR           TextRect

   METHOD        ComputeLayout()
                 // Methods for button rendering, see :Draw()
   METHOD        DrawFrame()
   METHOD        DrawBackground()

   method        DrawGradientColors()

   METHOD        DrawText()
   METHOD        DrawImage()

 EXPORTED:
                 // Image resource id or object. :SelectedImage,
                 // :DisabledImage optionally specify alternate
                 // images for the respective object state
                 // (default: :Image is used).
   VAR           Image
   ASSIGN METHOD SetImage() VAR Image
   VAR           SelectedImage
   VAR           DisabledImage

   VAR           DLLName
   VAR           TextAlign
   ASSIGN METHOD SetTextAlign() VAR TextAlign
   VAR           ImageAlign
   ASSIGN METHOD SetImageAlign()    VAR ImageAlign
   VAR           CaptionLayout
   ASSIGN METHOD SetCaptionLayout() VAR CaptionLayout

   var           GradientColors
   assign method SetGradientColors() var GradientColors

   var           nRadius, lEnter

   METHOD        Init()
   METHOD        Create()
   METHOD        Draw()

   METHOD        SetCaption()

   METHOD        SetSize()
   METHOD        SetPosAndSize()

   inline method Enter  ;  ::lEnter := .t. ; ::invalidateRect() ; RETURN self
   inline method Leave  ;  ::lEnter := .f. ; ::invalidateRect() ; RETURN self
ENDCLASS


//////////////////////////////////////////////////////////////////////
/// Implementation of the "XbpImageButton" class
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )

  ::XbpPushButton:Init(oParent, oOwner, aPos, aSize, aPP, lVisible)

  ::TextAlign    := XBPALIGN_VCENTER + XBPALIGN_LEFT
  ::ImageAlign   := XBPALIGN_LEFT + XBPALIGN_VCENTER
  ::CaptionLayout:= XBP_LAYOUT_TEXTRIGHT

  ::DrawMode     := XBP_DRAW_OWNER

  ::TextAttrs    := Array( GRA_AS_COUNT )
  ::AreaAttrs    := Array( GRA_AA_COUNT )

  ::AreaAttrs[GRA_AA_COLOR]     := XBPSYSCLR_3DFACE
  ::TextAttrs[GRA_AS_COLOR]     := XBPSYSCLR_WINDOWTEXT
  ::TextAttrs[GRA_AS_VERTALIGN] := GRA_VALIGN_BOTTOM

  ::lEnter      := .F.
  ::nRadius     := 20
RETURN self


//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )

 LOCAL oTmp, nRgn

   IF Upper(AppName(.F.)) $ "XPPFD.EXE"
      ::Image := XbpIcon():New():Create()
      ::Image:Load( "XPPNAT.DLL", 1 )

      IF Empty(::Caption) == .T.
         ::Caption := "Caption"
      ENDIF
   ENDIF

   IF ValType(::Image) == "N"
      oTmp  := XbpBitmap():New():Create()
      oTmp:Load( ::DLLName, ::Image )
      IF oTmp:XSize == 0
         XBPException():RaiseParameterType( {oParent,oOwner,aPos,aSize,aPP,lVisible} )
      ENDIF
      oTmp:TransparentClr := oTmp:GetDefaultBGColor()
      ::Image := oTmp
   ENDIF

   IF ValType(::SelectedImage) == "N"
      oTmp  := XbpBitmap():New():Create()
      oTmp:Load( ::DLLName, ::SelectedImage )
      IF oTmp:XSize == 0
         XBPException():RaiseParameterType( {oParent,oOwner,aPos,aSize,aPP,lVisible} )
      ENDIF
      ::SelectedImage := oTmp
   ENDIF

   IF ValType(::DisabledImage) == "N"
      oTmp  := XbpBitmap():New():Create()
      oTmp:Load( ::DLLName, ::DisabledImage )
      IF oTmp:XSize == 0
         XBPException():RaiseParameterType( {oParent,oOwner,aPos,aSize,aPP,lVisible} )
      ENDIF
      ::DisabledImage := oTmp
   ENDIF

   ::XbpPushButton:Create(oParent, oOwner, aPos, aSize, aPP, lVisible)

*   if isWorkVersion
*     if aSize = nil ; aSize:= ::currentSize() ; endif
*     nRgn:= CreateRoundRectRgn( 0, aSize[ 2 ], aSize[ 1 ], 0, ::nRadius, ::nRadius )
*     if nRgn # 0 ; SetWindowRgn( ::getHWND(), nRgn, .T. ) ; DeleteObject( nRgn ) ; endif
*   endif
RETURN self


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :Image
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetImage( xImage )

 LOCAL nType := ValType( xImage )

  IF nType != "O" .AND. nType != "N"
     XbpException():RaiseParameterType( {xImage} )
  ENDIF

  ::Image     := xImage

  ::TextRect  := NIL
  ::ImageRect := NIL

  IF ::Status() == XBP_STAT_CREATE
     ::InvalidateRect()
  ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :TextAlign
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetTextAlign( nAlign )

  IF ValType(nAlign) != "N"
     XBPException():RaiseParameterType( {nAlign} )
  ENDIF

  ::TextAlign := nAlign

  ::TextRect  := NIL
  ::ImageRect := NIL

  IF ::Status() == XBP_STAT_CREATE
     ::InvalidateRect()
  ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :ImageAlign
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetImageAlign( nAlign )

  IF ValType(nAlign) != "N"
     XBPException():RaiseParameterType( {nAlign} )
  ENDIF

  ::ImageAlign := nAlign

  ::TextRect  := NIL
  ::ImageRect := NIL

  IF ::Status() == XBP_STAT_CREATE
     ::InvalidateRect()
  ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :CaptionLayout
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetCaptionLayout( nLayout )

  IF ValType(nLayout) != "N"
     XBPException():RaiseParameterType( {nLayout} )
  ENDIF

  ::CaptionLayout := nLayout

  ::TextRect  := NIL
  ::ImageRect := NIL

  IF ::Status() == XBP_STAT_CREATE
     ::InvalidateRect()
  ENDIF

RETURN


method XbpImageButton:SetGradientColors( xcolors )

  ::GradientColors := xcolors

  if ::Status() == XBP_STAT_CREATE
    ::InvalidateRect()
  endif
return


//////////////////////////////////////////////////////////////////////
/// (Owner-) Draw method which is called by the system to control
/// control drawing of the button
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:Draw( oPS, aInfo )

   // Align image and caption
   ::ComputeLayout( oPS, aInfo )

   // Draw button elements
   ::DrawBackground( oPS, aInfo )
   ::DrawGradientColors( ops, ainfo )

   ::DrawFrame( oPS, aInfo )
   if( isWorkVersion, ::DrawGradientColors( ops, ainfo ), nil )
 
   ::DrawImage( oPS, aInfo )
   ::DrawText( oPS, aInfo )

   // Add focus rectangle if button
   // has the input focus
   IF BAnd(aInfo[3],XBP_DRAWSTATE_FOCUS) == XBP_DRAWSTATE_FOCUS
      GraFocusRect( oPS )
   ENDIF

RETURN self


//////////////////////////////////////////////////////////////////////
/// Draw frame around caption and image
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:DrawFrame( oPS, aInfo )
  local  nYPos:= Int( aInfo[ XBP_DRAWINFO_RECT, 4 ] / 3 )
  local  acolors1, acolors2

   if isWorkVersion   //  uvolnime to uživateli isWorkVersion
     if ::controlState == XBP_STATE_DISABLED
        aColors1:= { GRA_CLR_GRAY2, GRA_CLR_GRAY2 }
        aColors2:= { GRA_CLR_GRAY2, GRA_CLR_GRAY2 }
     elseIf ::controlState == XBP_STATE_PRESSED
        aColors1:= { GRA_CLR_BLUE2, GRA_CLR_BLUE2 }
        aColors2:= { GRA_CLR_BLUE3, GRA_CLR_BLUE3 }
     ELSEIF ::lEnter = .T.
        aColors1:= { GRA_CLR_BLUE1, GRA_CLR_BLUE2 }
        aColors2:= { GRA_CLR_BLUE3, GRA_CLR_BLUE4 }
     else
        aColors1:= { GRA_CLR_GRAY1, GRA_CLR_GRAY2 }
        aColors2:= { GRA_CLR_GRAY3, GRA_CLR_GRAY4 }
     endif

     GraGradient( oPS, { 0, 1 }, { { aInfo[ XBP_DRAWINFO_RECT, 3 ], nYPos } }, aColors1, GRA_GRADIENT_VERTICAL )
     GraGradient( oPS, { 0, nYPos + 1 }, { { aInfo[ XBP_DRAWINFO_RECT, 3 ], aInfo[ XBP_DRAWINFO_RECT, 4 ] - 1 } }, aColors2, GRA_GRADIENT_VERTICAL )

     oPS:setColor( GRA_CLR_PALEGRAY, GRA_CLR_WHITE )
     GraBox( oPS, { 0, 1 }, { aInfo[ XBP_DRAWINFO_RECT, 3 ] - 1 , aInfo[ XBP_DRAWINFO_RECT, 4 ] - 1 },, ::nRadius, ::nRadius )
     oPS:setColor( GRA_CLR_BLACK, XBPSYSCLR_WINDOWSTATICTEXT )
   endif

   IF IsThemeActive(.T.) == .T.
      RETURN
   ENDIF

   IF ::ControlState == XBP_STATE_PRESSED
      GraEdge( oPS, {aInfo[XBP_DRAWINFO_RECT][1],aInfo[XBP_DRAWINFO_RECT][2]},;
                    {aInfo[XBP_DRAWINFO_RECT][3],aInfo[XBP_DRAWINFO_RECT][4]},;
               GRA_EDGESTYLE_SUNKEN )
   ELSE
      GraEdge( oPS, {aInfo[XBP_DRAWINFO_RECT][1],aInfo[XBP_DRAWINFO_RECT][2]},;
                    {aInfo[XBP_DRAWINFO_RECT][3],aInfo[XBP_DRAWINFO_RECT][4]},;
               GRA_EDGESTYLE_RAISED )
   ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// Clear button background
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:DrawBackground( oPS, aInfo )
   GraBackground( oPS, {aInfo[XBP_DRAWINFO_RECT][1],aInfo[XBP_DRAWINFO_RECT][2]},;
                       {aInfo[XBP_DRAWINFO_RECT][3],aInfo[XBP_DRAWINFO_RECT][4]} )
RETURN


method XbpImageButton:DrawGradientColors( ops, ainfo )
  local  aStart    := { 3, 3 }
  local  aVertices := { { aInfo[XBP_DRAWINFO_RECT][3] -3, ;
                          aInfo[XBP_DRAWINFO_RECT][4] -3  } }

  if ValType( ::GradientColors) = 'A'
    GraGradient( ops, aStart, aVertices, ::GradientColors, GRA_GRADIENT_HORIZONTAL)
  endif
return



//////////////////////////////////////////////////////////////////////
/// Draw image corresponding to button's current state
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:DrawImage( oPS, aInfo )

 LOCAL oImage
 LOCAL aRect      // := AClone( ::ImageRect )
 LOCAL nWidth
 LOCAL nHeight
 LOCAL nImgWidth
 LOCAL nImgHeight
 LOCAL nDiffX, nDiffY


 if isNull( ::ImageRect )
   return
 endif

 aRect := AClone( ::ImageRect )

   DO CASE
      CASE BAnd(aInfo[3],XBP_DRAWSTATE_DISABLED) == XBP_DRAWSTATE_DISABLED
         oImage := ::DisabledImage
      CASE BAnd(aInfo[3],XBP_DRAWSTATE_SELECTED) == XBP_DRAWSTATE_SELECTED
         oImage := ::SelectedImage
   ENDCASE

   IF oImage == NIL
      oImage = ::Image
   ENDIF

   IF oImage == NIL
      RETURN
   ENDIF

   nImgWidth  = ::Image:XSize
   nImgHeight = ::Image:YSize
   nWidth     = aRect[3] - aRect[1]
   nHeight    = aRect[4] - aRect[2]

   IF nImgWidth > nWidth
      nImgHeight -= (nImgWidth - nWidth)
      nImgWidth  =  nWidth
   ENDIF
   IF nImgHeight > nHeight
      nImgWidth  -= (nImgHeight - nHeight)
      nImgHeight =  nHeight
   ENDIF

   nDiffX = nWidth  - nImgWidth
   nDiffY = nHeight - nImgHeight

   DO CASE
     CASE BAnd(::ImageAlign,XBPALIGN_RIGHT) == XBPALIGN_RIGHT
        aRect[1] += nDiffX
     CASE BAnd(::ImageAlign,XBPALIGN_HCENTER) == XBPALIGN_HCENTER
        aRect[1] += nDiffX /2
        aRect[3] -= nDiffX /2
     OTHERWISE
        // XBPALIGN_LEFT
        aRect[3] -= nDiffX
   ENDCASE

   DO CASE
     CASE BAnd(::ImageAlign,XBPALIGN_BOTTOM) == XBPALIGN_BOTTOM
       aRect[4] -= nDiffY
     CASE BAnd(::ImageAlign,XBPALIGN_VCENTER) == XBPALIGN_VCENTER
        aRect[2] += nDiffY /2
        aRect[4] -= nDiffY  /2
     OTHERWISE
        // XBPALIGN_TOP
        aRect[2] += nDiffY
   ENDCASE

   IF BAnd(aInfo[3],XBP_DRAWSTATE_DISABLED) == XBP_DRAWSTATE_DISABLED
      IF oImage:IsDerivedFrom("XbpBitmap") == .T.
         oImage:Draw( oPS, aRect,,,, XBP_STATE_DISABLED )
      ELSE
         oImage:Draw( oPS, aRect, XBP_STATE_DISABLED )
      ENDIF
   ELSE
      oImage:Draw( oPS, aRect )
   ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// Draw the caption
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:DrawText( oPS, aInfo )

 LOCAL aAttrsPrev
 LOCAL aAttrs := Array( GRA_AS_COUNT )

   IF BAnd(aInfo[3],XBP_DRAWSTATE_DISABLED) == XBP_DRAWSTATE_DISABLED
      aAttrs[GRA_AS_COLOR] := XBPSYSCLR_ACTIVEBORDER
      aAttrsPrev := GraSetAttrString( oPS, aAttrs )
   ENDIF

   * naše úprava na textu, nìkde se tam objeví NIL
   if isNull( ::caption ) .or. isNull( ::TextRect)
     return
   endif

   // WORK-AROUND PDR 6129
   oPS:ThemeHandle := 0
   GraCaptionStr( oPS, {::TextRect[1],::TextRect[2]}, ;
                       {::TextRect[3],::TextRect[4]}, ::Caption, ;
                  ::TextAlign )

   IF aAttrsPrev != NIL
      GraSetAttrString( oPS, aAttrsPrev )
   ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :Caption
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetCaption( cCaption )

   IF ValType(cCaption) != "C"
      XBPException():RaiseParameterType( {cCaption} )
   ENDIF

   ::Caption   := cCaption

   ::TextRect  := NIL
   ::ImageRect := NIL

   IF ::Status() == XBP_STAT_CREATE
      ::InvalidateRect()
   ENDIF

RETURN .T.


//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetSize( aSize )
   ::ImageRect := NIL
   ::TextRect  := NIL
RETURN ::XbpPushButton:SetSize(aSize)


//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:SetPosAndSize( aPos, aSize )
   ::ImageRect := NIL
   ::TextRect  := NIL
RETURN ::XbpPushButton:SetPosAndSize(aPos, aSize)


//////////////////////////////////////////////////////////////////////
/// Computes rectangles for text and image rendering
///
/// Notes: o This methods initializes members ::TextRect and
///          ::ImageRect
//////////////////////////////////////////////////////////////////////
METHOD XbpImageButton:ComputeLayout( oPS, aInfo )

 LOCAL aRect
 LOCAL aSize
 LOCAL nImgWidth
 LOCAL nImgHeight
 LOCAL aImgRect
 LOCAL aTxtRect

   UNUSED( oPS )

   IF ValType(::ImageRect) == "A" .AND. ValType(::TextRect) == "A"
      RETURN
   ENDIF

   aRect      := aInfo[XBP_DRAWINFO_RECT]
   aSize      := {aRect[3]-aRect[1],aRect[4]- aRect[2]}
   nImgWidth  := 0
   nImgHeight := 0
   aImgRect   := {0,0,0,0}
   aTxtRect   := {0,0,0,0}

   IF ValType(::Image) == "O"
      nImgWidth  := ::Image:XSize
      nImgHeight := ::Image:YSize
   ENDIF

   DO CASE
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTLEFT
        aImgRect[2] := aTxtRect[2] := aRect[2] + STD_SPACING
        aImgRect[4] := aTxtRect[4] := aSize[2] - STD_SPACING
        aTxtRect[1] = aRect[1] + STD_SPACING
        aTxtRect[3] = Max( (aSize[1] - STD_SPACING) /2, aSize[1] -;
                           nImgWidth - STD_SPACING *2 )
        aImgRect[1] = aTxtRect[3] + STD_SPACING
        aImgRect[3] = aSize[1] - STD_SPACING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTTOP
        aImgRect[1] := aTxtRect[1] := aRect[1] + STD_SPACING
        aImgRect[3] := aTxtRect[3] := aSize[1] - STD_SPACING
        aImgRect[2] = aRect[2] + STD_SPACING
        aImgRect[4] = Min( (aSize[2] - STD_SPACING) /2, nImgHeight +;
                           STD_SPACING )
        aTxtRect[2] = aImgRect[4] + STD_SPACING
        aTxtRect[4] = aSize[2] - STD_SPACING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTRIGHT
        aImgRect[2] := aTxtRect[2] := aRect[2] + STD_SPACING
        aImgRect[4] := aTxtRect[4] := aSize[2] - STD_SPACING
        aImgRect[1] = aRect[1] + STD_SPACING
        aImgRect[3] = Min( (aSize[1] - STD_SPACING) /2, nImgWidth +;
                           STD_SPACING *2)
        aTxtRect[1] = aImgRect[3] + STD_SPACING
        aTxtRect[3] = aSize[1] - STD_SPACING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTBOTTOM
        aImgRect[1] := aTxtRect[1] := aRect[1] + STD_SPACING
        aImgRect[3] := aTxtRect[3] := aSize[1] - STD_SPACING
        aTxtRect[2] = aRect[2] + STD_SPACING
        aTxtRect[4] = Max( (aSize[2]  - STD_SPACING) /2, aSize[2] -;
                           nImgHeight - STD_SPACING *2 )
        aImgRect[2] = aTxtRect[4] + STD_SPACING
        aImgRect[4] = aSize[2] - STD_SPACING
     OTHERWISE
        // XBP_LAYOUT_TEXTCENTER
        aImgRect[1] := aTxtRect[1] := aRect[1] + STD_SPACING
        aImgRect[3] := aTxtRect[3] := aRect[3] - STD_SPACING
        aImgRect[2] := aTxtRect[2] := aRect[2] + STD_SPACING
        aImgRect[4] := aTxtRect[4] := aRect[4] - STD_SPACING
   ENDCASE

   ::ImageRect := aImgRect
   ::TextRect  := aTxtRect

RETURN

// EOF