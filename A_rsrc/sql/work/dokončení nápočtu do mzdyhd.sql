/*
CREATE PROCEDURE UpdateItems
  ( 
      par_rok Character,
      par_obdobi Character,
	  par_oscisPrac Memo
  )  

BEGIN
*/

  declare @par_rok String, @par_obdobi String, @par_oscisPrac Memo;
  declare p_nrok String;
  
  declare srok String, sobdobi String, soscisPrac String, sporPraVzt String;
  declare sdoklad String, sid String;
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
       where not druhyMzd.mdefNap IS NULL and mzdyit.nrok = 2012           ;
  
  p_nrok = '2012';
 
  
  open curs_mzdyit;
  
  
/*  
  while fetch curs_mzdyit do
//    if par_rok = curs_mzdyit.nrok and par_obdobi = curs_mzdyit.nobdobi and 
  
    sdoklad  = convert(curs_mzdyit.ndoklad, SQL_CHAR);
    sid      = convert(curs_mzdyit.sid    , SQL_CHAR);	 
	 
    @mdefNap = replace( curs_mzdyit.mdefNap, '->', '.' ); 
	@mdefNap = replace( @mdefNap           , ':=', '=' );
	@mdefNap = replace( @mdefNap           , char(13) +char(10), ',' );                                              
	
	@stmt    = 'update mzdyhd set ' +@mdefNap +' from mzdyit ' +
	           'where mzdyhd.ndoklad = ' +@sdoklad +' and mzdyit.sid = ' +@sid;  
	             
    EXECUTE IMMEDIATE @stmt;				 		 
  end while;			 
			 
  close curs_mzdyit;
*/  
// END;  			 
