#include "activex.ch"

#include "Appevent.ch"
#include "Directry.ch"
**#include "Imgview.ch"
#include "Common.ch"
#include "Font.ch"
#include "Gra.ch"
#include "Xbp.ch"


#define  xbeDS_DirChanged           xbeP_User + 100
#define  xbeFS_FileMarked           xbeP_User + 101
#define  xbeFS_FileSelected         xbeP_User + 102

#xtrans  CenterPos( <aSize>, <aRefSize> ) => ;
         { Int( (<aRefSize>\[1] - <aSize>\[1]) / 2 ) ;
         , Int( (<aRefSize>\[2] - <aSize>\[2]) / 2 ) }


* This procedure displays an image file in a separate window
*-------------------------------------------------------------------------------
PROCEDURE FullView( cFile )
   LOCAL oDlg, oImage, oPS, aSize, aPos
   LOCAL lBGClr := XBPSYSCLR_TRANSPARENT

   * Only bitmap and meta files are supported
   IF cFile <> NIL            .AND. ;
     ( ".BMP" $ Upper( cFile ) .OR. ;
       ".EMF" $ Upper( cFile ) .OR. ;
       ".GIF" $ Upper( cFile ) .OR. ;
       ".JPG" $ Upper( cFile ) .OR. ;
       ".PNG" $ Upper( cFile ) .OR. ;
       ".MET" $ Upper( cFile )      )

      * Create hidden dialog window
      oDlg := XbpDialog():new( AppDesktop(),,,{100,100} )
      oDlg:taskList   := .F.
      oDlg:visible    := .F.
      oDlg:title      := cFile
      oDlg:sizeRedraw := .T.
      oDlg:close      := {|mp1,mp2,obj| obj:destroy() }
      oDlg:create()

      * Create a presentation space and connect it with the device
      * context of :drawingArea
      oPS := XbpPresSpace():new():create( oDlg:drawingArea:winDevice() )

      IF ".BMP" $ Upper( cFile ) .OR. ;
         ".GIF" $ Upper( cFile ) .OR. ;
         ".JPG" $ Upper( cFile ) .OR. ;
         ".PNG" $ Upper( cFile )

         * File contains a bitmap. Limit the window size to a range
         * between 16x16 pixel and the screen resolution
         oImage   := XbpBitmap():new():create( oPS )
         oImage:loadFile( cFile )

         IF oImage:transparentClr <> GRA_CLR_INVALID
            lBGClr := XBPSYSCLR_DIALOGBACKGROUND
         ENDIF

         aSize    := { oImage:xSize, oImage:ySize }
         aSize[1] := Max( 16, Min( aSize[1], AppDeskTop():currentSize()[1] ) )
         aSize[2] := Max( 16, Min( aSize[2], AppDeskTop():currentSize()[2] ) )
         aSize    := oDlg:calcFrameRect( {0,0, aSize[1], aSize[2]} )

         oDlg:setSize( {aSize[3], aSize[4]} )

         * The window must react to xbeP_Paint to redraw the bitmap
         oDlg:drawingarea:paint := {|x,y,obj| x:=obj:currentSize(), ;
                                     oImage:draw( oPS, {0, 0, x[1], x[2]}, ;
                                     {0, 0, oImage:xSize, oImage:ySize},,;
                                     GRA_BLT_BBO_IGNORE), Sleep(0.1) }
      ELSE
         * Display a meta file. It has no size definition for the image
         oImage := XbpMetafile():new():create()
         oImage:load( cFile )
         aSize := { 600, 400 }
         oDlg:setSize( aSize )
         oDlg:drawingarea:paint := {|x,y,obj| x:=obj:currentSize(), ;
                                              oImage:draw( oPS, {0, 0, x[1], x[2]}),;
                                              Sleep(0.1) }
         lBGClr := XBPSYSCLR_DIALOGBACKGROUND
      ENDIF

     /*
      * Set the background color for the dialog's drawingarea.
      * Per default, the transparent color is used to avoid
      * flicker during refreshs. For transparent images and
      * metafiles, however, color gray is set instead, see above.
      * This is done to prevent bits of the desktop from being
      * visible in transparent areas of the bitmap/metafile image.
      * Alternatively, transparency could be explicitly switched
      * off for bitmapped images.
      */
      oDlg:drawingArea:SetColorBG( lBGClr )

      * Display the window centered on the desktop
      aPos:= CenterPos( oDlg:currentSize(), AppDesktop():currentSize() )
      oDlg:setPos( aPos )
      oDlg:show()
      SetAppFocus( oDlg )
   ENDIF
RETURN

********************************************************************************
* Class for displaying bitmaps or meta files
********************************************************************************
CLASS ImageView FROM XbpStatic
   PROTECTED:
   VAR oFrame
   VAR oCanvas
   VAR oPS
   VAR oBitmap
   VAR oMetafile
   VAR nMode

   EXPORTED:
   VAR autoScale
   VAR file
   METHOD init, create, load, display
ENDCLASS

* Initialize the object. Self is the parent for two additional XbpStatic objects
********************************************************************************
METHOD ImageView:init( oParent, oOwner, aPos, aSize, aPresParam, lVisible )
   *
   ::xbpStatic:init( oParent, oOwner, aPos, aSize, aPresParam, lVisible )
   ::xbpStatic:type := XBPSTATIC_TYPE_RAISEDRECT

   ::oFrame         := XbpStatic():new( self )
   ::oFrame:type    := XBPSTATIC_TYPE_RECESSEDRECT

   ::oCanvas        := XbpStatic():new( self )
   ::autoScale      := .T.
   ::nMode          := 0
   ::oPS            := XbpPresSpace():new()
RETURN self

* Request system resources. Self is the outer frame, ::oFrame is the
* inner frame and ::oCanvas is used for displaying the image
********************************************************************************
METHOD ImageView:create( oParent, oOwner, aPos, aSize, aPresParam, lVisible )
   LOCAL aAttr[ GRA_AA_COUNT ]

   ::xbpStatic:create( oParent, oOwner, aPos, aSize, aPresParam, lVisible )
   aSize    := ::currentSize()
   aSize[1] -= 8
   aSize[2] -= 8

   ::oFrame:create(self,, {4,4}, aSize )

   aSize[1] -= 2
   aSize[2] -= 2

   ::oCanvas:create(::oFrame,, {1,1}, aSize )

   * Connect presentation space with device context of XbpStatic object
   ::oPS:create( ::oCanvas:winDevice() )
   aAttr[ GRA_AA_COLOR ] := GRA_CLR_BACKGROUND
   ::oPS:setAttrArea( aAttr )
   ::oCanvas:paint := {| aClip | ::display( aClip ) }

RETURN self

* Load an image file
********************************************************************************
METHOD ImageView:load( cFile )
   LOCAL lSuccess := .F.

   IF Valtype( cFile ) <> "C" .OR. ! File( cFile )
      RETURN lSuccess
   ENDIF

   ::nMode := 0
   ::file  := ""

   IF ".BMP" $ Upper( cFile ) .OR. ;
      ".GIF" $ Upper( cFile ) .OR. ;
      ".JPG" $ Upper( cFile ) .OR. ;
      ".PNG" $ Upper( cFile )

      IF ::oBitmap == NIL
         ::oBitmap := XbpBitmap():New():create( ::oPS )
      ENDIF

      IF ( lSuccess := ::oBitmap:loadFile( cFile ) )
         ::nMode := 1
         ::file := cFile
      ENDIF

   ELSEIF ".EMF" $ Upper( cFile ) .OR. ".MET" $ Upper( cFile )
      IF ::oMetafile == NIL
         ::oMetafile := XbpMetafile():New():create()
      ENDIF

      IF ( lSuccess := ::oMetafile:load( cFile ) )
         ::nMode := 2
         ::file := cFile
      ENDIF
   ENDIF

RETURN lSuccess

* Display the image
********************************************************************************
METHOD ImageView:display( aClip )
   LOCAL lSuccess := .F.
   LOCAL aSize    := ::oCanvas:currentSize()
   LOCAL aTarget, aSource, nAspect

   * Prepare clipping path
   DEFAULT aClip TO { 1, 1, aSize[1]-1, aSize[2]-1 }
   GraPathBegin( ::oPS )
   GraBox( ::oPS, { aClip[1]-1, aClip[2]-1 }, { aClip[3]+1, aClip[4]+1 }, GRA_OUTLINE )
   GraPathEnd( ::oPS )
   GraPathClip( ::oPS, .T. )

   GraBox( ::oPS, {0,0}, aSize, GRA_FILL )

   DO CASE
   CASE ::nMode == 1
      * A bitmap file is loaded
      aSource := {0,0,::oBitmap:xSize,::oBitmap:ySize}
      aTarget := {1,1,aSize[1]-2,aSize[2]-2}

      IF ::autoScale
         * Bitmap is scaled to the size of ::oCanvas
         nAspect    := aSource[3] / aSource[4]
         IF nAspect > 1
            aTarget[4] := aTarget[3] / nAspect
         ELSE
            aTarget[3] := aTarget[4] * nAspect
         ENDIF
      ELSE
         aTarget[3] := aSource[3]
         aTarget[4] := aSource[4]
      ENDIF

      * Center bitmap horizontally or vertically in ::oCanvas
      IF aTarget[3] < aSize[1]-2
         nAspect := ( aSize[1]-2-aTarget[3] ) / 2
         aTarget[1] += nAspect
         aTarget[3] += nAspect
      ENDIF

      IF aTarget[4] < aSize[2]-2
         nAspect := ( aSize[2]-2-aTarget[4] ) / 2
         aTarget[2] += nAspect
         aTarget[4] += nAspect
      ENDIF

      ::oBitmap:draw( ::oPS, aTarget, aSource, , GRA_BLT_BBO_IGNORE )
      Sleep(1)

   CASE ::nMode == 2
      * A meta file is loaded
      IF ::autoScale
         ::oMetafile:draw( ::oPS, XBPMETA_DRAW_SCALE )
      ELSE
         ::oMetafile:draw( ::oPS, XBPMETA_DRAW_DEFAULT )
      ENDIF

   ENDCASE

   GraPathClip( ::oPS, .F. )

RETURN lSuccess

*===============================================================================
FUNCTION Doc_WORD( cFile, aData, cSaveAs, lPrint)
  LOCAL oWord,oBM,oDoc

  * Create a Word ActiveX component
  oWord := CreateObject("Word.Application")
  IF Empty( oWord )
    MsgBox( "Microsoft Word není nainstalován !" )
  ENDIF

  oWord:visible := .T.

  * Open a Word document  //and retrieve the bookmarks collection.
  oWord:documents:open( cFile )
  oDoc := oWord:ActiveDocument
  * Save the resulting Word document
  IF(ValType(cSaveAs)=="C")
    oDoc:saveas(cSaveAs)
  ENDIF

  * Optional print out of document to standard printer
  IF(ValType(lPrint)=="L" .AND. lPrint)
    oDoc:PrintOut()
  ENDIF

  * Close the document and destroy the ActiveX object
**  oDoc:close()
**  oWord:Quit()
**  oWord:destroy()
RETURN NIL


*===============================================================================
FUNCTION Doc_EXCEL( cFile)
  *
  LOCAL oExcel, oBook, oSheet
  LOCAL cDir, nRow

  * Create the "Excel.Application" object
  oExcel := CreateObject("Excel.Application")
  IF Empty( oExcel )
    MsgBox( "Excel není nainstalován !" )
    RETURN nil
  ENDIF

  // Avoid message boxes such as "File already exists". Also,
  // ensure the Excel application is visible.
  oExcel:DisplayAlerts := .F.
  oExcel:visible       := .T.

  // Add a workbook to the Excel application. Query for
  // the active sheet (sheet-1) and set up page/paper
  // orientation.
**  cDir := CurDrive()+":\"+CurDir()
  oBook  := oExcel:workbooks:Add()
  oSheet := oBook:ActiveSheet
**  oSheet:PageSetup:Orientation := xlLandscape

  // Open source table, reset the row counter used
  // to determine the row# inside the excel
  // sheet later on.
  /*
  Set(_SET_DEFAULT, cDir + "\..\..\data" )
  DbeSetDefault("FOXCDX")
  USE "PARTS.DBF" EXCLUSIVE
  DbGoTop()
  nRow := 1

  // Format the columns. Column #1 is for the part
  // name, all others visualize numerice values
  oSheet:Columns( 2 ):NumberFormat := "0.00"
  oSheet:Columns( 3 ):NumberFormat := "0.00"

  // Feed in the data from the table to the Cells
  // of the sheet.
  ? "Copy the values from the DBF table"
  DO WHILE !EOF()
    oSheet:Cells(nRow,1):Value := FIELD->PARTNAME
    oSheet:Cells(nRow,2):Value := FIELD->PURCHASE
    oSheet:Cells(nRow,3):Value := FIELD->SELLPRICE
    nRow++
    DbSkip(1)
  ENDDO
  */
  // Force a reformat for the size of the first column
  oSheet:Columns( 1 ):AutoFit()
**  ? oBook:FullName

  // Save workbook as ordinary excel file.
*  oBook:SaveAs(cDir+"\MyExcel.xls",xlWorkbookNormal)
**  oBook:SaveAs( cFile, xlWorkbookNormal)

  // Quit Excel
**  oExcel:Quit()
**  oExcel:Destroy()
*  WAIT
RETURN nil

