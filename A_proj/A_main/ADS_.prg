;#include "ads.ch"
#include "common.ch"
#include "dll.ch"
#include "dmlb.ch"
#include "error.ch"

#include "adsdbe.ch"
#include "..\A_main\ace.ch"


#define ACE_SUCCESS      0
#define ADSDLL           "ACE32.DLL"
//#define ADSDLL           "ACE64.DLL"



/*------------------- MODULE GLOBAL DATA -------------------*/
/*
 * store handles and DLL calls in STATICs for high performance
 */
STATIC snAdsDllHandle      := 0
STATIC scDllGetTblHandle   := ""
STATIC scDllGetLastError   := ""
STATIC scDllGetIdxHandle   := ""

STATIC scDllSetScope       := ""
STATIc scDllGetScope       := ""
STATIC scDllClearScope     := ""

STATIC scDllGotoTop        := ""
STATIC scDllGotoBottom     := ""
STATIC scDllGotoRecord     := ""

STATIC scDllSkip           := ""

STATIC scDllGetRecordCount := ""
STATIC scDllGetKeyCount    := ""

STATIC scDllAtEOF          := ""
STATIC scDllAtBOF          := ""

STATIC scDllCloseTable     := ""
STATIC scDllCloseAllTables := ""

STATIC scDllUnlockRecord   := ""


DLLFUNCTION AdsRegisterCallbackFunction(nCallback, nParam) USING STDCALL FROM ACE32.DLL
DLLFUNCTION AdsClearCallbackFunction()                     USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsSetAOF( nTable, @cBuffer, nOptions ) USING STDCALL FROM ACE32.DLL


/*------------------- INIT/EXIT PROC'S  -------------------*/
INIT PROCEDURE ADSEXTI()
    snAdsDllHandle      := DllLoad( ADSDLL )

  scDllGetTblHandle   := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetTableHandle" )
  scDllGetIdxHandle   := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetIndexHandle" )
  scDllGetLastError   := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetLastError"   )

  scDllSetScope       := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsSetScope"       )
  scDllGetScope       := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetScope"       )
  scDllClearScope     := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsClearScope"     )

  scDllGotoTop        := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoTop"        )
  scDllGotoBottom     := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoBottom"     )
  scDllGotoRecord     := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoRecord"     )

  scDllSkip           := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsSkip"           )

  scDllAtEOF          := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsAtEOF"          )
  scDllAtBOF          := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsAtBOF"          )

  scDllGetRecordCount := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetRecordCount" )
  scDllGetKeyCount    := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsGetKeyCount"    )

  scDllCloseTable     := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsCloseTable"     )
  scDllCloseAllTables := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsCloseAllTables" )

  scDllUnlockRecord   := DllPrepareCall( snAdsDllHandle, DLL_STDCALL, "AdsUnlockRecord"   )
RETURN


EXIT PROCEDURE ADSEXTE()
   DllUnload( snAdsDllHandle )
RETURN


/*------------------- FORMAT FUNCTION FOR AOF/LOCATE .. ----------------------*/
FUNCTION Format(S,ARG)
  LOCAL x, cFs := S, xVal, cTa

  FOR x := LEN(ARG) TO 1 STEP -1
    (xVal := ARG[x], cTa := ValType(xVal))
    DO CASE
    CASE( cTa == 'N')  ;  xVal := STR(xVal)
    CASE( cTa == 'C')
    CASE( cTa == 'D')  ;  xVal := DtoC(xVal)
    CASE( cTa == 'L')  ;  xVal := IF(xVal, '.T.', '.F.')
    ENDCASE

    cFs := StrTran(cFs,'%%',xVal,x,1)
  NEXT
RETURN(cFs)


/*------------------- LOCAL FUNCTIONS   -------------------*/
STATIC FUNCTION AdsExtErrorCheck( rc, nIgnoreError )
   LOCAL oErr
   LOCAL nLen    := 0
   LOCAL cBuffer := Space(128)
   LOCAL cWord   := W2Bin(Len(cBuffer))   /* 16 bit buffer */

   IF nIgnoreError == NIL
      nIgnoreError := 0
   ENDIF

   IF rc != ACE_SUCCESS .AND. rc != nIgnoreError
      DllExecuteCall( scDllGetLastError, @rc, @cBuffer, @cWord )
      nLen               := Bin2W( cWord )
      cBuffer            := SubStr( cBuffer, 1, nLen )
      oErr               := Error():new()
      oErr:genCode       := XPP_ERR_NOTABLE
      oErr:description   := cBuffer
      oErr:subCode       := rc
      oErr:canDefault    := .F.
      oErr:canRetry      := .F.
      oErr:canSubstitute := .T.
      oErr:operation     := ProcName(2) + "(" + LTrim(Str(ProcLine(2))) + ")"
      oErr:subSystem     := ADSDLL
      RETURN Eval( ErrorBlock(), oErr )
   ENDIF
RETURN rc


// get table handle of current workarea //
function AdsExtGetTableHandle()
  local  nHandle := 0, cFile := Alias(Select())

  nHandle := (cFile)->(DbInfo(ADSDBO_TABLE_HANDLE))
return nHandle


// get handle of controlling index of the current workarea //
STATIC FUNCTION AdsExtGetIndexHandle( nTblHandle )
   LOCAL nHandle := 0, rc
   LOCAL cIndex  := OrdName()

   rc := DllExecuteCall( scDllGetIdxHandle, nTblHandle, @cIndex, @nHandle )
   AdsExtErrorCheck( rc )
RETURN nHandle


FUNCTION Ads_GetKeyCount(nFilterOption)
  LOCAL rc, hIndex
  LOCAL nKEYcount := 0

  DEFAULT nFilterOption TO ADS_IGNOREFILTERS

  hIndex := AdsExtGetIndexHandle( AdsExtGetTableHandle() )
  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetKeyCount", hIndex, nFilterOption, @nKEYcount )
  AdsExtErrorCheck( rc )
RETURN nKEYcount


function Ads_getLastAutoinc()
  LOCAL  hTable  := AdsExtGetTableHandle(), rc
  LOCAL  cFile   := Alias(Select())
  LOCAL  pulAutoIncVal := 0

  if .not. (cfile)->( eof())
    rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetLastAutoinc", hTable, @pulAutoIncVal )
    AdsExtErrorCheck( rc )
  endif
RETURN pulAutoIncVal


// AOF //
FUNCTION Ads_SetAOF(cFILTER)
  LOCAL hTable := AdsExtGetTableHandle(), rc
  LOCAL cBuffer := cFILTER

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsSetAOF", hTable, @cBuffer, ADS_RESOLVE_IMMEDIATE)
  AdsExtErrorCheck( rc )
RETURN .T.


FUNCTION Ads_GetAOF()
  LOCAL hTable := AdsExtGetTableHandle(), rc
  LOCAL cFilter := SPACE(512)
  LOCAL nLen := 512, nPos

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetAOF", hTable, @cFilter, @nLen )

  IF rc = ACE_SUCCESS
    IF ( nPos := AT( CHR(0), cFilter ) ) > 0
      cFilter := SUBSTR(cFilter, 1, nPos-1 )
    ENDIF
    cFilter := TRIM(cFilter)
  ENDIF
RETURN TRIM(cFilter)


FUNCTION Ads_ClearAOF()
  LOCAL rc, hTable := AdsExtGetTableHandle()

  IF ! EMPTY(Ads_GetAOF())
    rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsClearAOF", hTable )
    AdsExtErrorCheck( rc )
 ENDIF
RETURN NIL


function Ads_GetAOFOptLevel()
  local  rc, hTable := AdsExtGetTableHandle()
  local  cBuf := SPACE(256), nBuf := 256
  local  nOptLevel := 0

  if .not. empty(Ads_GetAOF())
    rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetAOFOptLevel", hTable, @nOptLevel, @cBuf, @nBuf )
    AdsExtErrorCheck( rc )
  endif
return noptLevel


function Ads_IsRecordInAOF( recNo )
  local  rc, hTable := AdsExtGetTableHandle()
  local  bIsInAOF := .T.

  if .not. empty(Ads_GetAOF())
    rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsIsRecordInAOF", hTable, recNo, @bIsInAOF)
    AdsExtErrorCheck( rc )
  endif
return bIsInAOF


function Ads_CustomizeAOF( pulRecords, usOption )
  local  rc := 0, hTable := AdsExtGetTableHandle()
  *
  local  x, pRecord

  default usOption TO ADS_AOF_ADD_RECORD

  if .not. empty(Ads_GetAOF())
    for x := 1 to len(pulRecords) step 1
      pRecord := pulRecords[x]

      rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCustomizeAOF", hTable, 1, @pRecord, usOption)
    next
    AdsExtErrorCheck( rc )
  endif
return nil


function Ads_evalAOF(cFilter)
  LOCAL hTable    := AdsExtGetTableHandle(), rc
  LOCAL pucFilter := cFilter, pusOptLevel := 0

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsEvalAOF", hTable, @pucFilter, @pusOptLevel)
  AdsExtErrorCheck( rc )
RETURN pusOptLevel


function Ads_RefreshAOF()
  LOCAL hTable    := AdsExtGetTableHandle(), rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsRefreshAOF", hTable)
  AdsExtErrorCheck( rc )
return nil


** AdsEvalAOF  (ADSHANDLE hTable, UNSIGNED8 *pucFilter,  UNSIGNED16 *pusOptLevel);
*/
// AOF //


// LOCATE //
FUNCTION Ads_Locate(cLOCATe)
  LOCAL  hTable  := AdsExtGetTableHandle()
  LOCAL  rc, cBuffer := cLOCATe
  LOCAL  bFound := .F.

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsLocate", hTable, @cBuffer, TRUE, @bFound)
  AdsExtErrorCheck( rc )
RETURN bFound
// LOCATE //


// SCOPE //
FUNCTION Ads_SetScope( nScopeType, xScope )
   LOCAL rc, hIndex
   LOCAL cLen, nLen, nType, cType
   LOCAL cBuffer /* decouple passed value (ANSI/OEM conv!) */

   hIndex := AdsExtGetIndexHandle( AdsExtGetTableHandle() )

   IF PCount() == 1
      cBuffer := space(128)
      cLen    := W2Bin(len(cBuffer))

      rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetScope", hIndex, ;
                                               nScopeType, @cBuffer, @cLen )
      AdsExtErrorCheck( rc, AE_NO_SCOPE )

      cBuffer := SubStr( cBuffer, 1, Bin2W(cLen))
      RETURN cBuffer
   ENDIF

   cType := Valtype( xScope )

   /* check type of scope value and convert to character */
   DO CASE
   CASE cType == "C"
      nLen   := Len( xScope )
      nType  := ADS_STRINGKEY

      /* convert to ANSI if we are running OEM */
      IF Set( _SET_CHARSET ) == CHARSET_OEM
         cBuffer := ConvToAnsiCp( xScope )
      ELSE
         cBuffer := xScope
      ENDIF

   CASE cType == "D"
      nLen    := 8
      nType   := ADS_STRINGKEY
      cBuffer := DTOS( xScope )

   CASE cType == "L"
      nLen    := 1
      nType   := ADS_STRINGKEY
      cBuffer := IIF( xScope, "T", "F" )

   CASE cType == "N"
      cBuffer    := f2bin( xScope )
      nLen       := LEN( cBuffer )
      nType      := ADS_DOUBLEKEY

   OTHERWISE
       RETURN NIL
   ENDCASE

   rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsSetScope", hIndex, nScopeType, @cBuffer, nLen, nType )
   AdsExtErrorCheck( rc )
RETURN xScope


FUNCTION Ads_ClearScope(nScopeType)
   LOCAL rc, hIndex

   IF nScopeType == NIL
      RETURN .F.
   ENDIF

   hIndex := AdsExtGetIndexHandle( AdsExtGetTableHandle() )

   rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsClearScope", hIndex, nScopeType )
   AdsExtErrorCheck( rc )
RETURN rc == ACE_SUCCESS


function Ads_ClearAllScope()
  LOCAL  hTable  := AdsExtGetTableHandle()

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsClearAllScopes", hTable)
  AdsExtErrorCheck( rc )
RETURN .t.
// SCOPE //


*
** RELATION      **
function Ads_SetRelation(calias, crelation, tagName)
  local  rc, cbuffer := crelation
  local  hTable := AdsExtGetTableHandle(), hrelTable, hIndex
  *
  **
  local  cBuff := space(128)
  local  cLen  := W2Bin(len(cBuff))
  *
  local  ntag  := 0


  if( .not. empty(tagName), (calias)->(ordSetFocus( tagName)), nil )

  hrelTable := (calias)->(AdsExtGetTableHandle())
  hIndex    := (calias)->(AdsExtGetIndexHandle(hrelTable))

/*
  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetTableFilename", hTable, ADS_FULLPATHNAME, @cBuff, cLen )
  cBuff := SubStr( cBuff, 1, Bin2W(cLen))


  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetIndexFilename", hIndex, ADS_FULLPATHNAME, @cBuff, cLen )
  cBuff := SubStr( cBuff, 1, Bin2W(cLen))

  cBuff := space(128)
  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetIndexOrderByHandle", hIndex, @ntag )
*/


  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsSetRelation", hTable, hIndex, @cbuffer )
  AdsExtErrorCheck( rc )
return nil


*
** DELETE RECORD **
function Ads_DeleteRecord()
  local  hTable  := AdsExtGetTableHandle()
  local  rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDeleteRecord", hTable)
  AdsExtErrorCheck( rc )
RETURN .T.


*
** RECORD COUNT **
function Ads_GetRecordCount(filterOption,hTable)
  LOCAL rc  // , hTable := AdsExtGetTableHandle()
  LOCAL recCount := 0

  DEFAULT filterOption TO ADS_RESPECTFILTERS, ;
          hTable       TO AdsExtGetTableHandle()

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetRecordCount", hTable, filterOption, @recCount )
  AdsExtErrorCheck( rc )
RETURN recCount

*
** DBGOTOP **
function Ads_GotoTop(byIndex)
  LOCAL rc, hTable, hIndex

  default byIndex to .f.

  hTable := AdsExtGetTableHandle()
  hIndex := AdsExtGetIndexHandle(hTable)

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoTop", if( byIndex, hIndex, hTable) )
  AdsExtErrorCheck( rc )
RETURN .T.


function AdsGotoRecord( ulRec, goTop )
  local  rc, hTable := AdsExtGetTableHandle()

  default goTop to .t.

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoRecord", hTable, ulRec )

  if rc <> 0
    if( goTop, dbgoTop(), dbgoBottom() )
  endif
return NIL


*
** DBGOBOTTOM **
function Ads_GotoBottom()
  local  rc, hTable := AdsExtGetTableHandle()

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGotoBottom", hTable )
  AdsExtErrorCheck( rc )
RETURN .T.


*
** FILE INDEX NAME **
function Ads_GetIndexFilename(nOptions)
  local  rc, buffer := space(512), len := 512, hIndex := AdsExtGetIndexHandle( AdsExtGetTableHandle())

  default nOptions to ADS_FULLPATHNAME

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetIndexFilename", hIndex, nOptions, @buffer, @len )
  AdsExtErrorCheck( rc )
return buffer


*
**
static function AdsCreateIndex( pucFileName , ;
                          pucTag      , ;
                          pucKeyExpr  , ;
                          pucCondition, ;
                          pucWhile    , ;
                          ulOptions     )

  local  rc, hTable :=  AdsExtGetTableHandle()
  *
  local  phIndex := 0

  default ulOptions to ADS_COMPOUND

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCreateIndex", ;
                                              hTable          , ;
                                              @pucFileName    , ;
                                              @pucTag         , ;
                                              @pucKeyExpr     , ;
                                              @pucCondition   , ;
                                              pucWhile        , ;
                                              ulOptions       , ;
                                              @phIndex          )

  AdsExtErrorCheck( rc )
return phIndex


*
**
static function AdsCloseIndex( hIndex )
  local  rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCloseIndex", hIndex )
return nil



function AdsAtEOF()
 local  rc, hTable := AdsExtGetTableHandle()
 local  nrecs := 0

 rc := DllExecuteCall( scDllAtEOF, hTable, @nrecs )
return ( nrecs = 0)


*
** tady budeme psát pomocné funkce pro API -> ALASKA
static function par_setScope(xScope, pcBuffer, pnLen, pnType)
  local cType := Valtype( xScope )

   * check type of scope value and convert to character
   DO CASE
   CASE cType == "C"
      pnLen   := Len( xScope )
      pnType  := ADS_STRINGKEY

      * convert to ANSI if we are running OEM
      IF Set( _SET_CHARSET ) == CHARSET_OEM
         pcBuffer := ConvToAnsiCp( xScope )
      ELSE
         pcBuffer := xScope
      ENDIF

   CASE cType == "D"
      pnLen    := 8
      pnType   := ADS_STRINGKEY
      pcBuffer := DTOS( xScope )

   CASE cType == "L"
      pnLen    := 1
      pnType   := ADS_STRINGKEY
      pcBuffer := IIF( xScope, "T", "F" )

   CASE cType == "N"
      pcBuffer    := f2bin( xScope )
      pnLen       := LEN( pcBuffer )
      pnType      := ADS_DOUBLEKEY

   oTHERWISE
      RETURN .f.

   ENDCASE
Return .t.


static function info_Scope( nSetScope, aScope)
  local cFile := lower(Alias(Select()))
  local obj   := ThreadObject(), paFiles
  *

  default nSetScope to 0

  * 1 - ukládám   scope
  * 2 - ruším     scope
  * 3 - nastavený scope ?
  * 4 - vrátím    xscope_Top / xcsope_Bottom

  if obj:className() = 'drgDialogThread'
     paFiles := obj:paFiles
     nPos    := AScan(paFiles, {|x| lower(x[1]) = cFile })

     do case
     case nSetScope > 0 .and. isArray(aScope)
       if nPos = 0
          AAdd( paFiles, { cFile, aScope[1], aScope[2] })
       else
         paFiles[nPos,2] := aScope[1]
         paFiles[nPos,3] := aScope[2]
       endif
       return nil

     otherwise
       if nPos <> 0

         do case
         case nSetScope < 0
           paFiles[nPos,2] := aScope[1]
           paFiles[nPos,3] := aScope[2]

           if( paFiles[nPos,2] = -1 .and. paFiles[nPos,3] = -1)
             ARemove( paFiles, nPos )
           endif
           return nil

         case empty(nSetScope)
           return  (npos <> 0)

         case nSetScope = SCOPE_TOP
           return paFiles[nPos,2]

         case nSetScope = SCOPE_BOTTOM
            return paFiles[nPos,3]

         case nSetScope = SCOPE_BOTH
            return {paFiles[nPos,2], paFiles[nPos,3]}

         endcase
       endif
     endcase
   endif
return nil

*
**
function DbScope(nScope)
   if nScope = nil
     return IsNull(info_Scope(), .f.)        //  lIsScope
   endif

   if nScope = SCOPE_TOP
     return info_Scope(nScope)              //  xscope_Top
   endif

   if nScope = SCOPE_BOTTOM
     return info_Scope(nScope)              //  xscope_Bottom
   endif

   if nScope = SCOPE_BOTH
     return info_Scope(nScope)             // { xscope_Top, xscope_Bottom}
   endif
return nil

*
**
function dbSetScope(nScope,xValue)
  local  cBuffer, nLen, nType
  local  hIndex := OrdInfo(ADSORD_INDEX_HANDLE)
  *
  local  aScope    := {,}

  if par_setScope(xValue, @cBuffer, @nLen, @nType)
    if nScope = SCOPE_TOP    .or. nScope = SCOPE_BOTH
      DllExecuteCall( scDllSetScope, hIndex, 1, @cBuffer, nLen, nType )
      aScope[1] = xValue
    endif

    if nScope = SCOPE_BOTTOM .or. nScope = SCOPE_BOTH
      DllExecuteCall( scDllSetScope, hIndex, 2, @cBuffer, nLen, nType )
      aScope[2] := xValue
    endif

    info_Scope( 1, aScope )
  endif
return nil

*
**
function DbClearScope(nScope)
  local hIndex := OrdInfo(ADSORD_INDEX_HANDLE)
  local aScope := {,}

  default nScope to SCOPE_BOTH

  if nScope = SCOPE_TOP    .or. nScope = SCOPE_BOTH
    DllExecuteCall( scDllClearScope, hIndex, 1)
    aScope[1] := -1
  endif

  if nScope = SCOPE_BOTTOM .or. nScope = SCOPE_BOTH
    DllExecuteCall( scDllClearScope, hIndex, 2)
    aScope[2] := -1
  endif

  info_Scope( -1, aScope)
return nil


*
** náhrada INDEX ON ... ADDITIVE
function Ads_CreateTmpIndex(pucFileName, pucTag, pucKeyExpr, pucCondition, pucWhile, ulOptions, ulCloseIndex)
  local cfile  := Alias( Select() )
  local hIndex, nin, file
  *
  local hTable :=  AdsExtGetTableHandle()

  default pucCondition to '', ;
          pucWhile     to '', ;
          ulOptions    to ADS_COMPOUND + ADS_NOT_AUTO_OPEN, ;
          ulCloseIndex to .t.

  hIndex := AdsCreateIndex(pucFileName , ;
                           pucTag      , ;
                           pucKeyExpr  , ;
                           pucCondition, ;
                           pucWhile    , ;
                           ulOptions     )


  *
  ** musíme zavøít soubor, ale nezrušit
  if ulCloseIndex
    DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCloseIndex", hIndex )
  endif

  (cfile)->(ordListClear())
  (cfile)->(ordListAdd( pucFileName, pucTag ))
return hIndex


function AdsAddCustomKey( hIndex )
  local  rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsAddCustomKey", hIndex )
return nil


function AdsGetAllLocks()
  local  rc, hTable :=  AdsExtGetTableHandle()
  *
  local  aulLocks := space(128), pusArrayLen := 128
  local   paLocks := {}, nLocks := 0

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetAllLocks", ;
                                              hTable          , ;
                                              @aulLocks       , ;
                                              @pusArrayLen      )
  *
  ** OK
  if rc = 0 .and. pusArrayLen <> 0
    aulLocks := strTran( trim( aulLocks ), chr(0) +chr(0), ';' )
    aulLocks := substr( aulLocks, 1, len(aulLocks) -1)
    aulLocks := listAsArray( aulLocks, ';' )
    AEval( aulLocks, {|x,i| aulLocks[i] := Bin2W(x) } )
  else
    aulLocks    := {}
    pusArrayLen := 0
  endif
return { aulLocks, pusArrayLen }


function AdsConvertTable( pucFile, usFilterOption, usTableType )
  local  rc, hobj :=  AdsExtGetTableHandle()

  default usFilterOption to ADS_IGNOREFILTERS , ;
          usTableType    to ADS_CDX

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsConvertTable", ;
                                               hObj            , ;
                                               usFilterOption  , ;
                                               @pucFile        , ;
                                               usTableType       )
  AdsExtErrorCheck( rc )
return nil


function Ads_convertTable( hObj, usFilterOption, pucFile, usTableType)
  local  rc

  default usFilterOption to ADS_IGNOREFILTERS , ;
          usTableType    to ADS_CDX

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsConvertTable", ;
                                               hObj            , ;
                                               usFilterOption  , ;
                                               @pucFile        , ;
                                               usTableType       )
  AdsExtErrorCheck( rc )
return nil

function AdsCopyTable( hObj, usFilterOption, pucFile )
  local  rc

  default usFilterOption to ADS_IGNOREFILTERS

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCopyTable", ;
                                               hObj            , ;
                                               usFilterOption  , ;
                                               @pucFile         )
  AdsExtErrorCheck( rc )
return nil


*
** pozor, tato èást je urèena pro reintalaci
********************************************************************************
function AdsCloseTable( hTable )

  if( isNull( hTable ), hTable := AdsExtGetTableHandle(), nil )

  rc := DllExecuteCall( scDllCloseTable, hTable )
**  AdsExtErrorCheck( rc )
return nil

function AdsGetTableHandle( pucName )
  local  rc, nHandle := 0

  rc := DllExecuteCall( scDllGetTblHandle, @pucName, @nHandle )
**  AdsExtErrorCheck( rc )
return nHandle


function AdsCloseSQLStatement ( hStatement )
  local nError

  nError := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCloseSQLStatement", ;
                                                   hStatement             )
return nError


function AdsCreateSQLStatement( hConnect, phStatement )
  local  rc

   rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCreateSQLStatement", ;
                                                hConnect              , ;
                                                @phStatement            )
  AdsExtErrorCheck( rc )
return rc


function AdsVerifySQL( hStatement, pucSQL )
  local rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsVerifySQL", ;
                                               hStatement   , ;
                                               @pucSQL        )
  AdsExtErrorCheck( rc )
return rc


function AdsExecuteSQLDirect( hStatement, pucSQL, phCursor )
  local  rc

   rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsExecuteSQLDirect", ;
                                                hStatement          , ;
                                                @pucSQL             , ;
                                                @phCursor             )
  AdsExtErrorCheck( rc )
return rc


function AdsGetField ( hTable, pucFldName)
  local pucBuf   := space( 1024 )   // ADS_DD_MAX_OBJECT_NAME_LEN)
  local puLen    := 1024            // ADS_DD_MAX_OBJECT_NAME_LEN
  local usOption := ADS_NONE        // ADS_RTRIM   // ADS_NONE

  nError := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsGetField", ;
                                                   hTable      , ;
                                                   @pucFldName , ;
                                                   @pucBuf     , ;
                                                   @puLen      , ;
                                                   usOption      )

return {pucBuf, puLen}


function AdsSetField ( hObj, pucFldName, pucValue, ulLen)
  nError := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsSetField", ;
                                                   hObj        , ;
                                                   @pucFldName , ;
                                                   @pucValue   , ;
                                                    ulLen        )
return nil


function AdsConnect60( pucConnectPath, usServerTypes, pucUserName, pucPassword, ulOptions )
  local  phConnect := 0, rc

  default usServerTypes to ADS_REMOTE_SERVER , ;
          pucUserName   to 'ADSSYS'          , ;
          pucPassword   to ''                , ;
          ulOptions     to ADS_DEFAULT

  rc := DllCall(  snAdsDllHandle, DLL_STDCALL, "AdsConnect60"  , ;
                                               @pucConnectPath , ;
                                               usServerTypes   , ;
                                               @pucUserName    , ;
                                               @pucPassword    , ;
                                               ulOptions       , ;
                                               @phConnect        )
return phConnect


function AdsDisconnect( hConnect )
  local rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDisconnect" , ;
                                              hConnect          )
return nil


** Data Distionary - DD
function AdsDDCreate(cDictionaryPath, nEnscrypt, cDescription)
  local  hAdminConn := 0

  default nEnscrypt to 0, cDescription to ''

  DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDCreate"   , ;
                                        cDictionaryPath , ;
                                        nEnscrypt       , ;
                                        @cDescription   , ;
                                        @hAdminConn       )
return hAdminConn


function AdsDDGetDatabaseProperty( hDBConn, usPropertyID, pvProperty, pusPropertyLen )
  local  rc
  *
  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDGetDatabaseProperty" , ;
                                              hDBconn                    , ;
                                              usPropertyID               , ;
                                              @pvProperty                , ;
                                              @pusPropertyLen              )
return pvProperty


function AdsDDSetDatabaseProperty( hAdminConn    , ;
                                   usPropertyID  , ;
                                   pvProperty    , ;
                                   usPropertyLen   )

  default usPropertyID  to ADS_DD_ENCRYPT_TABLE_PASSWORD, ;
          usPropertyLen to 0

  if empty(usPropertyLen)
    if isNumber(pvProperty)
      usPropertyLen := len( allTrim( str(pvProperty))) +1
    else
      usPropertyLen := len(pvProperty) +1
    endif
  endif

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDSetDatabaseProperty" , ;
                                               hAdminConn                , ;
                                               usPropertyID              , ;
                                               @pvProperty               , ;
                                               usPropertyLen               )
return nil


function AdsDDSetTableProperty( hAdminConn      , ;
                                pucTableName    , ;
                                usPropertyID    , ;
                                pvProperty      , ;
                                usPropertyLen   , ;
                                usValidateOption, ;
                                pucFailTable      )
  *
  local rc

  default usValidateOption  to nil , ;
          pucFailTable      to ''

  if usPropertyID = ADS_DD_TABLE_AUTO_CREATE
    usPropertyLen := 2
  else
    usPropertyLen := len(pvProperty) +1
  endif


  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDSetTableProperty", ;
                                              hAdminConn             , ;
                                              @pucTableName          , ;
                                              usPropertyID           , ;
                                              @pvProperty            , ;
                                              usPropertyLen          , ;
                                              usValidateOption       , ;
                                              @pucFailTable            )
return rc


function AdsDDRemoveIndexFile( hAdminConn      , ;
                               pucTableName    , ;
                               pucIndexFileName  )
  local rc, usDeleteFile := 1

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDRemoveIndexFile", ;
                                               hAdminConn           , ;
                                               @pucTableName        , ;
                                               @pucIndexFileName    , ;
                                               usDeleteFile           )
return rc


function AdsDDGetTriggerProperty( pucTriggerName, ;
                                  usPropertyID  , ;
                                  pvProperty    , ;
                                  pusPropertyLen  )

  local rc, hObject := oSession_data:getConnectionHandle()

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsDDGetTriggerProperty", ;
                                               hObject                 , ;
                                               @pucTriggerName         , ;
                                               usPropertyID            , ;
                                               @pvProperty             , ;
                                               @pusPropertyLen           )

***  AdsExtErrorCheck( rc )
return pvProperty




/**********************************
function AdsMgGetOpenTables( hMgmtConnect    , ;
                             pucUserName     , ;
                             usConnNumber      )


  local  astOpenTableInfo  := space(1024)  //   := array( 1000, 2)
  local  pusArrayLen       := 1024         // 1000
  local  pusStructSize     := 2

*  default pucUserName  to ''  , ;
*          usConnNumber to 0


  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsMgGetOpenTables"   , ;
                                              hMgmtConnect           , ;
                                                                     , ;
                                              usConnNumber           , ;
                                              astOpenTableInfo       , ;
                                              @pusArrayLen           , ;
                                              @pusStructSize           )

return 0
*/

/*

nRC := AdsMgGetOpenTables(::nHandle,,,aArray , @nAmount)


AdsMgGetOpenTables ( ADSHANDLE hMgmtConnect,
                     UNSIGNED8 *pucUserName,
                     UNSIGNED16 usConnNumber,
                     ADS_MGMT_TABLE_INFO astOpenTableInfo[],
                     UNSIGNED16 *pusArrayLen,
                     UNSIGNED16 *pusStructSize );
Parameters

*/



*
** tato funkce nahrazuje ordSetFocus( nIndex ) - DbSetOrder( nIndex )
**
*  pøí rekonstrukci ADI souborù dojde k posunu TAGu a nelze použít
*  nIndex pouze cTagName pro správné pøepnutí na TAG
**
function AdsSetOrder( xTagName )
  local cfile, ctagName, cold_TagName

  if isNumber( xTagName )
    if xTagName <> 0
      cfile    := parseFileName( DbInfo( DBO_FILENAME ), 1)
      ctagName := drgDBMS:getTagByOrder( cfile, xTagName )
    else
      ctagName := xTagName
    endif
  else
    ctagName := xTagName
  endif

  cold_TagName := ordSetFocus( ctagName )
return cold_TagName


*
** tato funkce pøekrývá numerický parametr v DbSeek( InexKeyVaue, lSOftSeek, nIndex ...
*                                                                            ******
function AdsCtag( xTagName )
  local cfile, ctagName := xTagName

  if isNumber( xTagName )
    cfile    := parseFileName( DbInfo( DBO_FILENAME ), 1)
    ctagName := drgDBMS:getTagByOrder( cfile, xTagName )

    * nenašel se v DBD vrátil 0 -- pojedeme na nIndex
    if( isNumber( ctagName ), ctagName := xTagName, nil )
  endif
return ctagName


function Ads_SetTimeStamp( fldName )
  local  rc, hTable := AdsExtGetTableHandle()
  local  cdate_time := dtoc(date()) +' ' +time()
  local  nlen       := len(cdate_time)

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsSetTimeStamp", hTable, @fldName, @cdate_time, nlen)
  AdsExtErrorCheck( rc )
return nil


*
** transakce
*
function Ads_BeginTransaction( hConnect )
  local  rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsBeginTransaction", hConnect)

  AdsExtErrorCheck( rc )
return nil


function Ads_CommitTransaction( hConnect)
  local rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsCommitTransaction", hConnect)

  AdsExtErrorCheck( rc )
return nil


function Ads_RollbackTransaction( hConnect)
  local rc

  rc := DllCall( snAdsDllHandle, DLL_STDCALL, "AdsRollbackTransaction", hConnect)

  AdsExtErrorCheck( rc )
return nil