ALTER PROCEDURE p_MZD_Update_Mzdyhd_from_Mzdyit()

BEGIN
 
  declare srok String, sdoklad String, sid String;
  declare @mdefNap String, @stmt String;  
  declare curs_mzdyit cursor as select mzdyit.nrok       as nrok      , 
                                       mzdyit.nobdobi    as nobdobi   , 
                            	       mzdyit.noscisPrac as noscisPrac,
									   mzdyit.nporPraVzt as nporPraVzt,
									   mzdyit.ndoklad    as ndoklad   , 
									   mzdyit.sid        as sid       ,
  	                                   druhyMzd.ndruhMzdy             ,
	                                   druhyMzd.mdefNap  as mdefNap   ,
									   druhyMzd.mBlock   as mBlock
	   from mzdyit 
	   left join druhyMzd on ( mzdyit.nrok      = druhyMzd.nrok         and 
                               mzdyit.nobdobi   = druhyMzd.nobdobi      and
							   mzdyit.ndruhMzdy = druhyMzd.ndruhMzdy       )
       where not druhyMzd.mdefNap IS NULL and mzdyit.nstavNapHM = 1        ;
    
  open curs_mzdyit;
   
   
  while fetch curs_mzdyit do
    srok     = convert(curs_mzdyit.nrok   , SQL_CHAR);  
    sdoklad  = convert(curs_mzdyit.ndoklad, SQL_CHAR);
    sid      = convert(curs_mzdyit.sid    , SQL_CHAR);	 
	 
    @mdefNap = replace( curs_mzdyit.mdefNap, '->', '.' ); 
	@mdefNap = replace( @mdefNap           , ':=', '=' );
	@mdefNap = replace( @mdefNap           , char(13) +char(10), ',' +char(13) +char(10) );                                              
	
	if right( @mdefNap, 3) = ',' +char(13) +char(10) then
      @mdefNap = subString( @mdefNap, 1, length(@mdefNap) -3);
    endif;  
	
	@stmt    = 'update mzdyhd set ' +@mdefNap +' from mzdyit ' +
	           'where mzdyhd.ndoklad = ' +sdoklad + 
			       ' and mzdyhd.nrok = ' +srok + 
				   ' and mzdyit.sid  = ' +sid;  
	             
    EXECUTE IMMEDIATE @stmt;			 		 
  end while;			 
			 
  close curs_mzdyit;
  
  // po zpracování nápočtu mddavit -> mzdyit je nahozen nstavNapHM = 1
  // po zpracování smyčky se                            nstavNapHM = 0
  update mzdyit set nstavNapHM = 0 where mzdyit.nstavNapHm = 1;
  
END;  			 
