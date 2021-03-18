update spojeni set ncisSpoj = convert( right(cuniqidrec,10), SQL_NUMERIC)   ;

update dokument set nid = nCisDokum   ;

update dokument set cIDdokum = 'USER' + REPEAT( '0', 10-LENGTH(Ltrim(CAST(nid as SQL_CHAR))))  ;
