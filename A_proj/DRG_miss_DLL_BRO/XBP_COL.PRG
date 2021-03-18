//////////////////////////////////////////////////////////////////////
//
//     xbp_col.prg
//
//  Copyright:
//     Alaska Software, (c) 1997-2010. All rights reserved.
//
//  Contents :
//
//     XbpColumn source code
//
//////////////////////////////////////////////////////////////////////

 #include "common.ch"
 #include "appevent.ch"
 #include "xbp.ch"
 #include "gra.ch"

 #include "xbp_brw.ch"


 ///////////////////////////////////////////////////////////////////////////////


 /* **********************************************************************
  * static storage
  */
 STATIC aTransDA, aTransHFA


 /* **********************************************************************
  * Some Helper Macros
  */

 /* macro to inquire whether the col has footing */
 #xtrans COL_HasFooting()                                         ;
     => ( self:FooterLayout\[XBPCOL_HFA_CAPTION] != NIL )

 /* macro to inquire whether the col has heading */
 #xtrans COL_HasHeading()                                         ;
     => ( self:HeaderLayout\[XBPCOL_HFA_CAPTION] != NIL )

 #xtrans COL_OriginTopLeft()                                      ;
     => (ColOriginTopLeft(self))

 ///////////////////////////////////////////////////////////////////////////////


 /* **********************************************************************
  * XbpColumn class implementation
  * */
 CLASS XbpColumn FROM XbpStatic, DataRef

  #ifdef RTL_DEBUG
   #define __DBG
  #else
   #define __DBG  NODEBUG
  #endif

  EXPORTED:
                               ** Layout Creation Flags
    VAR DataAreaLayout  __DBG  // Layout of the Data Area Bundle
    VAR HeaderLayout    __DBG  // Header Area Layout Bundle
    VAR FooterLayout    __DBG  // Footer Area Layout Bundle

    VAR RowCount        __DBG  // Number of rows ( == -1: calc the rowcount
                               // according to size)
    VAR AdjustHeight           // Adjust number of rows so that they match
                               // the column height and no rows are partly
                               // visible - this setting is inherited from
                               // owner
    VAR DrawMode               // One of XBP_DRAW_NORMAL or XBP_DRAW_OWNER
    ASSIGN METHOD SetDrawMode() VAR DrawMode
                                ** Browser Subcomponents
    VAR Heading                // Heading
    VAR Footing                // Footing
    VAR DataArea               // Column body

    VAR ValType                // The column data type

    VAR Type                   // The Display type (BITMAP, TEXT, etc.)
    VAR ColorBlock             // The Color Block

                               ** Asynchronous Callbacks
    VAR ItemMarked      __DBG  // an item was marked (one click)
    VAR ItemActivated   __DBG  // an item was activated (double click, ENTER, RETURN)
    VAR ItemRbDown      __DBG  // rbDown on the dataarea
    VAR HeaderRbDown    __DBG  // rbDown on the heading
    VAR FooterRbDown    __DBG  // rbDown on the footer

  PROTECTED:
                               ** Internal data
    VAR Size            __DBG  // window size
    VAR _RowCount       __DBG  // internal rowcount, used as calculation base

    VAR EditBuffer      __DBG  // editbuffer, contains last displayed cell

    VAR HasCellColor    __DBG  // marks rows which have colour set
    VAR RefreshRows     __DBG  // invalid rows which have to be refreshed from
                               // the data link in the next redraw cycle
    VAR Invalid         __DBG  // invalid rows which have to be repainted in the
                               // next redraw cycle
    VAR Mark            __DBG  // the mark

  EXPORTED:
                               ** Overloaded Methods
    METHOD Init, Create        // Lifecycle
    METHOD Configure           // Lifecycle
    METHOD Destroy             // Lifecycle
    CLASS METHOD InitClass     // Class initialization

    METHOD SetFontCompoundName // change font
    METHOD SetColorFG          // change FG Color (only on dataArea)
    METHOD SetColorBG          // change BG Color (only on dataArea)
    METHOD SetPresParam        // change Presentation parameter

    METHOD SetSize             // Resize rearranges the childs

    METHOD EditBuffer          // Overloaded from Dataref

                               ** Manipulation Methods
    METHOD ScrollUp            // scroll Rows
    METHOD ScrollDown          // scroll Rows

                               ** Display Methods
    METHOD DrawRow             // draw/Refresh row
    METHOD HiliteRow           // hilite Row
    METHOD RefreshRows         // force rows to be refreshed on next update cycle
    METHOD RefreshRow          // force one row to be refreshed on next update cycle
    METHOD GetRow              // get row data
    METHOD RowCount            // get number of rows
    METHOD Redraw              // redraw invalidated rows

                               ** Asynchronous Callbacks
    METHOD ItemLbDown          // an item was marked (lb down)
    METHOD ItemLbDblClick      // an item was activated (double click, ENTER, RETURN)
    METHOD ItemRbDown          // rbDown on the dataarea
    METHOD HeaderRbDown        // rbDown on the heading
    METHOD FooterRbDown        // rbDown on the footing

                               ** Internal Callbacks
    METHOD RowLbDown           // lbDown on a row in the dataarea
    METHOD RowLbUp             // lbUp on a row in the dataarea
    METHOD RowMotion           // motion on a row in the dataarea

                               ** other stuff
    METHOD SetMark             // set/get internal marking variable

    VAR    Picture             // Picture mask used for output; only used for
    ASSIGN METHOD SetPicture() // columns of type XBPCOL_TYPE_TEXT

    ASSIGN METHOD SetUseVisualStyle()
                               ** Internal Service level stuff
  PROTECTED:
    METHOD _SetPresParam       // set presentation parameter
    METHOD _GetPresParam       // inquire current presentation parameter
    METHOD Rearrange           // reconfiguration

    METHOD Validate            // Validate the invalid rows

 ENDCLASS

 /* **********************************************************************
  * CLASS Intialization will initialize the transformation arrays
  * */
 CLASS METHOD XbpColumn:InitClass()

    aTransHFA := ARRAY ( XBPCOL_HFA_COUNT )
    aTransHFA[XBPCOL_HFA_FGCLR       ] := XBP_PP_FGCLR
    aTransHFA[XBPCOL_HFA_BGCLR       ] := XBP_PP_BGCLR
    aTransHFA[XBPCOL_HFA_COMPOUNDNAME] := XBP_PP_COMPOUNDNAME
    aTransHFA[XBPCOL_HFA_FRAMELAYOUT ] := XBP_PP_CGRP_FRAMELAYOUT
    aTransHFA[XBPCOL_HFA_ALIGNMENT   ] := XBP_PP_CGRP_CELLALIGNMENT
    aTransHFA[XBPCOL_HFA_HEIGHT      ] := XBP_PP_CGRP_ROWHEIGHT

    aTransDA := ARRAY ( XBPCOL_DA_COUNT )
    aTransDA[XBPCOL_DA_FGCLR            ] := XBP_PP_FGCLR
    aTransDA[XBPCOL_DA_BGCLR            ] := XBP_PP_BGCLR
    aTransDA[XBPCOL_DA_HILITE_FGCLR     ] := XBP_PP_HILITE_FGCLR
    aTransDA[XBPCOL_DA_HILITE_BGCLR     ] := XBP_PP_HILITE_BGCLR
    aTransDA[XBPCOL_DA_COMPOUNDNAME     ] := XBP_PP_COMPOUNDNAME
    aTransDA[XBPCOL_DA_ROWWIDTH         ] := XBP_PP_CGRP_ROWWIDTH
    aTransDA[XBPCOL_DA_ROWHEIGHT        ] := XBP_PP_CGRP_ROWHEIGHT
    aTransDA[XBPCOL_DA_CELLWIDTH        ] := XBP_PP_CGRP_CELLWIDTH
    aTransDA[XBPCOL_DA_CELLHEIGHT       ] := XBP_PP_CGRP_CELLHEIGHT
    aTransDA[XBPCOL_DA_CELLALIGNMENT    ] := XBP_PP_CGRP_CELLALIGNMENT
    aTransDA[XBPCOL_DA_ROWSEPARATOR     ] := XBP_PP_CGRP_HSEPARATOR
    aTransDA[XBPCOL_DA_COLSEPARATOR     ] := XBP_PP_CGRP_VSEPARATOR
    aTransDA[XBPCOL_DA_FRAMELAYOUT      ] := XBP_PP_CGRP_FRAMELAYOUT
    aTransDA[XBPCOL_DA_CELLFRAMELAYOUT  ] := XBP_PP_CGRP_CELLFRAMELAYOUT
    aTransDA[XBPCOL_DA_HILITEFRAMELAYOUT] := XBP_PP_CGRP_HILITEFRAMELAYOUT

 RETURN self


 /* **********************************************************************
  * Overloaded Init method
  * */
 METHOD XbpColumn:Init ( oParent, oOwner, aPos, aSize, aPresParam, lVisible )

    DEFAULT oParent    TO SetAppWindow()
    DEFAULT oOwner     TO oParent
    DEFAULT aSize      TO { 0, 0 }
    DEFAULT lVisible   TO TRUE

    // Call parent class method and overload some predefined behaviours
    ::XbpStatic:Init ( oParent, oOwner, aPos, aSize, , FALSE )
    ::XbpStatic:Type := XBPSTATIC_TYPE_BGNDFRAME
    ::XbpStatic:ClipChildren := TRUE
    ::Size    := AClone ( aSize )
    ::Visible := lVisible

    // Initialize Layout
    ::RowCount       := XBP_AUTOSIZE
    ::DataAreaLayout := ARRAY ( XBPCOL_DA_COUNT )
    ::HeaderLayout   := ARRAY ( XBPCOL_HFA_COUNT )
    ::FooterLayout   := ARRAY ( XBPCOL_HFA_COUNT )
    ::DataAreaLayout[XBPCOL_DA_CHARWIDTH] := XBP_AUTOSIZE
    ::FooterLayout[XBPCOL_HFA_HEIGHT] := XBP_AUTOSIZE
    ::HeaderLayout[XBPCOL_HFA_HEIGHT] := XBP_AUTOSIZE

    ::_RowCount      := 0

    // Set Presparams
    IF aPresParam <> NIL
       ::_SetPresParam ( aPresParam )
    ENDIF

    // Initialize the subcomponents
    ::DrawMode  := XBP_DRAW_NORMAL

    ::Heading   := XbpCellGroup():New( self, self )
    ::Footing   := XbpCellGroup():New( self, self )
    ::DataArea  := XbpCellGroup():New( self, self )
    ::DataArea:ReferenceString := "W"
    ::Footing:ReferenceString  := "W"
    ::Heading:ReferenceString  := "W"

    // Initialize remaining information
    ::Type         := XBPCOL_TYPE_TEXT
    ::RefreshRows  := Array(0)
    ::HasCellColor := Array(0)
    ::Invalid      := Array(0)
    ::AdjustHeight := FALSE

    ::Picture      := ""

 RETURN self


 /* **********************************************************************
  * Create method
  * */
 METHOD XbpColumn:Create ( oParent, oOwner, aPos, aSize, aPresParam, lVisible )

    LOCAL xSizeDataArea, xSizeFooting, xSizeHeading
    LOCAL ySizeDataArea, ySizeFooting, ySizeHeading
    LOCAL aPPDataArea, aPPHeading, aPPFooting
    LOCAL nLen, nTmp, aTmp
    LOCAL lIsTopLeft := COL_OriginTopLeft()

    // Save size and position
    IF ! aSize == NIL
       ::Size := AClone ( aSize )
    ENDIF
    DEFAULT lVisible   TO ::Visible
    DEFAULT oOwner     TO ::SetOwner()

    // Now inherit our settings from our owner, when this is an xbpBrowse
    // object.
    IF ValType(oOwner) == "O" .AND. oOwner:IsDerivedFrom( XbpBrowse() )
      xbpInheritBundle( ::DataAreaLayout, oOwner:DataAreaLayout )
      xbpInheritBundle( ::HeaderLayout,   oOwner:HeaderLayout )
      xbpInheritBundle( ::FooterLayout,   oOwner:FooterLayout )
      ::AdjustHeight := oOwner:AdjustHeight
    ENDIF

    // Store our presparams
    IF aPresParam <> NIL
       ::_SetPresParam ( aPresParam )
    ENDIF

    // Call parent class method to request the system resources
    // NOTE: we will create our object invisible so that we can
    //       create faster and smoother.
    ::XbpStatic:Create ( oParent, oOwner, aPos, ::Size, aPresParam, FALSE )

    // Add default reference string, this string is used from the column
    // when its CharWidth == -1. If a charwidth is passed, a string of the
    // specified character count containing the "W" char is used.
    // The "W" char is the widest character in the charset.
    // NOTE: We will call the datalink codeblock once to get the ValType!
    ::DataArea:ReferenceString := _Block2String ( @::ValType, ::DataLink, self )

    // Set cellalignment if it was not set yet
    IF ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] == NIL
       DO CASE
          CASE ::ValType == "L"
          ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := XBPALIGN_HCENTER + XBPALIGN_VCENTER
          CASE ::ValType == "C"
          ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := XBPALIGN_LEFT + XBPALIGN_VCENTER
          CASE ::ValType == "D"
          ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := XBPALIGN_RIGHT + XBPALIGN_VCENTER
          CASE ::ValType == "M"
          ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := XBPALIGN_LEFT + XBPALIGN_VCENTER
          CASE ::ValType == "N"
          ::DataAreaLayout[XBPCOL_DA_CELLALIGNMENT] := XBPALIGN_RIGHT + XBPALIGN_VCENTER
       ENDCASE
    ENDIF

    // Determine the layout of the components and apply this.
    aPPDataArea := xbpGetDABundle ( ::DataAreaLayout )
    aPPHeading  := xbpGetHFABundle( ::HeaderLayout )
    aPPFooting  := xbpGetHFABundle( ::FooterLayout )
    AAdd( aPPHeading, { XBP_PP_CGRP_CELLFRAMELAYOUT, XBPFRAME_NONE } )
    AAdd( aPPHeading, { XBP_PP_CGRP_HILITEFRAMELAYOUT, XBPFRAME_NONE } )
    AAdd( aPPFooting, { XBP_PP_CGRP_CELLFRAMELAYOUT, XBPFRAME_NONE } )
    AAdd( aPPFooting, { XBP_PP_CGRP_HILITEFRAMELAYOUT, XBPFRAME_NONE } )

   IF ::DataAreaLayout[XBPCOL_DA_CHARWIDTH] <> XBP_AUTOSIZE
       ::DataArea:ReferenceString := REPLICATE ( "W", ::DataAreaLayout[XBPCOL_DA_CHARWIDTH] )
    ELSE
       nLen := Len( ::DataArea:ReferenceString )
       IF Valtype( ::FooterLayout[XBPCOL_HFA_CAPTION] ) == "C" .AND. ;
          Len( ::FooterLayout[XBPCOL_HFA_CAPTION] ) > nLen
          nLen := Len( ::FooterLayout[XBPCOL_HFA_CAPTION] )
          ::DataArea:ReferenceString := ::FooterLayout[XBPCOL_HFA_CAPTION]
       ENDIF

       IF Valtype( ::HeaderLayout[XBPCOL_HFA_CAPTION] ) == "C" .AND. ;
          Len( ::HeaderLayout[XBPCOL_HFA_CAPTION] ) > nLen
          ::DataArea:ReferenceString := ::HeaderLayout[XBPCOL_HFA_CAPTION]
       ENDIF
    ENDIF

    // Create the subcomponents:

    // Create Footing
    ::Footing:MaxRow := 1
    IF ::FooterLayout[XBPCOL_HFA_CAPTION] != NIL
       IF ::FooterLayout[XBPCOL_HFA_HEIGHT] == XBP_AUTOSIZE
          ::Footing:ReferenceString := IF ( !Empty( ::FooterLayout[XBPCOL_HFA_CAPTION] ), ;
                                            ::FooterLayout[XBPCOL_HFA_CAPTION], "W" )
       ENDIF
       IF ::UseVisualStyle == .T. .AND. IsThemeActive(.T.) == .T.
          nTmp := AScan( aPPFooting, {|e| e[1]==XBP_PP_BGCLR} )
          IF nTmp > 0
             aPPFooting[nTmp][2] := XBPSYSCLR_DIALOGBACKGROUND
          ELSE
             AAdd( aPPFooting, {XBP_PP_BGCLR,XBPSYSCLR_DIALOGBACKGROUND} )
          ENDIF
          nTmp := AScan( aPPFooting, {|e| e[1]==XBP_PP_CGRP_FRAMELAYOUT} )
          IF nTmp > 0
             aPPFooting[nTmp][2] := XBPFRAME_BOX+XBPFRAME_RECT
          ELSE
             AAdd( aPPFooting, {XBP_PP_CGRP_FRAMELAYOUT,XBPFRAME_BOX+XBPFRAME_RECT} )
          ENDIF
       ENDIF

       ::Footing:DrawMode  := ::DrawMode
       ::Footing:Create( , , { 0, 0 }, ;
                         { -1, ::FooterLayout[XBPCOL_HFA_HEIGHT] }, aPPFooting )
       IF lIsTopLeft == .T.
          ::Footing:SetPresParam( {{XBP_PP_ORIGIN, XBP_ORIGIN_BOTTOMLEFT}} )
       ENDIF
       aTmp := ::Footing:CurrentSize()
       xSizeFooting  := aTmp[1]
       ySizeFooting  := aTmp[2]
    ELSE
       ySizeFooting  := 0
       xSizeFooting  := 0
    ENDIF

    // Create Heading
    ::Heading:MaxRow := 1
    IF ::HeaderLayout[XBPCOL_HFA_CAPTION] != NIL
       IF ::HeaderLayout[XBPCOL_HFA_HEIGHT] == XBP_AUTOSIZE
          ::Heading:ReferenceString := IF ( !Empty( ::HeaderLayout[XBPCOL_HFA_CAPTION] ), ;
                                            ::HeaderLayout[XBPCOL_HFA_CAPTION], "W" )
       ENDIF

       IF ::UseVisualStyle == .T. .AND. IsThemeActive(.T.) == .T.
          nTmp := AScan( aPPHeading, {|e| e[1]==XBP_PP_CGRP_FRAMELAYOUT} )
          IF nTmp > 0
             aPPHeading[nTmp][2] := XBPFRAME_NONE
          ELSE
             AAdd( aPPHeading, {XBP_PP_CGRP_FRAMELAYOUT,XBPFRAME_NONE} )
          ENDIF
       ENDIF
       ::Heading:DrawMode  := ::DrawMode
       ::Heading:Create( , , { 0, 0 }, ;
                         { -1, ::HeaderLayout[XBPCOL_HFA_HEIGHT] }, aPPHeading )

       IF lIsTopLeft == .T.
          ::Heading:SetPresParam( {{XBP_PP_ORIGIN, XBP_ORIGIN_BOTTOMLEFT}} )
       ENDIF

       aTmp := ::Heading:CurrentSize()
       ySizeHeading  := aTmp[2]
       xSizeHeading  := aTmp[1]
    ELSE
       ySizeHeading  := 0
       xSizeHeading  := 0
    ENDIF

    // Now we can determine the height of the dataarea - the space
    // between heading and footing
    ySizeDataArea := ::Size[2] - ( ySizeFooting + ySizeHeading )

    // Create DataArea
    IF ::UseVisualStyle == .T. .AND. IsThemeActive(.T.) == .T.
       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_BGCLR} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPSYSCLR_WINDOW
       ELSE
          AAdd( aPPDataArea, {XBP_PP_BGCLR,XBPSYSCLR_WINDOW} )
       ENDIF

       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_HILITE_FGCLR} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPSYSCLR_HILITEFOREGROUND
       ELSE
          AAdd( aPPDataArea, {XBP_PP_HILITE_FGCLR,XBPSYSCLR_HILITEFOREGROUND} )
       ENDIF

       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_HILITE_BGCLR} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPSYSCLR_HILITEBACKGROUND
       ELSE
          AAdd( aPPDataArea, {XBP_PP_HILITE_BGCLR,XBPSYSCLR_HILITEBACKGROUND} )
       ENDIF

       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_CGRP_FRAMELAYOUT} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPFRAME_NONE
       ELSE
          AAdd( aPPDataArea, {XBP_PP_CGRP_FRAMELAYOUT,XBPFRAME_NONE} )
       ENDIF

       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_CGRP_CELLFRAMELAYOUT} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPFRAME_BOX
       ELSE
          AAdd( aPPDataArea, {XBP_PP_CGRP_CELLFRAMELAYOUT,XBPFRAME_BOX} )
       ENDIF

       nTmp := AScan( aPPDataArea,  {|e| e[1]==XBP_PP_CGRP_HILITEFRAMELAYOUT} )
       IF nTmp > 0
          aPPDataArea[nTmp][2] := XBPFRAME_NONE
       ELSE
          AAdd( aPPDataArea, {XBP_PP_CGRP_HILITEFRAMELAYOUT,XBPFRAME_NONE} )
       ENDIF
    ENDIF

    ::DataArea:MaxRow       := ::RowCount
    ::DataArea:AdjustHeight := ::AdjustHeight
    ::DataArea:DrawMode     := ::DrawMode
    IF COL_OriginTopLeft() == .T.
       nTmp := ySizeHeading
    ELSE
       nTmp := ySizeFooting
    ENDIF

    IF ::DataAreaLayout[XBPCOL_DA_ROWWIDTH] == NIL
       ::DataArea:Create(,, {0, nTmp}, {-1, ySizeDataArea}, ;
                          aPPDataArea )
    ELSE
       ::DataArea:Create( ,, {0, nTmp}, ;
                          {::DataAreaLayout[XBPCOL_DA_ROWWIDTH], ySizeDataArea}, ;
                          aPPDataArea )
    ENDIF
    xSizeDataArea := ::DataArea:CurrentSize()[1]
    xSizeDataArea := Max( xSizeDataArea, xSizeFooting )
    xSizeDataArea := Max( xSizeDataArea, xSizeHeading )

    // Apply the new sizes and positions
    ::SetSize ( { xSizeDataArea, ::Size[2] }, FALSE )

    // Now set captions
    IF ::FooterLayout[XBPCOL_HFA_CAPTION] <> NIL
       ::Footing:SetCell ( 1, ::FooterLayout[XBPCOL_HFA_CAPTION] )
    ENDIF
    IF ::HeaderLayout[XBPCOL_HFA_CAPTION] <> NIL
       ::Heading:SetCell ( 1, ::HeaderLayout[XBPCOL_HFA_CAPTION] )
    ENDIF

    // Now set the rowcount
    ::_RowCount := ::DataArea:RowCount()
    ASize( ::RefreshRows, ::_RowCount )
    ASize( ::HasCellColor, ::_RowCount )
    ASize( ::Invalid, ::_RowCount )

    // Apply the codeblocks in the subcompontents which are required
    ::Heading:LbDown  := { |mp1,mp2,obj| ::RowLbDown( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::Heading:LbUp    := { |mp1,mp2,obj| ::RowLbUp  ( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::Heading:Motion  := { |mp1,mp2,obj| ::RowMotion( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::Footing:LbDown  := { |mp1,mp2,obj| ::RowLbDown( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::Footing:LbUp    := { |mp1,mp2,obj| ::RowLbUp  ( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::Footing:Motion  := { |mp1,mp2,obj| ::RowMotion( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::DataArea:LbDown := { |mp1,mp2,obj| ::RowLbDown( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::DataArea:LbUp   := { |mp1,mp2,obj| ::RowLbUp  ( mp1, { obj, obj:CellFromPos(mp1) } ) }
    ::DataArea:Motion := { |mp1,mp2,obj| ::RowMotion( mp1, { obj, obj:CellFromPos(mp1) } ) }

    ::Heading:CustomDrawCell  := { |mp1,mp2,obj| ForwardCustomDrawCell(mp1, mp2, Self, obj) }
    ::Footing:CustomDrawCell  := { |mp1,mp2,obj| ForwardCustomDrawCell(mp1, mp2, Self, obj) }
    ::DataArea:CustomDrawCell := { |mp1,mp2,obj| ForwardCustomDrawCell(mp1, mp2, Self, obj) }
 #ifdef __WIN32__
    ::DataArea:ItemMarked   := { | mp1,mp2,obj | ::ItemLbDown ( mp1, mp2 ) }
    ::DataArea:ItemSelected := { | mp1,mp2,obj | ::ItemLbDblClick ( mp1, mp2 ) }
 #else
    ::DataArea:CellMarked   := { | mp1,mp2,obj | ::ItemLbDown ( mp1, mp2 ) }
    ::DataArea:CellSelected := { | mp1,mp2,obj | ::ItemLbDblClick ( mp1, mp2 ) }
 #endif

    ::DataArea:RbDown := { | mp1,mp2,obj | ::ItemRbDown ( mp1, obj:CellFromPos(mp1) ) }
    ::Heading:RbDown  := { | mp1,mp2,obj | ::HeaderRbDown ( mp1, obj:CellFromPos(mp1) ) }
    ::Footing:RbDown  := { | mp1,mp2,obj | ::FooterRbDown ( mp1, obj:CellFromPos(mp1) ) }

    // Now show ourself if necessary
    IF lVisible
       ::Show()
    ENDIF

 RETURN self


 /* **********************************************************************
  * Object desctruction
  * */
 METHOD XbpColumn:Destroy()

  LOCAL nRows

    IF ::Status() != XBP_STAT_CREATE
       XbpException():RaiseObjectState()
    ENDIF

    // When we are created again, we
    // have to refresh all rows
    nRows := ::RowCount()
    IF nRows > 0
       ::RefreshRows( 1, nRows )
    ENDIF

 RETURN ::XbpStatic:Destroy()



 /* **********************************************************************
  * Configuration method
  * */
 METHOD XbpColumn:Configure ( oParent, oOwner, aPos, aSize, aPresParam, lVisible )

    // Reconfiguration will destroy and recreate ourself
    ::Destroy ()
    ::Create ( oParent, oOwner, aPos, aSize, aPresParam, lVisible )

 RETURN self


 /* **********************************************************************
  * Overloaded SetSize() method.
  * */
 METHOD XbpColumn:SetSize ( aNewSize, lRedraw )

    LOCAL ySizeHeading := 0, ySizeFooting := 0, ySizeDataArea := 0

    DEFAULT lRedraw TO TRUE

    ::LockUpdate( TRUE )

    // The height of footing and heading remains unchanged
    IF COL_HasFooting()
       ySizeFooting  := ::Footing:CurrentSize()[2]
       ::Footing:SetSize( { aNewSize[1], ySizeFooting },   FALSE )
    ENDIF
    IF COL_HasHeading()
       ySizeHeading  := ::Heading:CurrentSize()[2]
       ::Heading:SetSize( { aNewSize[1], ySizeHeading },   FALSE )
    ENDIF

    // Now calculate data area height
    ySizeDataArea := aNewSize[2] - ( ySizeFooting + ySizeHeading )
    ::DataArea:SetSize ( { aNewSize[1], ySizeDataArea }, FALSE )

    // Adjust position of heading and/or
    // footing elements
    IF COL_OriginTopLeft() == .F.
    IF COL_HasHeading()
          ::Heading:SetPos( {0, ySizeFooting + ySizeDataArea}, FALSE )
       ENDIF
    ELSE
       IF COL_HasFooting()
          ::Footing:SetPos( {0, ySizeHeading + ySizeDataArea}, FALSE )
       ENDIF
    ENDIF

    // Store the size
    ::Size := AClone ( aNewSize )

    // Since our height has changed we have to check the rowcount.
    ::_RowCount := ::DataArea:RowCount()
    ASize ( ::RefreshRows, ::_RowCount )
    ASize ( ::HasCellColor, ::_RowCount )
    ASize ( ::Invalid, ::_RowCount )

    ::LockUpdate( FALSE )

    // Now forward the changes to the parent class.
 RETURN ::XbpStatic:SetSize ( aNewSize, lRedraw )


 /* **********************************************************************
  * Hilite one row
  * */
 METHOD XbpColumn:HiliteRow ( nRow, lHilite, lHiliteBorder, lRedraw )

    DEFAULT lRedraw TO TRUE

    IF Empty( nRow )
       RETURN FALSE
    ENDIF

    // we cannot draw a row that we do not know
    IF nRow > ::RowCount() .OR. nRow < 1
       RETURN FALSE
    ENDIF

    // When the row needs to be refreshed we have to call the Drawrow()
    // method which fetches the data from the datalink.
    IF ! ::RefreshRows[nRow] == NIL
       ::DrawRow ( nRow, FALSE )
    ENDIF

 RETURN ::DataArea:HiliteCell ( nRow, lHilite, lHiliteBorder, lRedraw )


 /* **********************************************************************
  * Redisplay row.
  * In case the cell in the dataarea contains NIL, we have to call the
  * datalink to fetch the data from the data source.
  * In case the row was marked as empty by :refreshRows() we must
  * also call the datalink.
  * In both cases we will call the colourblock if necessary.
  * When the row is not refreshed we will not call the codeblock.
  * In all cases we will mark this row as invalid which means that it
  * has to be redrawn when the column object paints again.
  * */
 METHOD XbpColumn:DrawRow( nRow, lRedraw )

    LOCAL xCell, xCaption, aColor, xRet := TRUE

    DEFAULT lRedraw TO TRUE

    // we cannot draw a row that we do not know
    IF nRow > ::RowCount() .OR. nRow < 1
       RETURN FALSE
    ENDIF

    // Get value from the cell
    xCaption := xCell := ::DataArea:GetCell( nRow )

    // Now we have to fetch data again when this cell is empty or
    // the row was marked as empty.
    IF xCaption == NIL .OR. ! ::RefreshRows[nRow] == NIL

       // Reset the empty flag
       ::RefreshRows[nRow] := NIL

       // Now call the datalink to fetch the value
       xCaption := Eval( ::DataLink )
       IF ::Type == XBPCOL_TYPE_TEXT

          // If a picture mask is set, make sure it is respected
          // for output.
          IF Empty(::Picture) == .F.
             xCaption := Transform( xCaption, ::Picture )
          ENDIF

          // Assign value
          IF Empty( xCell )
             xRet := ::DataArea:SetCell( nRow, xCaption, ::type, FALSE )
             ::Invalid[nRow] := nRow
          ELSE
             IF Empty( xCaption )
               xRet := ::DataArea:SetCell( nRow, xCaption, ::type, FALSE )
               ::Invalid[nRow] := nRow
             ELSE
                IF ! xCell == xCaption
                   xRet := ::DataArea:SetCell( nRow, xCaption, ::type, FALSE )
                   ::Invalid[nRow] := nRow
                ENDIF
             ENDIF
          ENDIF

       ELSE

          // Assign value
          // Note that the value is assigned only if it differs
          // from the previous one. If the column displays content
          // specified using (file-) paths, the value is always
          // updated to take care about relative paths
          IF xCell == NIL .OR. xCell != xCaption .OR. ::Type == XBPCOL_TYPE_FILEICON ;
             .OR. ::Type == XBPCOL_TYPE_FILEMINIICON
             xRet := ::DataArea:SetCell( nRow, xCaption, ::type, FALSE )
             ::Invalid[nRow] := nRow
          ENDIF

       ENDIF

       // Now evaluate colour block
       IF ! ::ColorBlock == NIL
          aColor := Eval( ::ColorBlock, xCaption, self, nRow )
          IF ! aColor == NIL
             // The colour block returned a value, now apply this
             ::DataArea:SetCellColor( nRow, aColor[1], aColor[2], FALSE )
             IF Len(aColor) > 2
                ASize( aColor, 4 )
                ::DataArea:SetCellHiliteColor( nRow, aColor[3], aColor[4], FALSE )
             ENDIF
             ::Invalid[nRow] := nRow
             ::HasCellColor[nRow] := TRUE
          ENDIF
       ELSEIF ! ::HasCellColor[nRow] == NIL
          // Set default colour
          IF ! ( xCell == NIL .OR. ! xCell == xCaption )
             ::DataArea:SetCell( nRow, xCaption, ::Type, FALSE )
             ::Invalid[nRow] := nRow
          ENDIF
          ::HasCellColor[nRow] := NIL
       ENDIF

    ELSE

       // This row will be repainted
       ::Invalid[nRow] := nRow

    ENDIF

    // Set Editbuffer which contains the value from the last drawn row.
    ::EditBuffer := xCaption

 RETURN xRet


 /* **********************************************************************
  * Get value in row
  * */
 METHOD XbpColumn:GetRow ( nRow )

    // we access a row that we do not know
    IF nRow > ::RowCount() .OR. nRow < 1
       RETURN NIL
    ENDIF

 RETURN ::DataArea:GetCell ( nRow )


 /* **********************************************************************
  * Mark several rows as empty, which means that they need to be reread
  * on next :DrawRow() call.
  * */
 METHOD XbpColumn:RefreshRows ( nStartRow, nEndRow )

   LOCAL i
   DEFAULT nStartRow TO 1 , ;
           nEndRow   TO ::RowCount()

   // we access a row that we do not know
   IF nStartRow > ::RowCount() .OR. nStartRow < 1
      nStartRow := 1
   ENDIF
   IF nEndRow > ::RowCount() .OR. nEndRow < 1
      nEndRow := ::RowCount()
   ENDIF

   FOR i := nStartRow TO nEndRow
      ::RefreshRows[i] := TRUE
   NEXT

 RETURN self


 /* **********************************************************************
  * Mark one row as empty, which means that it needs to be reread
  * on next :DrawRow() call.
  * */
 METHOD XbpColumn:RefreshRow ( nRow )

   // we access a row that we do not know
   IF nRow > ::RowCount() .OR. nRow < 1
      RETURN self
   ENDIF

   // mark the row as to be refreshed
   ::RefreshRows[nRow] := TRUE

 RETURN self


 /* **********************************************************************
  * Scroll, this method is forwarded to the appropriate method of the
  * datarea.
  * */
 METHOD XbpColumn:ScrollUp ( nRows, lRedraw )

   LOCAL nScrolled := 0

   DEFAULT lRedraw TO TRUE

   // In case the last row is parly visible, this needs to be refreshed
   // as well.
   ::DataArea:SetCell( ::RowCount(), NIL, FALSE )
 #ifdef __WIN32__
   nScrolled := ::DataArea:ScrollUp ( nRows, lRedraw )
 #endif
 #ifdef __OS2__
   IF ::Type == XBPCOL_TYPE_TEXT
      nScrolled := ::DataArea:Scroll ( nRows, lRedraw )
   ELSE
      // for icons, bitmaps
      nScrolled := ::DataArea:Scroll ( nRows, FALSE )
      IF lRedraw
        ::DataArea:InvalidateRect()
      ENDIF
   ENDIF
 #endif
   ::Validate()

 RETURN nScrolled


 /* **********************************************************************
  * Scroll, this method is forwarded to the appropriate method of the
  * datarea.
  * */
 METHOD XbpColumn:ScrollDown ( nRows, lRedraw )
   LOCAL nScrolled := 0

   DEFAULT lRedraw TO TRUE

 #ifdef __WIN32__
   nScrolled := ::DataArea:ScrollDown ( nRows, lRedraw )
 #endif
 #ifdef __OS2__
   nScrolled := ::DataArea:Scroll ( nRows * (-1), lRedraw )
 #endif
   ::Validate()

 RETURN nScrolled


 /* **********************************************************************
  * Left button down on row.
  * Paramters:
  *   aPos    = Position relative to origin of cellgroup
  *   aValues = { oObj = Object, nRow = Number of row in oObj }
  * */
 METHOD XbpColumn:RowLbDown ( aPos, aValues )

    LOCAL _aPos := aValues[1]:CurrentPos()

    // - make aPos relative to my origin
    // - self gets aValues[1]
    // - the component where the error occurs is added at pos #3
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]
    AAdd ( aValues, aValues[1] )
    aValues[1] := self

    // Forward the message to our owner
    IF aValues[3] == ::Heading .OR. aValues[3] == ::Footing
       ::SetOwner():HFLbDown( aPos, aValues )
    ELSE
       ::SetOwner():DALbDown( aPos, aValues )
    ENDIF

 RETURN self


 /* **********************************************************************
  * Left button up on row
  * */
 METHOD XbpColumn:RowLbUp (aPos, aValues  )

    LOCAL _aPos := aValues[1]:CurrentPos ()

    // - convert position in aPos to owner-relative
    //   coordinates
    // - self gets aValues[1]
    // - the component where the error occurs is added at pos #3
    aPos    := AClone( aPos )
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    aPos[1] += ::currentPos()[1]
    aPos[2] += ::currentPos()[2]
    aPos[1] += ::SetOwner():getBg():currentPos()[1]

    AAdd ( aValues, aValues[1] )
    aValues[1] := self

    // Forward the message to our owner
    IF aValues[3] == ::Heading .OR. aValues[3] == ::Footing
       ::SetOwner():HFLbUp( aPos, aValues )
    ELSE
       ::SetOwner():DALbUp( aPos, aValues )
    ENDIF

 RETURN self


 /* **********************************************************************
  * Mouse motion
  * */
 METHOD XbpColumn:RowMotion ( aPos, aValues )

    LOCAL _aPos := aValues[1]:CurrentPos ()

    // - convert position in aPos to owner-relative
    //   coordinates
    // - self gets aValues[1]
    // - the component where the error occurs is added at pos #3
    aPos    := AClone( aPos )
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    aPos[1] += ::currentPos()[1]
    aPos[2] += ::currentPos()[2]
    aPos[1] += ::SetOwner():getBg():currentPos()[1]

    AAdd ( aValues, aValues[1] )
    aValues[1] := self

    // Forward the message to our owner
    IF aValues[3] == ::Heading .OR. aValues[3] == ::Footing
       ::SetOwner():HFMotion( aPos, aValues )
    ELSE
       ::SetOwner():DAMotion( aPos, aValues )
    ENDIF

 RETURN self


 /* **********************************************************************
  * Right mouse button down on row
  * */
 METHOD XbpColumn:ItemRbDown ( aPos, nItem )

    LOCAL _aPos := ::DataArea:CurrentPos ()

    // make aPos relative to my origin
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    // forward the event to my owner
    ::SetOwner():HandleEvent ( xbeCOL_ItemRbDown, aPos, { self, nItem } )

 RETURN self


 /* **********************************************************************
  * An iten was marked (single click)
  * */
 METHOD XbpColumn:ItemLbDown ( nItem )

    // forward the event to my owner
    ::SetOwner():ItemLbDown ( nItem, self )

 RETURN self


 /* **********************************************************************
  * An item was activated (dbl click)
  * */
 METHOD XbpColumn:ItemLbDblClick ( nItem )

    // forward the event to my owner
    ::SetOwner():ItemLbDblClick ( nItem, self )

 RETURN self


 /* **********************************************************************
  * RbDown on heading
  * */
 METHOD XbpColumn:HeaderRbDown ( aPos, nItem )

    LOCAL _aPos := ::Heading:CurrentPos ()

    // make aPos relative to my origin
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    // forward event to my owner
    ::SetOwner():HandleEvent ( xbeCOL_HeaderRbDown, aPos, { self, nItem } )

 RETURN self


 /* **********************************************************************
  * RbDown on footing
  * */
 METHOD XbpColumn:FooterRbDown ( aPos, nItem )

    LOCAL _aPos := ::Footing:CurrentPos ()

    // make aPos relative to my origin
    aPos[1] += _aPos[1]
    aPos[2] += _aPos[2]

    // forward the event to my owner
    ::SetOwner():HandleEvent ( xbeCOL_FooterRbDown, aPos, { self, nItem } )

 RETURN self


 /* **********************************************************************
  * Internal method to get the presparam arrays
  * */
 METHOD XbpColumn:_GetPresParam ()

    LOCAL aPresParam

    aPresParam := xbpGetPPBundle ( ::DataAreaLayout, XBP_PP_COL_DA_BASE )
    AEval( xbpGetPPBundle(::HeaderLayout, XBP_PP_COL_HA_BASE), ;
           {|e| AAdd(aPresParam, e)} )
    AEval( xbpGetPPBundle(::FooterLayout, XBP_PP_COL_FA_BASE), ;
           {|e| AAdd(aPresParam, e)} )

 RETURN aPresParam


 /* **********************************************************************
  * Internal method to set the presparam bundles without calling the
  * methods on the comoponents
  * */
 METHOD XbpColumn:_SetPresParam ( aPresParam )

    LOCAL aRet, aPP := NIL, nPos

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


 /* **********************************************************************
  * Change font (on all subcomponents)
  * */
 METHOD XbpColumn:SetFontCompoundName ( cFont )

    LOCAL cRet := ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME]

    IF ! cFont == NIL
       ::DataAreaLayout[XBPCOL_DA_COMPOUNDNAME] := cFont
       ::HeaderLayout[XBPCOL_HFA_COMPOUNDNAME]  := cFont
       ::FooterLayout[XBPCOL_HFA_COMPOUNDNAME]  := cFont
       ::DataArea:SetFontCompoundName ( cFont )
       IF COL_HasHeading()
          ::Heading:SetFontCompoundName ( cFont )
       ENDIF
       IF COL_HasFooting()
          ::Footing:SetFontCompoundName ( cFont )
       ENDIF
    ENDIF

 RETURN cRet


 /* **********************************************************************
  * Change FG Color (only on drawingArea)
  * */
 METHOD XbpColumn:SetColorFG ( nColor )

    LOCAL nRet := ::DataAreaLayout[XBPCOL_DA_FGCLR]

    IF ! nColor == NIL
       ::DataAreaLayout[XBPCOL_DA_FGCLR] := nColor
       ::DataArea:SetColorFG ( nColor )
    ENDIF

 RETURN nRet


 /* **********************************************************************
  * Change BG Color (only on drawingArea)
  * */
 METHOD XbpColumn:SetColorBG ( nColor )

    LOCAL nRet := ::DataAreaLayout[XBPCOL_DA_BGCLR]

    IF ! nColor == NIL
       ::DataAreaLayout[XBPCOL_DA_BGCLR] := nColor
       ::DataArea:SetColorBG ( nColor )
    ENDIF

 RETURN nRet


 /* **********************************************************************
  * Change presentation parameter on column
  * */
 METHOD XbpColumn:SetPresParam ( aPP )

    LOCAL aPPDataArea, aPPHeading, aPPFooting, aRet

    IF ! aPP == NIL

       // Call internal method to manipulate bundles
       IF aPP <> NIL
          aRet := ::_SetPresParam ( aPP )
       ENDIF

       // Now apply the bundles to my components
       aPPDataArea := xbpGetDABundle  ( ::DataAreaLayout )
       ::DataArea:SetPresParam ( aPPDataArea )
       IF COL_HasHeading()
          aPPHeading  := xbpGetHFABundle ( ::HeaderLayout )
          ::Heading:SetPresParam ( aPPHeading )
       ENDIF
       IF COL_HasFooting()
          aPPFooting  := xbpGetHFABundle ( ::FooterLayout )
          ::Footing:SetPresParam ( aPPFooting )
       ENDIF

       // reconfiguration
       ::Rearrange()

    ELSE

       // Return current settings
       aRet := ::_GetPresParam ()
    ENDIF

 RETURN aRet


 /* **********************************************************************
  *
  * */
 METHOD XbpColumn:SetDrawMode( nMode )

   IF ValType(nMode) != "N"
      XbpException():RaiseParameterType( {nMode} )
   ENDIF

   ::DrawMode := nMode

   IF ValType(::Heading) == "O"
      ::Heading:DrawMode := nMode
   ENDIF
   IF ValType(::DataArea) == "O"
      ::DataArea:DrawMode   := nMode
   ENDIF
   IF ValType(::Footing) == "O"
      ::Footing:DrawMode := nMode
   ENDIF

 RETURN


 /* **********************************************************************
  * Inquire Rowcount
  * */
 METHOD XbpColumn:RowCount()

 RETURN ::_RowCount


 /* **********************************************************************
  * Internal reconfiguration method
  * */
 METHOD XbpColumn:Rearrange ()

  LOCAL xSizeDataArea := 0
  LOCAL ySizeDataArea := 0
  LOCAL ySizeFooting  := 0
  LOCAL ySizeHeading  := 0
  LOCAL lOriginBL     := (COL_OriginTopLeft() == .F.)

    ::LockUpdate ( TRUE )

    // Enable/Disable heading
    IF COL_HasFooting()
       IF ::Footing:Status() == XBP_STAT_INIT
          ::Footing:Create()
          IF lOriginBL == .F.
             ::Footing:SetPresParam( {{XBP_PP_ORIGIN, XBP_ORIGIN_BOTTOMLEFT}} )
       ENDIF
       ENDIF

       ::Footing:Configure( ,,, { 1, ::FooterLayout[XBPCOL_HFA_HEIGHT] } )
    ELSE
       IF ::Footing:Status() != XBP_STAT_INIT
          ::Footing:Destroy()
       ENDIF
    ENDIF

    // Enable/Disable footing
    IF COL_HasHeading()
       IF ::Heading:Status() == XBP_STAT_INIT
          ::Heading:Create()
          IF lOriginBL == .F.
             ::Heading:SetPresParam( {{XBP_PP_ORIGIN, XBP_ORIGIN_BOTTOMLEFT}} )
          ENDIF
       ENDIF
       ::Heading:Configure( ,,, { 1, ::HeaderLayout[XBPCOL_HFA_HEIGHT] } )
    ELSE
       IF ::Heading:Status() != XBP_STAT_INIT
          ::Heading:Destroy()
       ENDIF
    ENDIF

    // Calculate size of drawingarea
    IF COL_HasFooting()
       ySizeFooting  := ::Footing:CurrentSize()[2]
    ENDIF
    IF COL_HasHeading()
       ySizeHeading  := ::Heading:CurrentSize()[2]
    ENDIF
    ySizeDataArea := ::Size[2] - ( ySizeFooting + ySizeHeading )

    // DataArea == space between heading and footing
    ::DataArea:MaxRow := ::RowCount

    IF lOriginBL == .T.
       ::DataArea:Configure ( ,, {0, ySizeFooting} )
    ELSE
       ::DataArea:Configure ( ,, {0, ySizeHeading} )
    ENDIF
    xSizeDataArea := ::DataArea:CurrentSize()[1]

    // apply new position and size
    IF COL_HasHeading()
       ::Heading:SetSize( {xSizeDataArea, ySizeHeading} )
       IF lOriginBL == .T.
          ::Heading:SetPos( {0, ySizeFooting + ySizeDataArea} )
       ENDIF
       ::Heading:SetCell( 1, ::HeaderLayout[XBPCOL_HFA_CAPTION] )
    ENDIF
    IF COL_HasFooting()
       ::Footing:SetSize( {xSizeDataArea, ySizeFooting} )
       IF lOriginBL == .T.
          ::Footing:SetPos( {0, ySizeHeading + ySizeDataArea} )
       ENDIF
       ::Footing:SetCell( 1, ::FooterLayout[XBPCOL_HFA_CAPTION] )
    ENDIF
    ::XbpStatic:SetSize ( { xSizeDataArea, ::Size[2] } )
    ::DataArea:SetSize  ( { xSizeDataArea, ySizeDataArea } )

    // Now set rowcount
    ::_RowCount := ::DataArea:RowCount()
    ASize ( ::RefreshRows, ::_RowCount )
    ASize ( ::HasCellColor, ::_RowCount )
    ASize ( ::Invalid, ::_RowCount )

    ::LockUpdate ( FALSE )
    ::Show()

 RETURN self


 /* **********************************************************************
  * Overloaded EditBuffer() method, this method returns the contents of
  * the last row drawn with :DrawRow()
  * */
 METHOD XbpColumn:Editbuffer()

 RETURN ::EditBuffer


 /* **********************************************************************
  * Redraw invalid rows
  * */
 METHOD XbpColumn:Redraw()

   // redraw
   ::DataArea:DrawCell( ::Invalid )

   // validate
   ::Validate()

 RETURN self


 /* **********************************************************************
  * Mark invalid rows as valid
  * */
 METHOD XbpColumn:Validate()

   // now reset invalid rows
   AFill( ::Invalid, NIL )

 RETURN self


 /* **********************************************************************
  * Set/Get internal mark variable
  * This var is used by the browser to determin whether a column must
  * be repainted when scrolling
  * */
 METHOD XbpColumn:SetMark( xMark )
    LOCAL xRet := ::Mark
    IF xMark
       ::Mark := xMark
    ENDIF
 RETURN xRet


 /* **********************************************************************
  * Set picture mask for formatting values displayed in columns of type
  * XBPCOL_TYPE_TEXT. This method is intended primarily for usage in
  * derived classes. In this class, it does nothing more but to store
  * the value passed.
  * */
  METHOD XbpColumn:SetPicture( cPicture )

     IF ValType(cPicture) != "C"
        XBPException():raiseParameterType( {cPicture} )
     ENDIF

     ::Picture := cPicture

  RETURN


 /* **********************************************************************
  * */
  METHOD XbpColumn:SetUseVisualStyle( lUse )

  LOCAL aPPD := {}
  LOCAL aPPH := {}
  LOCAL aPPF := {}

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

    ::XbpStatic:SetUseVisualStyle( lUse )

    IF ::Status() != XBP_STAT_CREATE
       RETURN
    ENDIF

    IF lUse == .T. .AND. IsThemeActive(.T.) == .T.
       AAdd( aPPD, {XBP_PP_BGCLR, XBPSYSCLR_WINDOW} )
       AAdd( aPPD, {XBP_PP_HILITE_FGCLR, XBPSYSCLR_HILITEFOREGROUND} )
       AAdd( aPPD, {XBP_PP_HILITE_BGCLR, XBPSYSCLR_HILITEBACKGROUND} )
       AAdd( aPPD, {XBP_PP_CGRP_FRAMELAYOUT, XBPFRAME_NONE} )
       AAdd( aPPD, {XBP_PP_CGRP_CELLFRAMELAYOUT, XBPFRAME_BOX} )
       AAdd( aPPD, {XBP_PP_CGRP_HILITEFRAMELAYOUT, XBPFRAME_BOX} )

       AAdd( aPPH, {XBP_PP_CGRP_FRAMELAYOUT, XBPFRAME_NONE} )
       AAdd( aPPF, {XBP_PP_BGCLR, XBPSYSCLR_DIALOGBACKGROUND} )
       AAdd( aPPF, {XBP_PP_CGRP_FRAMELAYOUT, XBPFRAME_BOX+XBPFRAME_RECT} )
    ELSE
       IF ::DataAreaLayout[XBPCOL_DA_BGCLR] != NIL
          AAdd( aPPD, {XBP_PP_BGCLR, ::DataAreaLayout[XBPCOL_DA_BGCLR]} )
       ENDIF
       IF ::DataAreaLayout[XBPCOL_DA_HILITE_FGCLR] != NIL
          AAdd( aPPD, {XBP_PP_HILITE_FGCLR, ::DataAreaLayout[XBPCOL_DA_HILITE_FGCLR]} )
       ENDIF
       IF ::DataAreaLayout[XBPCOL_DA_HILITE_BGCLR] != NIL
          AAdd( aPPD, {XBP_PP_HILITE_BGCLR, ::DataAreaLayout[XBPCOL_DA_HILITE_BGCLR]} )
       ENDIF
       IF ::DataAreaLayout[XBPCOL_DA_FRAMELAYOUT] != NIL
          AAdd( aPPD, {XBP_PP_CGRP_FRAMELAYOUT, ::DataAreaLayout[XBPCOL_DA_FRAMELAYOUT]} )
       ENDIF
       IF ::DataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT] != NIL
          AAdd( aPPD, {XBP_PP_CGRP_CELLFRAMELAYOUT, ::DataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]} )
       ENDIF
       IF ::DataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT]  != NIL
          AAdd( aPPD, {XBP_PP_CGRP_HILITEFRAMELAYOUT, ::DataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT]} )
       ENDIF
       IF ::HeaderLayout[XBPCOL_HFA_FRAMELAYOUT] != NIL
          AAdd( aPPH, {XBP_PP_CGRP_FRAMELAYOUT, ::HeaderLayout[XBPCOL_HFA_FRAMELAYOUT]} )
       ENDIF
       IF ::FooterLayout[XBPCOL_HFA_BGCLR] != NIL
          AAdd( aPPF, {XBP_PP_BGCLR, ::FooterLayout[XBPCOL_HFA_BGCLR]} )
       ENDIF
       IF ::FooterLayout[XBPCOL_HFA_FRAMELAYOUT] != NIL
          AAdd( aPPF, {XBP_PP_CGRP_FRAMELAYOUT, ::FooterLayout[XBPCOL_HFA_FRAMELAYOUT]} )
       ENDIF
    ENDIF

    ::DataArea:SetPresParam( aPPD )
    IF Empty(::Heading) == .F.
       ::Heading:SetPresParam( aPPH )
    ENDIF
    IF Empty(::Footing) == .F.
       ::Footing:SetPresParam( aPPF )
    ENDIF

  RETURN


 /* ***************************************************************** */
 /* Internal service level
  */

 /* **********************************************************************
  * Translate heading and footing bundle into cellgroup bundle
  * */
 STATIC FUNCTION xbpGetHFABundle ( aLayout )

    LOCAL aRet := {}, i

    FOR i := 1 TO LEN ( aLayout )
       IF aLayout[i] <> NIL .AND. aTransHFA[i] <> NIL
          Aadd ( aRet, { aTransHFA[i], aLayout[i] } )
       ENDIF
    NEXT

 RETURN aRet


 /* **********************************************************************
  * Translate drawingarea bundle into cellgroup bundle
  * */
 STATIC FUNCTION xbpGetDABundle ( aLayout )

    LOCAL aRet := {}, i

    FOR i := 1 TO LEN ( aLayout )
       IF aLayout[i] <> NIL .AND. aTransDA[i] <> NIL
          Aadd ( aRet, { aTransDA[i], aLayout[i] } )
       ENDIF
    NEXT

 RETURN aRet

 /* **********************************************************************
  * Evaluate codeblock and return its value as string.
  * */
 STATIC FUNCTION _Block2String ( cType, bBlock )

   LOCAL xRet

   xRet  := Eval ( bBlock )
   cType := VALTYPE ( xRet )
   DO CASE
      CASE cType == "N"
         xRet := STR ( xRet )
      CASE cType == "D"
         xRet := DTOC ( xRet )
      CASE cType == "L"
         xRet := IIF ( xRet, ".T.", ".F." )
      CASE cType == "M"
         xRet := "Memo"
   ENDCASE

 RETURN xRet

 /* **********************************************************************
  * Forward "xbeP_CustomDrawCell" event to owner object (browser)
  *
  * Notes: o This method extends the "aInfo" array passed by the system
  *          to include a reference to the column object as well as to
  *          the column area that contains the cell to be rendered.
  * */
 STATIC FUNCTION ForwardCustomDrawCell( oPS, aInfo, oColumn, oArea )

  LOCAL aTmp   := AClone( aInfo )
  LOCAL nColor := oArea:SetColorBG()

    ASize( aTmp, Len(aTmp) +2 )
    AIns( aTmp,  XBP_DRAWINFO_AREA,   oArea )
    AIns( aTmp,  XBP_DRAWINFO_COLUMN, oColumn )

    IF nColor != NIL
       GraSetColor( oPS, nColor )
    ELSE
       GraSetColor( oPS, XBPSYSCLR_DIALOGBACKGROUND )
    ENDIF

 RETURN oColumn:SetOwner():HandleEvent(xbeP_CustomDrawCell, oPS, aTmp)


 STATIC FUNCTION ColOriginTopLeft( oXbp )

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