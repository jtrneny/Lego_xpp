// Alaska dBase++ header constants and function definitions for LS11.DLL
//  (c) 1991,..,1999,2000,..,06,... combit GmbH, Konstanz, Germany 
//  [build of 2006-08-03 10:08:04]

// HEADER file to be included in all modules using LS11

#ifndef _LS11_CH // include header only once
#define _LS11_CH

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
#endif

/*--- constant declarations ---*/

//#define LL_STG_COMPAT4                 (0)                 
//#define LL_STG_STORAGE                 (1)                 
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
#define LS_OPTION_PROJECTNAME          (100)                /* name of the original project (not page dependent) */
#define LS_OPTION_JOBNAME              (101)                /* name of the job (WindowTitle of LlPrintWithBoxStart()) (not page dependent) */
#define LS_OPTION_PRTNAME              (102)                /* printer name ("HP Laserjet 4L") */
#define LS_OPTION_PRTDEVICE            (103)                /* printer device ("PSCRIPT") */
#define LS_OPTION_PRTPORT              (104)                /* printer port ("LPT1:" or "\\server\printer") */
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
#define LS_PRINTFLAG_FIT               (0x00000001)        
#define LS_PRINTFLAG_STACKEDCOPIES     (0x00000002)         /* n times page1, n times page2, ... (else n times (page 1...x)) */
#define LS_PRINTFLAG_TRYPRINTERCOPIES  (0x00000004)         /* first try printer copies, then simulated ones... */
#define LS_PRINTFLAG_METER             (0x00000010)        
#define LS_PRINTFLAG_ABORTABLEMETER    (0x00000020)        
#define LS_PRINTFLAG_METERMASK         (0x00000070)         /* allows 7 styles of abort boxes... */
#define LS_VIEWERCONTROL_SET_HANDLE    (WM_USER+3)          /* lParam = HANDLE (NULL for RELEASE) */
#define LS_VIEWERCONTROL_GET_HANDLE    (WM_USER+4)          /* lParam = HANDLE (NULL for none) */
#define LS_VIEWERCONTROL_SET_FILENAME  (WM_USER+5)          /* lParam = LPCTSTR pszFilename (NULL for RELEASE), wParam = options */
#define LS_STGFILEOPEN_READONLY        (0x00000000)        
#define LS_STGFILEOPEN_READWRITE       (0x00000001)        
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
#define LS_VCITEM_SEARCH_PREV          (2)                 
#define LS_VCITEM_SEARCHFLAG_CASEINSENSITIVE (0x8000)            
#define LS_VCITEM_SAVE_AS_FILE         (3)                 
#define LS_VCITEM_SEND_AS_MAIL         (4)                 
#define LS_VCITEM_SEND_AS_FAX          (5)                 
#define LS_VCITEM_PRINT_ONE            (6)                 
#define LS_VCITEM_PRINT_ALL            (7)                 
#define LS_VCITEM_PAGENUMBER           (8)                 
#define LS_VCITEM_ZOOM                 (9)                 
#define LS_VIEWERCONTROL_GET_SEARCHSTATE (WM_USER+28)         /* returns TRUE if search in progress */
#define LS_VIEWERCONTROL_SEARCH        (WM_USER+29)         /* wParam = BOOL(bCaseSens), lParam=SearchText (NULL to stop) */
#define LS_VIEWERCONTROL_GET_ENABLED_SEARCHPREV (WM_USER+30)        
#define LS_VIEWERCONTROL_PRINT_CURRENT (WM_USER+31)         /* wParam = 0 (default printer), 1 (with printer selection) */
#define LS_VIEWERCONTROL_PRINT_ALL     (WM_USER+32)         /* wParam = 0 (default printer), 1 (with printer selection) */
#define LS_VIEWERCONTROL_PRINT_TO_FAX  (WM_USER+33)        
#define LS_VIEWERCONTROL_UPDATE_TOOLBAR (WM_USER+35)         /* if LS_OPTION_TOOLBAR is TRUE */
#define LS_VIEWERCONTROL_GET_TOOLBAR   (WM_USER+36)         /* if LS_OPTION_TOOLBAR is TRUE, returns window handle of toolbar */
#define LS_VIEWERCONTROL_SAVE_TO_FILE  (WM_USER+37)        
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
#define LS_VIEWERCONTROL_ADDTOOLBARITEM (WM_USER+47)        
#define LS_VIEWERCONTROL_INTERNAL_CHECKERRORLIST (WM_USER+48)        
#define LS_VIEWERCONTROL_NTFY_PAGELOADED (1)                  /* lParam = page# */
#define LS_VIEWERCONTROL_NTFY_UPDATETOOLBAR (2)                  /* called when control does NOT have an own toolbar */
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
#define LS_VIEWERCONTROL_NTFY_VIEWCHANGED (14)                 /* lParam = const scViewChangedInfo */
#define LS_VIEWERCONTROL_CMND_SAVEDATA (15)                 /* return: 0 = OK, -1 = failure, 1 = save in LL file too [event used only if AUTOSAVE is TRUE] */
#define LS_VIEWERCONTROL_NTFY_DATACHANGED (16)                
#define LS_MAILCONFIG_GLOBAL           (0x0001)            
#define LS_MAILCONFIG_USER             (0x0002)            
#define LS_MAILCONFIG_PROVIDER         (0x0004)            
#define LS_DIO_CHECKBOX                (0)                 
#define LS_DIO_PUSHBUTTON              (1)                 
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NONE (0x0000)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NEW_WINDOW (0x0001)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_NAVIGATION (0x0002)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_JAVA (0x0004)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_SCRIPTING (0x0008)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_ACTIVEX (0x0010)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_ONLINE (0x0020)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_BROWSERCONTEXTMENU (0x0040)            
#define LSMAILVIEW_HTMLRIGHT_ALLOW_PRINT (0x0080)            

#endif  /* #ifndef _LS11_CH */

