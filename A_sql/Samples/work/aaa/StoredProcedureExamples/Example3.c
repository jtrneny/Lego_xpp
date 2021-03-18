/*
 * This example demonstrates the use of output parameters with a stored procedure.
 *
 * The stored procedure returns information about the table named "DATA".
 * The returned data includes:
 *    - the number of records in the table
 *    - the maximum Employee ID
 *    - the name of the newest employee hired in the format FIRSTNAME LASTNAME
 *    - the number of distict last names
 */
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <crtdbg.h>

#include "examples.h"

void Example3()
{
   ADSHANDLE   hStmt;
   UNSIGNED32  ulLen;
   ADSHANDLE   hCursor;
   ADSHANDLE   hConnect;
   SIGNED8     acBuffer[ 2000 ];

   /*
    * Create the database and all associated files.  Returned an Administrative
    * connection to the database and an SQL statement handle.
    */
   MakeFiles( &hConnect, &hStmt );

 
   /*
    * create a stored procedure
    */
   strcpy( acBuffer,
           "CREATE PROCEDURE Example3StoredProc"
           "( "
           "   RecordCount INTEGER OUTPUT, "
           "   MaxEmployeeID INTEGER OUTPUT, "
           "   NewestEmployee CHAR(41) OUTPUT, "
           "   UniqueLastNameCount INTEGER OUTPUT"
           ")"
           "FUNCTION Example3StoredProc IN LIBRARY Example3StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );


   /*
    * call the stored procedure -- should get back a zero indicating no error
    */
   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE Example3StoredProc()",
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

   /* close the SQL handle */
   ACECHECK( AdsCloseSQLStatement( hStmt ));

   /* disconnect from the server */
   ACECHECK( AdsDisconnect( hConnect ));
}



int main(int argc, char *argv[] )
{
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   Example3();
   AdsApplicationExit();
   return 0;
}

