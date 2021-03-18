/*
 * The simplest stored procedure example.
 *
 * Call a stored procedure that has no parameters and produces no output.
 * The stored procedure returns 12345 as an error message, so that it is obvious
 * that it actually ran.
 */


#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <crtdbg.h>

#include "examples.h"

void Example1()
{
   ADSHANDLE   hStmt;
   ADSHANDLE   hCursor;
   ADSHANDLE   hConnect;
   ADSHANDLE   hADD;
   SIGNED8     acADDName[ ADS_MAX_PATH ];
   SIGNED8     acTempName[ ADS_MAX_PATH ];
   SIGNED8     acBuffer[ 2000 ];

   strcpy( acADDName, DATA_DIRECTORY );
   strcat( acADDName, "StoredProcExample.ADD" );

   /* clean all examples files from the drive */
   DeleteFile( acADDName );
   strcpy( acTempName, DATA_DIRECTORY );
   strcat( acTempName, "StoredProcExample.AI" );
   DeleteFile( acTempName );
   strcpy( acTempName, DATA_DIRECTORY );
   strcat( acTempName, "StoredProcExample.AM" );
   DeleteFile( acTempName );


   ACECHECK( AdsSetServerType( SERVER_TYPE ));

   /* create the dictionary */
   ACECHECK( AdsDDCreate( acADDName, 0 /* no encrypt */,
                          "Stored Procedure Example 1", &hADD ));
   ACECHECK( AdsDDClose( hADD ));

   /*
    * Open the ADD with the administrative password.  This produces an
    * administrative connection that can be used to manipulate the ADD.
    * Then, create an SQL statement and add the stored procedure to it
    */
   ACECHECK( AdsConnect60( acADDName, SERVER_TYPE, "ADSSYS", NULL, ADS_DEFAULT, &hConnect ) );
   ACECHECK( AdsCreateSQLStatement( hConnect, &hStmt ) );

   /*
    * For the next SQL statement to work, the stored procedure file named
    * Example1StoredProc.AEP must exist in the same directory as the
    * ADD file named StoredProcExample.ADD.  The .AEP file may be located
    * in a different directory or may have a different extension.  In either
    * of those cases, the path/file name must be surrounded with double quotes.
    * A C example would be
    *    "... IN LIBRARY \"..\STORED_PROCS\Example1StoredProc.DLL"
    */
   strcpy( acBuffer, "CREATE PROCEDURE Example1StoredProc() "
                     "FUNCTION Example1StoredProc IN LIBRARY Example1StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );


   /*
    * call the stored procedure -- should get back an ADS SQL error containing
    * the 12345 value since that is returned from the stored procedure
    */
   ACECHECK( AdsExecuteSQLDirect( hStmt, "EXECUTE PROCEDURE Example1StoredProc()",
      &hCursor ));


   /* disconnect from the server */
   ACECHECK( AdsDisconnect( hConnect ));
}



int main(int argc, char *argv[] )
 {
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   Example1();
   AdsApplicationExit();
   return 0;
}

