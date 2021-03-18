//////////////////////////////////////////////////////////////////////
//
//     xbp_brw.prg
//
//  Copyright:
//     Alaska Software, (c) 1997-2010. All rights reserved.
//
//  Contents :
//
//     XbpBrowse source code
//
//////////////////////////////////////////////////////////////////////

  #include "appevent.ch"
  #include "xbp.ch"
  #include "gra.ch"
  #include "common.ch"
  #include "assert.ch"
  #include "xbp_brw.ch"
  #include "dll.ch"
  #include "set.ch"
  #include "os.ch"

  /* **********************************************************************
   * APIs and low-level interfaces
   */
  #define SPI_GETWHEELSCROLLLINES  104

  STATIC DLLFUNCTION SystemParametersInfoA( uiAction, uiParam, @pvParam, fWinIni ) ;
     USING STDCALL ;
     FROM USER32.DLL

  /* **********************************************************************
   * Some internal Defines
   */

  /* defines for State */
  #define XBPBRW_STATE_STABLE        1
  #define XBPBRW_STATE_NOTSTABLE     2

  /* defines for InvalidRows and RefreshRows */
  #define XBPBRW_INV_ALL            -1
  #define XBPBRW_INV_NONE           -2

  /* nation dll name and the resource Id for the arrows pointer */
  #define XBNATIONDLL                "XppNat.dll"
  #define XBNATIONARROW              3

  /* defines for Column size mode */
  #define COLUMN_SIZEMODE_NONE       1
  #define COLUMN_SIZEMODE_LEFT       2
  #define COLUMN_SIZEMODE_RIGHT      3


  /* **********************************************************************
   * Some Helper Macros
   * */

  /* Macro to clear one row */
  #xtrans BRW_ClearRow(<nRow>)                                      ;
     => AEval( self:aColumns, {|o| o:DataArea:setCell( <nRow>, NIL ) } )

  /* Macro to redraw columns */
  #xtrans BRW_RedrawCols(<aCols>)                                   ;
     => AEval( <aCols>, {|n| ::aColumns\[n]:Redraw() } )

  /* Inquire column object from column position */
  #define BRW_GetColObject(nColPos)      ::aColumns[::aNavigateCols[nColPos]]

  /* Inquire origin location defined for the object */
  #xtrans BRW_OriginTopLeft()  => BRWOriginTopLeft(self)


 ///////////////////////////////////////////////////////////////////////////////


 /* *******************************************************************
  * XbpBrowse CLASS implementation
  * */
 CLASS XbpBrowse FROM XbpStatic, DataRef

 #ifdef RTL_DEBUG
  #define __DBG
  EXPORTED:
 #else
  #define __DBG  NODEBUG
  PROTECTED:
 #endif
                               ** Browser Subcomponents
    VAR oVScroll         __DBG // vertical scrollbar
    VAR oHScroll         __DBG // horizontal scrollbar
    VAR oBG              __DBG // background for columns
    VAR oScrollBG        __DBG // canvas for columns
    VAR oBR_BG           __DBG // lower-right background
    VAR oBL_BG           __DBG // upper-left background

                               ** Parameter storage
    VAR aSize            __DBG // size
    VAR oParent          __DBG // parent object

                               ** Stabilization vars
    VAR nCurrentRow      __DBG // the current row where we are stabilizing
    VAR nNewRowPos       __DBG // new rowpos after navigation
    VAR nState           __DBG // state of the browser:
                               // nState = { XBPBRW_STABLE | XBPBRW_NOTSTABLE }
    VAR aInvalidRange    __DBG // the invalid range
    VAR nToSkip          __DBG // the number of rows which have to be skipped

    VAR nVScrollPos      __DBG // position of vertical scrollbar

                               ** Marking
    VAR aRecNo           __DBG // array which contains the record id for each
                               // displayed row

                               ** Sizing of columns
    VAR nColumnSizeMode  __DBG // column size mode
                               // nColumnSizeMode = { COLUMN_SIZEMODE_NONE | COLUMN_SIZEMODE_LEFT | COLUMN_SIZEMODE_RIGHT }
    VAR oColumnSize      __DBG // current sized column
    VAR nColumnCol       __DBG // current sized column x position
    VAR nColumnColOld    __DBG // original x position of sized column

    VAR lArranged        __DBG // the object was rearranged
    VAR xLeftFrozen      __DBG // width of the currently "frozen" cols
    VAR xRightFrozen     __DBG // width of the currently "frozen" cols

    VAR aViewSize        __DBG // the size of the browse window excluding scrollbars
    VAR nScrollHeight    __DBG // width/height of the scrollbar
    VAR nMinWidth        __DBG // minimal column width
    VAR nMaxScroll       __DBG // right border of scrollbar

    VAR aNavigateCols    __DBG // array containing the column numbers
                               // describing navigation order of columns
    VAR aVisibleCols     __DBG // complete or partly visible column numbers
    VAR aInvisibleCols   __DBG // not visible column number
    VAR lRedrawInvisible __DBG // TRUE when the invisible cols have to be
                               // repainted on next HScroll
    VAR lStabilizeInvisible __DBG // TRUE when Forcestable is called from RedrawInvisible

                               ** Mouse support
    VAR aPointer         __DBG // current mouse pointer and object

  EXPORTED:

    VAR aColumns         __DBG READONLY // array containing our columns

                               ** Layout Creation Flags
    VAR DataAreaLayout   __DBG READONLY // Layout of the Data Area Bundle
    VAR HeaderLayout     __DBG READONLY // Header Area Layout Bundle
    VAR FooterLayout     __DBG READONLY // Footer Area Layout Bundle

    VAR LeftFrozen       __DBG READONLY // leftfrozen column numbers
    VAR RightFrozen      __DBG READONLY // rightfrozen column numbers
    VAR Scrollable       __DBG READONLY // scrollable column numbers

    VAR LastScroll             // Number of columns to scroll at end
                               // default == 1
    VAR AdjustHeight           // Adjust number of rows so that they match
                               // the column height and no rows are partly
                               // visible
    VAR StyleActive __DBG      // Visual style application, depends on system settings

                               ** Documented vars
   EXPORTED:
                               ** Creation Flags
    VAR HSCroll                // horizontal scrollbar?
    VAR VSCroll                // vertical scrollbar?
    VAR CursorMode             // cursor mode == { XBPBRW_CURSOR_CELL |
                               // XBPBRW_CURSOR_ROW | XBPBRW_CURSOR_NONE }
    VAR DrawMode               // One of XBP_DRAW_NORMAL, XBP_DRAW_OWNERADVANCED
                               // or XBP_DRAW_OWNER
                               ** Runtime Data
    VAR RowPos                 // current row
    VAR ColPos                 // current column
    VAR RowCount  READONLY     // number of rows
    VAR ColCount  READONLY     // number of columns
    VAR SoftTrack              // if FALSE will the browse scroll while
                               // mouse moves
    VAR SizeCols               // if TRUE the columns may be sized

                               ** Callback Slots for codeblocks

                               ** Asynchronous callbacks
    VAR ItemMarked             // an item was marked (one click)
    VAR ItemSelected           // an item was activated (double click, ENTER, RETURN)
    VAR ItemRbDown             // rbdown on an item
    VAR HeaderRbDown           // rbdown on a heading
    VAR FooterRbDown           // rbdown on a footing

    VAR Navigate               // navigation up/down/pageup ...
    VAR Pan                    // scroll left/right/firstcol/lastcol
    VAR ForceStable            // full stabilization

                               ** Synchronous callbacks
    // The following callbacks are synchronous, therefore no events
    // are posted to the object. The specified callback is called
    // directly.
    VAR SkipBlock              // SkipBlock ( self, nToSkip ) => nDidSkip
    VAR GoTopBlock             // GoTopBlock ( self ) => self
    VAR GoBottomBlock          // GoBottomBlock ( self ) => self
    VAR FirstPosBlock          // FirstPosBlock ( self ) => nFirstPos
    VAR LastPosBlock           // LastPosBlock ( self ) => nLastPos
    VAR PosBlock               // PosBlock ( self ) => nPos
    VAR PhyPosBlock            // PhyPosBlock ( self ) => nPhysicalPos
    VAR GoPosBlock             // GoPosBlock( nPos, self ) => self

    VAR HitTopBlock            // called when hittop reached
    VAR HitBottomBlock         // called when hitbottom reached
    VAR StableBlock            // called when object is stable
    VAR CustomDrawCell         // called during owner-drawing


    // ----------------------------------------------------------------------

                               ** Overloaded Lifecycle methods
    METHOD Init, Create        // creation
    METHOD Configure           // reconfiguration

                               ** Overloaded Manipulation methods
    METHOD SetSize             // size change
    METHOD SetPosAndSize       // size change
    METHOD Motion              // overloaded mouse message
    METHOD LbUp                // overloaded mouse message
    METHOD Keyboard            // overloaded keyboard message
    METHOD HandleEvent         // message handling
    METHOD Resize              // browser refresh

    METHOD SetFontCompoundName // change font
    METHOD SetColorFG          // change FG Color (only on dataArea)
    METHOD SetColorBG          // change BG Color (only on dataArea)
    METHOD SetPresParam        // change Presentation parameter

    METHOD Show                // show object
    METHOD Hide                // hide object

                               ** Manipulation methods
    METHOD AddColumn           // add column
    METHOD DelColumn           // remove column
    METHOD InsColumn           // insert column
    METHOD GetColumn           // get column
    METHOD SetColumn           // replace column

                               ** Navigation methods
    METHOD Down                // next row
    METHOD Up                  // previous row
    METHOD PageDown            // next page
    METHOD PageUp              // previous page
    METHOD Right               // next column
    METHOD Left                // previous column
    METHOD GoBottom            // last record
    METHOD GoTop               // first record
    METHOD FirstCol            // first column
    METHOD LastCol             // last column

    METHOD PanLeft             // scroll left one column
    METHOD PanRight            // scroll right one column
    METHOD PanHome             // scroll to first column
    METHOD PanEnd              // scroll to last column

                               ** Methods for the stabilization cycle
    METHOD ForceStable         // stabilize browser

    METHOD RefreshCurrent      // the current row is to be reread on next stabilize
    METHOD RefreshAll          // all rows are to be reread on next stabilize

    METHOD Hilite              // hilite mark
    METHOD DeHilite            // dehilite mark

                               ** Overloaded Methods from Dataref
    METHOD GetData             // inquire current data (and call datalink)
    METHOD EditBuffer          // editbuffer contains currently marked data

    METHOD SetLeftFrozen       // set frozen columns left
    METHOD SetRightFrozen      // ..and right

    METHOD VisibleRecords      // inquire copy of visible records (physical records)

                               ** asynchronous callbacks
    METHOD ItemMarked          // item was marked
    METHOD ItemSelected        // item was activated (double click, ENTER, RETURN)
    METHOD ItemLbDown          // item is to be marked
    METHOD ItemLbDblClick      // item is to be activated
    METHOD ItemRbDown          // rbdown on an item
    METHOD HeaderRbDown        // rbdown on a heading
    METHOD FooterRbDown        // rbdown on a footing
    METHOD ThemeChanged

    METHOD Navigate            // navigation up/down/pageup ...
    METHOD Pan                 // scroll left/right/firstcol/lastcol

                               ** synchronous callbacks
    METHOD CustomDrawCell      // Cell must be redrawn through owner-drawing

                               ** Internal callbacks
    METHOD DALbDown            // left mouse button down on dataarea
    METHOD DALbUp              // left mouse button up on dataarea
    METHOD DAMotion            // mouse motion on dataarea
    METHOD HFLbDown            // left mouse button down on heading (used for
                               // column sizing)
    METHOD HFLbUp              // left mouse button up on heading
    METHOD HFMotion            // mouse motion on heading

    METHOD BeginSizeColumn     // size columns
    METHOD DoSizeColumn
    METHOD EndSizeColumn

    METHOD HScroll             // callback for horizontal scrollbar
    METHOD VScroll             // callback for vertical scrollbar
    METHOD ScrollPanel         // scroll background

    ACCESS METHOD GetBG       VAR oBG      // get parent of scroll canvas
    ACCESS METHOD GetScrollBG VAR oScrollBG// get scroll canvas

    ACCESS METHOD GetHScrollObject() VAR HScrollObject
    ACCESS METHOD GetVScrollObject() VAR VScrollObject

    METHOD SetUseVisualStyle()

    inline method currentState()
      return ::nstate

  PROTECTED:
                                ** Internal methods
    METHOD InValidate          // row range needs to be redrawn
    METHOD Validate            // row range does not need to be redrawn
    METHOD RowSkip             // skipper, called by navigation methods
    METHOD Rearrange           // rearrange browser components pos+size

    METHOD SetNavigateCols     // determine navigation order
    METHOD SetVisibleCols      // determine visible/invisible cols

    METHOD HiliteColumns       // hilite the specified columns
    METHOD DrawRow             // redraw/update row
    METHOD DoSkip              // call the skip block

    METHOD RefreshRows         // mark given rows so that they are reread from
                               // datalink in next stabilization and force
                               // restabilization if necessary
    METHOD _RefreshRows        // mark given rows so that they are reread from
                               // datalink in next stabilization (this function
                               // does not skip or stabilize)

    METHOD RedrawInvisible     // internal method to redraw invisible rows

    METHOD ScrollUp            // scroll a given number of rows up
    METHOD ScrollDown          // scroll a given number of rows down


                               ** Marking methods
    METHOD GotoItem            // move hilit bar to row+col
    METHOD ItemFromPos         // determine row+col from given mouse pos

    METHOD ColNum              // get column number from aNavigateCols

    METHOD _SetPresParam       // internal to set presparams
    METHOD _GetPresParam       // internal to get presparams

    METHOD StaticHandleEvent IS HandleEvent IN XbpStatic // Overloaded due to PDR 2861

 ENDCLASS


 /* *******************************************************************
  * Init method
  * */
 METHOD XbpBrowse:Init ( oParent, oOwner, aPos, aSize, aPP, lVisible )

    DEFAULT aSize    TO { -1, -1 }
    DEFAULT lVisible TO TRUE
    DEFAULT oParent  TO SetAppWindow()

    // call method of parent class
    ::XbpStatic:Init ( oParent, oOwner, aPos, aSize, aPP, lVisible  )
    ::XbpStatic:Type := XBPSTATIC_TYPE_BGNDFRAME
    ::XbpStatic:ClipChildren := TRUE
    ::aSize    := AClone ( aSize )
    ::oParent  := oParent

    // init internal runtime IVars
    ::aColumns      := ARRAY ( 0 )
    ::ColCount      := 0
    ::nNewRowPos    := 0
    ::nState        := XBPBRW_STATE_NOTSTABLE
    ::aInvalidRange := { 0, 0 }
    ::nToSkip       := 0
    ::StyleActive   := .F.

    // init exported runtime Ivars and creation flags
    ::Leftfrozen    := {}
    ::Rightfrozen   := {}
    ::Scrollable    := {}
    ::aNavigateCols := {}
    ::aRecNo        := {}
    ::RowCount      := -1
    ::ColCount      := 0
    ::CursorMode    := XBPBRW_CURSOR_CELL
    ::Sizecols      := TRUE
    ::LastScroll    := 1
    ::AdjustHeight  := FALSE
    ::DrawMode      := XBP_DRAW_NORMAL

    // Layout
    ::DataAreaLayout := ARRAY ( XBPCOL_DA_COUNT )

 #ifdef __OS2__
    ::DataAreaLayout[XBPCOL_DA_FGCLR        ]        := NIL
    ::DataAreaLayout[XBPCOL_DA_BGCLR        ]        := GRA_CLR_PALEGRAY
    ::DataAreaLayout[XBPCOL_DA_HILITE_FGCLR ]        := XBPSYSCLR_HILITEFOREGROUND
    ::DataAreaLayout[XBPCOL_DA_HILITE_BGCLR ]        := GRA_CLR_DARKBLUE
    ::DataAreaLayout[XBPCOL_DA_FRAMELAYOUT  ]        := XBPFRAME_BOX + XBPFRAME_RAISED
    ::DataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT  ]    := XBPFRAME_BOX + XBPFRAME_RAISED
    ::DataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT]    := XBPFRAME_BOX
 #else
    ::DataAreaLayout[XBPCOL_DA_FGCLR        ]     := NIL
    ::DataAreaLayout[XBPCOL_DA_BGCLR        ]     := XBPSYSCLR_3DFACE
    ::DataAreaLayout[XBPCOL_DA_FRAMELAYOUT  ]     := XBPFRAME_BOX + XBPFRAME_RAISED
    ::DataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT  ] := XBPFRAME_BOX + XBPFRAME_RAISED
    ::DataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_BOX
    ::DataAreaLayout[XBPCOL_DA_HILITE_FGCLR ] := XBPSYSCLR_HILITEFOREGROUND
    ::DataAreaLayout[XBPCOL_DA_HILITE_BGCLR ] := XBPSYSCLR_HILITEBACKGROUND
 #endif
    ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME ] := NIL
    ::DataAreaLayout[XBPCOL_DA_ROWWIDTH     ] := XBP_AUTOSIZE
    ::DataAreaLayout[XBPCOL_DA_ROWHEIGHT    ] := XBP_AUTOSIZE
    ::DataAreaLayout[XBPCOL_DA_CELLWIDTH    ] := XBP_AUTOSIZE
    ::DataAreaLayout[XBPCOL_DA_CELLHEIGHT   ] := XBP_AUTOSIZE
    ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := NIL
    ::DataAreaLayout[XBPCOL_DA_ROWSEPARATOR ] := 0
    ::DataAreaLayout[XBPCOL_DA_COLSEPARATOR ] := 0

    ::HeaderLayout := ARRAY ( XBPCOL_HFA_COUNT )
    ::HeaderLayout[XBPCOL_HFA_FGCLR       ] := NIL
 #ifdef __OS2__
    ::HeaderLayout[XBPCOL_HFA_BGCLR       ] := GRA_CLR_PALEGRAY
 #else
    ::HeaderLayout[XBPCOL_HFA_FRAMELAYOUT ] := XBPFRAME_RAISED + ;
                                               XBPFRAME_BOX  + ;
                                               XBPFRAME_THICK
    ::HeaderLayout[XBPCOL_HFA_BGCLR       ] := XBPSYSCLR_3DFACE
 #endif
    ::HeaderLayout[XBPCOL_HFA_COMPOUNDNAME] := NIL
    ::HeaderLayout[XBPCOL_HFA_ALIGNMENT   ] := XBPALIGN_LEFT + ;
                                               XBPALIGN_TOP
    ::HeaderLayout[XBPCOL_HFA_HEIGHT      ] := XBP_AUTOSIZE

    ::FooterLayout := ARRAY ( XBPCOL_HFA_COUNT )
    ::FooterLayout[XBPCOL_HFA_FGCLR    ] := NIL
 #ifdef __OS2__
    ::HeaderLayout[XBPCOL_HFA_BGCLR       ] := GRA_CLR_PALEGRAY
 #else
    ::FooterLayout[XBPCOL_HFA_BGCLR       ] := GRA_CLR_PALEGRAY
    ::FooterLayout[XBPCOL_HFA_FRAMELAYOUT ] := XBPFRAME_RAISED + ;
                                               XBPFRAME_BOX  + ;
                                               XBPFRAME_THICK
 #endif
    ::FooterLayout[XBPCOL_HFA_COMPOUNDNAME] := NIL
    ::FooterLayout[XBPCOL_HFA_ALIGNMENT  ] := XBPALIGN_LEFT + ;
                                              XBPALIGN_TOP
    ::FooterLayout[XBPCOL_HFA_HEIGHT     ] := XBP_AUTOSIZE

    // scrollbars
    ::nScrollHeight := xbpGetSystemMetrics( SM_CYHSCROLL ) // used to be 16
    ::oVScroll      := XbpScrollBar():New( self, self,, {::nScrollHeight,0} )
    ::oVScroll:Type := XBPSCROLL_VERTICAL
    ::oVScroll:Keyboard := { | mp1, mp2 | ::Keyboard ( mp1, mp2 ) }

    ::oHScroll      := XbpScrollBar():New( self, self,, {0,::nScrollHeight} )
    ::oHScroll:AutoTrack := TRUE
    ::oHScroll:Keyboard := { | mp1, mp2 | ::Keyboard ( mp1, mp2 ) }

    ::oHScroll:LbDown := { || IF( !::HasInputFocus(), SetAppFocus( self ), ) }
    ::oVScroll:LbDown := { || IF( !::HasInputFocus(), SetAppFocus( self ), ) }

    // background objects
    ::oBG         := XbpStatic():New( self, self )
    ::oBG:Type    := XBPSTATIC_TYPE_BGNDRECT
    ::oBG:ClipChildren := TRUE
    ::oScrollBG   := XbpStatic():New( ::oBG, self )
    ::oScrollBG:Type := XBPSTATIC_TYPE_BGNDFRAME
    ::oScrollBG:ClipChildren := TRUE
    ::oBR_BG      := XbpStatic():New( self, self )
    ::oBR_BG:Type := XBPSTATIC_TYPE_RECESSEDBOX
    ::oBR_BG:ClipChildren := TRUE
    ::oBL_BG      := XbpStatic():New( self, self )
    ::oBL_BG:Type := XBPSTATIC_TYPE_RECESSEDBOX
    ::oBL_BG:ClipChildren := TRUE

    // store presparams if some were specified
    IF aPP <> NIL
       ::_SetPresParam ( aPP )
    ENDIF

    ::aViewSize := { 0, 0 }

    // default for tracking
    ::SoftTrack := TRUE

    // default switches for the scrollbar
    ::HScroll     := TRUE
    ::VScroll     := TRUE
    ::nVScrollPos := 0

    // initialize column size mode
    ::nColumnSizeMode := COLUMN_SIZEMODE_NONE
    ::oColumnSize     := NIL
    ::nColumnCol      := 0
    ::nColumnColOld   := 0
    ::aPointer        := { 0, self } // { current pointer, oCurrentObject }

    // some configuration sizes
    ::nMinWidth       := 10
    ::lArranged       := FALSE

    // initialize column arrays
    ::aVisibleCols    := {}
    ::aInvisibleCols  := {}

    // indicate that the invisible rows have to be displayed
    ::lRedrawInvisible := TRUE
    ::lStabilizeInvisible := FALSE

    // set current row and column
    ::RowPos      := 1
    ::nCurrentRow := 1
    ::nNewRowPos  := 1
    ::ColPos      := 1

 RETURN self


 /* *******************************************************************
  * Create method
  *
  * The object is created hidden because we don't want it to flicker
  * to much in creation.
  * All header and footer sizes of the columns are adjusted so that
  * all columns share one height of footer, dataarea and header. The
  * rowcount is also determined by the columns when none was specified.
  * */
 METHOD XbpBrowse:Create ( oParent, oOwner, aPos, aSize, aPP, lVisible )

    LOCAL l, i, nHeadHeight, nFootHeight

    DEFAULT aSize    TO ::aSize
    DEFAULT lVisible TO ::Visible
    DEFAULT oParent  TO ::oParent

    // save size and parent
    ::aSize    := AClone ( aSize )
    ::oParent  := oParent

    // a size of -1 indicates that the parent size is used
    IF ::aSize[1] == -1; ::aSize[1] := oParent:CurrentSize()[1]; ENDIF
    IF ::aSize[2] == -1; ::aSize[2] := oParent:CurrentSize()[2]; ENDIF

    // store presparams from internal bundles into presparam array
    IF aPP <> NIL
       ::_SetPresParam ( aPP )
    ENDIF

    // now create our window
    ::XbpStatic:Create ( ::oParent, oOwner, aPos, ::aSize, aPP, FALSE )

    // reset visible flag because the create method resets it
    ::Visible := lVisible

    // create scrollbars
    IF ::VScroll
       ::oVScroll:Create()
       ::oVScroll:Scroll := { | mp1, mp2, obj | ::VScroll ( mp1 ) }
    ENDIF
    IF ::HScroll
       ::oHScroll:Create()
       ::oHScroll:Scroll := { | mp1, mp2, obj | ::HScroll ( mp1 ) }
       ::oBR_BG:Create()
    ENDIF

    // create background
 #ifdef __OS2__
    ::XbpStatic:SetColorBG ( GRA_CLR_PALEGRAY )
    ::XbpStatic:SetColorFG ( GRA_CLR_PALEGRAY )
 #else
    ::XbpStatic:SetColorBG ( XBPSYSCLR_3DFACE )
    ::XbpStatic:SetColorFG ( XBPSYSCLR_OUTPUTTEXT )
 #endif
    ::oBG:Create()
 #ifdef __OS2__
    ::oBG:SetColorBG ( GRA_CLR_PALEGRAY )
    ::oBG:SetColorFG ( GRA_CLR_PALEGRAY )
 #else
    ::oBG:SetColorBG ( XBPSYSCLR_3DFACE )
    ::oBG:SetColorFG ( XBPSYSCLR_OUTPUTTEXT )
 #endif
    ::oScrollBG:Create()
 #ifdef __OS2__
    ::oScrollBG:SetColorFG ( GRA_CLR_PALEGRAY )
    ::oScrollBG:SetColorFG ( GRA_CLR_PALEGRAY )
 #else
    ::oScrollBG:SetColorBG ( XBPSYSCLR_3DFACE )
    ::oScrollBG:SetColorFG ( XBPSYSCLR_OUTPUTTEXT )
 #endif
    ::oBL_BG:Create()

    // create all columns
    l := LEN ( ::aColumns )
    IF l > 0

       // determine maximal values for header and footer height
       nFootHeight := -1
       nHeadHeight := -1
       FOR i := 1 TO l
          IF ::aColumns[i]:FooterLayout[XBPCOL_HFA_HEIGHT] <> NIL .AND. ;
             ::aColumns[i]:FooterLayout[XBPCOL_HFA_HEIGHT] > nFootHeight
             nFootHeight := ::aColumns[i]:FooterLayout[XBPCOL_HFA_HEIGHT]
          ENDIF
          IF ::aColumns[i]:HeaderLayout[XBPCOL_HFA_HEIGHT] <> NIL .AND. ;
             ::aColumns[i]:HeaderLayout[XBPCOL_HFA_HEIGHT] > nHeadHeight
             nHeadHeight := ::aColumns[i]:HeaderLayout[XBPCOL_HFA_HEIGHT]
          ENDIF
       NEXT i

       // create the column
       FOR i := 1 TO l
          aPP := { { XBP_PP_COL_FA_HEIGHT, nFootHeight } ;
                 , { XBP_PP_COL_HA_HEIGHT, nHeadHeight } }
          ::aColumns[i]:Create( ::oScrollBG, self, { 0, 0 }, ;
                                { -1, ::aSize[2] - ::nScrollHeight }, aPP )
          IF ::RowCount == -1
             ::RowCount := ::aColumns[i]:RowCount()
          ENDIF
       NEXT

       // now rearrange our components as we know now the width
       // of the columns
       ::Rearrange()
    ENDIF

    ::StyleActive := (::UseVisualStyle .AND. IsThemeActive(.T.))

    // now we know our rowcount, we can set our invalid range now
    ::aInvalidRange := { 1, ::RowCount }
    ::nState        := XBPBRW_STATE_NOTSTABLE

    // the default value for the physical pos block is the pos block
    IF ::PhyPosBlock == NIL
       ::PhyPosBlock := ::PosBlock
    ENDIF

    // when we are supposed to be visible, we can now show our window
    IF lVisible
       ::XbpStatic:Show()
    ENDIF

 RETURN self


 /* *******************************************************************
  * Reconfiguration
  * */
 METHOD XbpBrowse:Configure ( oParent, oOwner, aPos, aSize, aPP, lVisible )

    DEFAULT aSize    TO ::aSize
    DEFAULT oParent  TO ::oParent
    DEFAULT lVisible TO ::visible

    // store size and parent flag
    ::aSize    := AClone ( aSize )
    ::oParent  := oParent

    // a size of -1 indicates that the parent size is used
    IF ::aSize[1] == -1; ::aSize[1] := oParent:CurrentSize()[1]; ENDIF
    IF ::aSize[2] == -1; ::aSize[2] := oParent:CurrentSize()[2]; ENDIF

    // store presparams from internal bundles into presparam array
    IF aPP <> NIL
       ::_SetPresParam( aPP )
    ENDIF

    // configure parent class
    ::XbpStatic:Configure( ::oParent, oOwner, aPos, ::aSize, aPP, FALSE )

    AEval( ::aColumns, {|o| o:DrawMode:=::DrawMode} )

    // rearrange components
    ::Rearrange( TRUE )

    // now when we should be visible, we will show ourself
    IF lVisible
       ::show()
    ENDIF

 RETURN self


 /* *******************************************************************
  * Add column to browser
  * */
 METHOD XbpBrowse:AddColumn( xValue, nCharWidth, xHeading, xFooting, nType )
 RETURN ::InsColumn(::ColCount+1,xValue,nCharWidth,xHeading,xFooting,nType)


 /* *******************************************************************
  * Delete column from browser
  * */
 METHOD XbpBrowse:DelColumn ( nIndex )

    LOCAL oCol, nPos

    // check parameter
    IF nIndex > Len( ::aColumns ) .OR. nIndex <= 0
       RETURN NIL
    ENDIF

    // dehilite if necessary
    IF nIndex == ::ColPos
       ::Dehilite()
    ENDIF

    // destroy column, decrease column count and remove column from
    // internal column storage
    oCol := ::aColumns[nIndex]
    oCol:Destroy()
    ADel( ::aColumns, nIndex )
    ::ColCount--
    ASize( ::aColumns, ::ColCount )

    // adjust column position if necessary
    IF ::ColPos > ::ColCount
       ::ColPos := ::ColCount
    ENDIF

    // now we have to remove the column from the navigation arrays
    IF ( nPos := AScan( ::Scrollable, nIndex ) ) > 0
       aDel( ::Scrollable, nPos )
       ASize( ::Scrollable, Len( ::Scrollable ) - 1 )
    ELSEIF ( nPos := AScan( ::Leftfrozen, nIndex ) ) > 0
       aDel( ::Leftfrozen, nPos )
       ASize( ::Leftfrozen, Len( ::Leftfrozen ) - 1 )
    ELSEIF ( nPos := AScan( ::Rightfrozen, nIndex ) ) > 0
       aDel( ::Rightfrozen, nPos )
       ASize( ::Rightfrozen, Len( ::Rightfrozen ) - 1 )
    ENDIF

    // now we have to scan all columns and adjust the column positions
    // there
    AdjustColumnArrays( self, nIndex )

    // determine navgation order as the column array has now been changed
    ::SetNavigateCols()

    // rearrange visible areas
    ::Rearrange( TRUE, TRUE )

    // now rehilite if necessary
    IF nIndex == ::ColPos
       ::Hilite()
    ENDIF

 RETURN oCol


 /* *******************************************************************
  * Insert column into the browser
  *
  * The interface of this function is polymorph:
  *  - <xValue> can either specify a valid XbpColumn object or
  *  - <xValue> can specify a datalink codeblock
  * In the latter case a new column IS created and filled with the
  * values from the parameters or default values.
  * When a column is passed it may either be in CREATE state or in
  * INIT state.
  * */
 METHOD XbpBrowse:InsColumn ( nIndex, xValue, nCharWidth, xHeading, xFooting, nType )

   LOCAL aPP := ARRAY(0)
   LOCAL lVisible := ::IsVisible()
   LOCAL oColumn, lRedraw := FALSE
   LOCAL nStatus := ::Status()
   LOCAL lOld, nTmp

   // correct params
   IF nIndex <= 0
      nIndex := 1
   ENDIF

   // prevent window updates
   IF nStatus == XBP_STAT_CREATE .AND. ::IsVisible()
      ::LockUpdate( TRUE )
      lRedraw := TRUE
   ENDIF

   // first dehilite
   IF nStatus == XBP_STAT_CREATE .AND. ::nState == XBPBRW_STATE_STABLE
      ::DeHilite()
   ENDIF

   // when a codeblock was passed we create a new column
   IF VALTYPE ( xValue ) == "B"

      DEFAULT nCharWidth TO -1

      // initialize the heading and footing height values with the
      // default value
      IF xHeading == NIL
         Aadd ( aPP, { XBP_PP_COL_HA_HEIGHT, 0 } )
      ELSE
         Aadd ( aPP, { XBP_PP_COL_HA_CAPTION, xHeading } )
      ENDIF
      IF xFooting == NIL
         Aadd ( aPP, { XBP_PP_COL_FA_HEIGHT, 0 } )
      ELSE
         Aadd ( aPP, { XBP_PP_COL_FA_CAPTION, xFooting } )
      ENDIF
      IF nCharWidth == NIL
         nCharWidth := -1
      ENDIF
      Aadd ( aPP, { XBP_PP_COL_DA_CHARWIDTH, nCharWidth } )

      // we may create the column now
      oColumn := XbpColumn():New( ::oScrollBG, self, { 0, 0 }, , aPP )
      oColumn:DataLink := xValue
      oColumn:DrawMode := ::DrawMode

      IF nType <> NIL
         oColumn:Type := nType
      ENDIF

   ELSE
      // use the column from the parameter
      oColumn := xValue
   ENDIF

   // now we save the column object into our internal arrays and
   // also adjust the navigation arrays so that they keep in sync
   AAdd( ::aColumns, oColumn, nIndex )
   AdjustColumnArrays( self, nIndex, 1 )
   IF nIndex <= Len( ::Scrollable )
      AAdd( ::Scrollable, nIndex, nIndex )
   ELSE
      AAdd( ::Scrollable, nIndex )
   ENDIF
   ::ColCount := Len( ::aColumns )
   ::SetNavigateCols()

   // when we did not have any columns before we set this column as
   // first column
   IF ::ColPos == 0
      ::ColPos := 1
   ENDIF

   IF ::UseVisualStyle == .T. .AND. IsThemeActive(.T.) == .T.
      ::oVScroll:SetColorBG( XBPSYSCLR_SCROLLBAR )
      ::oHScroll:SetColorBG( XBPSYSCLR_SCROLLBAR )
   ENDIF

   oColumn:UseVisualStyle := ::UseVisualStyle

   IF Valtype(oColumn:Heading) == "O"
      oColumn:Heading:StyleClass   := "Header"
      oColumn:Heading:ControlState := XBP_STATE_NORMAL
   ENDIF

   lOld := Set( _SET_FIXED, .F. )
   nTmp := Val( SubStr(OS(OS_VERSION),1,5) )
   Set( _SET_FIXED, lOld )
   IF nTmp >= 6.0
      oColumn:DataArea:StyleClass := "Explorer::Listview"
   ENDIF

   // since it is allowed to call this method also when the browser
   // is in INIT state, we have to check here whether we might create
   // the column or not
   IF ::Status() == XBP_STAT_CREATE
      // the column might be added also in CREATE state, in this case
      // we have to reconfigure it, otherwise we simply create it
      // NOTE: we pass ourself here as owner in order to allow the column
      //       to send all notification to us. This makes sure that we
      //       might add the physical layout of the windows (the column
      //       can get another parent, but the logical (ownership) remains
      //       the same)
      IF oColumn:Status() == XBP_STAT_INIT
         oColumn:Create( ::oScrollBG, self, {0,0}, ;
                         {-1,::aSize[2] - ::nScrollHeight} )
      ELSE
         oColumn:Configure( ::oScrollBG, self, {0,0}, ;
                            {-1, ::aSize[2] - ::nScrollHeight},, TRUE )
      ENDIF

      // we do not stabilize when we are invisible
      IF lVisible

         // rearrange visible areas
         ::Rearrange( TRUE, TRUE )

         // force a complete refresh of the browser
         ::RefreshRows ( 1, ::RowCount, FALSE )
         ::lRedrawInvisible := TRUE

         // stabilize browser
         IF ! PostAppEvent ( xbeBRW_ForceStable, NIL, NIL, self, TRUE )
            ::handleEvent( xbeBRW_ForceStable )
         ENDIF

      ELSE

         // force a complete refresh of the browser
         ::RefreshRows ( 1, ::RowCount, FALSE )
         ::lRedrawInvisible := TRUE
      ENDIF
   ENDIF

   // allow window updates
   IF lRedraw
      ::LockUpdate( FALSE )
      ::InvalidateRect()
   ENDIF

 RETURN oColumn


 /* *******************************************************************
  * Get column object
  * */
 METHOD XbpBrowse:GetColumn ( nIndex, lCreationOrder )
    DEFAULT lCreationOrder TO TRUE
    // return column in creation order
    IF lCreationOrder
       RETURN ::aColumns[nIndex]
    ENDIF
    // return column in navigation order
 RETURN ::aColumns[::aNavigateCols[nIndex]]


 /* *******************************************************************
  * Replace given column object
  * */
 METHOD XbpBrowse:SetColumn ( nIndex, xValue, nWidth, xHeading, xFooting, cType )

   LOCAL oRet

   // provide return value
   oRet := ::GetColumn( nIndex )
   IF Empty( oRet )
      RETURN oRet
   ENDIF

   // remove the original column
   ::DelColumn( nIndex )

   // now add the new column
   ::InsColumn ( nIndex, xValue, nWidth, xHeading, xFooting, cType )

 RETURN oRet


 /* *******************************************************************
  * Hilite one row
  * */
 METHOD XbpBrowse:HiliteColumns ( nRow, lHilite, lHiliteBorder )

    // when we have no rows or columns then we just return
    IF ::ColCount == 0
       RETURN self
    ENDIF
    IF ::RowCount == 0
       RETURN self
    ENDIF

    // now hilite/dehilite
    IF ::CursorMode == XBPBRW_CURSOR_ROW
       // we have a row cursor, hilite the visible columns visible
       // and the invisible columns withour repaint, this basically
       // speeds up browser display when we have many columns
       AEval( ::aVisibleCols, { |n| ::aColumns[n]:HiliteRow ( nRow, ;
                                lHilite, lHiliteBorder, TRUE ) } )
       AEval( ::aInvisibleCols, { |n| ::aColumns[n]:HiliteRow ( nRow, ;
                                  lHilite, lHiliteBorder, FALSE ) } )
    ELSEIF ::CursorMode == XBPBRW_CURSOR_CELL
       // we have a cell cursor, hilite only one column
       ::aColumns[::aNavigateCols[::ColPos]]:HiliteRow ( nRow, lHilite, lHiliteBorder )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Stabilization routine
  *
  * This browser does not allow incremental stabilization currently,
  * therefore on return of this function the browser is stable.
  *
  * */
 METHOD XbpBrowse:ForceStable ()

    LOCAL ntoSkip, nDist, nDidSkip, lEnd, nScrollboxSize

    // the browser is stable, validate and return
    IF ::nState == XBPBRW_STATE_STABLE
       ::Validate()                         // reset invalid range
       RETURN TRUE
    ENDIF

    // an invisible browser wont be stabilized
    IF ! ::Visible
       RETURN TRUE
    ENDIF

    // when we dont have rows, we return
    IF ::RowCount == 0 .OR. ::ColCount == 0
       ::Validate()                         // reset invalid range
       RETURN TRUE
    ENDIF

    // :redrawInvisible() might also call this method when the user
    // scrolls invisible rows into view, in this case we have to
    // skip to the first row
    IF ::lStabilizeInvisible
       IF ::nCurrentRow != 1

          // skip to first row since we have to redraw the complete browse
          // window
          ntoSkip       := ( ::RowPos - 1 ) * -1
          ndidSkip      := ::DoSkip ( ntoSkip )
          ::nCurrentRow := 1
          ::nToSkip     := ::nToSkip - ndidSkip

          // when hittop was reached we will set the hilite bar to
          // the first row
          IF ( ABS ( ndidSkip ) < ABS ( ntoSkip ) )
             ::nNewRowPos  := IIF( Empty( ::aInvalidRange[1] ), 1, ::aInvalidRange[1] )
          ENDIF
       ENDIF
    ENDIF

    // set start values
    nDist      := 0
    nDidSkip   := 0
    ntoSkip    := 0
    lEnd       := FALSE

    // the default value for the physical pos block is the pos block
    IF ::PhyPosBlock == NIL
       ::PhyPosBlock := ::PosBlock
    ENDIF

    // when we have to skip since the navigation funcs (:down(), :up(),
    // :nextpage() etc. have been called) we need to determine the new
    // rowpos here
    IF ::nToSkip <> 0

       // skip the given number of rows and determine how many rows
       // we actually skipped
       ntoSkip  := ::nToSkip
       nDidSkip := ::DoSkip ( ntoSkip )

       // if the row is outside the visible area we have to scroll
       // and adjust the new rowpos.
       nDist := 0
       IF ::nCurrentRow + ::LastScroll > ::RowCount

          nDist := ::nCurrentRow + ::LastScroll - ::RowCount
          nDist := IIF ( nDist > ::RowCount, ::RowCount, nDist )

          // scroll
          ::ScrollUp ( nDist )
          // the hilite bar is now at the last row
          ::nCurrentRow := ::RowCount - ::LastScroll
          IF ::nCurrentRow == 0
             ::nCurrentRow := 1
             nDist := 0
          ENDIF

          // set new invalid range which needs to be repainted
          // - when we scrolled we have to include also the scrolled
          //   area
          IF nDist == ::RowCount
             // when we scrolled the complete screen we also have to
             // invalidate the last row since this might be partly visible
             nDist -= ( 1 + ::LastScroll )
          ENDIF
          ::aInvalidRange[1] := ::nCurrentRow + ::LastScroll - nDist
          ::aInvalidRange[2] := ::nCurrentRow + ::LastScroll

       ELSEIF ::nCurrentRow < 1

          // the first row must be added to the scrolling range
          nDist := ::nCurrentRow - 1
          nDist := IIF ( ABS ( nDist ) > ::RowCount, ::RowCount * -1, nDist )

          ::ScrollDown ( nDist * -1 )
          // now we put the hilite bar to row #1
          ::nCurrentRow := 1
          nDist++

          // set new invalid range which needs to be repainted
          // - when we scrolled we have to include also the scrolled
          //   area
          ::aInvalidRange[1] := ::nCurrentRow - nDist
          ::aInvalidRange[2] := ::nCurrentRow

       ELSE

          // if we have an invalid range then we have to postion the record
          // cursor to the begginning of the invalid range
          IF ::aInvalidRange[1] != 0
             nDist := ::nCurrentRow - ::aInvalidRange[1]
          ENDIF

       ENDIF

       // new rowpos will be the current row
       ::nNewRowPos := ::nCurrentRow
       ::aRecNo[::nCurrentRow] := Eval ( ::PhyPosBlock, self )

    ENDIF

    // now we have to position the cursor to the start of the invalid
    // range in order to sequentially stabilize each row individually
    ntoSkip := nDist * ( -1 )
    IF ntoSkip <> 0
       ::DoSkip ( ntoSkip )
    ENDIF

    // Display all rows in the invalid range (including start and end)
    //

    // set new rowpos which has been determine above
    IF ::nNewRowPos <> NIL
       ::RowPos := ::nNewRowPos
    ENDIF

    // check direction (up or down)
    IF ::aInvalidRange[1] < ::aInvalidRange[2]
       ntoSkip := 1
    ELSEIF ::aInvalidRange[1] > ::aInvalidRange[2]
       ntoSkip := -1
    ELSE
       ntoSkip := 0
    ENDIF

    // now set the scrollbox size, but only when we refresh the whole screen
    IF ::aInvalidRange[1] == 1 .AND. ::aInvalidRange[2] == ::RowCount    ;
       .AND. ::PosBlock != NIL .AND. ::nCurrentRow == 1
       nScrollBoxSize := Eval( ::PosBlock, self )
    ENDIF

    // stabilize all invalid rows
    IF ::aInvalidRange[1] > 0
       lEnd := FALSE
       WHILE lEnd == FALSE

          // refresh row
          IF ::nCurrentRow > 0
             ::aRecNo[::nCurrentRow] := Eval( ::PhyPosBlock, self )
             IF Abs(ntoSkip) > 2
                ::DrawRow( ::nCurrentRow, FALSE )
             ELSE
                ::DrawRow( ::nCurrentRow, TRUE )
             ENDIF
          ENDIF

          // if all rows have been painted we are now on the end
          // of the invalid range, we can now finish stabilization
          IF ::nCurrentRow == ::aInvalidRange[2]
             lEnd := TRUE
          ELSE
             // otherwise skip to the next row
             nDidSkip := ::DoSkip ( ntoSkip )
          ENDIF

          // if no further skipping is possible we have to stop
          // stabilization the fill the remaining rows with
          // empty data
          IF nDidSkip == 0
             lEnd := TRUE
             // we have to adjust rowpos in case it would otherwise be
             // placed on an empty row
             IF ::RowCount > ::nCurrentRow .AND. nToSkip > 0
                FOR nToSkip := ::nCurrentRow + 1 TO ::RowCount
                   BRW_ClearRow( nToSkip )
                NEXT
             ENDIF
             IF ntoSkip > 0 .AND. ::RowPos > ::nCurrentRow
                ::RowPos := ::nCurrentRow
             ENDIF
          ENDIF
       ENDDO
    ENDIF

    // adjust vertical scrollbar
    IF ::PosBlock <> NIL .AND. nScrollBoxSize != NIL .AND. ::nCurrentRow >= ::RowCount
       nScrollBoxSize := Eval( ::PosBlock, self ) - nScrollBoxSize + 1
       ::oVScroll:SetScrollboxSize ( nScrollBoxSize )
    ENDIF

    // skip the record cursor back to rowpos if it is different to the
    // current row
    IF ::RowPos <> ::nCurrentRow
       nDidSkip := ::DoSkip ( ::RowPos - ::nCurrentRow )
    ENDIF

    // now we can set the vertical scrollbar
    IF ::PosBlock <> NIL

       // adjust range of vertical scrollbar
       ::oVScroll:SetRange ( { Eval ( ::FirstPosBlock, self ), Eval ( ::LastPosBlock, self ) } )

       // set the scrollbar position
       ::aRecNo[::RowPos] := Eval ( ::PhyPosBlock, self )
       ::nVScrollPos := Eval ( ::PosBlock, self )
       ::oVScroll:SetData ( ::nVScrollPos )
    ENDIF

    // now redraw the columns since no painting has been done before, this
    // makes sure that we draw only once and it will lead to a faster display
    BRW_RedrawCols( ::aVisibleCols )

    // now hilite
    ::HiliteColumns ( ::RowPos, TRUE, TRUE )

    // validate the internal structures
    ::Validate()

    // call the stable block
    IF VALTYPE ( ::StableBlock ) == "B"
       Eval ( ::StableBlock, self:&(self:className()) )
    ENDIF

    // generate an itemmarked event
    // - we cannot generate an itemmarked event when we where called
    //   from a refresh function
    IF At( "REFRESHROWS", UPPER ( ProcName(2) ) ) == 0
       PostAppEvent ( xbeBRW_ItemMarked, { ::RowPos, ::ColPos }, NIL, self )
    ENDIF

 RETURN TRUE


 /* *******************************************************************
  * Rearrange the browser components
  *
  * - When the browser subcomponents were not arranged yet we will
  *   do this in this function.
  * - After the positions/size have been changed we will recalculate
  *   the internal arrays contiaining the visible/invisible columns
  * - The scrollbars are adjusted according to the sizes
  * */
 METHOD XbpBrowse:Rearrange ( lSetSizes, lRedraw )

    LOCAL i, xPos, aSizeBG[2], aSizeCol
  LOCAL lOriginBL := (BRW_OriginTopLeft() == .F.)

    DEFAULT lRedraw TO FALSE

    // force setting of frozen columns
    IF lSetSizes <> NIL
       ::lArranged := ! lSetSizes
    ENDIF

    ::LastScroll := 1

    // we dont have columns so we will only set the canvas
    IF LEN ( ::aColumns ) == 0
       ::oScrollBG:SetSize ( { 0, ::oBG:CurrentSize()[2] }, lRedraw )
       RETURN self
    ENDIF

    // size was not adjusted
    IF ! ::lArranged

       // adjust size of frozen cols
       ::xLeftFrozen  := 0
       ::xRightFrozen := 0

       // calculate the background size
       aSizeBG[1] := ::aSize[1]
       aSizeBG[2] := ::aSize[2]
       IF ::HScroll
          aSizeBG[2] -= ::nScrollHeight
       ENDIF
       IF ::VScroll
          aSizeBG[1] -= ::nScrollHeight
       ENDIF

       // reposition Leftfrozen columns
       IF LEN ( ::LeftFrozen ) > 0
          FOR i := 1 TO LEN ( ::LeftFrozen )
             ::aColumns[::LeftFrozen[i]]:SetParent( self )
             IF lOriginBL == .T.
                ::aColumns[::LeftFrozen[i]]:SetPos( {::xLeftFrozen,  ;
                                            IIF(::HScroll, ::nScrollHeight, 0)}, FALSE )
             ELSE
                ::aColumns[::LeftFrozen[i]]:SetPos( {::xLeftFrozen, 0}, FALSE )
             ENDIF
             ::xLeftFrozen += ::aColumns[::LeftFrozen[i]]:CurrentSize()[1]
          NEXT
       ENDIF

       // reposition Rightfrozen columns
       IF LEN ( ::RightFrozen ) > 0
          FOR i := LEN ( ::RightFrozen ) TO 1 STEP -1
             ::xRightFrozen += ::aColumns[::RightFrozen[i]]:CurrentSize()[1]
             ::aColumns[::RightFrozen[i]]:SetParent( self )
             IF lOriginBL == .T.
                ::aColumns[::RightFrozen[i]]:SetPos( {aSizeBG[1] - ::xRightFrozen, ;
                                       IIF(::HScroll, ::nScrollHeight, 0)}, FALSE )
             ELSE
                ::aColumns[::RightFrozen[i]]:SetPos( {aSizeBG[1] - ::xRightFrozen, 0} )
             ENDIF
          NEXT
       ENDIF

       // adjust size of the scrollbars and of the bottom right background
       aSizeBG[1] -= ( ::xLeftFrozen + ::xRightFrozen )
       IF ::HScroll
          IF lOriginBL == .T.
             ::oHScroll:SetPos( {::xLeftFrozen, 0}, FALSE )
          ELSE
             ::oHScroll:SetPos( {::xLeftFrozen, aSizeBG[2]}, FALSE )
          ENDIF
          ::oHScroll:SetSize( {aSizeBG[1], ::nScrollHeight}, FALSE )

          // set size of the bottom right background
          IF lOriginBL == .T.
             ::oBR_BG:SetPos(  {aSizeBG[1] + ::xLeftFrozen, 0}, FALSE )
          ELSE
             ::oBR_BG:SetPos(  {aSizeBG[1] + ::xLeftFrozen, aSizeBG[2]}, FALSE )
          ENDIF
          ::oBR_BG:SetSize( {::aSize[1] - aSizeBG[1] - ::xLeftFrozen, ;
                               ::aSize[2] - aSizeBG[2] }, FALSE )
       ENDIF
       IF ::VScroll
          IF lOriginBL == .T.
             ::oVScroll:SetPos(  {::aSize[1] - ::nScrollHeight, ;
                                  ::aSize[2] - aSizeBG[2]}, FALSE )
          ELSE
             ::oVScroll:SetPos(  {::aSize[1] - ::nScrollHeight, 0}, FALSE )
          ENDIF
          ::oVScroll:SetSize( {::nScrollHeight, aSizeBG[2]}, FALSE )
       ENDIF

       // set size and position of the background
       IF lOriginBL == .T.
          ::oBG:SetPos( {::xLeftFrozen, ::aSize[2] - aSizeBG[2]}, FALSE )
       ELSE
          ::oBG:SetPos( {::xLeftFrozen, 0}, FALSE )
       ENDIF
       ::oBG:SetSize( {aSizeBG[1], aSizeBG[2]}, FALSE )

       // set size of bottom left background
       IF lOriginBL == .F.
          ::oBL_BG:SetPos( {0,aSizeBG[2]}, FALSE )
       ENDIF
       ::oBL_BG:SetSize( {::xLeftFrozen, ::aSize[2] - aSizeBG[2]}, FALSE )

       // set flag that we have rearranged the object
       ::lArranged := TRUE

       // now store the size of the background for later usage
       ::aViewSize := AClone ( aSizeBG )
    ENDIF

    // we may now rearrange the column positions and sizes
    xPos := 0
    FOR i := 1 TO LEN ( ::Scrollable )

       // column position
       IF ::aColumns[::Scrollable[i]]:SetParent() <> ::oScrollBG
          ::aColumns[::Scrollable[i]]:SetParent( ::oScrollBG, FALSE )
       ENDIF
       ::aColumns[::Scrollable[i]]:SetPos ( { xPos, 0 }, FALSE )
       xPos += ::aColumns[::Scrollable[i]]:CurrentSize()[1]

       // column size
       aSizeCol := ::aColumns[::Scrollable[i]]:CurrentSize()
       ::aColumns[::Scrollable[i]]:SetSize ( { aSizeCol[1], ::oBG:CurrentSize()[2] }, FALSE )
    NEXT i
    ::oScrollBG:SetSize ( { xPos, ::oBG:CurrentSize()[2] }, FALSE )

    // the size of the left and rightfrozen columns must also be adjusted
    FOR i := 1 TO LEN ( ::LeftFrozen )
       aSizeCol := ::aColumns[::LeftFrozen[i]]:CurrentSize()
       ::aColumns[::Leftfrozen[i]]:SetSize ( { aSizeCol[1], ::oBG:CurrentSize()[2] }, FALSE )
    NEXT i
    FOR i := 1 TO LEN ( ::RightFrozen )
       aSizeCol := ::aColumns[::RightFrozen[i]]:CurrentSize()
       ::aColumns[::RightFrozen[i]]:SetSize ( { aSizeCol[1], ::oBG:CurrentSize()[2] }, FALSE )
    NEXT i

    // Adjust range for horizontal scrollbar, we have to exclude the visible
    // ranges here since they should not be scrolled out
    ::nMaxScroll := LEN ( ::Scrollable )
    ::oHScroll:SetRange ( { 0, ::oScrollBG:CurrentSize()[1] - ::oBG:CurrentSize()[1] } )
    ::oHScroll:SetScrollboxSize ( ::oBG:CurrentSize()[1] )
    ::oHScroll:SetData  ( ::oScrollBG:CurrentPos()[1] * (-1) )

    // The rowcount is determined by the rowcount of the first column
    IF ::aColumns[1]:RowCount() <> -1
       ::RowCount := ::aColumns[1]:RowCount()
       ASize ( ::aRecNo, ::RowCount )
       IF ::RowPos > ::RowCount
          ::RowPos := ::RowCount
          ::nCurrentRow := ::RowCount
       ELSEIF ::RowPos == 0
          ::RowPos := 1
          ::nCurrentRow := 1
       ENDIF
       IF ::RowCount > 1 .AND. Abs(::LastScroll) >= ::RowCount
          // we have to adjust lastscroll in order to get it
          // working correctly when we show only a few rows
          ::LastScroll := ::RowCount - 1
       ENDIF
    ENDIF

    // Determine visible/invisible columns
    IF ::Status() == XBP_STAT_CREATE
       ::SetVisibleCols()
    ENDIF

    // now redraw window if necessary
    IF lRedraw
       ::InvalidateRect ( { 0, 0, ::CurrentSize()[1], ::CurrentSize()[2] } )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Overloaded keyboard message handler TO handle special keyboard
  * messages
  * */
 METHOD XbpBrowse:Keyboard ( mp1 )

    // when we don't display any columns, then keyboard interaction
    // does not make sense
    IF ::ColCount == 0
       RETURN ::XbpStatic:Keyboard( mp1 )
    ENDIF

    // handle the keyboard event
    DO CASE
       CASE mp1 == xbeK_DOWN .OR. mp1 == xbeK_SH_DOWN
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_NextLine,, self )
       CASE mp1 == xbeK_UP .OR. mp1 == xbeK_SH_UP
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_PrevLine,, self )
       CASE mp1 == xbeK_PGDN .OR. mp1 == xbeK_SH_PGDN
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_NextPage,, self )
       CASE mp1 == xbeK_PGUP .OR. mp1 == xbeK_SH_PGUP
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_PrevPage,, self )
       CASE mp1 == xbeK_CTRL_PGDN
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_GoBottom,, self )
       CASE mp1 == xbeK_CTRL_PGUP
          PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_GoTop,, self )
       CASE mp1 == xbeK_LEFT
          IF ::CursorMode == XBPBRW_CURSOR_CELL
             PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_PrevCol,, self )
          ELSE
             PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Left, NIL, self )
          ENDIF
       CASE mp1 == xbeK_RIGHT
          IF ::CursorMode == XBPBRW_CURSOR_CELL
             PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_NextCol,, self )
          ELSE
             PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Right, NIL, self )
          ENDIF
       CASE mp1 == xbeK_HOME
          IF ::CursorMode == XBPBRW_CURSOR_CELL
             PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_FirstCol,, self )
          ELSE
             PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_FirstCol, NIL, self )
          ENDIF
       CASE mp1 == xbeK_END
          IF ::CursorMode == XBPBRW_CURSOR_CELL
             PostAppEvent ( xbeBRW_Navigate, XBPBRW_Navigate_LastCol,, self )
          ELSE
             PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_LastCol, NIL, self )
          ENDIF
       CASE mp1 == xbeK_ENTER
          ::ItemLbDblClick ( ::RowPos, BRW_GetColObject(::ColPos) )
       CASE mp1 == xbeK_RETURN
          ::ItemLbDblClick ( ::RowPos, BRW_GetColObject(::ColPos) )
       OTHERWISE
          RETURN ::XbpStatic:Keyboard( mp1 )
    END CASE

 RETURN self


 /* *******************************************************************
  * Browser specific handleEvent method
  * We process the browser internal messages here.
  * */
 METHOD XbpBrowse:HandleEvent ( nEvent, Mp1, Mp2 )
    LOCAL xRet := self, i:=0

    // Jetzt Event bearbeiten
    DO CASE
       CASE nEvent == xbeBRW_Navigate

          // first evaualte the codeblock, when the codeblock returns NIL,
          // we assume that the codeblock handled the message, nothing is done.
          // When the codeblock returns Mp1 (or a value <> NIL) he did ignore
          // the message (or changed mp1), therefore the default handling
          // according to mp1 must be called.
          xRet := mp1
          IF Valtype( ::navigate ) == "B"
             xRet := Eval( ::navigate, mp1, mp2, self )
          ENDIF

          // when a value <> NIL is returned from the codeblock, the codeblock
          // ignored the message therefore the default handling must be called
          // with the return value passed by the codeblock
          IF xRet <> NIL
             // now perform the action
             ::Navigate ( xRet, mp2 )
          ENDIF

       CASE nEvent == xbeBRW_Pan
          // call the callback
          // -> see above
          xRet := mp1
          IF VALTYPE ( ::Pan ) == "B"
             xRet := Eval ( ::Pan, mp1, mp2, self )
          ENDIF

          // -> see above
          IF xRet <> NIL
             // now perform the action
             ::pan ( xRet, mp2 )
          ENDIF

       CASE nEvent == xbeBRW_ForceStable
          // call the codeblock
          IF VALTYPE ( ::ForceStable ) == "B"
             xRet := Eval ( ::ForceStable, NIL, NIL, self )
          ENDIF

          IF xRet <> NIL
            // stabilize the object
            ::ForceStable()
          ENDIF

       CASE nEvent == xbeBRW_ItemSelected
          // an item was selected
          IF VALTYPE ( ::ItemSelected ) == "B"
             Eval ( ::ItemSelected, mp1, mp2, self )
          ENDIF
          ::ItemSelected ( mp1, mp2 )

       CASE nEvent == xbeBRW_ItemMarked
          // an item was marked
          IF VALTYPE ( ::ItemMarked ) == "B"
             Eval ( ::ItemMarked, mp1, mp2, self )
          ENDIF
          ::ItemMarked ( mp1, mp2 )

       CASE nEvent == xbeBRW_ItemRbDown
          // RbDown on Item == contextmenu request
          ::ItemRbDown ( mp1, mp2 )

       CASE nEvent == xbeBRW_HeaderRbDown
          // RbDown on Header == contextmenu request
          ::HeaderRbDown ( mp1, mp2 )

       CASE nEvent == xbeBRW_FooterRbDown
          // RbDown on Footer == contextmenu request
          ::FooterRbDown ( mp1, mp2 )

       CASE nEvent == xbeP_CustomDrawCell
          xRet := ::CustomDrawCell( mp1, mp2 )
          IF ValType(::CustomDrawCell) == "B"
             xRet := Eval(::CustomDrawCell, mp1, mp2, Self )
          ENDIF

          RETURN xRet

       CASE nEvent == xbeM_Wheel
          SystemParametersInfoA( SPI_GETWHEELSCROLLLINES, 0, @i, 0 )
          IF i < 0
             i := ::RowCount
          ENDIF
          i := Int( (Mp2[2] / 120) * i )
          i *= (-1)
          PostAppEvent( xbeBRW_Navigate, XBPBRW_Navigate_Skip, i, self )

       OTHERWISE
          RETURN ::StaticHandleEvent ( nEvent, Mp1, Mp2 )

    END CASE

 RETURN self


 /* *******************************************************************
  * Callback for our horizontal scrollbar
  * */
 METHOD XbpBrowse:HScroll ( mp1 )

    LOCAL nCommand := mp1[2], nNewPos := mp1[1]

    // generate xbeBRW_Pan messages
    DO CASE
       CASE nCommand == XBPSB_PREVPOS
          PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Left, NIL, self, TRUE )
       CASE nCommand == XBPSB_NEXTPOS
          PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Right, NIL, self, TRUE )
       CASE nCommand == XBPSB_PREVPAGE
          PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Left, NIL, self, TRUE )
       CASE nCommand == XBPSB_NEXTPAGE
          PostAppEvent ( xbeBRW_Pan, XBPBRW_Pan_Right, NIL, self, TRUE )
       CASE nCommand == XBPSB_SLIDERTRACK
          // when we are in the track mode, we will follow the
          // cursor
          IF ! ::SoftTrack
             ::HandleEvent ( xbeBRW_Pan, XBPBRW_Pan_Track, nNewPos )
             IF ::lRedrawInvisible
                ::RedrawInvisible()
             ENDIF
          ENDIF
       CASE nCommand == XBPSB_ENDSCROLL
          // navigate to the given position and force a restabilization
          ::HandleEvent ( xbeBRW_Pan, XBPBRW_Pan_Track, nNewPos )
          IF ::SoftTrack
             IF ::lRedrawInvisible
                ::RedrawInvisible()
             ENDIF
          ENDIF
          // set the visible cols again
          ::SetVisibleCols()
     ENDCASE

 RETURN self


 /* *******************************************************************
  * Scroll the panel horizontally
  *   nNewPos    : the first visible column index in ::Scrollable
  *   lAlignRight: align so that the newpos column is on the right
  *                border (used when scrolling from right to left with
  *                xbeK_RIGHT key)
  * */
 METHOD XbpBrowse:ScrollPanel ( nNewPos, lAlignRight )

    LOCAL i, nRightOffset, nCX, nLeftOffset

    DEFAULT lAlignRight TO FALSE

    // first check whether we should scroll or not, when the scrolling
    // panel is smaller than the visible area for the scrolling panel then
    // we cannot scroll
    IF ::oScrollBg:CurrentSize()[1] < ::oBG:CurrentSize()[1]
       RETURN self
    ENDIF

    // calculate new invisible columns and add their size
    nLeftOffset := 0
    IF nNewPos == 0
       nLeftOffset := 0
    ELSEIF nNewPos > 0 .AND. nNewPos <> ::nMaxScroll
       // the new position is not at the end nor at the beginning
       IF lAlignRight
          // right align the column
          nLeftOffset := ::aColumns[::Scrollable[nNewPos]]:CurrentPos()[1]
          nCX := ::oBG:CurrentSize()[1] - ::aColumns[::Scrollable[nNewPos]]:CurrentSize()[1]
          IF nCX > 0
             nLeftOffset -= nCX
          ENDIF
       ELSE
          // left align
          FOR i := 1 TO nNewPos - 1
             nLeftOffset += ::aColumns[::Scrollable[i]]:CurrentSize()[1]
          NEXT i
       ENDIF
    ELSE
       // recalc complete column width
       FOR i := 1 TO LEN ( ::Scrollable )
          nLeftOffset += ::aColumns[::Scrollable[i]]:CurrentSize()[1]
       NEXT i
       // If less rows are displayed than the browser background has a width
       // then we will not scroll. This applies also when we have only one
       // column.
       IF ( nLeftOffset < ::oBG:CurrentSize()[1] ) .OR. ::colCount == 1
          RETURN self
       ENDIF
       // Calculate the complete width of the columns which are to be cut.
       nRightOffset := 0
       FOR i := ::nMaxScroll + 1 TO LEN ( ::Scrollable )
          nRightOffset += ::aColumns[i]:CurrentSize()[1]
       NEXT i
       nLeftOffset -= nRightOffset + (::aViewSize[1] - nRightOffset)
    ENDIF

    // Now adjust position of the scrolled cols
    ::oScrollBG:SetPos ( { nLeftOffset * (-1), 0 } )

    // Now adjust position of the HScrollbar scrollbox, this might be necessary
    // when we were called from anything other than the HScroll callback.
    ::oHScroll:SetData( ::oScrollBG:CurrentPos()[1] * -1 )

    // Determine visible/invisible cols
    IF ::Status() == XBP_STAT_CREATE
       ::SetVisibleCols()
    ENDIF

 RETURN self


 /* *******************************************************************
  * Scroll Rows
  * */
 METHOD XbpBrowse:VScroll ( mp1 )

    LOCAL  nCommand := mp1[2], nNewPos := mp1[1], i

    DO CASE
       CASE nCommand == XBPSB_PREVPOS
          PostAppEvent( xbeBRW_Navigate, XBPBRW_Navigate_PrevLine,, self )
       CASE nCommand == XBPSB_NEXTPOS
          PostAppEvent( xbeBRW_Navigate, XBPBRW_Navigate_NextLine,, self )
       CASE nCommand == XBPSB_PREVPAGE
          PostAppEvent( xbeBRW_Navigate, XBPBRW_Navigate_PrevPage,, self )
       CASE nCommand == XBPSB_NEXTPAGE
          PostAppEvent( xbeBRW_Navigate, XBPBRW_Navigate_NextPage,, self )
       CASE nCommand == XBPSB_SLIDERTRACK
          IF ! ::SoftTrack
             IF Empty( ::GoPosBlock )
                IF ::nVScrollPos > 0
                   IF ::nVScrollPos < nNewPos
                      FOR i := ::nVScrollPos TO nNewPos - 1
                         ::HandleEvent( xbeBRW_Navigate, XBPBRW_Navigate_NextLine )
                      NEXT i
                   ELSE
                      FOR i := ::nVScrollPos TO nNewPos + 1 STEP -1
                         ::HandleEvent( xbeBRW_Navigate, XBPBRW_Navigate_PrevLine )
                      NEXT i
                   ENDIF
                ENDIF
                // Store new position
                ::nVScrollPos := nNewPos
             ELSE
                // Now navigate to precentage position
                ::HandleEvent( xbeBRW_Navigate, XBPBRW_Navigate_GoPos, nNewPos )
             ENDIF
             // Stabilize
             IF ! PostAppEvent( xbeBRW_ForceStable, NIL, NIL, self )
                ::handleEvent( xbeBRW_ForceStable )
             ENDIF
          ENDIF
       CASE nCommand == XBPSB_ENDTRACK
          IF ::SoftTrack
             IF Empty( ::GoPosBlock )
                IF ::nVScrollPos > 0
                   ::HandleEvent( xbeBRW_Navigate, XBPBRW_Navigate_Skip, ;
                                  nNewPos - ::nVScrollPos )
                ENDIF
                // Store new position
                ::nVScrollPos := nNewPos
             ELSE
                // Goto Percentage position
                ::HandleEvent( xbeBRW_Navigate, XBPBRW_Navigate_GoPos, nNewPos )
             ENDIF
          ENDIF
          // Stabilize
          IF ! PostAppEvent( xbeBRW_ForceStable, NIL, NIL, self, TRUE )
             ::handleEvent( xbeBRW_ForceStable )
          ENDIF
       CASE nCommand == XBPSB_ENDSCROLL
          IF ! PostAppEvent( xbeBRW_ForceStable, NIL, NIL, self, TRUE )
             ::handleEvent( xbeBRW_ForceStable )
          ENDIF
    ENDCASE

 RETURN self


 /* *******************************************************************
  * ACCESS method for the "oBG" instance variable. The method returns
  * the parent object of the column scroll canvas.
  * */
 METHOD XbpBrowse:GetBG()
 RETURN ::oBG


 /* *******************************************************************
  * ACCESS method for the "oScrollBG" instance variable. The method
  * returns the parent object of the column scroll canvas.
  * */
 METHOD XbpBrowse:GetScrollBG()
 RETURN ::oScrollBG


 /* *******************************************************************
  * ACCESS method for the "HScrollObject" instance variable.
  * */
 METHOD XbpBrowse:GetHScrollObject()
 RETURN ::oHScroll


 /* *******************************************************************
  * ACCESS method for the "VScrollObject" instance variable.
  * */
 METHOD XbpBrowse:GetVScrollObject()
 RETURN ::oVScroll


 /* **********************************************************************
  **/
 METHOD XbpBrowse:SetUseVisualStyle( lUse )

    IF ValType(lUse) != "L"
       XbpException():RaiseParameterType( {lUse} )
    ENDIF

    IF ValType(::oVScroll) == "O"
       ::oVScroll:SetUseVisualStyle( lUse )
    ENDIF
    IF ValType(::oHScroll) == "O"
       ::oHScroll:SetUseVisualStyle( lUse )
    ENDIF

    ::XbpStatic:SetUseVisualStyle( lUse )

    IF ::Status() == XBP_STAT_CREATE
       IF ValType(::aColumns) == "A"
          AEval( ::aColumns, {|o| o:UseVisualStyle:=lUse} )
       ENDIF

       IF ::oBG:Status() == XBP_STAT_CREATE
          ::Configure()
       ENDIF
    ENDIF

    ::StyleActive := (::UseVisualStyle .AND. IsThemeActive(.T.))

 RETURN


 /* *******************************************************************
  * The item was selected (left mouse doubleclick or ENTER/RETURN key
  * was pressed)
  * -> we have to determine the column number and generate a ItemSelected
  *    event
  * */
 METHOD XbpBrowse:ItemLbDblClick ( nRow, oCol )

    LOCAL nCol := ::ColNum ( oCol )

    // when I determined the column I may send myself a ItemSelected
    // message
    PostAppEvent ( xbeBRW_ItemSelected, { nRow, nCol }, NIL, self )

 RETURN self


 /* *******************************************************************
  * An item was marked (left mouse down)
  * -> navigate TO cell by using GotoItem (which in turn generates
  *    an ItemMarked event)
  * */
 METHOD XbpBrowse:ItemLbDown ( nRow, oCol )

    LOCAL nCol := ::ColNum ( oCol )

    // inquire focus if necessary
    IF !::HasInputFocus()
       SetAppFocus( self )
    ENDIF

    // navigate the cursor to the selected item
    ::GotoItem ( nRow, nCol )

 RETURN self


 /* *******************************************************************
  * Callback slot for xbeBRW_ItemMarked
  * */
 METHOD XbpBrowse:ItemMarked()
 RETURN self


 /* *******************************************************************
  * Callback slot for xbeBRW_ItemSelected
  * */
 METHOD XbpBrowse:ItemSelected()
 RETURN self


 /* *******************************************************************
  * Navigate to given Row/Column
  * RETURN:  TRUE - stabilizing is necessary
  *          FALSE - stabilizing is not necessary
  * */
 METHOD XbpBrowse:GotoItem ( nRow, nCol, lDehilite )

    DEFAULT lDehilite TO FALSE

    // when the same item has been marked a second time, I will just return
    IF ( ::CursorMode == XBPBRW_CURSOR_ROW )
       IF nRow == ::RowPos
          RETURN FALSE
       ENDIF
    ELSE
       IF nRow == ::RowPos .AND. nCol == ::ColPos
          RETURN FALSE
       ENDIF
    ENDIF

    // dehilite current mark if necessary
    IF lDehilite
       ::Dehilite()
    ENDIF

    // skip to the selected row and column
    IF nRow != ::RowPos
       ::HandleEvent ( xbeBRW_Navigate, XBPBRW_Navigate_Skip, nRow - ::RowPos )
    ENDIF
    IF nCol != ::ColPos
       ::HandleEvent ( xbeBRW_Navigate, XBPBRW_Navigate_SkipCols, nCol - ::ColPos )
    ENDIF

 RETURN TRUE


 /* *******************************************************************
  * Skip request, we store the number of rows here which need to
  * be skipped when the browser will stabilize the NEXT time.
  * */
 METHOD XbpBrowse:RowSkip ( nSkip, lDehilite )

    DEFAULT lDehilite TO TRUE

    // dehilite current row
    IF ::nState == XBPBRW_STATE_STABLE
       IF lDehilite
          ::Dehilite()
       ENDIF
    ENDIF

    // now add the skip request to the pending skip requests
    ::nToSkip += nSkip
    ::nState := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Next rows
  * */
 METHOD XbpBrowse:Down ( nRows, lDehilite )

    DEFAULT lDehilite TO TRUE
    DEFAULT nRows     TO 1

    // activate next row or a number of next rows
    ::RowSkip ( nRows, lDehilite )

 RETURN self


 /* *******************************************************************
  * Previous rows
  * */
 METHOD XbpBrowse:Up ( nRows, lDehilite )

    DEFAULT lDehilite TO TRUE
    DEFAULT nRows     TO 1

    // activate previous rows
    ::RowSkip ( nRows * (-1), lDehilite )

 RETURN self


 /* *******************************************************************
  * NEXT page
  * */
 METHOD XbpBrowse:PageDown ( lDehilite )

    DEFAULT lDehilite TO TRUE

    // goto next page
    ::RowSkip ( ::RowCount, lDehilite )

 RETURN self


 /* *******************************************************************
  * Goto previous page
  * */
 METHOD XbpBrowse:PageUp ( lDehilite )

    DEFAULT lDehilite TO TRUE

    // goto previous page
    ::RowSkip ( ::RowCount * ( - 1), lDehilite )

 RETURN self


 /* *******************************************************************
  * Next column
  * */
 METHOD XbpBrowse:Right ( lDehilite)

    DEFAULT lDehilite TO TRUE

    IF ::ColPos < LEN ( ::aNavigateCols )

       // dehilite current row
       IF ::nState == XBPBRW_STATE_STABLE
          IF lDehilite
             ::Dehilite()
          ENDIF
       ENDIF

       // increase colpos
       ::ColPos++

       // scroll when this is necessary
       IF ( ::aColumns[::aNavigateCols[::ColPos]]:CurrentPos()[1]  + ;
            ::aColumns[::aNavigateCols[::ColPos]]:CurrentSize()[1] + ;
            ::oScrollBG:CurrentPos()[1] ) > ::oBG:CurrentSize()[1] .AND. ;
          AScan( ::Scrollable, ::aNavigateCols[::ColPos] ) != 0
          // pan one column right
          ::PanRight()
       ENDIF

    ENDIF

    // set state to indicate that we are not stable
    ::nState := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Previous column
  * */
 METHOD XbpBrowse:Left ( lDehilite )

    DEFAULT lDehilite TO TRUE

    IF ::ColPos > 1

       // dehilite current column
       IF ::nState == XBPBRW_STATE_STABLE
          IF lDehilite
             ::Dehilite()
          ENDIF
       ENDIF

       // decrease colpos
       ::ColPos--

       // scroll if necessary
       IF ::aColumns[::aNavigateCols[::ColPos]]:CurrentPos()[1] < ;
          ABS ( ::oScrollBG:CurrentPos()[1] )
          // pan one column left
          ::PanLeft()
       ENDIF

    ENDIF

    // set state to indicate that we are not stable
    ::nState := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Last record
  * */
 METHOD XbpBrowse:GoBottom ( lDehilite )

    DEFAULT lDehilite TO TRUE

    // dehilite current row
    IF ::nState == XBPBRW_STATE_STABLE
       IF lDehilite
          ::Dehilite()
       ENDIF
    ENDIF

    // call the codeblock
    Eval ( ::GoBottomBlock, self )

    // skip backwards the number of displayed rows
    ::DoSkip ( ( ::RowCount - 1 - ::LastScroll ) * ( -1 ) )

    // jump to last record in the window on stabilizing
    ::nNewRowPos  := ::RowCount - ::LastScroll
    ::RowPos      := 1
    ::nCurrentRow := 1

    // we shall redraw all invisible rows since our screen contents
    // would change
    ::lRedrawInvisible := TRUE

    // invalidate all
    ::_RefreshRows ( 1, ::RowCount, TRUE )

 RETURN self


 /* *******************************************************************
  * First Record
  * */
 METHOD XbpBrowse:GoTop ( lDehilite)

    DEFAULT lDehilite TO TRUE

    // dehilite current row
    IF ::nState == XBPBRW_STATE_STABLE
       IF lDehilite
          ::Dehilite()
       ENDIF
    ENDIF

    // call the codeblock
    Eval ( ::GoTopBlock, self )

    // jump to first record in the window
    ::nNewRowPos := 1
    ::nCurrentRow := 1

    // we shall redraw all invisible rows since our screen contents
    // would change
    ::lRedrawInvisible := TRUE

    // invalidate all
    ::_RefreshRows ( 1, ::RowCount, FALSE )

 RETURN self


 /* *******************************************************************
  * Set invalid range
  * */
 METHOD XbpBrowse:InValidate ( nStartRow, nEndRow )

    ::aInvalidRange[1] := nStartRow
    ::aInvalidRange[2] := nEndRow
    ::nState           := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Reset invalid range
  * */
 METHOD XbpBrowse:Validate ()

    ::aInvalidRange[1] := 0
    ::aInvalidRange[2] := 0
    ::nState           := XBPBRW_STATE_STABLE
    ::nToSkip          := 0
    ::nNewRowPos       := NIL
    ::nCurrentRow      := ::RowPos

 RETURN self


 /* *******************************************************************
  * Refresh row
  *
  * PRECONDITION: the RowRecPos value has to be set before!
  *
  *   DrawRow ( nRow ) -> self
  * */
 METHOD XbpBrowse:DrawRow ( nRow, lRedraw )

    // draw the current row
    AEval ( ::aVisibleCols, { | n | ::aColumns[n]:DrawRow( nRow, lRedraw ) } )

 RETURN self


 /* *******************************************************************
  * Call the skipper block
  * */
 METHOD XbpBrowse:DoSkip ( ntoSkip )

    LOCAL nDidSkip

    // when the skip request is > rowcount, it may last some more time
    // therefore I will disable my window and tell the user not to
    // scroll anymore
    IF ABS ( ntoSkip ) > ::RowCount * 3
       AEval( ::ChildList(), { |oXbp| oXbp:Disable() } )
       ::SetPointer (, XBPSTATIC_SYSICON_WAIT, XBPWINDOW_POINTERTYPE_SYSPOINTER )
    ENDIF

    // call skipblock and add the skipped records to the current row
    nDidSkip      := Eval ( ::SkipBlock, ntoSkip, self )
    ::nCurrentRow += nDidSkip

    // now check for the hittop and hitbottom blocks
    IF nDidSkip <> ntoSkip
       IF ntoSkip < 0 .AND. VALTYPE ( ::HitTopBlock ) == "B"
          // hittop
          Eval ( ::HitTopBlock, self )
       ELSEIF ntoSkip > 0  .AND. VALTYPE ( ::HitBottomBlock ) == "B"
          // hitbottom
          Eval ( ::HitBottomBlock, self )
       ENDIF
    ENDIF

    // now reset pointers again if necessary
    IF ABS ( ntoSkip ) > ::RowCount * 3
       AEval( ::ChildList(), { |oXbp| oXbp:Enable() } )
       ::SetPointer (, XBPSTATIC_SYSICON_ARROW, XBPWINDOW_POINTERTYPE_SYSPOINTER )
    ENDIF

 RETURN nDidSkip


 /* *******************************************************************
  * Display context menu on data area
  * */
 METHOD XbpBrowse:ItemRbDown ( aPos, aValues )

    LOCAL oCol := aValues[1]
    LOCAL nRow := aValues[2]
    LOCAL nCol := ::ColNum ( aValues[1] )

    // adjust the position passed in mp1 relative to self: 0,0
    AdjustPos ( self, aPos, oCol )

    // now call the callback
    IF ValType ( ::ItemRbDown ) == "B"
       Eval ( ::ItemRbDown, aPos, { nRow, nCol }, self )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Display context menu on header
  * */
 METHOD XbpBrowse:HeaderRbDown ( aPos, aValues )

    LOCAL oCol := aValues[1]
    LOCAL nCol := ::ColNum ( aValues[1] )

    // adjust the position passed in mp1 relative to self: 0,0
    AdjustPos ( self, aPos, oCol )

    // now call the callback
    IF ValType ( ::HeaderRbDown ) == "B"
       Eval ( ::HeaderRbDown, aPos, nCol, self )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Display context menu on footer
  * */
 METHOD XbpBrowse:FooterRbDown ( aPos, aValues )

    LOCAL oCol := aValues[1]
    LOCAL nCol := ::ColNum ( aValues[1] )

    // adjust the position passed in mp1 relative to self: 0,0
    AdjustPos ( self, aPos, oCol )

    // now call the callback
    IF ValType ( ::FooterRbDown ) == "B"
       Eval ( ::FooterRbDown, aPos, nCol, self )
    ENDIF

 RETURN self


 /* *******************************************************************
  * */
 METHOD XbpBrowse:ThemeChanged( mp1, mp2 )

   IF ::StyleActive != (IsThemeActive(.T.) .AND. ::UseVisualStyle)
      ::SetUseVisualStyle( ::UseVisualStyle )
   ENDIF

 RETURN ::XbpStatic:ThemeChanged(mp1, mp2)


 /* *******************************************************************
  * The current row is marked so that it will be reloaded when
  * the next stabilization cycle occurs.
  * */
 METHOD XbpBrowse:RefreshCurrent ( lStabilize )

    DEFAULT lStabilize TO TRUE

    ::RefreshRows ( ::RowPos, ::RowPos, lStabilize )

 RETURN self


 /* *******************************************************************
  * All rows need to be reloaded when the next stabilization cycle
  * occurs.
  * */
 METHOD XbpBrowse:RefreshAll ( lStabilize )

    DEFAULT lStabilize TO TRUE

    // refresh all visible rows
    ::RefreshRows ( 1, ::RowCount, lStabilize )

    // indicate that the invisible rows have to be refreshed as well
    ::lRedrawInvisible := TRUE

 RETURN self


 /* *******************************************************************
  * Refresh the rows without skipping
  *
  * NOTE: this is an internal method
  * */
 METHOD XbpBrowse:_RefreshRows ( nStartRow, nEndRow )

    IF ::RowCount == 0
       RETURN self
    ENDIF

    IF ::nState == XBPBRW_STATE_STABLE

       // invalidate the given area
       ::InValidate ( nStartRow, nEndRow )

       // now mark the rows as invalid in the column objects
       AEval ( ::aColumns, { | o | o:RefreshRows ( nStartRow, nEndRow ) } )

    ENDIF

 RETURN self


 /* *******************************************************************
  * Refresh Rows
  *
  * NOTE: Internal method
  * */
 METHOD XbpBrowse:RefreshRows ( nStartRow, nEndRow, lStabilize )

    LOCAL ndidSkip, ntoSkip

    DEFAULT lStabilize TO TRUE

    IF ::RowCount == 0
       RETURN self
    ENDIF

    IF ::nState == XBPBRW_STATE_STABLE

       // dehilite because current line is to be redrawn
       ::Dehilite()

       // invalidate the given area
       ::InValidate ( nStartRow, nEndRow )

       // now skip to the first row of the area
       ntoSkip  := ( ::RowPos - nStartRow ) * -1
       ndidSkip := ::DoSkip ( ntoSkip )

       // the current row is always the first row, since we are
       // at the first positoin of the invalidated area
       ::nCurrentRow := nStartRow

       // if hittop was reached, we always set rowpos to 1
       IF ( ABS ( ndidSkip ) < ABS ( ntoSkip ) )
          ::nNewRowPos  := nStartRow
       ENDIF

       // invalidate columns
       AEval ( ::aColumns, { | o | o:RefreshRows ( nStartRow, nEndRow ) } )

    ENDIF

    IF lStabilize
       // the stabilization must be done synchronous here, because of
       // of the notification mechanisms in APPBROWSE
       ::handleEvent( xbeBRW_ForceStable )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Redraw invisible rows: this method IS needed because the browser
  * will only stabilize the currently visible rows, it will not stabilize
  * rows out of the visible area. This method redraws these invisible rows
  * and is called when the dataarea IS scrolled.
  *
  * NOTE: internal method
  * */
 METHOD XbpBrowse:RedrawInvisible()

    LOCAL aTmp
    LOCAL nStartRow := 1, nEndRow := ::RowCount

    // when there are pending skip requests, we stabilize first, otherwise
    // the stabilization routine will not handle this case correctly
    IF ::ntoSkip != 0
       ::handleEvent( xbeBRW_ForceStable )
    ENDIF

    // invalidate
    ::InValidate ( nStartRow, nEndRow )

    // refresh invisible rows
    AEval( ::aInvisibleCols, { |n| ::aColumns[n]:RefreshRows ( nStartRow, nEndRow ) } )

    // now redraw
    aTmp           := ::aVisibleCols
    ::aVisibleCols := ::aInvisibleCols
    ::lStabilizeInvisible := TRUE
    ::handleEvent( xbeBRW_ForceStable )
    ::lStabilizeInvisible := FALSE
    ::aVisibleCols := aTmp

    // we dont have to redraw invisible rows anymore now
    ::lRedrawInvisible := FALSE

 RETURN self


 /* *******************************************************************
  * Scroll horizontal
  *
  *   PanLeft() => self
  * */
 METHOD XbpBrowse:PanLeft ( nCols )

    LOCAL nPos, nScrollPos := ABS( ::oScrollBG:CurrentPos()[1] )

    DEFAULT nCols TO -1

 #define B_FINDFIRSTVISIBLE     ;
         { | i | ::aColumns[i]:CurrentPos()[1] + ::aColumns[i]:CurrentSize()[1] >= nScrollPos .AND. ;
                 ::aColumns[i]:CurrentPos()[1] <= nScrollPos }

    nPos := AScan( ::Scrollable, B_FINDFIRSTVISIBLE )

    nPos += nCols
    IF nPos >= 0
       IF ::lRedrawInvisible
          ::RedrawInvisible()
       ENDIF
       ::ScrollPanel ( nPos )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Scroll horizontal
  *
  *   PanRight() => self
  * */
 METHOD XbpBrowse:PanRight ( nCols )

    LOCAL nPos, nScrollWidth := ::oBG:CurrentSize()[1]
    LOCAL nScrollPos := ::oScrollBG:CurrentPos()[1]

    DEFAULT nCols TO 1

 #define B_FINDLASTPARTLYVISIBLE     ;
         { | i | ::aColumns[i]:CurrentPos()[1] + nScrollPos < nScrollWidth .AND. ;
                 ::aColumns[i]:CurrentPos()[1] + ::aColumns[i]:CurrentSize()[1] + nScrollPos > nScrollWidth }
 #define B_FINDLASTFULLYVISIBLE     ;
         { | i | ::aColumns[i]:CurrentPos()[1] + nScrollPos < nScrollWidth .AND. ;
                 ::aColumns[i]:CurrentPos()[1] + ::aColumns[i]:CurrentSize()[1] + nScrollPos == nScrollWidth }

    nPos := AScan( ::Scrollable, B_FINDLASTPARTLYVISIBLE )
    IF nPos == 0
       // we have to find the last fully visible one and advance then to the
       // next invisible
       nPos := AScan( ::Scrollable, B_FINDLASTFULLYVISIBLE )
    ELSE
       nPos--
    ENDIF

    nPos += nCols
    IF nPos <= ::nMaxScroll
       IF ::lRedrawInvisible
          ::RedrawInvisible()
       ENDIF
       // this code is to adress PDR 3498: when the size of the column
       // is wider than the scrolling area, then we have to catch this here
       IF Abs( nScrollPos ) == ::aColumns[::Scrollable[nPos]]:CurrentPos()[1] .AND. ;
          nPos < Len( ::Scrollable )
          nPos++
       ENDIF
       ::ScrollPanel ( nPos, TRUE )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Scroll horizontal
  *
  *   PanEnd() => self
  * */
 METHOD XbpBrowse:PanEnd ()

    IF ::lRedrawInvisible
      ::RedrawInvisible()
    ENDIF
    ::ScrollPanel ( ::nMaxScroll )

 RETURN self


 /* *******************************************************************
  * Scroll horizontal
  *
  *   PanHome() => self
  * */
 METHOD XbpBrowse:PanHome()

    IF ::lRedrawInvisible
      ::RedrawInvisible()
    ENDIF
    ::ScrollPanel ( 1 )

 RETURN self


 /* *******************************************************************
  * Display current hiliting bar at :rowpos
  *
  *       Hilite () => self
  * */
 METHOD XbpBrowse:Hilite ()
    ::HiliteColumns ( ::RowPos, TRUE, TRUE )
 RETURN self


 /* *******************************************************************
  * Hide current hilite bar
  *
  *   Dehilite() => self
  * */
 METHOD XbpBrowse:Dehilite()

    // now unhilite the current row
    IF ::nState == XBPBRW_STATE_STABLE
       ::HiliteColumns ( ::RowPos, FALSE, FALSE )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Resize on browser (overloaeded from parent class)
  * - we have to determine the new rowcount
  * - we have to rearrange
  * - we have to repaint
  *
  *     SetSize ( <aNewSize> ) => lSucess
  * */
 METHOD XbpBrowse:SetSize ( aNewSize, lRedraw )

    LOCAL lRet
    LOCAL aOldSize := ::CurrentSize()
    LOCAL aPos, aRect

    DEFAULT lRedraw TO TRUE

    // lock screen update for more smoothy redraw
    ::LockUpdate( TRUE )

    // adjust size that it does not get < 0
    IF aNewSize[1] < 0
       aNewSize[1] := 0
    ENDIF
    IF aNewSize[2] < 0
       aNewSize[2] := 0
    ENDIF

    // forward the call to anchestor class
    lRet := ::XbpStatic:SetSize ( aNewSize, FALSE )

    // setsize only when new size is != 0,0 and old size is also != 0, 0
    IF ::aSize[1] <> 0 .AND. ::aSize[2] <> 0 .AND. ;
       aNewSize[1] <> 0 .AND. aNewSize[2] <> 0

       // now rearrange the position and sizes of all subcomponents
       // please note that we also set the rowcount here
       ::lArranged := FALSE
       ::aSize := AClone ( aNewSize )
       ::Rearrange( , FALSE )

       // pan home in order to stabilize the view when the x size was
       // decreased
       ::PanHome()

       // now we need to redraw when the rowcount was changed
       IF ::RowPos >= ::RowCount
          ::RowPos := ::RowCount - 1
          IF ::RowPos <= 0
             ::RowPos := 1
          ENDIF
       ENDIF

 #ifdef __OS2__
       ::RefreshAll()
       ::InvalidateRect ()
 #endif

    ENDIF

    // now unlock screen update again
    ::LockUpdate( FALSE )
    IF lRedraw
       IF aOldSize[1] > aNewSize[1]
         aPos  := ::CurrentPos()
         aRect := {aPos[1]+aNewSize[1],aPos[2],;
                   aPos[1]+aOldSize[1],aPos[2]+Max(aOldSize[2],aNewSize[2])}
       ENDIF
       IF aOldSize[2] > aNewSize[2]
         aPos  := ::CurrentPos()
         aRect := {aPos[1],aPos[2]+aNewSize[2],;
                   aPos[1]+Max(aOldSize[1],aNewSize[1]),aPos[2]+aOldSize[2]}
       ENDIF

       IF aRect != NIL
          ::SetParent():InvalidateRect( aRect )
       ENDIF

       ::InvalidateRect()
    ENDIF

 RETURN lRet


 /* *******************************************************************
  * Repositioning and resizing the browser (overloaeded from parent
  * class)
  *
  *     SetPosAndSize( <aNewPos>, <aNewSize>, [<lRedraw>] ) => lSuccess
  * */
 METHOD XbpBrowse:SetPosAndSize ( aNewPos, aNewSize, lRedraw )

   DEFAULT lRedraw TO TRUE

   ::SetPos( aNewPos, lRedraw )

RETURN ::SetSize(aNewSize, lRedraw)


 /* *******************************************************************
  * Resize event overloaded
  *
  *       ReSize ( <aOldSize>, <aNewSize> ) => self
  * */
 METHOD XbpBrowse:ReSize ( aOldSize, aNewSize )

 #ifdef __WIN32__
    ::RefreshAll()
    ::InvalidateRect ( { 0, 0, aNewSize[1], aNewSize[2] } )
 #endif
    ::lRedrawInvisible := TRUE

 RETURN ::XbpStatic:Resize( aOldSize, aNewSize )


/* *******************************************************************
  * Set leftfrozen columns
  *
  *    SetLeftFrozen( [<anFrozen>] ) => <anLeftFrozen>
  *    anFrozen : Array of column indices
  * */
 METHOD XbpBrowse:SetLeftFrozen( aFrozen )

    LOCAL i, nPos, aRet

    aRet := AClone( ::LeftFrozen )

    IF ValType(aFrozen) == "U"
       RETURN aRet
    ENDIF

    IF ValType(aFrozen) != "A"
       XbpException():RaiseParameterType( {aFrozen} )
    ENDIF

    // first delete all references to elements which are currently set
    // frozen and insert them at the left of the scrollable area
    FOR i := LEN( ::LeftFrozen ) TO 1 STEP -1
       AAdd( ::Scrollable, NIL )
       AIns( ::Scrollable, 1, ::LeftFrozen[i] )
    NEXT
    ASize( ::Leftfrozen, 0 )

    // now remove all elements from the scrollable and rightfrozen arrays
    // and add them to the leftfrozen
    FOR i := 1 TO LEN( aFrozen )
       IF (nPos := AScan(::Scrollable, aFrozen[i])) <> 0
          AAdd( ::LeftFrozen, ::Scrollable[nPos] )
          ADel( ::Scrollable, nPos )
          ASize( ::Scrollable, LEN(::Scrollable) - 1 )
       ELSEIF (nPos := AScan(::RightFrozen, aFrozen[i])) <> 0
          AAdd( ::LeftFrozen, ::RightFrozen[nPos] )
          ADel( ::RightFrozen, nPos )
          ASize( ::RightFrozen, LEN(::RightFrozen) - 1 )
       ENDIF
    NEXT

    // set navigation columns
    ::SetNavigateCols()

    // recalibrate screen
    ::Rearrange( TRUE, TRUE )

 RETURN aRet


 /* *******************************************************************
  * Set rightfrozen columns
  *
  *    SetRightFrozen( [<anFrozen>] ) => <anRightFrozen>
  *    anFrozen : Array of column indices
  * */
 METHOD XbpBrowse:SetRightFrozen( aFrozen )

    LOCAL i, nPos, aRet

    aRet := AClone( ::RightFrozen )

    IF ValType(aFrozen) == "U"
       RETURN aRet
    ENDIF

    IF ValType(aFrozen) != "A"
       XbpException():RaiseParameterType( {aFrozen} )
    ENDIF

    // first delete all references to elements which are currently set
    // frozen
    FOR i := 1 TO LEN( ::RightFrozen )
       AAdd( ::Scrollable, ::RightFrozen[i] )
    NEXT
    ASize( ::RightFrozen, 0 )

    // now remove all elements from the scrollable and leftfrozen arrays
    // and add them to the rightfrozen
    FOR i := 1 TO LEN ( aFrozen )
       IF (nPos := AScan(::Scrollable, aFrozen[i])) <> 0
          AAdd( ::RightFrozen, ::Scrollable[nPos] )
          ADel( ::Scrollable, nPos )
          ASize( ::Scrollable, LEN(::Scrollable) - 1 )
       ELSEIF (nPos := AScan(::LeftFrozen, aFrozen[i])) <> 0
          AAdd( ::RightFrozen, ::LeftFrozen[nPos] )
          ADel( ::LeftFrozen, nPos )
          ASize( ::LeftFrozen, LEN(::LeftFrozen) - 1 )
       ENDIF
    NEXT

    // set navigation columns
    ::SetNavigateCols()

    // recalibrate screen
    ::Rearrange( TRUE, TRUE )

 RETURN aRet


 /* *******************************************************************
  * Move cursor to first column
  * */
 METHOD XbpBrowse:FirstCol ()

    // now move record cursor to first col when cell cursor is
    // used
    IF ::CursorMode == XBPBRW_CURSOR_CELL

       // dehilite current row
       IF ::nState == XBPBRW_STATE_STABLE
          ::DeHilite()
       ENDIF
       ::ColPos := 1
    ENDIF

    // redraw invisible columns
    IF ::lRedrawInvisible
       ::RedrawInvisible()
    ENDIF

    // scroll to first column
    ::ScrollPanel( 1 )
    ::Invalidate( 1, ::RowCount )

    // reset stable status
    ::nState := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Set cursor to last column
  * */
 METHOD XbpBrowse:LastCol ()

    // now move record cursor to first col when cell cursor is
    // used
    IF ::CursorMode == XBPBRW_CURSOR_CELL

       // dehilite current row
       IF ::nState == XBPBRW_STATE_STABLE
          ::DeHilite()
       ENDIF
       ::ColPos := LEN ( ::aNavigateCols )
    ENDIF

    // redraw invisible columns
    IF ::lRedrawInvisible
       ::RedrawInvisible()
    ENDIF

    // scroll to last column
    ::ScrollPanel ( ::nMaxScroll )
    ::Invalidate ( 1, ::RowCount )

    // reset stable status
    ::nState := XBPBRW_STATE_NOTSTABLE

 RETURN self


 /* *******************************************************************
  * Notification that left button was pressed on heading/footing
  *
  *    aPos    = Position relativ to origin of column
  *    aValues = { oCol  = column, nRow = index of row IN column,
  *                oCell = activated subcomponent of column (DataArea,
  *                        Heading, ... ) }
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:HFLbDown ( aPos, aValues )

    LOCAL aSize := aValues[1]:CurrentSize(), nCol, nColPos

 #define COLUMN_SIZEMODE_SIZE_AREA   4

    // inquire focus if necessary
    IF !::HasInputFocus()
       SetAppFocus( self )
    ENDIF

    // now check whether the position was within the size area of
    // the column, if yes this indicates that the user wants to size
    // the column and we will do that here
    nCol    := AScan ( ::aColumns, aValues[1] )
    nColPos := AScan ( ::Scrollable, nCol )
    IF nColPos > 0 .AND. aPos[1] <= COLUMN_SIZEMODE_SIZE_AREA .AND. ;
       ! ( nColPos == 1 .AND. aPos[1] <= COLUMN_SIZEMODE_SIZE_AREA ) ;
       .AND. ::Sizecols == TRUE

       ::BeginSizeColumn ( aValues[1], aPos, COLUMN_SIZEMODE_LEFT )
    ELSEIF nColPos > 0 .AND. aPos[1] >= aSize[1] - COLUMN_SIZEMODE_SIZE_AREA ;
       .AND. ::Sizecols == TRUE

       ::BeginSizeColumn ( aValues[1], aPos, COLUMN_SIZEMODE_RIGHT )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Notification that left button was released on heading/footing
  *
  *    aPos    = Position relativ to origin of column
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:HFLbUp ( aPos )

    IF ::nColumnSizeMode <> COLUMN_SIZEMODE_NONE
       // reset column size mode
       ::EndSizeColumn ( aPos )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Notification that left button was moved on heading/footing
  *
  *    aPos    = Position relative to origin of the scroll canvas
  *              (:oScrollBG)
  *    aValues = { oCol  = column, nRow = index of row in column,
  *                oCell = activated subcomponent of column (DataArea,
  *                        Heading, ... ) }
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:HFMotion ( aPos, aValues )

    LOCAL aSize := aValues[1]:CurrentSize(), nCol, nColPos

    aPos := AClone( aPos )

    IF ::nColumnSizeMode <> COLUMN_SIZEMODE_NONE
       // we are currently sizing the column, now call the aproriate
       // callback
       ::DoSizeColumn ( aPos, TRUE )
    ELSE
       // Convert position from browser-relative to
       // column-relative coordinates
       aPos[1] -= aValues[1]:currentPos()[1]
       aPos[1] -= ::getBg():currentPos()[1]

       // now we will indicate with the mouse cursor when the column size
       // mode has changed
       IF ( aPos[1] <= COLUMN_SIZEMODE_SIZE_AREA .OR. aPos[1] >= aSize[1] - COLUMN_SIZEMODE_SIZE_AREA  );
          .AND. ::Sizecols == TRUE

          IF ::aPointer[2] <> aValues[3]
             IF ::aPointer[1] <> 0
                ::aPointer[2]:SetPointer ( , XBPSTATIC_SYSICON_ARROW, ;
                                           XBPWINDOW_POINTERTYPE_SYSPOINTER )
                ::aPointer[1] := 0
             ENDIF
             nCol    := AScan ( ::aColumns, aValues[1] )
             nColPos := AScan ( ::Scrollable, nCol )
             IF nColPos > 0 .AND. ;
                ! ( nColPos == 1 .AND. aPos[1] <= COLUMN_SIZEMODE_SIZE_AREA )

                aValues[3]:SetPointer ( XBNATIONDLL, XBNATIONARROW, ;
                                        XBPWINDOW_POINTERTYPE_POINTER )
                ::aPointer[1] := 10
                ::aPointer[2] := aValues[3]
             ENDIF
          ENDIF
       ELSE
          IF ::aPointer[1] <> 0
             ::aPointer[2]:SetPointer ( , XBPSTATIC_SYSICON_ARROW, ;
                                        XBPWINDOW_POINTERTYPE_SYSPOINTER )
             ::aPointer[1] := 0
             ::aPointer[2] := NIL
          ENDIF
       ENDIF
    ENDIF

 RETURN self


 /* *******************************************************************
  * Left button down on data area
  * - we will only get the focus here
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:DALbDown()
 RETURN self


 /* *******************************************************************
  * Left button up on data area
  * - currently unused
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:DALbUp()
 RETURN self


 /* *******************************************************************
  * Motion on dataarea
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:DAMotion()

    // reset the mouse pointer if it was set over heading or
    // footing
    IF ::aPointer[1] <> 0
       ::aPointer[2]:SetPointer ( , XBPSTATIC_SYSICON_ARROW, ;
                                  XBPWINDOW_POINTERTYPE_SYSPOINTER )
       ::aPointer[1] := 0
       ::aPointer[2] := NIL
    ENDIF

 RETURN self


 /* *******************************************************************
  * Return column number in aNavigateCols to given Column object
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:ColNum ( oCol )

    LOCAL nColumnId, nCol

    nColumnId := AScan ( ::aColumns, oCol )
    nCol      := AScan ( ::aNavigateCols, nColumnId )

 RETURN nCol


 /* *******************************************************************
  * Overloaded Mouse movement
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:Motion ( aPos )

    // we will only get mouse messages we have the mouse capture
    // while sizing a column, then we have to forward the message
    // to the appropriate handlers
    IF ::oColumnSize <> NIL
       ::HFMotion ( aPos, { ::oColumnSize, 0 } )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Mouse left button release
  * - leave size mode IF necessary
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:LbUp ( aPos )

    // we will only get mouse messages we have the mouse capture
    // while sizing a column, then we have to forward the message
    // to the appropriate handlers
    IF ::oColumnSize <> NIL
       ::HFLbUp ( aPos )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Initialize column size mode
  * - gain mouse capture
  * - store current position of cursor and set internal vars
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:BeginSizeColumn ( oColumn, aPos, nColumnSizeMode )

    LOCAL _aPos := oColumn:CurrentPos()

    IF ::nColumnSizeMode <> COLUMN_SIZEMODE_NONE
       RETURN self
    ENDIF

    ::nColumnSizeMode := nColumnSizeMode
    ::oColumnSize     := oColumn
    ::nColumnCol      := aPos[1] + _aPos[1]
    ::nColumnColOld   := ::nColumnCol

    ::CaptureMouse ( TRUE )

    ::DoSizeColumn ( { aPos[1] + _aPos[1], aPos[2] + _aPos[2] }, FALSE )

    ::SetPointer ( XBNATIONDLL, XBNATIONARROW, XBPWINDOW_POINTERTYPE_POINTER )

 RETURN self


 /* *******************************************************************
  * Size the column
  * - called by Motion callback
  * - will only echo the current position
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:DoSizeColumn ( aPos, lDraw )

    LOCAL oPS := ::oScrollBG:LockPS( , TRUE)
    LOCAL aAttr[ GRA_AL_COUNT ]
    LOCAL aSize := ::oColumnSize:CurrentSize()

    // Draw mark
    // - delete old mark
    // - draw new mark

    // now set attributes, we will paint using the XOR mix mode
    aAttr[ GRA_AL_MIXMODE ] := GRA_FGMIX_XOR
    aAttr[ GRA_AL_WIDTH   ] := GRA_LINEWIDTH_THICK
    aAttr[ GRA_AL_COLOR   ] := GRA_CLR_WHITE
 #ifdef __OS2__
    aAttr[ GRA_AL_COLOR   ] := GRA_CLR_GREEN
    aAttr[ GRA_AL_TYPE    ] := GRA_LINETYPE_ALTERNATE
 #endif
    oPS:SetAttrLine ( aAttr )

    // delete old mark by painting over it in XOR mode
    GraLine ( oPS, { ::nColumnCol, 0 }, { ::nColumnCol, aSize[2] } )

    // store new mark and draw it
    IF lDraw
       ::nColumnCol := aPos[1] - ::xLeftFrozen + abs( ::oScrollBG:CurrentPos()[1] )
       GraLine ( oPS, { ::nColumnCol, 0 }, { ::nColumnCol, aSize[2] } )
    ENDIF

    ::oScrollBG:UnlockPS( oPS )

 RETURN self


 /* *******************************************************************
  * End column sizes
  * - apply changes to columns
  * - release mouse capture
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:EndSizeColumn ( aPos )

    LOCAL aSize := ::oColumnSize:CurrentSize(), n
    LOCAL nNewWidth

    ::CaptureMouse ( FALSE )

    ::nColumnCol := aPos[1] - ::xLeftFrozen + abs ( ::oScrollBG:CurrentPos()[1] )
    ::DoSizeColumn ( aPos, FALSE )

    IF ::nColumnSizeMode == COLUMN_SIZEMODE_RIGHT

       // the column itself is sized
       nNewWidth := aSize[1] + ( ::nColumnCol - ::nColumnColOld )
       IF nNewWidth <= 0
          nNewWidth := ::nMinWidth
       ENDIF
       ::oColumnSize:SetSize ( { nNewWidth, aSize[2] } )

    ELSEIF ::nColumnSizeMode == COLUMN_SIZEMODE_LEFT

       // size the previous column
       n := AScan ( ::aColumns, ::oColumnSize )
       IF n > 1
          aSize := ::aColumns[n - 1]:CurrentSize()
          nNewWidth := aSize[1] + ( ::nColumnCol - ::nColumnColOld )
          IF nNewWidth <= 0
             nNewWidth := ::nMinWidth
          ENDIF
          ::aColumns[n - 1]:SetSize ( { nNewWidth, aSize[2] }, TRUE )
       ENDIF
    ENDIF

    // we need to redraw the invisible columns since now former invisible
    // columns might need to be repainted
    ::RedrawInvisible()

    // now reset positions of the columns
    ::Rearrange( , TRUE )

    // reset column size mode and mouse pointer
    ::nColumnSizeMode := COLUMN_SIZEMODE_NONE
    ::oColumnSize := NIL
    ::SetPointer ( , XBPSTATIC_SYSICON_ARROW, XBPWINDOW_POINTERTYPE_SYSPOINTER )

 RETURN self


 /* *******************************************************************
  * Change font (on all subcomponents)
  * */
 METHOD XbpBrowse:SetFontCompoundName ( cFont )

    LOCAL cRet := ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME]

    IF cFont <> NIL
       // store font in all layout definitions
       ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME] := cFont
       ::HeaderLayout[XBPCOL_HFA_COMPOUNDNAME]  := cFont
       ::FooterLayout[XBPCOL_HFA_COMPOUNDNAME]  := cFont

       // now tell all childs about the new font
       AEval ( ::aColumns, { | o | o:SetFontCompoundName ( cFont ) } )

       // call parent class method to set font
       ::XbpStatic:SetFontCompoundName ( cFont )
    ENDIF

 RETURN cRet


 /* *******************************************************************
  * Change FG Color (only on drawingArea)
  * */
 METHOD XbpBrowse:SetColorFG ( nColor )

    LOCAL nRet := ::DataAreaLayout[XBPCOL_DA_FGCLR]

    IF nColor <> NIL
       // store color
       ::DataAreaLayout[XBPCOL_DA_FGCLR] := nColor
       ::XbpStatic:SetColorFG ( nColor )
       // now tell all childs about the new color
       AEval ( ::aColumns, { | o | o:SetColorFG ( nColor ) } )
    ENDIF

 RETURN nRet


 /* *******************************************************************
  * Change BG Color (only on drawingArea)
  * */
 METHOD XbpBrowse:SetColorBG ( nColor )

    LOCAL nRet := ::DataAreaLayout[XBPCOL_DA_BGCLR]

    IF nColor <> NIL
       // store color
       ::DataAreaLayout[XBPCOL_DA_BGCLR] := nColor
       ::XbpStatic:SetColorBG ( nColor )
       // now tell all childs about the new color
       AEval ( ::aColumns, { | o | o:SetColorBG ( nColor ) } )
    ENDIF

 RETURN nRet


 /* *******************************************************************
  * Change presentation parameter on browse
  * */
 METHOD XbpBrowse:SetPresParam ( aPP )

    LOCAL aRet

    IF aPP <> NIL

       // store new presparams
       aRet := ::_SetPresParam ( aPP )

       // tell all childs the new presparams
       AEval ( ::aColumns, { | o | o:SetPresParam ( aPP ) } )

       // now rearrange since the layout may have changed (by
       // chaning for etc.)
       ::Rearrange()

    ELSE

       // return current settings
       aRet := ::_GetPresParam()

    ENDIF

 RETURN aRet


 /* *******************************************************************
  * Hide Browser
  * */
 METHOD XbpBrowse:Hide ()
 RETURN ::XbpStatic:Hide()


 /* *******************************************************************
  * Display Browser
  * - the special thing is here that we might stabilize and rearrange
  *   the browser when columns have been added while the browser was
  *   invisible
  * */
 METHOD XbpBrowse:Show ()

    LOCAL lRet

    // the invisible cols must be redrawn since this might change
    ::lRedrawInvisible := TRUE

    // now set our visible flag
    ::visible          := TRUE

    // when columns have been added while the browser was invisible,
    // arranging and stabilizing was deferred, so that we have to
    // do this now
    IF ::nState <> XBPBRW_STATE_STABLE
       ::Rearrange( TRUE )                   // adjust positions
       ::Invalidate ( 1, ::RowCount )        // rowcount may have changed
       ::handleEvent( xbeBRW_ForceStable )   // stabilize
    ELSE
       ::SetVisibleCols()                    // determine visible/invisible cols
    ENDIF
    lRet := ::XbpStatic:Show()
    ::XbpStatic:InvalidateRect()             // invalidate since not
                                             // all components of the browser
                                             // maybe redrawn since we
                                             // have clipping set
 RETURN lRet


 /* *******************************************************************
  * Set Navigate Columns
  * - calculate new navigation order of columns
  *
  *    SetNavigateCols () => <self>
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:SetNavigateCols()

   LOCAL i

   // Set Navigate Columns:
   // This is an array with column numbers (Ref to ::aColumns) which
   // represents the physical order of the columns in the browser.
   // ::ColPos points to an index in this array, not to ::aColumns!!
   // The order is as follows:
   //
   //   1. ::LeftFrozen columns
   //   2. ::Scrollable columns
   //   3. ::RightFrozen columns
   //
   ::aNavigateCols := {}
   FOR i := 1 TO LEN ( ::LeftFrozen )
      Aadd ( ::aNavigateCols, ::LeftFrozen[i] )
   NEXT
   FOR i := 1 TO LEN ( ::Scrollable )
      Aadd ( ::aNavigateCols, ::Scrollable[i] )
   NEXT
   FOR i := 1 TO LEN ( ::RightFrozen )
      Aadd ( ::aNavigateCols, ::RightFrozen[i] )
   NEXT

 RETURN self


 /* *******************************************************************
  * Set visible/invisible Columns
  *
  *    SetVisibleCols () => <self>
  *
  * Set internal arrays which hold the references to the visible/invisible
  * columns.
  *
  * */
 METHOD XbpBrowse:SetVisibleCols()

   LOCAL i, oCol, nXSizeBG, nXPos, nXSize
   LOCAL nLeftOffset := ::oScrollBG:CurrentPos()[1]

   // when I am invisible, I will just make sure that we
   // dont have visible columns
   IF ::Visible == FALSE
      ::aVisibleCols   := {}
      ::aInvisibleCols := AClone ( ::aNavigateCols )
      RETURN self
   ENDIF
   nXSizeBG := ::oBG:CurrentSize()[1]

   // reset the internal arrays
   ::aVisibleCols   := {}
   ::aInvisibleCols := {}

   // now we have to walk over all scrollable columns in order
   // to check whether it is visible or not
   FOR i := 1 TO LEN ( ::Scrollable )
      oCol   := ::aColumns[::Scrollable[i]]
      nXPos  := oCol:CurrentPos()[1]
      nXSize := oCol:CurrentSize()[1]
      IF ( ( nXPos + nXSize + nLeftOffset >= 0 ) .AND. ;
           ( nXPos + nXSize + nLeftOffset <= nXSizeBG ) ) .OR. ;
         ( ( nXPos + nLeftOffset          >= 0 ) .AND. ;
           ( nXPos + nLeftOffset          < nXSizeBG ) ) .OR. ;
           ( ::colCount == 1 .AND. nXSize > 0 )

         // the column is visible
         AAdd ( ::aVisibleCols, ::Scrollable[i] )
      ELSE
         // the column is not visible
         AAdd ( ::aInvisibleCols, ::Scrollable[i] )
      ENDIF
   NEXT

   // the frozen columns are always visible
   FOR i := 1 TO LEN ( ::Leftfrozen )
      AAdd ( ::aVisibleCols, ::Leftfrozen[i] )
   NEXT
   FOR i := 1 TO LEN ( ::Rightfrozen )
      AAdd ( ::aVisibleCols, ::Rightfrozen[i] )
   NEXT

 RETURN self


 /* *******************************************************************
  * Internal method to set presparams in Init, Create and Configure
  * methods
  *  - only store the values in the internal arrays, do not forward
  *    the presparam settings to the parent class or the childs
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:_SetPresParam ( aPresParam )

    LOCAL aRet, aPP := {}, nPos

    // apply the browse and column specific settings
    aRet := xbpAssignPPBundle ( ::DataAreaLayout, aPresParam, XBP_PP_COL_DA_BASE )
    IF ! Empty ( ( aPP := xbpAssignPPBundle ( ::HeaderLayout, aPresParam, ;
                                              XBP_PP_COL_HA_BASE ) ) )
       AAdd ( aRet, aPP )
    ENDIF
    IF ! Empty ( ( aPP := xbpAssignPPBundle ( ::FooterLayout, aPresParam, ;
                                              XBP_PP_COL_FA_BASE ) ) )
       AAdd ( aRet, aPP )
    ENDIF

    // now apply the special settings concerning the data area:
    //  XBP_PP_FGCLR         -> XBP_PP_COL_DA_FGCLR
    //  XBP_PP_BGCLR         -> XBP_PP_COL_DA_BGCLR
    //  XBP_PP_HILITE_FGCLR  -> XBP_PP_COL_DA_HILITE_FGCLR
    //  XBP_PP_HILITE_BGCLR  -> XBP_PP_COL_DA_HILITE_BGCLR
    //  XBP_PP_COMPOUNDNAME  -> XBP_PP_COL_DA_COMPOUNDNAME
    nPos := AScan ( aPresParam, { | aPPVal | aPPVal[1] == XBP_PP_FGCLR } )
    IF nPos > 0
       ::DataAreaLayout[XBPCOL_DA_FGCLR] := aPresParam[nPos, 2]
       AAdd ( aPresParam, { XBP_PP_COL_DA_FGCLR, aPresParam[nPos, 2] } )
    ENDIF
    nPos := AScan ( aPresParam, { | aPPVal | aPPVal[1] == XBP_PP_BGCLR } )
    IF nPos > 0
       ::DataAreaLayout[XBPCOL_DA_BGCLR] := aPresParam[nPos, 2]
       AAdd ( aPresParam, { XBP_PP_COL_DA_BGCLR, aPresParam[nPos, 2] } )
    ENDIF
    nPos := AScan ( aPresParam, { | aPPVal | aPPVal[1] == XBP_PP_HILITE_FGCLR } )
    IF nPos > 0
       ::DataAreaLayout[XBPCOL_DA_HILITE_FGCLR] := aPresParam[nPos, 2]
       AAdd ( aPresParam, { XBP_PP_COL_DA_HILITE_FGCLR, aPresParam[nPos, 2] } )
    ENDIF
    nPos := AScan ( aPresParam, { | aPPVal | aPPVal[1] == XBP_PP_HILITE_BGCLR } )
    IF nPos > 0
       ::DataAreaLayout[XBPCOL_DA_HILITE_BGCLR] := aPresParam[nPos, 2]
       AAdd ( aPresParam, { XBP_PP_COL_DA_HILITE_BGCLR, aPresParam[nPos, 2] } )
    ENDIF
    nPos := AScan ( aPresParam, { | aPPVal | aPPVal[1] == XBP_PP_COMPOUNDNAME } )
    IF nPos > 0
       ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME] := aPresParam[nPos, 2]
       AAdd ( aPresParam, { XBP_PP_COL_DA_COMPOUNDNAME, aPresParam[nPos, 2] } )
    ENDIF

 RETURN aRet


 /* *******************************************************************
  * Return preparam settings from bundles
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:_GetPresParam ()

  LOCAL aPP
  LOCAL aRet := {}

    aRet := xbpGetPPBundle( ::DataAreaLayout, XBP_PP_COL_DA_BASE )
    aPP  := xbpGetPPBundle( ::HeaderLayout, XBP_PP_COL_HA_BASE)
    AEval( aPP, {|x| AAdd(aRet, x)} )
    aPP  := xbpGetPPBundle( ::FooterLayout, XBP_PP_COL_FA_BASE )
    AEval( aPP, {|x| AAdd(aRet, x)} )

 RETURN aRet


 /* *******************************************************************
  * Scroll the given number of rows up
  *
  *    ScrollUp( nRows ) => self
  * */
 METHOD XbpBrowse:ScrollUp( nRows )

    // Tell the column objects to scroll
    AEval ( ::aVisibleCols, { | n, i | ::aColumns[n]:ScrollUp ( nRows, TRUE ) } )
    AEval ( ::aInvisibleCols, { | n, i | ::aColumns[n]:ScrollUp ( nRows, FALSE ) } )

    // Now scroll the rowrecno buffer
    ACopy ( ::aRecNo, ::aRecNo, nRows + 1, LEN ( ::aRecNo ) - nRows, 1 )

    // For the most cases, the last row is displayed only partly, when
    // this row is to be scrolled up, it needs to be repainted

    // We scrolled, now all invisible rows have to repainted the next time
    // they are displayed
    ::lRedrawInvisible := TRUE

 RETURN


 /* *******************************************************************
  * Scroll the given number of rows down
  *
  *    ScrollDown( nRows ) => self
  * */
 METHOD XbpBrowse:ScrollDown( nRows )

    // Tell the column objects to scroll
    AEval ( ::aVisibleCols, { | n, i | ::aColumns[n]:ScrollDown ( nRows, TRUE ) } )
    AEval ( ::aInvisibleCols, { | n, i | ::aColumns[n]:ScrollDown ( nRows, FALSE ) } )

    // now scroll the rowrecno buffer
    ACopy ( ::aRecNo, ::aRecNo, 1, LEN ( ::aRecNo ) - nRows, nRows + 1 )

    // we scrolled, now all invisible rows have to repainted the next time
    // they are displayed
    ::lRedrawInvisible := TRUE

 RETURN


 /* *******************************************************************
  * Inquire the values of the current record position
  *
  *      GetData() => axData
  * */
 METHOD XbpBrowse:GetData ()

   LOCAL axData

    ::ForceStable()

   // the editbuffer method will provide us with the information
   axData := ::EditBuffer()

   // now forward the call to :dataref to eval the :datalink
   ::DataRef:GetData ( axData )

 RETURN axData


 /* *******************************************************************
  * Inquire the values of the current record position
  *
  *   EditBuffer () => axData
  *
  * */
 METHOD XbpBrowse:EditBuffer ()

   LOCAL axData := {}, i, imax, oColumn

   IF ::CursorMode == XBPBRW_CURSOR_ROW
      IF ::nState == XBPBRW_STATE_STABLE
         imax := LEN ( ::aNavigateCols )
         ASize( axData, imax )
         FOR i := 1 TO imax
            oColumn   := ::aColumns[::aNavigateCols[i]]
            /* now the columns store the valtype directly */
            axData[i] := oColumn:GetRow ( ::RowPos )
            /* in case that there are invisible columns, these
             * rows need to be drawn and we may then fetch
             * the data */
            IF ValType( axData[i] ) == "U"
               oColumn:DrawRow ( ::RowPos, FALSE )
               axData[i] := oColumn:GetRow ( ::RowPos )
            ENDIF
         NEXT i
      ENDIF
   ELSEIF ::CursorMode == XBPBRW_CURSOR_CELL
      IF ::nState == XBPBRW_STATE_STABLE
         oColumn   := ::aColumns[::aNavigateCols[::ColPos]]
         /* now the columns store the valtype directly */
         axData    := { oColumn:GetRow ( ::RowPos ) }
      ENDIF
   ENDIF

 RETURN axData


 /* *******************************************************************
  * Inquire item from given position
  *
  *    ItemFromPos( aPos ) => { nRow, nCol }
  *
  * NOTE: internal
  * */
 METHOD XbpBrowse:ItemFromPos( _aPos )

    LOCAL nRow, nCol := 0, aBGPos, i, aPos, aSize, aDAPos
    LOCAL nLeftOffset := ::oScrollBG:CurrentPos()[1]

    aBGPos := ::oBG:CurrentPos()

    // find the matching column object
    // 1. try the leftfrozen columns
    FOR i := 1 TO LEN ( ::Leftfrozen )
       aPos  := ::aColumns[::Leftfrozen[i]]:CurrentPos()
       aSize := ::aColumns[::Leftfrozen[i]]:CurrentSize()
       IF _aPos[1] >= aPos[1] .AND. _aPos[1] <= aPos[1] + aSize[1]
          nCol := i
       ENDIF
    NEXT i

    // 2. scrollable columns
    IF nCol == 0
       FOR i := 1 TO LEN ( ::Scrollable )
          aPos  := ::aColumns[::Scrollable[i]]:CurrentPos()
          aSize := ::aColumns[::Scrollable[i]]:CurrentSize()
          IF _aPos[1] >= aPos[1] + aBGPos[1] + nLeftOffset .AND. ;
             _aPos[1] <= aPos[1] + aBGPos[1] + aSize[1] + nLeftOffset
             nCol := i + LEN ( ::LeftFrozen )
          ENDIF
       NEXT i
    ENDIF

    // 3. rightfrozen columns
    IF nCol == 0
       FOR i := 1 TO LEN ( ::Rightfrozen )
          aPos  := ::aColumns[::Rightfrozen[i]]:CurrentPos()
          aSize := ::aColumns[::Rightfrozen[i]]:CurrentSize()
          IF _aPos[1] >= aPos[1] .AND. _aPos[1] <= aPos[1] + aSize[1]
             nCol := i + LEN ( ::LeftFrozen ) + LEN ( ::Scrollable )
          ENDIF
       NEXT i
    ENDIF

    // the row is clculated using the position of the background
    aDAPos := BRW_GetColObject(nCol):DataArea:CurrentPos()
    nRow   := BRW_GetColObject(nCol):DataArea:CellFromPos( { 1, ;
                                    _aPos[2] - aBGPos[2] - aDAPos[2] } )

 RETURN { nRow, nCol }


 /* *******************************************************************
  * Navigate callback method
  *
  *    Navigate ( mp1, mp2 ) => self
  * */
 METHOD XbpBrowse:Navigate( Mp1, Mp2 )

    LOCAL i

    // When we have no rows we wont navigate
    IF ::RowCount == 0
       RETURN
    ENDIF

    // The navigation code is stored in the message parameter #1
    DO CASE
       CASE mp1 == XBPBRW_Navigate_NextLine
          ::Down( , TRUE )
       CASE mp1 == XBPBRW_Navigate_PrevLine
          ::Up( , TRUE )
       CASE mp1 == XBPBRW_Navigate_NextPage
          ::PageDown( TRUE )
       CASE mp1 == XBPBRW_Navigate_PrevPage
          ::PageUp( TRUE )
       CASE mp1 == XBPBRW_Navigate_GoBottom
          ::GoBottom( TRUE )
       CASE mp1 == XBPBRW_Navigate_GoTop
          ::GoTop( TRUE )
       CASE mp1 == XBPBRW_Navigate_Skip
          ::RowSkip( Mp2, TRUE )
       CASE mp1 == XBPBRW_Navigate_NextCol
          ::Right( TRUE )
       CASE mp1 == XBPBRW_Navigate_PrevCol
          ::Left( TRUE )
       CASE mp1 == XBPBRW_Navigate_FirstCol
          ::FirstCol( TRUE )
       CASE mp1 == XBPBRW_Navigate_LastCol
          ::LastCol( TRUE )
       CASE mp1 == XBPBRW_Navigate_SkipCols
          IF Mp2 > 0
             FOR i := 1 TO Mp2
                ::Right( TRUE )
             NEXT
          ELSE
             FOR i := 1 TO ABS ( Mp2 )
                ::Left( TRUE )
             NEXT
          ENDIF
       CASE mp1 == XBPBRW_Navigate_GoPos
          // Navigate to percentage position by evaluating the goposblock
          Eval( ::GoPosBlock, Mp2, self )
          // it is likely that we scrolled, now we have to redrawin invisible
          ::lRedrawInvisible := TRUE
          // now we have to refresh all
          ::RefreshAll( FALSE )
    ENDCASE

    // stabilize
    IF ! PostAppEvent ( xbeBRW_ForceStable,,, self, TRUE )
       ::handleEvent( xbeBRW_ForceStable )
    ENDIF

 RETURN self


 /* *******************************************************************
  * Pan callback (for scrollbar) method
  *
  *    Pan ( mp1, mp2 ) => self
  *
  *         mp1: <nPanCommand> (Pan_Left, Pan_Right, Pan_Home, Pan_End)
  *         mp2: [<nPanCols>]  (only for Pan_Left, Pan_Right)
  *
  * */
 METHOD XbpBrowse:Pan( Mp1, Mp2 )

    // process pan/scroll message, mp1 contains the code
    DO CASE
       CASE Mp1 == XBPBRW_Pan_Left
          ::PanLeft( Mp2 )
       CASE Mp1 == XBPBRW_Pan_Right
          ::PanRight( Mp2 )
       CASE Mp1 == XBPBRW_Pan_FirstCol
          ::PanHome()
       CASE Mp1 == XBPBRW_Pan_LastCol
          ::PanEnd()
       CASE Mp1 == XBPBRW_Pan_Track
          ::oScrollBG:SetPos( { Mp2 * -1, ::oScrollBG:CurrentPos()[2] } )
          ::oHScroll:SetData( Mp2 )
    ENDCASE

 RETURN self


 /* *******************************************************************
  * Cell must be redrawn through owner-drawing. If :DrawMode has been
  * set to "XBP_DRAW_OWNER", "xbeP_CustomDrawCell" is generated
  * immediately after the background of the cell has been cleared,
  * but before the value of the cell is rendered. If the browser is to
  * perform default processing for this event (i.e. render the cell
  * value), the application must return TRUE. If :DrawMode is
  * "XBP_DRAW_OWNERADVANCED", "xbeP_CustomDrawCell" is send immediately
  * before the individual cell elements (its background, frame and
  * foreground) is rendered. The browser does not perform any default
  * rendering, unless the application returns TRUE.
  *
  *  Array "aInfo" has the following format:
  *    <aInfo> : {nRow, nAction, nState, aRect, oArea, oCol }
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
  *    oCol   : Column that contains the cell
  *    oArea  : Column area that contains the cell
  * */
 METHOD XbpBrowse:CustomDrawCell( oPS, aInfo )
    UNUSED( oPS )
    UNUSED( aInfo )
 RETURN .T.


 /* *******************************************************************
  * Inquire currently visible record numbers
  * */
 METHOD XbpBrowse:VisibleRecords()
 RETURN AClone ( ::aRecNo )



 /* ************************************************************************
  * Service level
  */

 /* *******************************************************************
  * insert the given value in the array and provide ascending order
  * */
 FUNCTION AInsNumbered ( aArray, nValue )

    LOCAL i, l

    l := LEN ( aArray )
    i := 1
    WHILE i <= l .AND. nValue >= aArray[i]
       i++
    ENDDO
    AAdd ( aArray, NIL )
    AIns ( aArray, i, nValue )

 RETURN aArray

 /* *******************************************************************
  * Calculate the position given relative from oXBP relative the given
  * XBP oXBPRel
  * */
 PROCEDURE AdjustPos ( oXBPRel, aPos, oXBP )

    LOCAL _aPos

    _aPos := oXBP:CurrentPos ()
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    oXBP := oXBP:SetPArent()

    IF oXBPRel <> oXBP
       AdjustPos ( oXBPRel, aPos, oXBP )
    ENDIF

 RETURN

 /* *******************************************************************
  * Adjust the internal column arrays of the browser
  * */
 PROCEDURE AdjustColumnArrays( oBrowse, nIndex, nLevel )
    LOCAL i
    DEFAULT nLevel TO -1
    FOR i := 1 TO Len( oBrowse:Scrollable )
       IF nLevel < 0
          IF oBrowse:Scrollable[i] > nIndex
             oBrowse:Scrollable[i] += nLevel
          ENDIF
       ELSE
          IF oBrowse:Scrollable[i] >= nIndex
             oBrowse:Scrollable[i] += nLevel
          ENDIF
       ENDIF
    NEXT
    FOR i := 1 TO Len( oBrowse:Leftfrozen )
       IF nLevel < 0
          IF oBrowse:Leftfrozen[i] > nIndex
             oBrowse:Leftfrozen[i] += nLevel
          ENDIF
       ELSE
          IF oBrowse:Leftfrozen[i] >= nIndex
             oBrowse:Leftfrozen[i] += nLevel
          ENDIF
       ENDIF
    NEXT
    FOR i := 1 TO Len( oBrowse:Rightfrozen )
       IF nLevel < 0
          IF oBrowse:Rightfrozen[i] > nIndex
             oBrowse:Rightfrozen[i] += nLevel
          ENDIF
       ELSE
          IF oBrowse:Rightfrozen[i] >= nIndex
             oBrowse:Rightfrozen[i] += nLevel
          ENDIF
       ENDIF
    NEXT
 RETURN


 STATIC FUNCTION BRWOriginTopLeft( oXbp )

  LOCAL aPP
  LOCAL n
  LOCAL x := XBP_ORIGIN_BOTTOMLEFT

    DO WHILE .T.
       IF IsMethod(oXbp, "SetPresParam") == .T.
          aPP := oXbp:SetPresParam()
          n   := AScan( aPP, XBP_PP_ORIGIN )
          IF n > 0 .AND. aPP[n][2] != NIL
             x := aPP[n][2]
             EXIT
          ENDIF
       ENDIF

       IF oXbp == AppDesktop()
          EXIT
       ENDIF

       oXbp := oXbp:SetParent()
    ENDDO

 RETURN (x==XBP_ORIGIN_TOPLEFT)

 // EOF