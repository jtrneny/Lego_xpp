/*
 * // Brett_Unresolved
 */
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <crtdbg.h>

#include "examples.h"


void CreateStoredProcedures( ADSHANDLE hConnect, ADSHANDLE hStmt )
{
   UNSIGNED32 ulRetCode;
   UNSIGNED16 usLen;
   UNSIGNED8  aucStoredProcName[ ADS_DD_MAX_OBJECT_NAME_LEN + 1 ];
   SIGNED8    acBuffer[ 2000 ];
   SIGNED8    acFileName[ ADS_MAX_PATH + 1 ];
   ADSHANDLE  hFindHandle;
   ADSHANDLE  hCursor;


   /* if the ADD does not already have the stored procedures in it, add them */

   usLen = sizeof( aucStoredProcName );
   ulRetCode = AdsDDFindFirstObject( hConnect,
                                     ADS_DD_PROCEDURE_OBJECT,
                                     NULL, // the dictionary is the parent
                                     aucStoredProcName,
                                     &usLen,
                                     &hFindHandle );
   if ( ulRetCode != AE_NO_OBJECT_FOUND )
      {
      // an object was found.  Check if it is one of the stored procs this
      // routine needs.  If so, assume all of the stored procs have been
      // added.
      AdsDDFindClose( hConnect, hFindHandle );

      if (( 0 == stricmp( aucStoredProcName, "Startup" )) ||
          ( 0 == stricmp( aucStoredProcName, "Shutdown" )) ||
          ( 0 == stricmp( aucStoredProcName, "BeginTransaction" )) ||
          ( 0 == stricmp( aucStoredProcName, "CommitTransaction" )) ||
          ( 0 == stricmp( aucStoredProcName, "RollBackTransaction" )) ||
          ( 0 == stricmp( aucStoredProcName, "GetInfoForTable" )) ||
          ( 0 == stricmp( aucStoredProcName, "AddRecordToData" )))
         // yep, it was a stored procedure that was expected, return
         return;
      } /* if ( ulRetCode != AE_NO_O... */


   /* delete the log file so that the stored procedures create it */
   strcpy( acFileName, DATA_DIRECTORY );
   strcat( acFileName, "StoredProcedureLog.ADT" );
   DeleteFile( acFileName );

   /* create the stored procs */

   strcpy( acBuffer,
           "CREATE PROCEDURE BeginTransaction()"
           "FUNCTION BeginTransaction IN LIBRARY Example4StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );

   strcpy( acBuffer,
           "CREATE PROCEDURE CommitTransaction()"
           "FUNCTION CommitTransaction IN LIBRARY Example4StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );

   strcpy( acBuffer,
           "CREATE PROCEDURE RollBackTransaction()"
           "FUNCTION RollBackTransaction IN LIBRARY Example4StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );


   strcpy( acBuffer,
           "CREATE PROCEDURE GetInfoForTable"
           "( "
           "   RecordCount INTEGER OUTPUT, "
           "   MaxEmployeeID INTEGER OUTPUT, "
           "   NewestEmployee CHAR(41) OUTPUT, "
           "   UniqueLastNameCount INTEGER OUTPUT"
           ")"
           "FUNCTION GetInfoForTable IN LIBRARY Example4StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );


   strcpy( acBuffer,
           "CREATE PROCEDURE AddRecordToData"
           "( "
           "   LastName  CHAR(20), "
           "   FirstName CHAR(20),"
           "   EmpID     SHORT,       "
           "   Married   LOGICAL    "
           ")"
           "FUNCTION AddRecordToData IN LIBRARY Example4StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );

}



void Example4()
{
   ADSHANDLE   hStmt;
   ADSHANDLE   hStmt2;
   ADSHANDLE   hConnect2;
   UNSIGNED32  ulLen;
   ADSHANDLE   hCursor;
   ADSHANDLE   hConnect;
   SIGNED8     acBuffer[ 2000 ];
   SIGNED8     acADDName[ ADS_MAX_PATH ];

   strcpy( acADDName, DATA_DIRECTORY );
   strcat( acADDName, "StoredProcExample.ADD" );



   /*
    * Create the database and all associated files.  Returned an Administrative
    * connection to the database and an SQL statement handle.
    */
   MakeFiles( &hConnect, &hStmt );

   /*
    * create all stored procedures
    */
   CreateStoredProcedures( hConnect, hStmt );


   /*
    * Add two users
    */
//   AddUsers( hConnect );

   /*
    * Do not use the hConnect handle returned from MakeFiles.  It is the
    * Administrative account (ADSSYS).  The below code starts transactions
    * on the connection handle and that is not legal when using the
    * Administrative account.
    */
   ACECHECK( AdsDisconnect( hConnect ));

   /* use the default user account (NULL) */
   ACECHECK( AdsConnect60( acADDName, SERVER_TYPE, NULL, NULL, ADS_DEFAULT, &hConnect ) );
   ACECHECK( AdsCreateSQLStatement( hConnect, &hStmt ) );

   /*
    * at this point, the dictionary exists and the stored procedures have
    * all been created
    */

   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE BeginTransaction()",
                                  &hCursor ));

   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE AddRecordToData"
                                  "( 'Williams', 'Greg', 105, TRUE )", &hCursor ));


   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE GetInfoForTable()",
                                  &hCursor ));


   /* print the data returned */
   ulLen = sizeof( acBuffer );
   ACECHECK( AdsGetField( hCursor, "RecordCount", acBuffer, &ulLen, ADS_TRIM ));
   printf( "Record Count \t= %s\n", acBuffer );

   ulLen = sizeof( acBuffer );
   ACECHECK( AdsGetField( hCursor, "MaxEmployeeID", acBuffer, &ulLen, ADS_TRIM ));
   printf( "Max Employee ID \t= %s\n", acBuffer );

   ulLen = sizeof( acBuffer );
   ACECHECK( AdsGetField( hCursor, "NewestEmployee", acBuffer, &ulLen, ADS_TRIM ));
   printf( "Newest Employ \t= %s\n", acBuffer );

   ulLen = sizeof( acBuffer );
   ACECHECK( AdsGetField( hCursor, "UniqueLastNameCount", acBuffer, &ulLen, ADS_TRIM ));
   printf( "Unique Last Name Count \t = %s\n", acBuffer );


   /* close the cursor handle when finished */
   ACECHECK( AdsCloseTable( hCursor ));



   /*
    *
    * At this point, grab another connection and demonstrate that the
    * User name is identical, but the connection ID actually does change
    *
    */
   ACECHECK( AdsConnect60( acADDName, SERVER_TYPE, NULL, NULL, ADS_DEFAULT, &hConnect2 ) );
   ACECHECK( AdsCreateSQLStatement( hConnect2, &hStmt2 ) );

   ACECHECK( AdsExecuteSQLDirect( hStmt2,
                                  "EXECUTE PROCEDURE AddRecordToData"
                                  "( 'Connection 2', 'Connection ID Diff', 107, FALSE )", &hCursor ));

   ACECHECK( AdsExecuteSQLDirect( hStmt2,
                                  "EXECUTE PROCEDURE BeginTransaction()",
                                  &hCursor ));

   ACECHECK( AdsExecuteSQLDirect( hStmt2,
                                  "EXECUTE PROCEDURE AddRecordToData"
                                  "( 'Roll back This', 'Thomas', 121, FALSE )", &hCursor ));

   ACECHECK( AdsExecuteSQLDirect( hStmt2,
                                  "EXECUTE PROCEDURE RollbackTransaction()",
                                  &hCursor ));



   /*
    *
    * back to connection 1
    *
    */
   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE CommitTransaction()",
                                  &hCursor ));



   /* disconnect from the server */
   ACECHECK( AdsDisconnect( hConnect ));
   ACECHECK( AdsDisconnect( hConnect2 ));
}



int main(int argc, char *argv[] )
{
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   Example4();
   AdsApplicationExit();
   return 0;
}

