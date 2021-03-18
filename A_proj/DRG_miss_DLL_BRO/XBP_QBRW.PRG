//////////////////////////////////////////////////////////////////////
//
//     xbp_qbrw.prg
//
//  Copyright:
//     Alaska Software, (c) 1997-2010. All rights reserved.         
//
//  Contents :
//
//     XbpQuickbrowse source code
//
//////////////////////////////////////////////////////////////////////

 #include "appevent.ch"
 #include "xbp.ch"
 #include "gra.ch"
 #include "common.ch"
 #include "types.ch"
 #include "dac.ch"
 #include "dll.ch"
 #include "os.ch"

 #include "xbp_brw.ch"

 #PRAGMA LIBRARY( "ADAC20B.LIB" )

 /* **********************************************************************
  * Internal storage
  */
 STATIC aStyleTrans := { XBP_STYLE_3D,   ;  // SYSTEMDEFAULT
                         XBP_STYLE_3D,   ;  // PLAIN
                         XBP_STYLE_3D,   ;  // 3D
                         NIL,            ;  // undefined 
                         XBP_STYLE_FANCY ;  // FANCY
                       }


 /* **********************************************************************
  * APIs and low-level interfaces
  */
 #define SPI_GETWHEELSCROLLLINES  104

 STATIC DLLFUNCTION SystemParametersInfoA( uiAction, uiParam, @pvParam, fWinIni ) ;
    USING STDCALL ;
    FROM USER32.DLL


 /* **********************************************************************
  * Some Helper Macros
  */

 /* Macro to extract data from DacPagedDataStore:GetRowData */
 #xtrans DAC_Data(<aData>)                                        ;
     => <aData>\[2]

 /* Macro to extract record ID DacPagedlocate:GetRowData */
 #xtrans DAC_RecId(<aData>)                                       ;
     => <aData>\[1]

 /* Macro to locate record ID */
 #xtrans QB_RecordId(<nRow>)                                      ;
     => IF( <nRow> > 0 .AND. <nRow> <= Len( ::VisibleRecords ),   ;
            self:VisibleRecords\[<nRow>], NIL )

 /* Macro to locate the row which displays the given record */
 #xtrans QB_RecordRow(<nId>)                                      ;
     => AScan( self:VisibleRecords, <nId> )

 /* Macro to store the record Id on given row */
 #xtrans QB_StoreRecordId(<nRow>,<nId>)                           ;
     => self:VisibleRecords\[<nRow>] := <nId>

 /* Macro to calculate the block size */
 #xtrans QB_CalcBlockSize(<nRowCount>)                            ;
     => IF ( <nRowCount> > 8, Int( <nRowCount> / 3 ) + 1, Int( <nRowCount> ) )

 /* Macro to check stable state, this is the case when the invalid
  * range[1] == { 0 } */
 #xtrans QB_IsStable()                                            ;
     => ( ::Invalid\[1] == 0 )

 /* function to generate headers out of dacFieldInfo Objects
  */
 STATIC FUNCTION qbGetDefaultHeader( oDataStore )
    LOCAL aName, aCaption, aRet
    LOCAL i, imax

    /* now iterate over the list of fieldinfo structures and 
     * generate the header string
     */
    aName    := oDataStore:GetRowInfo( DAC_FIELD_NAME )
    aCaption := oDataStore:GetRowInfo( DAC_FIELD_CAPTION )
    imax := Len( aName )
    aRet := Array( imax )
    FOR i := 1 TO imax
       IF !Empty( aCaption[i] )
          aRet[i] := aCaption[i]
       ELSE
          aRet[i] := aName[i]
       ENDIF
    NEXT
 RETURN aRet

 /* function to inquire the datatypes of the columns
  */
 STATIC FUNCTION qbGetTypes( oDatastore )
    LOCAL aType    := oDatastore:GetRowInfo( DAC_FIELD_VALTYPE )
    LOCAL aPicture := oDatastore:GetRowInfo( DAC_FIELD_PICTURE )
    LOCAL aRet     := Array( Len( aType ) ), i, imax
    imax := Len( aRet )
    FOR i := 1 TO imax
       aRet[i] := { aType[i], XBPCOL_TYPE_TEXT, aPicture[i] }
    NEXT
 RETURN aRet


#ifdef RTL_DEBUG
 #define _DBG  
#else
 #define _DBG  NODEBUG
#endif


 /* **********************************************************************
  *
  * Our new quick and lean table browser.
  *
  */
 CLASS XbpQuickbrowse FROM XbpStatic, DataRef

#ifdef RTL_DEBUG
 EXPORTED:
#else
 PROTECTED:
#endif
   /* the internal objects */
   VAR Canvas            _DBG   /* the scrolling canvas (XbpCanvas) */

   VAR Invalid           _DBG   /* the invalid rows on the screen 
                                 * {0,0} indicates that the object is stable */
   VAR RedrawInvisible   _DBG   /* flag which indicates that invisible cols
                                   have TO be repainted */
   VAR IsHilite          _DBG   /* TRUE when we are currently hilited */

   VAR VisibleRecords    _DBG   /* the currently visible record IDs */

   VAR OldColPos         _DBG   /* this ivar stores the colpos before 
                                 * endstabstabilize IS called */

   VAR SetHeader         _DBG   /* the array containing the set heading data */

 EXPORTED:
   VAR NavigationList    _DBG   /* the internal navigation queue */
   VAR CurrentRecord     _DBG   /* the current record ID (note: this is not
                                   equal to ::RowPos) */

   VAR VScrollObject            /* the vertical scrollbar object (XbpScrollbar) */
   VAR HScrollObject            /* the horizontal scrollbar object (XbpScrollbar) */

   VAR Heading                  /* the heading object (XbpMultiCellGroup) */
   VAR Footing           _DBG   /* the footing object (XbpMultiCellGroup) */
   VAR DataArea                 /* the data area object (XbpMultiCellGroup) */
   VAR Separator         _DBG   /* the separator between heading and dataarea (XbpStatic) */

   /* the exported ivars */
   VAR RowCount     READONLY    /* the rowcount */
   VAR ColCount     READONLY    /* the column count */
   VAR Style                    /* the style of the object (3d, plain, fancy) */
   VAR BlockSize                /* the size of a stabilization frame */
   VAR RowPos                   /* the current row */
   VAR ColPos                   /* the current column */

   VAR HScroll, VScroll         /* flags for enabling the scrollbars */
   VAR SoftTrack         _DBG   /* flags for softrack mode */
   VAR SizeCols          _DBG   /* flags for sizeable columns */
   VAR AutoSize                 /* flags for autoadjust width */
   VAR CursorMode               /* the cursor mode of the browser */
   VAR AlwaysShowSelection      /* flag to toggle visibility of mark when the object
                                 * does not have input focus */
   VAR DrawMode                 /* One of XBP_DRAW_NORMAL, XBP_DRAW_OWNERADVANCED
                                 * or XBP_DRAW_OWNER */
   ASSIGN METHOD SetDrawMode() VAR DrawMode

   /* Callback slots */
   VAR ItemMarked               /* a item was marked */
   VAR ItemSelected             /* a item was selected */

   VAR BeginStabilize           /* called on begin of stabilization */
   VAR EndStabilize             /* called when browser is stable */


    VAR CustomDrawCell          /* Called during owner-drawing */

   /* --------------------------------------------------------------- */

   /* Lifecycle */
   METHOD Init, Create          /* lifecycle */
   METHOD Destroy               /*     "     */
   METHOD Configure             /* reconfiguration */

   /* Overloaded */
   METHOD HandleEvent 

   METHOD Keyboard              /* keyboard navigation */
   METHOD SetSize               /* overloaded adjusting the size */
   METHOD SetPosAndSize         /* overloaded adjusting the pos and size */
   METHOD GetData               /* inquire the currently marked items */
   METHOD EditBuffer            /* inquire the currently marked items */
   METHOD SetInputFocus         /* set input focus callback */
   METHOD KillInputFocus        /* kill input focus callback */
   METHOD Resize                /* resize calback */
   METHOD SetDatalink           /* specify a new datalink for the object */
   METHOD ApplyTypes            /* apply the data types to the columns */

   /* Navigation */
   METHOD Up, Down, Left, Right /* the cursor navigation */
   METHOD PageDown, PageUp      /* the cursor page navigation */
   METHOD GoTop, GoBottom       /* Navigation */
   METHOD PanFirstCol           /* the panel navigation */
   METHOD PanLastCol
   METHOD PanLeft, PanRight     /* panel scrolling */
   METHOD ScrollDown, ScrollUp  /* scrolling the current visible records */
   METHOD GoToRecord            /* navigate to record ID */

   /* Display */
   METHOD ForceStable           /* full stabilization */
   METHOD Stabilize             /* incremental stabilization */
   METHOD RedrawInvisible       /* redraw invisible cols */
   METHOD Hilite, DeHilite      /* hiliting */
   METHOD RefreshAll            /* refreshing */
   METHOD RefreshRows           /* refreshing of specified rows */
   METHOD Invalidate            /* set invalid range */
   METHOD Validate              /* reset invalid range */
   METHOD DrawRow               /* draw a specific row */

   /* Other stuff */
   METHOD CellRect              /* inquire cell rectangle */
   METHOD SetHeader             /* set the heading */
   METHOD GetHeader             /* get the current visible heading */

   METHOD SetUseVisualStyle

   /* Process  scrollbar */
   METHOD VScroll               /* vertical scrollbar */

   /* Callback methods */
   METHOD ItemMarked            /* a item was marked */
   METHOD ItemSelected          /* a item was selected */
   METHOD CustomDrawCell        /* Cell must be redrawn through owner-drawing */

   /* Column Management */
   METHOD SetColType            /* change the column datatype and representation */
   METHOD GetColType            /* inquire the column datatype and representation */
   METHOD SetColRepresentation  /* change the representation of the datatypes */
   METHOD GetColRepresentation  /* inquire the representation of the datatypes */
   METHOD SetColWidth           /* change the column width */
   METHOD GetColWidth           /* inquire the column width */
   METHOD SetRowHeight          /* change the row height */
   METHOD GetRowHeight          /* inquire the row height */
   METHOD SetColAlignment       /* change the column alignment */
   METHOD GetColAlignment       /* inquire the column alignment */

   /* presparam */
   METHOD SetColorFG            /* overload presparam setting */
   METHOD SetColorBG

 PROTECTED:

   /* Internal stuff */
   METHOD BeginStabilize        /* starting stabilization */
   METHOD EndStabilize          /* finish stabilization */
   METHOD ProcessNavigation     /* traverse and execute the navigation list */
   METHOD BindDataProvider      /* bind new data provider */

 EXPORTED:
   /* Debugging */
   METHOD CheckBuffer

 ENDCLASS


 /* **********************************************************************
  * The Init method
  * */
 METHOD XbpQuickbrowse:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )

  LOCAL lOld, nTmp

    /* initialize static baseclass */
    ::XbpStatic:Init( oParent, oOwner, aPos, aSize, aPP, lVisible )
    ::XbpStatic:Type := XBPSTATIC_TYPE_TEXT
    ::XbpStatic:ClipChildren := TRUE

    /* now initialize the embedded objects */
    ::Canvas     := XbpMultiCellCanvas():New( self )

    /* The cellgroup objects must exist in :init() state. Otherwise
     * we cannot pass a reference array to get the column width
     * calculated upon :create(). It doesn't make sense to call
     * :setColWidth() immediately after browser creation.
     */
    ::Heading    := XbpMultiCellGroup():New( self, self,, { -1, 10 } )
    ::DataArea   := XbpMultiCellGroup():New( self, self,, { -1, 100 } )

    IF IsThemeActive(.T.) == .T. 
       ::Heading:StyleClass := "Header"
       ::Heading:ControlState := XBP_STATE_NORMAL

       lOld := Set( _SET_FIXED, .F. )
       nTmp := Val( SubStr(OS(OS_VERSION),1,5) )
       Set( _SET_FIXED, lOld )
       IF nTmp >= 6.0 
          ::DataArea:StyleClass := "Explorer::Listview"
       ENDIF
    ENDIF

    /* the navigation request storage */
    ::NavigationList := NavigationQueue():New()

    /* the internal variables */
    ::Invalid    := { 0, 0 }
    ::RedrawInvisible := TRUE
    ::IsHilite   := FALSE

    /* row & col position */
    ::RowPos     := 1
    ::ColPos     := 1
    ::OldColPos  := 1

    /* the exported flags */
    ::SoftTrack  := FALSE
    ::AutoSize   := FALSE
    ::HScroll    := TRUE
    ::VScroll    := TRUE
    ::CursorMode := XBPBRW_CURSOR_ROW
    ::AlwaysShowSelection := TRUE
    ::DrawMode   := XBP_DRAW_NORMAL

    /* initialize the style flags */
    ::Style      := XBP_STYLE_SYSTEMDEFAULT
   
 RETURN self

 /* **********************************************************************
  * Creation of the control
  * */
 METHOD XbpQuickbrowse:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )

    LOCAL aStringSize, aHeader, aData

    IF IsThemeActive(.F.) == .F. .OR. ::Style != XBP_STYLE_SYSTEMDEFAULT
       ::UseVisualStyle := .F.
    ENDIF
    
    /* initialize static baseclass */
    ::XbpStatic:Create( oParent, oOwner, aPos, aSize, aPP, lVisible )

    /* Register object on the data   */
    /* source and prefetch a row of  */
    /* of data for computing columns */
    /* etc. */
    ::DataLink:BindView( self )
    aHeader     := qbGetDefaultHeader( ::DataLink )
    aData       := ::DataLink:GetRowData( 1 )

    ::ColCount  := Len( aHeader )

    IF !Empty( aHeader )
       aStringSize := xbpQueryStringSize( self, aHeader[1] )
    ELSE
       aStringSize := xbpQueryStringSize( self, " " )
    ENDIF

    /* now we do the following: since the headers and the data might have
     * a different length we basically calculate a default string which
     * represents the MAX( lDataStr, lHeaderStr ) values.
     */
    IF Empty( ::Heading:ReferenceArray )
      ::Heading:ReferenceArray := _qbGetReferenceString( NIL, aHeader )
    ENDIF

    IF Empty( ::dataArea:ReferenceArray )
      ::dataArea:ReferenceArray := ;
         _qbGetReferenceString( ::Heading:ReferenceArray, DAC_Data( aData ) )
    ELSE
      ::dataArea:ReferenceArray := ;
         _qbGetReferenceString( ::heading:ReferenceArray, ::dataArea:ReferenceArray )
    ENDIF

    ::heading:ReferenceArray := AClone( ::dataArea:ReferenceArray )

    /* create the canvas */
    ::Canvas:lHScroll := ::HScroll
    ::Canvas:lVScroll := ::VScroll
    ::Canvas:Style    := ::Style
    ::Canvas:Create( self, self, { 0, 0 }, ::CurrentSize() )

    /* create the heading and add it to the canvas */
    ::Heading:MaxCol     := ::ColCount
    ::Heading:Style      := aStyleTrans[::Style+1]
    ::Heading:DrawMode   := ::DrawMode
    ::Canvas:AddItemVertical( ::Heading, { -1, aStringSize[2] + 10 } )

    /* add a horizontal line as separator */
    IF ::Style != XBP_STYLE_SYSTEMDEFAULT
       ::Separator := XbpStatic():New( self, self )
       ::Separator:type := XBPSTATIC_TYPE_TEXT
       ::Canvas:AddItemVertical( ::Separator, { ::Heading:CurrentSize()[1], 2 } )
       ::Separator:SetColorBG( XBPSYSCLR_3DFACE )
    ENDIF

    /* configure and add the data area to the canvas */
    ::DataArea:MaxCol     := ::ColCount
    ::DataArea:Style      := ::Style
    ::DataArea:DrawMode   := ::DrawMode

    /* provide callbacks for our subcomponents */
    ::DataArea:itemMarked   := { |aPos, mp2, oXbp| qbGotoItem( self, aPos ) }
    ::DataArea:itemSelected := { |aPos, mp2, oXbp| PostAppEvent( xbeBRW_ItemSelected, ;
                                                                 aPos,;
                                                                 NIL, ;
                                                                 self ) }
    ::DataArea:LbDown     := { || IF( !::HasInputFocus(), SetAppFocus( self ), ) }
    ::Heading:CustomDrawCell  := { |mp1,mp2,obj| ForwardCustomDrawCell(mp1, mp2, obj) }
    ::DataArea:CustomDrawCell := { |mp1,mp2,obj| ForwardCustomDrawCell(mp1, mp2, obj) }
    ::Heading:LbDown         :=  { || IF(!::HasInputFocus(), SetAppFocus(self),)}

    /* add the Data Area Object */
    ::Canvas:AddItemVertical( ::DataArea )

    /* we don't have a footing yet */
    ::Footing  := NIL   /* NYI */

    /* apply the data types */
    ::ApplyTypes()

    /* now assign the scrollbar objects */
    ::HScrollObject := ::Canvas:oHScroll
    ::VScrollObject := ::Canvas:oVScroll
    ::VScrollObject:Scroll := { | mp1 | ::VScroll ( mp1 ) }
    IF !Empty( ::HSCrollObject )
       ::HSCrollObject:LbDown := { || IF( !::HasInputFocus(), SetAppFocus( self ), ) }
    ENDIF
    IF !Empty( ::VSCrollObject )
       ::VSCrollObject:LbDown := { || IF( !::HasInputFocus(), SetAppFocus( self ), ) }
    ENDIF

    /* now we are able to determine our rowcount */
    ::RowCount := ::DataArea:RowCount()

    /* initialize the remaining IVars */
    ::BlockSize      := QB_CalcBlockSize( ::RowCount )
    ::VisibleRecords := Array( ::RowCount )

    /* we should make sure that we set the pagesize on the browser
     * only after we initialized the browser
     */
    ::DataLink:SetAbsolutePageSize( ::RowCount )

    /* when we know the rowcount we are able to invalidate ourself */
    ::Invalidate( 1, ::RowCount )

    /* now perform first stabilization and draw our headers */
    ::ForceStable()
    ::SetHeader( aHeader )
    ::SetHeader := NIL

    /* after the first stabilization we have all visible records, now
     * we may determine the current record id and hilite by
     * requesting the input focus */
    ::CurrentRecord  := QB_RecordId( ::RowPos )
    ::Hilite()

 RETURN self

 /* **********************************************************************
  * Destruction
  * */
 METHOD XbpQuickbrowse:Destroy()

    /* unbind myself from datalink */
    IF ValType(::DataLink) == "O"
       ::DataLink:BindView( NIL )
    ENDIF

 RETURN ::XbpStatic:Destroy()

 /* **********************************************************************
  * Reconfiguration
  * */
 METHOD XbpQuickbrowse:Configure( oParent, oOwner, aPos, aSize, aPP, lVisible )

    LOCAL aHeader, aData

    /* reconfigure our parent class */
    ::XbpStatic:Configure( oParent, oOwner, aPos, aSize, aPP, lVisible )

    /* the navigation request storage must be reinitialized in order to
     * clear pending navigation requests
     */
    ::NavigationList := NavigationQueue():New()

    /* Register object on the data   */
    /* source and prefetch a row of  */
    /* of data for computing columns */
    /* etc. */
    ::DataLink:BindView( self )
    aHeader := qbGetDefaultHeader( ::DataLink )
    aData   := ::DataLink:GetRowData( 1 )

    ::ColCount := Len( aHeader )

    /* now we do the following: since the headers and the data might have
     * a different length we basically calculate a default string which
     * represents the MAX( lDataStr, lHeaderStr ) values.
     */
   ::Heading:ReferenceArray  := _qbGetReferenceString( NIL, aHeader )
   ::dataArea:ReferenceArray := ;
         _qbGetReferenceString( ::Heading:ReferenceArray, DAC_Data( aData ) )
   ::heading:ReferenceArray := AClone( ::dataArea:ReferenceArray )

    /* configure the canvas */
    ::Canvas:lHScroll := ::HScroll
    ::Canvas:lVScroll := ::VScroll
    ::Canvas:Style    := ::Style

    /* configure the heading */
    ::Heading:MaxCol  := ::ColCount
    ::Heading:Style   := aStyleTrans[::Style+1]

    /* add a horizontal line as separator */
    IF !Empty( ::Separator )
       ::Separator:type := XBPSTATIC_TYPE_BGNDFRAME
    ENDIF

    /* add the data area to the canvas */
    ::DataArea:MaxCol := ::ColCount
    ::DataArea:Style  := ::Style

    /* now reconfigure all childs so that we are able to determine the 
     * changed rowcount and stuff 
     */
    ::LockUpdate( TRUE )
    AEval( ::ChildList(), { | o | o:Configure() } )
    IF !Empty( ::Separator )
       ::Separator:setSize( { ::Heading:CurrentSize()[1], ;
                              ::Separator:CurrentSize()[2] } )
    ENDIF

    /* apply the data types */
    ::ApplyTypes()

    /* now we are able to determine our rowcount */
    ::RowCount := ::DataArea:RowCount()
    ::DataLink:SetAbsolutePageSize( ::RowCount )

    /* initialize the remaining IVars */
    ::Canvas:ArrangeHScroll()
    ::Canvas:RecalcVisible()
    ::BlockSize      := QB_CalcBlockSize( ::RowCount )
    ::VisibleRecords := Array( ::RowCount )

    /* when we know the rowcount we are able to invalidate ourself */
    ::Invalidate( 1, ::RowCount )
    ::ForceStable()

    /* draw our headers */
    ::SetHeader( aHeader )
    ::SetHeader := NIL

    /* after the first stabilization we have all visible records, now
     * we may determin the current record id and hilite */
    ::CurrentRecord  := QB_RecordId( ::RowPos )
    ::Hilite()

    ::LockUpdate( FALSE )
    ::InvalidateRect()

 RETURN self

 /* **********************************************************************
  * Previous row
  * */
 METHOD XbpQuickbrowse:Up( lSetRowPos )
    DEFAULT lSetRowPos TO TRUE
    IF lSetRowPos
       ::NavigationList:Add( XBPBRW_Navigate_PrevLine )
    ELSE
       ::NavigationList:Add( XBPBRW_Navigate_VScroll, -1 )
    ENDIF
    PostAppEvent( xbeBRW_Stabilize, lSetRowPos, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Next row
  * */
 METHOD XbpQuickbrowse:Down( lSetRowPos )
    DEFAULT lSetRowPos TO TRUE
    IF lSetRowPos
       ::NavigationList:Add( XBPBRW_Navigate_NextLine )
    ELSE
       ::NavigationList:Add( XBPBRW_Navigate_VScroll, 1 )
    ENDIF
    PostAppEvent( xbeBRW_Stabilize, lSetRowPos, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Next Page
  * */
 METHOD XbpQuickbrowse:PageDown( lSetRowPos )
    DEFAULT lSetRowPos TO TRUE
    ::NavigationList:Add( XBPBRW_Navigate_NextPage )
    PostAppEvent( xbeBRW_Stabilize, lSetRowPos, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Previous page
  * */
 METHOD XbpQuickbrowse:PageUp( lSetRowPos )
    DEFAULT lSetRowPos TO TRUE
    ::NavigationList:Add( XBPBRW_Navigate_PrevPage )
    PostAppEvent( xbeBRW_Stabilize, lSetRowPos, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Navigation to previous column
  * */
 METHOD XbpQuickbrowse:Left()
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::NavigationList:Add( XBPBRW_Navigate_PrevCol )
       PostAppEvent( xbeBRW_Stabilize, FALSE, NIL, self, TRUE )
    ELSE
       ::PanLeft()
    ENDIF
 RETURN self

 /* **********************************************************************
  * Navigation to next column
  * */
 METHOD XbpQuickbrowse:Right()
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::NavigationList:Add( XBPBRW_Navigate_NextCol )
       PostAppEvent( xbeBRW_Stabilize, FALSE, NIL, self, TRUE )
    ELSE
       ::PanRight()
    ENDIF
 RETURN self

 /* **********************************************************************
  * Scroll the panel TO the right
  * */
 METHOD XbpQuickbrowse:PanLeft()
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_PREVPOS }, NIL )
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_ENDSCROLL }, NIL )
 RETURN self

 /* **********************************************************************
  * Scroll the panel TO the left
  * */
 METHOD XbpQuickbrowse:PanRight()
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_NEXTPOS }, NIL )
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_ENDSCROLL }, NIL )
 RETURN self

 /* **********************************************************************
  * Scroll to first column
  * */
 METHOD XbpQuickbrowse:PanFirstCol()
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::Dehilite()
    ENDIF
    /* TODO: this needs to be done with the navigation queue
     */
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_SLIDERTRACK }, NIL )
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_ENDSCROLL }, NIL )
    IF ::HScrollObject:IsVisible() .AND. ::HScrollObject:IsEnabled()
       ::HScrollObject:SetData( 0 )
    ENDIF
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::ColPos := 1
       ::Hilite()
    ENDIF
 RETURN self

 /* **********************************************************************
  * Scroll to last column
  * */
 METHOD XbpQuickbrowse:PanLastCol()
    LOCAL aRange := ::HScrollObject:SetRange()
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::Dehilite()
    ENDIF
    /* TODO: this needs to be done with the navigation queue
     */
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { aRange[2], XBPSB_SLIDERTRACK }, NIL )
    ::HScrollObject:HandleEvent( xbeSB_Scroll, { aRange[2], XBPSB_ENDSCROLL }, NIL )
    IF ::HScrollObject:IsVisible() .AND. ::HScrollObject:IsEnabled()
       ::HScrollObject:SetData( aRange[2] )
    ENDIF
    IF ::CursorMode == XBPBRW_CURSOR_CELL
       ::ColPos := ::ColCount
       ::Hilite()
    ENDIF
 RETURN self

 /* **********************************************************************
  * Navigate to first record in the dataset
  * */
 METHOD XbpQuickbrowse:GoBottom()
    ::NavigationList:Add( XBPBRW_Navigate_GoBottom )
    PostAppEvent( xbeBRW_Stabilize, NIL, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Navigate to last record in the dataset
  * */
 METHOD XbpQuickbrowse:GoTop()
    ::NavigationList:Add( XBPBRW_Navigate_GoTop )
    PostAppEvent( xbeBRW_Stabilize, NIL, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Process the pending navigation events on the browser
  * */
 METHOD XbpQuickbrowse:ProcessNavigation()

    LOCAL aNav := NIL, nRows := 0, aData, nPos := 0
    LOCAL nRowPos

    /* optimize the navigation queue
     */
    ::NavigationList:Optimize()

    /* process all pending navigation requests
     */
    WHILE !Empty( aNav := ::NavigationList:Get() )

       DO CASE

          /* *************************************************************
           * goto percentage position
           */
          CASE aNav[1] == XBPBRW_Navigate_GoPos
             /* goto percentage position and invalidate */
             nPos := aNav[2]
             WHILE !Empty( aNav := ::NavigationList:Peek() )
                IF aNav[1] == XBPBRW_Navigate_GoPos
                   aNav := ::NavigationList:Get()
                   nPos := aNav[2]
                ELSE
                   EXIT
                ENDIF
             ENDDO
             ::DataLink:GoPos( nPos )
             /* now we may scroll when we only skipped a small number of records */
             aData := ::DataLink:GetRowData( 1 )
             nRows := AScan( ::VisibleRecords, DAC_RecId( aData ) )
             IF nRows > 1
                /* the first row was moved up, so scroll up */
                ::ScrollUp( nRows - 1 )
             ELSEIF nRows == 0
                /* the first row is not visible anymore, now we
                 * check whether the last row was previously visible somewhere 
                 * in the screen and scroll if necessary */
                aData := ::DataLink:GetRowData( ::DataLink:RowCount() )
                nRows := AScan( ::VisibleRecords, DAC_RecId( aData ) )
                IF nRows > 1
                   /* the first row was moved down, so scroll down */
                   ::ScrollDown( ::DataLink:RowCount() - nRows )
                ELSE
                   /* neither the first nor the last row were visible
                    * before, so we know now that we cannot scroll and
                    * will repaint the complete screen */
                   ::Dehilite()
                   ::Invalidate( 1, ::RowCount )
                ENDIF
             ELSE /* nRows == 1 */
                /* the first row is still the first row, so we will do nothing */
             ENDIF

          /* *************************************************************
           * goto top of file
           */
          CASE aNav[1] == XBPBRW_Navigate_GoTop
             /* dehilite */
             IF ::RowPos != 1
                ::Dehilite()
             ENDIF
             /* gotop and invalidate the whole screen */
             ::DataLink:GoFirst()
             ::RowPos := 1
             ::Invalidate( 1, ::RowCount )

          /* *************************************************************
           * goto bottom of file
           */
          CASE aNav[1] == XBPBRW_Navigate_GoBottom
             /* dehilite */
             ::Dehilite()
             /* gobottom and invalidate the whole screen */
             ::DataLink:GoLast()
             ::RowPos := ::DataLink:RowCount()
             /* when we have the cursor on the last row, then it is better
              * to scroll up one row as the last row may only be parly
              * visible 
              */
             IF ::RowPos == ::RowCount
                /* ::rowPos is adjusted in :scrolldown() */
                ::ScrollUp( ::DataLink:ScrollDown( 1 ) )
             ENDIF
             ::Invalidate( 1, ::RowCount )

          /* *************************************************************
           * goto previous page
           */
          CASE aNav[1] == XBPBRW_Navigate_PrevPage
             /* dehilite */
             ::Dehilite()
             /* goto previous page and invalidate the whole screen */
             IF ::DataLink:isFirst()
                /* bumped against Bof() */
                ::rowPos := 1
             ELSE
                ::DataLink:GoPrev()
             ENDIF
             ::Invalidate( 1, ::RowCount )

          /* *************************************************************
           * goto next page
           */
          CASE aNav[1] == XBPBRW_Navigate_NextPage
             /* dehilite */
             ::Dehilite()
             /* goto next page and invalidate the whole screen */
             IF ::DataLink:isLast()
                /* bumped against Eof() */
                ::rowPos := IF( ::DataLink:RowCount() == ::RowCount, ;
                                ::RowCount - 1, ::DataLink:RowCount() )
             ELSE
                ::DataLink:GoNext()
             ENDIF
             ::Invalidate( 1, ::RowCount )

          /* *************************************************************
           * goto next line
           */
          CASE aNav[1] == XBPBRW_Navigate_NextLine
             /* dehilite */
             ::Dehilite()
             /* lets see whether we have some pending nextline events and 
                process these also first */
             nRows := 1
             WHILE !Empty( aNav := ::NavigationList:Peek() )
                IF aNav[1] == XBPBRW_Navigate_NextLine
                   aNav := ::NavigationList:Get()
                   nRows++
                ELSE
                   EXIT
                ENDIF
             ENDDO
             /* now perform navigation */
             ::RowPos := QB_RecordRow( ::CurrentRecord )
             IF !Empty( ::RowPos ) .AND. ::RowPos + nRows < ::RowCount
                ::RowPos += nRows
                IF ::DataLink:isLast() .AND. ::rowPos > ::DataLink:RowCount()
                   /* bumped against Eof() */
                   ::rowPos := IF( ::DataLink:RowCount() == ::RowCount, ;
                                   ::RowCount - 1, ::DataLink:RowCount() )
                ENDIF
                ::RedrawInvisible := TRUE
             ELSE
                ::ScrollUp( ::DataLink:ScrollDown( nRows ) )
                ::RowPos := Min( ::RowCount - 1, ::DataLink:RowCount() )
             ENDIF

          /* *************************************************************
           * goto previous line
           */
          CASE aNav[1] == XBPBRW_Navigate_PrevLine
             /* dehilite */
             ::Dehilite()
             /* lets see whether we have some pending prevline events and 
                process these also first */
             nRows := 1
             WHILE !Empty( aNav := ::NavigationList:Peek() )
                IF aNav[1] == XBPBRW_Navigate_PrevLine
                   aNav := ::NavigationList:Get()
                   nRows++
                ELSE
                   EXIT
                ENDIF
             ENDDO
             /* now perform navigation */
             ::RowPos := QB_RecordRow( ::CurrentRecord )
             IF !Empty( ::RowPos ) .AND. ::RowPos - nRows >= 1
                ::RowPos -= nRows
                ::RedrawInvisible := TRUE
             ELSE
                ::ScrollDown( ::DataLink:ScrollUp( nRows ) )
                ::RowPos := 1
             ENDIF

          /* *************************************************************
           * scroll up
           */
          CASE aNav[1] == XBPBRW_Navigate_VScroll .AND. aNav[2] > 0
             /* ScrollUp:
              * Lets see whether we have some pending scroll events and
              * process these also first
              */
             nRows := 1
             WHILE !Empty( aNav := ::NavigationList:Peek() )
                IF aNav[1] == XBPBRW_Navigate_VScroll .AND. aNav[2] > 0
                   aNav := ::NavigationList:Get()
                   nRows++
                ELSE
                   EXIT
                ENDIF
             ENDDO
             /* now perform navigation */
             ::ScrollUp( ::DataLink:ScrollDown( nRows ) )

          /* *************************************************************
           * goto previous column
           */
          CASE aNav[1] == XBPBRW_Navigate_PrevCol
             /* dehilite */
             ::Dehilite()
             /* now verify wether the column matches in the visible area
              * and scroll if necessary
              */
             IF AScan( ::Canvas:GetVisible(), ::ColPos ) <= 2
                ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_PREVPOS }, NIL )
                ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_ENDSCROLL }, NIL )
             ENDIF
             /* decrease column position
              */
             IF ::ColPos > 1
                ::ColPos--
             ENDIF

          /* *************************************************************
           * goto next column
           */
          CASE aNav[1] == XBPBRW_Navigate_NextCol
             /* dehilite */
             ::Dehilite()
             /* now verify wether the column matches in the visible area
              * and scroll if necessary
              */
             IF ::ColPos + 1 == ::ColCount
                ::HScrollObject:HandleEvent( xbeSB_Scroll, { ::HScrollObject:SetRange()[2], ;
                                                             XBPSB_SLIDERTRACK }, NIL )
                ::HScrollObject:HandleEvent( xbeSB_Scroll, { ::HScrollObject:SetRange()[2], ;
                                                             XBPSB_ENDSCROLL }, NIL )
             ELSE
                WHILE AScan( ::Canvas:GetVisible(), ::ColPos ) >= Len( ::Canvas:GetVisible() ) - 1 ;
                      .AND. ! ( ATail( ::Canvas:GetVisible() ) == ::ColCount )
                  ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_NEXTPOS }, NIL )
                  ::HScrollObject:HandleEvent( xbeSB_Scroll, { 0, XBPSB_ENDSCROLL }, NIL )
                ENDDO
             ENDIF

             /* increase column position
              */
             IF ::ColPos < ::ColCount
                ::ColPos++
             ENDIF

          /* *************************************************************
           * scroll down
           */
          CASE aNav[1] == XBPBRW_Navigate_VScroll .AND. aNav[2] < 0
             /* ScrollDown:
              * Lets see whether we have some pending scroll events and
              * process these also first
              */
             nRows := 1
             WHILE !Empty( aNav := ::NavigationList:Peek() )
                IF aNav[1] == XBPBRW_Navigate_VScroll .AND. aNav[2] < 0
                   aNav := ::NavigationList:Get()
                   nRows++
                ELSE
                   EXIT
                ENDIF
             ENDDO
             /* now perform navigation */
             ::ScrollDown( ::DataLink:Scrollup( nRows ) )

          /* *************************************************************
           * scroll horizontally
           */
          CASE aNav[1] == XBPBRW_Navigate_HScroll
             /* NYI */

          /* *************************************************************
           * goto item in browser
           */
          CASE aNav[1] == XBPBRW_Navigate_GotoItem
             /* activate the given row */
             IF !Empty( QB_RecordId( aNav[2,1] ) ) .AND. ;
                ( ::RowPos != aNav[2,1] .OR. ::ColPos != aNav[2,2] )
                /* dehilite */
                ::Dehilite()
                /* now we have to set our new position */
                ::RowPos := aNav[2,1]
                IF ::RowPos == ::RowCount
                   /* ::rowPos is adjusted in :scrolldown() */
                   ::ScrollUp( ::DataLink:ScrollDown( 1 ) )
                ENDIF
                ::ColPos := aNav[2,2]
             ENDIF
             ::RedrawInvisible := TRUE

          /* *************************************************************
           * goto specific record id
           */
          CASE aNav[1] == XBPBRW_Navigate_GotoRecord
             /* navigate to given record */
             nPos    := aNav[2]
             nRowPos := QB_RecordRow( nPos )
             IF !Empty( nRowPos ) .AND. nRowPos < ::RowCount
                ::Dehilite()
                ::CurrentRecord := nPos
                ::RowPos        := nRowPos
             ELSE
                IF( ::DataLink:ScrollTo( nPos ) )
                   ::Dehilite()
                   ::Invalidate( 1, ::RowCount )
                   ::CurrentRecord := nPos
                   ::RowPos        := 1
                ENDIF
             ENDIF
       ENDCASE
    ENDDO

 RETURN self

 /* **********************************************************************
  * Perform full stabilization
  * */
 SYNC METHOD XbpQuickbrowse:ForceStable( lSetRowPos, lSetScrollbar )

    LOCAL aData, i
    LOCAL nColsVisible, nRowsVisible
    LOCAL aColsVisible

    DEFAULT lSetRowPos    TO TRUE
    DEFAULT lSetScrollbar TO TRUE

    /* Begin stabilization 
     */
    IF !::BeginStabilize( lSetRowPos, lSetScrollbar )
       RETURN self
    ENDIF

    /* now stabilize the invalid area
     */
    aColsVisible := ::Canvas:GetVisible()
    nColsVisible := Len( aColsVisible )
    nRowsVisible := ::Invalid[2] - ::Invalid[1] + 1

    FOR i := ::Invalid[1] TO ::Invalid[2]
       /* get the row and set respective */
       /* cell values                    */
       aData := ::DataLink:GetRowData( i )
       IF nColsVisible > 0
          ::DrawRow( i, aColsVisible[1], DAC_Data( aData ), nColsVisible, FALSE )
       ENDIF

       /* store the record number */
       QB_StoreRecordId( i, DAC_RecId( aData ) )
    NEXT

    /* Redraw the region */
    IF nColsVisible > 0
       ::DataArea:DrawCell( ::Invalid[1], aColsVisible[1], nRowsVisible, nColsVisible )
    ENDIF

    /* we are stable
     */
    ::EndStabilize( lSetRowPos, lSetScrollbar )

 RETURN self

 /* **********************************************************************
  * Perform incremental stabilization
  * */
 SYNC METHOD XbpQuickbrowse:Stabilize( lSetRowPos, lSetScrollbar )

    LOCAL aData, i, k
    LOCAL nVisible, aVisible

    DEFAULT lSetRowPos    TO TRUE
    DEFAULT lSetScrollbar TO TRUE

    /* Begin stabilization 
     */
    IF ! ::BeginStabilize( lSetRowPos, lSetScrollbar )
       RETURN self
    ENDIF

    /* now we may stabilize the invalid area
     */
    i := ::Invalid[1]
    k := 1
    aVisible := ::Canvas:GetVisible()
    nVisible := Len( aVisible )

    WHILE i <= ::Invalid[2] .AND. k <= ::BlockSize
       /* get the row and  set respective */
       /* cell values                     */
       aData := ::DataLink:GetRowData( i )
       IF nVisible > 0
          ::DrawRow( i, aVisible[1], DAC_Data( aData ), nVisible, FALSE )
       ENDIF

       /* store the record number */
       QB_StoreRecordId( i, DAC_RecId( aData ) )

       /* now increase counters */
       i++
       k++
    ENDDO
    IF nVisible > 0
       ::DataArea:DrawCell( ::Invalid[1], aVisible[1], i, nVisible )
    ENDIF

    /* now we did stabilize some rows, now we change the invalid range and repost
     * a message that we are supposed to continue stabilization
     */
    ::Invalid[1] := i
    IF ::Invalid[1] <= ::Invalid[2]
       /* force the next stabilization cycle
        */
       IF !PostAppEvent( xbeBRW_Stabilize, lSetRowPos, lSetScrollbar, self, TRUE )
          ::ForceStable()
       ENDIF
    ELSE
       /* we are stable
        */
       ::EndStabilize( lSetRowPos, lSetScrollbar )
    ENDIF

 RETURN self

 /* **********************************************************************
  * Perform full stabilization
  * */
 SYNC METHOD XbpQuickbrowse:RedrawInvisible()

    LOCAL aData, i
    LOCAL nInvisible, aInvisible, nRow

    /* redraw only when we are invisible
     */
    IF !::RedrawInvisible
       RETURN self
    ENDIF

    /* when we dont have rows then we do nothing
     */
    IF ::RowCount == 0
       RETURN self
    ENDIF

    /* Evaluate the beginstabilize codeblock */
    IF ValType( ::BeginStabilize ) == "B"
       Eval( ::BeginStabilize, NIL, NIL, self )
    ENDIF

    /* now stabilize the whole view
     */
    aInvisible := ::Canvas:GetInvisible()
    nInvisible := Len( aInvisible )
    IF nInvisible == 0
       ::RedrawInvisible := FALSE
       RETURN self
    ENDIF

    FOR i := 1 TO ::RowCount

       /* get the row and set respective */
       /* cell values                    */
       aData := ::DataLink:GetRowData( i )
       ::DrawRow( i, aInvisible[1], DAC_Data( aData ), ::ColCount, FALSE )

    NEXT
    ::DataArea:DrawCell( 1, aInvisible[1], ::RowCount, nInvisible )

    /* now hilite
     */
    nRow := QB_RecordRow( ::CurrentRecord )
    IF !Empty( nRow ) .AND. ::IsHilite == TRUE
       IF ::CursorMode == XBPBRW_CURSOR_ROW
          FOR  i := 1 TO ::ColCount
             ::DataArea:HiliteCell( nRow, i, TRUE )
          NEXT
       ELSEIF ::CursorMode == XBPBRW_CURSOR_CELL
          ::DataArea:HiliteCell( nRow, ::ColPos, TRUE )
       ENDIF
    ENDIF

    ::RedrawInvisible := FALSE

    /* Evaluate the endstabilize codeblock */
    IF ValType( ::EndStabilize ) == "B"
       Eval( ::EndStabilize, NIL, NIL, self )
    ENDIF

 RETURN self


 /* **********************************************************************
  * Draw one browser row
  * */
 METHOD XbpQuickbrowse:DrawRow( nRow, nCol, aValues, nCols, lRedraw )
 RETURN ::DataArea:SetRange( nRow, nCol, aValues, 1, nCols,,, lRedraw )


 /* **********************************************************************
  * Perform hilite on the browser
  * */
 METHOD XbpQuickbrowse:Hilite()
    LOCAL i, nRow
    LOCAL nVisible, aVisible

    /* in case we dont always show the selection, we simply return */
    IF !::HasInputFocus() .AND. ::AlwaysShowSelection == FALSE
       RETURN self
    ENDIF

    /* perform hiliting */
    nRow := QB_RecordRow( ::CurrentRecord )
    IF !Empty( nRow )
       IF ::CursorMode == XBPBRW_CURSOR_ROW
          aVisible := ::Canvas:GetVisible()
          nVisible := Len( aVisible )
          FOR  i := 1 TO nVisible
             ::DataArea:HiliteCell( nRow, aVisible[i], TRUE )
          NEXT
       ELSEIF ::CursorMode == XBPBRW_CURSOR_CELL
          ::DataArea:HiliteCell( nRow, ::ColPos, TRUE )
       ENDIF
    ENDIF
    ::IsHilite := TRUE

 RETURN self

 /* **********************************************************************
  * Remove hiliting from current hilited row
  * */
 METHOD XbpQuickbrowse:DeHilite()
    LOCAL i, nRow
    LOCAL nVisible, aVisible

    IF !::IsHilite
       RETURN self
    ENDIF

    /* perform dehiliting */
    nRow := QB_RecordRow( ::CurrentRecord )
    IF !Empty( nRow )
       IF ::CursorMode == XBPBRW_CURSOR_ROW
          aVisible := ::Canvas:GetVisible()
          nVisible := Len( aVisible )
          FOR  i := 1 TO nVisible
             ::DataArea:HiliteCell( nRow, aVisible[i], FALSE )
          NEXT
       ELSEIF ::CursorMode == XBPBRW_CURSOR_CELL
          ::DataArea:HiliteCell( nRow, ::ColPos, FALSE )
       ENDIF
    ENDIF
    ::IsHilite := FALSE

 RETURN self

 /* **********************************************************************
  * Reload the complete screeen
  * */
 METHOD XbpQuickbrowse:RefreshAll( lStabilize, lGotop )

    DEFAULT lStabilize TO TRUE
    DEFAULT lGoTop     TO FALSE

    /* invalidate the screen */
    ::Invalidate( 1, ::RowCount )
    /* gotop if necessary */
    IF lGotop
       ::RowPos := 1
    ENDIF
    /* now stabilize if necessary */
    IF lStabilize
       ::ForceStable()
    ENDIF

 RETURN self

 /* **********************************************************************
  * Reload onle some rows
  * */
 METHOD XbpQuickbrowse:RefreshRows( nStart, nStop, lStabilize )

    DEFAULT lStabilize TO TRUE

    /* invalidate the screen */
    ::Invalidate( nStart, nStop )
    /* now stabilize if necessary */
    IF lStabilize
       ::ForceStable()
    ENDIF

 RETURN self

 /* **********************************************************************
  * inquire cell rectangle
  * */
 METHOD XbpQuickbrowse:CellRect( nRow, nCol )
    DEFAULT nRow TO ::RowPos
    DEFAULT nCol TO ::ColPos
 RETURN ::DataArea:CellRect( nRow, nCol )

 /* **********************************************************************
  * keyboard callback
  * */
 METHOD XbpQuickbrowse:Keyboard( nKey )

    DO CASE
       CASE nKey == xbeK_CTRL_UP
          ::Up( FALSE )
       CASE nKey == xbeK_CTRL_DOWN
          ::Down( FALSE )
       CASE nKey == xbeK_UP
          ::Up()
       CASE nKey == xbeK_DOWN
          ::Down()
       CASE nKey == xbeK_PGDN
          ::PageDown()
       CASE nKey == xbeK_PGUP
          ::PageUp()
       CASE nKey == xbeK_CTRL_PGDN
          ::GoBottom()
       CASE nKey == xbeK_CTRL_PGUP
          ::GoTop()
       CASE nKey == xbeK_RIGHT
          ::Right()
       CASE nKey == xbeK_LEFT
          ::Left()
       CASE nKey == xbeK_END  .OR. nKey == xbeK_CTRL_RIGHT
          ::PanLastCol()
       CASE nKey == xbeK_HOME .OR. nKey == xbeK_CTRL_LEFT
          ::PanFirstCol()
       CASE nKey == xbeK_ENTER .OR. nKey == xbeK_RETURN
          PostAppEvent( xbeBRW_ItemSelected, { ::RowPos, ::ColPos }, NIL, self )
       OTHERWISE
          ::setParent():keyboard( nKey )
    ENDCASE

 RETURN self


 /* **********************************************************************
  * overloaded handleevent method
  * */
 METHOD XbpQuickbrowse:HandleEvent( nEvent, mp1, mp2 )

    LOCAL i, xRet

    DO CASE

    CASE nEvent == xbeBRW_Stabilize
       ::Stabilize( mp1, mp2 )
       RETURN self

    CASE nEvent == xbeBRW_ForceStable
       ::ForceStable( mp1, mp2 )
       RETURN self

    CASE nEvent == xbeBRW_RedrawInvisible
       ::RedrawInvisible( mp1, mp2 )
       RETURN self

    CASE nEvent == xbeBRW_ItemMarked
       ::ItemMarked( mp1, mp2 )
       IF ValType( ::ItemMarked ) == "B"
          Eval( ::ItemMarked, mp1, mp2, self )
       ENDIF

    CASE nEvent == xbeBRW_ItemSelected
       ::ItemSelected( mp1, mp2 )
       IF ValType( ::ItemSelected ) == "B"
          Eval( ::ItemSelected, mp1, mp2, self )
       ENDIF

    CASE nEvent == xbeM_Wheel
       i := 0
       SystemParametersInfoA( SPI_GETWHEELSCROLLLINES, 0, @i, 0 )
       IF i < 0
          i := ::RowCount
       ENDIF
       i := Abs( (Mp2[2] / 120) * i)

       DO WHILE i > 0 
          IF mp2[2] < 0
             ::Down(FALSE)
          ELSE
             ::Up(FALSE)
          ENDIF

          i--
       ENDDO

    CASE nEvent == xbeP_CustomDrawCell
       xRet := ::CustomDrawCell( mp1, mp2 )
       IF ValType(::CustomDrawCell) == "B" 
          xRet := Eval(::CustomDrawCell, mp1, mp2, Self )
       ENDIF

       RETURN xRet
    ENDCASE

 RETURN ::XbpStatic:HandleEvent( nEvent, mp1, mp2 )

 /* **********************************************************************
  * invalidate the given rows
  * */
 METHOD XbpQuickbrowse:Invalidate( nStartRow, nEndRow )

    DEFAULT nStartRow TO 1
    DEFAULT nEndRow   TO ::RowCount

    IF ::Invalid[1] == 0
       /* the invalid range was empty before, so simply use the specified 
        * range */
       ::Invalid[1] := nStartRow
       ::Invalid[2] := nEndRow
    ENDIF

    /* make sure that the positions are valid */
    ::Invalid[1] := Min( ::RowCount, Max( 1, Min( nStartRow, ::Invalid[1] ) ) )
    ::Invalid[2] := Min( ::RowCount, Max( 1, Max( nEndRow  , ::Invalid[2] ) ) )

    /* we have to redraw the invisible cols */
    ::RedrawInvisible := TRUE
 RETURN self

 /* **********************************************************************
  * validate the object
  * */
 METHOD XbpQuickbrowse:Validate()

    /* we have to redraw the invisible cols */
    ::Invalid[1] := ::Invalid[2] := 0

 RETURN self

 /* **********************************************************************
  * scroll the list and not the datasource
  * */
 METHOD XbpQuickbrowse:ScrollDown( nScroll )

    IF nScroll != 0 

       /* scroll records */
       ::DataArea:ScrollDown( nScroll )

       /* scroll invalid area */
       IF !Empty( ::Invalid[1] )
          ::Invalid[1] += nScroll
          IF ::Invalid[1] > ::RowCount
             ::Invalid[1] := ::RowCount
          ENDIF
          ::Invalid[2] += nScroll
          IF ::Invalid[2] > ::RowCount
             ::Invalid[2] := ::RowCount
          ENDIF
       ENDIF
       ::Invalidate( 1, nScroll )

       /* now scroll visible record ids */
       IF nScroll < ::RowCount
          ACopy( ::VisibleRecords, ::VisibleRecords, 1, ::RowCount - nScroll, 1 + nScroll )
       ELSE
          AFill( ::VisibleRecords, NIL )
       ENDIF

       /* adjust rowpos */
       ::RowPos += nScroll
       IF ::RowPos > ::RowCount
          ::RowPos := 0
       ENDIF
    ENDIF
 RETURN self

 /* **********************************************************************
  * scroll the list and not the datasource
  * */
 METHOD XbpQuickbrowse:ScrollUp( nScroll )

    IF nScroll != 0 

       /* scroll records */
       ::DataArea:ScrollUp( nScroll )

       /* scroll invalid area */
       IF !Empty( ::Invalid[1] )
          ::Invalid[1] -= nScroll
          IF ::Invalid[1] < 1
             ::Invalid[1] := 1
          ENDIF
          ::Invalid[2] -= nScroll
          IF ::Invalid[2] < 1
             ::Invalid[2] := 1
          ENDIF
       ENDIF
       ::Invalidate( ::RowCount - nScroll, ::RowCount )

       /* now scroll visible record ids */
       IF nScroll < ::RowCount
          ACopy( ::VisibleRecords, ::VisibleRecords, nScroll + 1,, 1 )
       ELSE
          AFill( ::VisibleRecords, NIL )
       ENDIF

       /* adjust rowpos */
       ::RowPos -= nScroll
       IF ::RowPos < 0 
          ::RowPos := 0
       ENDIF
    ENDIF
 RETURN self

 /* **********************************************************************
  * called when the stabilization cycle starts
  * */
 METHOD XbpQuickbrowse:BeginStabilize( lSetRowPos, lSetScrollbar )

   /* when we dont have rows then we do nothing
    */
   IF ::RowCount == 0
      RETURN FALSE
   ENDIF

   /* Evaluate the beginstabilize codeblock */
   IF ValType( ::BeginStabilize ) == "B"
      Eval( ::BeginStabilize, NIL, NIL, self )
   ENDIF

   /* process the pending navigation requests 
    */
   ::ProcessNavigation()


   /* when we dont have rows then we do nothing
    */
   IF QB_IsStable()
      ::EndStabilize( lSetRowPos, lSetScrollbar )
      RETURN FALSE
   ENDIF

 RETURN TRUE

 /* **********************************************************************
  * called when the stabilization IS ready
  * */
 METHOD XbpQuickbrowse:EndStabilize( lSetRowPos, lSetScrollbar )
   LOCAL nPos, aRange := { 0, 0 }, nRelPageSize
   LOCAL lastRecord

   IF ValType(::DataLink) != "O"
      RETURN self
   ENDIF

   /* inquire the values and position indicators of the scrollbars */
   nPos         := ::DataLink:GetPos()
   nRelPageSize := ::DataLink:GetRelativePageSize()
   IF lSetScrollbar
      aRange[1]    := 0
      aRange[2]    := 100
      ::VScrollObject:SetData( nPos )
      ::VScrollObject:SetRange( aRange )
      ::VScrollObject:SetScrollboxSize( nRelPageSize )
   ENDIF

   /* we are stable, now validate */
   ::Validate()

   /* display the hiliting bar */
   lastRecord := ::CurrentRecord
   IF !Empty( ::RowPos ) .AND. lSetRowPos
      ::CurrentRecord  := QB_RecordId( ::RowPos )
      IF ::CurrentRecord == 0 .AND. ::RowPos > 1
         /* We hit the end of the table
          * Make sure that a row containing data is hilited
          */
         nPos     := AScan( ::visibleRecords, 0 ) - 1
         ::RowPos := Max( 1, nPos )
         ::CurrentRecord := QB_RecordId( ::RowPos )
      ENDIF
   ELSEIF lSetRowPos == FALSE
      /* when the row position differs from the current
       * record, then we will set this position. This might
       * happen when the scrollbar is used and the row
       * position needs to be adjusted
       */
      nPos := AScan( ::visibleRecords, ::CurrentRecord )
      IF nPos != 0
         ::RowPos := nPos
      ELSE
         ::RowPos := 0
      ENDIF
   ENDIF
   ::Hilite()

   /* Evaluate the endstabilize codeblock */
   IF ValType( ::EndStabilize ) == "B"
      Eval( ::EndStabilize, NIL, NIL, self )
   ENDIF

   /* now we may post ourself a itemmarked event which has occured
    * We post ItemMarked only:
    * - when the current record has changed
    * - when the column position has changed
    */
   IF lastRecord != ::CurrentRecord .OR. ;
      ( ::OldColPos != ::ColPos .AND. ::CursorMode != XBPBRW_CURSOR_ROW )
      PostAppEvent( xbeBRW_ItemMarked, { ::RowPos, ::ColPos }, NIL, self )
      ::OldColPos := ::ColPos
   ENDIF

   /* now make sure that the screen contents match the stored contents
    */
   ::CheckBuffer()

 RETURN self

 /* **********************************************************************
  * provide default handling FOR the vertical scrollbar
  * */
 METHOD XbpQuickbrowse:VScroll( mp1 )
   LOCAL  nCommand := mp1[2], nNewPos := mp1[1]

   DO CASE
      CASE nCommand == XBPSB_PREVPOS
         ::Up( FALSE )
      CASE nCommand == XBPSB_NEXTPOS
         ::Down( FALSE )
      CASE nCommand == XBPSB_PREVPAGE
         ::PageUp( FALSE )
      CASE nCommand == XBPSB_NEXTPAGE
         ::PageDown( FALSE )
      CASE nCommand == XBPSB_SLIDERTRACK
         IF !::SoftTrack
            ::NavigationList:Add( XBPBRW_Navigate_GoPos, nNewPos )
            PostAppEvent( xbeBRW_Stabilize, FALSE, FALSE, self, TRUE )
         ENDIF
      CASE nCommand == XBPSB_ENDTRACK
         ::NavigationList:Add( XBPBRW_Navigate_GoPos, nNewPos )
         PostAppEvent( xbeBRW_Stabilize, FALSE, NIL, self, TRUE )
      CASE nCommand == XBPSB_ENDSCROLL
         /* nothing to be done here */
   ENDCASE

 RETURN self

 /* **********************************************************************
  * overloaded setsize handling
  * */
 METHOD XbpQuickbrowse:SetSize( aNewSize, lRedraw )

   LOCAL lRet

   DEFAULT lRedraw TO TRUE

   /* first we have to dehilite */
   ::DeHilite()

   /* apply the new size to the canvas */
   ::Canvas:SetSize( aNewSize, FALSE )

   /* we might change the size of the static now */
   lRet := ::XbpStatic:SetSize( aNewSize, lRedraw )

 RETURN lRet

 /* **********************************************************************
  * overloaded setsize handling
  * */
 METHOD XbpQuickbrowse:SetPosAndSize( aNewPos, aNewSize, lRedraw )

   LOCAL lRet

   DEFAULT lRedraw TO TRUE

   /* first we have to dehilite */
   ::DeHilite()

   /* apply the new size to the canvas */
   ::Canvas:SetSize( aNewSize, FALSE )

   /* we might change the size of the static now */
   lRet := ::XbpStatic:SetPosAndSize( aNewPos, aNewSize, lRedraw )

 RETURN lRet

 /* **********************************************************************
  * Overloaded focus handling to perform dehiliting
  * */
 METHOD XbpQuickbrowse:Resize( mp1, mp2 )

   /* we are able to determine our rowcount */
   ::RowCount := Int( ::DataArea:RowCount() )

   ::DataLink:SetAbsolutePageSize( ::RowCount )

   /* initialize the remaining IVars */
   ::BlockSize      := QB_CalcBlockSize( ::RowCount )
   ::VisibleRecords := Array( ::RowCount )

   /* now stabilize */
   ::Validate()
   ::Invalidate( 1, ::RowCount )
   ::Stabilize()

 RETURN ::XbpStatic:ReSize( mp1, mp2 )

 /* **********************************************************************
  * Callback for marked item
  * */
 METHOD XbpQuickbrowse:ItemMarked()
 RETURN self

 /* **********************************************************************
  * Callback for selected item
  * */
 METHOD XbpQuickbrowse:ItemSelected()
 RETURN self

 /* **********************************************************************
  * ASSIGN method of :DrawMode instance variable
  * */
 METHOD XbpQuickbrowse:SetDrawMode( nMode )

   IF ValType(nMode) != "N"
      XbpException():RaiseParameterType( {nMode} )
   ENDIF

   ::DrawMode := nMode
   
   IF ValType(::Heading) == "O"
      ::Heading:DrawMode := nMode
   ENDIF
   IF ValType(::DataArea) == "O"
      ::DataArea:DrawMode := nMode
   ENDIF
   IF ValType(::Footing) == "O"
      ::Footing:DrawMode := nMode
   ENDIF

 RETURN self

 /* *********************************************************************
  * Cell must be redrawn through owner-drawing. If :DrawMode has been set
  * to "XBP_DRAW_OWNER", "xbeP_CustomDrawCell" is generated immediately 
  * after the background of the cell has been cleared, but before the 
  * value of the cell is rendered. If the browser is to perform default 
  * processing for this event (i.e. render the cell value), the 
  * application must return TRUE. If :DrawMode is "XBP_DRAW_OWNERADVANCED", 
  * "xbeP_CustomDrawCell" is send immediately before the individual cell 
  * elements (its background, frame and foreground) is rendered. The 
  * browser does not perform any default rendering, unless the application 
  * returns TRUE. 
  *
  *  Array "aInfo" has the following format:
  *    <aInfo> : {{nRow,nCol}, nAction, nState, aRect, oArea} 
  *    nRow   : Row that must be redrawn
  *    nAction: XBP_DRAWACTION_DRAWALL,   
  *             XBP_DRAWACTION_SELCHANGE,
  *             XBP_DRAWACTION_FOCUSCHANGE,
  *             XBP_DRAWACTION_DRAWBG (advanced mode only),        
  *             XBP_DRAWACTION_DRAWFRAME ( - " - ),
  *             XBP_DRAWACTION_DRAWFG (advanced mode only)
  *    nState : XBP_DRAWSTATE_SELECTED,
  *             XBP_DRAWSTATE_DISABLED,
  *             XBP_DRAWSTATE_FOCUS
  *    aRect  : Update rectangle
  *    oArea  : Column area that contains the cell
  * */
 METHOD XbpQuickBrowse:CustomDrawCell( oPS, aInfo )
    UNUSED( oPS )
    UNUSED( aInfo )
 RETURN .T.

 /* **********************************************************************
  * Set the heading of the browser
  * */
 METHOD XbpQuickbrowse:SetHeader( aHeader )
    LOCAL l := Min( ::ColCount, Len( aHeader ) )

    ::Heading:SetRange( 1, 1, aHeader, 1, l )
    ::Heading:InvalidateRect()
    ::SetHeader := AClone( aHeader )
    IF Len( ::SetHeader ) < ::ColCount 
       ASize( ::SetHeader, ::ColCount )
    ENDIF

 RETURN self


 /* **********************************************************************
  * Get the heading of the browser
  * */
 METHOD XbpQuickbrowse:GetHeader()

  LOCAL aHeader := Array( ::ColCount ), i

    IF !Empty( ::SetHeader )
       RETURN AClone( ::SetHeader )
    ENDIF

    FOR i := 1 TO ::ColCount
       aHeader[i] := ::Heading:GetCell( 1, i )
    NEXT

 RETURN aHeader

 /* **********************************************************************
  * Inquire the currently marked record number
  * */
 METHOD XbpQuickbrowse:GetData()
 RETURN ::EditBuffer()

 /* **********************************************************************
  * Inquire the currently marked record number
  * */
 METHOD XbpQuickbrowse:EditBuffer()
 RETURN ::CurrentRecord

 /* **********************************************************************
  * Set/Get the datalink
  * */
 METHOD XbpQuickbrowse:SetDataLink( oDataLink )
    LOCAL oOld := ::DataLink

    IF PCount() == 0
       RETURN ::DataLink
    ENDIF
    /* store the new datalink */
    ::DataLink := oDatalink
    /* reconfigure the datalink */
    IF !Empty( oOld )
       ::BindDataProvider( oDatalink )
    ENDIF
 RETURN oDataLink

 /* **********************************************************************
  * Apply the datatypes and picture to the columns, we also
  * change the alignment if necessary
  * */
 METHOD XbpQuickbrowse:ApplyTypes()
    LOCAL aType   
    LOCAL aPicture
    LOCAL i, l

    aType    := ::Datalink:GetRowInfo( DAC_FIELD_VALTYPE )
    aPicture := ::Datalink:GetRowInfo( DAC_FIELD_PICTURE )
    l        := Len( aType )

    FOR i := 1 TO l
       /* when we encounter a picture we will use this
        */
       IF Empty( aPicture[i] )
          ::SetColType( i, aType[i], XBPCOL_TYPE_TEXT )
       ELSE
          ::SetColType( i, aType[i], XBPCOL_TYPE_TEXT, aPicture[i] )
       ENDIF
       /* numerics will be right aligned
        */
       IF aType[i] == "N"
          ::DataArea:SetAlignment( i, XBPALIGN_RIGHT + XBPALIGN_VCENTER )
       ENDIF
    NEXT
 RETURN self

 /* **********************************************************************
  * Change the datatype of a column
  * */
 METHOD XbpQuickbrowse:SetColType( nColumn, nDataType, nDisplayType, cPicture )
    ::DataArea:SetColType( nColumn, nDataType, nDisplayType, cPicture )
 RETURN self

 /* **********************************************************************
  * Inquire the datatype of a column
  * */
 METHOD XbpQuickbrowse:GetColType( nColumn )
 RETURN ::DataArea:GetColType( nColumn )

 /* **********************************************************************
  * Change the alignment of a column
  * */
 METHOD XbpQuickbrowse:SetColAlignment( nColumn, nAlign )
    ::DataArea:SetAlignment( nColumn, nAlign )
 RETURN self

 /* **********************************************************************
  * Inquire the aligment of a column
  * */
 METHOD XbpQuickbrowse:GetColAlignment( nColumn )
 RETURN ::DataArea:GetAlignment( nColumn )

 /* **********************************************************************
  * Change the representation for the given column
  * */
 METHOD XbpQuickbrowse:SetColRepresentation( nColumn, xRepresentation )
    // NOTE: the notation below is a currently undocumented compiler
    //       notation which forwards all parameters of this method
    //       to the called method
    xRepresentation := xRepresentation   // surpress warning
    nColumn         := nColumn           // surpress warning
    ::DataArea:SetColRepresentation( CONTEXT.PARAMLIST )
 RETURN self

 /* **********************************************************************
  * Inquire the representation for the given column
  * */
 METHOD XbpQuickbrowse:GetColRepresentation( nColumn, xValue )
 RETURN ::DataArea:GetColRepresentation( nColumn, xValue )

 /* **********************************************************************
  * Change the column width for the given column
  * */
 METHOD XbpQuickbrowse:SetColWidth( nWidth, nColumn, lArrange )
    LOCAL nOldWidth := ::DataArea:GetColWidth( nColumn )
    LOCAL aSize     := ::DataArea:CurrentSize()

    DEFAULT lArrange TO TRUE

    /* adjust size of data area */
    aSize[1] += nWidth - nOldWidth
    ::DataArea:SetSize( aSize )
    ::DataArea:SetColWidth( nWidth, nColumn )
    IF !Empty( ::Separator )
       ::Separator:SetSize( { aSize[1], 2 } )
    ENDIF

    /* adjust size of heading */
    aSize := ::Heading:CurrentSize()
    aSize[1] += nWidth - nOldWidth
    ::Heading:SetSize( aSize )
    ::Heading:SetColWidth( nWidth, nColumn )

    /* now recalculate and redraw invisible cols */
    IF lArrange
       ::Canvas:ArrangeHScroll()
       ::RedrawInvisible := TRUE
       ::RedrawInvisible()
       ::Canvas:RecalcVisible()
    ENDIF

 RETURN self

 /* **********************************************************************
  * Inquire column width for given column
  * */
 METHOD XbpQuickbrowse:GetColWidth( nColumn )
 RETURN ::DataArea:GetColWidth( nColumn )

 /* **********************************************************************
  * change the row height
  * */
 METHOD XbpQuickbrowse:SetRowHeight( nHeight )

    LOCAL aSize := ::DataArea:CurrentSize()

    /* change the row height */
    ::DataArea:MaxRow := -1
    ::DataArea:SetRowHeight( nHeight )
    ::DataArea:MaxRow := -1
    ::DataArea:SetSize( aSize )

    /* inquire the row count */
    ::RowCount := ::DataArea:RowCount()

    ::DataLink:SetAbsolutePageSize( ::RowCount )

    /* initialize the remaining IVars */
    ::BlockSize      := QB_CalcBlockSize( ::RowCount )
    ::VisibleRecords := Array( ::RowCount )

    /* now stabilize */
    ::Validate()
    ::Invalidate( 1, ::RowCount )
    ::Stabilize()

 RETURN self

 /* **********************************************************************
  * Overloaded color setting simply forwards call to dataarea
  * */
 METHOD XbpQuickbrowse:SetColorFG( nColor )

    IF ValType(nColor) == "N"
       ::DataArea:SetColorFG( nColor )
    ENDIF

 RETURN ::XbpStatic:SetColorFG( nColor )

 /* **********************************************************************
  * Overloaded color setting simply forwards call to dataarea
  * */
 METHOD XbpQuickbrowse:SetColorBG( nColor )

    IF ValType(nColor) == "N"
       ::DataArea:SetColorBG( nColor )
    ENDIF

 RETURN ::XbpStatic:SetColorBG( nColor )

 /* **********************************************************************
  * inquire the row height
  * */
 METHOD XbpQuickbrowse:GetRowHeight()
 RETURN ::DataArea:getRowHeight()

 /* **********************************************************************
  * Navigate to given record ID
  * - when the record is currently visible we will set only the 
  *   rowpos
  * - when the record is currently not visible we will scroll
  *   the datalink TO the given record number
  * */
 METHOD XbpQuickbrowse:GotoRecord( nRecord ) 
    ::NavigationList:Add( XBPBRW_Navigate_GotoRecord, nRecord )
    PostAppEvent( xbeBRW_Stabilize, TRUE, NIL, self, TRUE )
 RETURN self

 /* **********************************************************************
  * Make sure that screen buffer and data buffer did not get out of sync
  * */
 METHOD XbpQuickbrowse:CheckBuffer() 

   LOCAL i

   FOR i := 1 TO ::RowCount
      IF QB_RecordId( i ) != DAC_RecId( ::DataLink:GetRowData( i ) )
         ::Invalidate( 1, ::RowCount )
         ::ForceStable()
      ENDIF
   NEXT

 RETURN self

 /* **********************************************************************
  * Overloaded focus handling to perform hiliting
  * */
 METHOD XbpQuickbrowse:SetInputFocus( mp1, mp2 )
    ::Hilite()
 RETURN ::XbpStatic:SetInputFocus( mp1, mp2 )

 /* **********************************************************************
  * Overloaded focus handling to perform dehiliting
  * */
 METHOD XbpQuickbrowse:KillInputFocus( mp1, mp2 )
    IF ::AlwaysShowSelection
       ::Hilite()
    ELSE
       ::DeHilite()
    ENDIF
 RETURN ::XbpStatic:KillInputFocus( mp1, mp2 )

 /* **********************************************************************
  * Method to bind a new data provider to the object
  * - this method does not reconfigure the complete object
  *   according to the values given in the data provider
  * - it will only refresh and updated values which have been
  *   changed
  * */
 METHOD XbpQuickbrowse:BindDataProvider( oDataProvider )
    LOCAL i, aData
    LOCAL aOldTypes  , aNewTypes
    LOCAL aOldHeader , aNewHeader
    LOCAL aOldWidths , aOldSetHeader

    /* check status */
    IF ::Status() == XBP_STAT_INIT
       RETURN self
    ENDIF

    /* save the original values */
    aOldTypes  := Array( ::ColCount )
    aOldWidths := Array( ::ColCount )
    FOR i := 1 to ::ColCount
       aOldTypes[i]  := ::GetColType( i )
       aOldWidths[i] := ::GetColWidth( i )
    NEXT
    aOldHeader := ::GetHeader()
    IF ::SetHeader != NIL
       aOldSetHeader := AClone( ::SetHeader )
    ENDIF

    /* now bind the new data provider */
    oDataProvider:BindView( self )
    oDataProvider:SetAbsolutePageSize( ::RowCount )

    /* now get the new header and colcount */
    aNewHeader := qbGetDefaultHeader( oDataProvider)
    aData      := ::DataLink:GetRowData( 1 )
    ::ColCount := Len( aNewHeader )

    /* now we do the following: since the headers and the data might have
     * a different length we basically calculate a default string which
     * represents the MAX( lDataStr, lHeaderStr ) values.
     */
    ::Heading:ReferenceArray  := _qbGetReferenceString( NIL, aNewHeader )
    ::dataArea:ReferenceArray := ;
         _qbGetReferenceString( ::Heading:ReferenceArray, DAC_Data( aData ) )
    ::heading:ReferenceArray := AClone( ::dataArea:ReferenceArray )

    /* assign new colcount to heading and data area */
    ::Heading:MaxCol  := ::ColCount
    ::DataArea:MaxCol := ::ColCount

    /* get the new data types */
    aNewTypes := qbGetTypes( oDataProvider )

    /* now reconfigure all childs so that we are able to determine the 
     * changed rowcount and stuff 
     */
    ::LockUpdate( TRUE )
    ::Heading:Configure()
    IF !Empty( ::Separator )
       ::Separator:Configure()
    ENDIF
    ::DataArea:Configure()

    /* now do the following: when a setting was added from the new data
     * provider, the setting will be applied here, otherwise the 
     * original setting is used
     */
    ASize( aOldTypes,  ::ColCount )
    ASize( aOldWidths, ::ColCount )
    ASize( aOldHeader, ::ColCount )
    IF !Empty( aOldSetHeader )
       ASize( aOldSetHeader, ::ColCount )
    ENDIF
    FOR i := 1 TO ::ColCount
       IF aOldHeader[i] != NIL
          /* use old header */
          IF !Empty( aOldSetHeader ) .AND. aOldSetHeader[i] != NIL
             aNewHeader[i] := aOldSetHeader[i]
          ENDIF
       ENDIF
       IF aOldTypes[i]  != NIL
          /* use old column datatype only if the old and new datatypes match */
          IF aNewTypes[i,1] == aOldTypes[i,1]
             aNewTypes[i]  := aOldTypes[i]
          ENDIF
       ENDIF
       ::SetColType( i, aNewTypes[i,1], aNewTypes[i,2], aNewTypes[i,3] )
       IF aOldWidths[i] != NIL
          /* use old column width */
          ::SetColWidth( aOldWidths[i], i, FALSE )
       ENDIF
    NEXT
    ::SetHeader( aNewHeader )
    IF !Empty( aOldSetHeader )
       ::SetHeader := AClone( aOldSetHeader )
    ELSE
       ::SetHeader := NIL
    ENDIF

    /* now we have to arrange our childs */
    ::Invalidate( 1, ::RowCount )
    ::Canvas:ArrangeHScroll()
    ::RedrawInvisible := TRUE
    ::Canvas:RecalcVisible()
    ::LockUpdate( FALSE )
    ::InvalidateRect()
  
 RETURN self


 /* **********************************************************************
  **/
 METHOD XbpQuickbrowse:SetUseVisualStyle( lUse )
   
    IF ValType(lUse) != "L"
       XbpException():RaiseParameterType( {lUse} )
    ENDIF

    IF ValType(::Heading) == "O"
       ::Heading:SetUseVisualStyle( lUse )
    ENDIF
    IF ValType(::Footing) == "O"
       ::Footing:SetUseVisualStyle( lUse )
    ENDIF
    IF ValType(::DataArea) == "O"
       ::DataArea:SetUseVisualStyle( lUse )
    ENDIF
    IF ValType(::VScrollObject) == "O"
       ::VScrollObject:SetUseVisualStyle( lUse )
    ENDIF
    IF ValType(::HScrollObject) == "O"
       ::HScrollObject:SetUseVisualStyle( lUse )
    ENDIF

    ::XbpStatic:SetUseVisualStyle( lUse )

 RETURN


 /* **********************************************************************
  * generate a GotoItem event for the specified browser
  */
 STATIC PROCEDURE qbGotoItem( oXbp, aItem )

    LOCAL nRow, nCol

    nRow := aItem[1]
    nCol := aItem[2]
    IF nRow > 0 .AND. nRow <= oXbp:RowCount .AND. ;
       ( nRow != oXbp:RowPos .OR. nCol != oXbp:ColPos )
       oXbp:NavigationList:Add( XBPBRW_Navigate_GotoItem, aItem )
       PostAppEvent( xbeBRW_Stabilize, NIL, NIL, oXbp, TRUE )
    ENDIF

  RETURN

 /* **********************************************************************
  * Forward "xbeP_CustomDrawCell" event to owner object (browser)
  *
  * Notes: o This method extends the "aInfo" array passed by the system
  *          to include a reference to the area that contains the cell 
  *          to be rendered.
  * */
 STATIC FUNCTION ForwardCustomDrawCell( oPS, aInfo, oArea )
  LOCAL aTmp := AClone( aInfo )

    ASize( aTmp, Len(aTmp) +1 )
    AIns( aTmp,  XBP_DRAWINFO_AREA, oArea )
 RETURN oArea:SetOwner():HandleEvent(xbeP_CustomDrawCell, oPS, aTmp )

 // EOF
