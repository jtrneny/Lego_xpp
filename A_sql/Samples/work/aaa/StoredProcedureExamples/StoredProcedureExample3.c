/*
 * This example demonstrates the use of stored procedure output parameters.
 */


#include <windows.h>
#include <stdio.h>
#include <crtdbg.h>
#include <time.h>

#include "examples.h"


ADSHANDLE ghConnect = 0; // a global variable used for all data access
ADSHANDLE ghDataTable = 0; // a global variable used for all data access


BOOL APIENTRY DllMain( HANDLE h,
                       DWORD  dwProcessState,
                       LPVOID lpVoid
                     )
{
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   /*
    * Never call Advantage from this routine.  This routine is called when
    * the Windows API LoadLibrary is called.  It is illegal to call LoadLibrary
    * from within DllMain.  Any call to ACE, will result in a LoadLibrary.
    */

   switch ( dwProcessState )
      {
      case DLL_PROCESS_ATTACH:
         break;

      case DLL_THREAD_ATTACH:
         break;

      case DLL_THREAD_DETACH:
         break;

      case DLL_PROCESS_DETACH:
         break;
      }
   return TRUE;
}


/******************************************************************************/

/*
 * This routine will be called when a user connects.
 */
UNSIGNED32 _declspec( dllexport ) WINAPI Startup
(
   UNSIGNED32  ulConnectionID, // (I) value used to associate a user/connection
                               //     and can be used to track the state
   UNSIGNED8   *pucUserName,   // (I) the user name who invoked this procedure
   UNSIGNED8   *pucPassword    // (I) the user's password in encrypted form
)
{
   SIGNED8     acADDName[ ADS_MAX_PATH ];
   UNSIGNED32  ulRetCode;

   strcpy( acADDName, DATA_DIRECTORY );
   strcat( acADDName, "StoredProcExample.ADD" );

   // the very first time this routine is executed, create a connection handle
   ulRetCode = AdsConnect60( acADDName,
                             SERVER_TYPE, // the server type from examples.h
                             NULL,        // connect with no user name
                             NULL,        // use no password
                             ADS_STORED_PROC,  // indicate this is for a stored proc
                             &ghConnect );
   if ( ulRetCode != AE_SUCCESS )
      {
      AdsShowError( "AdsConnect60 failed" );
      return FALSE;     // indicate that the DLL did not load properly
      }

   ulRetCode = AdsOpenTable( ghConnect,               // the dictionary connection handle
                             "Data",                  // the name of the table
                             NULL,                    // alias are never necessary
                             ADS_DEFAULT,                 // input tables are always ADT files
                             ADS_ANSI,                // input tables are always ANSI
                             ADS_PROPRIETARY_LOCKING, // with ADT files, this is ignored
                             ADS_IGNORERIGHTS,        // from the server, rights checking is unnecessary
                             ADS_DEFAULT,             // default options
                             &ghDataTable );

   if ( ulRetCode != AE_SUCCESS )
      {
      AdsShowError( "AdsOpenTable failed" );
      return FALSE;     // indicate that the DLL did not load properly
      }


   return AE_SUCCESS;
}


/******************************************************************************/

/*
 * This routine will be called when a user disconnects.
 */
UNSIGNED32 _declspec( dllexport ) WINAPI Shutdown
(
   UNSIGNED32  ulConnectionID, // (I) value used to associate a user/connection
                               //     and can be used to track the state
   UNSIGNED8   *pucUserName,   // (I) the user name who invoked this procedure
   UNSIGNED8   *pucPassword    // (I) the user's password in encrypted form
)
{
   /* if the ACE handle exists, close it */
   if ( ghConnect != 0 )
      AdsDisconnect( ghConnect );

   return AE_SUCCESS;
}


/******************************************************************************/



UNSIGNED32 _declspec( dllexport ) WINAPI Example3StoredProc
(
   UNSIGNED32  ulConnectionID, // (I) value used to associate a user/connection
                               //     and can be used to track the state
   UNSIGNED8   *pucUserName,   // (I) the user name who invoked this procedure
   UNSIGNED8   *pucPassword,   // (I) the user's password in encrypted form
   UNSIGNED8   *pucProcName,   // (I) the stored procedure name
   UNSIGNED32  ulRecNum,       // (I) reserved for triggers
   UNSIGNED8   *pucTable1,     // (I) table one.  For Stored Proc this table
                               //     contains all input parameters.  For
                               //     triggers, it contains the original field
                               //     values if the trigger is an OnUpdate or
                               //     OnDelete
   UNSIGNED8   *pucTable2      // (I) table two.  For Stored Proc this table
                               //     is empty and the users function will
                               //     optionally add rows to it as output.
                               //     For triggers, it contains the new field
                               //     values if the trigger is an OnUpdate or
                               //     OnInsert
)
{
   UNSIGNED32  ulRetCode;
   UNSIGNED32  ulLen;
   ADSHANDLE   hOutput;
   ADSHANDLE   hCursor;
   ADSHANDLE   hStmt;
   UNSIGNED32  ulMaxEmployeeID;
   UNSIGNED32  ulRecordCount;
   UNSIGNED32  ulUniqueLastNames;
   UNSIGNED8   aucNewestEmployee[200];


   _ASSERT( pucTable1 == NULL ); // this procedure has no input parameters, so
                                 // the input table value is NULL

   ulRetCode = AdsOpenTable( ghConnect,
                             pucTable2,
                             NULL,                    // alias are never necessary
                             ADS_ADT,                 // input tables are always ADT files
                             ADS_ANSI,                // input tables are always ANSI
                             ADS_PROPRIETARY_LOCKING, // with ADT files, this is ignored
                             ADS_IGNORERIGHTS,        // from the server, rights checking is unnecessary
                             ADS_DEFAULT,             // always open files read-write so that
                                                      // the server may access it in another instance
                             &hOutput );

   if ( ulRetCode )
      goto ExitStoredProcedure;


   /*
    * calculate all values to be output to the table, which are
    *    - the number of records in the table
    *    - the maximum Employee ID
    *    - the name of the newest employee hired in the format FIRSTNAME LASTNAME
    *    - the number of distict last names
    */
   ulRetCode = AdsCreateSQLStatement( ghConnect, &hStmt );


   /* record count */
   ulRetCode = AdsGetRecordCount( ghDataTable, ADS_IGNOREFILTERS, &ulRecordCount );
   if ( ulRetCode )
      goto ExitStoredProcedure;


   /* max employee ID */
   ulRetCode = AdsExecuteSQLDirect( hStmt, "SELECT MAX( EmployeeID ) FROM DATA",
                                    &hCursor );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsGetLong( hCursor, ADSFIELD( 1 ), &ulMaxEmployeeID );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitStoredProcedure;



   /* name of newest employee */
   ulRetCode = AdsExecuteSQLDirect( hStmt, "SELECT ( FirstName + LastName ) as FullName "
                                    "FROM data WHERE data.DateHired in"
                                    "( SELECT MAX( DateHired ) FROM data )", &hCursor );
   ulLen = sizeof( aucNewestEmployee );
   ulRetCode = AdsGetString( hCursor, "FullName", aucNewestEmployee, &ulLen, ADS_TRIM );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitStoredProcedure;


   /* get the number of unique last names */
   ulRetCode = AdsExecuteSQLDirect( hStmt, "SELECT LastName FROM data GROUP BY LastName",
                                    &hCursor );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsGetRecordCount( hCursor, ADS_IGNOREFILTERS, &ulUniqueLastNames );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitStoredProcedure;



   /*
    * Append a new record to the database table named DEMO.ADT and write the
    * parameters values to the output table
    */
   ulRetCode = AdsAppendRecord( hOutput );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetLong( hOutput, "MaxEmployeeID", ulMaxEmployeeID );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetLong( hOutput, "RecordCount", ulRecordCount );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetString( hOutput, "NewestEmployee", aucNewestEmployee,
                             strlen( aucNewestEmployee ));
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetLong( hOutput, "UniqueLastNameCount", ulUniqueLastNames );
   if ( ulRetCode )
      goto ExitStoredProcedure;


ExitStoredProcedure:
   if ( hOutput != 0 )
      AdsCloseTable( hOutput );

   return ulRetCode;
} /* StoredProcedureExample3 */


