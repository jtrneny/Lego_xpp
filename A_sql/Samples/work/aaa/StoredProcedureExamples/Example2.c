/*
 * This example demonstrates the use of input parameters to a stored procedure.
 *
 * The stored procedure appends a single row to the database table name demo.
 * The data appended in the stored procedure is retrieved from the values
 * passed to that stored procedure via the EXECUTE PROCEDURE statement.  The
 * stored procedure calculates the date and stores that date into the
 * "Date Hired" field.
 *
 * The values are passed by three different means in three different SQL
 * statements.  The first example includes all values in the SQL statement.
 * The second uses named parameters.  The last example uses unnamed parameters.
 */
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <crtdbg.h>

#include "examples.h"

void Example2()
{
   ADSHANDLE   hStmt;
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
           "CREATE PROCEDURE Example2StoredProc"
           "( "
           "   LastName  CHAR(20), "
           "   FirstName CHAR(20),"
           "   EmpID     SHORT,       "
           "   Married   LOGICAL    "
           ")"
           "FUNCTION Example2StoredProc IN LIBRARY Example2StoredProc" );
   ACECHECK( AdsExecuteSQLDirect( hStmt, acBuffer, &hCursor ) );


   /*
    * call the stored procedure -- should get back a zero indicating no error
    */
   ACECHECK( AdsExecuteSQLDirect( hStmt,
                                  "EXECUTE PROCEDURE Example2StoredProc"
                                  "( 'Williams', 'Greg', 105, TRUE )", &hCursor ));



   /*
    * now call the stored procedure using named parameters
    */
   ACECHECK( AdsPrepareSQL( hStmt, "EXECUTE PROCEDURE Example2StoredProc"
                            "( :ln, :fn, :id, :married )" ));
   /* set the parameter values */
   ACECHECK( AdsSetString( hStmt, "ln", "Campbell", strlen( "Campbell" )));
   ACECHECK( AdsSetString( hStmt, "fn", "James", strlen( "James" )));
   ACECHECK( AdsSetShort( hStmt, "id", 123 ));
   ACECHECK( AdsSetLogical( hStmt, "married", FALSE ));

   /* execute the statement */
   ACECHECK( AdsExecuteSQL( hStmt, &hCursor ));



   /*
    * one more time with unnamed parameters
    */
   ACECHECK( AdsPrepareSQL( hStmt, "EXECUTE PROCEDURE Example2StoredProc"
                            "( ?, ?, ?, ? )" ));
   /* set the parameter values */
   ACECHECK( AdsSetString( hStmt, ADSFIELD( 1 ), "Howell", strlen( "Howell" )));
   ACECHECK( AdsSetString( hStmt, ADSFIELD( 2 ), "Mike", strlen( "Mike" )));
   ACECHECK( AdsSetShort( hStmt, ADSFIELD( 3 ), 103 ));
   ACECHECK( AdsSetLogical( hStmt, ADSFIELD( 4 ), TRUE ));

   /* execute the statement */
   ACECHECK( AdsExecuteSQL( hStmt, &hCursor ));

   /* disconnect from the server */
   ACECHECK( AdsDisconnect( hConnect ));
}



int main(int argc, char *argv[] )
{
   // the constant DATA_DIRECTORY must end in a backslash
   _ASSERT( DATA_DIRECTORY[ strlen( DATA_DIRECTORY ) - 1 ] == '\\' );

   Example2();
   AdsApplicationExit();
   return 0;
}

