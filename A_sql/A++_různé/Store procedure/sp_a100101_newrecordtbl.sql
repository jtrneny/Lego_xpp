CREATE PROCEDURE sp_a100101_newrecordtbl( tblName char(10) ) 

  begin
   
    declare tbl char( 10)   ;
	declare db char( 250)   ;
	declare dbName char( 6) ;
	declare iduniq char(12) ; 
	declare len integer     ;
	
	db     = database()  ;
	dbName = substring( db, position( '.add' IN db )-6, 6);	
    tbl    = insert( tblName,LENGTH(Ltrim(tblName)), 10-LENGTH(Ltrim(tblName)), ' ');	 
	iduniq = ltrim( CAST( ( select test from __new)  as SQL_CHAR)) ; 
	len    = 12-LENGTH(Ltrim(CAST( ( SELECT test FROM __new)  as SQL_CHAR))) ;	
	
	
    update tblName set cuniqidrec =  dbname + tbl +repeat('0', len ) + iduniq                                             
          where test = ( select test from __new) ;	
		  
  end; 
