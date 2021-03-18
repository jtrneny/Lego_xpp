/*
 ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
 º  Program..: ADS.PRG                                      º
 º  Author...:  Roger J. Donnay                             º
 º  Notice...: (c) DONNAY Software Designs 1987-2010        º
 º  Date.....: Sept 16, 2010                                º
 º  Notes....: Advantage Server (ACE32.DLL)                 º
 º             Wrapper Functions                            º
 ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½

 A complete set of client functions for the Advantage Database
 server exists in ACE32.DLL.  This dynamic link library is
 included with the ADSDBE available from Alaska Software.  The
 below set of ADS*() DLLFUNCTION wrappers and AX_*() wrappers
 provide a much simpler interface to this robust database
 library.  The AX_*() wrappers are designed to be equivalent
 functions to those which exist in the Clipper 5.x client
 library.  To use this library in Xbase++ applications, include
 the DCLIPX.LIB file in your link script or project file and
 make sure that DCLIPX.DLL exists in your workstations search
 path.

 The complete set of AdsMg*() function wrappers is included
 with the ADSDBE product available from Alaska Software
 therefore they are not included here.  To use AdsMg*()
 functions in your application, include the ADSMG.LIB in
 your link script or project file and make sure that ADSMG.DLL
 exists in your workstation search path.

 The documentation for AX_() functions is included with the
 Clipper client kit available from Extended Systems.   The
 documentation for ADS*() functions is included with the
 ACE32 SDK also available from Extended Systems, therefore the
 functions are not documented here.  The ACE32 Client SDK is
 free.  Just visit http://www.advantagedatabase.com
*/


#INCLUDE "dll.ch"
#INCLUDE "common.ch"
#include 'dmlb.ch'
#include 'dbfdbe.ch'
#INCLUDE "appevent.CH"
//#INCLUDE "dcads.CH"

#pragma library("ADAC20B.LIB")

STATIC snHDll

* ---------------

#command  ACEFUNCTION <Func>([<x,...>]) ;
       => ;
FUNCTION <Func>([<x>]);;
STATIC scHCall ;;
IF scHCall == nil ;;
  IF snHdll == nil ;;
    snHDll := DllLoad('ACE32.DLL') ;;
  ENDIF ;;
  scHCall := DllPrepareCall(snHDll,DLL_STDCALL,<(Func)>) ;;
ENDIF ;;
RETURN DllExecuteCall(scHCall,<x>)

* ----------------

#define KEYWORD_SELECT "SELECT"

* ------ ADS Driver Functions ------ *
/*
AdsApplicationExit
AdsBeginTransaction
AdsCacheOpenTables
AdsCheckExistence
AdsClearDefault
AdsClearProgressCallback
AdsCommitTransaction
AdsConnect
AdsConnect26
AdsConnect60
AdsDisconnect
AdsFailedTransactionRecovery
AdsFindConnection
AdsFindConnection25
AdsGetAllTables
AdsGetCollationLang
AdsGetConnectionType
AdsGetDateFormat
AdsGetDecimals
AdsGetDefault
AdsGetDeleted
AdsGetEpoch
AdsGetErrorString
AdsGetExact
AdsGetExact22
AdsGetLastError
AdsGetNumOpenTables
AdsGetSearchPath
AdsGetServerName
AdsGetServerTime
AdsGetVersion
AdsInTransaction
AdsIsServerLoaded
AdsNullTerminateStrings
AdsRegisterProgressCallback
AdsRollbackTransaction
AdsSetCollationLang
AdsSetDateFormat
AdsSetDecimals
AdsSetDefault
AdsSetEpoch
AdsSetExact
AdsSetExact22
AdsSetSearchPath
AdsSetServerType
AdsShowDeleted
AdsShowError
AdsThreadExit
AdsWriteAllRecords
*/

ACEFUNCTION AdsApplicationExit()

ACEFUNCTION AdsBeginTransaction( nHandle )

ACEFUNCTION AdsCommitTransaction( nHandle )

ACEFUNCTION AdsCheckExistence( nHandle, cFileName, @lExist )

ACEFUNCTION AdsClearDefault()

ACEFUNCTION AdsClearProgressCallback()

ACEFUNCTION AdsConnect( cServerName, @nHandle )

ACEFUNCTION AdsConnect26( cServerName, nServerType, @nHandle )

ACEFUNCTION AdsConnect60( cServerName, nServerType, cUserName, cPassword, nOptions, @nHandle )

ACEFUNCTION AdsDisconnect( nHandle )

ACEFUNCTION AdsFailedTransactionRecovery( cServerPath )

ACEFUNCTION AdsFindConnection( cServerName, @nHandle )

ACEFUNCTION AdsFindConnection25( cFullPath, @nHandle )

FUNCTION AdsGetAllTables( aTable, nLength )

   LOCAL xRet, i, cTable, nDll := DllLoad("ACE32.DLL")
   DEFAULT nLength TO 100, aTable TO {}
   cTable := Space( nLength * 4 )
   xRet := DllCall( nDll, 32, "AdsGetAllTables", @cTable, @nLength )
   DllUnLoad(nDll)
   ASize(aTable,nLength)
   FOR i := 1 TO nLength
     aTable[i] := Bin2L( SubStr(cTable,(i-1)*4+1,4))
   NEXT

RETURN xRet

ACEFUNCTION AdsGetConnectionType( nHandle, @nType )

ACEFUNCTION AdsGetDateFormat( @cDateFormat, @nBufferLength )

ACEFUNCTION AdsGetDecimals( @nDecimals )

ACEFUNCTION AdsGetDefault( @cDefaultPath, @nBufferLength )

ACEFUNCTION AdsGetDeleted( @lDeleted )

ACEFUNCTION AdsGetEpoch( @nEpoch )

ACEFUNCTION AdsGetErrorString( nError, @cErrorString, @nBufferLength ) //

ACEFUNCTION AdsGetExact( @lExact )

ACEFUNCTION AdsGetExact22( nHandle, @lExact )

ACEFUNCTION AdsGetLastError( @nError, @cErrorString, @nBufferLength )

ACEFUNCTION AdsGetNumOpenTables( @nTables )

ACEFUNCTION AdsGetSearchPath( @cSearchPath, @nBufferLength )

ACEFUNCTION AdsGetServerName( nHandle, @cServerName, @nBufferLength )

ACEFUNCTION AdsGetServerTime( nHandle, @cDate, @nDateBufferLength, @nTime, @cTime, @nTimeBufferLength )

ACEFUNCTION AdsGetVersion( @nMajor, @nMinor, @cVersion, @cDescription, @nDescBufferLength )

ACEFUNCTION AdsInTransaction( nHandle, @lInTrans )

ACEFUNCTION AdsIsServerLoaded( cServer, @nIsLoaded )

ACEFUNCTION AdsNullTerminateStrings( lNulTerm )

ACEFUNCTION AdsRegisterProgressCallback( bFunction, nPercent )

ACEFUNCTION AdsRollbackTransaction( nHandle )

ACEFUNCTION AdsSetDateFormat( cDateFormat )

ACEFUNCTION AdsSetDecimals( nDecimals )

ACEFUNCTION AdsSetDefault( cDefault )

ACEFUNCTION AdsSetEpoch( nEpoch )

ACEFUNCTION AdsSetExact( lExact )

ACEFUNCTION AdsSetExact22( nHandle, lExact )

ACEFUNCTION AdsSetSearchPath( cSearchPath )

ACEFUNCTION AdsSetServerType( nServerType )

ACEFUNCTION AdsShowDeleted( lShowDeleted )

ACEFUNCTION AdsShowError( cTitle )

ACEFUNCTION AdsWriteAllRecords()


* ------ ADS Table Functions ------ *

/*
AdsAddCustomKey
AdsAtBOF
AdsAtEOF
AdsCacheOpenTables
AdsCacheRecords
AdsCancelUpdate
AdsClearAllScopes
AdsClearAOF
AdsClearFilter
AdsClearRelation
AdsClearScope
AdsCloneTable
AdsCloseAllIndexes
AdsCloseAllTables
AdsCloseIndex
AdsCloseTable
AdsContinue
AdsConvertTable
AdsCopyTable
AdsCopyTableContents
AdsCopyTableStructure
AdsCreateIndex
AdsCreateIndex61
AdsCreateTable
AdsCustomizeAOF
AdsDecryptRecord
AdsDecryptTable
AdsDeleteCustomKey
AdsDeleteIndex
AdsDisableEncryption
AdsEnableEncryption
AdsEncryptRecord
AdsEncryptTable
AdsEvalAOF
AdsEvalLogicalExpr
AdsEvalNumericExpr
AdsEvalStringExpr
AdsEvalTestExpr
AdsExtractKey
AdsGetAllIndexes
AdsGetAllLocks
AdsGetAOF
AdsGetAOFOptLevel
AdsGetBookmark
AdsGetFieldDecimals
AdsGetFieldLength
AdsGetFieldName
AdsGetFieldNum
AdsGetFieldOffset
AdsGetFieldType
AdsGetFilter
AdsGetHandleLong
AdsGetHandleType
AdsGetIndexCondition
AdsGetIndexExpr
AdsGetIndexFilename
AdsGetIndexHandle
AdsGetIndexHandleByExpr
AdsGetIndexHandleByOrder
AdsGetIndexName
AdsGetIndexOrderByHandle
AdsGetKeyCount
AdsGetKeyLength
AdsGetKeyNum
AdsGetKeyType
AdsGetLastTableUpdate
AdsGetNumFields
AdsGetNumIndexes
AdsGetNumLocks
AdsGetRecordCount
AdsGetRecordLength
AdsGetRecordNum
AdsGetRelKeyPos
AdsGetScope
AdsGetTableAlias
AdsGetTableCharType
AdsGetTableConnection
AdsGetTableFilename
AdsGetTableHandle
AdsGetTableLockType
AdsGetTableOpenOptions
AdsGetTableRights
AdsGetTableType
AdsGotoBookmark
AdsGotoBottom
AdsGotoRecord
AdsGotoTop
AdsIsEncryptionEnabled
AdsIsExprValid
AdsIsFound
AdsIsIndexCompound
AdsIsIndexCustom
AdsIsIndexDescending
AdsIsIndexUnique
AdsIsRecordDeleted
AdsIsRecordEncrypted
AdsIsRecordInAOF
AdsIsRecordLocked
AdsIsRecordVisible
AdsIsTableEncrypted
AdsIsTableLocked
AdsLocate
AdsLockRecord
AdsLockTable
AdsLookupKey
AdsOpenIndex
AdsOpenTable
AdsPackTable
AdsRefreshAOF
AdsRefreshRecord
AdsReindex
AdsSeek
AdsSeekLast
AdsSetAOF
AdsSetFilter
AdsSetHandleLong
AdsSetRelation
AdsSetRelKeyPos
AdsSetScope
AdsSetScopedRelation
AdsSkip
AdsUnlockRecord
AdsUnlockTable
AdsVerifyPassword
AdsZapTable
*/

ACEFUNCTION AdsAddCustomKey( nIndex )

ACEFUNCTION AdsAtBOF( nTableHandle, @lStatus )

ACEFUNCTION AdsAtEOF( nTableHandle, @lStatus )

ACEFUNCTION AdsCacheOpenTables( nTables )

ACEFUNCTION AdsCacheRecords( nTableHandle, nRecords )

ACEFUNCTION AdsCancelUpdate( nTableHandle )

ACEFUNCTION AdsClearAllScopes( nTableHandle )

ACEFUNCTION AdsClearAOF( nTableHandle )

ACEFUNCTION AdsClearFilter( nTableHandle )

ACEFUNCTION AdsClearRelation( nParentHandle )

ACEFUNCTION AdsClearScope( nIndex, nScope )

ACEFUNCTION AdsCloneTable( nTableHandle, @nCloneHandle )

ACEFUNCTION AdsCloseAllIndexes( nTableHandle )

ACEFUNCTION AdsCloseAllTables()

ACEFUNCTION AdsCloseIndex( nIndex )

ACEFUNCTION AdsCloseTable( nTableHandle )

ACEFUNCTION AdsContinue( nTableHandle, @lStatus )

ACEFUNCTION AdsConvertTable( nTableHandle, nFilterOption, cFileName, nTableType )

ACEFUNCTION AdsCopyTable( nTableHandle, nFilterOption, cFileName )

ACEFUNCTION AdsCopyTableContents( nTableFrom, nTableTo, nFilterOption )

ACEFUNCTION AdsCopyTableStructure( nTableFrom, cFileName )

ACEFUNCTION AdsCreateIndex( nHandle, cFileName, cTagName, cKeyExpr, cCondition, cWhile, nOptions, @nIndex) ;

ACEFUNCTION AdsCreateIndex61( nHandle, cFileName, cTagName, cKeyExpr, cCondition, cWhile, nOptions, nPageSize, @nIndex) ;

ACEFUNCTION AdsCreateTable( nConnectHandle, cTableName, cAlias, nTableType, nCharType, nLockType, ;
                            nCheckRights, nMemoSize, cFields,  @nTableHandle) ;


ACEFUNCTION AdsCustomizeAOF( nTableHandle, nNumRecs, aRecords, nOption)

ACEFUNCTION AdsDecryptRecord( nTableHandle )

ACEFUNCTION AdsDecryptTable( nTableHandle )

ACEFUNCTION AdsDeleteCustomKey( nIndex )

ACEFUNCTION AdsDeleteIndex( nIndex )

ACEFUNCTION AdsDisableEncryption( nTableHandle )

ACEFUNCTION AdsEnableEncryption( nTableHandle, cPassWord )

ACEFUNCTION AdsEncryptRecord( nTableHandle )

ACEFUNCTION AdsEncryptTable( nTableHandle )

ACEFUNCTION AdsEvalAOF( nTableHandle, cFilter, nOptLevel )

ACEFUNCTION AdsExtractKey( nTableHandle, @cKey, @nBufferLen )

FUNCTION AdsGetAllIndexes( nTableHandle, aIndex, nLength )

LOCAL xRet, i, cIndex, nDll,nIndexes := 0
nLength := 100  // init pass-by-reference
aIndex  := {}   // "  " " "  " "
AdsGetNumIndexes(nTableHandle, @nIndexes)  // get number of indexes so we can correctly init call to AdsGetAllIndexes
nLength := nIndexes  // this is how many file handles we should get back
cIndex := SPACE( nLength * 4 )
nDll := DllLoad("ACE32.DLL")
xRet := DllCall( nDll, 32, "AdsGetAllIndexes", nTableHandle, @cIndex, @nLength )
DllUnLoad(nDll)
ASIZE(aIndex,nLength)
FOR i := 1 TO nLength
  aIndex[i] := Bin2L( SubStr(cIndex,(i-1)*4+1,4))
NEXT
RETURN xRet

FUNCTION AdsGetAllLocks( nTableHandle, aLocks, nLength )

   LOCAL xRet, i, cLocks, nDll := DllLoad("ACE32.DLL")
   DEFAULT nLength TO 100, aLocks TO {}
   cLocks := Space( nLength * 4 )
   xRet := DllCall( nDll, 32, "AdsGetAllLocks", nTableHandle, @cLocks, @nLength )
   DllUnLoad(nDll)
   ASize(aLocks,nLength)
   FOR i := 1 TO nLength
     aLocks[i] := Bin2L( SubStr(cLocks,(i-1)*4+1,4))
   NEXT

RETURN xRet

ACEFUNCTION AdsGetAOF( nTableHandle, @cFilter, @nBufferLen )

ACEFUNCTION AdsGetAOFOptLevel( nTableHandle, @nOptLevel, @cNonOpt, @nBufferLen )

ACEFUNCTION AdsGetBookMark( nTableHandle, @nRecord )

ACEFUNCTION AdsGetFieldDecimals( nTableHandle, cFieldName, @nDecimals ) //

ACEFUNCTION AdsGetFieldLength( nTableHandle, cFieldName, @nLength ) //

ACEFUNCTION AdsGetFieldName( nTableHandle, nFieldPos, @cFieldName, @nBufferLen ) //

ACEFUNCTION AdsGetFieldNum( nTableHandle, cFieldName, @nFieldPos ) //

ACEFUNCTION AdsGetFieldOffset( nTableHandle, cFieldName, @nOffset )

ACEFUNCTION AdsGetFieldType( nTableHandle, cFieldName, @nType ) //

ACEFUNCTION AdsGetFilter( nTableHandle, @cFilter, @nBufferLen )

ACEFUNCTION AdsGetHandleLong( nTableHandle, @nHandleLong )

ACEFUNCTION AdsGetHandleType( nTableHandle, @nHandleType )

ACEFUNCTION AdsGetIndexCondition( nIndex, @cCond, @nBufferLen )

ACEFUNCTION AdsGetIndexExpr( nIndex, @cExpr, @nBufferLen )

ACEFUNCTION AdsGetIndexFilename( nIndex, nOption, @cFileName, @nBufferLen )

ACEFUNCTION AdsGetIndexHandle( nTableHandle, cIndexName, @nHandle )

ACEFUNCTION AdsGetIndexHandleByExpr( nTableHandle, cExpr, nDescending, @nHandle )

ACEFUNCTION AdsGetIndexHandleByOrder( nTableHandle, nOrder, @nHandle )

ACEFUNCTION AdsGetIndexName( nIndex, @cIndexName, @nBufferLen )

ACEFUNCTION AdsGetIndexOrderByHandle( nIndex, @nOrder )

ACEFUNCTION AdsGetKeyCount( nIndex, nFilterOption, @nKeyCount )

ACEFUNCTION AdsGetKeyLength( nIndex, @nBytes )

ACEFUNCTION AdsGetKeyNum( nIndex, nFilterOption, @nKeyNo )

ACEFUNCTION AdsGetKeyType( nIndex, @nKeyType )

ACEFUNCTION AdsGetLastTableUpdate( nTableHandle, @cDate, @nBufferLen )

ACEFUNCTION AdsGetNumFields( nTableHandle, @nFieldCount )

ACEFUNCTION AdsGetNumIndexes( nTableHandle, @nIndexCount )

ACEFUNCTION AdsGetNumLocks( nTableHandle, @nLockCount )

ACEFUNCTION AdsGetRecordCount( nTableHandle, nFilterOption, @nRecCount )

ACEFUNCTION AdsGetRecordLength( nTableHandle, @nRecLength )

ACEFUNCTION AdsGetRecordNum( nTableHandle, nFilterOption, @nRecord )

ACEFUNCTION AdsGetRelKeyPos( nIndex, @nPosition )

ACEFUNCTION AdsGetScope( nIndex, nScopeOption, @cScope, @nBufferLen )

ACEFUNCTION AdsGetTableAlias( nTableHandle, @cAlias, @nBufferLen )

ACEFUNCTION AdsGetTableCharType( nTableHandle, @nCharType )

ACEFUNCTION AdsGetTableConnection( nTableHandle, @nConnection )

ACEFUNCTION AdsGetTableFilename( nTableHandle, nOption, @cFileName, @nBufferLen )

ACEFUNCTION AdsGetTableHandle( cAlias, @nTableHandle )

ACEFUNCTION AdsGetTableLockType( nTableHandle, @nLockType )

ACEFUNCTION AdsGetTableOpenOptions( nTableHandle, @nOptions )

ACEFUNCTION AdsGetTableRights( nTableHandle, @nRights )

ACEFUNCTION AdsGetTableType( nTableHandle, @nType )

ACEFUNCTION AdsGotoBookMark( nTableHandle, nBookMark )

ACEFUNCTION AdsGotoBottom( nTableHandle )

ACEFUNCTION AdsGotoRecord( nTableHandle, nRecord )

ACEFUNCTION AdsGotoTop( nTableHandle )

ACEFUNCTION AdsIsEncryptionEnabled( nTableHandle, @lStatus )

ACEFUNCTION AdsIsExprValid( nTableHandle, cExpression, @lStatus )

ACEFUNCTION AdsIsFound( nTableHandle, @lStatus )

ACEFUNCTION AdsIsIndexCompound( nIndex, @lStatus )

ACEFUNCTION AdsIsIndexCustom( nIndex, @lStatus )

ACEFUNCTION AdsIsIndexDescending( nIndex, @lStatus )

ACEFUNCTION AdsIsIndexUnique( nIndex, @lStatus )

ACEFUNCTION AdsIsRecordDeleted( nTableHandle, @lStatus )

ACEFUNCTION AdsIsRecordEncrypted( nTableHandle, @lStatus )

ACEFUNCTION AdsIsTableLocked( nTableHandle, @lStatus )

ACEFUNCTION AdsLocate( nTableHandle, cExpr, lForward, @lFound )

ACEFUNCTION AdsLockRecord( nTableHandle, nRecord )

ACEFUNCTION AdsLockTable( nTableHandle )

ACEFUNCTION AdsLookupKey( nIndex, cKey, nKeyLen, nDataType, @lFound )

ACEFUNCTION AdsOpenIndex( nTableHandle, cFileName, @aOrders, @nArrayLen )

ACEFUNCTION AdsOpenTable( nConnect, cName, cAlias, nTableType, nCharType, nLockType, nCheckRights, ;
                          nOptions, @nTableHandle )

ACEFUNCTION AdsPackTable( nTableHandle )

ACEFUNCTION AdsRefreshAOF( nTableHandle )

ACEFUNCTION AdsRefreshRecord( nTableHandle )

ACEFUNCTION AdsReindex( nTableHandle )

ACEFUNCTION AdsSeek( nIndex, @cKey, cLength, nDataType, nSeekType, @lFound )

ACEFUNCTION AdsSeekLast( nIndex, @cKey, cLength, nDataType, @lFound )

ACEFUNCTION AdsSetAOF ( nTableHandle, cFilter, nResolve )

ACEFUNCTION AdsSetFilter( nTableHandle )

ACEFUNCTION AdsSetHandleLong( nTableHandle, nHandleLong )

ACEFUNCTION AdsSetRelation( nParentHandle, nChildIndex, cRelation )

ACEFUNCTION AdsSetRelKeyPos( nIndex, nRelKeyPos )

ACEFUNCTION AdsSetScope( nIndex,  nScopeOption, cScope, nScopeLen, nDataType )

ACEFUNCTION AdsSetScopedRelation( nParentHandle, nChildIndex, cScope )

ACEFUNCTION AdsSkip( nTableHandle, nRecords )

ACEFUNCTION AdsUnlockRecord( nTableHandle, nRecord )

ACEFUNCTION AdsUnlockTable( nTableHandle )

ACEFUNCTION AdsZapTable( nTableHandle )


* ------ ADS Data Manipulation Functions ------ *

/*
AdsAppendRecord
AdsBinaryToFile
AdsBuildRawKey
AdsDeleteRecord
AdsFileToBinary
AdsGetBinary
AdsGetBinaryLength
AdsGetDate
AdsGetDouble
AdsGetField
AdsGetJulian
AdsGetLogical
AdsGetLong
AdsGetMemoDataType
AdsGetMemoLength
AdsGetMilliseconds
AdsGetRecord
AdsGetShort
AdsGetString
AdsGetTime
AdsImageToClipboard
AdsInitRawKey
AdsIsEmpty
AdsRecallRecord
AdsSetBinary
AdsSetDate
AdsSetDouble
AdsSetEmpty
AdsSetField
AdsSetJulian
AdsSetLogical
AdsSetLong
AdsSetMilliseconds
AdsSetRecord
AdsSetShort
AdsSetString
AdsSetTime
AdsSetTimeStamp
AdsWriteRecord
*/

ACEFUNCTION AdsAppendRecord( nTableHandle )

ACEFUNCTION AdsBinaryToFile( nTableHandle, cFieldName, cFileName )

ACEFUNCTION AdsBuildRawKey( nIndex, @cKey, @nBufferLen )

ACEFUNCTION AdsDeleteRecord( nTableHandle )

ACEFUNCTION AdsFileToBinary( nTableHandle, cFieldName, nBinaryType, cFileName )

ACEFUNCTION AdsGetBinary( nTableHandle, cFieldName, nOffset, @cBuffer, @nBufferLen )

ACEFUNCTION AdsGetBinaryLength( nTableHandle, cFieldName, @nLength )

ACEFUNCTION AdsGetDate( nTableHandle, cFieldName, @cDate, @nBufferLen )

ACEFUNCTION AdsGetDouble( nTableHandle, cFieldName, @nValue )

ACEFUNCTION AdsGetField( nTableHandle, cFieldName, @cBuffer, @nBufferLen, nOption ) //

ACEFUNCTION AdsGetJulian( nTableHandle, cFieldName, @nJulian )

ACEFUNCTION AdsGetLogical( nTableHandle, cFieldName, @lValue )

ACEFUNCTION AdsGetLong( nTableHandle, cFieldName, @nValue )

ACEFUNCTION AdsGetMemoDataType( nTableHandle, cFieldName, @nMemoType )

ACEFUNCTION AdsGetMemoLength( nTableHandle, cFieldName, @nLength )

ACEFUNCTION AdsGetMilliseconds( nTableHandle, cFieldName, @nValue )

ACEFUNCTION AdsGetRecord( nTableHandle, @cBuffer, @nBufferLen )

ACEFUNCTION AdsGetShort( nTableHandle, cFieldName, @nValue )

ACEFUNCTION AdsGetString( nTableHandle, cFieldName, @cString, @nBufferLen, nOption )

ACEFUNCTION AdsGetTime( nTableHandle, cFieldName, @cTime, @nBufferLen )

ACEFUNCTION AdsImageToClipboard( nTableHandle, cFieldName )

ACEFUNCTION AdsInitRawKey( nIndex )

ACEFUNCTION AdsIsEmpty( nTableHandle, cFieldName, @lStatus )

ACEFUNCTION AdsRecallRecord( nTableHandle )

ACEFUNCTION AdsSetBinary( nTableHandle, cFieldName, nBinaryType, nTotalLength, nOffset, cBuffer, nBufferLen) ;


ACEFUNCTION AdsSetDate( nTableHandle, cFieldName, cDate, nBufferLen )

ACEFUNCTION AdsSetDouble( nTableHandle, cFieldName, nValue )

ACEFUNCTION AdsSetEmpty( nTableHandle, cFieldName )

ACEFUNCTION AdsSetField( nTableHandle, cFieldName, cData, nDataLen )

ACEFUNCTION AdsSetJulian( nTableHandle, cFieldName, nJulien )

ACEFUNCTION AdsSetLogical( nTableHandle, cFieldName, lValue )

ACEFUNCTION AdsSetLong( nTableHandle, cFieldName, nValue )

ACEFUNCTION AdsSetMilliseconds( nTableHandle, cFieldName, nValue )

ACEFUNCTION AdsSetRecord( nTableHandle, cBuffer, nRecLength )

ACEFUNCTION AdsSetShort( nTableHandle, cFieldName, nValue )

ACEFUNCTION AdsSetString( nTableHandle, cFieldName, cString, nStringLen )

ACEFUNCTION AdsSetTime( nTableHandle, cFieldName, cTime, nTimeLen )

ACEFUNCTION AdsSetTimeStamp( nTableHandle, cFieldName, cTime, nTimeLen )

ACEFUNCTION AdsWriteRecord( nTableHandle )


* ------ ADS SQL Functions ------ *

/*
AdsCacheOpenCursors
AdsClearSQLAbortFunc
AdsClearSQLParams
AdsCloseSQLStatement
AdsCreateSQLStatement
AdsExecuteSQL
AdsExecuteSQLDirect
AdsPrepareSQL
AdsRegisterSQLAbortFunc
AdsStmtClearTablePasswords
AdsStmtConstrainUpdates
AdsStmtDisableEncryption
AdsStmtEnableEncryption
AdsStmtSetTableCharType
AdsStmtSetTableLockType
AdsStmtSetTablePassword
AdsStmtSetTableReadOnly
AdsStmtSetTableRights
AdsStmtSetTableType
AdsCloseCachedTables
*/

ACEFUNCTION AdsCacheOpenCursors( nCursors )

ACEFUNCTION AdsClearSQLAbortFunc()

ACEFUNCTION AdsClearSQLParams( nStatement )

ACEFUNCTION AdsCloseSQLStatement( nStatement )

ACEFUNCTION AdsCreateSQLStatement( nConnect, @nStatement )

ACEFUNCTION AdsExecuteSQL( nStatement, @nCursor )

ACEFUNCTION AdsExecuteSQLDirect( nStatement, cStatement, @nCursor )

ACEFUNCTION AdsPrepareSQL( nStatement, cStatement )

ACEFUNCTION AdsRegisterSQLAbortFunc( bFunction )

ACEFUNCTION AdsStmtClearTablePasswords( nStatement )

ACEFUNCTION AdsStmtConstrainUpdates( nStatement, nConstrain )

ACEFUNCTION AdsStmtDisableEncryption( nStatement )

ACEFUNCTION AdsStmtEnableEncryption( nStatement, cPassword )

ACEFUNCTION AdsStmtSetTableCharType( nStatement, nCharType )

ACEFUNCTION AdsStmtSetTableLockType( nStatement, nLockType )

ACEFUNCTION AdsStmtSetTablePassword( nStatement, cTableName, cPassword )

ACEFUNCTION AdsStmtSetTableReadOnly( nStatement, nReadOnly )

ACEFUNCTION AdsStmtSetTableRights( nStatement, nRights )

ACEFUNCTION AdsStmtSetTableType( nStatement, nRights )

ACEFUNCTION AdsVerifySQL( nStatement, cStatement )

ACEFUNCTION AdsCloseCachedTables( nHandle )

* ------ ADS Management API Functions ------ *

/*
AdsMgConnect
AdsMgDisconnect
AdsMgGetActivityInfo
AdsMgGetCommStats
AdsMgGetConfigInfo
AdsMgGetInstallInfo
AdsMgGetLockOwner
AdsMgGetLocks
AdsMgGetOpenIndexes
AdsMgGetOpenTables
AdsMgGetServerType
AdsMgGetUserNames
AdsMgGetWorkerThreadActivity
AdsMgKillUser
AdsMgResetCommStats
*/

/*
DLLFUNCTION AdsMgConnect( cServerName, cUserName, cPassWord, @nConnectHandle ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgDisconnect( nConnectHandle ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetActivityInfo( nMgmtConnect, @aStructure, @nStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetCommStats( nMgmtConnect, @aStructure, @nStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetConfigInfo( nMgmtConnect, @aConfigValues, @nConfigValuesStructSize, @aConfigMemory, ;
                                @nConfigMemoryStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetInstallInfo( nMgmtConnect, @aInstallValues, @nInstallValuesStructSize ) ;
            USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetLockOwner( nMgmtConnect, cTableName, nRecordNumber, @aUserInfo, ;
                               @nStructSize, nLockType) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetLocks( nMgmtConnect, cTableName, cUserName,  nConnNumber, ;
                           @aRecordInfo, @nArrayLen,  @nStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetOpenIndexes( nMgmtConnect, cTableName, cUserName, nConnNumber, ;
                                 @aOpenIndexInfo, @nArrayLen, @nStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetOpenTables( nMgmtConnect, cUserName, nConnNumber, @aOpenTableInfo, ;
                                @nArrayLen, @nStructSize ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetServerType( nMgmtConnect, @nServerType ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetUserNames( nMgmtConnect, cFileName, @aUserInfo, @nArrayLen, @nStructSize ) ;
            USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgGetWorkerThreadActivity( nMgmtConnect, @aWorkerThreadActivity, @nArrayLen, ;
                                          @nStructSize) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgKillUser( nMgmtConnect, cUserName, nConnNumber ) USING STDCALL FROM ACE32.DLL

DLLFUNCTION AdsMgResetCommStats( nMgmtConnect ) USING STDCALL FROM ACE32.DLL
*/

* ------ ADS Data Dictionary Functions ------ *

/*
AdsDDAddIndexFile()
AdsDDAddProcedure()
AdsDDAddTable()
AdsDDAddUserToGroup()
AdsDDAddView()
AdsDDCreate()
AdsDDCreateLink()
AdsDDCreateRefIntegrity()
AdsDDCreateRefIntegrity62()
AdsDDCreateTrigger()
AdsDDCreateUser()
AdsDDCreateUserGroup()
AdsDDDeleteIndex()
AdsDDDeleteUser()
AdsDDDeleteUserGroup()
AdsDDDeployDatabase()
AdsDDDropLink()
AdsDDFindClose()
AdsDDFindFirstObject()
AdsDDFindNextObject()
AdsDDFreeTable()
AdsDDGetDatabaseProperty()
AdsDDGetFieldProperty()
AdsDDGetIndexFileProperty()
AdsDDGetIndexProperty()
AdsDDGetLinkProperty()
AdsDDGetPermissions()
AdsDDGetProcedureProperty()
AdsDDGetRefIntegrityProperty()
AdsDDGetTableProperty()
AdsDDGetTriggerProperty()
AdsDDGetUserGroupProperty()
AdsDDGetUserProperty()
AdsDDGetViewProperty()
AdsDDGrantPermission()
AdsDDModifyLink()
AdsDDRemoveIndexFile()
AdsDDRemoveProcedure()
AdsDDRemoveRefIntegrity()
AdsDDRemoveTable()
AdsDDRemoveTrigger()
AdsDDRemoveUserFromGroup()
AdsDDRemoveView()
AdsDDRevokePermission()
AdsDDSetDatabaseProperty()
AdsDDSetFieldProperty()
AdsDDSetProcedureProperty()
AdsDDSetTableProperty()
AdsDDSetUserGroupProperty()
AdsDDSetUserProperty()
AdsDDSetViewProperty()
*/

ACEFUNCTION AdsDDAddIndexFile( nAdminConn, cTableName, cIndexFilePath, cComment )
ACEFUNCTION AdsDDAddProcedure( nAdminConn, cName, cEAP, cProcName, nInvokeOption, cInParams, cOutParams, cComments )
ACEFUNCTION AdsDDAddTable( nAdminConn, cTableName, cTablePath, nTableType, nCharType, cIndexFiles, cComments )
ACEFUNCTION AdsDDAddUserToGroup( nAdminConn, cGroupName, cUserName )
ACEFUNCTION AdsDDAddView( nAdminConn, cName, cComments, cSQL )
ACEFUNCTION AdsDDCreate( cDictionaryPath, nEncrypt, cDescription, @nAdminConn )
ACEFUNCTION AdsDDCreateLink( nDBConn, cLinkAlias, cLinkedDDPath, cUserName, cPassword, nOptions )
ACEFUNCTION AdsDDCreateRefIntegrity( nAdminConn, cRIName, cFailTable, cParentTableName, pucParentTagName, ;
                                     cChildTableName, cChildTagName, nUpdateRule, nDeleteRule )
ACEFUNCTION AdsDDCreateRefIntegrity62( nAdminConn, cRIName, cFailTable, cParentTableName, pucParentTagName, ;
                                       cChildTableName, cChildTagName, nUpdateRule, nDeleteRule, ;
                                       cNoPrimaryError, cCascadeError )
ACEFUNCTION AdsDDCreateTrigger( nDictionary, cName, cTableName, nTriggerType, nEventTypes, ;
                                nContainerType, cContainer, cFunctionName, nPriority,  ;
                                cComments, nOptions )
ACEFUNCTION AdsDDCreateUser( nAdminConn, cGroupName, cUserName, cPassword, cDescription )
ACEFUNCTION AdsDDCreateUserGroup( nAdminConn, cGroupName, cDescription )
ACEFUNCTION AdsDDDeleteIndex( hAdminConn, cTableName, cIndexName )
ACEFUNCTION AdsDDDeleteUser( nAdminConn, cUserName )
ACEFUNCTION AdsDDDeleteUserGroup( nAdminConn, cGroupName )
ACEFUNCTION AdsDDDeployDatabase ( cDestination, cDestinationPassword, cSource, cSourcePassword, ;
                                  nServerTypes, nValidateOption, nBackupFiles, nOptions )
ACEFUNCTION AdsDDDropLink( nDBConn, cLinkedDD, lDropGlobal )
ACEFUNCTION AdsDDFindClose( nDBConn, nFindHandle )
ACEFUNCTION AdsDDFindFirstObject( nDBConn, nFindObjectType, cParentName, @cObjectName, ;
                                  @nObjectNameLen, @nFindHandle )
ACEFUNCTION AdsDDFindNextObject( nDBConn, nFindHandle, @cObjectName, @nObjectNameLen )
ACEFUNCTION AdsDDFreeTable( cTableName, cPassword )
ACEFUNCTION AdsDDGetDatabaseProperty( nDBConn, nPropertyID, @cProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetFieldProperty( nDBConn, cTableName, cFieldName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetIndexFileProperty( nDBConn, cTableName, cIndexFileName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetIndexProperty( nDBConn, cTableName, cIndexName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetLinkProperty( nAdminConn, cLinkName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetPermissions( nAdminConn, cGrantee, nObjectType, cObjectName, cParentName, ;
                                 lGetInherited, @nPermissions )
ACEFUNCTION AdsDDGetProcedureProperty( nDBConn, cProcName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetRefIntegrityProperty( nDBConn, cRIName, nPropertyID, @cProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetTableProperty( nDBConn, cTableName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetTriggerProperty( nObject, cTriggerName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetUserGroupProperty( nDBConn, cUserGroupName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetUserProperty( nDBConn, cUserName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGetViewProperty( nDBConn, cViewName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDGrantPermission( nAdminConn, nObjectType, cObjectName, cParentName, cGrantee, nPermissions )
ACEFUNCTION AdsDDModifyLink( nDBConn, cLinkAlias, cLinkedDDPath, cUserName, cPassword, nOptions )
ACEFUNCTION AdsDDRemoveIndexFile( nAdminConn, cTableName, cIndexFileName, nDeleteFile )
ACEFUNCTION AdsDDRemoveProcedure( nAdminConn, cName )
ACEFUNCTION AdsDDRemoveRefIntegrity( nAdminConn, cRIName )
ACEFUNCTION AdsDDRemoveTable( nAdminConn, ucTableName, lDeleteFiles )
ACEFUNCTION AdsDDRemoveTrigger( nDictionary, cName )
ACEFUNCTION AdsDDRemoveUserFromGroup( nAdminConn, cGroupName, cUserName )
ACEFUNCTION AdsDDRemoveView( nAdminConn, cName )
ACEFUNCTION AdsDDRevokePermission( nAdminConn, nObjectType, cObjectName, cParentName, cGrantee, nPermissions )
ACEFUNCTION AdsDDSetDatabaseProperty( nAdminConn, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDSetFieldProperty( nAdminConn, cTableName, cFieldName, nPropertyID, @nProperty, ;
                                   @nPropertyLen, nValidateOption, cFailTable )
ACEFUNCTION AdsDDSetProcedureProperty( nDBConn, cProcedureName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDSetTableProperty( nAdminConn, cTableName, nPropertyID, @nProperty, @nPropertyLen, ;
                                   nValidateOption, cFailTable )
ACEFUNCTION AdsDDSetUserGroupProperty( nAdminConn, cUserGroupName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDSetUserProperty( nDBConn, cUserName, nPropertyID, @nProperty, @nPropertyLen )
ACEFUNCTION AdsDDSetViewProperty( nDBConn, cViewName, nPropertyID, @nProperty, @nPropertyLen )


* ------ Clipper Compatability Functions ------ *

/*
AX_AXSLocking()    // included in ADSUTIL.DLL
AX_DbfDecrypt()    // included in ADSUTIL.DLL
AX_DbfEncrypt()    // included in ADSUTIL.DLL
AX_Decrypt()       // included in ADSUTIL.DLL
AX_Encrypt()       // included in ADSUTIL.DLL
AX_Error()         // included in ADSUTIL.DLL
AX_IDType()        // included in ADSUTIL.DLL
AX_RightsCheck()   // included in ADSUTIL.DLL
AX_SetPass()       // included in ADSUTIL.DLL
AX_TableType()     // included in ADSUTIL.DLL

AX_AutoOpen()         // not completed
AX_BLOB2File()
AX_CDXCheck()         // not completed
AX_ChooseOrgBagExt()
AX_ClearOrder()
AX_ClrScope()
AX_Driver()
AX_Error()
AX_ExprEngine()       // not supported in ACE32.DLL (always on)
AX_ExprError()        // not completed
AX_ExprValid()
AX_File2BLOB()
AX_FileOrder()        // not completed
AX_GetDrive()
AX_GetLocks()
AX_I_IndexName()      // not completed
AX_I_TagName()        // not completed
AX_IndexCount()
AX_IndexFilt()
AX_IndexName()
AX_IndexType()
AX_IsFlocked()
AX_IsLocked()
AX_IsReadOnly()
AX_IsReIndex()        // not completed
AX_IsShared()
AX_IsCustom()
AX_IsDescend()
AX_IsUnique()
AX_KeyAdd()
AX_KeyCount()
AX_KeyDrop()
AX_KeyNo()
AX_KeysIncluded()
AX_KeyVal()
AX_KillTag()
AX_Loaded()
AX_MemoArrayStyle     // not completed
AX_RddCount()
AX_RddInfo()
AX_Rlock()
AX_SeekLast()
AX_SetMemoBlock()
AX_SetRdd()
AX_SetScope()
AX_SetTag()
AX_SetTagNo()
AX_SetTagOrder()
AX_SkipUnique()
AX_TableName()
AX_TableType()
AX_TagInfo()
AX_TagName()
AX_TagNo()
AX_TagOrder()
AX_Tags()
AX_TPSCleanup()
AX_Transaction()
AX_Unlock()
AX_UserLockID()        // not completed
AX_Version()
AofFilterInfo()
*/


FUNCTION AX_AutoOpen()  // not completed
RETURN .t.

* ----------------

FUNCTION AX_BLOB2File( cFileName, cFieldName )

LOCAL nError, nHandle

nHandle := _GetTableHandle()
nError := AdsBinaryToFile( nHandle, cFieldName, cFileName )

RETURN nError == 0

* ----------------

FUNCTION AX_CDXCheck()  // not completed
RETURN .t.

* ----------------

FUNCTION AX_ChooseOrdBagExt( cExt )

RETURN DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, cExt )

* ----------------

FUNCTION AX_ClearOrder( nOrder )

LOCAL nHandle, nIndex, nError

nHandle := _GetTableHandle()
nIndex := 0
AdsGetIndexHandleByOrder( nHandle, nOrder, @nIndex )

nError := AdsCloseIndex( nIndex )

RETURN nError == 0

* ----------------

FUNCTION AX_ClrScope( nScope )

LOCAL nIndex, nHandle, nError
DEFAULT nScope TO 0
IF nScope = 0
  nScope := ADS_TOP
ELSEIF nScope = 1
  nScope := ADS_BOTTOM
ENDIF

nHandle := _GetTableHandle()
nIndex := 0
AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )

nError := AdsClearScope( nIndex, nScope )

RETURN nError == 0

* ----------------

FUNCTION AX_Driver()

LOCAL aList := DbeList()
RETURN  Ascan(aList,{|a|a[1]=='ADSDBE'}) > 0

* ----------------

FUNCTION AX_Error()

LOCAL nError := 0, cString, nLength

cString := Space(100)
nLength := 100
AdsGetLastError( @nError, @cString, @nLength )

RETURN nError

* ----------------

FUNCTION AX_ExprEngine( lOn ) // Not completed
RETURN .t.

* ----------------

FUNCTION AX_ExprError()  // Not completed
RETURN 0

* ----------------

FUNCTION AX_ExprValid( cExpression )

LOCAL nError, lStatus := .f., nHandle

nHandle := _GetTableHandle()
nError := AdsIsExprValid( nHandle, cExpression, @lStatus )

RETURN lStatus .AND. nError == 0

* ----------------

FUNCTION AX_File2BLOB( cFileName, cFieldName )

LOCAL nError, nHandle
nHandle := _GetTableHandle()
nError := AdsFileToBinary( nHandle, cFieldName, ADS_BINARY, cFileName )

RETURN nError == 0

* ----------------

FUNCTION AX_FileOrder() // Not completed

RETURN OrdNumber()

* ----------------

FUNCTION AX_GetDrive( cAlias )

LOCAL nError, nHandle, cFileName := Space(200)
nHandle := _GetTableHandle()
nError := AdsGetTableFilename( nHandle, ADS_FULLPATHNAME, @cFileName, 200 )

RETURN Trim(cFileName)

* ----------------

FUNCTION AX_GetLocks()

LOCAL nError, nHandle, aLocks

nHandle := _GetTableHandle()
nError := AdsGetAllLocks( nHandle, @aLocks, @nHandle )

RETURN aLocks

* ----------------

FUNCTION AX_I_IndexName() // Not completed
RETURN ''

* -----------------

FUNCTION AX_I_TagName() // Not completed
RETURN ''

* ----------------

FUNCTION AX_IndexCount()

LOCAL nHandle := 0, aIndex := {},  nLength := 0

nHandle := _GetTableHandle()
AdsGetAllIndexes( nHandle, @aIndex, @nLength )

RETURN LEN(aIndex)

* ----------------

FUNCTION AX_IndexFilt( nOrder )

LOCAL nHandle := 0, nLength := 1000, cFilter := SPACE(nLength), nIndex := 0
IF Empty(Alias())
   RETURN ''
ENDIF
nHandle := _GetTableHandle()
DEFAULT nOrder TO OrdNumber()
AdsGetIndexHandleByOrder( nHandle, nOrder, @nIndex )
AdsGetIndexCondition( nIndex, @cFilter, @nLength )

RETURN SUBSTR(cFilter,1,nLength)

* ----------------

FUNCTION AX_IndexName( nOrder )

LOCAL nHandle := 0, nLength := 1000, cName := SPACE(nLength), nIndex := 0

IF Empty(Alias())
   RETURN ''
ENDIF
nHandle := _GetTableHandle()
DEFAULT nOrder TO OrdNumber()
AdsGetIndexHandleByOrder( nHandle, nOrder, @nIndex )
AdsGetIndexFileName( nIndex, ADS_FULLPATHNAME, @cName, @nLength )

RETURN SUBSTR(cName,1,nLength)

* ----------------

FUNCTION AX_IndexType( cnOrder )  // contributed by Mark Butler

LOCAL nHandle := 0, nIndex := 0,nIsCompound := 0,nLength := 1000,;
      cIndexName := SPACE(nLength),nError := 0
/* From the Advantage Norton Guide:
Returns   0 = No index found
          1 = Non-compact IDX  (unsupported, can't identify this type)
          2 = Compact IDX
          3 = CDX
          4 = NTX
*/
IF Empty(Alias()) .OR. OrdNumber() = 0
   RETURN 0 // no index found
ENDIF
nHandle := _GetTableHandle()
IF Valtype(cnOrder) = 'N'
   nError := AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
   nError := AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
   nError := AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
IF nError != 0
   RETURN 0  // bad order name/number specified or other error
ENDIF
AdsIsIndexCompound( nIndex, @nIsCompound )
IF nIsCompound != 0
   RETURN 3  // compound indexes are CDX type
ENDIF
// non-compound index, use file extension to determine return value
AdsGetIndexFileName( nIndex, ADS_FULLPATHNAME, @cIndexName, @nLength )
cIndexName := SUBSTR(cIndexName,1,nLength)
IF SUBSTR(cIndexName,RAT('.',cIndexName) + 1) == 'NTX'
   RETURN 4  // NTX type (this only works if user is using standard file extensions)
ENDIF

RETURN 2 // assume Compact IDX

* ----------------

FUNCTION AX_IsFlocked()

LOCAL lIsLocked := .f., nHandle

IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
AdsIsTableLocked( nHandle, @lIsLocked )

RETURN lIsLocked

* ----------------

FUNCTION AX_IsLocked( nRecNo )

LOCAL aLocks
IF Empty(Alias())
  RETURN .f.
ENDIF
aLocks := AX_GetLocks()
DEFAULT nRecNo TO RecNo()

RETURN aScan( aLocks, nRecNo ) > 0

* ----------------

FUNCTION AX_IsReadOnly()

LOCAL nHandle, nOptions
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nOptions := 0
AdsGetTableOpenOptions( nHandle, @nOptions )

RETURN DC_BitTest( nOptions, ADS_READONLY )

* ----------------

FUNCTION AX_IsReindex() // Not Completed
RETURN .f.

* ----------------

FUNCTION AX_IsShared()

LOCAL lIsShared
IF !EMPTY(Alias())
  lIsShared := dbInfo( DBO_SHARED )
ELSE
  lIsShared := !SET(_SET_EXCLUSIVE)
ENDIF
RETURN lIsShared

* ----------------

FUNCTION AX_IsCustom( cnOrder, cCDXName )

LOCAL lCustom := .f., nHandle, nIndex
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
AdsIsIndexCustom( nIndex, @lCustom )

RETURN lCustom

* ----------------

FUNCTION AX_IsDescend( cnOrder, cCDXName )

LOCAL lDescend := .f., nHandle, nIndex
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
AdsIsIndexDescending( nIndex, @lDescend )

RETURN lDescend

* ----------------

FUNCTION AX_IsUnique( cnOrder, cCDXName )

LOCAL lUnique := .f., nHandle, nIndex, cFileName
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
AdsIsIndexUnique( nIndex, @lUnique )

RETURN lUnique

* ----------------

FUNCTION AX_KeyAdd( cnOrder, cCDXName )

LOCAL nHandle, nIndex
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF

RETURN AdsAddCustomKey( nIndex ) == 0

* ----------------

FUNCTION AX_KeyCount( cnOrder, cCDXName )

LOCAL nHandle, nIndex, nKeys := 0, cFileName

IF Empty(Alias())
  RETURN nKeys
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
AdsGetKeyCount( nIndex, ADS_RESPECTSCOPES, @nKeys )

RETURN nKeys

* ----------------

FUNCTION AX_KeyDrop( cnOrder, cCDXName )

LOCAL nHandle, nIndex
IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandle( nHandle, OrdNumber(), @nIndex )
ENDIF

RETURN AdsDeleteCustomKey( nIndex ) == 0

* ----------------

FUNCTION AX_KeyNo( cnOrder, cCDXName )

LOCAL nHandle, nIndex, nKey := 0, cFileName
IF Empty(Alias())
  RETURN nKey
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
ENDIF
AdsGetKeyNum( nIndex, ADS_RESPECTSCOPES, @nKey )

RETURN nKey

* ----------------

FUNCTION AX_KeysIncluded()

LOCAL nHandle, nIndex, nKeys := 0
IF Empty(Alias())
  RETURN nKeys
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
AdsGetIndexHandle( nHandle, OrdNumber(), @nIndex )
AdsGetKeyCount( nIndex, ADS_IGNOREFILTERS, @nKeys )

RETURN nKeys

* ----------------

FUNCTION AX_KeyVal( cnOrder, cCDXName )

LOCAL nHandle, cExpr, nLength, nIndex
IF Empty(Alias())
  RETURN nil
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
IF Valtype(cnOrder) = 'N'
  AdsGetIndexHandleByOrder( nHandle, cnOrder, @nIndex )
ELSEIF Valtype(cnOrder) = 'C'
  AdsGetIndexHandle( nHandle, cnOrder, @nIndex )
ELSE
  AdsGetIndexHandle( nHandle, OrdNumber(), @nIndex )
ENDIF
cExpr := Space(500)
nLength := 500
AdsGetIndexExpr( nIndex, @cExpr, @nLength )
cExpr := Alltrim(cExpr)

RETURN IIF( !Empty(cExpr),&(cExpr),nil )

* ----------------

FUNCTION AX_KillTag( lcTagName, cCDXName )

LOCAL nHandle, cExpr, nLength, nIndex, nError, nOrder
IF Empty(Alias())
  RETURN nil
ENDIF
nHandle := _GetTableHandle()
nIndex := 0
nError := 0
IF Valtype(lcTagName) = 'C'
  AdsGetIndexHandle( nHandle, lcTagName, @nIndex )
  nError := AdsDeleteIndex(nIndex)
ELSEIF Valtype(lcTagName) = 'L' .AND. lcTagName
  FOR nOrder := 1 TO 100
    nIndex := 0
    AdsGetIndexHandleByOrder( nHandle, nOrder, @nIndex )
    IF nIndex # 0
      AdsDeleteIndex(nIndex)
    ELSE
      EXIT
    ENDIF
  NEXT
ENDIF

RETURN nError == 0

* ----------------

STATIC FUNCTION _GetTableHandle()

LOCAL nHandle := 0, cFileName

cFileName := DbInfo(DBO_FILENAME)
AdsGetTableHandle( cFileName, @nHandle )

RETURN nHandle

* ----------------

FUNCTION AX_Loaded( cServer, nLoaded )

LOCAL nError

/*

Updated my Mark Butler.  Here are his notes (Thanks Mark) :

nLoaded will be set to the server type if Advantage is
loaded/started on the specified server and if no server is available.
The server types are ADS_AIS_SERVER, ADS_REMOTE_SERVER, and ADS_LOCAL_SERVER.
NOTE: I extended the functionality of AX_Loaded() by including the
nLoaded parm which according to the ACE SDK docs will return the
type of ADS server you're connected to.

*/

nLoaded := 0 // init pass-by-reference prior to DLLCall

nError := AdsIsServerLoaded( cServer, @nLoaded )

RETURN nError == 0

* ----------------

FUNCTION AX_MemoArrayStyle( cMemoStyle ) // Not supported
RETURN ''

* ----------------

FUNCTION AX_RddCount()

RETURN Len(DbeList())

* ----------------

FUNCTION AX_RddInfo( nArea )

LOCAL nSaveArea := nArea, cRddName, cOldDbe := dbeSetDefault(), aRddInfo

IF Valtype(nArea) = 'N'
  cRddName := DbInfo( DBO_DBENAME )
ELSEIF Valtype(nArea) = 'C'
  cRddName := nArea
ENDIF
aRddInfo := { ;
         cRddName, ;
         .t., ;
         DbeInfo( COMPONENT_DATA, DBE_EXTENSION ), ;
         DbeInfo( COMPONENT_ORDER, DBE_EXTENSION ), ;
         '', ;
         DbeInfo( COMPONENT_DATA, ADSDBE_MEMOFILE_EXT ) }

dbeSetDefault(cRddName)
SELE (nSaveArea)

RETURN aRddInfo

* ----------------

FUNCTION AX_RLock( naRecord )

LOCAL nHandle, aRecords, aStatus, i, nStatus

IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
IF Empty( naRecord )
  naRecord := RecNo()
ENDIF
IF Valtype( naRecord ) = 'N'
  aRecords := { naRecord }
ENDIF
aStatus := Array(Len(aRecords))
FOR i := 1 TO Len(aRecords)
   nStatus := AdsLockRecord( nHandle, aRecords[i] )
   aStatus[i] := IIF( nStatus==AE_LOCK_FAILED,.f.,.t. )
NEXT
IF Valtype(naRecord) = 'N'
   RETURN aStatus[1]
ENDIF
RETURN aStatus

* ----------------

FUNCTION AX_SeekLast( xKey, lSoftSeek )

LOCAL nIndex := 0, nKeyLen, lFound := .f., nHandle, nError

IF Empty(Alias())
  RETURN .f.
ENDIF
nHandle := _GetTableHandle()
AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )
IF Valtype(xKey) = 'C'
  nKeyLen := Len(xKey)
  nError := AdsSeekLast( nIndex, xKey, nKeyLen, ADS_STRINGKEY, @lFound )
ELSEIF Valtype(xKey) = 'N'
  nError := AdsSeekLast( nIndex, xKey, 8, ADS_DOUBLEKEY, @lFound )
ENDIF

RETURN lFound

* ----------------

FUNCTION AX_SetMemoBlock( nBlockSize )

RETURN dbeInfo( COMPONENT_DATA, ADSDBE_MEMOBLOCKSIZE, nBlockSize )

* ----------------

FUNCTION AX_SetFileOrd( nFileOrd )
RETURN .f.

* ----------------

FUNCTION AX_SetRdd( cRdd )

RETURN dbeSetDefault( cRdd )

* ----------------

FUNCTION AX_SetScope( nScope, xKey )

LOCAL nIndex, nHandle, nError, nKeyLen, xOldScope
DEFAULT nScope TO 0
IF nScope = 0
  nScope := ADS_TOP
ELSEIF nScope = 1
  nScope := ADS_BOTTOM
ENDIF

nHandle := _GetTableHandle()

nIndex := 0
AdsGetIndexHandleByOrder( nHandle, OrdNumber(), @nIndex )

xOldScope := Space(100)
nKeyLen := 100
nError := AdsGetScope( nIndex, nScope, @xOldScope, @nKeyLen )
IF Valtype(xOldScope) = 'C'
   xOldScope := Pad(xOldScope,nKeyLen)
ENDIF
IF Valtype(xKey) = 'C'
  nKeyLen := Len(xKey)
  nError := AdsSetScope( nIndex, nScope, xKey, @nKeyLen, ADS_STRINGKEY )
ELSEIF Valtype(xKey) = 'N'
  nError := AdsSetScope( nIndex, nScope, xKey, 8, ADS_DOUBLEKEY )
ENDIF

RETURN xOldScope

* ----------------

FUNCTION AX_SetTag( ncTagName, cCDXName )

IF Empty(Alias())
  RETURN .f.
ENDIF

RETURN OrdSetFocus( ncTagName )

* ----------------

FUNCTION AX_SetTagNo( ncTagName, cCDXName )

IF Empty(Alias())
  RETURN .f.
ENDIF

RETURN OrdSetFocus( ncTagName )

* ----------------

FUNCTION AX_SetTagOrder( nPosition )

RETURN dbSetOrder( nPosition )

* ----------------

FUNCTION AX_SkipUnique( nDirection )

LOCAL xValue := &(IndexKey(0)), xNewValue, nRecNo := RecNo()

DEFAULT nDirection TO 1
IF nDirection == 1
  SKIP
  xNewValue := &(IndexKey(0))
  IF xNewValue == xValue
    AX_SeekLast(xNewValue)
    SKIP
  ENDIF
ELSE
  SKIP -1
  xNewValue := &(IndexKey(0))
  IF xNewValue == xValue .AND. !Bof()
    SEEK xNewValue
    SKIP -1
  ENDIF
ENDIF

RETURN ( nRecNo # RecNo() )

* -----------------

FUNCTION AX_TableName()

LOCAL nHandle := 0, nLength := 1000, cFileName := Space(nLength)

IF Empty(Alias())
   RETURN ''
ENDIF
nHandle := _GetTableHandle()
AdsGetTableFilename( nHandle, ADS_FULLPATHNAME, @cFileName, @nLength )

RETURN SUBSTR(cFileName,1,nLength)

* -----------------

/*
FUNCTION AX_TableType()
LOCAL nHandle, lIsEncrypted := .f.

IF Empty(Alias())
  RETURN 0
ENDIF
nHandle := 0
AdsGetTableHandle( DBInfo(DBO_FILENAME), @nHandle )

AdsIsEncryptionEnabled( nHandle, @lIsEncrypted )

RETURN IIF( lIsEncrypted, 2, 1 )
*/

* -----------------

FUNCTION AX_TagCount( nFileOrder, lIsCompound )

LOCAL nHandle := 0, nIndex := 0, nLength := 0, aIndex := {}
lIsCompound := FALSE // init pass-by-reference (NOTE: This is extended functionality, we need it for AX_TagInfo() & AX_Tags())
IF Empty(Alias()) .OR. OrdNumber() = 0
   RETURN 0
ENDIF
IF VALTYPE(nFileOrder) != 'N'
   nFileOrder := OrdNumber()
ENDIF
nHandle := _GetTableHandle()
AdsGetAllIndexes( nHandle, @aIndex, @nLength )
nIndex := aIndex[nFileOrder]  // got index handle of index specified by <nFileOrder>
// return now depends on type of index specified by <nFileOrder>
lIsCompound := 0
AdsIsIndexCompound( nIndex, @lIsCompound )
lIsCompound := lIsCompound != 0  // fixup return of pass-by-reference
IF lIsCompound
   RETURN LEN(aIndex)
ENDIF
RETURN 1  // non-compound indexes only have 1 order "tag"

* -----------------

FUNCTION AX_TagInfo( nFileOrder )

/* From the Advantage Norton Guide:
   Returns a multi-dimensional array containing information about each
  tag in the .cdx file.  If the specified order is invalid or no index
  is open, it returns an empty array.

  This function returns an array of six element arrays, each containing
  information about a tag within the current or specified .cdx file.
  If <nFileOrder> is not specified, the current index is used.

  The following information is returned for each tag:
       [1] = Tag name
       [2] = Index key expression
       [3] = FOR clause expression (or "" if no FOR clause)
       [4] = Logical value - .T. if index is UNIQUE
       [5] = Logical value - .T. if index is DESCENDING order
       [6] = Logical value - .T. if index is CUSTOM order

  This function can also be used with .idx and .ntx files.  It returns a
  single element array containing an array with the above information.
  The index name is given in place of the tag name.
*/

LOCAL nTags, aTagInfo := {}, i,lIsCompound
IF Empty(Alias()) .OR. OrdNumber() = 0
   RETURN {}
ENDIF
IF VALTYPE(nFileOrder) != 'N'
   nFileOrder := OrdNumber()
ENDIF
// Get number of tags for current CDX or NTX or IDX
nTags := AX_TagCount(nFileOrder,@lIsCompound )
IF lIsCompound
   // compound index CDX
   FOR i := 1 TO nTags
      // Store tag info for all tags in .CDX
      AADD(aTagInfo,{ AX_TagName(i), ;
                      IndexKey(i), ;
                      AX_IndexFilt(i), ;
                      AX_IsUnique(i), ;
                      AX_IsDescend(i), ;
                      AX_IsCustom(i) })
   NEXT
ELSE
   // non-compound index NTX or IDX
   FOR i := 1 TO nTags
      // Store tag info for NTX or IDX - single order
      AADD(aTagInfo,{ AX_TagName(nFileOrder), ;
                      IndexKey(nFileOrder), ;
                      AX_IndexFilt(nFileOrder), ;
                      AX_IsUnique(nFileOrder), ;
                      AX_IsDescend(nFileOrder), ;
                      AX_IsCustom(nFileOrder) })
   NEXT
ENDIF
RETURN aTagInfo

* -----------------

FUNCTION AX_TagName( nFileOrder )

LOCAL nHandle := 0, nIndex := 0, nLength := 128, cTagName := SPACE(nLength)

IF Empty(Alias()) .OR. OrdNumber() = 0
   RETURN ''
ENDIF
IF VALTYPE(nFileOrder) != 'N'
   nFileOrder := OrdNumber()
ENDIF
nHandle := _GetTableHandle()
AdsGetIndexHandleByOrder( nHandle, nFileOrder, @nIndex )
AdsGetIndexName( nIndex, @cTagName, @nLength )

RETURN SUBSTR(cTagName,1,nLength)

* -----------------

FUNCTION AX_TagNo( nFileOrder ) // Not completed

RETURN OrdNumber()

* -----------------

FUNCTION AX_TagOrder()

RETURN OrdNumber()

* -----------------

FUNCTION AX_Tags( nFileOrder )
LOCAL lIsCompound, nTags, aTags := {},i
// Get number of tags for current CDX or NTX or IDX
IF (nTags := AX_TagCount(nFileOrder,@lIsCompound )) = 0
   RETURN {}
ENDIF
IF lIsCompound
   // Store tag name for all tags in .CDX
   FOR i := 1 TO nTags
      AADD(aTags,AX_TagName(i))
   NEXT
ELSE
   // Store tag name for NTX or IDX - single order
   AADD(aTags,AX_TagName(nFileOrder))
ENDIF
RETURN aTags

* -----------------

FUNCTION AX_TPSCleanUp( cServerName )

LOCAL nError
nError := AdsFailedTransactionRecovery( cServerName )
RETURN nError == 0

* -----------------

FUNCTION AX_Transaction( nMode )

LOCAL nError, nHandle

DEFAULT nMode TO 0
nHandle := _GetTableHandle()

IF nMode = 1
  nError := AdsBeginTransaction( nHandle )
ELSEIF nMode = 2
  nError := AdsCommitTransaction( nHandle )
ELSEIF nMode = 3
  nError := AdsRollbackTransaction( nHandle )
ENDIF

RETURN nError == 0

* -----------------

FUNCTION AX_UnLock( naRecord )

LOCAL nHandle, aRecords, i

IF Empty(Alias())
  RETURN nil
ENDIF
nHandle := _GetTableHandle()
IF Empty(naRecord)
   AdsUnlockTable( nHandle )
ELSE
  IF Empty( naRecord )
    naRecord := RecNo()
  ENDIF
  IF Valtype( naRecord ) = 'N'
    aRecords := { naRecord }
  ENDIF
  FOR i := 1 TO Len(aRecords)
     AdsUnlockRecord( nHandle, aRecords[i] )
  NEXT

ENDIF
RETURN nil

* -----------------

FUNCTION AX_UserLockID( nRecNo ) // Not completed
RETURN ''


* ------------------

FUNCTION AX_Version ( nType ) // Contributed by Mark Butler

LOCAL xReturn := '',nMajor := 0, nMinor := 0, nLength := 500, ;
      cVersion := SPACE(1),cDescription := SPACE(nLength),;
      aFile,cDLL := 'ACE32.DLL',dDate := CTOD(''),cTime := ''

IF VALTYPE(nType) != 'N'
   nType := 0
ENDIF
AdsGetVersion( @nMajor, @nMinor, @cVersion, @cDescription, @nLength )
cDescription := SUBSTR(cDescription,1,nLength)
// get date/time of ACE32.DLL
IF EMPTY(aFile := DIRECTORY(cDLL))
   // didn't find it in the current dir, check EXE dir
   aFile := DIRECTORY(LEFT(AppName(.T.),RAT('\',AppName(.T.))) + cDLL)
ENDIF
IF LEN(aFile) > 0
   dDate := aFile[1,3]
   cTime := aFile[1,4]
ENDIF
// From the Advantage Norton Guide:
// Returns one of four values, depending on the value of nType:
DO CASE
CASE nType == 0
   // 0 = Primary version number as a string ( "5.0" )
   xReturn := TRIM(LTRIM(STR(nMajor)) + '.' + LTRIM(STR(nMinor)) + cVersion)
CASE nType == 1
   // 1 = Date stamp of release as a DATE type ( "03/30/98" )
   xReturn := dDate
CASE nType == 2
   // 2 = Time stamp of release as a string ( "5:20a" )
   xReturn := cTime
CASE nType == 3
   //  3 = A string containing the following information:
   //      product name, dialect, version number, date stamp, and
   //      time stamp.  (For example: "Advantage RDD for CA-Clipper 5.2, CDX/IDX, 5.0, 03/30/98, 5:20a")
   xReturn := cDescription + SPACE(1) + TRIM(LTRIM(STR(nMajor)) + '.' + LTRIM(STR(nMinor)) + cVersion) + ', ' + DTOC(dDate) + SPACE(1) + cTime
   // Append Alaska ADSDBE Version info too CRLF delimeter
   xReturn += CHR(13) + CHR(10) + DbeInfo( COMPONENT_DATA, DBE_NAME ) + PADC('=',3) + DbeInfo( COMPONENT_DATA, DBE_VERSION ) + SPACE(1) + DbeInfo( COMPONENT_DATA, DBE_MANUFACTURER )
ENDCASE

RETURN xReturn

* ------------------

FUNCTION aofFilterInfo( )  // Contributed by Mark Butler

// Get information about a Client Advantage Optimized Filter
/*   From the Advantage Norton Guide:
     A single dimensional array containing information about the
     specified user-owned filter or the system-owned filter.

Description
     aofFilterInfo() returns a seven element array with information about
     a Client Advantage Optimized Filter.  The first element of the array
     contains the entire filter expression.  The second element contains
     the non-optimized part of the filter expression, if applicable.  The
     third element contains the optimization level of the filter:
     0 = not optimized, 1 = partially optimized, and 2 = fully optimized.
     The fourth element is the number of records that are in the filter.
     The fifth element is the maximum record number possible in the
     filter.  The sixth element is the filter's owner: 1 = system-owned
     filter, 2 = user-owned filter. The seventh element is the current
     record number positioned to in the filter.

     Note:  Use the following constants defined in AOF.CH to reference
     the elements of the info array:
     #define INFO_EXPR        1  // Complete filter expression
     #define INFO_NONEXPR     2  // Non-optimized part of the expression
     #define INFO_OPTLVL      3  // Optimization level: 0=None, 1=Partial, 2=Full
     #define INFO_COUNT       4  // Number of records in filter
     #define INFO_SIZE        5  // Maximum record number possible in the filter
     #define INFO_OWNER       6  // Filter Owner, 1=System, 2=User
     #define INFO_POS         7  // Current record positioned to in the filter
*/

LOCAL aReturn := {'','',0,0,0,0,0},nLength := 500,cBuffer := SPACE(nLength),n := 0,;
      nTableHandle := 0,nIndexHandle := 0

IF Empty(Alias()) .OR. OrdNumber() = 0
   RETURN aReturn
ENDIF
nTableHandle := _GetTableHandle()
AdsGetIndexHandleByOrder( nTableHandle, OrdNumber(), @nIndexHandle )
AdsGetAOF(nTableHandle,@cBuffer, @nLength )
aReturn[1] := SUBSTR(cBuffer,1,nLength) // Complete filter expression
n := 0; nLength := 500; cBuffer := SPACE(nLength); AdsGetAOFOptLevel(nTableHandle, @n, @cBuffer, @nLength )
aReturn[2] := SUBSTR(cBuffer,1,nLength) // Non-optimized part of the expression
aReturn[3] := ABS(n - 3)    // adjust Optimization level for compatability: 0=None, 1=Partial, 2=Full
n := 0; AdsGetKeyCount(nIndexHandle, 1, @n) // get count and respect filters
aReturn[4] := n             // Number of records in filter
aReturn[5] := LASTREC()     // Maximum record number possible in the filter
aReturn[6] := 1             // ?? Filter Owner, 1=System, 2=User
n := 0; AdsGetKeyNum(nIndexHandle, 1, @n)
aReturn[7] := n             // Current record positioned to in the filter

RETURN aReturn

* ------------

FUNCTION AdsSession( xSession, nWhich, lReturnAll )

LOCAL cSession, nThread := ThreadID()

STATIC aAdsSession[0]

DEFAULT nWhich TO 1, ;
        lReturnAll TO .f.

IF Len(aAdsSession) < nThread
  ASize(aAdsSession,nThread)
  aAdsSession[nThread] := {}
ENDIF

IF Len(aAdsSession[nThread]) < nWhich
  ASize(aAdsSession[nThread],nWhich)
ENDIF

IF lReturnAll
  RETURN aAdsSession
ENDIF

IF Valtype(xSession) == 'C'
  IF Valtype(aAdsSession[nThread,nWhich]) # 'O' .OR. ;
            !aAdsSession[nThread,nWhich]:isConnected()
    cSession := "DBE=ADSDBE;SERVER=" + xSession
    aAdsSession[nThread,nWhich] := DacSession():new(cSession)
    IF !aAdsSession[nThread,nWhich]:isConnected()
      MsgBox( "Unable to establish connection to ADS Server" + Chr(13) + ;
              cSession + Chr(13) + ;
              "Error Code: " + Alltrim(Str(aAdsSession[nThread,nWhich]:getLastError())) + Chr(13) + ;
              aAdsSession[nThread,nWhich]:getLastMessage() )
    ENDIF
  ENDIF
ELSEIF Valtype(xSession) == 'O'
  aAdsSession[nThread,nWhich] := xSession
ENDIF

RETURN aAdsSession[nThread,nWhich]

* -------------------

CLASS AdsStatement

EXPORTED:

VAR Handle, Statement, Alias, Session, Cursor, LastError

INLINE METHOD GetLastError()
RETURN(::LastError)

* -------------

INLINE METHOD Init(cStatement, oSession)

IF(ValType(oSession)!="O")
  MsgBox( 'Parameter Type error : oSession' + Chr(13) + ;
          '(passed to AdsStatement:Init())' )
  ::LastError := 3
  RETURN Self
ENDIF
IF(!oSession:IsDerivedFrom("DacSession"))
  MsgBox( 'Parameter passed is not a DacSession : oSession' + chr(13) + ;
          '(passed to AdsStatement:Init())' )
  ::LastError := 4
  RETURN Self
ENDIF
::Session := oSession

RETURN ::Open(cStatement)

* ------------

INLINE METHOD Close()

IF(::HANDLE==NIL)
  RETURN(.F.)
ENDIF

// cursor still open
IF (Used(::Alias))
  (::Alias)->(DbCloseArea())
ENDIF

// close statement
::LastError := AdsCloseSQLStatement( ::HANDLE)
::Statement := NIL
::HANDLE    := NIL
::Alias     := NIL

RETURN .t.

* -------------

INLINE METHOD Open(cStatement)

LOCAL nH, nError, nErrorLen, cErrorString

IF ValType(cStatement)!="C"
  MsgBox( 'Parameter Type Invalid : Statement' + Chr(13) + ;
               '(passed to AdsStatement:Open())' )
  ::LastError := 1
  RETURN self
ENDIF
IF(Upper(Left(cStatement,Len(KEYWORD_SELECT)))!=KEYWORD_SELECT)
  MsgBox( 'Unsupported SQL statement' + Chr(13) + ;
          '(passed to AdsStatement:Open())' )
  ::LastError := 2
  RETURN self
ENDIF
::Statement := cStatement

nH := 0x0
::LastError := AdsCreateSQLStatement( ::Session:getConnectionHandle(), @nH )
::HANDLE := nH
IF ::LastError > 0
  cErrorString := DC_AdsGetLastError()
  MsgBox(cErrorString)
ELSE
  ::LastError := AdsVerifySQL( nH, cStatement )
  IF ::LastError > 0
    cErrorString := DC_AdsGetLastError()
    MsgBox(cErrorString)
  ENDIF
ENDIF

// FIXME set default behav. on statement
RETURN self

* --------------

INLINE METHOD Execute( cAlias )

LOCAL rc := 0x0, nCursor := 0x0, cErrorString, nErrorLen, nError

::LastError := AdsExecuteSQLDirect( ::HANDLE , ::Statement , @nCursor )
IF ::LastError > 0
  cErrorString := DC_AdsGetLastError()
  MsgBox(cErrorString)
  RETURN ''
ENDIF

// feed cursor handle into dbusearea
DbUseArea( ,::Session, "<CURSOR>"+L2Bin(nCursor)+"</CURSOR>",cAlias)

IF (Used())
  ::Alias := Alias()
  ::Cursor := L2Bin(nCursor)
ENDIF

// return alias name
RETURN (::Alias)

ENDCLASS

* --------------

FUNCTION AdsCursor2Array( nCursorHandle )

LOCAL nNumFields := 0, i, cFieldName, nLength, lOk, ;
      aData[0], aFields[0], aColumn, nDidSkip, xValue, GetList[0]

AdsGoToTop(nCursorHandle)

nNumFields := 0
AdsGetNumFields( nCursorHandle, @nNumFields )

aColumn := Array(nNumFields)
FOR i := 1 TO nNumFields
  cFieldName := Space(20)
  nLength := 20
  AdsGetFieldName( nCursorHandle, i, @cFieldName, @nLength )
  cFieldName := Pad(cFieldName,nLength)
  AAdd( aFields, { cFieldName, ;
                   cFieldName, ;
                   nil, ;
                   AdsFieldBlock( nCursorHandle, cFieldName ) })

  aColumn[i] := cFieldName
NEXT
AAdd(aData,aColumn)
nDidSkip := 1
DO WHILE nDidSkip > 0
  nDidSkip := AdsSkipper(nCursorHandle,1)
  aColumn := Array(nNumFields)
  FOR i := 1 TO nNumFields
    xValue := Eval(aFields[i,4])
    aColumn[i] := xValue
  NEXT
  AAdd( aData, aColumn )
ENDDO

FOR i := 1 TO nNumFields
  ASize(aFields[i],3)
NEXT

AdsGoToTop(nCursorHandle)

RETURN aData

* --------------

FUNCTION AdsRunSQL( cSqlStatement, cAlias )

LOCAL oDictConnection, oStatement

oDictConnection := DC_AdsSessionDict( '.ADD' )

oStatement := AdsStatement():New(cSqlStatement,oDictConnection)
IF oStatement:LastError > 0
  RETURN .f.
ENDIF

cAlias := oStatement:Execute( cAlias )

RETURN !Empty(cAlias)

* --------------

FUNCTION AdsFieldBlock( nCursor, cFieldName, bFormat )

LOCAL cBlock, bBlock, nFieldPos, nFieldLen, nFieldDec, nFieldType, cGet, cSet

nFieldType := 0
nFieldDec := 0

AdsGetFieldType( nCursor, cFieldName, @nFieldType )

IF nFieldType = ADS_LOGICAL
  nFieldLen := 1
ELSEIF nFieldType = ADS_DATE
  nFieldLen := 10
ELSE
  nFieldLen := 0
  AdsGetFieldLength( nCursor, cFieldName, @nFieldLen )
ENDIF

AdsGetFieldDecimals( nCursor, cFieldName, @nFieldDec )

IF nFieldPos <> 0

   cGet := '(AdsGetField(' + Alltrim(Str(nCursor)) + ;
           ',"' + ;
           cFieldName + ;
           '",@a,b),a:=Pad(a,b)'

   IF nFieldType = ADS_LOGICAL
     cGet += ',a:=(a[1]$"TY")'
   ELSEIF nFieldType == ADS_DATE
     cGet += ',a:=CtoD(a)'
   ELSEIF nFieldType == ADS_NUMERIC .OR. nFieldType == ADS_DOUBLE .OR. nFieldType == ADS_INTEGER .OR. ;
          nFieldType == ADS_SHORTINT
     cGet += ',a:=Val(a)'
   ENDIF
   IF Valtype(bFormat) = 'B'
     cGet += ',Eval(' + DC_XtoC(bFormat) + ',a)'
   ENDIF

   cGet += ')'

   cSet := '(_AdsSetField(' + Alltrim(Str(nCursor)) + ;
           ',"' + ;
           cFieldName + ;
           '",x,b,' + Alltrim(Str(nFieldDec)) + '))'

   cBlock := '{|x,a,b|' + ;
             'a:=Space('+Alltrim(Str(nFieldLen)) + ;
             '),b:=' + Alltrim(Str(nFieldLen)) + ',' + ;
             cGet + ',IIF(x==nil .OR. x==a, a,' + cSet + ')'

   cBlock += '}'
   bBlock := &(cBlock)

ENDIF

RETURN bBlock

* ------------

FUNCTION _AdsSetField( nHandle, cFieldName, xValue, nLength, nDec )

LOCAL nError, cErrorString, nErrorLen

IF Valtype(xValue) = 'N'
  xValue := Str(xValue,nLength,nDec)
ELSEIF Valtype(xValue) = 'D'
  xValue := DC_XtoC(xValue)
ELSEIF Valtype(xValue) = 'L'
  xValue := IIF(xValue,'Y','N')
ENDIF

nError := AdsSetField( nHandle, cFieldName, xValue, nLength )

cErrorString := Space(250)
nErrorLen := 250
nError := 0
AdsGetLastError(@nError,@cErrorString,@nErrorLen)
cErrorString := Strtran(Pad(cErrorString,nErrorLen),';',Chr(13))

IF nError > 0
  MsgBox(cErrorString)
ENDIF

RETURN nError

* ----------

FUNCTION AdsSkipper( nCursorHandle, nWantSkip, lAppend )

LOCAL nDidSkip := 0, nRecCount := 0, nEof := 0, nBof := 0

AdsGetRecordCount( nCursorHandle, ADS_IGNOREFILTERS, @nRecCount )
AdsAtEof( nCursorHandle, @nEof)

IF PCount() < 3
  lAppend := .F.
ENDIF

DO CASE

   CASE nRecCount == 0
   CASE nWantSkip == 0
      AdsSkip(nCursorHandle,0)

   CASE nWantSkip > 0 .AND. nEof == 0

      /* Skip down */
      DO WHILE nDidSkip < nWantSkip
         AdsSkip(nCursorHandle,1)
         AdsAtEof( nCursorHandle, @nEof)
         IF nEof == 1
            IF lAppend
               /* Append Mode: Ghost record */
               nDidSkip ++
            ELSE
              AdsSkip(nCursorHandle,-1)
            ENDIF
            EXIT
         ENDIF
         nDidSkip ++
      ENDDO

   CASE nWantSkip < 0

      /* Skip up */
      DO WHILE nDidSkip > nWantSkip
         AdsSkip(nCursorHandle,-1)
         AdsAtBof( nCursorHandle, @nBof)
         IF nBof == 1
            EXIT
         ENDIF
         nDidSkip --
      ENDDO

   ENDCASE

RETURN  nDidSkip

* ------------------

FUNCTION AdsGoPosition( nCursor, nPosition )

LOCAL nRecCount := 0, nRecNo
nPosition := nPosition / 100

AdsGetRecordCount( nCursor, ADS_IGNOREFILTERS, @nRecCount )
nRecNo := Int( nRecCount * nPosition )
IF nRecNo <= 0
  nRecNo := 1
ENDIF
AdsGotoRecord(nCursor,nRecNo)

RETURN nil

* ------------------

FUNCTION AdsPosition( nCursor )

LOCAL nRecNo := 0, nRecCount := 0, nPosition

AdsGetRecordCount( nCursor, ADS_IGNOREFILTERS, @nRecCount )
AdsGetRecordNum(nCursor,ADS_IGNOREFILTERS,@nRecNo)

nPosition := Int(( nRecNo / nRecCount ) * 100)
IF nPosition < 1
  nPosition := 1
ENDIF

RETURN nPosition

