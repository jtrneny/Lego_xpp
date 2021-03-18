// Alaska Software Xbase++ module constants and function definitions for LL20.DLL
//  (c) combit GmbH
//  [build of 2014-10-15 11:10:42]

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
FUNCTION LL20ModuleInit()
  IF hDll == 0
    hDll = DllLoad("CMLL20.DLL")
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
PROCEDURE LL20ModuleExit()
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

LL_FUNCTION LlJobOpen(nLanguage) ORDINAL 10
LL_FUNCTION LlJobOpenLCID(nLCID) ORDINAL 12
LL_PROCEDURE LlJobClose(hLlJob) ORDINAL 11
LL_PROCEDURE LlSetDebug(nOnOff) ORDINAL 13
LL_FUNCTION LlGetVersion(nCmd) ORDINAL 14
LL_FUNCTION LlGetNotificationMessage(hLlJob) ORDINAL 15
LL_FUNCTION LlSetNotificationMessage(hLlJob, nMessage) ORDINAL 16
LL_FUNCTION LlDefineField(hLlJob, @pszVarName, @lpbufContents) ORDINAL 18
LL_FUNCTION LlDefineFieldExt(hLlJob, @pszVarName, @lpbufContents, lPara, lpPtr) ORDINAL 19
LL_FUNCTION LlDefineFieldExtHandle(hLlJob, @pszVarName, hContents, lPara, lpPtr) ORDINAL 20
LL_PROCEDURE LlDefineFieldStart(hLlJob) ORDINAL 21
LL_FUNCTION LlDefineVariable(hLlJob, @pszVarName, @lpbufContents) ORDINAL 22
LL_FUNCTION LlDefineVariableExt(hLlJob, @pszVarName, @lpbufContents, lPara, lpPtr) ORDINAL 23
LL_FUNCTION LlDefineVariableExtHandle(hLlJob, @pszVarName, hContents, lPara, lpPtr) ORDINAL 24
LL_FUNCTION LlDefineVariableName(hLlJob, @pszVarName) ORDINAL 25
LL_PROCEDURE LlDefineVariableStart(hLlJob) ORDINAL 26
LL_FUNCTION LlDefineSumVariable(hLlJob, @pszVarName, @lpbufContents) ORDINAL 27
LL_FUNCTION LlDefineLayout(hLlJob, hWnd, @pszTitle, nObjType, @pszObjName) ORDINAL 28
LL_FUNCTION LlDlgEditLine(hLlJob, hWnd, @lpBuf, nBufSize) ORDINAL 29
LL_FUNCTION LlDlgEditLineEx(hLlJob, hWnd, @pszBuffer, nBufSize, nParaTypes, @pszTitle, bTable, pvReserved) ORDINAL 30
LL_FUNCTION LlPreviewSetTempPath(hLlJob, @pszPath) ORDINAL 31
LL_FUNCTION LlPreviewDeleteFiles(hLlJob, @pszObjName, @pszPath) ORDINAL 32
LL_FUNCTION LlPreviewDisplay(hLlJob, @pszObjName, @pszPath, Wnd) ORDINAL 33
LL_FUNCTION LlPreviewDisplayEx(hLlJob, @pszObjName, @pszPath, Wnd, nOptions, pOptions) ORDINAL 34
LL_FUNCTION LlPrint(hLlJob) ORDINAL 35
LL_FUNCTION LlPrintAbort(hLlJob) ORDINAL 36
LL_FUNCTION LlPrintCheckLineFit(hLlJob) ORDINAL 37
LL_FUNCTION LlPrintEnd(hLlJob, nPages) ORDINAL 38
LL_FUNCTION LlPrintFields(hLlJob) ORDINAL 39
LL_FUNCTION LlPrintFieldsEnd(hLlJob) ORDINAL 40
LL_FUNCTION LlPrintGetCurrentPage(hLlJob) ORDINAL 41
LL_FUNCTION LlPrintGetItemsPerPage(hLlJob) ORDINAL 42
LL_FUNCTION LlPrintGetItemsPerTable(hLlJob) ORDINAL 43
LL_FUNCTION LlPrintGetRemainingItemsPerTable(hLlJob, @pszField) ORDINAL 44
LL_FUNCTION LlPrintGetRemItemsPerTable(hLlJob, @pszField) ORDINAL 45
LL_FUNCTION LlPrintGetOption(hLlJob, nIndex) ORDINAL 46
LL_FUNCTION LlPrintGetPrinterInfo(hLlJob, @pszPrn, nPrnLen, @pszPort, nPortLen) ORDINAL 47
LL_FUNCTION LlPrintOptionsDialog(hLlJob, hWnd, @pszText) ORDINAL 48
LL_FUNCTION LlPrintSelectOffsetEx(hLlJob, hWnd) ORDINAL 49
LL_FUNCTION LlPrintSetBoxText(hLlJob, @szText, nPercentage) ORDINAL 50
LL_FUNCTION LlPrintSetOption(hLlJob, nIndex, nValue) ORDINAL 51
LL_FUNCTION LlPrintUpdateBox(hLlJob) ORDINAL 52
LL_FUNCTION LlPrintStart(hLlJob, nObjType, @pszObjName, nPrintOptions, nReserved) ORDINAL 53
LL_FUNCTION LlPrintWithBoxStart(hLlJob, nObjType, @pszObjName, nPrintOptions, nBoxType, hWnd, @pszTitle) ORDINAL 54
LL_FUNCTION LlPrinterSetup(hLlJob, hWnd, nObjType, @pszObjName) ORDINAL 55
LL_FUNCTION LlSelectFileDlgTitleEx(hLlJob, hWnd, @pszTitle, nObjType, @pszObjName, nBufSize, pReserved) ORDINAL 56
LL_PROCEDURE LlSetDlgboxMode(nMode) ORDINAL 57
LL_FUNCTION LlGetDlgboxMode() ORDINAL 58
LL_FUNCTION LlExprParse(hLlJob, @lpExprText, bIncludeFields) ORDINAL 59
LL_FUNCTION LlExprType(hLlJob, lpExpr) ORDINAL 60
LL_PROCEDURE LlExprError(hLlJob, @pszBuf, nBufSize) ORDINAL 61
LL_PROCEDURE LlExprFree(hLlJob, lpExpr) ORDINAL 62
LL_FUNCTION LlExprEvaluate(hLlJob, lpExpr, @pszBuf, nBufSize) ORDINAL 63
LL_FUNCTION LlExprGetUsedVars(hLlJob, lpExpr, @pszBuffer, nBufSize) ORDINAL 162
LL_FUNCTION LlSetOption(hLlJob, nMode, nValue) ORDINAL 64
LL_FUNCTION LlGetOption(hLlJob, nMode) ORDINAL 65
LL_FUNCTION LlSetOptionString(hLlJob, nIndex, @pszBuffer) ORDINAL 66
LL_FUNCTION LlGetOptionString(hLlJob, nIndex, @pszBuffer, nBufSize) ORDINAL 67
LL_FUNCTION LlPrintSetOptionString(hLlJob, nIndex, @pszBuffer) ORDINAL 68
LL_FUNCTION LlPrintGetOptionString(hLlJob, nIndex, @pszBuffer, nBufSize) ORDINAL 69
LL_FUNCTION LlDesignerProhibitAction(hLlJob, nMenuID) ORDINAL 70
LL_FUNCTION LlDesignerProhibitFunction(hLlJob, @pszFunction) ORDINAL 1
LL_FUNCTION LlPrintEnableObject(hLlJob, @pszObjectName, bEnable) ORDINAL 71
LL_FUNCTION LlSetFileExtensions(hLlJob, nObjType, @pszObjectExt, @pszPrinterExt, @pszSketchExt) ORDINAL 72
LL_FUNCTION LlPrintGetTextCharsPrinted(hLlJob, @pszObjectName) ORDINAL 73
LL_FUNCTION LlPrintGetFieldCharsPrinted(hLlJob, @pszObjectName, @pszField) ORDINAL 74
LL_FUNCTION LlPrintIsVariableUsed(hLlJob, @pszVarName) ORDINAL 75
LL_FUNCTION LlPrintIsFieldUsed(hLlJob, @pszFieldName) ORDINAL 76
LL_FUNCTION LlPrintOptionsDialogTitle(hLlJob, hWnd, @pszTitle, @pszText) ORDINAL 77
LL_FUNCTION LlSetPrinterToDefault(hLlJob, nObjType, @pszObjName) ORDINAL 78
LL_FUNCTION LlDefineSortOrderStart(hLlJob) ORDINAL 79
LL_FUNCTION LlDefineSortOrder(hLlJob, @pszIdentifier, @pszText) ORDINAL 80
LL_FUNCTION LlPrintGetSortOrder(hLlJob, @pszBuffer, nBufSize) ORDINAL 81
LL_FUNCTION LlDefineGrouping(hLlJob, @pszSortorder, @pszIdentifier, @pszText) ORDINAL 82
LL_FUNCTION LlPrintGetGrouping(hLlJob, @pszBuffer, nBufSize) ORDINAL 83
LL_FUNCTION LlAddCtlSupport(hWnd, nFlags, @pszInifile) ORDINAL 84
LL_FUNCTION LlPrintBeginGroup(hLlJob, lParam, lpParam) ORDINAL 85
LL_FUNCTION LlPrintEndGroup(hLlJob, lParam, lpParam) ORDINAL 86
LL_FUNCTION LlPrintGroupLine(hLlJob, lParam, lpParam) ORDINAL 87
LL_FUNCTION LlPrintGroupHeader(hLlJob, lParam) ORDINAL 88
LL_FUNCTION LlPrintGetFilterExpression(hLlJob, @pszBuffer, nBufSize) ORDINAL 89
LL_FUNCTION LlPrintWillMatchFilter(hLlJob) ORDINAL 90
LL_FUNCTION LlPrintDidMatchFilter(hLlJob) ORDINAL 91
LL_FUNCTION LlGetFieldContents(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 93
LL_FUNCTION LlGetVariableContents(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 92
LL_FUNCTION LlGetSumVariableContents(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 94
LL_FUNCTION LlGetUserVariableContents(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 95
LL_FUNCTION LlGetVariableType(hLlJob, @pszName) ORDINAL 96
LL_FUNCTION LlGetFieldType(hLlJob, @pszName) ORDINAL 97
LL_FUNCTION LlSetPrinterDefaultsDir(hLlJob, @pszDir) ORDINAL 200
LL_FUNCTION LlCreateSketch(hLlJob, nObjType, @lpszObjName) ORDINAL 201
LL_FUNCTION LlViewerProhibitAction(hLlJob, nMenuID) ORDINAL 202
LL_FUNCTION LlPrintCopyPrinterConfiguration(hLlJob, @lpszFilename, nFunction) ORDINAL 203
LL_FUNCTION LlSetPrinterInPrinterFile(hLlJob, nObjType, @pszObjName, nPrinterIndex, @pszPrinter, pDevMode) ORDINAL 204
LL_FUNCTION LlRTFCreateObject(hLlJob) ORDINAL 228
LL_FUNCTION LlRTFDeleteObject(hLlJob, hRTF) ORDINAL 229
LL_FUNCTION LlRTFSetText(hLlJob, hRTF, @pszText) ORDINAL 230
LL_FUNCTION LlRTFGetTextLength(hLlJob, hRTF, nFlags) ORDINAL 231
LL_FUNCTION LlRTFGetText(hLlJob, hRTF, nFlags, @pszBuffer, nBufSize) ORDINAL 232
LL_FUNCTION LlRTFEditObject(hLlJob, hRTF, hWnd, hPrnDC, nProjectType, bModal) ORDINAL 233
LL_FUNCTION LlRTFCopyToClipboard(hLlJob, hRTF) ORDINAL 234
LL_FUNCTION LlRTFDisplay(hLlJob, hRTF, hDC, @pRC, bRestart, @pnState) ORDINAL 235
LL_FUNCTION LlRTFEditorProhibitAction(hLlJob, hRTF, nControlID) ORDINAL 109
LL_FUNCTION LlRTFEditorInvokeAction(hLlJob, hRTF, nControlID) ORDINAL 117
LL_PROCEDURE LlDebugOutput(nIndent, @pszText) ORDINAL 240
LL_FUNCTION LlEnumGetFirstVar(hLlJob, nFlags) ORDINAL 241
LL_FUNCTION LlEnumGetFirstField(hLlJob, nFlags) ORDINAL 242
LL_FUNCTION LlEnumGetNextEntry(hLlJob, nPos, nFlags) ORDINAL 243
LL_FUNCTION LlEnumGetEntry(hLlJob, nPos, @pszNameBuf, nNameBufSize, @pszContBuf, nContBufSize, @pHandle, @pType) ORDINAL 244
LL_FUNCTION LlPrintResetObjectStates(hLlJob) ORDINAL 245
LL_FUNCTION LlXSetParameter(hLlJob, nExtensionType, @pszExtensionName, @pszKey, @pszValue) ORDINAL 246
LL_FUNCTION LlXGetParameter(hLlJob, nExtensionType, @pszExtensionName, @pszKey, @pszBuffer, nBufSize) ORDINAL 247
LL_FUNCTION LlPrintResetProjectState(hJob) ORDINAL 248
LL_PROCEDURE LlDefineChartFieldStart(hLlJob) ORDINAL 2
LL_FUNCTION LlDefineChartFieldExt(hLlJob, @pszVarName, @pszContents, lPara, lpPtr) ORDINAL 3
LL_FUNCTION LlPrintDeclareChartRow(hLlJob, nFlags) ORDINAL 4
LL_FUNCTION LlPrintGetChartObjectCount(hLlJob, nType) ORDINAL 6
LL_FUNCTION LlPrintIsChartFieldUsed(hLlJob, @pszFieldName) ORDINAL 5
LL_FUNCTION LlGetChartFieldContents(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 8
LL_FUNCTION LlEnumGetFirstChartField(hLlJob, nFlags) ORDINAL 9
LL_FUNCTION LlGetPrinterFromPrinterFile(hJob, nObjType, @pszObjectName, nPrinter, @pszPrinter, @pnPrinterBufSize, pDevMode, @pnDevModeBufSize) ORDINAL 98
LL_FUNCTION LlPrintGetRemainingSpacePerTable(hLlJob, @pszField, nDimension) ORDINAL 102
LL_FUNCTION LlSetDefaultProjectParameter(hLlJob, @pszParameter, @pszValue, nFlags) ORDINAL 108
LL_FUNCTION LlGetDefaultProjectParameter(hLlJob, @pszParameter, @pszBuffer, nBufSize, @pnFlags) ORDINAL 110
LL_FUNCTION LlPrintSetProjectParameter(hLlJob, @pszParameter, @pszValue, nFlags) ORDINAL 113
LL_FUNCTION LlPrintGetProjectParameter(hLlJob, @pszParameter, bEvaluated, @pszBuffer, nBufSize, @pnFlags) ORDINAL 114
LL_FUNCTION LlExprContainsVariable(hLlJob, hExpr, @pszVariable) ORDINAL 7
LL_FUNCTION LlExprIsConstant(hLlJob, hExpr) ORDINAL 116
LL_FUNCTION LlProfileStart(hThread, @pszDescr, @pszFilename, nTicksMS) ORDINAL 136
LL_PROCEDURE LlProfileEnd(hThread) ORDINAL 137
LL_FUNCTION LlDbAddTable(hJob, @pszTableID, @pszDisplayName) ORDINAL 139
LL_FUNCTION LlDbAddTableRelation(hJob, @pszTableID, @pszParentTableID, @pszRelationID, @pszRelationDisplayName) ORDINAL 140
LL_FUNCTION LlDbAddTableSortOrder(hJob, @pszTableID, @pszSortOrderID, @pszSortOrderDisplayName) ORDINAL 141
LL_FUNCTION LlPrintDbGetCurrentTable(hJob, @pszTableID, nTableIDLength, bCompletePath) ORDINAL 142
LL_FUNCTION LlPrintDbGetCurrentTableRelation(hJob, @pszRelationID, nRelationIDLength) ORDINAL 143
LL_FUNCTION LlPrintDbGetCurrentTableSortOrder(hJob, @pszSortOrderID, nSortOrderIDLength) ORDINAL 146
LL_FUNCTION LlDbDumpStructure(hJob) ORDINAL 149
LL_FUNCTION LlPrintDbGetRootTableCount(hJob) ORDINAL 151
LL_FUNCTION LlDbSetMasterTable(hJob, @pszTableID) ORDINAL 152
LL_FUNCTION LlDbGetMasterTable(hJob, @pszBuffer, nBufSize) ORDINAL 157
LL_FUNCTION LlXSetExportParameter(hLlJob, @pszExtensionName, @pszKey, @pszValue) ORDINAL 158
LL_FUNCTION LlXGetExportParameter(hLlJob, @pszExtensionName, @pszKey, @pszBuffer, nBufSize) ORDINAL 160
LL_FUNCTION LlXlatName(hLlJob, @pszName, @pszBuffer, nBufSize) ORDINAL 164
LL_FUNCTION LlDesignerProhibitEditingObject(hLlJob, @pszObject) ORDINAL 185
LL_FUNCTION LlGetUsedIdentifiers(hLlJob, @pszProjectName, @pszBuffer, nBufSize) ORDINAL 186
LL_FUNCTION LlExprGetUsedVarsEx(hLlJob, lpExpr, @pszBuffer, nBufSize, OrgName) ORDINAL 205
LL_FUNCTION LlDomGetProject(hLlJob, @phDOMObj) ORDINAL 206
LL_FUNCTION LlDomGetProperty(hDOMObj, @pszName, @pszBuffer, nBufSize) ORDINAL 207
LL_FUNCTION LlDomSetProperty(hDOMObj, @pszName, @pszValue) ORDINAL 208
LL_FUNCTION LlDomGetObject(hDOMObj, @pszName, @phDOMSubObj) ORDINAL 209
LL_FUNCTION LlDomGetSubobjectCount(hDOMObj, @pnCount) ORDINAL 210
LL_FUNCTION LlDomGetSubobject(hDOMObj, nPosition, @phDOMSubObj) ORDINAL 211
LL_FUNCTION LlDomCreateSubobject(hDOMObj, nPosition, @pszType, @phDOMSubObj) ORDINAL 212
LL_FUNCTION LlDomDeleteSubobject(hDOMObj, nPosition) ORDINAL 213
LL_FUNCTION LlProjectOpen(hLlJob, nObjType, @pszObjName, nOpenMode) ORDINAL 214
LL_FUNCTION LlProjectSave(hLlJob, @pszObjName) ORDINAL 215
LL_FUNCTION LlProjectClose(hLlJob) ORDINAL 216
LL_FUNCTION LlAssociatePreviewControl(hLlJob, hWndControl, nFlags) ORDINAL 218
LL_FUNCTION LlGetErrortext(nError, @pszBuffer, nBufSize) ORDINAL 219
LL_FUNCTION LlSetPreviewOption(hLlJob, nOption, nValue) ORDINAL 221
LL_FUNCTION LlGetPreviewOption(hLlJob, nOption, @pnValue) ORDINAL 222
LL_FUNCTION LlDesignerInvokeAction(hLlJob, nMenuID) ORDINAL 223
LL_FUNCTION LlDesignerRefreshWorkspace(hLlJob) ORDINAL 224
LL_FUNCTION LlDesignerFileOpen(hLlJob, @pszFilename, nFlags) ORDINAL 225
LL_FUNCTION LlDesignerFileSave(hLlJob, nFlags) ORDINAL 226
LL_FUNCTION LlDesignerAddAction(hLlJob, nID, nFlags, @pszMenuText, @pszMenuHierarchy, @pszTooltipText, nIcon, pvReserved) ORDINAL 227
LL_FUNCTION LlDesignerGetOptionString(hLlJob, nIndex, @pszBuffer, nBufSize) ORDINAL 236
LL_FUNCTION LlDesignerSetOptionString(hLlJob, nIndex, @pszBuffer) ORDINAL 237
LL_FUNCTION LlJobOpenCopy(hJob) ORDINAL 239
LL_FUNCTION LlGetProjectParameter(hLlJob, @pszProjectName, @pszParameter, @pszBuffer, nBufSize) ORDINAL 249
LL_FUNCTION LlConvertBLOBToString(@pBytes, nBytes, @pszBuffer, nBufSize, bWithCompression) ORDINAL 250
LL_FUNCTION LlConvertStringToBLOB(@pszText, @pBytes, nBytes) ORDINAL 251
LL_FUNCTION LlDbAddTableRelationEx(hJob, @pszTableID, @pszParentTableID, @pszRelationID, @pszRelationDisplayName, @pszKeyField, @pszParentKeyField) ORDINAL 238
LL_FUNCTION LlDbAddTableSortOrderEx(hJob, @pszTableID, @pszSortOrderID, @pszSortOrderDisplayName, @pszField) ORDINAL 257
LL_FUNCTION LlGetUsedIdentifiersEx(hLlJob, @pszProjectName, nIdentifierTypes, @pszBuffer, nBufSize) ORDINAL 258
LL_FUNCTION LlGetTempFileName(@pszPrefix, @pszExt, @pszBuffer, nBufSize, nOptions) ORDINAL 259
LL_FUNCTION LlGetDebug() ORDINAL 260
LL_FUNCTION LlRTFEditorGetRTFControlHandle(hLlJob, hRTF) ORDINAL 261
LL_FUNCTION LlGetDefaultPrinter(@pszPrinter, @pnPrinterBufSize, pDevMode, @pnDevModeBufSize, nOptions) ORDINAL 262
LL_FUNCTION LlLocAddDictionaryEntry(hLlJob, nLCID, @pszKey, @pszValue, nType) ORDINAL 263
LL_FUNCTION LlLocAddDesignLCID(hLlJob, nLCID) ORDINAL 264
LL_FUNCTION LlIsUILanguageAvailable(nLanguage, nTypesToLookFor) ORDINAL 265
LL_FUNCTION LlIsUILanguageAvailableLCID(nLCID, nTypesToLookFor) ORDINAL 266
LL_FUNCTION LlDbAddTableEx(hJob, @pszTableID, @pszDisplayName, nOptions) ORDINAL 267
LL_FUNCTION LlRTFSetTextEx(hLlJob, hRTF, nFlags, @pszText) ORDINAL 269
LL_FUNCTION LlInplaceDesignerInteraction(hLlJob, nAction, wParam, lParam) ORDINAL 270
LL_FUNCTION LlGetProjectDescription(hLlJob, @pszProjectName, @pszBuffer, nBufSize) ORDINAL 280
LL_FUNCTION LlSRTriggerExport(hJob, hSessionJob, @pszID, @pszExportFormat, nFlags) ORDINAL 289
LL_FUNCTION LlExprGetUsedFunctions(hLlJob, lpExpr, @pszBuffer, nBufSize) ORDINAL 292

LL_FUNCTION LlSetNotificationCallback(hJob,nMessage) ORDINAL 17
LL_FUNCTION LlSetNotificationCallbackExt(hJob,nEvent,nMessage) ORDINAL 100
