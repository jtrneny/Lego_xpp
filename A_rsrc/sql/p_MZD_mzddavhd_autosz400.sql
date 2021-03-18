ALTER PROCEDURE p_MZD_mzddavhd_autosz400
   ( 
      par_rok Integer,
      par_obdobi Integer,
	  par_oscisPrac Integer,
	  par_porPraVzt Integer,
	  par_delzaklSoc Integer,
	  par_delzaklZdr Integer
   )
    
BEGIN   
  declare @stmt Memo;
  declare @stmt_mzddavhd Memo, @stmt_mzddavit memo, @stmt_ucetpol Memo;
  declare srok String, sobdobi String,  soscisPrac String, sporPraVzt String;
  declare ldel_zaklSoc Logical, ldel_zaklZdr Logical;
  declare @swhere_mzddav  String;
  declare @roobcppv       String;  
  declare @swhere_ucetpol String; 

//  srok       = '2012';
//  sobdobi    =    '6';
//  soscisPrac =  '306';
//  sporPraVzt =    '1';
 
  srok         = convert( (SELECT par_rok        FROM __input), SQL_CHAR);
  sobdobi      = convert( (SELECT par_obdobi     FROM __input), SQL_CHAR);
  soscisPrac   = convert( (SELECT par_oscisPrac  FROM __input), SQL_CHAR); 
  sporPraVzt   = convert( (SELECT par_porPraVzt  FROM __input), SQL_CHAR);
  ldel_zaklSoc = convert( (SELECT par_delzaklSoc FROM __input), SQL_BIT ); 
  ldel_zaklZdr = convert( (SELECT par_delzaklZdr FROM __input), SQL_BIT );
  
  @swhere_mzddav  = ' nrok       = %yyyy    and nobdobi    = %mm and ' + 
                    ' noscisPrac = %cprac   and nporPraVzt = %pravzt'    ; 
  @swhere_ucetpol = ' nrok       = %yyyy    and nobdobi    = %mm and ' +
                    ' catr1      = ''%roobcppv'''                        ;

  @swhere_mzddav  = replace( @swhere_mzddav , '%yyyy'    , srok       );
  @swhere_mzddav  = replace( @swhere_mzddav , '%mm'      , sobdobi    );
  @swhere_mzddav  = replace( @swhere_mzddav , '%cprac'   , soscisPrac );
  @swhere_mzddav  = replace( @swhere_mzddav , '%pravzt'  , sporPraVzt );					
					
  @roobcppv       = srok                                            +
                    repeat( '0', 2 -length(sobdobi))    +sobdobi    +
					repeat( '0', 5 -length(soscisPrac)) +soscisPrac +
					repeat( '0', 3 -length(sporPraVzt)) +sporPraVzt ;			
					
  @swhere_ucetpol = replace( @swhere_ucetpol, '%yyyy'    , srok       );
  @swhere_ucetpol = replace( @swhere_ucetpol, '%mm'      , sobdobi    );					
  @swhere_ucetpol = replace( @swhere_ucetpol, '%roobcppv', @roobcppv  );								
					
  if     ldel_zaklSoc and ldel_zaklZdr then
    @stmt_mzddavhd  = 'update mzddavhd set nzaklSocPo = 0, nzaklZdrPo = 0 ';
	@stmt_mzddavit  = 'update mzddavit set nzaklSocPo = 0, nzaklZdrPo = 0 ';
    @stmt_ucetpol   = 'delete from ucetpol ';
	@swhere_ucetpol = @swhere_ucetpol +' and ( left(ctypUct,7) = ''MZ_SOPO'' or left(ctypUct,7) = ''MZ_ZDPO'' )' ;
	
  elseif ldel_zaklSoc                  then
    @stmt_mzddavhd  = 'update mzddavhd set nzaklSocPo = 0 ';
	@stmt_mzddavit  = 'update mzddavit set nzaklSocPo = 0 ';
    @stmt_ucetpol   = 'delete from ucetpol ';	
	@swhere_ucetpol = @swhere_ucetpol +' and ( left(ctypUct,7) = ''MZ_SOPO'' )' ;
  
  else 
    @stmt_mzddavhd  = 'update mzddavhd set nzaklZdrPo = 0 ';
	@stmt_mzddavit  = 'update mzddavit set nzaklZdrPo = 0 ';
    @stmt_ucetpol   = 'delete from ucetpol ';	
	@swhere_ucetpol = @swhere_ucetpol +' and ( left(ctypUct,7) = ''MZ_ZDPO'' )' ;   
  endif;  
  
  @stmt = @stmt_mzddavhd +' where ' +@swhere_mzddav;
  EXECUTE IMMEDIATE @stmt;
  
  @stmt = @stmt_mzddavit +' where ' +@swhere_mzddav;
  EXECUTE IMMEDIATE @stmt;
  
  @stmt = @stmt_ucetpol  +' where ' +@swhere_ucetpol;
  EXECUTE IMMEDIATE @stmt;

END;  
	 