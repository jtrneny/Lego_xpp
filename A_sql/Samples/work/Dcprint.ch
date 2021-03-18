/*
   Program..: DCPRINT.CH
   Author...: Roger Donnay
   Notice...: (c) DONNAY Software Designs 1987-2005
   Date.....: May 2, 2005
   Notes....: Special Printer Dialog commands for dCLIP++ / eXpress++
*/

// ****************************************************************************
// Pre-defined paper sizes for XbpPrinter:setFormSize()
// ****************************************************************************

#ifndef XPBPRN_FORM_LETTER

#define  XBPPRN_FORM_LETTER                     1
#define  XBPPRN_FORM_LETTERSMALL                2
#define  XBPPRN_FORM_TABLOID                    3
#define  XBPPRN_FORM_LEDGER                     4
#define  XBPPRN_FORM_LEGAL                      5
#define  XBPPRN_FORM_STATEMENT                  6
#define  XBPPRN_FORM_EXECUTIVE                  7
#define  XBPPRN_FORM_A3                         8
#define  XBPPRN_FORM_A4                         9
#define  XBPPRN_FORM_A4SMALL                    10
#define  XBPPRN_FORM_A5                         11
#define  XBPPRN_FORM_B4                         12
#define  XBPPRN_FORM_B5                         13
#define  XBPPRN_FORM_FOLIO                      14
#define  XBPPRN_FORM_QUARTO                     15
#define  XBPPRN_FORM_10X14                      16
#define  XBPPRN_FORM_11X17                      17
#define  XBPPRN_FORM_NOTE                       18
#define  XBPPRN_FORM_ENVELOPE_9                 19
#define  XBPPRN_FORM_ENVELOPE_10                20
#define  XBPPRN_FORM_ENVELOPE_11                21
#define  XBPPRN_FORM_ENVELOPE_12                22
#define  XBPPRN_FORM_ENVELOPE_14                23
#define  XBPPRN_FORM_CSHEET                     24
#define  XBPPRN_FORM_DSHEET                     25
#define  XBPPRN_FORM_ESHEET                     26
#define  XBPPRN_FORM_ENVELOPE_DL                27
#define  XBPPRN_FORM_ENVELOPE_C5                28
#define  XBPPRN_FORM_ENVELOPE_C3                29
#define  XBPPRN_FORM_ENVELOPE_C4                30
#define  XBPPRN_FORM_ENVELOPE_C6                31
#define  XBPPRN_FORM_ENVELOPE_C65               32
#define  XBPPRN_FORM_ENVELOPE_B4                33
#define  XBPPRN_FORM_ENVELOPE_B5                34
#define  XBPPRN_FORM_ENVELOPE_B6                35
#define  XBPPRN_FORM_ENVELOPE_ITALY             36
#define  XBPPRN_FORM_ENVELOPE_MONARCH           37
#define  XBPPRN_FORM_ENVELOPE_PERS              38
#define  XBPPRN_FORM_FANFOLD_US                 39
#define  XBPPRN_FORM_FANFOLD_GER                40
#define  XBPPRN_FORM_FANFOLD_LGL_GER            41
#define  XBPPRN_FORM_ISO_B4                     42
#define  XBPPRN_FORM_JAPANESE_POSTCARD          43
#define  XBPPRN_FORM_9X11                       44
#define  XBPPRN_FORM_10X11                      45
#define  XBPPRN_FORM_15X11                      46
#define  XBPPRN_FORM_ENVELOPE_INV               47
#define  XBPPRN_FORM_LETTER_EXTRA               50
#define  XBPPRN_FORM_LEGAL_EXTRA                51
#define  XBPPRN_FORM_TABLOID_EXTRA              52
#define  XBPPRN_FORM_A4_EXTRA                   53
#define  XBPPRN_FORM_LETTER_TRANSVERSE          54
#define  XBPPRN_FORM_A4_TRANSVERSE              55
#define  XBPPRN_FORM_LETTER_XTRA_TRANS          56
#define  XBPPRN_FORM_A_PLUS                     57
#define  XBPPRN_FORM_B_PLUS                     58
#define  XBPPRN_FORM_LETTER_PLUS                59
#define  XBPPRN_FORM_A4_PLUS                    60
#define  XBPPRN_FORM_A5_TRANSVERSE              61
#define  XBPPRN_FORM_B5_TRANSVERSE              62
#define  XBPPRN_FORM_A3_EXTRA                   63
#define  XBPPRN_FORM_A5_EXTRA                   64
#define  XBPPRN_FORM_B5_EXTRA                   65
#define  XBPPRN_FORM_A2                         66
#define  XBPPRN_FORM_A3_TRANSVERSE              67
#define  XBPPRN_FORM_A3_EXTRA_TRANS             68

#endif

#ifndef XBPPRN_PAPERBIN_SINGLE
  #define  XBPPRN_PAPERBIN_SINGLE         1
  #define  XBPPRN_PAPERBIN_LOWER          2
  #define  XBPPRN_PAPERBIN_MIDDLE         3
  #define  XBPPRN_PAPERBIN_MANUAL         4
  #define  XBPPRN_PAPERBIN_ENVELOPE       5
  #define  XBPPRN_PAPERBIN_ENVMANUAL      6
  #define  XBPPRN_PAPERBIN_AUTO           7
  #define  XBPPRN_PAPERBIN_TRACTOR        8
  #define  XBPPRN_PAPERBIN_SMALLFORMAT    9
  #define  XBPPRN_PAPERBIN_LARGEFORMAT   10
  #define  XBPPRN_PAPERBIN_LARGECAPACITY 11
  #define  XBPPRN_PAPERBIN_CASETTE       14
  #define  XBPPRN_PAPERBIN_FORMSOURCE    15
#endif


#ifndef XPBPRN_COLLATIONMODE_OFF
  #define  XBPPRN_COLLATIONMODE_OFF       0
  #define  XBPPRN_COLLATIONMODE_ON        1
#endif

#ifndef XPBPRN_DUPLEXMODE_OFF
  #define  XBPPRN_DUPLEXMODE_OFF          1
  #define  XBPPRN_DUPLEXMODE_MEMO         2
  #define  XBPPRN_DUPLEXMODE_BOOK         3
#endif

#ifndef XPBPRN_COLORMODE_OFF
  #define  XBPPRN_COLORMODE_OFF           1
  #define  XBPPRN_COLORMODE_ON            2
#endif

#ifndef XPBPRN_FILE_PROMPT
  #define  XBPPRN_FILE_PROMPT            "FILE:"
#endif

#ifndef XBPPRN_RESOLUTION_DRAFT
  #define  XBPPRN_RESOLUTION_DRAFT         (-1)
  #define  XBPPRN_RESOLUTION_LOW           (-2)
  #define  XBPPRN_RESOLUTION_MEDIUM        (-3)
  #define  XBPPRN_RESOLUTION_HIGH          (-4)
#endif

#ifndef XBPPRN_ORIENT_LANDSCAPE
  #define  XBPPRN_ORIENT_PORTRAIT                 1
  #define  XBPPRN_ORIENT_LANDSCAPE                2
#endif

#ifndef _JACE30XPP_CH
  #define JAHANDLE_PUNK               0
  #define JAHANDLE_HWND               2
  #define JARESIZESTYLE_X1LEFT        0x0
  #define JARESIZESTYLE_X1RIGHT       0x1
  #define JARESIZESTYLE_X2LEFT        0x00
  #define JARESIZESTYLE_X2RIGHT       0x10
  #define JARESIZESTYLE_Y1TOP         0x000
  #define JARESIZESTYLE_Y1BOTTOM      0x100
  #define JARESIZESTYLE_Y2TOP         0x0000
  #define JARESIZESTYLE_Y2BOTTOM      0x1000
#endif

/*
#define PROW()      DC_PrinterRow()
#define PRow()      DC_PrinterRow()
#define prow()      DC_PrinterRow()

#define PCOL()      DC_PrinterCol()
#define PCol()      DC_PrinterCol()
#define pcol()      DC_PrinterCol()
*/

#define DCPRINT_DIALOG_EXPRESS       1
#define DCPRINT_DIALOG_DRIVER        2

#define DCPRINT_ALIGN_BOTTOM          0
#define DCPRINT_ALIGN_LEFT            0
#define DCPRINT_ALIGN_TOP             1
#define DCPRINT_ALIGN_RIGHT           2
#define DCPRINT_ALIGN_HCENTER         4
#define DCPRINT_ALIGN_VCENTER         8

#define DCPRINT_BUTTON_PLUS           1
#define DCPRINT_BUTTON_MINUS          2
#define DCPRINT_BUTTON_FIRSTPAGE      3
#define DCPRINT_BUTTON_PREVPAGE       4
#define DCPRINT_BUTTON_NEXTPAGE       5
#define DCPRINT_BUTTON_LASTPAGE       6
#define DCPRINT_BUTTON_PRINT          7
#define DCPRINT_BUTTON_FIND           8
#define DCPRINT_BUTTON_EXIT           9
#define DCPRINT_BUTTON_FIRSTGROUP    10
#define DCPRINT_BUTTON_PREVGROUP     11
#define DCPRINT_BUTTON_NEXTGROUP     12
#define DCPRINT_BUTTON_LASTGROUP     13

#define DCPRINT_GROUP_NONE            0
#define DCPRINT_GROUP_FIRST           1
#define DCPRINT_GROUP_PREV            2
#define DCPRINT_GROUP_NEXT            3
#define DCPRINT_GROUP_LAST            4

#define DCPRINT_OPTIONARRAY_SIZE     66

#xcommand DCPRINT SAY <uText> [<opt,...>] => @ nil, nil DCPRINT SAY <uText> [<opt>]

#command @ <nRow>, <nCol> DCPRINT SAY <uText>                            ;
                   [PRINTER <o>]                                         ;
                   [PICTURE <p>]                                         ;
                   [<truetype:TRUETYPE>] [_TRUETYPE <_truetype>]         ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [<fixed:FIXED>] [_FIXED <_fixed>]                     ;
                   [FONT <ocFont> [CODEPAGE <nCodePage>]]                ;
                   [COLOR <nColorFG> [,<nColorBG>]]                      ;
                   [ATTRIBUTE <aAttr>]                                   ;
                   [ALIGN <nAlign>]                                      ;
                   [<outline:OUTLINE>] [_OUTLINE <_outline>]             ;
                   [WHEN <bWhen>]                                        ;
                   [WIDTH <nWidth>]                                      ;
      =>                                                                 ;
   DC_PrinterObject(<o>):AtSay( <nRow>, <nCol>,                          ;
                     TransForm(<uText>,DC_XtoC(<p>)),                    ;
                     <.truetype.> [.OR. <_truetype>],                    ;
                     <.pixel.> [.OR. <_pixel>],                          ;
                     <.fixed.> [.OR. <_fixed>],                          ;
                     <ocFont>,                                           ;
                     [<aAttr>] [DC_Color2Attr(<nColorFG>,<nColorBG>)],   ;
                     <nCodePage>,                                        ;
                     <nAlign>,                                           ;
                     <.outline.> [.OR. <_outline>],                      ;
                     <bWhen>,                                            ;
                     <nWidth> )


// Command DCRIGHTPRINT by Michael Rudrich
// This is made to enable right-justfied printing of numerics even when a true-type font is selected

#command @ <nRow>, <nCol> DCRIGHTPRINT SAY <uText>                       ;
                   [PRINTER <o>]                                         ;
                   [PICTURE <p>]                                         ;
                   [<truetype:TRUETYPE>] [_TRUETYPE <_truetype>]         ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [<fixed:FIXED>] [_FIXED <_fixed>]                     ;
                   [FONT <ocFont> [CODEPAGE <nCodePage>] ]               ;
                   [ATTRIBUTE <aAttr>]                                   ;
                   [COLOR <nColorFG> [,<nColorBG>]]                      ;
                   [WHEN <bWhen>]                                        ;
      =>                                                                 ;
   DC_PrinterObject(<o>):AtSay( <nRow>, DC_CalcPrinterColForRightJustified(<o>,<uText>,<nCol>,<p>),   ;
                     TransForm(<uText>,DC_XtoC(<p>)),                    ;
                     <.truetype.> [.OR. <_truetype>],                    ;
                     <.pixel.> [.OR. <_pixel>],                          ;
                     <.fixed.> [.OR. <_fixed>],                          ;
                     <ocFont>,                                           ;
                     [<aAttr>] [DC_Color2Attr(<nColorFG>,<nColorBG>)],   ;
                     <nCodePage>, nil, nil,                              ;
                     <bWhen> )

#command @ <nSRow>, <nSCol> [,<nERow>,<nECol>] DCPRINT BITMAP <ncRes>    ;
                   [BUFFER <cBuffer>]                                    ;
                   [RESTYPE <cResType>]                                  ;
                   [RESTYPE <cResFile>]                                  ;
                   [PRINTER <o>]                                         ;
                   [<autoscale:AUTOSCALE>]                               ;
                   [<noautoscale:NOAUTOSCALE>]                           ;
                   [<center:CENTER>] [_CENTER <_center>]                 ;
                   [SCALE <nScale>]                                      ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [WHEN <bWhen>]                                        ;
                   [RASTEROP <nRasterOp>]                                ;
      =>                                                                 ;
 DC_PrinterObject(<o>):BitMap( <nSRow>, <nSCol>, <nERow>, <nECol>,       ;
                       <ncRes>, [<.autoscale.>] [!<.noautoscale.>],      ;
                       <.center.> [.OR. <_center>], <nScale>,            ;
                       <.pixel.> [.OR. <_pixel>], <bWhen>,               ;
                       <cBuffer>, <(cResType)>, <(cResFile)>,            ;
                       <nRasterOp> )

#command @ <nSRow>, <nSCol> [,<nERow>,<nECol>] DCPRINT RTF <cRtf>        ;
                   [PRINTER <o>]                                         ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [WHEN <bWhen>]                                        ;
      =>                                                                 ;
 DC_PrinterObject(<o>):Rtf( <nSRow>, <nSCol>, <nERow>, <nECol>,          ;
                       <cRtf>, <.pixel.> [.OR. <_pixel>], <bWhen>)

#command @ <nSRow>, <nSCol>, <nERow>, <nECol> DCPRINT BOX                ;
                   [PRINTER <o>]                                         ;
                   [FILL <nFill>]                                        ;
                   [HRADIUS <nHrad>]                                     ;
                   [VRADIUS <nVrad>]                                     ;
                   [ATTRIBUTE <aAttr>]                                   ;
                   [AREAATTR <aAreaAttr>]                                ;
                   [LINEATTR <aLineAttr>]                                ;
                   [AREACOLOR <nAreaColorFG> [,<nAreaColorBG>]]          ;
                   [LINECOLOR <nLineColorFG> [,<nLineColorBG>]]          ;
                   [COLOR <nLineColorFG> [,<nLineColorBG>]]              ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [LINEWIDTH <nLineWidth>]                              ;
                   [GRAY <nGrayPct>]                                     ;
                   [WHEN <bWhen>]                                        ;
      =>                                                                 ;
 DC_PrinterObject(<o>):Box( <nSRow>, <nSCol>, <nERow>, <nECol>,          ;
                         <nFill>, <nHrad>, <nVrad>,                      ;
                         [<aAttr>] [<aAreaAttr>]                         ;
                          [DC_Color2Attr(<nAreaColorFG>,<nAreaColorBG>,GRA_AA_COUNT)],;
                         <.pixel.> [.OR. <_pixel>],                      ;
                         [<aLineAttr>]                                   ;
                          [DC_Color2Attr(<nLineColorFG>,<nLineColorBG>,GRA_AL_COUNT)],;
                         <nLineWidth>,                                   ;
                         <bWhen>,                                        ;
                         <nGrayPct>  )

#command @ <nSRow>, <nSCol>, <nERow>, <nECol> DCPRINT LINE               ;
                   [PRINTER <o>]                                         ;
                   [ATTRIBUTE <aAttr>]                                   ;
                   [COLOR <nColorFG> [,<nColorBG>]]                      ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [WHEN <bWhen>]                                        ;
                   [LINEWIDTH <nLineWidth>]                              ;
      =>                                                                 ;
 DC_PrinterObject(<o>):Line( <nSRow>, <nSCol>, <nERow>, <nECol>,         ;
                             [<aAttr>]                                   ;
                              [DC_Color2Attr(<nColorFG>,<nColorBG>,GRA_AL_COUNT)], ;
                             <.pixel.> [.OR. <_pixel>],         ;
                             <bWhen>, <nLineWidth> )


#command @ <nSRow>, <nSCol> DCPRINT MARKER                               ;
                   [PRINTER <o>]                                         ;
                   [ATTRIBUTE <aAttr>]                                   ;
                   [COLOR <nColorFG> [,<nColorBG>]]                      ;
                   [<pixel:PIXEL,NOSCALE>] [_PIXEL <_pixel>]             ;
                   [WHEN <bWhen>]                                        ;
      =>                                                                 ;
 DC_PrinterObject(<o>):Marker( <nSRow>, <nSCol>, <aAttr>                 ;
                               [DC_Color2Attr(<nColorFG>,<nColorBG>,GRA_AM_COUNT)], ;
                               <.pixel.> [.OR. <_pixel>], <bWhen> )

#command DCPRINT EJECT [PRINTER <o>] => DC_PrinterObject(<o>):Eject()

#command DCPRINT EXCELSHEET [NAME <x>] [PRINTER <o>] => DC_PrinterObject(<o>):ExcelSheet(<x>)

#command DCPRINT ENDPAGE [PRINTER <o>] [WHEN <bWhen>] => ;
         DC_PrinterObject(<o>):EndPage(<bWhen>)

#command DCPRINT FIXED <x:ON,OFF,&> [PRINTER <o>] => ;
         DC_PrinterObject(<o>):lFixed := IIF(<(x)>=='ON',.t.,.f.)

#command DCPRINT STARTPAGE [PRINTER <o>] [WHEN <bWhen>] => ;
         DC_PrinterObject(<o>):StartPage(<bWhen>)

#command DCPRINT ORIENTATION <n> [PRINTER <o>] [WHEN <bWhen>] => ;
         DC_PrinterObject(<o>):SetOrientation(<n>,<bWhen>)

#command DCPRINT PAPERBIN <n> [PRINTER <o>] [WHEN <bWhen>] => ;
         DC_PrinterObject(<o>):SetPaperBin(<n>,<bWhen>)

#command DCPRINT ABORT [PRINTER <o>] => DC_PrinterObject(<o>):Abort()

#command DCPRINT ? [<uText>] [PRINTER <o>]  ;
         [PICTURE <p>] [AT <n>] ;
         [ATTRIBUTE <a>] ;
         [COLOR <nColorFG> [,<nColorBG>]] ;
         [WHEN <b>]
  => DC_PrinterObject(<o>):Qout(<uText>,<p>,<n>,[<a>] [DC_Color2Attr(<nColorFG>,<nColorBG>)],<b>)

#command DCPRINT ?? [<uText>] [<lUsePenCoords:USEPENCOORDS>] [PRINTER <o>] ;
         [PICTURE <p>] [AT <n>] ;
         [ATTRIBUTE <a>] ;
         [COLOR <nColorFG> [,<nColorBG>]] ;
         [WHEN <b>] ;
     =>  ;
         DC_PrinterObject(<o>):QQout(<uText>,<.lUsePenCoords.>,<p>,<n>,[<a>] [DC_Color2Attr(<nColorFG>,<nColorBG>)],<b>)

#command DCPRINT FONT <ocFont>     ;
         [PRINTER <o>]             ;
         [CODEPAGE <n>]            ;
         [WHEN <b>]                ;
     =>                            ;
         DC_PrinterObject(<o>):SetFont(<ocFont>,<n>,<b>)

#command DCPRINT OFF [PRINTER <o>] [PAGE <nPage>] ;
         [TO <lStatus>] => [<lStatus> :=] DC_PrinterOff(<o>,<nPage>)

#command DCPRINT GROUPEJECT [PRINTER <o>] [PAGE <nPage>] ;
         [TO <lStatus>] => [<lStatus> :=] DC_PrinterGroupEject(<o>,<nPage>)

#command DCPRINT SIZE <nRows>,<nCols> [PRINTER <o>] [WHEN <b>] => ;
         DC_PrinterObject(<o>):SetSize( <nRows>, <nCols>, <b> )

#command DCPRINT ROWS <nRows> [PRINTER <o>] [WHEN <b>] => ;
         DC_PrinterObject(<o>):SetSize( <nRows>, nil, <b> )

#command DCPRINT COLS <nCols> [PRINTER <o>] [WHEN <b>] => ;
         DC_PrinterObject(<o>):SetSize( nil, <nCols>, <b> )

#command DCPRINT ON [ TO <oPrinter> ]                                      ;
                 [ NAME <cPrinterName> ]                                   ;
                 [ SIZE <nRows>,<nCols> ]                                  ;
                 [ PAGES <nFrom>, <nTo> ]                                  ;
                 [ PAGESIZE <nPageWidth>, <nPageHeight> ]                  ;
                 [ VIEWPORT <nX1>, <nY1>, <nX2>, <nY2> ]                   ;
                 [ <allpages:ALLPAGES> ] [_ALLPAGES <_allpages>]           ;
                 [ COPIES <nCopies> ]                                      ;
                 [ <lCopyLoop:COPYLOOP> ] [_COPYLOOP <_copyloop>]          ;
                 [ <collate:COLLATE> ] [_COLLATE <_collate>]               ;
                 [ <tofile:TOFILE> ] [_TOFILE <_tofile>]                   ;
                 [ <textonly:TEXTONLY> ] [_TEXTONLY <_textonly>]           ;
                 [ OUTFILE <(cOutFile)>                                    ;
                     [<ow:OVERWRITE>] [_OVERWRITE <_overwrite>]            ;
                     [<ap:APPEND>] [_APPEND <_append>] ]                   ;
                 [ <selection:SELECTION> ] [_SELECTION <_selection>]       ;
                 [ FONT <ocFont> ]                                         ;
                 [ <fixed:FIXED> ] [_FIXED <_fixed>]                       ;
                 [ <pixel:PIXEL,NOSCALE> ] [_PIXEL <_pixel>]               ;
                 [ UNITS <nUnits> ]                                        ;
                 [ <default:USEDEFAULT> ] [_USEDEFAULT <_usedefault>]      ;
                 [ HANDLER <bHandler> ]                                    ;
                 [ <fontbutton:FONTBUTTON>] [_FONTBUTTON <_fontbutton>]    ;
                 [ ORIENTATION <nOrientation> ]                            ;
                 [ MARGIN <anMargin> ]                                     ;
                 [ OPTIONS <aAltOptions> ]                                 ;
                 [ TITLE <cTitle> ]                                        ;
                 [ PAPERBIN <nPaperBin> ]                                  ;
                 [ FORMSIZE <nFormSize> ]                                  ;
                 [ <lEnableCancel:ENABLECANCEL,CANCELENABLE,CANCEL> ]      ;
                     [_ENABLECANCEL <_enablecancel>]                       ;
                 [ <preview:PREVIEW> ] [_PREVIEW <_preview>]               ;
                 [ <lNonStop:NOSTOP,NONSTOP> ] [_NONSTOP <_nonstop>]       ;
                 [ <lHide:HIDE> ] [_HIDE <_hide>]                          ;
                 [ ZOOMFACTOR <nZoomFactor> [,<nZoomIncr>] ]               ;
                 [ SCROLLFACTOR <nScrollFactor> ]                          ;
                 [ PPOSITION <nPreviewCol>, <nPreviewRow> ]                ;
                 [ PSIZE <nPreviewWidth> [,<nPreviewHeight>] ]             ;
                 [ <NoPrintButton:NOPRINTBUTTON> ]                         ;
                      [_NOPRINTBUTTON <_noprintbutton>]                    ;
                 [ BUSYMESSAGE <cBusyMsg> ]                                ;
                 [ <lForceDlg:FORCEPRINTDIALOG,FORCEDIALOG,PRINTDIALOG> ]  ;
                      [_FORCEDIALOG <_forcedialog>]                        ;
                 [ <lAutoEject:AUTOEJECT> ] [_AUTOEJECT <_autoeject>]      ;
                 [ DIALOGSTYLE <nDialogStyle> ]                            ;
                 [ <lGrid:GRID> ] [_GRID <_grid>]                          ;
                 [ DUPLEXMODE <nDuplexMode> ]                              ;
                 [ COLORMODE <nColorMode> ]                                ;
                 [ RESOLUTION <nResolution> ]                              ;
                 [ <lNoTrans:NOTRANSLATE> ] [_NOTRANSLATE <_notrans>]      ;
                 [ <lBorder:BORDER> ] [_BORDER <_border>]                  ;
                 [ <lFindButton:FINDBUTTON> ] [_FINDBUTTON <_findbutton>]  ;
                 [ BUTTONS <aButtons> ]                                    ;
                 [ <lAcrobat:ACROBAT> [<lNoSpawn:NOSPAWN>]] [_ACROBAT <_acrobat>];
                 [ ADDBUTTONS <aAddButtons> ]                              ;
                 [ <lGroupButt:GROUPBUTTONS> ] [_GROUPBUTTONS <_groupbutt>];
                 [ <lExit:EXITAFTERPRINT> ] [_EXITAFTERPRINT <_exit>]      ;
                 [ SCALEFONT <nScaleFont> ]                                ;
                 [ <lExcel:EXCEL> ] [_EXCEL <_excel>]                      ;
                 [ <lCombine:COMBINEEXCELSHEETS> ] [_COMBINEEXCELSHEETS <_combine>] ;
                 [ <lImageWriter:IMAGEWRITER,IMAGEVIEWER> ] [_IMAGEWRITER <_iw>]       ;
                 [ COLLATIONMODE <collation> ]                             ;
                 [ FONTMODE <fontmode> ]                                   ;
                 [ OWNER <owner> ]                                         ;
   =>                                                                      ;
    [ <oPrinter> := ] DC_PrinterOn( {                                      ;
                     <cPrinterName>,                          /*   1 */    ;
                     <nFrom>,                                 /*   2 */    ;
                     <nTo>,                                   /*   3 */    ;
                     <nRows>,                                 /*   4 */    ;
                     <nCols>,                                 /*   5 */    ;
                     <nCopies>,                               /*   6 */    ;
                     <.selection.> [.OR. <_selection>],       /*   7 */    ;
                     <.collate.> [.OR. <_collate>],           /*   8 */    ;
                     <.tofile.> [.OR. <_tofile>],             /*   9 */    ;
                     [{<nPageWidth>,<nPageHeight>}],          /*  10 */    ;
                     <ocFont>,                                /*  11 */    ;
                     nil,                                     /*  12 */    ;
                     <.fixed.> [.OR. <_fixed>],               /*  13 */    ;
                     <.pixel.> [.OR. <_pixel>],               /*  14 */    ;
                     <.preview.> [.OR. <_preview>],           /*  15 */    ;
                     [{<nX1>,<nY1>,<nX2>,<nY2>}],             /*  16 */    ;
                     nil,                                     /*  17 */    ;
                     <(cOutFile)>,                            /*  18 */    ;
                     <.textonly.> [.OR. <_textonly>],         /*  19 */    ;
                     <nUnits>,                                /*  20 */    ;
                     <nZoomFactor>,                           /*  21 */    ;
                     <nZoomIncr>,                             /*  22 */    ;
                     <nScrollFactor>,                         /*  23 */    ;
                     <nPreviewCol>,                           /*  24 */    ;
                     <nPreviewRow>,                           /*  25 */    ;
                     <nPreviewWidth>,                         /*  26 */    ;
                     <nPreviewHeight>,                        /*  27 */    ;
                     <.default.> [.OR. <_usedefault>],        /*  28 */    ;
                     <bHandler>,                              /*  29 */    ;
                     <.fontbutton.> [.OR. <_fontbutton>],     /*  30 */    ;
                     IIF(<.ow.>,1,0) + IIF(<.ap.>,2,0),       /*  31 */    ;
                     <nOrientation>,                          /*  32 */    ;
                     nil,                                     /*  33 */    ;
                     nil,                                     /*  34 */    ;
                     nil,                                     /*  35 */    ;
                     <anMargin>,                              /*  36 */    ;
                     <cTitle>,                                /*  37 */    ;
                     !<.lNonStop.> [.AND. !<_nonstop>],       /*  38 */    ;
                     <.lHide.> [.OR. <_hide>],                /*  39 */    ;
                     <nPaperBin>,                             /*  40 */    ;
                     <nFormSize>,                             /*  41 */    ;
                     !<.NoPrintButton.> [.AND. !<_noprintbutton>],  /*  42 */ ;
                     <.lEnableCancel.> [.OR. <_enablecancel>],/*  43 */    ;
                     <cBusyMsg>,                              /*  44 */    ;
                     <.lForceDlg.> [.OR. <_forcedialog>],     /*  45 */    ;
                     <.lAutoEject.> [.OR. <_autoeject>],      /*  46 */    ;
                     <.lCopyLoop.> [.OR. <_copyloop>],        /*  47 */    ;
                     <nDialogStyle>,                          /*  48 */    ;
                     <.lGrid.> [.OR. <_grid>],                /*  49 */    ;
                     <nDuplexMode>,                           /*  50 */    ;
                     <nColorMode>,                            /*  51 */    ;
                     <nResolution>,                           /*  52 */    ;
                     !<.lNoTrans.> [.AND. !<_notrans>],       /*  53 */    ;
                     <.lBorder.> [.OR. <_border>],            /*  54 */    ;
                     <.lFindButton.> [.OR. <_findbutton>],    /*  55 */    ;
                     <aButtons>,                              /*  56 */    ;
                     <.lAcrobat.> [.OR. <_acrobat>],          /*  57 */    ;
                     <aAddButtons>,                           /*  58 */    ;
                     <.lGroupButt.> [.OR. <_groupbutt>],      /*  59 */    ;
                     <.lExit.> [.OR <_exit>],                 /*  60 */    ;
                     <nScaleFont>,                            /*  61 */    ;
                     <.lImageWriter.> [.OR. <_iw>],           /*  62 */    ;
                     <.lExcel.> [.OR. <_excel>],              /*  63 */    ;
                     <.lCombine.> [.OR. <_combine>],          /*  64 */    ;
                     <owner>,                                 /*  65 */    ;
                     <.lNoSpawn.>                             /*  66 */    ;
                  }, <aAltOptions> )

#command DCPRINT OPTIONS                                                  ;
                 [ TO <aOptions> ]                                        ;
                 [ NAME <cPrinterName> ]                                  ;
                 [ SIZE <nRows>,<nCols> ]                                 ;
                 [ PAGES <nFrom>, <nTo> ]                                 ;
                 [ PAGESIZE <nPageWidth>, <nPageHeight> ]                 ;
                 [ VIEWPORT <nX1>, <nY1>, <nX2>, <nY2> ]                  ;
                 [ <allpages:ALLPAGES> ] [_ALLPAGES <_allpages>]          ;
                 [ COPIES <nCopies> ]                                     ;
                 [ <lCopyLoop:COPYLOOP> ] [_COPYLOOP <_copyloop>]         ;
                 [ <collate:COLLATE> ] [_COLLATE <_collate>]              ;
                 [ <textonly:TEXTONLY> ] [_TEXTONLY <_textonly>]          ;
                 [ OUTFILE <(cOutFile)>                                   ;
                     [<ow:OVERWRITE>] [_OVERWRITE <_overwrite>]           ;
                     [<ap:APPEND>] [_APPEND <_append>] ]                  ;
                 [ <tofile:TOFILE> ] [_TOFILE <_tofile>]                  ;
                 [ <selection:SELECTION> ] [_SELECTION <_selection>]      ;
                 [ FONT <ocFont> ]                                        ;
                 [ <fixed:FIXED> ] [_FIXED <_fixed>]                      ;
                 [ <pixel:PIXEL,NOSCALE> ] [_PIXEL <_pixel>]              ;
                 [ <preview:PREVIEW> ] [_PREVIEW <_preview>]              ;
                 [ UNITS <nUnits> ]                                       ;
                 [ ZOOMFACTOR <nZoomFactor> [,<nZoomIncr>] ]              ;
                 [ SCROLLFACTOR <nScrollFactor> ]                         ;
                 [ PPOSITION <nPreviewCol>, <nPreviewRow> ]               ;
                 [ PSIZE <nPreviewWidth>, <nPreviewHeight> ]              ;
                 [ <default:USEDEFAULT> ] [_USEDEFAULT <_usedefault>]     ;
                 [ HANDLER <bHandler> ]                                   ;
                 [ <fontbutton:FONTBUTTON> ] [_FONTBUTTON <_fontbutton>]  ;
                 [ ORIENTATION <nOrientation> ]                           ;
                 [ MARGIN <nMargin> ]                                     ;
                 [ TITLE <cTitle> ]                                       ;
                 [ <lNonStop:NOSTOP,NONSTOP> ] [_NONSTOP <_nonstop>]      ;
                 [ <lHide:HIDE> ] [_HIDE <_hide>]                         ;
                 [ PAPERBIN <nPaperBin> ]                                 ;
                 [ FORMSIZE <nFormSize> ]                                 ;
                 [ <NoPrintButton:NOPRINTBUTTON> ]                        ;
                   [_NOPRINTBUTTON <_noprintbutton>]                      ;
                 [ <lEnableCancel:ENABLECANCEL,CANCELENABLE,CANCEL> ]     ;
                   [_ENABLECANCEL <_enablecancel>]                        ;
                 [ BUSYMESSAGE <cBusyMsg> ]                               ;
                 [ <lForceDlg:FORCEPRINTDIALOG,FORCEDIALOG,PRINTDIALOG> ] ;
                   [_FORCEDIALOG <_forcedialog>]                          ;
                 [ <lAutoEject:AUTOEJECT> ] [_AUTOEJECT <_autoeject>]     ;
                 [ DIALOGSTYLE <nDialogStyle> ]                           ;
                 [ <lGrid:GRID> ] [_GRID <_grid>]                         ;
                 [ DUPLEXMODE <nDuplexMode> ]                             ;
                 [ COLORMODE <nColorMode> ]                               ;
                 [ RESOLUTION <nResolution> ]                             ;
                 [ <lNoTrans:NOTRANSLATE> ] [_NOTRANSLATE <_notrans>]     ;
                 [ <lBorder:BORDER> ] [_BORDER <_border>]                 ;
                 [ <lFindButton:FINDBUTTON> ] [_FINDBUTTON <_findbutton>] ;
                 [ BUTTONS <aButtons> ]                                   ;
                 [ <lAcrobat:ACROBAT> ] [_ACROBAT <_acrobat>]             ;
                 [ <lImageWriter:IMAGEWRITER> ] [_IMAGEWRITER <_iw>]      ;
                 [ ADDBUTTONS <aAddButtons> ]                             ;
                 [ <lGroupButt:GROUPBUTTONS> ] [_GROUPBUTTONS <_groupbutt>] ;
                 [ <lExit:EXITAFTERPRINT> ] [_EXITAFTERPRINT <_exit>]     ;
                 [ SCALEFONT <nScaleFont> ]                               ;
  =>                                                                      ;
  [<aOptions> :=]  { <cPrinterName>,                           /*   1 */  ;
                     <nFrom>,                                  /*   2 */  ;
                     <nTo>,                                    /*   3 */  ;
                     <nRows>,                                  /*   4 */  ;
                     <nCols>,                                  /*   5 */  ;
                     <nCopies>,                                /*   6 */  ;
                     <.selection.> [.OR. <_selection>],        /*   7 */  ;
                     <.collate.> [.OR. <_collate>],            /*   8 */  ;
                     <.tofile.> [.OR. <_tofile>],              /*   9 */  ;
                     {<nPageWidth>,<nPageHeight>},             /*  10 */  ;
                     <ocFont>,                                 /*  11 */  ;
                     nil,                                      /*  12 */  ;
                     <.fixed.> [.OR. <_fixed>],                /*  13 */  ;
                     <.pixel.> [.OR. <_pixel>],                /*  14 */  ;
                     <.preview.> [.OR. <_preview>],            /*  15 */  ;
                     [{<nX1>,<nY1>,<nX2>,<nY2>}],              /*  16 */  ;
                     <.allpages.> [.OR. <_allpages>],          /*  17 */  ;
                     <(cOutFile)>,                             /*  18 */  ;
                     <.textonly.>,                             /*  19 */  ;
                     <nUnits>,                                 /*  20 */  ;
                     <nZoomFactor>,                            /*  21 */  ;
                     <nZoomIncr>,                              /*  22 */  ;
                     <nScrollFactor>,                          /*  23 */  ;
                     <nPreviewCol>,                            /*  24 */  ;
                     <nPreviewRow>,                            /*  25 */  ;
                     <nPreviewWidth>,                          /*  26 */  ;
                     <nPreviewHeight>,                         /*  27 */  ;
                     <.default.> [.OR. <_usedefault>],         /*  28 */  ;
                     <bHandler>,                               /*  29 */  ;
                     <.fontbutton.> [.OR. <_fontbutton>],      /*  30 */  ;
                     IIF(<.ow.>,1,0) + IIF(<.ap.>,2,0),        /*  31 */  ;
                     <nOrientation>,                           /*  32 */  ;
                     nil,                                      /*  33 */  ;
                     nil,                                      /*  34 */  ;
                     nil,                                      /*  35 */  ;
                     <nMargin>,                                /*  36 */  ;
                     <cTitle>,                                 /*  37 */  ;
                     !<.lNonStop.> [.AND. !<_nonstop>],        /*  38 */  ;
                     <.lHide.> [.OR. <_hide>],                 /*  39 */  ;
                     <nPaperBin>,                              /*  40 */  ;
                     <nFormSize>,                              /*  41 */  ;
                     !<.NoPrintButton.> [.AND. !<_noprintbutton>], /*  42 */  ;
                     <.lEnableCancel.> [.OR. <_enablecancel>], /*  43 */  ;
                     <cBusyMsg>,                               /*  44 */  ;
                     <.lForceDlg.> [.OR. <_forcedialog>],      /*  45 */  ;
                     <.lAutoEject.> [.OR. <_autoeject>],       /*  46 */  ;
                     <.lCopyLoop.> [.OR. <_copyloop>],         /*  47 */  ;
                     <nDialogStyle>,                           /*  48 */  ;
                     <.lGrid.> [.OR. <_grid>],                 /*  49 */  ;
                     <nDuplexMode>,                            /*  50 */  ;
                     <nColorMode>,                             /*  51 */  ;
                     <nResolution>,                            /*  52 */  ;
                     !<.lNoTrans.> [.AND. !<_notrans>],        /*  53 */  ;
                     <.lBorder.> [.OR. <_border>],             /*  54 */  ;
                     <.lFindButton.> [.OR. <_findbutton>],     /*  55 */  ;
                     <aButtons>,                               /*  56 */  ;
                     <.lAcrobat.> [.OR. <_acrobat>],           /*  57 */  ;
                     <aAddButtons>,                            /*  58 */  ;
                     <.lGroupButt.> [.OR. <_groupbutt>],       /*  59 */  ;
                     <.lExit.> [.OR <_exit>],                  /*  60 */  ;
                     <nScaleFont>,                             /*  61 */  ;
                     <.lImageWriter.> [.OR. <_iw>]}            /*  62 */  ;

#command DCPRINT ATTRIBUTE                                                ;
             [PRINTER <o>]                                                ;
             [<text:TEXT,STRING> <aText>]                                 ;
             [LINE <aLine>]                                               ;
             [AREA <aArea>]                                               ;
             [MARKER <aMarker>]                                           ;
             [WHEN <bWhen>]                                               ;
         =>                                                               ;
  DC_PrinterObject(<o>):SetAttr( <aText>,<aLine>,<aArea>,<aMarker>,<bWhen> )


#command DCPRINT COLOR                                                    ;
             [PRINTER <o>]                                                ;
             [<text:TEXT,STRING> <nTextColorFG> [,<nTextColorBG>]]        ;
             [LINE <nLineColorFG>]                                        ;
             [AREA <nAreaColorFG> [,<nAreaColorBG>]]                      ;
             [MARKER <nMarkerColorFG> [,<nMarkerColorBG>]]                ;
             [WHEN <bWhen>]                                               ;
         =>                                                               ;
  DC_PrinterObject(<o>):SetAttr( [DC_Color2Attr(<nTextColorFG>,<nTextColorBG>)], ;
                                 [DC_Color2Attr(<nLineColorFG>,,GRA_AL_COUNT)], ;
                                 [DC_Color2Attr(<nAreaColorFG>,<nAreaColorBG>,GRA_AA_COUNT)], ;
                                 [DC_Color2Attr(<nMarkerColorFG>,<nMarkerColorBG>,GRA_AM_COUNT)], ;
                                 <bWhen> )

#command DCPRINT EVAL <bProc> [PRINTER <o>] [WHEN <bWhen>]                ;
         =>                                                               ;
  DC_PrinterObject(<o>):Eval( <bProc>, <bWhen> )


#command DCREPORT FORM <frm>                                              ;
         [HEADING <heading>]                                              ;
         [<plain: PLAIN>]                                                 ;
         [<noeject: NOEJECT>]                                             ;
         [<summary: SUMMARY>]                                             ;
         [<noconsole: NOCONSOLE>]                                         ;
         [PRINTER <oPrinter>]                                             ;
         [<print: TO PRINTER>]                                            ;
         [TO FILE <(toFile)>]                                             ;
         [FOR <for>]                                                      ;
         [WHILE <while>]                                                  ;
         [NEXT <next>]                                                    ;
         [RECORD <rec>]                                                   ;
         [<rest:REST>]                                                    ;
         [ALL]                                                            ;
         [<xbp:XBP>]                                                      ;
         [TITLEFONT <titlefont>]                                          ;
         [HEADFONT <headfont>]                                            ;
         [SIZE <nRows>,<nCols>]                                           ;
         [FONT <font>]                                                    ;
         [<preview:PREVIEW>]                                              ;
         [<acrobat:ACROBAT>]                                              ;
         [<textonly:TEXTONLY>]                                            ;
         [OPTIONS <aOptions>]                                             ;
      => DC_ReportForm(                                                   ;
                       <(frm)>, <.print.>, <(toFile)>, <.noconsole.>,     ;
                       <{for}>, <{while}>, <next>, <rec>, <.rest.>,       ;
                       <.plain.>, <heading>,                              ;
                       <.noeject.>, <.summary.>,                          ;
                       <.xbp.>, { <titlefont>,<headfont>,<font> },        ;
                       { <nRows>,<nCols> }, <.preview.>, <oPrinter>,      ;
                       <.textonly.>, <.acrobat.>, <aOptions>)

#command DCPRINT FONT <ocFont>     ;
         [PRINTER <o>]             ;
         [CODEPAGE <n>]            ;
     =>                            ;
         DC_PrinterObject(<o>):SetFont(<ocFont>,<n>)

#command DCPRINT OFF [PRINTER <o>] [PAGE <nPage>] => DC_PrinterOff(<o>,<nPage>)


#command LABEL FORM <lbl> [<sample: SAMPLE>] [<noconsole: NOCONSOLE>]   ;
         [<print: TO PRINT>] [TO FILE <(toFile)>] [FOR <for>]           ;
         [WHILE <while>] [NEXT <next>] [RECORD <rec>] [<rest:REST>]     ;
         [ALL]                                                          ;
      => DC_LBLFORM(<(lbl)>,<.print.>,<(toFile)>,<.noconsole.>,         ;
         <{for}>,<{while}>,<next>,<rec>,<.rest.>,<.sample.>)


