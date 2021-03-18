// Alaska Software Xbase++ module constants and function definitions for LS23.DLL
//  (c) combit GmbH
//  [build of 2018-01-22 09:01:15]

// MODULE file to be included once in a project

#include "dll.ch"

STATIC hDll		   := 0
STATIC nDLLLoadCount := 0

//
// Two commands for LL_FUNCTION and procedure calls. The difference is
// the return value only. A call will silently ignore the fact that
// the library failed getting loaded. For each function/procedure
// a template is created once and then reused for the next call.
// The command executes the call into the library with DLL_STDCALL
// and an ordinal. In case the functions are properly exported from
// the library then we call cFunctionName (use <FUNC>).
//

#command  LL_FUNCTION <FUNC>([<x,...>]) ORDINAL <nOrdinal> =>      ;
FUNCTION <FUNC>([<x>])                                             ;;
  STATIC cTemplate := NIL                                          ;;
  LOCAL xRet                                                       ;;
  IF hDll == 0													 ;;
    RETURN(NIL)                                                    ;;
  ENDIF                                                            ;;
  IF cTemplate==NIL                                                ;;
    cTemplate := DllPrepareCall( hDll, DLL_STDCALL, <nOrdinal> ) ;;
  ENDIF                                                            ;;
  xRet := DllExecuteCall(cTemplate[,<x>])                          ;;
RETURN xRet

#command  LL_PROCEDURE <FUNC>([<x,...>]) ORDINAL <nOrdinal> =>     ;
FUNCTION <FUNC>([<x>])                                             ;;
  STATIC cTemplate := NIL                                          ;;
  IF hDll == 0                                                     ;;
    RETURN(NIL)                                                    ;;
  ENDIF                                                            ;;
  IF cTemplate==NIL                                                ;;
    cTemplate := DllPrepareCall( hDll, DLL_STDCALL, <nOrdinal> ) ;;
  ENDIF                                                            ;;
  DllExecuteCall(cTemplate[,<x>])                                  ;;
RETURN(NIL)

//
// Load the LL library dynamically.
// Raise an error on failure -> Can not find/load LL library.
// Call this routine once at application startup or ...
// call LLModuleInit() before and LLModuleExit() after the print job
// to load/unload the DLL with each print job.
//
FUNCTION LS23ModuleInit()
  IF hDll == 0
    hDll = DllLoad("CMLS23.DLL")
    IF hDll == 0
      // Handle the error case here
      // Runtime error with semantic: Can not find DLL
    ELSE
      nDLLLoadCount++
    ENDIF
  ENDIF
RETURN (hDll # 0)

//
// Unload the library.
//
PROCEDURE LS23ModuleExit()
  nDLLLoadCount--
  IF nDLLLoadCount <= 0 .AND. ;
      .NOT. hDll==0
    DllUnload( hDll )
    hDll        := 0
    nDLLLoadCount := 0
  ENDIF
RETURN

//
// These lines are preprocessed into Xbase++ functions,
// to be called as: LlJobOpen(nLanguage)
//

LL_FUNCTION LlStgsysStorageOpen(@lpszFilename, @pszTempPath, bReadOnly, bOneJobTranslation) ORDINAL 1
LL_PROCEDURE LlStgsysStorageClose(hStg) ORDINAL 3
LL_FUNCTION LlStgsysGetAPIVersion(hStg) ORDINAL 4
LL_FUNCTION LlStgsysGetFileVersion(hStg) ORDINAL 5
LL_FUNCTION LlStgsysGetFilename(hStg, nJob, nFile, @pszBuffer, nBufSize) ORDINAL 6
LL_FUNCTION LlStgsysGetJobCount(hStg) ORDINAL 8
LL_FUNCTION LlStgsysSetJob(hStg, nJob) ORDINAL 9
LL_FUNCTION LlStgsysGetJob(hStg) ORDINAL 37
LL_FUNCTION LlStgsysGetPageCount(hStg) ORDINAL 10
LL_FUNCTION LlStgsysGetJobOptionValue(hStg, nOption) ORDINAL 11
LL_FUNCTION LlStgsysGetPageOptionValue(hStg, nPageIndex, nOption) ORDINAL 12
LL_FUNCTION LlStgsysGetPageOptionString(hStg, nPageIndex, nOption, @pszBuffer, nBufSize) ORDINAL 13
LL_FUNCTION LlStgsysSetPageOptionString(hStg, nPageIndex, nOption, @pszBuffer) ORDINAL 15
LL_FUNCTION LlStgsysAppend(hStg, hStgToAppend) ORDINAL 17
LL_FUNCTION LlStgsysDeleteJob(hStg, nPageIndex) ORDINAL 18
LL_FUNCTION LlStgsysDeletePage(hStg, nPageIndex) ORDINAL 19
LL_FUNCTION LlStgsysGetPageMetafile(hStg, nPageIndex) ORDINAL 20
LL_FUNCTION LlStgsysDestroyMetafile(hMF) ORDINAL 22
LL_FUNCTION LlStgsysDrawPage(hStg, hDC, hPrnDC, bAskPrinter, @pRC, nPageIndex, bFit, pReserved) ORDINAL 23
LL_FUNCTION LlStgsysGetLastError(hStg) ORDINAL 24
LL_FUNCTION LlStgsysDeleteFiles(hStg) ORDINAL 25
LL_FUNCTION LlStgsysPrint(hStg, @pszPrinterName1, @pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, @pszMessage, hWndParent) ORDINAL 26
LL_FUNCTION LlStgsysStoragePrint(@lpszFilename, @pszTempPath, @pszPrinterName1, @pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, @pszMessage, hWndParent) ORDINAL 28
LL_FUNCTION LlStgsysGetPagePrinter(hStg, nPageIndex, @pszDeviceName, nDeviceNameSize, @phDevMode) ORDINAL 30
LL_PROCEDURE LsSetDebug(bOn) ORDINAL 32
LL_FUNCTION LsGetViewerControlClassName() ORDINAL 33
LL_FUNCTION LsGetViewerControlDefaultMessage() ORDINAL 35
LL_FUNCTION LsCreateViewerControlOverParent(hStg, hParentControl) ORDINAL 36
LL_FUNCTION LlStgsysGetJobOptionStringEx(hStg, @pszKey, @pszBuffer, nBufSize) ORDINAL 41
LL_FUNCTION LlStgsysSetJobOptionStringEx(hStg, @pszKey, @pszBuffer) ORDINAL 43
LL_FUNCTION LsConversionJobOpen(hWndParent, nLanguage, @pszFormat) ORDINAL 45
LL_FUNCTION LsConversionJobClose(hCnvJob) ORDINAL 47
LL_FUNCTION LsConversionConfigurationDlg(hCnvJob, hWndParent) ORDINAL 52
LL_FUNCTION LsConversionSetOptionString(hCnvJob, @pszKey, @pszData) ORDINAL 53
LL_FUNCTION LsConversionGetOptionString(hCnvJob, @pszKey, @pszBuffer, nBufSize) ORDINAL 55
LL_FUNCTION LsConversionConvertEMFToFile(hCnvJob, hEMF, @pszFilename) ORDINAL 57
LL_FUNCTION LsConversionConvertStgToFile(hCnvJob, hStg, @pszFilename) ORDINAL 59
LL_FUNCTION LlStgsysStorageConvert(@pszStgFilename, @pszDstFilename, @pszFormat) ORDINAL 70
LL_FUNCTION LlStgsysConvert(hStg, @pszDstFilename, @pszFormat) ORDINAL 72
LL_FUNCTION LsMailConfigurationDialog(hWndParent, @pszSubkey, nFlags, nLanguage) ORDINAL 61
LL_FUNCTION LsMailJobOpen(nLanguage) ORDINAL 63
LL_FUNCTION LsMailJobClose(hJob) ORDINAL 64
LL_FUNCTION LsMailSetOptionString(hJob, @pszKey, @pszValue) ORDINAL 65
LL_FUNCTION LsMailGetOptionString(hJob, @pszKey, @pszBuffer, nBufSize) ORDINAL 67
LL_FUNCTION LsMailSendFile(hJob, hWndParent) ORDINAL 69
LL_FUNCTION LlStgsysStorageCreate(@lpszFilename, @pszTempPath, hRefDC, @prcArea, bPhysicalPage) ORDINAL 76
LL_FUNCTION LlStgsysAppendEMF(hStg, hEMFToAppend, hRefDC, @prcArea, bPhysicalPage) ORDINAL 78
LL_FUNCTION LsProfileStart(hThread, @pszDescr, @pszFilename, nTicksMS) ORDINAL 79
LL_PROCEDURE LsProfileEnd(hThread) ORDINAL 81
LL_FUNCTION LsMailView(hWndParent, @pszMailFile, nRights, nLanguage) ORDINAL 83
LL_FUNCTION LsInternalCreateViewerControlOverParent13(hParentControl, nFlags) ORDINAL 87
LL_FUNCTION LsInternalGetViewerControlFromParent13(hParentControl) ORDINAL 88
LL_PROCEDURE LsSetDlgboxMode(nMode) ORDINAL 89
LL_FUNCTION LsGetDlgboxMode() ORDINAL 90
LL_FUNCTION LsGetDebug() ORDINAL 94
LL_FUNCTION LlStgsysSetUILanguage(hStg, nCMBTLanguage) ORDINAL 105


