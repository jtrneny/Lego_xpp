// CREATE PROCEDURE UpdateItems_tst() 
// BEGIN
  declare @stmt Memo;
  declare srok String, sobdobi String,  soscisPrac String;
  declare @swhere_mzdyhd   String;
  declare @swhere_mzdyit   String;
  declare @swhere_mzddavit String; 

  declare i Integer;
//  declare curs_mzdyit cursor as select mzdyit.nrok       as nrok      , 
//                                       mzdyit.nobdobi    as nobdobi   , 
//                                   	   mzdyit.noscisPrac as noscisPrac
//   	                                   from mzdyit; 

  srok       = '2012';
  sobdobi    =    '4';
  soscisPrac =    '' ;  // '717,722,725';
  
  @swhere_mzdyhd   = ' mzdyhd.nrok   = %yyyy and mzdyhd.nobdobi   = %mm '; 
  @swhere_mzdyit   = ' mzdyit.nrok   = %yyyy and mzdyit.nobdobi   = %mm ';
  @swhere_mzddavit = ' mzddavit.nrok = %yyyy and mzddavit.nobdobi = %mm ';
  
  if ( soscisPrac = '' ) then
    @swhere_mzdyhd   = @swhere_mzdyhd   +''; 
    @swhere_mzdyit   = @swhere_mzdyit   +'';
    @swhere_mzddavit = @swhere_mzddavit +'';
  else
    @swhere_mzdyhd   = @swhere_mzdyhd   +' and mzdyhd.noscisPrac    IN (%soscisPrac)'; 
    @swhere_mzdyit   = @swhere_mzdyit   +' and mzdyit.noscisPrac    IN (%soscisPrac)';
    @swhere_mzddavit = @swhere_mzddavit +' and mzdddavit.noscisPrac IN (%soscisPrac)';  
  endif;

  @swhere_mzdyhd   = replace( @swhere_mzdyhd,   '%yyyy', srok       );
  @swhere_mzdyhd   = replace( @swhere_mzdyhd,   '%mm'  , sobdobi    );
  
  @swhere_mzdyit   = replace( @swhere_mzdyit,   '%yyyy', srok       );
  @swhere_mzdyit   = replace( @swhere_mzdyit,   '%mm'  , sobdobi    );  
  
  @swhere_mzddavit = replace( @swhere_mzddavit, '%yyyy', srok       );
  @swhere_mzddavit = replace( @swhere_mzddavit, '%mm'  , sobdobi    );  
  
  if ( soscisPrac <> '' ) then
    @swhere_mzdyhd   = replace( @swhere_mzdyhd  , '%soscisPrac' , soscisPrac );
    @swhere_mzdyit   = replace( @swhere_mzdyit  , '%soscisPrac' , soscisPrac );
    @swhere_mzddavit = replace( @swhere_mzddavit, '%soscisPrac' , soscisPrac );
  end;		


// zrušíme záznamy v mzdyhd a mzdyit
  @stmt = 'delete from mzdyhd where (' +@swhere_mzdyhd +')';                        				   
  EXECUTE IMMEDIATE @stmt;	
  
  @stmt = 'delete from mzdyit where (' +@swhere_mzdyit +')';
  EXECUTE IMMEDIATE @stmt;
    
// překopíruje do mzdyit záznamy nemocenek a srážek z mzddavit pro cdenik <> 'MH' bez sumace
  @stmt = 'insert into mzdyit (  ctask              , cUloha             , cDenik             , cObdobi            ,' +
                                'nRok               , nObdobi            , nRokObd            , CTYPDOKLAD         ,' +
                                'CTYPPOHYBU         , nDoklad            , nOrdItem           , cKmenStrPr         ,' +
                                'nOsCisPrac         , cPracovnik         , nPorPraVzt         , nTypPraVzt         ,' +
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
                                'nTMPnum1           , nTMPnum2 ) '                                                    +
                  'select        mzddavit.ctask     , mzddavit.cUloha    , mzddavit.cDenik    , mzddavit.cobdobi   ,' +
                                'mzddavit.nRok      , mzddavit.nObdobi   , mzddavit.nRokObd   , mzddavit.CTYPDOKLAD,' +
                                'mzddavit.CTYPPOHYBU,'                                                                + 
                                '((mzddavit.noscisPrac   *    100000) +'                                              +  
                                ' (mzddavit.nporPraVzt   *       100) +'                                              +
                                ' (mzddavit.nobdobi                  ))  , mzddavit.nOrdItem  , mzddavit.cKmenStrPr,' +
                                'mzddavit.nOsCisPrac, mzddavit.cPracovnik, mzddavit.nPorPraVzt, mzddavit.nTypPraVzt,' +
                                'mzddavit.nTypZamVzt, mzddavit.nClenSpol , mzddavit.cMzdKatPra, mzddavit.cPracZar  ,' +
                                'mzddavit.cPracZarDo, mzddavit.dDatPoriz , mzddavit.CUCETSKUP , mzddavit.nDruhMzdy ,' +
                                'mzddavit.nDnyDoklad, mzddavit.nHodDoklad, mzddavit.nMnPDoklad, mzddavit.nSazbaDokl,' +
                                'mzddavit.nMzda     , mzddavit.nZaklSocPo, mzddavit.nZaklZdrPo, mzddavit.nDnyFondKD,' +
                                'mzddavit.nDnyFondPD, mzddavit.nHodFondKD, mzddavit.nHodFondPD, mzddavit.nHodPresc ,' +
                                'mzddavit.nHodPrescS, mzddavit.nHodPripl , mzddavit.cZkratJEDN,                   0,' +
                                'mzddavit.nZdrPojis ,                   0,                   0, mzddavit.cVarSym   ,' +
                                'mzddavit.nPoradi   , mzddavit.dDatumOD  , mzddavit.dDatumDO  , mzddavit.nDnyVylocD,' +
                                'mzddavit.nDnyVylDOD, mzddavit.nDnyDovol , mzddavit.cZkrTypZAV,            char(32),' +
                                '           char(32), mzddavit.nKLikvid  , mzddavit.nZLikvid  , mzddavit.cTmKmStrPr,' +
                                'mzddavit.nTMPnum1  , mzddavit.nTMPnum2 '                                             +
                  'from mzddavit '                                                                                    +
                  'left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok        and '                           +                          
                                          'mzddavit.nobdobi    = msprc_mo.nobdobi     and '                           +
                                          'mzddavit.noscisPrac = msprc_mo.noscisPrac  and '                           +
                                          'mzddavit.nporpraVzt = msprc_mo.nporpraVzt     ) '                          +
                  'where (' +@swhere_mzddavit +' and '                                                                +
				                              'mzddavit.cdenik     <> ''MH'' and '                                    +
                                              'msprc_mo.lautoVypCm           and '                                    +
                                              'msprc_mo.lstavem                 )';
  EXECUTE IMMEDIATE @stmt;					  					  
	
	
// sumace za klíč mzddavit -> mzdyit
  @stmt = 'insert into mzdyit ( nrok      , nobdobi   , noscisPrac, nporPraVzt, cdenik   ,'                           +
                               'ndruhMzdy , ndnyDoklad, nhodDoklad, nmnPDoklad, nMzda    ,'                           +
                               'nhodPresc ,nhodPrescS, nhodPripl , ndnyVylocD, ndnyVylDOD, ndnyDovol)'                +
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
                               'sum(nhodPresc)  as nhodPresc ,'                                                       +
                               'sum(nhodPrescS) as nhodPrescS,'                                                       +
                               'sum(nhodPripl)  as nhodPripl ,'                                                       +
                               'sum(ndnyVylocD) as ndnyVylocD,'                                                       +
                               'sum(ndnyVylDOD) as ndnyVylDOD,'                                                       +
                               'sum(ndnyDovol)  as ndnyDovol  '                                                       +
                  'from mzddavit '                                                                                    + 
                  'left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok         and '                          +
                                          'mzddavit.nobdobi    = msprc_mo.nobdobi      and '                          +
                                          'mzddavit.noscisPrac = msprc_mo.noscisPrac   and '                          +
                                          'mzddavit.nporpraVzt = msprc_mo.nporpraVzt      ) '                         +
                  'where (' +@swhere_mzddavit +' and '                                                                +
                                              'mzddavit.cdenik     = ''MH'' and '                                     +
                                              'msprc_mo.lautoVypCm          and '                                     +
                                              'msprc_mo.lstavem               ) '                                     +			  				   										  							   							   
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
                            'ctypDoklad = mzddavit.ctypDoklad ,'                                                      +
                            'ctypPohybu = mzddavit.ctypPohybu ,'                                                      +
                            'nordItem   = mzddavit.nordItem   ,'                                                      +
                            'ckmenStrPr = mzddavit.ckmenStrPr ,'                                                      +
                            'cpracovnik = mzddavit.cpracovnik ,'                                                      +
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
                            'ndnyFondKd = mzddavit.ndnyFondKd ,'                                                      +
                            'ndnyFondPd = mzddavit.ndnyFondPd ,'                                                      +
                            'nhodFondKd = mzddavit.nhodFondKd ,'                                                      +
                            'nhodFondPd = mzddavit.nhodFondPd ,'                                                      +
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
                            'ndoklad    =  (( mzddavit.noscisPrac    *    100000) +'                                  +
                                            '(mzddavit.nporPraVzt    *       100) +'                                  +
                                            '(mzddavit.nobdobi                  )) '                                  +		
                  'from mzddavit '                                                                                    +
                  'left join mzdyit on ( mzdyit.nrok       = mzddavit.nrok           and '                            +
                                        'mzdyit.nobdobi    = mzddavit.nobdobi        and '                            +
                                        'mzdyit.nosCisPrac = mzddavit.nosCisPrac     and '                            +
                                        'mzdyit.nporPraVzt = mzddavit.nporPraVzt     and '                            +
                                        'mzdyit.ndruhMzdy  = mzddavit.ndruhMzdy         ) '                           +
                  'where (' +@swhere_mzdyit + ' and '                                                                 +
                                              'mzdyit.cdenik     = ''MH''   )';		
  EXECUTE IMMEDIATE @stmt;												  					 
	
// sumace za klíč mzdyit -> mzdyhd
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
//                ctypDoklad    = mzdyit.ctypDoklad        ?   
//                ctypPohybu    = mzdyit.ctypPohybu        ?
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
                            'cdelkPrDob    = msprc_mo.cdelkPrDob ,'                                                   +
                            'cprukazZPS    = msprc_mo.cprukazZPS ,'                                                   +
                            'nfyzStaSoc    = msprc_mo.nfyzStaSoc ,'                                                   +
                            'nfyzStaZdr    = msprc_mo.nfyzStaZdr ,'                                                   +
                            'nfyzStavOb    = msprc_mo.nfyzStavOb ,'                                                   + 
                            'nfyzStavKo    = msprc_mo.nfyzStavKo ,'                                                   +
                            'nfyzStavPr    = msprc_mo.nfyzStavPr ,'                                                   +
                            'npreStavPr    = msprc_mo.npreStavPr ,'                                                   +
                            'ctmKmStrPr    = msprc_mo.ctmKmStrPr  '                                                   + 	   
                  'from msprc_mo '                                                                                    +
	              'left join mzdyhd on ( mzdyhd.nrok       = msprc_mo.nrok        and '                               + 
                                        'mzdyhd.nobdobi    = msprc_mo.nobdobi     and '                               +
                                        'mzdyhd.noscisPrac = msprc_mo.noscisPrac  and '                               +
                                        'mzdyhd.nporpraVzt = msprc_mo.nporpraVzt     ) '                              + 
                  'where (' +@swhere_mzdyhd +')';
  EXECUTE IMMEDIATE @stmt;		
	
  i = 1;
//END;


		  