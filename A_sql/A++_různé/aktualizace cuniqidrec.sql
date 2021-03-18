declare tbl char( 10)   ;
 declare vUniqIdRec char( 10)   ;
 declare db char( 250)   ;
 declare dbName char( 6) ;
 declare iduniq char(12) ; 
 declare len integer     ;
 
 db     = database()  ;
 dbName = substring( db, position( '.add' IN db )-6, 6); 
 tbl    = upper(tblName);  
 iduniq = ltrim( CAST( ( select nUniqIdRec from __new)  as SQL_CHAR)) ; 
 len    = 12-LENGTH(Ltrim(CAST( ( SELECT nUniqIdRec FROM __new)  as SQL_CHAR))) ;
 vUniqIdRec = substring(dbname+tbl+repeat('0', len ) + iduniq,1,28); 

 if     tbl = 'c_dokume' then update c_dokume set cUniqIdRec = vUniqIdRec WHERE nUniqIdRec = (SELECT nUniqIdRec FROM __new);
 elseif tbl = 'c_dokume' then update c_dokume set cUniqIdRec = vUniqIdRec WHERE nUniqIdRec = (SELECT nUniqIdRec FROM __new);  
 end   