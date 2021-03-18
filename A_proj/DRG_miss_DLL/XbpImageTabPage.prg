//////////////////////////////////////////////////////////////////////
//
//  Copyright:
//        Alaska Software, (c) 2009. All rights reserved.
//
//  Contents:
//        Implementation of the "XbpImageTabPage" class
//
//////////////////////////////////////////////////////////////////////
#include "Xbp.CH"
#include "Gra.CH"
#include "XbpPack1.CH"


//////////////////////////////////////////////////////////////////////
///   Declaration of class "XbpImageTabPage"
//////////////////////////////////////////////////////////////////////
CLASS XbpImageTabPage FROM XbpTabPage
 PROTECTED:
                 // GRA attributes for tab page elements
   VAR           TextAttrs
   VAR           AreaAttrs
                 // Rectangles for tab page element alignment, see
                 // ::ComputeLayout()
   VAR           ImageRect
   VAR           TextRect

   METHOD        ComputeLayout()
                 // Methods for drawing tab page elements, see
                 // :Draw()
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

   METHOD        Init()
   METHOD        Create()
   METHOD        Draw()

   ASSIGN METHOD SetCaption() VAR Caption

   METHOD        SetSize()
   METHOD        SetPosAndSize()

ENDCLASS


//////////////////////////////////////////////////////////////////////
/// Implementation of class "XbpImageTabPage"
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )

  ::XbpTabPage:Init(oParent, oOwner, aPos, aSize, aPP, lVisible)

  ::TextAlign    := XBPALIGN_VCENTER +XBPALIGN_LEFT
  ::ImageAlign   := XBPALIGN_LEFT + XBPALIGN_VCENTER
  ::CaptionLayout:= XBP_LAYOUT_TEXTRIGHT

  ::DrawMode   := XBP_DRAW_OWNER

  ::TextAttrs  := Array( GRA_AS_COUNT )
  ::AreaAttrs  := Array( GRA_AA_COUNT )

  ::AreaAttrs[GRA_AA_COLOR]     := XBPSYSCLR_3DFACE
  ::TextAttrs[GRA_AS_COLOR]     := XBPSYSCLR_WINDOWTEXT
  ::TextAttrs[GRA_AS_VERTALIGN] := GRA_VALIGN_BOTTOM

  ::Minimized  := .F.

  ::PostOffset := 60

RETURN self


//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )

 LOCAL oTmp

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

   ::XbpTabPage:Create(oParent, oOwner, aPos, aSize, aPP, lVisible)

RETURN self


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :Image
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:SetImage( xImage )

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
METHOD XbpImageTabPage:SetTextAlign( nAlign )

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
METHOD XbpImageTabPage:SetImageAlign( nAlign )

  IF ValType(nAlign) != "N"
     XBPException():RaiseParameterType( {nAlign} )
  ENDIF

  ::ImageAlign := nAlign

  ::TextRect   := NIL
  ::ImageRect  := NIL

  IF ::Status() == XBP_STAT_CREATE
     ::InvalidateRect()
  ENDIF

RETURN


//////////////////////////////////////////////////////////////////////
/// ASSIGN method of member :CaptionLayout
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:SetCaptionLayout( nLayout )

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


//////////////////////////////////////////////////////////////////////
/// (Owner-) Draw method which is called by the system to control
/// control drawing of the button
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:Draw( oPS, aInfo )

   // Align and draw image and caption
   ::ComputeLayout( oPS, aInfo )

   ::DrawImage( oPS, aInfo )
   ::DrawText( oPS, aInfo )

   // Add focus rectangle, if the tab
   // page has the input focus
   IF BAnd(aInfo[3],XBP_DRAWSTATE_FOCUS) == XBP_DRAWSTATE_FOCUS .OR.;
      ::HasInputFocus() == .T.
      GraFocusRect( oPS, {aInfo[XBP_DRAWINFO_RECT,1],aInfo[XBP_DRAWINFO_RECT,2]},;
                         {aInfo[XBP_DRAWINFO_RECT,3],aInfo[XBP_DRAWINFO_RECT,4]} )
   ENDIF

RETURN .F.


//////////////////////////////////////////////////////////////////////
/// Draw image corresponding to the current object state
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:DrawImage( oPS, aInfo )

 LOCAL oImage
 LOCAL aRect := AClone( ::ImageRect )
 LOCAL nWidth
 LOCAL nHeight
 LOCAL nImgWidth
 LOCAL nImgHeight
 LOCAL nDiffX, nDiffY

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
METHOD XbpImageTabPage:DrawText( oPS, aInfo )

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

*JS*   GraSetFont( oPS, XbpFont():New():Create(XBPSYSFNT_GUIDEFAULT) )
   GraSetFont( oPS, ::setFont() )

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
METHOD XbpImageTabPage:SetCaption( cCaption )

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
METHOD XbpImageTabPage:SetSize( aSize )
   ::ImageRect := NIL
   ::TextRect  := NIL
RETURN ::XbpTabPage:SetSize(aSize)


//////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:SetPosAndSize( aPos, aSize )
   ::ImageRect := NIL
   ::TextRect  := NIL
RETURN ::XbpTabPage:SetPosAndSize(aPos, aSize)


//////////////////////////////////////////////////////////////////////
/// Computes rectangles for text and image rendering
///
/// Notes: o This methods initializes members ::TextRect and
///          ::ImageRect
//////////////////////////////////////////////////////////////////////
METHOD XbpImageTabPage:ComputeLayout( oPS, aInfo )

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
        aImgRect[2] := aTxtRect[2] := aRect[2] + TAB_PADDING
        aImgRect[4] := aTxtRect[4] := aRect[4] - TAB_PADDING
        aTxtRect[1] = aRect[1] + STD_SPACING
        aTxtRect[3] = aRect[3] - Min( (aSize[1] - MIN_SPACING) /2, ;
                      nImgWidth + STD_SPACING + MIN_SPACING )
        aImgRect[1] = aTxtRect[3] + MIN_SPACING
        aImgRect[3] = aRect[3] - STD_SPACING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTTOP
        aImgRect[1] := aTxtRect[1] := aRect[1] + STD_SPACING
        aImgRect[3] := aTxtRect[3] := aRect[3] - STD_SPACING
        aImgRect[2] = aRect[2] + TAB_PADDING
        aImgRect[4] = aRect[2] + Min( (aSize[2] - MIN_SPACING) /2, ;
                      nImgHeight + TAB_PADDING )
        aTxtRect[2] = aImgRect[4] + MIN_SPACING
        aTxtRect[4] = aRect[4] - TAB_PADDING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTRIGHT
        aImgRect[2] := aTxtRect[2] := aRect[2] + TAB_PADDING
        aImgRect[4] := aTxtRect[4] := aRect[4] - TAB_PADDING
        aImgRect[1] = aRect[1] + STD_SPACING
        aImgRect[3] = aImgRect[1] + Min( (aSize[1] - MIN_SPACING) /2, ;
                      nImgWidth + MIN_SPACING )
        aTxtRect[1] = aImgRect[3] + MIN_SPACING
        aTxtRect[3] = aRect[3] - STD_SPACING
     CASE ::CaptionLayout == XBP_LAYOUT_TEXTBOTTOM
        aImgRect[1] := aTxtRect[1] := aRect[1] + STD_SPACING
        aImgRect[3] := aTxtRect[3] := aRect[3] - STD_SPACING
        aImgRect[4] = aRect[4] - TAB_PADDING
        aImgRect[2] = aRect[4] - Min( (aSize[2] - MIN_SPACING) /2, ;
                      nImgHeight + TAB_PADDING )
        aTxtRect[4] = aImgRect[2] - MIN_SPACING
        aTxtRect[2] = aRect[2] + MIN_SPACING
     OTHERWISE
        // XBP_LAYOUT_TEXTCENTER
        aImgRect[1] := aTxtRect[1] := aRect[1] + MIN_SPACING
        aImgRect[3] := aTxtRect[3] := aRect[3] - TAB_PADDING
        aImgRect[2] := aTxtRect[2] := aRect[2] + MIN_SPACING
        aImgRect[4] := aTxtRect[4] := aRect[4] - TAB_PADDING
   ENDCASE

   ::ImageRect := aImgRect
   ::TextRect  := aTxtRect

RETURN

/*
METHOD XbpImageTabPage:ComputeLayout( oPS, aInfo )

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
*/
// EOF