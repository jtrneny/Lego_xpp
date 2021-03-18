// Alaska Software Xbase++ header constants and function definitions for LS24.DLL
//  (c) combit GmbH
//  [build of 2018-10-02 09:10:08]

// HEADER file to be included in all modules using LS24

#ifndef _LS24_CH // include header only once
#define _LS24_CH

#ifndef CMBTLANG_DEFAULT
 #define CMBTLANG_DEFAULT    -1
 #define CMBTLANG_GERMAN      0
 #define CMBTLANG_ENGLISH     1
 #define CMBTLANG_ARABIC      2
 #define CMBTLANG_AFRIKAANS   3
 #define CMBTLANG_ALBANIAN    4
 #define CMBTLANG_BASQUE      5
 #define CMBTLANG_BULGARIAN   6
 #define CMBTLANG_BYELORUSSIAN 7
 #define CMBTLANG_CATALAN     8
 #define CMBTLANG_CHINESE     9
 #define CMBTLANG_CROATIAN    10
 #define CMBTLANG_CZECH       11
 #define CMBTLANG_DANISH      12
 #define CMBTLANG_DUTCH       13
 #define CMBTLANG_ESTONIAN    14
 #define CMBTLANG_FAEROESE    15
 #define CMBTLANG_FARSI       16
 #define CMBTLANG_FINNISH     17
 #define CMBTLANG_FRENCH      18
 #define CMBTLANG_GREEK       19
 #define CMBTLANG_HEBREW      20
 #define CMBTLANG_HUNGARIAN   21
 #define CMBTLANG_ICELANDIC   22
 #define CMBTLANG_INDONESIAN  23
 #define CMBTLANG_ITALIAN     24
 #define CMBTLANG_JAPANESE    25
 #define CMBTLANG_KOREAN      26
 #define CMBTLANG_LATVIAN     27
 #define CMBTLANG_LITHUANIAN  28
 #define CMBTLANG_NORWEGIAN   29
 #define CMBTLANG_POLISH      30
 #define CMBTLANG_PORTUGUESE  31
 #define CMBTLANG_ROMANIAN    32
 #define CMBTLANG_RUSSIAN     33
 #define CMBTLANG_SLOVAK      34
 #define CMBTLANG_SLOVENIAN   35
 #define CMBTLANG_SERBIAN     36
 #define CMBTLANG_SPANISH     37
 #define CMBTLANG_SWEDISH     38
 #define CMBTLANG_THAI        39
 #define CMBTLANG_TURKISH     40
 #define CMBTLANG_UKRAINIAN   41
 #define CMBTLANG_SERBIAN_LATIN  42
#endif

/*--- constant declarations ---*/

#define LL_STGSYS_VERSION_LL18         (2)                  /* Internal use only */
#define LL_ERR_STG_NOSTORAGE           (-1000)             
#define LL_ERR_STG_BADVERSION          (-1001)             
#define LL_ERR_STG_READ                (-1002)             
#define LL_ERR_STG_WRITE               (-1003)             
#define LL_ERR_STG_UNKNOWNSYSTEM       (-1004)             
#define LL_ERR_STG_BADHANDLE           (-1005)             
#define LL_ERR_STG_ENDOFLIST           (-1006)             
#define LL_ERR_STG_BADJOB              (-1007)             
#define LL_ERR_STG_ACCESSDENIED        (-1008)             
#define LL_ERR_STG_BADSTORAGE          (-1009)             
#define LL_ERR_STG_CANNOTGETMETAFILE   (-1010)             
#define LL_ERR_STG_OUTOFMEMORY         (-1011)             
#define LL_ERR_STG_SEND_FAILED         (-1012)             
#define LL_ERR_STG_DOWNLOAD_PENDING    (-1013)             
#define LL_ERR_STG_DOWNLOAD_FAILED     (-1014)             
#define LL_ERR_STG_WRITE_FAILED        (-1015)             
#define LL_ERR_STG_UNEXPECTED          (-1016)             
#define LL_ERR_STG_CANNOTCREATEFILE    (-1017)             
#define LL_ERR_STG_UNKNOWN_CONVERTER   (-1018)             
#define LL_ERR_STG_INET_ERROR          (-1019)             
#define LL_ERR_STG_NOTFOUND            (-1020)             
#define LL_WRN_STG_UNFAXED_PAGES       (-1100)             
#define LS_OPTION_HAS16BITPAGES        (200)                /* has job 16 bit pages? */
#define LS_OPTION_BOXTYPE              (201)                /* wait meter box type */
#define LS_OPTION_UNITS                (203)                /* LL_UNITS_INCH_DIV_100 or LL_UNITS_MM_DIV_10 */
#define LS_OPTION_PRINTERCOUNT         (204)                /* number of printers (1 or 2) */
#define LS_OPTION_ISSTORAGE            (205)                /* returns whether file is STORAGE or COMPAT4 */
#define LS_OPTION_EMFRESOLUTION        (206)                /* EMFRESOLUTION used to print the file */
#define LS_OPTION_JOB                  (207)                /* returns current job number */
#define LS_OPTION_TOTALPAGES           (208)                /* differs from GetPageCount() if print range in effect */
#define LS_OPTION_PAGESWITHFAXNUMBER   (209)               
#define LS_OPTION_HASINPUTOBJECTS      (210)               
#define LS_OPTION_HASFORCEDINPUTOBJECTS (211)               
#define LS_OPTION_INPUTOBJECTSFINISHED (212)               
#define LS_OPTION_HASHYPERLINKS        (213)               
#define LS_OPTION_USED_PRINTERCOUNT    (214)                /* count of printers actually used (compares DEVMODEs etc) */
#define LS_OPTION_PAGENUMBER           (0)                  /* page number of current page */
#define LS_OPTION_COPIES               (1)                  /* number of copies (same for all pages at the moment) */
#define LS_OPTION_PRN_ORIENTATION      (2)                  /* orientation (DMORIENT_LANDSCAPE, DMORIENT_PORTRAIT) */
#define LS_OPTION_PHYSPAGE             (3)                  /* is page "physical page" oriented? */
#define LS_OPTION_PRN_PIXELSOFFSET_X   (4)                  /* this and the following values are */
#define LS_OPTION_PRN_PIXELSOFFSET_Y   (5)                  /* values of the printer that the preview was */
#define LS_OPTION_PRN_PIXELS_X         (6)                  /* created on! */
#define LS_OPTION_PRN_PIXELS_Y         (7)                 
#define LS_OPTION_PRN_PIXELSPHYSICAL_X (8)                 
#define LS_OPTION_PRN_PIXELSPHYSICAL_Y (9)                 
#define LS_OPTION_PRN_PIXELSPERINCH_X  (10)                
#define LS_OPTION_PRN_PIXELSPERINCH_Y  (11)                
#define LS_OPTION_PRN_INDEX            (12)                 /* printer index of the page (0/1) */
#define LS_OPTION_PRN_PAPERTYPE        (13)                
#define LS_OPTION_PRN_PAPERSIZE_X      (14)                
#define LS_OPTION_PRN_PAPERSIZE_Y      (15)                
#define LS_OPTION_PRN_FORCE_PAPERSIZE  (16)                
#define LS_OPTION_STARTNEWSHEET        (17)                
#define LS_OPTION_ISSUEINDEX           (18)                
#define LS_OPTION_STARTNEWJOB          (19)                
#define LS_OPTION_PAGETYPE             (20)                 /* 0=normal, 1=GTC */
#define LS_OPTION_PROJECTNAME          (100)                /* name of the original project (not page dependent) */
#define LS_OPTION_JOBNAME              (101)                /* name of the job (WindowTitle of LlPrintWithBoxStart()) (not page dependent) */
#define LS_OPTION_PRTNAME              (102)                /* deprecated! */
#define LS_OPTION_PRTDEVICE            (103)                /* printer device ("HP Laserjet 4L") */
#define LS_OPTION_PRTPORT              (104)                /* deprecated! */
#define LS_OPTION_USER                 (105)                /* user string (not page dependent) */
#define LS_OPTION_CREATION             (106)                /* creation date (not page dependent) */
#define LS_OPTION_CREATIONAPP          (107)                /* creation application (not page dependent) */
#define LS_OPTION_CREATIONDLL          (108)                /* creation DLL (not page dependent) */
#define LS_OPTION_CREATIONUSER         (109)                /* creation user and computer name (not page dependent) */
#define LS_OPTION_FAXPARA_QUEUE        (110)                /* NYI */
#define LS_OPTION_FAXPARA_RECIPNAME    (111)                /* NYI */
#define LS_OPTION_FAXPARA_RECIPNUMBER  (112)                /* NYI */
#define LS_OPTION_FAXPARA_SENDERNAME   (113)                /* NYI */
#define LS_OPTION_FAXPARA_SENDERCOMPANY (114)                /* NYI */
#define LS_OPTION_FAXPARA_SENDERDEPT   (115)                /* NYI */
#define LS_OPTION_FAXPARA_SENDERBILLINGCODE (116)                /* NYI */
#define LS_OPTION_FAX_AVAILABLEQUEUES  (118)                /* NYI, nPageIndex=1 */
#define LS_OPTION_PRINTERALIASLIST     (119)                /* alternative printer list (taken from project) */
#define LS_OPTION_PRTDEVMODE           (120)                /* r/o, DEVMODEW structure, to be used with the LlConvertXxxx API */
#define LS_OPTION_USED_PRTDEVICE       (121)                /* r/o, printer name that would actually be used */
#define LS_OPTION_USED_PRTDEVMODE      (122)                /* r/o, DEVMODEW structure, to be used with the LlConvertXxxx API */
#define LS_OPTION_REGIONNAME           (123)                /* r/o */
#define LS_PRINTFLAG_FIT               (0x00000001)        
#define LS_PRINTFLAG_STACKEDCOPIES     (0x00000002)         /* n times page1, n times page2, ... (else n times (page 1...x)) */
#define LS_PRINTFLAG_TRYPRINTERCOPIES  (0x00000004)         /* first try printer copies, then simulated ones... */
#define LS_PRINTFLAG_SHOWDIALOG        (0x00000008)        
#define LS_PRINTFLAG_METER             (0x00000010)        
#define LS_PRINTFLAG_ABORTABLEMETER    (0x00000020)        
#define LS_PRINTFLAG_METERMASK         (0x00000070)         /* allows 7 styles of abort boxes... */
#define LS_PRINTFLAG_USEDEFPRINTERIFNULL (0x00000080)        
#define LS_PRINTFLAG_FAX               (0x00000100)        
#define LS_PRINTFLAG_OVERRIDEPROJECTCOPYCOUNT (0x00000200)        
#define LS_PRINTFLAG_IGNORE_PROJECT_TRAY (0x00010000)        
#define LS_PRINTFLAG_IGNORE_PROJECT_DUPLEX (0x00020000)        
#define LS_PRINTFLAG_IGNORE_PROJECT_COLLATION (0x00040000)        
#define LS_PRINTFLAG_IGNORE_PROJECT_EXTRADATA (0x00080000)        
#define LS_VIEWERCONTROL_QUERY_CHARWIDTH (1)                  /* sent in wParam using LsGetViewerControlDefaultMessage() (return: 1 for SBCS, 2 for Unicode) */
#define LS_VIEWERCONTROL_CLEAR         (WM_USER+1)         
#define LS_VIEWERCONTROL_SET_HANDLE_EX (WM_USER+2)          /* wParam = HANDLE (NULL for RELEASE), lParam = internal struct handle; */
#define LS_VIEWERCONTROL_SET_HANDLE    (WM_USER+3)          /* wParam = HANDLE (NULL for RELEASE) */
#define LS_VIEWERCONTROLSETHANDLEFLAG_ADD (0x0100)            
#define LS_VIEWERCONTROLSETHANDLEFLAG_DELETE_ON_CLOSE (0x0200)            
#define LS_VIEWERCONTROL_GET_HANDLE    (WM_USER+4)          /* lParam = HANDLE (NULL for none) */
#define LS_VIEWERCONTROL_SET_FILENAME  (WM_USER+5)          /* lParam = LPCTSTR pszFilename (NULL for RELEASE), wParam = options */
#define LS_STGFILEOPEN_READONLY        (0x00000000)        
#define LS_STGFILEOPEN_READWRITE       (0x00000001)        
#define LS_STGFILEOPEN_FORCE_NO_READWRITE (0x00000002)         /* never open read-write, even if formula elements are present! */
#define LS_STGFILEOPEN_DELETE_ON_CLOSE (0x00000004)        
#define LS_STGFILEOPENFLAG_ADD         (0x00000100)        
#define LS_VIEWERCONTROL_SET_OPTION    (WM_USER+6)         
#define LS_OPTION_MESSAGE              (0)                  /* communication message */
#define LS_OPTION_PRINTERASSIGNMENT    (1)                  /* set BEFORE setting the storage handle/filename! */
#define LS_PRNASSIGNMENT_USEDEFAULT    (0x00000000)        
#define LS_PRNASSIGNMENT_ASKPRINTERIFNEEDED (0x00000001)        
#define LS_PRNASSIGNMENT_ASKPRINTERALWAYS (0x00000002)        
#define LS_PRNASSIGNMENT_ALWAYSUSEDEFAULT (0x00000003)         /* default */
#define LS_OPTION_TOOLBAR              (2)                  /* TRUE to force viewer control to display a toolbar, FALSE otherwise (def: FALSE) */
#define LS_OPTION_SKETCHBAR            (3)                  /* TRUE to force viewer control to display a sketch bar (def: TRUE) */
#define LS_OPTION_SKETCHBARWIDTH       (4)                  /* TRUE to force viewer control to display a sketch bar (def: 50) */
#define LS_OPTION_TOOLBARSTYLE         (5)                  /* default: LS_OPTION_TOOLBARSTYLE_STANDARD, set BEFORE LS_OPTION_TOOLBAR to TRUE! */
#define LS_OPTION_TOOLBARSTYLE_STANDARD (0)                  /* OFFICE97 alike style */
#define LS_OPTION_TOOLBARSTYLE_OFFICEXP (1)                  /* DOTNET/OFFICE_XP alike style */
#define LS_OPTION_TOOLBARSTYLE_OFFICE2003 (2)                 
#define LS_OPTION_TOOLBARSTYLEMASK     (0x0f)              
#define LS_OPTION_TOOLBARSTYLEFLAG_GRADIENT (0x80)               /* starting with XP, use gradient style */
#define LS_OPTION_CODEPAGE             (7)                  /* lParam = codepage for MBCS aware string operations - set it if the system default is not applicable */
#define LS_OPTION_SAVEASFILEPATH       (8)                  /* w/o, lParam = "SaveAs" default filename (LPCTSTR!) */
#define LS_OPTION_USERDATA             (9)                  /* for LS_VIEWERCONTROL_SET_NTFYCALLBACK */
#define LS_OPTION_BGCOLOR              (10)                 /* background color */
#define LS_OPTION_ASYNC_DOWNLOAD       (11)                 /* download is ASYNC (def: TRUE) */
#define LS_OPTION_LANGUAGE             (12)                 /* CMBTLANG_xxx or -1 for ThreadLocale */
#define LS_OPTION_ASSUME_TEMPFILE      (13)                 /* viewer assumes that the LL file is a temp file, so data can not be saved into it */
#define LS_OPTION_IOLECLIENTSITE       (14)                 /* internal use */
#define LS_OPTION_TOOLTIPS             (15)                 /* lParam = flag value */
#define LS_OPTION_AUTOSAVE             (16)                 /* lParam = (BOOL)bAutoSave */
#define LS_OPTION_CHANGEDFLAG          (17)                 /* lParam = flag value */
#define LS_OPTION_SHOW_UNPRINTABLE_AREA (18)                 /* lParam = flags, default: FALSE */
#define LS_OPTION_NOUIRESET            (19)                 /* lParam = flags, default: TRUE */
#define LS_OPTION_NAVIGATIONBAR        (20)                 /* TRUE to force viewer control to display a sketch bar (def: TRUE) */
#define LS_OPTION_NAVIGATIONBARWIDTH   (21)                 /* TRUE to force viewer control to display a sketch bar (def: 50) */
#define LS_OPTION_IN_PREVIEWPANE       (22)                 /* TRUE to disable unneeded message boxes */
#define LS_OPTION_IN_LLVIEWER          (23)                 /* internal */
#define LS_OPTION_TABBARSTYLE          (24)                
#define LS_OPTION_TABBARSTYLE_STANDARD (0)                 
#define LS_OPTION_TABBARSTYLE_OFFICEXP (1)                 
#define LS_OPTION_TABBARSTYLE_OFFICE2003 (2)                 
#define LS_OPTION_DESIGNERPREVIEW      (25)                
#define LS_OPTION_MOUSEMODE            (26)                
#define LS_OPTION_MOUSEMODE_MOVE       (1)                 
#define LS_OPTION_MOUSEMODE_ZOOM       (2)                 
#define LS_OPTION_ALLOW_RBUTTONUSAGE   (27)                 /* default: true */
#define LS_OPTION_TOOLBGCOLOR          (28)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_TYPE (29)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_TYPE_AREAFILL_SYSTEM (0)                  /* system theming (fixed colors, fixed rounding) */
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_TYPE_AREAFILL_WIN7ALIKE (1)                  /* like Windows 7 theming (fixed colors, fixed rounding) */
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_TYPE_AREAFILL (2)                 
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_TYPE_FRAME (3)                 
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_HEIGHT_PX (30)                 /* default: 5 */
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_WIDTH_PX (31)                 /* default: 5 */
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_FILLCOLOR_ARGB (32)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_FILLCOLORHIGHLIGHTED_ARGB (33)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_FRAMECOLOR_ARGB (34)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_FRAMECOLORHIGHLIGHTED_ARGB (35)                
#define LS_OPTION_PAGEITEM_SELECTED_ITEM_FRAME_ROUNDED_CORNER_PX (36)                 /* default: 5 */
#define LS_OPTION_PAGEITEM_DROPSHADOW  (37)                
#define LS_OPTION_PAGEITEM_DROPSHADOW_NONE (0)                 
#define LS_OPTION_PAGEITEM_DROPSHADOW_ONLY_NONSELECTED (1)                 
#define LS_OPTION_PAGEITEM_PAGENUMBER  (38)                 /* default: true (>=LS24) */
#define LS_OPTION_SKETCHBAR_BGCOLOR    (39)                 /* default: ::GetSysColor(COLOR_WINDOW) */
#define LS_VIEWERCONTROL_GET_OPTION    (WM_USER+7)         
#define LS_VIEWERCONTROL_QUERY_ENDSESSION (WM_USER+8)         
#define LS_VIEWERCONTROL_GET_ZOOM      (WM_USER+9)         
#define LS_VIEWERCONTROL_SET_ZOOM      (WM_USER+10)         /* wParam = factor (lParam = 1 if in percent) */
#define LS_VIEWERCONTROL_GET_ZOOMED    (WM_USER+11)         /* TRUE if zoomed */
#define LS_VIEWERCONTROL_POP_ZOOM      (WM_USER+12)        
#define LS_VIEWERCONTROL_RESET_ZOOM    (WM_USER+13)        
#define LS_VIEWERCONTROL_SET_ZOOM_TWICE (WM_USER+14)        
#define LS_VIEWERCONTROL_SET_PAGE      (WM_USER+20)         /* wParam = page# (0..n-1) */
#define LS_VIEWERCONTROL_GET_PAGE      (WM_USER+21)        
#define LS_VIEWERCONTROL_GET_PAGECOUNT (WM_USER+22)        
#define LS_VIEWERCONTROL_GET_PAGECOUNT_FAXPAGES (WM_USER+23)        
#define LS_VIEWERCONTROL_GET_JOB       (WM_USER+24)        
#define LS_VIEWERCONTROL_GET_JOBPAGEINDEX (WM_USER+25)        
#define LS_VIEWERCONTROL_GET_METAFILE  (WM_USER+26)         /* wParam = page#, for IMMEDIATE use (will be released by LS DLL at some undefined time!) */
#define LS_VIEWERCONTROL_GET_ENABLED   (WM_USER+27)         /* wParam = ID */
#define LS_VCITEM_SEARCH_FIRST         (0)                 
#define LS_VCITEM_SEARCH_NEXT          (1)                 
#define LS_VCITEM_SEARCH_OPTS          (2)                 
#define LS_VCITEM_SEARCHACTIONMASK     (0x00000fff)        
#define LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE (0x00008000)        
#define LS_VCITEM_SEARCHFLAG_UTF16     (0x00004000)        
#define LS_VCITEM_SEARCHFLAGMASK       (0xfffff000)        
#define LS_VCITEM_SAVE_AS_FILE         (3)                 
#define LS_VCITEM_SEND_AS_MAIL         (4)                 
#define LS_VCITEM_SEND_AS_FAX          (5)                 
#define LS_VCITEM_PRINT_ONE            (6)                 
#define LS_VCITEM_PRINT_ALL            (7)                 
#define LS_VCITEM_PAGENUMBER           (8)                 
#define LS_VCITEM_ZOOM                 (9)                 
#define LS_VCITEM_THEATERMODE          (10)                
#define LS_VCITEM_PREVSTG              (11)                
#define LS_VCITEM_NEXTSTG              (12)                
#define LS_VCITEM_SEARCH_DONE          (13)                
#define LS_VCITEM_FIRSTPAGE            (14)                
#define LS_VCITEM_NEXTPAGE             (15)                
#define LS_VCITEM_PREVIOUSPAGE         (16)                
#define LS_VCITEM_LASTPAGE             (17)                
#define LS_VCITEM_MOUSEMODE_MOVE       (18)                
#define LS_VCITEM_MOUSEMODE_ZOOM       (19)                
#define LS_VIEWERCONTROL_GET_SEARCHSTATE (WM_USER+28)         /* returns TRUE if search in progress */
#define LS_VIEWERCONTROL_SEARCH        (WM_USER+29)         /* wParam = LS_VCITEM_SEARCH_Xxxx enum, OR'ed optionally with LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE, lParam=SearchText in control's charset flavour (ANSI/UNICODE) (NULL or empty to stop) */
#define LS_VIEWERCONTROL_SEARCHDLGACTIVE (WM_USER+30)         /* returns HANDLE to common search dialog if it is currently being shown, otherwise NULL */
#define LS_VIEWERCONTROL_PRINT_CURRENT (WM_USER+31)         /* wParam = 0 (default printer), 1 (with printer selection) */
#define LS_VIEWERCONTROL_PRINT_ALL     (WM_USER+32)         /* wParam = 0 (default printer), 1 (with printer selection) */
#define LS_VIEWERCONTROL_PRINT_TO_FAX  (WM_USER+33)        
#define LS_VIEWERCONTROL_UPDATE_TOOLBAR (WM_USER+35)         /* if LS_OPTION_TOOLBAR is TRUE */
#define LS_VIEWERCONTROL_GET_TOOLBAR   (WM_USER+36)         /* if LS_OPTION_TOOLBAR is TRUE, returns window handle of toolbar */
#define LS_VIEWERCONTROL_SAVE_TO_FILE  (WM_USER+37)         /* if lParam is non-NULL, it is the export type ID */
#define LS_VIEWERCONTROL_SEND_AS_MAIL  (WM_USER+39)        
#define LS_VIEWERCONTROL_SET_OPTIONSTR (WM_USER+40)         /* see docs, wParam = (LPCTSTR)key, lParam = (LPCTSTR)value */
#define LS_VIEWERCONTROL_GET_OPTIONSTR (WM_USER+41)         /* see docs, wParam = (LPCTSTR)key, lParam = (LPCTSTR)value */
#define LS_VIEWERCONTROL_GET_OPTIONSTRLEN (WM_USER+42)         /* see docs, wParam = (LPCTSTR)key (returns size in TCHARs) */
#define LS_VIEWERCONTROL_SET_NTFYCALLBACK (WM_USER+43)         /* lParam = LRESULT ( WINAPI fn* )(UINT nMsg, LPARAM lParam, UINT nUserParameter); */
#define LS_VIEWERCONTROL_GET_NTFYCALLBACK (WM_USER+44)         /* LRESULT ( WINAPI fn* )(UINT nMsg, LPARAM lParam, UINT nUserParameter); */
#define LS_VIEWERCONTROL_GET_TOOLBARBUTTONSTATE (WM_USER+45)         /* wParam=nID -> -1=hidden, 1=enabled, 2=disabled (only when toobar present, to sync menu state) */
#define LS_VIEWERCONTROL_SET_FOCUS     (WM_USER+46)        
#define LS_VCSF_PREVIEW                (1)                 
#define LS_VCSF_SKETCHLIST             (2)                 
#define LS_VCSF_TOC                    (3)                 
#define LS_VIEWERCONTROL_ADDTOOLBARITEM (WM_USER+47)        
#define LS_VIEWERCONTROL_INTERNAL_CHECKERRORLIST (WM_USER+48)        
#define LS_VIEWERCONTROL_SET_THEATERMODE (WM_USER+49)         /* 0=non-theater, 1=with frame, 2=without frame */
#define LS_VIEWERCONTROL_SET_THEATERFLIPDELAY (WM_USER+50)         /* ms for each page */
#define LS_VIEWERCONTROL_SET_THEATERFLIPMODE (WM_USER+51)         /* wParam = mode */
#define LS_VCTFM_NONE                  (0)                 
#define LS_VCTFM_LINEAR                (1)                  /* lParam = (LPCTSTR)ProgID */
#define LS_VCTFM_FADE                  (2)                 
#define LS_VCTFM_WHEEL                 (3)                 
#define LS_VIEWERCONTROL_SELECT_THEATERXFORM (WM_USER+52)        
#define LS_VIEWERCONTROL_NTFY_PRVFSCHANGED (WM_USER+53)         /* wParam = ILLPreviewFileSystemChangeNotifier::enPrvFSChange.. */
#define LS_VIEWERCONTROL_SET_PROGRESSINFO (WM_USER+54)         /* wParam = nPercentage (-1=finished...) */
#define LS_VIEWERCONTROL_GET_FILENAME  (WM_USER+55)         /* lParam = LPTSTR pszFilename, wParam = sizeofTSTR(pszBuffer). Returns size needed if NULL filename */
#define LS_VIEWERCONTROL_QUERY_PRVFS_COMPLETE (WM_USER+56)         /* indicates whether the STGSYS file is complete (1=complete, 2=finished, but incomplete) */
#define LS_VIEWERCONTROL_ONSIZEMOVE    (WM_USER+57)         /* wParam = 0 (ENTER), 1 (EXIT) */
#define LS_VIEWERCONTROL_NTFY_SHOW     (WM_USER+58)         /* internal use */
#define LS_VIEWERCONTROL_GET_IDEVICEINFO (WM_USER+59)         /* internal use */
#define LS_VIEWERCONTROL_REMOVEFAILURETOOLTIPS (WM_USER+60)         /* internal use */
#define LS_VIEWERCONTROL_SET_LLNTFYSINK (WM_USER+61)         /* internal use */
#define LS_VIEWERCONTROL_OPEN_PREVSTG  (WM_USER+62)        
#define LS_VIEWERCONTROL_OPEN_NEXTSTG  (WM_USER+63)        
#define LS_VIEWERCONTROL_GET_THEATERSTATE (WM_USER+64)         /* returns TRUE if in theater mode */
#define LS_VIEWERCONTROL_SET_PROGRESSINFO_INTERNAL (WM_USER+65)        
#define LS_VIEWERCONTROL_GET_THIS      (WM_USER+67)         /* internal */
#define LS_VIEWERCONTROL_SEARCH_LINK   (WM_USER+68)         /* wParam = LS_VCITEM_GOTO_LINK_ enum, lParam=SearchText in control's charset flavour (ANSI/UNICODE) (NULL or empty to stop) */
#define LS_SEARCH_LINK_HYPERLINK       (0)                 
#define LS_VIEWERCONTROL_QUERY_DRILLDOWN_ACTIVE (WM_USER+69)         /* count of active drilldown jobs of visible storage - negative if error */
#define LS_VIEWERCONTROL_CMND_ABORT_DRILLDOWN_JOBS (WM_USER+70)        
#define LS_VIEWERCONTROL_STORAGE_CONTAINS_EXPORTFILE (WM_USER+71)         /* lParam = (LPCTSTR)format, returns 1 if yes, 0 if no, negative if error */
#define LS_VIEWERCONTROL_NTFY_PAGELOADED (1)                  /* lParam = page# */
#define LS_VIEWERCONTROL_NTFY_UPDATETOOLBAR (2)                  /* called when control does NOT have an own toolbar. lParam = 1 if count of pages did change */
#define LS_VIEWERCONTROL_NTFY_PRINT_START (3)                  /* lParam = &scViewerControlPrintData, return 1 to abort print */
#define LS_VIEWERCONTROL_NTFY_PRINT_PAGE (4)                  /* lParam = &scViewerControlPrintData, return 1 to abort loop */
#define LS_VIEWERCONTROL_NTFY_PRINT_END (5)                  /* lParam = &scViewerControlPrintData */
#define LS_VIEWERCONTROL_NTFY_TOOLBARUPDATE (6)                  /* lParam = toolbar handle, called when control has an own toolbar */
#define LS_VIEWERCONTROL_NTFY_EXITBTNPRESSED (7)                 
#define LS_VIEWERCONTROL_NTFY_BTNPRESSED (8)                  /* lParam = control ID */
#define LS_VIEWERCONTROL_QUEST_BTNSTATE (9)                  /* lParam = control ID, -1 to hide, 1 to show, 2 to disable (0 to use default) */
#define LS_VIEWERCONTROL_NTFY_ERROR    (10)                 /* lParam = &scVCError. Return != 0 to suppress error mbox from control. */
#define LS_VIEWERCONTROL_NTFY_MAIL_SENT (11)                 /* lParam = Stream* of EML mail contents */
#define LS_VIEWERCONTROL_NTFY_DOWNLOADFINISHED (12)                 /* lParam = 0 (failed), 1 (ok) */
#define LS_VIEWERCONTROL_NTFY_KEYBOARDMESSAGE (13)                 /* lParam = const MSG*. Return TRUE if message should be taken out of the input queue */
#define LS_VIEWERCONTROL_NTFY_VIEWCHANGED (14)                
#define LS_VIEWERCONTROL_CMND_SAVEDATA (15)                 /* return: 0 = OK, -1 = failure, 1 = save in LL file too [event used only if AUTOSAVE is TRUE] */
#define LS_VIEWERCONTROL_NTFY_DATACHANGED (16)                
#define LS_VIEWERCONTROL_NTFY_PROGRESS (17)                 /* lParam = percentage (-1=finished). return: 1 if internal progress bar shall be suppressed */
#define LS_VIEWERCONTROL_QUEST_SUPPORTCONTINUATION (18)                 /* return: 1 if continuation button () should be displayed */
#define LS_VIEWERCONTROL_CMND_CONTINUE (19)                 /* continue report! */
#define LS_VIEWERCONTROL_NTFY_VIEWERDRILLDOWN (20)                
#define LS_VIEWERCONTROL_QUEST_DRILLDOWNSUPPORT (21)                 /* 1 to allow (default), 0 to deny (if provider cannot handle multiple threads or so) */
#define LS_VIEWERCONTROL_QUEST_HOST_WANTS_KEY (22)                 /* lParam: MSG-structure (message = WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP, WM_CHAR), wParam = key code, lParam = snoop (0), action (1) */
#define LS_VIEWERCONTROL_INTERNALSYNC  (23)                 /* reserved, internal */
#define LS_VIEWERCONTROL_NTFY_RP_REALDATAJOB (24)                
#define LS_VIEWERCONTROL_QUEST_RP_REALDATAJOBSUPPORT (25)                 /* 1 to allow (default), 0 to deny (if provider cannot handle multiple threads or so) */
#define LS_VIEWERCONTROL_QUEST_PROJECTFILENAME (26)                 /* reserved, internal */
#define LS_VIEWERCONTROL_QUEST_ORGPROJECTFILENAME (27)                 /* reserved, internal */
#define LS_VIEWERCONTROL_NTFY_EXPANDABLEREGIONSJOB (28)                
#define LS_VIEWERCONTROL_NTFY_INTERACTIVESORTINGJOB (30)                
#define LS_VIEWERCONTROL_QUEST_ANYREALDATAJOBSUPPORT (32)                 /* 1 to allow (default), 0 to deny (if provider cannot handle multiple threads or so) */
#define LS_VIEWERCONTROL_NTFY_HYPERLINK (33)                 /* 1 to tell viewer it has been processed */
#define LS_VIEWERCONTROL_NTFY_ZOOMCHANGED (34)                 /* triggered whenever the zoom factor was updated */
#define LS_VIEWERCONTROL_NTFY_ACTIONRESULT (35)                 /* lParam = &scLSNtfyActionResult */
#define LS_VIEWERCONTROL_NTFY_RESETSEARCHSTATE (36)                 /* reserved, internal */
#define LS_MAILCONFIG_GLOBAL           (0x0001)            
#define LS_MAILCONFIG_USER             (0x0002)            
#define LS_MAILCONFIG_PROVIDER         (0x0004)            
#define LS_DIO_CHECKBOX                (0)                 
#define LS_DIO_PUSHBUTTON              (1)                 
#define LS_DIO_FLAG_READONLY           (0x0001)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NONE (0x0000)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NEW_WINDOW (0x0001)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NAVIGATION (0x0002)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_JAVA (0x0004)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_SCRIPTING (0x0008)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_ACTIVEX (0x0010)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_ONLINE (0x0020)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_BROWSERCONTEXTMENU (0x0040)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_PRINT (0x0080)            

#endif  /* #ifndef _LS24_CH */

