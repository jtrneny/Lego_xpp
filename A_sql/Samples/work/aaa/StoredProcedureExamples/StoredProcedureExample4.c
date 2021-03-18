/*
 * This example demonstrates various aspects of stored procedure programming.
 * The problems solved in this example are:
 *    - multi-threading issues (see stCriticalSection)
 *    - maintaining the context of users' connections between stored procedure
 *      calls.  (see USER_CONNECTION_ENVIRONMENT and gastUserEnvironments)
 *    - transaction processing within procedures
 *    - global connection handles for use with logging and opening of input
 *      and output parameter files (see ghLogConnection, ghIOTablesConnect )
 *    - use of Startup and Shutdown to initialize both global and per
 *      connection environments (see Startup and Shutdown)
 *    - use of DLLMain to initiliaze global variables.  Note, do not ever
 *      initialize ACE from DLLMain.  (See DLLMain)
 *    - handling of input and output parameters within stored procedures.
 *      (See GetInfoForTable and AddRecordToData)
 */


#include <windows.h>
#include <stdio.h>
#include <io.h>
#include <crtdbg.h>
#include <time.h>

#include "examples.h"

ADSHANDLE ghLogConnection = 0;// the dictionary connection that ghLogTable uses
ADSHANDLE ghLogTable = 0;     // a global variable used for all access to the log file
CRITICAL_SECTION stCriticalSection; // a windows critical section used to
                                    // enforce synchronous access to ghLogTable.
                                    // (ie. Make the handling of ghLogTable
                                    // threadsafe )

#define MAX_USER_CONNECTIONS 100 // only support 100 seperate user connections
typedef struct
{
   UNSIGNED32  ulConnID;
   ADSHANDLE   hConnect;
   ADSHANDLE   hDataTable;
   ADSHANDLE   hStmt;
   UNSIGNED32  ulCallCount;
} USER_CONNECTION_ENVIRONMENT;
USER_CONNECTION_ENVIRONMENT gastUserEnvironments[ MAX_USER_CONNECTIONS ];


ADSHANDLE ghIOTablesConnect = 0; // the connection used to read and write
                                 // all input and output tables.  See Startup
                                 // for more information

/******************************************************************************/

UNSIGNED32 GetUsersEnvironment
(
   UNSIGNED32 ulConnectionID,                // (I) the connection ID to search for
   USER_CONNECTION_ENVIRONMENT **ppstUserEnv // (O) the users environment associated
                                             //     with ulConnectionID.
)
{
   UNSIGNED32  ulIndex;


   for ( ulIndex = 0; ulIndex < MAX_USER_CONNECTIONS; ulIndex++ )
      {
      if ( gastUserEnvironments[ ulIndex ].ulConnID == ulConnectionID )
         {
         *ppstUserEnv = &gastUserEnvironments[ ulIndex ];
         (*ppstUserEnv)->ulCallCount++;
         return AE_SUCCESS;
         }
      }

   /* should never get here */
   _ASSERT( ulIndex >= 0 );

   return 100001; // some error code
}


/******************************************************************************/

UNSIGNED32 AddLogEntry
(
   UNSIGNED8  *pucUserName,  // (I) The user name
   UNSIGNED32 ulConnID,      // (I) The users connection ID
   UNSIGNED8  *pucProcName   // (I) The stored procedure name
)
{
   UNSIGNED32   ulRetCode;
   SYSTEMTIME   stTime;
   UNSIGNED8    aucTime[ 200 ];


   /*
    * add a log entry to the log table.
    *
    * It is important to note that only one table handle exists and this
    * function may be called by multple users at the same time on different
    * threads.  To make this thread-safe, use a critical section.  Of course
    * ACE is threadsafe, but this is still necessary.  Consider this case.
    * User 1 calls this function.  A record is appended and two of the
    * three fields are written.  Then, the OS preempts this thread.  User 2
    * calls this function on a second thread.  That thread appends to the
    * table using the SAME ACE HANDLE.  This causes the current record to
    * move prior to user 1 finishing his log entry.
    *
    * If each user had his own ACE handle to log file, this would not be
    * a problem.  But, in this case, all users are sharing one.
    */

   EnterCriticalSection( &stCriticalSection );

   /* no other thread can enter this code at the same time */

   ulRetCode = AdsAppendRecord( ghLogTable );
   if ( ulRetCode != 0 )
      goto ExitAddLogEntry;


   ulRetCode = AdsSetField( ghLogTable, "User", pucUserName, strlen( pucUserName ));
   if ( ulRetCode != 0 )
      goto ExitAddLogEntry;

   ulRetCode = AdsSetLong( ghLogTable, "ConnID", ulConnID );
   if ( ulRetCode != 0 )
      goto ExitAddLogEntry;

   ulRetCode = AdsSetField( ghLogTable, "ProcName", pucProcName, strlen( pucProcName ));
   if ( ulRetCode != 0 )
      goto ExitAddLogEntry;


   GetLocalTime( &stTime );
   sprintf( aucTime, "%02d/%02d/%04d %02d:%02d:%02d:%3d",
            stTime.wMonth + 1, stTime.wDay, stTime.wYear,
            stTime.wHour, stTime.wMinute, stTime.wSecond, stTime.wMilliseconds );
   ulRetCode = AdsSetTimeStamp( ghLogTable, "Time", aucTime, strlen( aucTime ));
   if ( ulRetCode != 0 )
      goto ExitAddLogEntry;


ExitAddLogEntry:
   /* release the critical section */
   LeaveCriticalSection( &stCriticalSection );
   return ulRetCode;
}


/******************************************************************************/

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
         // create a critical section that will be used to make this DLL
         // thread-safe.  Any code that exists in DllMain is guaranteed
         // to be run by at most one thread at any given time.  The operating
         // provides this.
         InitializeCriticalSection( &stCriticalSection );

         // initialize the user environments
         memset( gastUserEnvironments, 0, sizeof( gastUserEnvironments ));

         break;

      case DLL_THREAD_ATTACH:
         break;

      case DLL_THREAD_DETACH:
         break;

      case DLL_PROCESS_DETACH:
         DeleteCriticalSection( &stCriticalSection );

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
   UNSIGNED32  ulRetCode;
   UNSIGNED32  ulIndex;
   SIGNED8     acFileName[ ADS_MAX_PATH + 1 ];


   /*
    * this function checks for existence of the log file, if it does not exist
    * then create it.  Note that this is not thread-safe.  Two users could call
    * this at the same time and both try to create the file.  So, use a
    * critical section
    */
   EnterCriticalSection( &stCriticalSection );



   /*
    * if a handle already exists for ghLogTable, then skip handling of  the
    * log table since it has been created and opened prior to this call
    */
   if ( ghLogTable == 0 )
      {
      // if ghLogTable was equal to zero, the ghLogConnection must be zero
      _ASSERT( ghLogConnection == 0 );


      // does the log table exist?
      strcpy( acFileName, DATA_DIRECTORY );
      strcat( acFileName, "StoredProcedureLog.ADT" );
      if ( (_access( acFileName, 6 /* read write access */ )) == -1 )
         {
         // connect using an ADMIN connection which is required to add a table to
         // the dictionary
         strcpy( acFileName, DATA_DIRECTORY );
         strcat( acFileName, "StoredProcExample.ADD" );
         ulRetCode = AdsConnect60( acFileName,
                                   SERVER_TYPE,
                                   "ADSSYS",        // the admin user ID
                                   NULL,            // no password
                                   ADS_STORED_PROC, // a stored procedure connection
                                   &ghLogConnection );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         // create the log file since it does not exist
         strcpy( acFileName, DATA_DIRECTORY );
         strcat( acFileName, "StoredProcedureLog.ADT" );
         ulRetCode = AdsCreateTable( ghLogConnection,
                                     acFileName,
                                     NULL,         // no Alias
                                     ADS_ADT,      // an ADT file
                                     ADS_ANSI,     // ANSI characters
                                     ADS_PROPRIETARY_LOCKING, // ignored with ADTs
                                     ADS_IGNORERIGHTS, // ignore rights since this
                                                       // is run at the server
                                     ADS_DEFAULT,  // the default memo block size
                                     "User, CHAR, 20;"
                                     "ConnID, INTEGER;"
                                     "Time, TIMESTAMP;"
                                     "ProcName, CHAR, 40;",
                                     &ghLogTable );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         // at ths point, the file is opened exclusively.  Close it so that it
         // may be open shared
         ulRetCode = AdsCloseTable( ghLogTable );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         // Disconnect from the admin account.  This example uses transaction
         // processing, which cannot be performed on an Administrative connection
         ulRetCode = AdsDisconnect( ghLogConnection );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }
         }

      // connect using the default connection
      strcpy( acFileName, DATA_DIRECTORY );
      strcat( acFileName, "StoredProcExample.ADD" );
      ulRetCode = AdsConnect60( acFileName,
                                SERVER_TYPE,
                                pucUserName,
                                pucPassword,
                                ADS_STORED_PROC, // a stored procedure connection
                                &ghLogConnection );
      if ( ulRetCode )
         {
         LeaveCriticalSection( &stCriticalSection );
         return ulRetCode;
         }

      ulRetCode = AdsOpenTable( ghLogConnection,
                                "StoredProcedureLog",
                                NULL,                    // no alias
                                ADS_DEFAULT,             // whatever is in the dictionary
                                ADS_ANSI,
                                ADS_PROPRIETARY_LOCKING, // ignored with ADTs
                                ADS_IGNORERIGHTS,        // from the server, rights checking is unnecessary
                                ADS_DEFAULT,             // default options which is shared and
                                                         // readwrite
                                &ghLogTable );
      if ( ulRetCode )
         {
         LeaveCriticalSection( &stCriticalSection );
         return ulRetCode;
         }



      /*
       * These set of stored procedures often use transaction processing.
       * Any changes to the database by a connection that is in a transaction
       * are not visable to any other connection to the database until the
       * transaction is committed.  Because of this, updates to the output
       * table may not occur within the connection that is in the transaction.
       * So, create a single global connection that will be used to write
       * to output tables.  Otherwise, if the transaction was not committed,
       * the client connection could not see the updates to the output table.
       *
       * The Advantage Client Engine is threadsafe.  So, even though these
       * stored procedures may be executed by any number of threads, one
       * global connection can be used to read all input and output tables
       * regardless if many threads are doing so at the same instant.
       */

     /* this code should only be run once, assert that ghIOTablesConnect = 0 */
     _ASSERT( ghIOTablesConnect == 0 );
     ulRetCode = AdsConnect60( DATA_DIRECTORY,  // this is not a dictionary bound connection
                                                // since this is the path to the
                                                // dictionary without the data dictionary
                                                // file name attached
                               SERVER_TYPE,
                               NULL,
                               NULL,
                               ADS_STORED_PROC, // a stored procedure connection
                               &ghIOTablesConnect );
     if ( ulRetCode )
        {
        LeaveCriticalSection( &stCriticalSection );
        return ulRetCode;
        }

      } /* if ( ghLogTable == 0 ) */



   /*
    * Does this user have a user environment for this particular connection
    * in this DLL?
    *
    * The critical section is necessary so that two threads do not try to
    * initialize the same element of the array at the same time
    */

#ifdef _DEBUG
   // check to ensure this user does not have an element of the list already
   for ( ulIndex = 0; ulIndex < MAX_USER_CONNECTIONS; ulIndex++ )
      _ASSERT( gastUserEnvironments[ ulIndex ].ulConnID != ulConnectionID );
#endif


   // find an empty element in the array
   for ( ulIndex = 0; ulIndex < MAX_USER_CONNECTIONS; ulIndex++ )
      if ( gastUserEnvironments[ ulIndex ].ulConnID == 0 )
         {

         /*
          * Found an empty element in the array of user environments.
          * Initialize the user's environment.  Get a dictionary connection
          * for use with all future stored procedure calls.  Also for use with
          * future stored procedure calls, get a table handle for the "data"
          * table and create an SQL statement handle.
          */


         strcpy( acFileName, DATA_DIRECTORY );
         strcat( acFileName, "StoredProcExample.ADD" );

         ulRetCode = AdsConnect60( acFileName,
                                   SERVER_TYPE,
                                   pucUserName,
                                   pucPassword,
                                   ADS_STORED_PROC, // a stored procedure connection
                                   &gastUserEnvironments[ ulIndex ].hConnect
                                   );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         ulRetCode = AdsOpenTable( gastUserEnvironments[ ulIndex ].hConnect,
                                   "Data",                  // the name of the table
                                   NULL,                    // alias are never necessary
                                   ADS_DEFAULT,             // input tables are always ADT files
                                   ADS_ANSI,                // input tables are always ANSI
                                   ADS_PROPRIETARY_LOCKING, // with ADT files, this is ignored
                                   ADS_IGNORERIGHTS,        // from the server, rights checking is unnecessary
                                   ADS_DEFAULT,             // default options
                                   &gastUserEnvironments[ ulIndex ].hDataTable );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         ulRetCode = AdsCreateSQLStatement( gastUserEnvironments[ ulIndex ].hConnect,
                                            &gastUserEnvironments[ ulIndex ].hStmt );
         if ( ulRetCode )
            {
            LeaveCriticalSection( &stCriticalSection );
            return ulRetCode;
            }

         gastUserEnvironments[ ulIndex ].ulCallCount = 0;
         gastUserEnvironments[ ulIndex ].ulConnID = ulConnectionID;

         break;   // quit the loop
         }

   LeaveCriticalSection( &stCriticalSection );

   if ( ulIndex == MAX_USER_CONNECTIONS )
      {
      MessageBox( 0, "The maximum number of user connections has been reached.",
                  "Error", MB_SERVICE_NOTIFICATION  );
      return 98765;  // some specific error number
      }


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "Startup" );

   return AE_SUCCESS;
} /* Startup */


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
   UNSIGNED32  ulRetCode;
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "Shutdown" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   /*
    * shutdown this users environment -- disconnect to close opened tables
    * and connections -- then free the pstUserEnv by setting it all to zeros
    */
   ulRetCode = AdsDisconnect( pstUserEnv->hConnect );

   memset( pstUserEnv, 0, sizeof( USER_CONNECTION_ENVIRONMENT ));

   return AE_SUCCESS;
} /* Shutdown */


/******************************************************************************/

UNSIGNED32 _declspec( dllexport ) WINAPI BeginTransaction
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
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;

   _ASSERT( pucTable1 == NULL ); // this procedure has no input parameters, so
                                 // the input table value is NULL

   _ASSERT( pucTable2 == NULL ); // this procedure has no output parameters, so
                                 // the output table value is NULL


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "BeginTransaction" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   ulRetCode = AdsBeginTransaction( pstUserEnv->hConnect );

   return ulRetCode;
} /* BeginTransaction */


/******************************************************************************/

UNSIGNED32 _declspec( dllexport ) WINAPI CommitTransaction
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
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;

   _ASSERT( pucTable1 == NULL ); // this procedure has no input parameters, so
                                 // the input table value is NULL

   _ASSERT( pucTable2 == NULL ); // this procedure has no output parameters, so
                                 // the output table value is NULL


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "CommitTransaction" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   ulRetCode = AdsCommitTransaction( pstUserEnv->hConnect );

   return ulRetCode;
} /* EndTransaction */


/******************************************************************************/

UNSIGNED32 _declspec( dllexport ) WINAPI RollBackTransaction
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
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;

   _ASSERT( pucTable1 == NULL ); // this procedure has no input parameters, so
                                 // the input table value is NULL

   _ASSERT( pucTable2 == NULL ); // this procedure has no output parameters, so
                                 // the output table value is NULL


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "RollbackTransaction" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   ulRetCode = AdsRollbackTransaction( pstUserEnv->hConnect );

   return ulRetCode;
} /* RollbackTransaction */


/******************************************************************************/

/* NOTE THAT THIS CODE IS ALMOST IDENTICAL TO Example2StoredProc */
UNSIGNED32 _declspec( dllexport ) WINAPI AddRecordToData
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
   UNSIGNED32 ulRetCode;
   UNSIGNED32 ulLen;
   ADSHANDLE  hInput;
   UNSIGNED8  aucLastName[ 200 ];
   UNSIGNED8  aucFirstName[ 200 ];
   SIGNED16   sEmpID;
   UNSIGNED16 usMarried;
   UNSIGNED8  aucDate[200];
   time_t     ltime;
   struct tm  *pstToday;
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;


   _ASSERT( pucTable2 == NULL ); // this procedure has no output parameters, so
                                 // the output table value is NULL


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "AddRecordToData" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   ulRetCode = AdsOpenTable( ghIOTablesConnect,       // use the global handle for IO tables
                             pucTable1,
                             NULL,                    // alias are never necessary
                             ADS_ADT,                 // input tables are always ADT files
                             ADS_ANSI,                // input tables are always ANSI
                             ADS_PROPRIETARY_LOCKING, // with ADT files, this is ignored
                             ADS_IGNORERIGHTS,        // from the server, rights checking is unnecessary
                             ADS_DEFAULT,             // always open files read-write so that
                                                      // the server may access it in another instance
                             &hInput );

   if ( ulRetCode )
      goto ExitStoredProcedure;


   /*
    * get each of the input parameter values
    */
   ulLen = sizeof( aucLastName );
   ulRetCode = AdsGetString( hInput, "LastName", aucLastName, &ulLen, ADS_TRIM );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulLen = sizeof( aucFirstName );
   ulRetCode = AdsGetString( hInput, "FirstName", aucFirstName, &ulLen, ADS_TRIM );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsGetShort( hInput, "EmpID", &sEmpID );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsGetLogical( hInput, "Married", &usMarried );


   /*
    * Append a new record to the database table named DEMO.ADT and write the
    * parameters values from the input table into that table
    */
   ulRetCode = AdsAppendRecord( pstUserEnv->hDataTable );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetString( pstUserEnv->hDataTable, "LastName", aucLastName, strlen( aucLastName ));
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetString( pstUserEnv->hDataTable, "FirstName", aucFirstName, strlen( aucFirstName ));
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetShort( pstUserEnv->hDataTable, "EmployeeID", sEmpID );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetLogical( pstUserEnv->hDataTable, "Married", usMarried );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   /* calculate today's date and insert that in the field named "Date Hired" */
   time( &ltime );
   pstToday = localtime( &ltime );

   /* the default date format is MM/DD/YYYY */
   sprintf( aucDate, "%02d/%02d/%04d", pstToday->tm_mon + 1, pstToday->tm_mday,
                                       1900+pstToday->tm_year );
   ulRetCode = AdsSetDate( pstUserEnv->hDataTable, "DateHired", aucDate,
                           (UNSIGNED16) strlen( aucDate ) );
   if ( ulRetCode )
      goto ExitStoredProcedure;


   /* Commit the update record so that it is visible to all users */
   ulRetCode = AdsWriteRecord( pstUserEnv->hDataTable );
   if ( ulRetCode )
      goto ExitStoredProcedure;



ExitStoredProcedure:
   if ( hInput != 0 )
      AdsCloseTable( hInput );

   return ulRetCode;
} /* AddRecordToData */


/******************************************************************************/

/* NOTE THAT THIS CODE IS ALMOST IDENTICAL TO Example3StoredProc */
UNSIGNED32 _declspec( dllexport ) WINAPI GetInfoForTable
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
   UNSIGNED32  ulMaxEmployeeID;
   UNSIGNED32  ulRecordCount;
   UNSIGNED32  ulUniqueLastNames;
   UNSIGNED8   aucNewestEmployee[200];
   USER_CONNECTION_ENVIRONMENT *pstUserEnv;


   _ASSERT( pucTable1 == NULL ); // this procedure has no input parameters, so
                                 // the input table value is NULL


   /* log the fact that this user called this stored procedure */
   AddLogEntry( pucUserName, ulConnectionID, "AddRecordToData" );


   /* retrieve this users environment, which is unique per connection */
   ulRetCode = GetUsersEnvironment( ulConnectionID, &pstUserEnv );
   _ASSERT( ulRetCode == AE_SUCCESS );
   _ASSERT( pstUserEnv != NULL );


   ulRetCode = AdsOpenTable( ghIOTablesConnect,       // use the global handle for IO tables
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
      goto ExitGetInfoForTable;


   /*
    * calculate all values to be output to the table, which are
    *    - the number of records in the table
    *    - the maximum Employee ID
    *    - the name of the newest employee hired in the format FIRSTNAME LASTNAME
    *    - the number of distict last names
    */

   /* record count */
   ulRetCode = AdsGetRecordCount( pstUserEnv->hDataTable, ADS_IGNOREFILTERS, &ulRecordCount );
   if ( ulRetCode )
      goto ExitGetInfoForTable;


   /* max employee ID */
   ulRetCode = AdsExecuteSQLDirect( pstUserEnv->hStmt, "SELECT MAX( EmployeeID ) FROM DATA",
                                    &hCursor );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsGetLong( hCursor, ADSFIELD( 1 ), &ulMaxEmployeeID );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitGetInfoForTable;



   /* name of newest employee */
   ulRetCode = AdsExecuteSQLDirect( pstUserEnv->hStmt, "SELECT ( FirstName + LastName ) as FullName "
                                    "FROM data WHERE data.DateHired in"
                                    "( SELECT MAX( DateHired ) FROM data )", &hCursor );
   ulLen = sizeof( aucNewestEmployee );
   ulRetCode = AdsGetString( hCursor, "FullName", aucNewestEmployee, &ulLen, ADS_TRIM );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitGetInfoForTable;


   /* get the number of unique last names */
   ulRetCode = AdsExecuteSQLDirect( pstUserEnv->hStmt, "SELECT LastName FROM data GROUP BY LastName",
                                    &hCursor );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsGetRecordCount( hCursor, ADS_IGNOREFILTERS, &ulUniqueLastNames );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsCloseTable( hCursor );
   if ( ulRetCode )
      goto ExitGetInfoForTable;



   /*
    * Append a new record to the database table named DEMO.ADT and write the
    * parameters values to the output table
    */
   ulRetCode = AdsAppendRecord( hOutput );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsSetLong( hOutput, "MaxEmployeeID", ulMaxEmployeeID );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsSetLong( hOutput, "RecordCount", ulRecordCount );
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsSetString( hOutput, "NewestEmployee", aucNewestEmployee,
                             strlen( aucNewestEmployee ));
   if ( ulRetCode )
      goto ExitGetInfoForTable;

   ulRetCode = AdsSetLong( hOutput, "UniqueLastNameCount", ulUniqueLastNames );
   if ( ulRetCode )
      goto ExitGetInfoForTable;


ExitGetInfoForTable:
   if ( hOutput != 0 )
      AdsCloseTable( hOutput );

   return ulRetCode;
} /* GetInfoForTable */

