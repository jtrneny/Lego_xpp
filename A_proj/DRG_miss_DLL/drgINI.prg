//////////////////////////////////////////////////////////////////////
//
//  drgINI.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "xbp.ch"
#include "drg.ch"

//#define  _DRGDEMO
#ifdef  _DRGDEMO
  STATIC theMsg :=  'Vaše aplikace ASYSTEM++ bìží v režimu demo.;;' + ;
                    '2005(c) Copyright MISS Software, s.r.o. Všechna práva vyhrazena.;;' + ;
                    'Další informace mùžete získat na www.software.missuhcz'
#endif

CLASS drgINI
  EXPORTED:
* Common directories
  VAR     dir_App
  VAR     dir_DATAroot
  VAR     dir_DATA
  VAR     dir_RSRC, dir_RSRCfi
  VAR     dir_WORK
  VAR     dir_SYSTEM
  VAR     dir_USER
  VAR     dir_USERfi
  VAR     dir_USERfitm
  VAR     add_FILE

* Application
  VAR     appName
  VAR     appICON

* NLS lang
  VAR     nlsDRGorg
  VAR     nlsDRGloc
  VAR     nlsAPPorg
  VAR     nlsAPPloc
* NLS data
  VAR     nlsCP_DATA
  VAR     nlsCP_APP
  VAR     nlsCP_PRINT
*
  VAR     defFontSize
  VAR     defFontFamily
  VAR     defTextType
  VAR     defTextBGND
  VAR     defDlgBorder
  VAR     fontW
  VAR     fontH
  VAR     iconBarType

* MISC
  VAR     escIsClose
  VAR     stdErrorHandler

* Standard dialog objects
  VAR     stdIconBar
  VAR     stdDialogMenu
  VAR     stdMessageBar
  VAR     stdDialogFind
  VAR     stdDialogSort
  VAR     stdDialogFilter
  VAR     stdDialogAbout
  VAR     stdDialogDocs
  VAR     stdDialogDataCom
  VAR     stdDialogSwHelp


* Printer definitions
  VAR     printPageLen
  VAR     printSignRight
  VAR     printCanPreview
  VAR     printerList
  VAR     printerDevice
  VAR     printerType
  VAR     printerName
  VAR     printerWinFont
  VAR     stdPrinterInit

* Controller
  VAR     recycleDeleted

* Mzdy
  VAR     l_blockObdMzdy       // blokování modifikace mezd po vygenerování mzdZavhd defalut .t.

* Definice typu používaného ADS serveru
  VAR     ads_SERVER_TYPE   // mùže nabývat následujících hodnot ADS_LOCAL_SERVER,ADS_REMOTE_SERVER,ADS_AIS_SERVER

  METHOD  init

ENDCLASS

*****************************************************************************
* Init drgINI properties
*****************************************************************************
METHOD drgINI:init()
  ::dir_App      := parseFileName( AppName(.T.),3) + '\'
  ::dir_SYSTEM   := ''             // SYSTEM files directory
  ::dir_USER     := ''             // USERS files directory
  ::dir_DATAroot := ''             // DATA files directory root
  ::dir_DATA     := ''             // DATA files directory
  ::dir_RSRC     := ''             // DRG reSources directory
  ::dir_RSRCfi   := ''             // DRG reSources directory pro firmu
  ::dir_WORK     := ''             // WORK DATA files location directory
  ::dir_USERfi   := ''             // USER kmenový tj. bez vazby na firmu
  ::dir_USERfitm := ''             // USER tmp files directory
  ::add_FILE     := ''             // ADD file

  ::nlsDRGorg   := 'EN'         // DRG runtime original language
  ::nlsDRGloc   := 'EN'         // DRG runtime local language
  ::nlsAPPorg   := 'EN'         // application original language
  ::nlsAPPloc   := 'EN'         // application local language

  ::nlsCP_DATA  := 0            // CodePage data saved to database
  ::nlsCP_APP   := 0            // CodePage data displayed on screen
  ::nlsCP_PRINT := 0            // CodePage data printed to printer

* Default values for dialog
  ::defFontSize   := 8          // defaults to CPI 8
  ::defFontFamily := 'Tahoma'
  ::defTextType   := XBPSTATIC_TEXT_LEFT
  ::defTextBGND   := XBPSTATIC_TYPE_RAISEDBOX
*  ::defDlgBorder  := XBPDLG_SIZEBORDER
* ::defDlgBorder  := XBPDLG_DLGBORDER
  ::defDlgBorder  := XBPDLG_RAISEDBORDERTHIN

* Font height and width. They are recalculated everytime font changes in drgPP.
  ::fontW := 7
  ::fontH := 21
  ::iconBarType := drgICONBAR_OLD
* Pressing escape is same as selecting CLOSE
  ::escIsClose    := .F.
  ::stdErrorHandler  := 'drgStandardEH'

  ::appName          := 'ASYSTEM++'
  ::appICON          := 1

  ::stdIconBar       := 'drgStdIconBar'
  ::stdDialogMenu    := 'drgStdDialogMenu'
  ::stdMessageBar    := 'drgStdMessageBar'
  ::stdDialogFind    := 'drgFindDialog'
  ::stdDialogSort    := 'SYS_fltusers_SCR'
  ::stdDialogFilter  := 'SYS_fltusers_SCR'
  ::stdDialogDocs    := 'SYS_VazDokum_SCR'
  ::stdDialogDataCom := 'SYS_selectkom_CRD'
  ::stdDialogSwHelp  := 'SYS_pripominky_CRD'
  ::stdDialogAbout   := 'SYS_about_INF'


* Printer related settings
  ::printPageLen    := 72      // printer page length in lines
  ::printSignRight  := .F.     // position of - sign on printer output
  ::printerList     := {}
  ::printerDevice   := ::dir_WORK + 'OUT.PRN'
  ::printerType     := 'Windows'
  ::printerName     := ''
  ::stdPrinterInit  := '_drgStdPrinterInit'
  ::printerWinFont  := 'Courier New'
*
  ::recycleDeleted  := .F.

  ::l_blockObdMzdy  := .T.

* Type ADS server
  ::ads_SERVER_TYPE := 'ADS_LOCAL_SERVER'

*  PUBLIC CRLF    := Chr(13) + Chr(10) // CRLF sequence
*  PUBLIC ESC     := Chr(27)
*  PUBLIC TAB     := Chr(9)

#ifdef  _DRGDEMO
  MsgBox(STRTRAN(theMsg,';',CRLF), XBPMB_INFORMATION)
#endif


RETURN self