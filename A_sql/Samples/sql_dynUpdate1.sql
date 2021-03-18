CREATE PROCEDURE 
     sp_a100101_newrecordtbl
   ( 
      tblName CHAR ( 10 )
   ) 
   BEGIN 
         
 declare tbl char( 10)   ;
 declare vUniqIdRec char( 10)   ;
 declare db char( 250)   ;
 declare dbName char( 6) ;
 declare iduniq char(12) ; 
 declare len integer     ;
 
 db     = database()  ;
 dbName = substring( db, position( '.add' IN db )-6, 6); 
 tbl    = upper(:tblName);  
 iduniq = ltrim( CAST( ( select test from __new)  as SQL_CHAR)) ; 
 len    = 12-LENGTH(Ltrim(CAST( ( SELECT test FROM __new)  as SQL_CHAR))) ;
 vUniqIdRec = substring(dbname+tbl+repeat('0', len ) + iduniq,1,28); 

/* Prepare a statement handle to be executed with a named parameter */
ulRetVal = AdsPrepareSQL( hSQL, 
		"update :tblName
         set cuniqidrec = :vUniqIdRec ,                                          
         where test = ( select test from __new) " );
if ( ulRetVal != AE_SUCCESS ) {
	/* some kind of error, tell the user what happened */
	AdsShowError( "ACE Couldn't Prepare Statement to be Executed" );
	return ulRetVal;
}


/* Execute the SQL statment */
ulRetVal = AdsExecuteSQL( hSQL, null );
if ( ulRetVal != AE_SUCCESS ) {
	/* some kind of error, tell the user what happened */
	AdsShowError( "ACE Couldn't Execute the Statement" );
	return ulRetVal;
}

   END;