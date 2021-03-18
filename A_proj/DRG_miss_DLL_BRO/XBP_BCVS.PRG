//////////////////////////////////////////////////////////////////////
//
//     xbp_bcvs.prg
//
//  Copyright:
//     Alaska Software, (c) 1997-2009. All rights reserved.         
//
//  Contents :
//
//     XbpMulticellcanvas source code for XbpQuickbrowse
//
//////////////////////////////////////////////////////////////////////

 #include "appevent.ch"
 #include "xbp.ch"
 #include "gra.ch"
 #include "common.ch"

 #include "xbp_brw.ch"

#ifdef RTL_DEBUG
 #define _DBG  
#else
 #define _DBG  NODEBUG
#endif

 /* **********************************************************************
  * This class handles all scrolling of the MultiCellgroup in the browser,
  * it will call the browser navigation functions when the scrollbars
  * are called.
  */
 CLASS XbpMultiCellCanvas FROM XbpStatic

 PROTECTED:

   VAR    nHScrollHeight  _DBG
   VAR    nVScrollWidth   _DBG

 EXPORTED:

   VAR    aSize, aPos                _DBG
   VAR    aSizeHScroll, aPosHScroll  _DBG
   VAR    aSizeVSCroll, aPosVScroll  _DBG
   VAR    aSizeCanvas, aPosCanvas    _DBG

   VAR    oHScroll    _DBG
   VAR    oVScroll    _DBG

   VAR    aVisible    _DBG
   VAR    aInvisible  _DBG

   VAR    lHScroll    _DBG
   VAR    lVScroll    _DBG

   VAR    Style       _DBG

   METHOD Init, Create          /* overloaded lifecycle */
   METHOD Configure
   METHOD SetSize               /* overloaded setsize method */

   METHOD Arrange               /* recalculate the positions of scrollbars */
   METHOD AddItemVertical       /* add one item vertical */
   METHOD ArrangeChildsVertical /* recacculate the y-positions of the childs */
   METHOD ArrangeHScroll        /* apply the scrollbar range of the horizontal scrollbar */

   METHOD GetVisible            /* return visible columns */
   METHOD GetInvisible          /* return invisible columns */
   METHOD RecalcVisible         /* recalculate visible and invisible rows */

   METHOD HScroll               /* scroll the view */
   METHOD VScroll               /* scroll the view */

   METHOD HideHScroll           /* hide scrollbars */
   METHOD HideVScroll
   METHOD ShowHScroll           /* hide scrollbars */
   METHOD ShowVScroll

 ENDCLASS

 /* **********************************************************************
  * Init method of the canvas, we will will basically initialize all our
  * embedded controls here:
  * - scrollbars
  * - background static
  * */
 METHOD XbpMultiCellCanvas:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )

   /* initialization of the static */
   ::XbpStatic:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )
   ::XbpStatic:Type         := XBPSTATIC_TYPE_TEXT
   ::XbpStatic:ClipChildren := TRUE
   ::XbpStatic:ClipSiblings := TRUE

   /* store the params */
   IF !Empty( aSize )
      ::aSize := AClone( aSize )
   ENDIF
   IF !Empty( aPos )
      ::aSize := AClone( aPos )
   ENDIF

   /* we do the following here: we will add the scrollbars to the parent
    * childlist so that we dont have to create another static which
    * hosts the scrollbars and the canvas area
    */
   ::oHScroll := XbpScrollbar():New( oParent, oParent )
   ::oVScroll := XbpScrollbar():New( oParent, oParent )
   ::oVScroll:type := XBPSCROLL_VERTICAL
   ::oVScroll:autoTrack := FALSE
   ::oHScroll:autoTrack := FALSE

   ::lHScroll := TRUE
   ::lVScroll := TRUE

   ::Style    := 0

 RETURN self

 /* **********************************************************************
  * Creation of the control:
  * - create the scrollbars
  * - create the static
  * */
 METHOD XbpMultiCellCanvas:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )

   /* now recalculate the correct scrollbar sizes */
   IF ::lVScroll
      ::nVScrollWidth := xbpGetSystemMetrics( SM_CXVSCROLL )
   ELSE
      ::nVScrollWidth := 0
   ENDIF
   IF ::lHScroll
      ::nHScrollHeight := xbpGetSystemMetrics( SM_CYHSCROLL )
   ELSE
      ::nHScrollHeight := 0
   ENDIF

   /* store the params */
   IF !Empty( aSize )
      ::aSize := AClone( aSize )
   ENDIF
   IF !Empty( aPos )
      ::aPos := AClone( aPos )
   ENDIF
   ::Arrange()

   /* creation of the controls */
   ::XbpStatic:Create( oParent, oOwner, ::aPosCanvas, ::aSizeCanvas, aPP, lVisible )
   ::oHScroll:Create( oParent, oOwner, ::aPosHScroll, ::aSizeHScroll, aPP, lVisible )
   ::oVScroll:Create( oParent, oOwner, ::aPosVScroll, ::aSizeVScroll, aPP, lVisible )

   ::oHScroll:Scroll := { | mp1 | ::HScroll( mp1 ) }

 RETURN self

 /* **********************************************************************
  * Reconfiguration
  * */
 METHOD XbpMultiCellCanvas:Configure( oParent, oOwner, aPos, aSize, aPP, lVisible )

   LOCAL i, aChildlist

   /* store the params */
   IF !Empty( aSize )
      ::aSize := AClone( aSize )
   ENDIF
   IF !Empty( aPos )
      ::aPos := AClone( aPos )
   ENDIF

   /* reconfigure the static */
   ::XbpStatic:Configure( oParent, oOwner, ::aPosCanvas, ::aSizeCanvas, aPP, lVisible )

   /* apply ourself a new size so that the embedded childs match */
   ::SetSize( ::aSize, TRUE )

   /* now reconfigure the childs */
   aChildList  := ::childList()
   FOR i := 1 TO Len( aChildList )
      IF aChildlist[i]:IsDerivedFrom( XbpStatic() )
         aChildlist[i]:Destroy()
         aChildlist[i]:Create()
      ELSEIF aChildlist[i]:IsDerivedFrom( XbpMultiCellgroup() )
         aChildlist[i]:Configure(,,, { -1, aChildlist[i]:CurrentSize()[2] } )
      ENDIF
   NEXT

 RETURN self

 /* **********************************************************************
  * Add one Item horizontal
  * - the item must be in INIT state
  * */
 METHOD XbpMultiCellCanvas:AddItemVertical( oChild, aSize )

   LOCAL aPos, oLastChild, aChilds

   /* now calculate the position of the next child */
   aChilds    := ::ChildList()
   IF !Empty( aChilds )
      oLastChild := ATail( aChilds )
      aPos       := oLastChild:CurrentPos()
   ELSE
      aPos       := ::CurrentSize()
      aPos[1]    := 0
   ENDIF

   /* now we may create it */
   IF Valtype( aSize ) == "A"
      /* use the size assigned to the child */
      oChild:Create( self,,,aSize,, FALSE )
      aSize    := oChild:CurrentSize()
      aPos[2]  -= aSize[2]
      oChild:SetPos( aPos, FALSE )
   ELSE
      /* fit the child so that it matches vertically */
      oChild:Create( self,, { 0, 0 }, { -1, aPos[2] } ,, FALSE )
      aSize    := oChild:CurrentSize()
   ENDIF
   oChild:Show()

   /* now change the horizontal scrollbar */
   ::ArrangeHScroll()

   /* when the first child is added, we need to calculate
    * the visible and invisible columns
    */
   IF Len( ::ChildList() ) == 1
      ::RecalcVisible()
   ENDIF

 RETURN oChild

 /* **********************************************************************
  * Rearrange the canvas elements and apply the new position and size 
  * if necessary
  * */
 METHOD XbpMultiCellCanvas:Arrange( lChangeSizes )

   DEFAULT lChangeSizes TO FALSE

   /* now calculate the sizes and positions of the canvas related objects */
   ::aSizeCanvas  := { ::aSize[1] - ::nVScrollWidth, ::aSize[2] - ::nHScrollHeight }
   ::aPosCanvas   := { 0, ::nHScrollHeight }

   ::aSizeHScroll := { ::aSize[1] - ::nVScrollWidth, ::nHScrollHeight }
   ::aPosHScroll  := { 0, 0 }

   ::aSizeVScroll := { ::nVScrollWidth, ::aSize[2] - ::nHScrollHeight }
   ::aPosVScroll  := { ::aSize[1] - ::nVScrollWidth, ::nHScrollHeight }

   /* now apply the sizes if necessary */
   IF lChangeSizes
      ::oHScroll:SetPosAndSize( ::aPosHScroll, ::aSizeHScroll, TRUE )
      ::oVScroll:SetPosAndSize( ::aPosVScroll, ::aSizeVScroll, TRUE )
      ::XbpStatic:SetPosAndSize( ::aPosCanvas, ::aSizeCanvas,  TRUE ) 
   ENDIF

 RETURN self

 /* **********************************************************************
  * Arrange the positions of the childs
  * */
 METHOD XbpMultiCellCanvas:ArrangeChildsVertical()

   LOCAL oChild, aChilds, aPosChild, aSizeChild
   LOCAL nYPos, i, imax

   /* now calculate the position of the next child */
   aChilds := ::ChildList()
   imax    := Len( aChilds ) - 1
   nYPos   := ::CurrentSize()[2]

   IF imax == 0
      /* when we have only one child, than this is assumed
       * to leave its size as it IS
       */
      oChild    := aChilds[1]
      aPosChild := oChild:CurrentPos()
      nYPos     -= oChild:CurrentSize()[2]
      oChild:SetPos( { aPosChild[1], nYPos }, TRUE )
      RETURN oChild
   ENDIF

   FOR i := 1 TO imax
      /* apply new position to the child */
      oChild    := aChilds[i]
      aPosChild := oChild:CurrentPos()
      nYPos     -= oChild:CurrentSize()[2]
      oChild:SetPos( { aPosChild[1], nYPos }, TRUE )
   NEXT

   /* now the last child is made to fit into the canvas */
   oChild     := aChilds[i]
   aPosChild  := oChild:CurrentPos()
   aSizeChild := oChild:CurrentSize()
   oChild:MaxRow := -1
   oChild:SetPosAndSize ( { aPosChild[1], 0 }, { aSizeChild[1], nYPos }, TRUE )

 RETURN oChild

 /* **********************************************************************
  * Handle the horizontal scrollbar
  * */
 METHOD XbpMultiCellCanvas:HScroll( aScroll )

   LOCAL nCommand := aScroll[2], nNewPos := aScroll[1]
   LOCAL aPos, i, imax, aChilds
   LOCAL nBoxSize := ::CurrentSize()[1]/2
   LOCAL nCanvasWidth := ::CurrentSize()[1]
   LOCAL oHeader      := ::ChildList()[1]

   /* when we scroll area is bigger than the canvas, then we simply return
    */
   IF nCanvasWidth >= oHeader:CurrentSize()[1]
      RETURN self
   ENDIF

   aChilds := ::ChildList()
   imax    := Len( aChilds )

   DO CASE
      CASE nCommand == XBPSB_PREVPOS
         nNewPos := aChilds[1]:CurrentPos()[1] * -1 - nBoxSize
         IF nNewPos < 0
            nNewPos := 0
         ENDIF
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_NEXTPOS
         nNewPos := aChilds[1]:CurrentPos()[1] * -1 + nBoxSize
         IF nNewPos > aChilds[1]:CurrentSize()[1] - ::CurrentSize()[1]
            nNewPos := aChilds[1]:CurrentSize()[1] - ::CurrentSize()[1]
         ENDIF
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_PREVPAGE
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_NEXTPAGE
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_SLIDERTRACK
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         PostAppEvent( xbeBRW_RedrawInvisible, NIL, NIL, ::SetParent() )
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_ENDTRACK
         aChilds := ::ChildList()
         FOR i := 1 TO imax
            aPos    := aChilds[i]:CurrentPos()
            aPos[1] := nNewPos * -1
            aChilds[i]:SetPos( aPos )
         NEXT
         IF ::oHScroll:IsVisible() .AND. ::oHScroll:IsEnabled()
            ::oHScroll:SetData( nNewPos )
         ENDIF
      CASE nCommand == XBPSB_ENDSCROLL
         /* recalc visible */
         ::SetParent():HandleEvent( xbeBRW_RedrawInvisible, NIL, NIL )
         ::RecalcVisible()
   ENDCASE

 RETURN self

 /* **********************************************************************
  * Handle the vertical scrollbar
  * */
 METHOD XbpMultiCellCanvas:VScroll()
    /* not handled here, the browser will handle the vertical scrollbar */
 RETURN self

 /* **********************************************************************
  * Inquire the currently visible columns
  * */
 METHOD XbpMultiCellCanvas:GetVisible()
 RETURN ::aVisible

 /* **********************************************************************
  * Inquie the currently invisible columns
  * */
 METHOD XbpMultiCellCanvas:GetInvisible()
 RETURN ::aInvisible

 /* **********************************************************************
  * Recalculate invisible and visible columns
  * */
 METHOD XbpMultiCellCanvas:RecalcVisible()
    LOCAL nCanvasWidth
    LOCAL oHeader
    LOCAL nLeftOffset
    LOCAL i, nWidth := 0, nPos := 0, nColCount

    nCanvasWidth := ::CurrentSize()[1]
    i            := AScan( ::ChildList(), {|o|o:IsDerivedFrom(XbpMultiCellgroup())} )
    oHeader      := ::ChildList()[i]
    IF Empty( oHeader )
       RETURN self
    ENDIF
    nLeftOffset  := oHeader:CurrentPos()[1]
    nColCount    := oHeader:ColCount()
    ::aVisible   := Array( 0 )
    ::aInvisible := Array( 0 )

    /* iterate over all columns and check their visibility state 
     */
    FOR i := 1 TO nColCount
       nWidth := oHeader:GetColWidth( i )
       IF ( ( nPos + nWidth ) + nLeftOffset >= 0                   .AND. ;
            ( nPos + nWidth ) + nLeftOffset <= nCanvasWidth )      .OR.  ;
            ; // -> left edge of col is in visible area
          ( ( nPos + nLeftOffset >= 0 )                            .AND. ;
            ( nPos + nLeftOffset <= nCanvasWidth ) )               .OR.  ;
            ; // -> right edge of col is in visible area
          ( ( nPos + nLeftOffset < 0 )                             .AND. ;
            ( ( nPos + nWidth ) + nLeftOffset >= nCanvasWidth ) )  .OR.  ;
            ; // -> column is too wide to fit in the visible area, but
            ; //   is in the visible area
            ( nWidth > 0 .AND. nColCount == 1 )
              // -> we have only one column

          AAdd( ::aVisible, i )
       ELSE
          AAdd( ::aInvisible, i )
       ENDIF
       nPos += nWidth
    NEXT

    /* by default we have at least one visible column
     */
    IF Empty( ::aVisible ) .AND. nColCount > 0
       AAdd( ::aVisible, 1 )
    ENDIF

 RETURN self

 /* **********************************************************************
  * Change the size of the object
  * */
 METHOD XbpMultiCellCanvas:SetSize( aNewSize, lRedraw )

    LOCAL lRet := TRUE

    DEFAULT lRedraw TO TRUE

    /* first rearrange, this will also change the sizes */
    ::aSize := AClone( aNewSize )
    ::LockUpdate( TRUE )
    ::Arrange( TRUE )

    /* now check whether we have to scroll home */
    IF ::ChildList()[1]:CurrentSize()[1] < ::aSize[1]
       AEval( ::ChildList(), { |o| o:setPos( { 0, o:CurrentPos()[2] }, FALSE ) } )
    ENDIF
 
    /* now change the horizontal scrollbar */
    ::ArrangeHScroll()

    /* rearrange childs */
    ::ArrangeChildsVertical()

    /* recalculate the visible columns */
    ::RecalcVisible()

    /* now redraw */
    ::LockUpdate( FALSE )
    IF lRedraw
       ::InvalidateRect()
    ENDIF

 RETURN lRet


 /* **********************************************************************
  * Change the size of the object
  * */
 METHOD XbpMultiCellCanvas:ArrangeHSCroll()

    LOCAL aSize := ATail(::ChildList()):CurrentSize()
    LOCAL nData := ::oHScroll:GetData()
    LOCAL aChilds, i, imax, aPos

    /* verify whether the scrollbars points to a position that
     * is behind our width (this might happen when cols are
     * resized/deleted)
     */
    IF nData > aSize[1] - ::CurrentSize()[1]
       nData := 0
    ENDIF

    /* when we do not need a scrollbar because the width of all
     * columns is less than our width, then we will hide the scrollbars
     * by simply setting their size to zero
     */
    IF ::ChildList()[1]:CurrentSize()[1] < ::CurrentSize()[1] .AND. ::nHScrollHeight > 0
       ::HideHScroll()
    ELSEIF  ::ChildList()[1]:CurrentSize()[1] >= ::CurrentSize()[1] .AND. ::nHScrollHeight == 0
       ::ShowHScroll()
    ENDIF

    /* set scrollbar range/data
     */
    ::oHScroll:SetRange( { 0, aSize[1] - ::CurrentSize()[1] } )
    ::oHScroll:SetScrollboxSize( ::CurrentSize()[1] )
    ::oHSCroll:SetData( nData )

    /* now reposition all childs so that they reflect scrollbar
     * settings
     */
    aChilds := ::ChildList()
    imax    := Len( aChilds )
    FOR i := 1 TO imax
       aPos    := aChilds[i]:CurrentPos()
       aPos[1] := nData * -1
       aChilds[i]:SetPos( aPos )
    NEXT

 RETURN self

 /* **********************************************************************
  * Hide the horizontal scrollbar
  * */
 METHOD XbpMultiCellCanvas:HideHScroll()
    IF 0 == ::nHScrollHeight
       RETURN FALSE
    ENDIF
    ::nHScrollHeight := 0
    ::Arrange( TRUE )
    ::ArrangeChildsVertical()
    ::oHScroll:Hide()

    PostAppEvent( xbeP_Resize, ::SetParent():CurrentSize(), ;
                  ::SetParent():CurrentSize(), ::SetParent(), TRUE )
 RETURN TRUE

 /* **********************************************************************
  * Hide the vertical scrollbar
  * */
 METHOD XbpMultiCellCanvas:HideVScroll()
    IF 0 == ::nVScrollWidth
       RETURN FALSE
    ENDIF
    ::nVScrollWidth := 0
    ::Arrange( TRUE )
    ::RecalcVisible()
    ::oVScroll:Hide()

    PostAppEvent( xbeP_Resize, ::SetParent():CurrentSize(), ;
                  ::SetParent():CurrentSize(), ::SetParent(), TRUE )
 RETURN TRUE

 /* **********************************************************************
  * Show the horizontal scrollbar
  * */
 METHOD XbpMultiCellCanvas:ShowHScroll()
    IF 0 != ::nHScrollHeight
       RETURN FALSE
    ENDIF
    ::nHScrollHeight := xbpGetSystemMetrics( SM_CYHSCROLL )
    ::Arrange( TRUE )
    ::ArrangeChildsVertical()
    ::oHScroll:Show()

    PostAppEvent( xbeP_Resize, ::SetParent():CurrentSize(), ;
                  ::SetParent():CurrentSize(), ::SetParent(), TRUE )
 RETURN TRUE

 /* **********************************************************************
  * Show the vertical scrollbar
  * */
 METHOD XbpMultiCellCanvas:ShowVScroll()
    IF 0 != ::nVScrollWidth
       RETURN FALSE
    ENDIF
    ::nVScrollWidth := xbpGetSystemMetrics( SM_CYHSCROLL )
    ::Arrange( TRUE )
    ::RecalcVisible()
    ::oVScroll:Show()

    PostAppEvent( xbeP_Resize, ::SetParent():CurrentSize(), ;
                  ::SetParent():CurrentSize(), ::SetParent(), TRUE )
 RETURN TRUE

 // EOF
