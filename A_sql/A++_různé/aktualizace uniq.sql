
   update c_dokume SET cuniqidrec =  repeat('0', 12-LENGTH(Ltrim(CAST( ( SELECT test FROM __new)  as SQL_CHAR))))+        
                                      ltrim( CAST( ( SELECT test FROM __new)  as SQL_CHAR)),
                       mpoznamka = database() + ' ____ ' + APPLICATIONID()    
          WHERE test = ( SELECT test FROM __new) ;   
