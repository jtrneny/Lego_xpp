/*
 * This example demonstrates the use of stored procedure input parameters.
 * It also demonstrates how to use a global Advantage connection to be used
 * for all interaction with the Advantage Client Engine.  Also, the Startup
 * and Shutdown routines were used to initialize global variables in the
 * DLL.
 */


#include <windows.h>
#include <stdio.h>
#include <crtdbg.h>
#include <time.h>

#include "examples.h"

ADSHANDLE ghConnect = 0; // a global variable used for all data access
ADSHANDLE ghDataTable = 0; // a global variable used for all data access


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
   UNSIGNED32  ulRetCode;
   SIGNED8     acADDName[ ADS_MAX_PATH ];


   strcpy( acADDName, DATA_DIRECTORY );
   strcat( acADDName, "AepTester.ADD" );



   // the very first time this routine is executed, create a connection handle
   ulRetCode = AdsConnect60( acADDName,
                             SERVER_TYPE, // the server type from examples.h
                             NULL,        // connect with no user name
                             NULL,        // use no password
                             ADS_STORED_PROC, // a stored procedure connection
                             &ghConnect );
   if ( ulRetCode != AE_SUCCESS )
      {
      AdsShowError( "AdsConnect60 failed" );
      return FALSE;     // indicate that the DLL did not load properly
      }

   ulRetCode = AdsOpenTable( ghConnect,               // the dictionary connection handle
                             "Demo10",                // the name of the table
                             NULL,                    // alias are never necessary
                             ADS_DEFAULT,             // data table is in the dictionary
                             ADS_ANSI,                // set 
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

UNSIGNED32 _declspec( dllexport ) WINAPI Example2StoredProc
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



   _ASSERT( pucTable2 == NULL ); // this procedure has no output parameters, so
                                 // the output table value is NULL

   ulRetCode = AdsOpenTable( ghConnect,
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
   ulRetCode = AdsAppendRecord( ghDataTable );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetString( ghDataTable, "LastName", aucLastName, strlen( aucLastName ));
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetString( ghDataTable, "FirstName", aucFirstName, strlen( aucFirstName ));
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetShort( ghDataTable, "EMPID", sEmpID );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   ulRetCode = AdsSetLogical( ghDataTable, "Married", usMarried );
   if ( ulRetCode )
      goto ExitStoredProcedure;

   /* calculate today's date and insert that in the field named "Date Hired" */
   time( &ltime );
   pstToday = localtime( &ltime );

   /* the default date format is MM/DD/YYYY */
   sprintf( aucDate, "%02d/%02d/%04d", pstToday->tm_mon + 1, pstToday->tm_mday,
                                       1900+pstToday->tm_year );
   ulRetCode = AdsSetDate( ghDataTable, "DOH", aucDate,
                           (UNSIGNED16) strlen( aucDate ) );
   if ( ulRetCode )
      goto ExitStoredProcedure;


   /* Commit the update record so that it is visible to all users */
   ulRetCode = AdsWriteRecord( ghDataTable );
   if ( ulRetCode )
      goto ExitStoredProcedure;



ExitStoredProcedure:
   if ( hInput != 0 )
      AdsCloseTable( hInput );

   return ulRetCode;
} /* StoredProcedureExample2 */


