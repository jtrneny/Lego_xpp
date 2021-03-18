// Alaska dBase++ module constants and function definitions for LL11.DLL
//  (c) 1991,..,1999,2000,..,06,... combit GmbH, Konstanz, Germany
//  [build of 2006-06-26 10:06:56]

// MODULE file to be included once in a project

#include "dll.ch"

/*--- variables needed for dynamic loading (templates allow fast access) ---*/

STATIC aLL11Vars[1]

#define hDll aLL11Vars[ThreadId(),1]
#define tplLlJobOpen aLL11Vars[ThreadId(),2]
#define tplLlJobOpenLCID aLL11Vars[ThreadId(),3]
#define tplLlJobClose aLL11Vars[ThreadId(),4]
#define tplLlSetDebug aLL11Vars[ThreadId(),5]
#define tplLlGetVersion aLL11Vars[ThreadId(),6]
#define tplLlGetNotificationMessage aLL11Vars[ThreadId(),7]
#define tplLlSetNotificationMessage aLL11Vars[ThreadId(),8]
#define tplLlDefineField aLL11Vars[ThreadId(),9]
#define tplLlDefineFieldExt aLL11Vars[ThreadId(),10]
#define tplLlDefineFieldExtHandle aLL11Vars[ThreadId(),11]
#define tplLlDefineFieldStart aLL11Vars[ThreadId(),12]
#define tplLlDefineVariable aLL11Vars[ThreadId(),13]
#define tplLlDefineVariableExt aLL11Vars[ThreadId(),14]
#define tplLlDefineVariableExtHandle aLL11Vars[ThreadId(),15]
#define tplLlDefineVariableName aLL11Vars[ThreadId(),16]
#define tplLlDefineVariableStart aLL11Vars[ThreadId(),17]
#define tplLlDefineSumVariable aLL11Vars[ThreadId(),18]
#define tplLlDefineLayout aLL11Vars[ThreadId(),19]
#define tplLlDlgEditLine aLL11Vars[ThreadId(),20]
#define tplLlDlgEditLineEx aLL11Vars[ThreadId(),21]
#define tplLlPreviewSetTempPath aLL11Vars[ThreadId(),22]
#define tplLlPreviewDeleteFiles aLL11Vars[ThreadId(),23]
#define tplLlPreviewDisplay aLL11Vars[ThreadId(),24]
#define tplLlPreviewDisplayEx aLL11Vars[ThreadId(),25]
#define tplLlPrint aLL11Vars[ThreadId(),26]
#define tplLlPrintAbort aLL11Vars[ThreadId(),27]
#define tplLlPrintCheckLineFit aLL11Vars[ThreadId(),28]
#define tplLlPrintEnd aLL11Vars[ThreadId(),29]
#define tplLlPrintFields aLL11Vars[ThreadId(),30]
#define tplLlPrintFieldsEnd aLL11Vars[ThreadId(),31]
#define tplLlPrintGetCurrentPage aLL11Vars[ThreadId(),32]
#define tplLlPrintGetItemsPerPage aLL11Vars[ThreadId(),33]
#define tplLlPrintGetItemsPerTable aLL11Vars[ThreadId(),34]
#define tplLlPrintGetRemainingItemsPerTable aLL11Vars[ThreadId(),35]
#define tplLlPrintGetRemItemsPerTable aLL11Vars[ThreadId(),36]
#define tplLlPrintGetOption aLL11Vars[ThreadId(),37]
#define tplLlPrintGetPrinterInfo aLL11Vars[ThreadId(),38]
#define tplLlPrintOptionsDialog aLL11Vars[ThreadId(),39]
#define tplLlPrintSelectOffsetEx aLL11Vars[ThreadId(),40]
#define tplLlPrintSetBoxText aLL11Vars[ThreadId(),41]
#define tplLlPrintSetOption aLL11Vars[ThreadId(),42]
#define tplLlPrintUpdateBox aLL11Vars[ThreadId(),43]
#define tplLlPrintStart aLL11Vars[ThreadId(),44]
#define tplLlPrintWithBoxStart aLL11Vars[ThreadId(),45]
#define tplLlPrinterSetup aLL11Vars[ThreadId(),46]
#define tplLlSelectFileDlgTitleEx aLL11Vars[ThreadId(),47]
#define tplLlSetDlgboxMode aLL11Vars[ThreadId(),48]
#define tplLlGetDlgboxMode aLL11Vars[ThreadId(),49]
#define tplLlExprParse aLL11Vars[ThreadId(),50]
#define tplLlExprType aLL11Vars[ThreadId(),51]
#define tplLlExprError aLL11Vars[ThreadId(),52]
#define tplLlExprFree aLL11Vars[ThreadId(),53]
#define tplLlExprEvaluate aLL11Vars[ThreadId(),54]
#define tplLlExprGetUsedVars aLL11Vars[ThreadId(),55]
#define tplLlSetOption aLL11Vars[ThreadId(),56]
#define tplLlGetOption aLL11Vars[ThreadId(),57]
#define tplLlSetOptionString aLL11Vars[ThreadId(),58]
#define tplLlGetOptionString aLL11Vars[ThreadId(),59]
#define tplLlPrintSetOptionString aLL11Vars[ThreadId(),60]
#define tplLlPrintGetOptionString aLL11Vars[ThreadId(),61]
#define tplLlDesignerProhibitAction aLL11Vars[ThreadId(),62]
#define tplLlDesignerProhibitFunction aLL11Vars[ThreadId(),63]
#define tplLlPrintEnableObject aLL11Vars[ThreadId(),64]
#define tplLlSetFileExtensions aLL11Vars[ThreadId(),65]
#define tplLlPrintGetTextCharsPrinted aLL11Vars[ThreadId(),66]
#define tplLlPrintGetFieldCharsPrinted aLL11Vars[ThreadId(),67]
#define tplLlPrintIsVariableUsed aLL11Vars[ThreadId(),68]
#define tplLlPrintIsFieldUsed aLL11Vars[ThreadId(),69]
#define tplLlPrintOptionsDialogTitle aLL11Vars[ThreadId(),70]
#define tplLlSetPrinterToDefault aLL11Vars[ThreadId(),71]
#define tplLlDefineSortOrderStart aLL11Vars[ThreadId(),72]
#define tplLlDefineSortOrder aLL11Vars[ThreadId(),73]
#define tplLlPrintGetSortOrder aLL11Vars[ThreadId(),74]
#define tplLlDefineGrouping aLL11Vars[ThreadId(),75]
#define tplLlPrintGetGrouping aLL11Vars[ThreadId(),76]
#define tplLlAddCtlSupport aLL11Vars[ThreadId(),77]
#define tplLlPrintBeginGroup aLL11Vars[ThreadId(),78]
#define tplLlPrintEndGroup aLL11Vars[ThreadId(),79]
#define tplLlPrintGroupLine aLL11Vars[ThreadId(),80]
#define tplLlPrintGroupHeader aLL11Vars[ThreadId(),81]
#define tplLlPrintGetFilterExpression aLL11Vars[ThreadId(),82]
#define tplLlPrintWillMatchFilter aLL11Vars[ThreadId(),83]
#define tplLlPrintDidMatchFilter aLL11Vars[ThreadId(),84]
#define tplLlGetFieldContents aLL11Vars[ThreadId(),85]
#define tplLlGetVariableContents aLL11Vars[ThreadId(),86]
#define tplLlGetSumVariableContents aLL11Vars[ThreadId(),87]
#define tplLlGetUserVariableContents aLL11Vars[ThreadId(),88]
#define tplLlGetVariableType aLL11Vars[ThreadId(),89]
#define tplLlGetFieldType aLL11Vars[ThreadId(),90]
#define tplLlSetPrinterDefaultsDir aLL11Vars[ThreadId(),91]
#define tplLlCreateSketch aLL11Vars[ThreadId(),92]
#define tplLlViewerProhibitAction aLL11Vars[ThreadId(),93]
#define tplLlPrintCopyPrinterConfiguration aLL11Vars[ThreadId(),94]
#define tplLlSetPrinterInPrinterFile aLL11Vars[ThreadId(),95]
#define tplLlRTFCreateObject aLL11Vars[ThreadId(),96]
#define tplLlRTFDeleteObject aLL11Vars[ThreadId(),97]
#define tplLlRTFSetText aLL11Vars[ThreadId(),98]
#define tplLlRTFGetTextLength aLL11Vars[ThreadId(),99]
#define tplLlRTFGetText aLL11Vars[ThreadId(),100]
#define tplLlRTFEditObject aLL11Vars[ThreadId(),101]
#define tplLlRTFCopyToClipboard aLL11Vars[ThreadId(),102]
#define tplLlRTFDisplay aLL11Vars[ThreadId(),103]
#define tplLlRTFEditorProhibitAction aLL11Vars[ThreadId(),104]
#define tplLlRTFEditorInvokeAction aLL11Vars[ThreadId(),105]
#define tplLlDebugOutput aLL11Vars[ThreadId(),106]
#define tplLlEnumGetFirstVar aLL11Vars[ThreadId(),107]
#define tplLlEnumGetFirstField aLL11Vars[ThreadId(),108]
#define tplLlEnumGetNextEntry aLL11Vars[ThreadId(),109]
#define tplLlEnumGetEntry aLL11Vars[ThreadId(),110]
#define tplLlPrintResetObjectStates aLL11Vars[ThreadId(),111]
#define tplLlXSetParameter aLL11Vars[ThreadId(),112]
#define tplLlXGetParameter aLL11Vars[ThreadId(),113]
#define tplLlPrintResetProjectState aLL11Vars[ThreadId(),114]
#define tplLlDefineChartFieldStart aLL11Vars[ThreadId(),115]
#define tplLlDefineChartFieldExt aLL11Vars[ThreadId(),116]
#define tplLlPrintDeclareChartRow aLL11Vars[ThreadId(),117]
#define tplLlPrintGetChartObjectCount aLL11Vars[ThreadId(),118]
#define tplLlPrintIsChartFieldUsed aLL11Vars[ThreadId(),119]
#define tplLlGetChartFieldContents aLL11Vars[ThreadId(),120]
#define tplLlEnumGetFirstChartField aLL11Vars[ThreadId(),121]
#define tplLlGetPrinterFromPrinterFile aLL11Vars[ThreadId(),122]
#define tplLlPrintGetRemainingSpacePerTable aLL11Vars[ThreadId(),123]
#define tplLlDrawToolbarBackground aLL11Vars[ThreadId(),124]
#define tplLlSetDefaultProjectParameter aLL11Vars[ThreadId(),125]
#define tplLlGetDefaultProjectParameter aLL11Vars[ThreadId(),126]
#define tplLlPrintSetProjectParameter aLL11Vars[ThreadId(),127]
#define tplLlPrintGetProjectParameter aLL11Vars[ThreadId(),128]
#define tplLlExprContainsVariable aLL11Vars[ThreadId(),129]
#define tplLlExprIsConstant aLL11Vars[ThreadId(),130]
#define tplLlProfileStart aLL11Vars[ThreadId(),131]
#define tplLlProfileEnd aLL11Vars[ThreadId(),132]
#define tplLlDbAddTable aLL11Vars[ThreadId(),133]
#define tplLlDbAddTableRelation aLL11Vars[ThreadId(),134]
#define tplLlDbAddTableSortOrder aLL11Vars[ThreadId(),135]
#define tplLlPrintDbGetCurrentTable aLL11Vars[ThreadId(),136]
#define tplLlPrintDbGetCurrentTableRelation aLL11Vars[ThreadId(),137]
#define tplLlPrintDbGetCurrentTableSortOrder aLL11Vars[ThreadId(),138]
#define tplLlDbDumpStructure aLL11Vars[ThreadId(),139]
#define tplLlPrintDbGetRootTableCount aLL11Vars[ThreadId(),140]
#define tplLlDbSetMasterTable aLL11Vars[ThreadId(),141]
#define tplLlDbGetMasterTable aLL11Vars[ThreadId(),142]
#define tplLlXSetExportParameter aLL11Vars[ThreadId(),143]
#define tplLlXGetExportParameter aLL11Vars[ThreadId(),144]
#define tplLlXlatName aLL11Vars[ThreadId(),145]
#define tplLlDesignerProhibitEditingObject aLL11Vars[ThreadId(),146]
#define tplLlGetUsedIdentifiers aLL11Vars[ThreadId(),147]
#define tplLlInternalAttachApp aLL11Vars[ThreadId(),148]
#define tplLlInternalDetachApp aLL11Vars[ThreadId(),149]
*
#define tplLlSetNotificationCallback  aLL11Vars[ThreadId(),150]
#define tplLlSetNotificationCallbackExt aLL11Vars[ThreadId(),151]


PROCEDURE LL11LoadTemplates()
  tplLlJobOpen = DllPrepareCall(hDll,DLL_STDCALL,10)
  tplLlJobOpenLCID = DllPrepareCall(hDll,DLL_STDCALL,12)
  tplLlJobClose = DllPrepareCall(hDll,DLL_STDCALL,11)
  tplLlSetDebug = DllPrepareCall(hDll,DLL_STDCALL,13)
  tplLlGetVersion = DllPrepareCall(hDll,DLL_STDCALL,14)
  tplLlGetNotificationMessage = DllPrepareCall(hDll,DLL_STDCALL,15)
  tplLlSetNotificationMessage = DllPrepareCall(hDll,DLL_STDCALL,16)
  tplLlDefineField = DllPrepareCall(hDll,DLL_STDCALL,18)
  tplLlDefineFieldExt = DllPrepareCall(hDll,DLL_STDCALL,19)
  tplLlDefineFieldExtHandle = DllPrepareCall(hDll,DLL_STDCALL,20)
  tplLlDefineFieldStart = DllPrepareCall(hDll,DLL_STDCALL,21)
  tplLlDefineVariable = DllPrepareCall(hDll,DLL_STDCALL,22)
  tplLlDefineVariableExt = DllPrepareCall(hDll,DLL_STDCALL,23)
  tplLlDefineVariableExtHandle = DllPrepareCall(hDll,DLL_STDCALL,24)
  tplLlDefineVariableName = DllPrepareCall(hDll,DLL_STDCALL,25)
  tplLlDefineVariableStart = DllPrepareCall(hDll,DLL_STDCALL,26)
  tplLlDefineSumVariable = DllPrepareCall(hDll,DLL_STDCALL,27)
  tplLlDefineLayout = DllPrepareCall(hDll,DLL_STDCALL,28)
  tplLlDlgEditLine = DllPrepareCall(hDll,DLL_STDCALL,29)
  tplLlDlgEditLineEx = DllPrepareCall(hDll,DLL_STDCALL,30)
  tplLlPreviewSetTempPath = DllPrepareCall(hDll,DLL_STDCALL,31)
  tplLlPreviewDeleteFiles = DllPrepareCall(hDll,DLL_STDCALL,32)
  tplLlPreviewDisplay = DllPrepareCall(hDll,DLL_STDCALL,33)
  tplLlPreviewDisplayEx = DllPrepareCall(hDll,DLL_STDCALL,34)
  tplLlPrint = DllPrepareCall(hDll,DLL_STDCALL,35)
  tplLlPrintAbort = DllPrepareCall(hDll,DLL_STDCALL,36)
  tplLlPrintCheckLineFit = DllPrepareCall(hDll,DLL_STDCALL,37)
  tplLlPrintEnd = DllPrepareCall(hDll,DLL_STDCALL,38)
  tplLlPrintFields = DllPrepareCall(hDll,DLL_STDCALL,39)
  tplLlPrintFieldsEnd = DllPrepareCall(hDll,DLL_STDCALL,40)
  tplLlPrintGetCurrentPage = DllPrepareCall(hDll,DLL_STDCALL,41)
  tplLlPrintGetItemsPerPage = DllPrepareCall(hDll,DLL_STDCALL,42)
  tplLlPrintGetItemsPerTable = DllPrepareCall(hDll,DLL_STDCALL,43)
  tplLlPrintGetRemainingItemsPerTable = DllPrepareCall(hDll,DLL_STDCALL,44)
  tplLlPrintGetRemItemsPerTable = DllPrepareCall(hDll,DLL_STDCALL,45)
  tplLlPrintGetOption = DllPrepareCall(hDll,DLL_STDCALL,46)
  tplLlPrintGetPrinterInfo = DllPrepareCall(hDll,DLL_STDCALL,47)
  tplLlPrintOptionsDialog = DllPrepareCall(hDll,DLL_STDCALL,48)
  tplLlPrintSelectOffsetEx = DllPrepareCall(hDll,DLL_STDCALL,49)
  tplLlPrintSetBoxText = DllPrepareCall(hDll,DLL_STDCALL,50)
  tplLlPrintSetOption = DllPrepareCall(hDll,DLL_STDCALL,51)
  tplLlPrintUpdateBox = DllPrepareCall(hDll,DLL_STDCALL,52)
  tplLlPrintStart = DllPrepareCall(hDll,DLL_STDCALL,53)
  tplLlPrintWithBoxStart = DllPrepareCall(hDll,DLL_STDCALL,54)
  tplLlPrinterSetup = DllPrepareCall(hDll,DLL_STDCALL,55)
  tplLlSelectFileDlgTitleEx = DllPrepareCall(hDll,DLL_STDCALL,56)
  tplLlSetDlgboxMode = DllPrepareCall(hDll,DLL_STDCALL,57)
  tplLlGetDlgboxMode = DllPrepareCall(hDll,DLL_STDCALL,58)
  tplLlExprParse = DllPrepareCall(hDll,DLL_STDCALL,59)
  tplLlExprType = DllPrepareCall(hDll,DLL_STDCALL,60)
  tplLlExprError = DllPrepareCall(hDll,DLL_STDCALL,61)
  tplLlExprFree = DllPrepareCall(hDll,DLL_STDCALL,62)
  tplLlExprEvaluate = DllPrepareCall(hDll,DLL_STDCALL,63)
  tplLlExprGetUsedVars = DllPrepareCall(hDll,DLL_STDCALL,162)
  tplLlSetOption = DllPrepareCall(hDll,DLL_STDCALL,64)
  tplLlGetOption = DllPrepareCall(hDll,DLL_STDCALL,65)
  tplLlSetOptionString = DllPrepareCall(hDll,DLL_STDCALL,66)
  tplLlGetOptionString = DllPrepareCall(hDll,DLL_STDCALL,67)
  tplLlPrintSetOptionString = DllPrepareCall(hDll,DLL_STDCALL,68)
  tplLlPrintGetOptionString = DllPrepareCall(hDll,DLL_STDCALL,69)
  tplLlDesignerProhibitAction = DllPrepareCall(hDll,DLL_STDCALL,70)
  tplLlDesignerProhibitFunction = DllPrepareCall(hDll,DLL_STDCALL,1)
  tplLlPrintEnableObject = DllPrepareCall(hDll,DLL_STDCALL,71)
  tplLlSetFileExtensions = DllPrepareCall(hDll,DLL_STDCALL,72)
  tplLlPrintGetTextCharsPrinted = DllPrepareCall(hDll,DLL_STDCALL,73)
  tplLlPrintGetFieldCharsPrinted = DllPrepareCall(hDll,DLL_STDCALL,74)
  tplLlPrintIsVariableUsed = DllPrepareCall(hDll,DLL_STDCALL,75)
  tplLlPrintIsFieldUsed = DllPrepareCall(hDll,DLL_STDCALL,76)
  tplLlPrintOptionsDialogTitle = DllPrepareCall(hDll,DLL_STDCALL,77)
  tplLlSetPrinterToDefault = DllPrepareCall(hDll,DLL_STDCALL,78)
  tplLlDefineSortOrderStart = DllPrepareCall(hDll,DLL_STDCALL,79)
  tplLlDefineSortOrder = DllPrepareCall(hDll,DLL_STDCALL,80)
  tplLlPrintGetSortOrder = DllPrepareCall(hDll,DLL_STDCALL,81)
  tplLlDefineGrouping = DllPrepareCall(hDll,DLL_STDCALL,82)
  tplLlPrintGetGrouping = DllPrepareCall(hDll,DLL_STDCALL,83)
  tplLlAddCtlSupport = DllPrepareCall(hDll,DLL_STDCALL,84)
  tplLlPrintBeginGroup = DllPrepareCall(hDll,DLL_STDCALL,85)
  tplLlPrintEndGroup = DllPrepareCall(hDll,DLL_STDCALL,86)
  tplLlPrintGroupLine = DllPrepareCall(hDll,DLL_STDCALL,87)
  tplLlPrintGroupHeader = DllPrepareCall(hDll,DLL_STDCALL,88)
  tplLlPrintGetFilterExpression = DllPrepareCall(hDll,DLL_STDCALL,89)
  tplLlPrintWillMatchFilter = DllPrepareCall(hDll,DLL_STDCALL,90)
  tplLlPrintDidMatchFilter = DllPrepareCall(hDll,DLL_STDCALL,91)
  tplLlGetFieldContents = DllPrepareCall(hDll,DLL_STDCALL,93)
  tplLlGetVariableContents = DllPrepareCall(hDll,DLL_STDCALL,92)
  tplLlGetSumVariableContents = DllPrepareCall(hDll,DLL_STDCALL,94)
  tplLlGetUserVariableContents = DllPrepareCall(hDll,DLL_STDCALL,95)
  tplLlGetVariableType = DllPrepareCall(hDll,DLL_STDCALL,96)
  tplLlGetFieldType = DllPrepareCall(hDll,DLL_STDCALL,97)
  tplLlSetPrinterDefaultsDir = DllPrepareCall(hDll,DLL_STDCALL,200)
  tplLlCreateSketch = DllPrepareCall(hDll,DLL_STDCALL,201)
  tplLlViewerProhibitAction = DllPrepareCall(hDll,DLL_STDCALL,202)
  tplLlPrintCopyPrinterConfiguration = DllPrepareCall(hDll,DLL_STDCALL,203)
  tplLlSetPrinterInPrinterFile = DllPrepareCall(hDll,DLL_STDCALL,204)
  tplLlRTFCreateObject = DllPrepareCall(hDll,DLL_STDCALL,228)
  tplLlRTFDeleteObject = DllPrepareCall(hDll,DLL_STDCALL,229)
  tplLlRTFSetText = DllPrepareCall(hDll,DLL_STDCALL,230)
  tplLlRTFGetTextLength = DllPrepareCall(hDll,DLL_STDCALL,231)
  tplLlRTFGetText = DllPrepareCall(hDll,DLL_STDCALL,232)
  tplLlRTFEditObject = DllPrepareCall(hDll,DLL_STDCALL,233)
  tplLlRTFCopyToClipboard = DllPrepareCall(hDll,DLL_STDCALL,234)
  tplLlRTFDisplay = DllPrepareCall(hDll,DLL_STDCALL,235)
  tplLlRTFEditorProhibitAction = DllPrepareCall(hDll,DLL_STDCALL,109)
  tplLlRTFEditorInvokeAction = DllPrepareCall(hDll,DLL_STDCALL,117)
  tplLlDebugOutput = DllPrepareCall(hDll,DLL_STDCALL,240)
  tplLlEnumGetFirstVar = DllPrepareCall(hDll,DLL_STDCALL,241)
  tplLlEnumGetFirstField = DllPrepareCall(hDll,DLL_STDCALL,242)
  tplLlEnumGetNextEntry = DllPrepareCall(hDll,DLL_STDCALL,243)
  tplLlEnumGetEntry = DllPrepareCall(hDll,DLL_STDCALL,244)
  tplLlPrintResetObjectStates = DllPrepareCall(hDll,DLL_STDCALL,245)
  tplLlXSetParameter = DllPrepareCall(hDll,DLL_STDCALL,246)
  tplLlXGetParameter = DllPrepareCall(hDll,DLL_STDCALL,247)
  tplLlPrintResetProjectState = DllPrepareCall(hDll,DLL_STDCALL,248)
  tplLlDefineChartFieldStart = DllPrepareCall(hDll,DLL_STDCALL,2)
  tplLlDefineChartFieldExt = DllPrepareCall(hDll,DLL_STDCALL,3)
  tplLlPrintDeclareChartRow = DllPrepareCall(hDll,DLL_STDCALL,4)
  tplLlPrintGetChartObjectCount = DllPrepareCall(hDll,DLL_STDCALL,6)
  tplLlPrintIsChartFieldUsed = DllPrepareCall(hDll,DLL_STDCALL,5)
  tplLlGetChartFieldContents = DllPrepareCall(hDll,DLL_STDCALL,8)
  tplLlEnumGetFirstChartField = DllPrepareCall(hDll,DLL_STDCALL,9)
  tplLlGetPrinterFromPrinterFile = DllPrepareCall(hDll,DLL_STDCALL,98)
  tplLlPrintGetRemainingSpacePerTable = DllPrepareCall(hDll,DLL_STDCALL,102)
  tplLlDrawToolbarBackground = DllPrepareCall(hDll,DLL_STDCALL,104)
  tplLlSetDefaultProjectParameter = DllPrepareCall(hDll,DLL_STDCALL,108)
  tplLlGetDefaultProjectParameter = DllPrepareCall(hDll,DLL_STDCALL,110)
  tplLlPrintSetProjectParameter = DllPrepareCall(hDll,DLL_STDCALL,113)
  tplLlPrintGetProjectParameter = DllPrepareCall(hDll,DLL_STDCALL,114)
  tplLlExprContainsVariable = DllPrepareCall(hDll,DLL_STDCALL,7)
  tplLlExprIsConstant = DllPrepareCall(hDll,DLL_STDCALL,116)
  tplLlProfileStart = DllPrepareCall(hDll,DLL_STDCALL,136)
  tplLlProfileEnd = DllPrepareCall(hDll,DLL_STDCALL,137)
  tplLlDbAddTable = DllPrepareCall(hDll,DLL_STDCALL,139)
  tplLlDbAddTableRelation = DllPrepareCall(hDll,DLL_STDCALL,140)
  tplLlDbAddTableSortOrder = DllPrepareCall(hDll,DLL_STDCALL,141)
  tplLlPrintDbGetCurrentTable = DllPrepareCall(hDll,DLL_STDCALL,142)
  tplLlPrintDbGetCurrentTableRelation = DllPrepareCall(hDll,DLL_STDCALL,143)
  tplLlPrintDbGetCurrentTableSortOrder = DllPrepareCall(hDll,DLL_STDCALL,146)
  tplLlDbDumpStructure = DllPrepareCall(hDll,DLL_STDCALL,149)
  tplLlPrintDbGetRootTableCount = DllPrepareCall(hDll,DLL_STDCALL,151)
  tplLlDbSetMasterTable = DllPrepareCall(hDll,DLL_STDCALL,152)
  tplLlDbGetMasterTable = DllPrepareCall(hDll,DLL_STDCALL,157)
  tplLlXSetExportParameter = DllPrepareCall(hDll,DLL_STDCALL,158)
  tplLlXGetExportParameter = DllPrepareCall(hDll,DLL_STDCALL,160)
  tplLlXlatName = DllPrepareCall(hDll,DLL_STDCALL,164)
  tplLlDesignerProhibitEditingObject = DllPrepareCall(hDll,DLL_STDCALL,185)
  tplLlGetUsedIdentifiers = DllPrepareCall(hDll,DLL_STDCALL,186)
  tplLlInternalAttachApp = DllPrepareCall(hDll,DLL_STDCALL,187)
  tplLlInternalDetachApp = DllPrepareCall(hDll,DLL_STDCALL,188)

  tplLlSetNotificationCallback = DllPrepareCall(hDll,DLL_STDCALL,17)
  tplLlSetNotificationCallbackExt = DllPrepareCall(hDll,DLL_STDCALL,100)
RETURN

/*--- load and unload DLL automatically (or manually) ---*/

PROCEDURE LL11ModuleInit()
  LOCAL nId := ThreadID()

  IF Len(aLL11Vars) < nId
    ASize(aLL11Vars,nId)
  ENDIF
  aLL11Vars[nId] := { ;
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
     NIL  ;
    }

  hDll = DllLoad("CMLL11.DLL")
  IF hDll == 0
    ? "CMLL11.DLL cannot be loaded"
   ELSE
    LL11LoadTemplates()
  ENDIF
RETURN

PROCEDURE LL11ModuleExit()
  DllUnLoad(hDll)
  aLL11Vars[ThreadID()] := NIL
RETURN

/*--- functions ---*/

FUNCTION LlJobOpen(nLanguage)
 RETURN DllExecuteCall(tplLlJobOpen, nLanguage)

FUNCTION LlJobOpenLCID(nLCID)
 RETURN DllExecuteCall(tplLlJobOpenLCID, nLCID)

PROCEDURE LlJobClose(hLlJob)
 DllExecuteCall(tplLlJobClose, hLlJob)
 RETURN

PROCEDURE LlSetDebug(nOnOff)
 DllExecuteCall(tplLlSetDebug, nOnOff)
 RETURN

FUNCTION LlGetVersion(nCmd)
 RETURN DllExecuteCall(tplLlGetVersion, nCmd)

FUNCTION LlGetNotificationMessage(hLlJob)
 RETURN DllExecuteCall(tplLlGetNotificationMessage, hLlJob)

FUNCTION LlSetNotificationMessage(hLlJob, nMessage)
 RETURN DllExecuteCall(tplLlSetNotificationMessage, hLlJob, nMessage)

FUNCTION LlDefineField(hLlJob, pszVarName, lpbufContents)
 RETURN DllExecuteCall(tplLlDefineField, hLlJob, @pszVarName, @lpbufContents)

FUNCTION LlDefineFieldExt(hLlJob, pszVarName, lpbufContents, lPara, lpPtr)
 RETURN DllExecuteCall(tplLlDefineFieldExt, hLlJob, @pszVarName, @lpbufContents, lPara, lpPtr)

FUNCTION LlDefineFieldExtHandle(hLlJob, pszVarName, hContents, lPara, lpPtr)
 RETURN DllExecuteCall(tplLlDefineFieldExtHandle, hLlJob, @pszVarName, hContents, lPara, lpPtr)

PROCEDURE LlDefineFieldStart(hLlJob)
 DllExecuteCall(tplLlDefineFieldStart, hLlJob)
 RETURN

FUNCTION LlDefineVariable(hLlJob, pszVarName, lpbufContents)
 RETURN DllExecuteCall(tplLlDefineVariable, hLlJob, @pszVarName, @lpbufContents)

FUNCTION LlDefineVariableExt(hLlJob, pszVarName, lpbufContents, lPara, lpPtr)
 RETURN DllExecuteCall(tplLlDefineVariableExt, hLlJob, @pszVarName, @lpbufContents, lPara, lpPtr)

FUNCTION LlDefineVariableExtHandle(hLlJob, pszVarName, hContents, lPara, lpPtr)
 RETURN DllExecuteCall(tplLlDefineVariableExtHandle, hLlJob, @pszVarName, hContents, lPara, lpPtr)

FUNCTION LlDefineVariableName(hLlJob, pszVarName)
 RETURN DllExecuteCall(tplLlDefineVariableName, hLlJob, @pszVarName)

PROCEDURE LlDefineVariableStart(hLlJob)
 DllExecuteCall(tplLlDefineVariableStart, hLlJob)
 RETURN

FUNCTION LlDefineSumVariable(hLlJob, pszVarName, lpbufContents)
 RETURN DllExecuteCall(tplLlDefineSumVariable, hLlJob, @pszVarName, @lpbufContents)

FUNCTION LlDefineLayout(hLlJob, hWnd, pszTitle, nObjType, pszObjName)
 RETURN DllExecuteCall(tplLlDefineLayout, hLlJob, hWnd, @pszTitle, nObjType, @pszObjName)

FUNCTION LlDlgEditLine(hLlJob, hWnd, lpBuf, nBufSize)
 RETURN DllExecuteCall(tplLlDlgEditLine, hLlJob, hWnd, @lpBuf, nBufSize)

FUNCTION LlDlgEditLineEx(hLlJob, hWnd, pszBuffer, nBufSize, nParaTypes, pszTitle, bTable, pvReserved)
 RETURN DllExecuteCall(tplLlDlgEditLineEx, hLlJob, hWnd, @pszBuffer, nBufSize, nParaTypes, @pszTitle, bTable, pvReserved)

FUNCTION LlPreviewSetTempPath(hLlJob, pszPath)
 RETURN DllExecuteCall(tplLlPreviewSetTempPath, hLlJob, @pszPath)

FUNCTION LlPreviewDeleteFiles(hLlJob, pszObjName, pszPath)
 RETURN DllExecuteCall(tplLlPreviewDeleteFiles, hLlJob, @pszObjName, @pszPath)

FUNCTION LlPreviewDisplay(hLlJob, pszObjName, pszPath, Wnd)
 RETURN DllExecuteCall(tplLlPreviewDisplay, hLlJob, @pszObjName, @pszPath, Wnd)

FUNCTION LlPreviewDisplayEx(hLlJob, pszObjName, pszPath, Wnd, nOptions, pOptions)
 RETURN DllExecuteCall(tplLlPreviewDisplayEx, hLlJob, @pszObjName, @pszPath, Wnd, nOptions, pOptions)

FUNCTION LlPrint(hLlJob)
 RETURN DllExecuteCall(tplLlPrint, hLlJob)

FUNCTION LlPrintAbort(hLlJob)
 RETURN DllExecuteCall(tplLlPrintAbort, hLlJob)

FUNCTION LlPrintCheckLineFit(hLlJob)
 RETURN DllExecuteCall(tplLlPrintCheckLineFit, hLlJob)

FUNCTION LlPrintEnd(hLlJob, nPages)
 RETURN DllExecuteCall(tplLlPrintEnd, hLlJob, nPages)

FUNCTION LlPrintFields(hLlJob)
 RETURN DllExecuteCall(tplLlPrintFields, hLlJob)

FUNCTION LlPrintFieldsEnd(hLlJob)
 RETURN DllExecuteCall(tplLlPrintFieldsEnd, hLlJob)

FUNCTION LlPrintGetCurrentPage(hLlJob)
 RETURN DllExecuteCall(tplLlPrintGetCurrentPage, hLlJob)

FUNCTION LlPrintGetItemsPerPage(hLlJob)
 RETURN DllExecuteCall(tplLlPrintGetItemsPerPage, hLlJob)

FUNCTION LlPrintGetItemsPerTable(hLlJob)
 RETURN DllExecuteCall(tplLlPrintGetItemsPerTable, hLlJob)

FUNCTION LlPrintGetRemainingItemsPerTable(hLlJob, pszField)
 RETURN DllExecuteCall(tplLlPrintGetRemainingItemsPerTable, hLlJob, @pszField)

FUNCTION LlPrintGetRemItemsPerTable(hLlJob, pszField)
 RETURN DllExecuteCall(tplLlPrintGetRemItemsPerTable, hLlJob, @pszField)

FUNCTION LlPrintGetOption(hLlJob, nIndex)
 RETURN DllExecuteCall(tplLlPrintGetOption, hLlJob, nIndex)

FUNCTION LlPrintGetPrinterInfo(hLlJob, pszPrn, nPrnLen, pszPort, nPortLen)
 RETURN DllExecuteCall(tplLlPrintGetPrinterInfo, hLlJob, @pszPrn, nPrnLen, @pszPort, nPortLen)

FUNCTION LlPrintOptionsDialog(hLlJob, hWnd, pszText)
 RETURN DllExecuteCall(tplLlPrintOptionsDialog, hLlJob, hWnd, @pszText)

FUNCTION LlPrintSelectOffsetEx(hLlJob, hWnd)
 RETURN DllExecuteCall(tplLlPrintSelectOffsetEx, hLlJob, hWnd)

FUNCTION LlPrintSetBoxText(hLlJob, szText, nPercentage)
 RETURN DllExecuteCall(tplLlPrintSetBoxText, hLlJob, @szText, nPercentage)

FUNCTION LlPrintSetOption(hLlJob, nIndex, nValue)
 RETURN DllExecuteCall(tplLlPrintSetOption, hLlJob, nIndex, nValue)

FUNCTION LlPrintUpdateBox(hLlJob)
 RETURN DllExecuteCall(tplLlPrintUpdateBox, hLlJob)

FUNCTION LlPrintStart(hLlJob, nObjType, pszObjName, nPrintOptions, dummy)
 RETURN DllExecuteCall(tplLlPrintStart, hLlJob, nObjType, @pszObjName, nPrintOptions, dummy)

FUNCTION LlPrintWithBoxStart(hLlJob, nObjType, pszObjName, nPrintOptions, nBoxType, hWnd, pszTitle)
 RETURN DllExecuteCall(tplLlPrintWithBoxStart, hLlJob, nObjType, @pszObjName, nPrintOptions, nBoxType, hWnd, @pszTitle)

FUNCTION LlPrinterSetup(hLlJob, hWnd, nObjType, pszObjName)
 RETURN DllExecuteCall(tplLlPrinterSetup, hLlJob, hWnd, nObjType, @pszObjName)

FUNCTION LlSelectFileDlgTitleEx(hLlJob, hWnd, pszTitle, nObjType, pszObjName, nBufSize, pReserved)
 RETURN DllExecuteCall(tplLlSelectFileDlgTitleEx, hLlJob, hWnd, @pszTitle, nObjType, @pszObjName, nBufSize, pReserved)

PROCEDURE LlSetDlgboxMode(nMode)
 DllExecuteCall(tplLlSetDlgboxMode, nMode)
 RETURN

FUNCTION LlGetDlgboxMode()
 RETURN DllExecuteCall(tplLlGetDlgboxMode)

FUNCTION LlExprParse(hLlJob, lpExprText, bIncludeFields)
 RETURN DllExecuteCall(tplLlExprParse, hLlJob, @lpExprText, bIncludeFields)

FUNCTION LlExprType(hLlJob, lpExpr)
 RETURN DllExecuteCall(tplLlExprType, hLlJob, lpExpr)

PROCEDURE LlExprError(hLlJob, pszBuf, nBufSize)
 DllExecuteCall(tplLlExprError, hLlJob, @pszBuf, nBufSize)
 RETURN

PROCEDURE LlExprFree(hLlJob, lpExpr)
 DllExecuteCall(tplLlExprFree, hLlJob, lpExpr)
 RETURN

FUNCTION LlExprEvaluate(hLlJob, lpExpr, pszBuf, nBufSize)
 RETURN DllExecuteCall(tplLlExprEvaluate, hLlJob, lpExpr, @pszBuf, nBufSize)

FUNCTION LlExprGetUsedVars(hLlJob, lpExpr, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlExprGetUsedVars, hLlJob, lpExpr, @pszBuffer, nBufSize)

FUNCTION LlSetOption(hLlJob, nMode, nValue)
 RETURN DllExecuteCall(tplLlSetOption, hLlJob, nMode, nValue)

FUNCTION LlGetOption(hLlJob, nMode)
 RETURN DllExecuteCall(tplLlGetOption, hLlJob, nMode)

FUNCTION LlSetOptionString(hLlJob, nIndex, pszBuffer)
 RETURN DllExecuteCall(tplLlSetOptionString, hLlJob, nIndex, @pszBuffer)

FUNCTION LlGetOptionString(hLlJob, nIndex, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetOptionString, hLlJob, nIndex, @pszBuffer, nBufSize)

FUNCTION LlPrintSetOptionString(hLlJob, nIndex, pszBuffer)
 RETURN DllExecuteCall(tplLlPrintSetOptionString, hLlJob, nIndex, @pszBuffer)

FUNCTION LlPrintGetOptionString(hLlJob, nIndex, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlPrintGetOptionString, hLlJob, nIndex, @pszBuffer, nBufSize)

FUNCTION LlDesignerProhibitAction(hLlJob, nMenuID)
 RETURN DllExecuteCall(tplLlDesignerProhibitAction, hLlJob, nMenuID)

FUNCTION LlDesignerProhibitFunction(hLlJob, pszFunction)
 RETURN DllExecuteCall(tplLlDesignerProhibitFunction, hLlJob, @pszFunction)

FUNCTION LlPrintEnableObject(hLlJob, pszObjectName, bEnable)
 RETURN DllExecuteCall(tplLlPrintEnableObject, hLlJob, @pszObjectName, bEnable)

FUNCTION LlSetFileExtensions(hLlJob, nObjType, pszObjectExt, pszPrinterExt, pszSketchExt)
 RETURN DllExecuteCall(tplLlSetFileExtensions, hLlJob, nObjType, @pszObjectExt, @pszPrinterExt, @pszSketchExt)

FUNCTION LlPrintGetTextCharsPrinted(hLlJob, pszObjectName)
 RETURN DllExecuteCall(tplLlPrintGetTextCharsPrinted, hLlJob, @pszObjectName)

FUNCTION LlPrintGetFieldCharsPrinted(hLlJob, pszObjectName, pszField)
 RETURN DllExecuteCall(tplLlPrintGetFieldCharsPrinted, hLlJob, @pszObjectName, @pszField)

FUNCTION LlPrintIsVariableUsed(hLlJob, pszVarName)
 RETURN DllExecuteCall(tplLlPrintIsVariableUsed, hLlJob, @pszVarName)

FUNCTION LlPrintIsFieldUsed(hLlJob, pszFieldName)
 RETURN DllExecuteCall(tplLlPrintIsFieldUsed, hLlJob, @pszFieldName)

FUNCTION LlPrintOptionsDialogTitle(hLlJob, hWnd, pszTitle, pszText)
 RETURN DllExecuteCall(tplLlPrintOptionsDialogTitle, hLlJob, hWnd, @pszTitle, @pszText)

FUNCTION LlSetPrinterToDefault(hLlJob, nObjType, pszObjName)
 RETURN DllExecuteCall(tplLlSetPrinterToDefault, hLlJob, nObjType, @pszObjName)

FUNCTION LlDefineSortOrderStart(hLlJob)
 RETURN DllExecuteCall(tplLlDefineSortOrderStart, hLlJob)

FUNCTION LlDefineSortOrder(hLlJob, pszIdentifier, pszText)
 RETURN DllExecuteCall(tplLlDefineSortOrder, hLlJob, @pszIdentifier, @pszText)

FUNCTION LlPrintGetSortOrder(hLlJob, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlPrintGetSortOrder, hLlJob, @pszBuffer, nBufSize)

FUNCTION LlDefineGrouping(hLlJob, pszSortorder, pszIdentifier, pszText)
 RETURN DllExecuteCall(tplLlDefineGrouping, hLlJob, @pszSortorder, @pszIdentifier, @pszText)

FUNCTION LlPrintGetGrouping(hLlJob, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlPrintGetGrouping, hLlJob, @pszBuffer, nBufSize)

FUNCTION LlAddCtlSupport(hWnd, nFlags, pszInifile)
 RETURN DllExecuteCall(tplLlAddCtlSupport, hWnd, nFlags, @pszInifile)

FUNCTION LlPrintBeginGroup(hLlJob, lParam, lpParam)
 RETURN DllExecuteCall(tplLlPrintBeginGroup, hLlJob, lParam, lpParam)

FUNCTION LlPrintEndGroup(hLlJob, lParam, lpParam)
 RETURN DllExecuteCall(tplLlPrintEndGroup, hLlJob, lParam, lpParam)

FUNCTION LlPrintGroupLine(hLlJob, lParam, lpParam)
 RETURN DllExecuteCall(tplLlPrintGroupLine, hLlJob, lParam, lpParam)

FUNCTION LlPrintGroupHeader(hLlJob, lParam)
 RETURN DllExecuteCall(tplLlPrintGroupHeader, hLlJob, lParam)

FUNCTION LlPrintGetFilterExpression(hLlJob, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlPrintGetFilterExpression, hLlJob, @pszBuffer, nBufSize)

FUNCTION LlPrintWillMatchFilter(hLlJob)
 RETURN DllExecuteCall(tplLlPrintWillMatchFilter, hLlJob)

FUNCTION LlPrintDidMatchFilter(hLlJob)
 RETURN DllExecuteCall(tplLlPrintDidMatchFilter, hLlJob)

FUNCTION LlGetFieldContents(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetFieldContents, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlGetVariableContents(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetVariableContents, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlGetSumVariableContents(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetSumVariableContents, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlGetUserVariableContents(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetUserVariableContents, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlGetVariableType(hLlJob, pszName)
 RETURN DllExecuteCall(tplLlGetVariableType, hLlJob, @pszName)

FUNCTION LlGetFieldType(hLlJob, pszName)
 RETURN DllExecuteCall(tplLlGetFieldType, hLlJob, @pszName)

FUNCTION LlSetPrinterDefaultsDir(hLlJob, pszDir)
 RETURN DllExecuteCall(tplLlSetPrinterDefaultsDir, hLlJob, @pszDir)

FUNCTION LlCreateSketch(hLlJob, nObjType, lpszObjName)
 RETURN DllExecuteCall(tplLlCreateSketch, hLlJob, nObjType, @lpszObjName)

FUNCTION LlViewerProhibitAction(hLlJob, nMenuID)
 RETURN DllExecuteCall(tplLlViewerProhibitAction, hLlJob, nMenuID)

FUNCTION LlPrintCopyPrinterConfiguration(hLlJob, lpszFilename, nFunction)
 RETURN DllExecuteCall(tplLlPrintCopyPrinterConfiguration, hLlJob, @lpszFilename, nFunction)

FUNCTION LlSetPrinterInPrinterFile(hLlJob, nObjType, pszObjName, nPrinter, pszPrinter, pDevMode)
 RETURN DllExecuteCall(tplLlSetPrinterInPrinterFile, hLlJob, nObjType, @pszObjName, nPrinter, @pszPrinter, pDevMode)

FUNCTION LlRTFCreateObject(hLlJob)
 RETURN DllExecuteCall(tplLlRTFCreateObject, hLlJob)

FUNCTION LlRTFDeleteObject(hLlJob, hRTF)
 RETURN DllExecuteCall(tplLlRTFDeleteObject, hLlJob, hRTF)

FUNCTION LlRTFSetText(hLlJob, hRTF, pszText)
 RETURN DllExecuteCall(tplLlRTFSetText, hLlJob, hRTF, @pszText)

FUNCTION LlRTFGetTextLength(hLlJob, hRTF, nFlags)
 RETURN DllExecuteCall(tplLlRTFGetTextLength, hLlJob, hRTF, nFlags)

FUNCTION LlRTFGetText(hLlJob, hRTF, nFlags, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlRTFGetText, hLlJob, hRTF, nFlags, @pszBuffer, nBufSize)

FUNCTION LlRTFEditObject(hLlJob, hRTF, hWnd, hPrnDC, nProjectType, bModal)
 RETURN DllExecuteCall(tplLlRTFEditObject, hLlJob, hRTF, hWnd, hPrnDC, nProjectType, bModal)

FUNCTION LlRTFCopyToClipboard(hLlJob, hRTF)
 RETURN DllExecuteCall(tplLlRTFCopyToClipboard, hLlJob, hRTF)

FUNCTION LlRTFDisplay(hLlJob, hRTF, hDC, pRC, bRestart, pnState)
 RETURN DllExecuteCall(tplLlRTFDisplay, hLlJob, hRTF, hDC, @pRC, bRestart, @pnState)

FUNCTION LlRTFEditorProhibitAction(hLlJob, hRTF, nControlID)
 RETURN DllExecuteCall(tplLlRTFEditorProhibitAction, hLlJob, hRTF, nControlID)

FUNCTION LlRTFEditorInvokeAction(hLlJob, hRTF, nControlID)
 RETURN DllExecuteCall(tplLlRTFEditorInvokeAction, hLlJob, hRTF, nControlID)

PROCEDURE LlDebugOutput(nIndent, pszText)
 DllExecuteCall(tplLlDebugOutput, nIndent, @pszText)
 RETURN

FUNCTION LlEnumGetFirstVar(hLlJob, nFlags)
 RETURN DllExecuteCall(tplLlEnumGetFirstVar, hLlJob, nFlags)

FUNCTION LlEnumGetFirstField(hLlJob, nFlags)
 RETURN DllExecuteCall(tplLlEnumGetFirstField, hLlJob, nFlags)

FUNCTION LlEnumGetNextEntry(hLlJob, nPos, nFlags)
 RETURN DllExecuteCall(tplLlEnumGetNextEntry, hLlJob, nPos, nFlags)

FUNCTION LlEnumGetEntry(hLlJob, nPos, pszNameBuf, nNameBufSize, pszContBuf, nContBufSize, pHandle, pType)
 RETURN DllExecuteCall(tplLlEnumGetEntry, hLlJob, nPos, @pszNameBuf, nNameBufSize, @pszContBuf, nContBufSize, @pHandle, @pType)

FUNCTION LlPrintResetObjectStates(hLlJob)
 RETURN DllExecuteCall(tplLlPrintResetObjectStates, hLlJob)

FUNCTION LlXSetParameter(hLlJob, nExtensionType, pszExtensionName, pszKey, pszValue)
 RETURN DllExecuteCall(tplLlXSetParameter, hLlJob, nExtensionType, @pszExtensionName, @pszKey, @pszValue)

FUNCTION LlXGetParameter(hLlJob, nExtensionType, pszExtensionName, pszKey, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlXGetParameter, hLlJob, nExtensionType, @pszExtensionName, @pszKey, @pszBuffer, nBufSize)

FUNCTION LlPrintResetProjectState(hJob)
 RETURN DllExecuteCall(tplLlPrintResetProjectState, hJob)

PROCEDURE LlDefineChartFieldStart(hLlJob)
 DllExecuteCall(tplLlDefineChartFieldStart, hLlJob)
 RETURN

FUNCTION LlDefineChartFieldExt(hLlJob, pszVarName, pszContents, lPara, lpPtr)
 RETURN DllExecuteCall(tplLlDefineChartFieldExt, hLlJob, @pszVarName, @pszContents, lPara, lpPtr)

FUNCTION LlPrintDeclareChartRow(hLlJob, nFlags)
 RETURN DllExecuteCall(tplLlPrintDeclareChartRow, hLlJob, nFlags)

FUNCTION LlPrintGetChartObjectCount(hLlJob, nType)
 RETURN DllExecuteCall(tplLlPrintGetChartObjectCount, hLlJob, nType)

FUNCTION LlPrintIsChartFieldUsed(hLlJob, pszFieldName)
 RETURN DllExecuteCall(tplLlPrintIsChartFieldUsed, hLlJob, @pszFieldName)

FUNCTION LlGetChartFieldContents(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetChartFieldContents, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlEnumGetFirstChartField(hLlJob, nFlags)
 RETURN DllExecuteCall(tplLlEnumGetFirstChartField, hLlJob, nFlags)

FUNCTION LlGetPrinterFromPrinterFile(hJob, nObjType, pszObjectName, nPrinter, pszPrinter, pnPrinterBufSize, pDevMode, pnDevModeBufSize)
 RETURN DllExecuteCall(tplLlGetPrinterFromPrinterFile, hJob, nObjType, @pszObjectName, nPrinter, @pszPrinter, @pnPrinterBufSize, pDevMode, @pnDevModeBufSize)

FUNCTION LlPrintGetRemainingSpacePerTable(hLlJob, pszField, nDimension)
 RETURN DllExecuteCall(tplLlPrintGetRemainingSpacePerTable, hLlJob, @pszField, nDimension)

PROCEDURE LlDrawToolbarBackground(hDC, pRC, bHorz, nTBMode)
 DllExecuteCall(tplLlDrawToolbarBackground, hDC, @pRC, bHorz, nTBMode)
 RETURN

FUNCTION LlSetDefaultProjectParameter(hLlJob, pszParameter, pszValue, nFlags)
 RETURN DllExecuteCall(tplLlSetDefaultProjectParameter, hLlJob, @pszParameter, @pszValue, nFlags)

FUNCTION LlGetDefaultProjectParameter(hLlJob, pszParameter, pszBuffer, nBufSize, pnFlags)
 RETURN DllExecuteCall(tplLlGetDefaultProjectParameter, hLlJob, @pszParameter, @pszBuffer, nBufSize, @pnFlags)

FUNCTION LlPrintSetProjectParameter(hLlJob, pszParameter, pszValue, nFlags)
 RETURN DllExecuteCall(tplLlPrintSetProjectParameter, hLlJob, @pszParameter, @pszValue, nFlags)

FUNCTION LlPrintGetProjectParameter(hLlJob, pszParameter, bEvaluated, pszBuffer, nBufSize, pnFlags)
 RETURN DllExecuteCall(tplLlPrintGetProjectParameter, hLlJob, @pszParameter, bEvaluated, @pszBuffer, nBufSize, @pnFlags)

FUNCTION LlExprContainsVariable(hLlJob, hExpr, pszVariable)
 RETURN DllExecuteCall(tplLlExprContainsVariable, hLlJob, hExpr, @pszVariable)

FUNCTION LlExprIsConstant(hLlJob, hExpr)
 RETURN DllExecuteCall(tplLlExprIsConstant, hLlJob, hExpr)

FUNCTION LlProfileStart(hThread, pszDescr, pszFilename, nTicksMS)
 RETURN DllExecuteCall(tplLlProfileStart, hThread, @pszDescr, @pszFilename, nTicksMS)

PROCEDURE LlProfileEnd(hThread)
 DllExecuteCall(tplLlProfileEnd, hThread)
 RETURN

FUNCTION LlDbAddTable(hJob, pszTableID, pszDisplayName)
 RETURN DllExecuteCall(tplLlDbAddTable, hJob, @pszTableID, @pszDisplayName)

FUNCTION LlDbAddTableRelation(hJob, pszTableID, pszParentTableID, pszRelationID, pszRelationDisplayName)
 RETURN DllExecuteCall(tplLlDbAddTableRelation, hJob, @pszTableID, @pszParentTableID, @pszRelationID, @pszRelationDisplayName)

FUNCTION LlDbAddTableSortOrder(hJob, pszTableID, pszSortOrderID, pszSortOrderDisplayName)
 RETURN DllExecuteCall(tplLlDbAddTableSortOrder, hJob, @pszTableID, @pszSortOrderID, @pszSortOrderDisplayName)

FUNCTION LlPrintDbGetCurrentTable(hJob, pszTableID, nTableIDLength, bCompletePath)
 RETURN DllExecuteCall(tplLlPrintDbGetCurrentTable, hJob, @pszTableID, nTableIDLength, bCompletePath)

FUNCTION LlPrintDbGetCurrentTableRelation(hJob, pszRelationID, nRelationIDLength)
 RETURN DllExecuteCall(tplLlPrintDbGetCurrentTableRelation, hJob, @pszRelationID, nRelationIDLength)

FUNCTION LlPrintDbGetCurrentTableSortOrder(hJob, pszSortOrderID, nSortOrderIDLength)
 RETURN DllExecuteCall(tplLlPrintDbGetCurrentTableSortOrder, hJob, @pszSortOrderID, nSortOrderIDLength)

FUNCTION LlDbDumpStructure(hJob)
 RETURN DllExecuteCall(tplLlDbDumpStructure, hJob)

FUNCTION LlPrintDbGetRootTableCount(hJob)
 RETURN DllExecuteCall(tplLlPrintDbGetRootTableCount, hJob)

FUNCTION LlDbSetMasterTable(hJob, pszTableID)
 RETURN DllExecuteCall(tplLlDbSetMasterTable, hJob, @pszTableID)

FUNCTION LlDbGetMasterTable(hJob, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlDbGetMasterTable, hJob, @pszBuffer, nBufSize)

FUNCTION LlXSetExportParameter(hLlJob, pszExtensionName, pszKey, pszValue)
 RETURN DllExecuteCall(tplLlXSetExportParameter, hLlJob, @pszExtensionName, @pszKey, @pszValue)

FUNCTION LlXGetExportParameter(hLlJob, pszExtensionName, pszKey, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlXGetExportParameter, hLlJob, @pszExtensionName, @pszKey, @pszBuffer, nBufSize)

FUNCTION LlXlatName(hLlJob, pszName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlXlatName, hLlJob, @pszName, @pszBuffer, nBufSize)

FUNCTION LlDesignerProhibitEditingObject(hLlJob, pszObject)
 RETURN DllExecuteCall(tplLlDesignerProhibitEditingObject, hLlJob, @pszObject)

FUNCTION LlGetUsedIdentifiers(hLlJob, pszProjectName, pszBuffer, nBufSize)
 RETURN DllExecuteCall(tplLlGetUsedIdentifiers, hLlJob, @pszProjectName, @pszBuffer, nBufSize)

FUNCTION LlInternalAttachApp(hLlJob, hLlJobToAttach)
 RETURN DllExecuteCall(tplLlInternalAttachApp, hLlJob, hLlJobToAttach)

FUNCTION LlInternalDetachApp(hLlJob, hLlJobToDetach)
 RETURN DllExecuteCall(tplLlInternalDetachApp, hLlJob, hLlJobToDetach)

*
**
FUNCTION LlSetNotificationCallback(hLlJob, nMessage)
 RETURN DllExecuteCall(tplLlSetNotificationCallback, hLlJob, nMessage)

FUNCTION LlSetNotificationCallbackExt(hLlJob,nEvent, nMessage)
 RETURN DllExecuteCall(tplLlSetNotificationCallbackExt, hLlJob, nEvent, nMessage)


