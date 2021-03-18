// Alaska dBase++ module constants and function definitions for LS11.DLL
//  (c) 1991,..,1999,2000,..,06,... combit GmbH, Konstanz, Germany 
//  [build of 2006-08-03 10:08:04]

// MODULE file to be included once in a project

#include "dll.ch"

/*--- variables needed for dynamic loading (templates allow fast access) ---*/

STATIC aLS11Vars[1]

#define hDll aLS11Vars[ThreadId(),1]
#define tplLlStgsysStorageOpen aLS11Vars[ThreadId(),2]
#define tplLlStgsysStorageClose aLS11Vars[ThreadId(),3]
#define tplLlStgsysGetAPIVersion aLS11Vars[ThreadId(),4]
#define tplLlStgsysGetFileVersion aLS11Vars[ThreadId(),5]
#define tplLlStgsysGetFilename aLS11Vars[ThreadId(),6]
#define tplLlStgsysGetJobCount aLS11Vars[ThreadId(),7]
#define tplLlStgsysSetJob aLS11Vars[ThreadId(),8]
#define tplLlStgsysGetJob aLS11Vars[ThreadId(),9]
#define tplLlStgsysGetPageCount aLS11Vars[ThreadId(),10]
#define tplLlStgsysGetJobOptionValue aLS11Vars[ThreadId(),11]
#define tplLlStgsysGetPageOptionValue aLS11Vars[ThreadId(),12]
#define tplLlStgsysGetPageOptionString aLS11Vars[ThreadId(),13]
#define tplLlStgsysSetPageOptionString aLS11Vars[ThreadId(),14]
#define tplLlStgsysAppend aLS11Vars[ThreadId(),15]
#define tplLlStgsysDeleteJob aLS11Vars[ThreadId(),16]
#define tplLlStgsysDeletePage aLS11Vars[ThreadId(),17]
#define tplLlStgsysGetPageMetafile aLS11Vars[ThreadId(),18]
#define tplLlStgsysGetPageMetafile16 aLS11Vars[ThreadId(),19]
#define tplLlStgsysDestroyMetafile aLS11Vars[ThreadId(),20]
#define tplLlStgsysDrawPage aLS11Vars[ThreadId(),21]
#define tplLlStgsysGetLastError aLS11Vars[ThreadId(),22]
#define tplLlStgsysDeleteFiles aLS11Vars[ThreadId(),23]
#define tplLlStgsysPrint aLS11Vars[ThreadId(),24]
#define tplLlStgsysStoragePrint aLS11Vars[ThreadId(),25]
#define tplLlStgsysGetPagePrinter aLS11Vars[ThreadId(),26]
#define tplLsSetDebug aLS11Vars[ThreadId(),27]
#define tplLsGetViewerControlClassName aLS11Vars[ThreadId(),28]
#define tplLsGetViewerControlDefaultMessage aLS11Vars[ThreadId(),29]
#define tplLsCreateViewerControlOverParent aLS11Vars[ThreadId(),30]
#define tplLlStgsysGetJobOptionStringEx aLS11Vars[ThreadId(),31]
#define tplLlStgsysSetJobOptionStringEx aLS11Vars[ThreadId(),32]
#define tplLsConversionJobOpen aLS11Vars[ThreadId(),33]
#define tplLsConversionJobClose aLS11Vars[ThreadId(),34]
#define tplLsConversionConfigurationDlg aLS11Vars[ThreadId(),35]
#define tplLsConversionSetOptionString aLS11Vars[ThreadId(),36]
#define tplLsConversionGetOptionString aLS11Vars[ThreadId(),37]
#define tplLsConversionConvertEMFToFile aLS11Vars[ThreadId(),38]
#define tplLsConversionConvertStgToFile aLS11Vars[ThreadId(),39]
#define tplLlStgsysStorageConvert aLS11Vars[ThreadId(),40]
#define tplLlStgsysConvert aLS11Vars[ThreadId(),41]
#define tplLsMailConfigurationDialog aLS11Vars[ThreadId(),42]
#define tplLsMailJobOpen aLS11Vars[ThreadId(),43]
#define tplLsMailJobClose aLS11Vars[ThreadId(),44]
#define tplLsMailSetOptionString aLS11Vars[ThreadId(),45]
#define tplLsMailGetOptionString aLS11Vars[ThreadId(),46]
#define tplLsMailSendFile aLS11Vars[ThreadId(),47]
#define tplLlStgsysStorageCreate aLS11Vars[ThreadId(),48]
#define tplLlStgsysAppendEMF aLS11Vars[ThreadId(),49]
#define tplLsProfileStart aLS11Vars[ThreadId(),50]
#define tplLsProfileEnd aLS11Vars[ThreadId(),51]
#define tplLsMailView aLS11Vars[ThreadId(),52]

PROCEDURE LS11LoadTemplates()
  tplLlStgsysStorageOpen = DllPrepareCall(hDll,DLL_STDCALL,1)
  tplLlStgsysStorageClose = DllPrepareCall(hDll,DLL_STDCALL,3)
  tplLlStgsysGetAPIVersion = DllPrepareCall(hDll,DLL_STDCALL,4)
  tplLlStgsysGetFileVersion = DllPrepareCall(hDll,DLL_STDCALL,5)
  tplLlStgsysGetFilename = DllPrepareCall(hDll,DLL_STDCALL,6)
  tplLlStgsysGetJobCount = DllPrepareCall(hDll,DLL_STDCALL,8)
  tplLlStgsysSetJob = DllPrepareCall(hDll,DLL_STDCALL,9)
  tplLlStgsysGetJob = DllPrepareCall(hDll,DLL_STDCALL,37)
  tplLlStgsysGetPageCount = DllPrepareCall(hDll,DLL_STDCALL,10)
  tplLlStgsysGetJobOptionValue = DllPrepareCall(hDll,DLL_STDCALL,11)
  tplLlStgsysGetPageOptionValue = DllPrepareCall(hDll,DLL_STDCALL,12)
  tplLlStgsysGetPageOptionString = DllPrepareCall(hDll,DLL_STDCALL,13)
  tplLlStgsysSetPageOptionString = DllPrepareCall(hDll,DLL_STDCALL,15)
  tplLlStgsysAppend = DllPrepareCall(hDll,DLL_STDCALL,17)
  tplLlStgsysDeleteJob = DllPrepareCall(hDll,DLL_STDCALL,18)
  tplLlStgsysDeletePage = DllPrepareCall(hDll,DLL_STDCALL,19)
  tplLlStgsysGetPageMetafile = DllPrepareCall(hDll,DLL_STDCALL,20)
  tplLlStgsysGetPageMetafile16 = DllPrepareCall(hDll,DLL_STDCALL,21)
  tplLlStgsysDestroyMetafile = DllPrepareCall(hDll,DLL_STDCALL,22)
  tplLlStgsysDrawPage = DllPrepareCall(hDll,DLL_STDCALL,23)
  tplLlStgsysGetLastError = DllPrepareCall(hDll,DLL_STDCALL,24)
  tplLlStgsysDeleteFiles = DllPrepareCall(hDll,DLL_STDCALL,25)
  tplLlStgsysPrint = DllPrepareCall(hDll,DLL_STDCALL,26)
  tplLlStgsysStoragePrint = DllPrepareCall(hDll,DLL_STDCALL,28)
  tplLlStgsysGetPagePrinter = DllPrepareCall(hDll,DLL_STDCALL,30)
  tplLsSetDebug = DllPrepareCall(hDll,DLL_STDCALL,32)
  tplLsGetViewerControlClassName = DllPrepareCall(hDll,DLL_STDCALL,33)
  tplLsGetViewerControlDefaultMessage = DllPrepareCall(hDll,DLL_STDCALL,35)
  tplLsCreateViewerControlOverParent = DllPrepareCall(hDll,DLL_STDCALL,36)
  tplLlStgsysGetJobOptionStringEx = DllPrepareCall(hDll,DLL_STDCALL,41)
  tplLlStgsysSetJobOptionStringEx = DllPrepareCall(hDll,DLL_STDCALL,43)
  tplLsConversionJobOpen = DllPrepareCall(hDll,DLL_STDCALL,45)
  tplLsConversionJobClose = DllPrepareCall(hDll,DLL_STDCALL,47)
  tplLsConversionConfigurationDlg = DllPrepareCall(hDll,DLL_STDCALL,52)
  tplLsConversionSetOptionString = DllPrepareCall(hDll,DLL_STDCALL,53)
  tplLsConversionGetOptionString = DllPrepareCall(hDll,DLL_STDCALL,55)
  tplLsConversionConvertEMFToFile = DllPrepareCall(hDll,DLL_STDCALL,57)
  tplLsConversionConvertStgToFile = DllPrepareCall(hDll,DLL_STDCALL,59)
  tplLlStgsysStorageConvert = DllPrepareCall(hDll,DLL_STDCALL,70)
  tplLlStgsysConvert = DllPrepareCall(hDll,DLL_STDCALL,72)
  tplLsMailConfigurationDialog = DllPrepareCall(hDll,DLL_STDCALL,61)
  tplLsMailJobOpen = DllPrepareCall(hDll,DLL_STDCALL,63)
  tplLsMailJobClose = DllPrepareCall(hDll,DLL_STDCALL,64)
  tplLsMailSetOptionString = DllPrepareCall(hDll,DLL_STDCALL,65)
  tplLsMailGetOptionString = DllPrepareCall(hDll,DLL_STDCALL,67)
  tplLsMailSendFile = DllPrepareCall(hDll,DLL_STDCALL,69)
  tplLlStgsysStorageCreate = DllPrepareCall(hDll,DLL_STDCALL,76)
  tplLlStgsysAppendEMF = DllPrepareCall(hDll,DLL_STDCALL,78)
  tplLsProfileStart = DllPrepareCall(hDll,DLL_STDCALL,79)
  tplLsProfileEnd = DllPrepareCall(hDll,DLL_STDCALL,81)
  tplLsMailView = DllPrepareCall(hDll,DLL_STDCALL,83)
RETURN

/*--- load and unload DLL automatically (or manually) ---*/

PROCEDURE LS11ModuleInit()
  LOCAL nId := ThreadID()

  IF Len(aLS11Vars) < nId
    ASize(aLS11Vars,nId)
  ENDIF
  aLS11Vars[nId] := { ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL, ;
     NIL ;
    }

  hDll = DllLoad("CMLS11.DLL")
  IF hDll == 0
    ? "CMLS11.DLL cannot be loaded"
   ELSE
    LS11LoadTemplates()
  ENDIF
RETURN

PROCEDURE LS11ModuleExit()
  DllUnLoad(hDll)
  aLS11Vars[ThreadID()] := NIL
RETURN

/*--- functions ---*/

FUNCTION LlStgsysStorageOpen(lpszFilename, pszTempPath, bReadOnly, bOneJobTranslation)
 RETURN DllExecuteCall(tplLlStgsysStorageOpen, @lpszFilename, @pszTempPath, bReadOnly, bOneJobTranslation)

PROCEDURE LlStgsysStorageClose(hStg)
 DllExecuteCall(tplLlStgsysStorageClose, hStg)
 RETURN

FUNCTION LlStgsysGetAPIVersion(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetAPIVersion, hStg)

FUNCTION LlStgsysGetFileVersion(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetFileVersion, hStg)

FUNCTION LlStgsysGetFilename(hStg, nJob, nFile, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlStgsysGetFilename, hStg, nJob, nFile, @pszBuffer, nBufSize)

FUNCTION LlStgsysGetJobCount(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetJobCount, hStg)

FUNCTION LlStgsysSetJob(hStg, nJob)
 RETURN DllExecuteCall(tplLlStgsysSetJob, hStg, nJob)

FUNCTION LlStgsysGetJob(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetJob, hStg)

FUNCTION LlStgsysGetPageCount(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetPageCount, hStg)

FUNCTION LlStgsysGetJobOptionValue(hStg, nOption)
 RETURN DllExecuteCall(tplLlStgsysGetJobOptionValue, hStg, nOption)

FUNCTION LlStgsysGetPageOptionValue(hStg, nPageIndex, nOption)
 RETURN DllExecuteCall(tplLlStgsysGetPageOptionValue, hStg, nPageIndex, nOption)

FUNCTION LlStgsysGetPageOptionString(hStg, nPageIndex, nOption, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlStgsysGetPageOptionString, hStg, nPageIndex, nOption, @pszBuffer, nBufSize)

FUNCTION LlStgsysSetPageOptionString(hStg, nPageIndex, nOption, pszBuffer)
 RETURN DllExecuteCall(tplLlStgsysSetPageOptionString, hStg, nPageIndex, nOption, @pszBuffer)

FUNCTION LlStgsysAppend(hStg, hStgToAppend)
 RETURN DllExecuteCall(tplLlStgsysAppend, hStg, hStgToAppend)

FUNCTION LlStgsysDeleteJob(hStg, nPageIndex)
 RETURN DllExecuteCall(tplLlStgsysDeleteJob, hStg, nPageIndex)

FUNCTION LlStgsysDeletePage(hStg, nPageIndex)
 RETURN DllExecuteCall(tplLlStgsysDeletePage, hStg, nPageIndex)

FUNCTION LlStgsysGetPageMetafile(hStg, nPageIndex)
 RETURN DllExecuteCall(tplLlStgsysGetPageMetafile, hStg, nPageIndex)

FUNCTION LlStgsysGetPageMetafile16(hStg, nPageIndex)
 RETURN DllExecuteCall(tplLlStgsysGetPageMetafile16, hStg, nPageIndex)

FUNCTION LlStgsysDestroyMetafile(hMF)
 RETURN DllExecuteCall(tplLlStgsysDestroyMetafile, hMF)

FUNCTION LlStgsysDrawPage(hStg, hDC, hPrnDC, bAskPrinter, pRC, nPageIndex, bFit, pReserved)
 RETURN DllExecuteCall(tplLlStgsysDrawPage, hStg, hDC, hPrnDC, bAskPrinter, @pRC, nPageIndex, bFit, pReserved)

FUNCTION LlStgsysGetLastError(hStg)
 RETURN DllExecuteCall(tplLlStgsysGetLastError, hStg)

FUNCTION LlStgsysDeleteFiles(hStg)
 RETURN DllExecuteCall(tplLlStgsysDeleteFiles, hStg)

FUNCTION LlStgsysPrint(hStg, pszPrinterName1, pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, pszMessage, hWndParent)
 RETURN DllExecuteCall(tplLlStgsysPrint, hStg, @pszPrinterName1, @pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, @pszMessage, hWndParent)

FUNCTION LlStgsysStoragePrint(lpszFilename, pszTempPath, pszPrinterName1, pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, pszMessage, hWndParent)
 RETURN DllExecuteCall(tplLlStgsysStoragePrint, @lpszFilename, @pszTempPath, @pszPrinterName1, @pszPrinterName2, nStartPageIndex, nEndPageIndex, nCopies, nFlags, @pszMessage, hWndParent)

FUNCTION LlStgsysGetPagePrinter(hStg, nPageIndex, pszDeviceName, nDeviceNameSize, phDevMode)
 RETURN DllExecuteCall(tplLlStgsysGetPagePrinter, hStg, nPageIndex, @pszDeviceName, nDeviceNameSize, @phDevMode)

PROCEDURE LsSetDebug(bOn)
 DllExecuteCall(tplLsSetDebug, bOn)
 RETURN

FUNCTION LsGetViewerControlClassName()
 RETURN DllExecuteCall(tplLsGetViewerControlClassName)

FUNCTION LsGetViewerControlDefaultMessage()
 RETURN DllExecuteCall(tplLsGetViewerControlDefaultMessage)

FUNCTION LsCreateViewerControlOverParent(hStg, hParentControl)
 RETURN DllExecuteCall(tplLsCreateViewerControlOverParent, hStg, hParentControl)

FUNCTION LlStgsysGetJobOptionStringEx(hStg, pszKey, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlStgsysGetJobOptionStringEx, hStg, @pszKey, @pszBuffer, nBufSize)

FUNCTION LlStgsysSetJobOptionStringEx(hStg, pszKey, pszBuffer)
 RETURN DllExecuteCall(tplLlStgsysSetJobOptionStringEx, hStg, @pszKey, @pszBuffer)

FUNCTION LsConversionJobOpen(hWndParent, nLanguage, pszFormat)
 RETURN DllExecuteCall(tplLsConversionJobOpen, hWndParent, nLanguage, @pszFormat)

FUNCTION LsConversionJobClose(hCnvJob)
 RETURN DllExecuteCall(tplLsConversionJobClose, hCnvJob)

FUNCTION LsConversionConfigurationDlg(hCnvJob, hWndParent)
 RETURN DllExecuteCall(tplLsConversionConfigurationDlg, hCnvJob, hWndParent)

FUNCTION LsConversionSetOptionString(hCnvJob, pszKey, pszData)
 RETURN DllExecuteCall(tplLsConversionSetOptionString, hCnvJob, @pszKey, @pszData)

FUNCTION LsConversionGetOptionString(hCnvJob, pszKey, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLsConversionGetOptionString, hCnvJob, @pszKey, @pszBuffer, nBufSize)

FUNCTION LsConversionConvertEMFToFile(hCnvJob, hEMF, pszFilename)
 RETURN DllExecuteCall(tplLsConversionConvertEMFToFile, hCnvJob, hEMF, @pszFilename)

FUNCTION LsConversionConvertStgToFile(hCnvJob, hStg, pszFilename)
 RETURN DllExecuteCall(tplLsConversionConvertStgToFile, hCnvJob, hStg, @pszFilename)

FUNCTION LlStgsysStorageConvert(pszStgFilename, pszDstFilename, pszFormat)
 RETURN DllExecuteCall(tplLlStgsysStorageConvert, @pszStgFilename, @pszDstFilename, @pszFormat)

FUNCTION LlStgsysConvert(hStg, pszDstFilename, pszFormat)
 RETURN DllExecuteCall(tplLlStgsysConvert, hStg, @pszDstFilename, @pszFormat)

FUNCTION LsMailConfigurationDialog(hWndParent, pszSubkey, nFlags, nLanguage)
 RETURN DllExecuteCall(tplLsMailConfigurationDialog, hWndParent, @pszSubkey, nFlags, nLanguage)

FUNCTION LsMailJobOpen(nLanguage)
 RETURN DllExecuteCall(tplLsMailJobOpen, nLanguage)

FUNCTION LsMailJobClose(hJob)
 RETURN DllExecuteCall(tplLsMailJobClose, hJob)

FUNCTION LsMailSetOptionString(hJob, pszKey, pszValue)
 RETURN DllExecuteCall(tplLsMailSetOptionString, hJob, @pszKey, @pszValue)

FUNCTION LsMailGetOptionString(hJob, pszKey, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLsMailGetOptionString, hJob, @pszKey, @pszBuffer, nBufSize)

FUNCTION LsMailSendFile(hJob, hWndParent)
 RETURN DllExecuteCall(tplLsMailSendFile, hJob, hWndParent)

FUNCTION LlStgsysStorageCreate(lpszFilename, pszTempPath, hRefDC, prcArea, bPhysicalPage)
 RETURN DllExecuteCall(tplLlStgsysStorageCreate, @lpszFilename, @pszTempPath, hRefDC, @prcArea, bPhysicalPage)

FUNCTION LlStgsysAppendEMF(hStg, hEMFToAppend, hRefDC, prcArea, bPhysicalPage)
 RETURN DllExecuteCall(tplLlStgsysAppendEMF, hStg, hEMFToAppend, hRefDC, @prcArea, bPhysicalPage)

FUNCTION LsProfileStart(hThread, pszDescr, pszFilename, nTicksMS)
 RETURN DllExecuteCall(tplLsProfileStart, hThread, @pszDescr, @pszFilename, nTicksMS)

PROCEDURE LsProfileEnd(hThread)
 DllExecuteCall(tplLsProfileEnd, hThread)
 RETURN

FUNCTION LsMailView(hWndParent, pszMailFile, nRights, nLanguage)
 RETURN DllExecuteCall(tplLsMailView, hWndParent, @pszMailFile, nRights, nLanguage)



