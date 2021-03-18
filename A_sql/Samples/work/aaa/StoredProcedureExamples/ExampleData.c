#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include <crtdbg.h>

#include "examples.h"

/*
 * The simplest stored procedure example.
 * Call a stored procedure that has no parameters and produces no output.
 * The stored procedure returns 12345 as an error message, so that it is obvious
 * that it actually ran.
 */
void MakeFiles( ADSHANDLE *phConnect, ADSHANDLE *phStmt )
{
   ADSHANDLE   hCursor;
   ADSHANDLE   hADD;
   SIGNED8     acADDName[ ADS_MAX_PATH ];
   SIGNED8     acTempName[ ADS_MAX_PATH ];

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
   strcpy( acTempName, DATA_DIRECTORY );
   strcat( acTempName, "DATA.ADT" );
   DeleteFile( acTempName );



   ACECHECK( AdsSetServerType( SERVER_TYPE ));

   /* create the dictionary */
   ACECHECK( AdsDDCreate( acADDName, 0 /* no encrypt */,
                          "Stored Procedure Example", &hADD ));
   ACECHECK( AdsDDClose( hADD ));

   /*
    * Open the ADD with the administrative password.  This produces an
    * administrative connection that can be used to manipulate the ADD.
    * Then, create an SQL statement and add the stored procedure to it
    */
   ACECHECK( AdsConnect60( acADDName, SERVER_TYPE, "ADSSYS", NULL, ADS_DEFAULT, phConnect ) );
   ACECHECK( AdsCreateSQLStatement( *phConnect, phStmt ) );


   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "CREATE TABLE DATA ( "
                                  "  EmployeeID SHORT, "
                                  "  LastName   CHAR(20), "
                                  "  FirstName  CHAR(20), "
                                  "  Married    LOGICAL, "
                                  "  DateHired  DATE )", &hCursor ));
   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "INSERT INTO DATA VALUES"
                                  "( 1, 'Jones', 'Ed', TRUE, '1984-05-22' )", &hCursor ));
   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "INSERT INTO DATA VALUES"
                                  "( 2, 'Smith', 'Bill', TRUE, '1989-07-14' )", &hCursor ));
   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "INSERT INTO DATA VALUES"
                                  "( 3, 'Anderson', 'Dan', FALSE, '1994-01-03' )", &hCursor ));
   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "INSERT INTO DATA VALUES"
                                  "( 4, 'Thompson', 'John', FALSE, '1968-11-30' )", &hCursor ));
   ACECHECK( AdsExecuteSQLDirect( *phStmt,
                                  "INSERT INTO DATA VALUES"
                                  "( 5, 'Wilson', 'Ann', FALSE, '2000-02-27' )", &hCursor ));

   return;
} /* void MakeFiles( ADSHANDLE... */



