  declare sid String;
  declare @mdefNap String, @stmt String;
  declare curs_mzdyit cursor as select mzdyit.nrok       as nrok      , 
                                       mzdyit.nobdobi    as nobdobi   , 
                            	       mzdyit.noscisPrac as noscisPrac,
									   mzdyit.nporPraVzt as nporPraVzt,
									   mzdyit.ndoklad    as ndoklad   , 
									   mzdyit.sid        as sid       
	                            from mzdyit; 

    
  open curs_mzdyit;
   
   
  while fetch curs_mzdyit do
    sid      = convert(curs_mzdyit.sid    , SQL_CHAR);	
  
    @stmt = 'update mzdyit set nstavNapHM = 1 where mzdyit.sid  = ' +sid;
	EXECUTE IMMEDIATE @stmt;
	
	EXECUTE PROCEDURE Update_Mzdyhd_from_Mzdyit();
  end while;