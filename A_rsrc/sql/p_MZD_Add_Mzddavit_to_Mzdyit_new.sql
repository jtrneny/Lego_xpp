ALTER PROCEDURE p_MZD_Add_Mzddavit_to_Mzdyit
   ( 
      par_rok Integer,
      par_obdobi Integer,
      par_oscisPrac Memo
   ) 
BEGIN 
  declare @stmt Memo;
  declare srok String, sobdobi String,  soscisPrac String;
  declare @swhere_mzdyhd   String;
  declare @swhere_mzdyit   String;
  declare @swhere_mzddavit String;
  declare @swhere_msprc_mo String; 
  declare @swhere_msprc    String;
  declare @swhere_mzdZavhd String;
  declare @swhere_mzdZavit String;  

//  srok       = '2012';
//  sobdobi    =    '4';
//  soscisPrac =    '' ;  // '717,722,725';
  
  srok       = convert( (SELECT par_rok       FROM __input), SQL_CHAR);
  sobdobi    = convert( (SELECT par_obdobi    FROM __input), SQL_CHAR);
  soscisPrac = ISNULL( ( SELECT par_oscisPrac FROM __input), ''      );    
  
  @swhere_mzdyhd   = ' mzdyhd.nrok   = %yyyy and mzdyhd.nobdobi   = %mm '; 
  @swhere_mzdyit   = ' mzdyit.nrok   = %yyyy and mzdyit.nobdobi   = %mm ';
  @swhere_mzddavit = ' mzddavit.nrok = %yyyy and mzddavit.nobdobi = %mm ';
  @swhere_msprc_mo = ' msprc_mo.nrok = %yyyy and msprc_mo.nobdobi = %mm ';
  @swhere_msprc    = ' msprc_mo.nrok = %yyyy and msprc_mo.nobdobi = %mm and msprc_mo.nstaVypoCM = 9';  
  @swhere_mzdZavhd = ' mzdZavhd.nrok = %yyyy and mzdZavhd.nobdobi = %mm ';  
  @swhere_mzdZavit = ' mzdZavit.nrok = %yyyy and mzdZavit.nobdobi = %mm ';  
  
  if ( soscisPrac = '' ) then
    @swhere_mzdyhd   = @swhere_mzdyhd   +''; 
    @swhere_mzdyit   = @swhere_mzdyit   +'';
    @swhere_mzddavit = @swhere_mzddavit +'';
	@swhere_msprc_mo = @swhere_msprc_mo +'';
  else
    @swhere_mzdyhd   = @swhere_mzdyhd   +' and mzdyhd.noscisPrac   IN (%soscisPrac)'; 
    @swhere_mzdyit   = @swhere_mzdyit   +' and mzdyit.noscisPrac   IN (%soscisPrac)';
    @swhere_mzddavit = @swhere_mzddavit +' and mzddavit.noscisPrac IN (%soscisPrac)';
	@swhere_msprc_mo = @swhere_msprc_mo +' and msprc_mo.noscisPrac IN (%soscisPrac)';  
  endif;

  @swhere_mzdyhd   = replace( @swhere_mzdyhd,   '%yyyy', srok       );
  @swhere_mzdyhd   = replace( @swhere_mzdyhd,   '%mm'  , sobdobi    );
  
  @swhere_mzdyit   = replace( @swhere_mzdyit,   '%yyyy', srok       );
  @swhere_mzdyit   = replace( @swhere_mzdyit,   '%mm'  , sobdobi    );  
  
  @swhere_mzddavit = replace( @swhere_mzddavit, '%yyyy', srok       );
  @swhere_mzddavit = replace( @swhere_mzddavit, '%mm'  , sobdobi    );  
  
  @swhere_msprc_mo = replace( @swhere_msprc_mo, '%yyyy', srok       );
  @swhere_msprc_mo = replace( @swhere_msprc_mo, '%mm'  , sobdobi    );    
  
  @swhere_msprc    = replace( @swhere_msprc,    '%yyyy', srok       );
  @swhere_msprc    = replace( @swhere_msprc,    '%mm'  , sobdobi    );  
  
  @swhere_mzdZavhd = replace( @swhere_mzdZavhd, '%yyyy', srok       );
  @swhere_mzdZavhd = replace( @swhere_mzdZavhd, '%mm'  , sobdobi    );
  
  @swhere_mzdZavit = replace( @swhere_mzdZavit, '%yyyy', srok       );
  @swhere_mzdZavit = replace( @swhere_mzdZavit, '%mm'  , sobdobi    );  
  
  
  if ( soscisPrac <> '' ) then
    @swhere_mzdyhd   = replace( @swhere_mzdyhd  , '%soscisPrac' , soscisPrac );
    @swhere_mzdyit   = replace( @swhere_mzdyit  , '%soscisPrac' , soscisPrac );
    @swhere_mzddavit = replace( @swhere_mzddavit, '%soscisPrac' , soscisPrac );
	@swhere_msprc_mo = replace( @swhere_msprc_mo, '%soscisPrac' , soscisPrac );
  end;		

// zrušíme nulové doklady - asi po chybì zracování  
  delete from mzdyhd where ndoklad = 0;
  delete from mzdyit where ndoklad = 0;
  
// shodíme indikci nstaVypoCM pro 9 na 0 tj. nejel výpoèet èistých mezd
  @stmt = 'update msprc_mo set nstaVypoCM = 0 where (' +@swhere_msprc +')';
  EXECUTE IMMEDIATE @stmt;   
  
// zrušíme záznamy v mzdyhd a mzdyit
  @stmt = 'delete from mzdyhd where (' +@swhere_mzdyhd +')';                        				   
  EXECUTE IMMEDIATE @stmt;	 
 
  @stmt = 'delete from mzdyit where (' +@swhere_mzdyit +')';
  EXECUTE IMMEDIATE @stmt;
    
// zrušíme záznamy v mzdZavhd a mzdZavit
  @stmt = 'delete from mzdZavhd where (' +@swhere_mzdZavhd +')';                        				   
  EXECUTE IMMEDIATE @stmt;	
  
  @stmt = 'delete from mzdZavit where (' +@swhere_mzdZavit +')';
  EXECUTE IMMEDIATE @stmt;	
  
	
// pøekopíruje do mzdyit záznamy nemocenek a srážek z mzddavit pro cdenik <> 'MH' bez sumace
  @stmt = 'insert into mzdyit (  ctask              , cUloha             , cDenik             , cObdobi            ,' +
                                'nRok               , nObdobi            , nRokObd            , CTYPDOKLAD         ,' +
                                'CTYPPOHYBU         , nDoklad            , nOrdItem           , cKmenStrPr         ,' +
                                'nOsCisPrac         , cPracovnik         , nPorPraVzt         , nTypPraVzt         ,' +
                                'cjmenoRozl         ,                                                               ' +              
                                'nTypZamVzt         , nClenSpol          , cMzdKatPra         , cPracZar           ,' +
                                'cPracZarDo         , dDatPoriz          , CUCETSKUP          , nDruhMzdy          ,' +
                                'nDnyDoklad         , nHodDoklad         , nMnPDoklad         , nSazbaDokl         ,' +
                                'nMzda              , nZaklSocPo         , nZaklZdrPo         , nDnyFondKD         ,' +
                                'nDnyFondPD         , nHodFondKD         , nHodFondPD         , nHodPresc          ,' +
                                'nHodPrescS         , nHodPripl          , cZkratJEDN         , nLikCelDOK         ,' +
                                'nZdrPojis          , nMimoPrVzt         , nTypDuchod         , cVarSym            ,' +
                                'nPoradi            , dDatumOD           , dDatumDO           , nDnyVylocD         ,' +
                                'nDnyVylDOD         , nDnyDovol          , cZkrTypZAV         , cPolVyplPa         ,' +
                                'cVyplMist          , nKLikvid           , nZLikvid           , cTmKmStrPr         ,' +
                                'nTMPnum1           , nTMPnum2           , nstavNapHM         , ndokladorg         ,' +
                                'cCpPPv             ,                                                               ' + 
                                'nMZDDAVIT          , cRoObCpPPv         , cRoCpPPv           , cpohZavFir         ,' +
                                'czkratMeny         , czkratMenz         , nkurZahMen         , nmnozPrep          ,' +
                                'ctypPohZav         , nMsPrc_Mo        ) '                                            +
                  'select        mzddavit.ctask     , mzddavit.cUloha    , mzddavit.cDenik    , mzddavit.cobdobi   ,' +
                                'mzddavit.nRok      , mzddavit.nObdobi   , mzddavit.nRokObd   , mzddavit.CTYPDOKLAD,' +
                                'mzddavit.CTYPPOHYBU, msprc_mo.ndokladcm , mzddavit.nOrdItem  , mzddavit.cKmenStrPr,' +
                                'mzddavit.nOsCisPrac, mzddavit.cPracovnik, mzddavit.nPorPraVzt, mzddavit.nTypPraVzt,' +
                                'mzddavit.cjmenoRozl,                                                               ' +
                                'mzddavit.nTypZamVzt, mzddavit.nClenSpol , mzddavit.cMzdKatPra, mzddavit.cPracZar  ,' +
                                'mzddavit.cPracZarDo, mzddavit.dDatPoriz , mzddavit.CUCETSKUP , mzddavit.nDruhMzdy ,' +
                                'mzddavit.nDnyDoklad, mzddavit.nHodDoklad, mzddavit.nMnPDoklad, mzddavit.nSazbaDokl,' +
                                'mzddavit.nMzda     , mzddavit.nZaklSocPo, mzddavit.nZaklZdrPo, mzddavit.nDnyFondKD,' +
                                'mzddavit.nDnyFondPD, mzddavit.nHodFondKD, mzddavit.nHodFondPD, mzddavit.nHodPresc ,' +
                                'mzddavit.nHodPrescS, mzddavit.nHodPripl , mzddavit.cZkratJEDN,                   0,' +
                                'mzddavit.nZdrPojis ,                   0,                   0, mzddavit.cVarSym   ,' +
                                'mzddavit.nPoradi   , mzddavit.dDatumOD  , mzddavit.dDatumDO  , mzddavit.nDnyVylocD,' +
                                'mzddavit.nDnyVylDOD, mzddavit.nDnyDovol , mzddavit.cZkrTypZAV, druhyMzd.cpolVyplPa,' +
                                'msprc_mo.cVyplMist , mzddavit.nKLikvid  , mzddavit.nZLikvid  , mzddavit.cTmKmStrPr,' +
                                'mzddavit.nTMPnum1  , mzddavit.nTMPnum2  ,                   1, mzddavit.ndoklad   ,' +
                                'SubString(mzddavit.cRoCpPPv,5,8)        ,                                          ' + 
                                'mzddavit.sID       , mzddavit.cRoObCpPPv, mzddavit.cRoCpPPv  , mzddavit.cpohZavFir,' +
                                'mzddavit.czkratMeny, mzddavit.czkratMenz, mzddavit.nkurZahMen, mzddavit.nmnozPrep ,' +
                                'mzddavit.ctypPohZav, mzddavit.nMsPrc_Mo '                                            +
                  'from mzddavit '                                                                                    +
                  'left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok        and '                           +                          
                                          'mzddavit.nobdobi    = msprc_mo.nobdobi     and '                           +
                                          'mzddavit.noscisPrac = msprc_mo.noscisPrac  and '                           +
                                          'mzddavit.nporpraVzt = msprc_mo.nporpraVzt     ) '                          +
                  'left join druhyMzd on ( mzddavit.nrok       = druhyMzd.nrok        and '                           +
                                          'mzddavit.nobdobi    = druhyMzd.nobdobi     and '                           +
                                          'mzddavit.ndruhMzdy  = druhyMzd.ndruhMzdy      ) '                          +                  
                  'where (' +@swhere_mzddavit +' and '                                                                +
	                                      'mzddavit.cdenik     <> ''MH'' and '                                    +
                                              'msprc_mo.lVypCisMzd              )';
  EXECUTE IMMEDIATE @stmt;					  					  
	
	
// sumace za klíè mzddavit -> mzdyit
  @stmt = 'insert into mzdyit ( nrok      , nobdobi   , noscisPrac, nporPraVzt, cdenik   ,'                           +
                               'ndruhMzdy , ndnyDoklad, nhodDoklad, nmnPDoklad, nMzda    ,'                           +
                               'nZaklSocPo, nZaklZdrPo,'                                                              +   
                               'nhodPresc , nhodPrescS, nhodPripl , ndnyVylocD, ndnyVylDOD, ndnyDovol,'               +    
                               'ndnyFondKD, ndnyFondPD, nhodFondKD, nhodFondPD) '                                     +
                  'select       mzddavit.nrok                ,'                                                       +
                               'mzddavit.nobdobi             ,'                                                       +
                               'mzddavit.noscisPrac          ,'                                                       +
                               'mzddavit.nporPraVzt          ,'                                                       +
                               'mzddavit.cdenik              ,'                                                       +
                               'mzddavit.ndruhMzdy           ,'                                                       +
                               'sum(ndnyDoklad) as ndnyDoklad,'                                                       +
                               'sum(nhodDoklad) as nhodDoklad,'                                                       +
                               'sum(nmnPDoklad) as nmnPDoklad,'                                                       +    
                               'sum(nMzda)      as nmzda     ,'                                                       +
                               'sum(nZaklSocPo) as nZaklSocPo,'                                                       +
                               'sum(nZaklZdrPo) as nZaklZdrPo,'                                                       +
                               'sum(nhodPresc)  as nhodPresc ,'                                                       +
                               'sum(nhodPrescS) as nhodPrescS,'                                                       +
                               'sum(nhodPripl)  as nhodPripl ,'                                                       +
                               'sum(ndnyVylocD) as ndnyVylocD,'                                                       +
                               'sum(ndnyVylDOD) as ndnyVylDOD,'                                                       +
                               'sum(ndnyDovol)  as ndnyDovol ,'                                                       +
                               'sum(ndnyFondKD) as ndnyFondKD,'                                                       +
                               'sum(ndnyFondPD) as ndnyFondPD,'                                                       +
                               'sum(nhodFondKD) as nhodFondKD,'                                                       +
                               'sum(nhodFondPD) as nhodFondPD '                                                       +
                  'from mzddavit '                                                                                    + 
                  'left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok         and '                          +
                                          'mzddavit.nobdobi    = msprc_mo.nobdobi      and '                          +
                                          'mzddavit.noscisPrac = msprc_mo.noscisPrac   and '                          +
                                          'mzddavit.nporpraVzt = msprc_mo.nporpraVzt      ) '                         +
                  'where (' +@swhere_mzddavit +' and '                                                                +
                                              'mzddavit.cdenik     = ''MH'' and '                                     +
                                              'msprc_mo.lVypCisMzd             ) '                                    +		  				   										  							   							   
                  'group by mzddavit.nrok      ,'                                                                     +
                           'mzddavit.nobdobi   ,'                                                                     +
                           'mzddavit.nosCisPrac,'                                                                     +
                           'mzddavit.nporPraVzt,'                                                                     +
                           'mzddavit.cdenik    ,'                                                                     +
                           'mzddavit.ndruhMzdy  '; 
  EXECUTE IMMEDIATE @stmt;							   
	
// doplní se položky ve mzdyit, které nelze sumovat
  @stmt = 'update mzdyit set ctask      = mzddavit.ctask      ,'                                                      +
                            'culoha     = mzddavit.culoha     ,'                                                      +
                            'cdenik     = mzddavit.cdenik     ,'                                                      +
                            'cobdobi    = mzddavit.cobdobi    ,'                                                      +
                            'nrokObd    = mzddavit.nrokObd    ,'                                                      +
                            'cdenik     = mzddavit.cdenik     ,'                                                      +
   	                        'ctypDoklad = ''MZD_GENCM''       ,'                                                      +
                            'ctypPohybu = ''GENMZDA''         ,'                                                      +
                            'nordItem   = mzddavit.nordItem   ,'                                                      +
                            'ckmenStrPr = mzddavit.ckmenStrPr ,'                                                      +
                            'croobcpppv = mzddavit.croobcpppv ,'                                                      +
                            'crocpppv   = mzddavit.crocpppv ,'                                                        +
                            'cpracovnik = mzddavit.cpracovnik ,'                                                      +
                            'cjmenorozl = mzddavit.cjmenorozl ,'                                                      +
                            'ntypPraVzt = mzddavit.ntypPraVzt ,'                                                      +
                            'ntypZamVzt = mzddavit.ntypZamVzt ,'                                                      +
                            'nclenSpol  = mzddavit.nclenSpol  ,'                                                      +
                            'cmzdKatPra = mzddavit.cmzdKatPra ,'                                                      +
                            'cpracZar   = mzddavit.cpracZar   ,'                                                      +
                            'cpracZarDo = mzddavit.cpracZarDo ,'                                                      +
                            'ddatPoriz  = mzddavit.ddatPoriz  ,'                                                      +
                            'cucetSkup  = mzddavit.cucetSkup  ,'                                                      +
                            'nsazbaDokl = mzddavit.nsazbaDokl ,'                                                      +
                            'nzaklSocPo = mzddavit.nzaklSocPo ,'                                                      +
                            'nzaklZdrPo = mzddavit.nzaklZdrPo ,'                                                      +
                            'czkratJedn = mzddavit.czkratJedn ,'                                                      +
                            'nzdrPojis  = mzddavit.nzdrPojis  ,'                                                      +
                            'cvarSym    = mzddavit.cvarSym    ,'                                                      +
                            'nporadi    = mzddavit.nporadi    ,'                                                      +
                            'ddatumOd   = mzddavit.ddatumOd   ,'                                                      +
                            'ddatumDo   = mzddavit.ddatumDo   ,'                                                      +
                            'czkrTypZav = mzddavit.czkrTypZav ,'                                                      +
                            'ctmKmStrPr = mzddavit.ctmKmStrPr ,'                                                      +
                            'nTMPnum1   = mzddavit.nTMPnum1   ,'                                                      +
                            'nTMPnum2   = mzddavit.nTMPnum2   ,'                                                      +
	  	                    'nstavNapHM = 1                   ,'                                                      +
                            'ndoklad    = msprc_mo.ndokladcm  ,'                                                      +
                            'cpolVyplPa = druhyMzd.cpolVyplPa ,'                                                      +
                            'cVyplMist  = msprc_mo.cvyplmist  ,'                                                      +
			                'cCpPPv     = msprc_mo.cCpPPv     ,'                                                      +
		            	    'cRoObCpPPv = mzddavit.cRoObCpPPv ,'                                                      +
		                    'cRoCpPPv   = mzddavit.cRoCpPPv   ,'				                      +
		                    'nMsPrc_Mo  = mzddavit.nMsPrc_Mo   '				                      +
                  'from mzddavit '                                                                                    +
                  'left join mzdyit on ( mzdyit.nrok       = mzddavit.nrok           and '                            +
                                        'mzdyit.nobdobi    = mzddavit.nobdobi        and '                            +
                                        'mzdyit.nosCisPrac = mzddavit.nosCisPrac     and '                            +
                                        'mzdyit.nporPraVzt = mzddavit.nporPraVzt     and '                            +
                                        'mzdyit.ndruhMzdy  = mzddavit.ndruhMzdy         ) '                           +
                  'left join msprc_mo on ( mzdyit.nrok       = msprc_mo.nrok         and '                            +
                                          'mzdyit.nobdobi    = msprc_mo.nobdobi      and '                            +
                                          'mzdyit.noscisPrac = msprc_mo.noscisPrac   and '                            +
                                          'mzdyit.nporpraVzt = msprc_mo.nporpraVzt      ) '                           +  
                  'left join druhyMzd on ( mzdyit.nrok       = druhyMzd.nrok        and '                             +
                                          'mzdyit.nobdobi    = druhyMzd.nobdobi     and '                             +
                                          'mzdyit.ndruhMzdy  = druhyMzd.ndruhMzdy      ) '                            + 
                  'where (' +@swhere_mzdyit + ' and '                                                                 +
                                              'mzdyit.cdenik     = ''MH''   )';		
  EXECUTE IMMEDIATE @stmt;												  					 
	
// sumace za klíè mzdyit -> mzdyhd
  @stmt = 'insert into mzdyhd ( nrok, nobdobi, noscisPrac, nporPraVzt, ndoklad) '                                     + 
                 'select        mzdyit.nrok      ,'                                                                   +
	                           'mzdyit.nobdobi   ,'                                                                   +
                               'mzdyit.noscisPrac,'                                                                   +
                               'mzdyit.nporPraVzt,'                                                                   +
                               'mzdyit.ndoklad    '                                                                   +   
                 'from mzdyit '                                                                                       +	
                 'where (' +@swhere_mzdyit +')'                                                                       +
                 'group by mzdyit.nrok      ,'                                                                        +
                          'mzdyit.nobdobi   ,'                                                                        +
                          'mzdyit.nosCisPrac,'                                                                        +
                          'mzdyit.nporPraVzt,'                                                                        +
                          'mzdyit.ndoklad    '; 
  EXECUTE IMMEDIATE @stmt;		
		
// doplní se položky ve mzdyhd, které nelze sumovat
  @stmt = 'update mzdyhd set ctask         = msprc_mo.ctask      ,'                                                   +
                            'culoha        = msprc_mo.culoha     ,'                                                   +
//                cdenik        = mzdyit.cdenik            ?
                            'cobdobi       = msprc_mo.cobdobi    ,'                                                   +
//                nrok          = msprc_mo.nrok            SUM
//                nobdobi       = msprc_mo.nobdobi         SUM
                            'nrokObd       = msprc_mo.nrokObd    ,'                                                   +
                            'nctvrtleti    = msprc_mo.nctvrtleti ,'                                                   +
                            'croObCpPPv    = msprc_mo.croObCpPPv ,'                                                   +
                            'croCpPPv      = msprc_mo.croCpPPv ,'                                                     +
			    'ctypDoklad    = ''MZD_GENCM''       ,'                                                   +
			    'ctypPohybu    = ''GENMZDA''         ,'                                                   +
//                ndoklad       = mzdyit.ndoklad           SUM
                            'ckmenStrPr    = msprc_mo.ckmenStrPr ,'                                                   +
//                noscisPrac    = msprc_mo.noscisPrac      SUM
                            'cjmenoRozl    = msprc_mo.cjmenoRozl ,'                                                   +
                            'cdruPraVzt    = msprc_mo.cdruPraVzt ,'                                                   + 
//                nporPraVzt    = msprc_mo.nporPraVzt      SUM
                            'ntypPraVzt    = msprc_mo.ntypPraVzt ,'                                                   +
                            'cvznPraVzt    = msprc_mo.cvznPraVzt ,'                                                   +
                            'ntypZamVzt    = msprc_mo.ntypZamVzt ,'                                                   +
                            'nmimoPrVzt    = msprc_mo.nmimoPrVzt ,'                                                   +
                            'cPracovnik    = left(msprc_mo.cPracovnik,30) ,'                                          +
                            'cmzdKatPra    = msprc_mo.cmzdKatPra ,'                                                   +
                            'cpracZar      = msprc_mo.cpracZar   ,'                                                   +
                            'ntypDuchod    = msprc_mo.ntypDuchod ,'                                                   +
                            'nzdrPojis     = msprc_mo.nzdrPojis  ,'                                                   +
                            'lDanPrVzt     = msprc_mo.lDanPrVzt  ,'                                                   +
                            'cdelkPrDob    = msprc_mo.cdelkPrDob ,'                                                   +
                            'cprukazZPS    = msprc_mo.cprukazZPS ,'                                                   +
                            'nfyzStaSoc    = msprc_mo.nfyzStaSoc ,'                                                   +
                            'nfyzStaZdr    = msprc_mo.nfyzStaZdr ,'                                                   +
                            'nfyzStavOb    = msprc_mo.nfyzStavOb ,'                                                   + 
                            'nfyzStavKo    = msprc_mo.nfyzStavKo ,'                                                   +
                            'nfyzStavPr    = msprc_mo.nfyzStavPr ,'                                                   +
                            'npreStavPr    = msprc_mo.npreStavPr ,'                                                   +
                            'ctmKmStrPr    = msprc_mo.ctmKmStrPr ,'                                                   + 	   
                            'nMsPrc_Mo     = msprc_mo.sid         '                                                   + 	   
                  'from msprc_mo '                                                                                    +
	              'left join mzdyhd on ( mzdyhd.nrok       = msprc_mo.nrok        and '                               + 
                                        'mzdyhd.nobdobi    = msprc_mo.nobdobi     and '                               +
                                        'mzdyhd.noscisPrac = msprc_mo.noscisPrac  and '                               +
                                        'mzdyhd.nporpraVzt = msprc_mo.nporpraVzt     ) '                              + 
                  'where (' +@swhere_mzdyhd +')';
  EXECUTE IMMEDIATE @stmt;		
	
  EXECUTE PROCEDURE p_MZD_Update_Mzdyhd_from_Mzdyit();	
	
// nastavíme v msprc_mo nstaVypoCM
  @stmt = 'update msprc_mo set nstaVypoCM = 9 where (' +@swhere_msprc_mo +')';
  EXECUTE IMMEDIATE @stmt;  	
	








END;

EXECUTE PROCEDURE sp_ModifyProcedureProperty( 'p_MZD_Add_Mzddavit_to_Mzdyit', 
   'COMMENT', 
   '');

