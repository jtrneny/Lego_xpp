/*
CREATE PROCEDURE UpdateItems()
  ( 
      tblName CICHAR ( 20 ),
      colName CICHAR ( 20 )
  )  

BEGIN
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
       where not empty(druhyMzd.mdefNap)                                   ;
  
  open curs_mzdyit;
  
  while fetch curs_mzdyit do
    srok       = convert(curs_mzdyit.nrok      , SQL_CHAR); 
    sobdobi    = convert(curs_mzdyit.nobdobi   , SQL_CHAR); 
    soscisPrac = convert(curs_mzdyit.noscisPrac, SQL_CHAR); 
    sporPraVzt = convert(curs_mzdyit.nporPraVzt, SQL_CHAR); 
    sid        = convert(curs_mzdyit.sid       , SQL_CHAR);
  
    @stmt = curs_mzdyit.mBlock;
	
	@stmt  = replace( @stmt, '%srok'       , srok       );
    @stmt  = replace( @stmt, '%sobdobi'    , sobdobi    );
    @stmt  = replace( @stmt, '%soscisPrac' , sosCisPrac );
    @stmt  = replace( @stmt, '%sporPraVzt' , sporPraVzt );   							   
    @stmt  = replace( @stmt, '%sid'        , sid        );
  
    EXECUTE IMMEDIATE @stmt;
  end while;
			 
  while fetch curs_mzdyit do
    sdoklad  = convert(curs_mzdyit.ndoklad, SQL_CHAR);
    sid      = convert(curs_mzdyit.sid    , SQL_CHAR);	 
	 
    @mdefNap = replace( curs_mzdyit.mdefNap, '->', '.' ); 
	@mdefNap = replace( @mdefNap           , ':=', '=' );
	@mdefNam = replace( @mdefNap           , char(13) +char(10)', ',' );                                              
	
	@stmt    = 'update mzdyhd set ' +@mdefNap +' from mzdyit ' +
	           'where mzdyhd.ndoklad = ' +@sdoklad +' and mzdyit.sid = ' +@sid;  
	             
    EXECUTE IMMEDIATE @stmt;				 		 
  end while;			 
			 
  close curs_mzdyit;			 
END;
*/


// vytvoříme pomocný soubor, kde budou jen vybraní pracovníci proklauzuli WHERE
/*
select msprc_mo.noscisPrac, 
       msprc_mo.nrok      , 
	   msprc_mo.nobdobi
       into #msprc_moW 
       from msprc_mo
       where ( nrok       = 2012 and
	           nobdobi    = 4    and
			   nosCisPrac <> 0      )
;
*/

declare %yyyy Integer, %mm Integer;
%yyyy  = 2012;
%mm    =    4;


// zrušíme záznamy v mzdyhd a mzdyit 
delete from mzdyhd
       where (mzdyhd.nrok       = %yyyy and
              mzdyhd.nobdobi    =   %mm and
              mzdyhd.noscisPrac <> 0       )
;

delete from mzdyit
        where (mzdyit.nrok       = %yyyy and
               mzdyit.nobdobi    =   %mm and
               mzdyit.noscisPrac <> 0       )  
;

// překopíruje do mzdyit záznamy nemocenek a srážek z mzddavit pro cdenik <> 'MH' bez sumace
insert into mzdyit (  ctask              , cUloha             , cDenik             , cObdobi            ,
                      nRok               , nObdobi            , nRokObd            , CTYPDOKLAD         ,
                      CTYPPOHYBU         , nDoklad            , nOrdItem           , cKmenStrPr         ,
                      nOsCisPrac         , cPracovnik         , nPorPraVzt         , nTypPraVzt         ,
                      nTypZamVzt         , nClenSpol          , cMzdKatPra         , cPracZar           ,
                      cPracZarDo         , dDatPoriz          , CUCETSKUP          , nDruhMzdy          ,
                      nDnyDoklad         , nHodDoklad         , nMnPDoklad         , nSazbaDokl         ,
                      nMzda              , nZaklSocPo         , nZaklZdrPo         , nDnyFondKD         ,
                      nDnyFondPD         , nHodFondKD         , nHodFondPD         , nHodPresc          ,
                      nHodPrescS         , nHodPripl          , cZkratJEDN         , nLikCelDOK         ,
                      nZdrPojis          , nMimoPrVzt         , nTypDuchod         , cVarSym            ,
                      nPoradi            , dDatumOD           , dDatumDO           , nDnyVylocD         ,
                      nDnyVylDOD         , nDnyDovol          , cZkrTypZAV         , cPolVyplPa         ,
                      cVyplMist          , nKLikvid           , nZLikvid           , cTmKmStrPr         ,
                      nTMPnum1           , nTMPnum2                                                     )
        select        mzddavit.ctask     , mzddavit.cUloha    , mzddavit.cDenik    , mzddavit.cobdobi   ,
                      mzddavit.nRok      , mzddavit.nObdobi   , mzddavit.nRokObd   , mzddavit.CTYPDOKLAD,
                      mzddavit.CTYPPOHYBU, 
                      ((mzddavit.noscisPrac   *    100000) + 
                       (mzddavit.nporPraVzt   *       100) +
                       (mzddavit.nobdobi                  ))  , mzddavit.nOrdItem  , mzddavit.cKmenStrPr,
                      mzddavit.nOsCisPrac, mzddavit.cPracovnik, mzddavit.nPorPraVzt, mzddavit.nTypPraVzt,
                      mzddavit.nTypZamVzt, mzddavit.nClenSpol , mzddavit.cMzdKatPra, mzddavit.cPracZar  ,
                      mzddavit.cPracZarDo, mzddavit.dDatPoriz , mzddavit.CUCETSKUP , mzddavit.nDruhMzdy ,
                      mzddavit.nDnyDoklad, mzddavit.nHodDoklad, mzddavit.nMnPDoklad, mzddavit.nSazbaDokl,
                      mzddavit.nMzda     , mzddavit.nZaklSocPo, mzddavit.nZaklZdrPo, mzddavit.nDnyFondKD,
                      mzddavit.nDnyFondPD, mzddavit.nHodFondKD, mzddavit.nHodFondPD, mzddavit.nHodPresc ,
                      mzddavit.nHodPrescS, mzddavit.nHodPripl , mzddavit.cZkratJEDN,                   0,
                      mzddavit.nZdrPojis ,                   0,                   0, mzddavit.cVarSym   ,
                      mzddavit.nPoradi   , mzddavit.dDatumOD  , mzddavit.dDatumDO  , mzddavit.nDnyVylocD,
                      mzddavit.nDnyVylDOD, mzddavit.nDnyDovol , mzddavit.cZkrTypZAV,                  '',
                                       '', mzddavit.nKLikvid  , mzddavit.nZLikvid  , mzddavit.cTmKmStrPr,
                      mzddavit.nTMPnum1  , mzddavit.nTMPnum2
          from mzddavit
          left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok        and
                                  mzddavit.nobdobi    = msprc_mo.nobdobi     and
                                  mzddavit.noscisPrac = msprc_mo.noscisPrac  and
                                  mzddavit.nporpraVzt = msprc_mo.nporpraVzt     )
          where (mzddavit.nrok       =  %yyyy and
                 mzddavit.nobdobi    =    %mm and
                 mzddavit.noscisPrac <> 0     and
                 mzddavit.cdenik     <> 'MH'  and
                 msprc_mo.lautoVypCm          and
                 msprc_mo.lstavem               )							  
;

// sumace za klíč mzddavit -> mzdyit
insert into mzdyit ( nrok      , nobdobi   , noscisPrac, nporPraVzt, cdenik   ,
                     ndruhMzdy , ndnyDoklad, nhodDoklad, nmnPDoklad, nMzda    ,
                     nhodPresc ,nhodPrescS, nhodPripl , ndnyVylocD, ndnyVylDOD, ndnyDovol)
       select        mzddavit.nrok                ,
                     mzddavit.nobdobi             ,
                     mzddavit.noscisPrac          ,
                     mzddavit.nporPraVzt          ,
                     mzddavit.cdenik              ,
                     mzddavit.ndruhMzdy           ,
                     sum(ndnyDoklad) as ndnyDoklad,
                     sum(nhodDoklad) as nhodDoklad,
                     sum(nmnPDoklad) as nmnPDoklad,
                     sum(nMzda)      as nmzda     ,
                     sum(nhodPresc)  as nhodPresc ,
                     sum(nhodPrescS) as nhodPrescS,
                     sum(nhodPripl)  as nhodPripl ,
                     sum(ndnyVylocD) as ndnyVylocD,
                     sum(ndnyVylDOD) as ndnyVylDOD,
                     sum(ndnyDovol)  as ndnyDovol
       from mzddavit
       left join msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok         and
                               mzddavit.nobdobi    = msprc_mo.nobdobi      and
                               mzddavit.noscisPrac = msprc_mo.noscisPrac   and
                               mzddavit.nporpraVzt = msprc_mo.nporpraVzt      )
       where (mzddavit.nrok       = %yyyy and
              mzddavit.nobdobi    =   %mm and
              mzddavit.noscisPrac <> 0    and
              mzddavit.cdenik     = 'MH'  and
              msprc_mo.lautoVypCm         and
              msprc_mo.lstavem              )							   							   
       group by mzddavit.nrok      ,
                mzddavit.nobdobi   ,
                mzddavit.nosCisPrac,
                mzddavit.nporPraVzt,
                mzddavit.cdenik    ,
                mzddavit.ndruhMzdy
;

// doplní se položky ve mzdyit, které nelze sumovat
update mzdyit set ctask      = mzddavit.ctask      ,
                  culoha     = mzddavit.culoha     ,
                  cdenik     = mzddavit.cdenik     ,
                  cobdobi    = mzddavit.cobdobi    ,
                  nrokObd    = mzddavit.nrokObd    ,
                  cdenik     = mzddavit.cdenik     ,
                  ctypDoklad = mzddavit.ctypDoklad ,
                  ctypPohybu = mzddavit.ctypPohybu ,
                  nordItem   = mzddavit.nordItem   ,
                  ckmenStrPr = mzddavit.ckmenStrPr ,
                  cpracovnik = mzddavit.cpracovnik ,
                  ntypPraVzt = mzddavit.ntypPraVzt ,
                  ntypZamVzt = mzddavit.ntypZamVzt ,
                  nclenSpol  = mzddavit.nclenSpol  ,
                  cmzdKatPra = mzddavit.cmzdKatPra ,
                  cpracZar   = mzddavit.cpracZar   ,
                  cpracZarDo = mzddavit.cpracZarDo ,
                  ddatPoriz  = mzddavit.ddatPoriz  ,
                  cucetSkup  = mzddavit.cucetSkup  ,
                  nsazbaDokl = mzddavit.nsazbaDokl ,
                  nzaklSocPo = mzddavit.nzaklSocPo ,
                  nzaklZdrPo = mzddavit.nzaklZdrPo ,
                  ndnyFondKd = mzddavit.ndnyFondKd ,
                  ndnyFondPd = mzddavit.ndnyFondPd ,
                  nhodFondKd = mzddavit.nhodFondKd ,
                  nhodFondPd = mzddavit.nhodFondPd ,
                  czkratJedn = mzddavit.czkratJedn ,
                  nzdrPojis  = mzddavit.nzdrPojis  ,
                  cvarSym    = mzddavit.cvarSym    ,
                  nporadi    = mzddavit.nporadi    ,
                  ddatumOd   = mzddavit.ddatumOd   ,
                  ddatumDo   = mzddavit.ddatumDo   ,
                  czkrTypZav = mzddavit.czkrTypZav ,
                  ctmKmStrPr = mzddavit.ctmKmStrPr ,
                  nTMPnum1   = mzddavit.nTMPnum1   ,
                  nTMPnum2   = mzddavit.nTMPnum2   ,
                  ndoklad    =  ((mzddavit.noscisPrac    *    100000) +
                                 (mzddavit.nporPraVzt    *       100) +
                                 (mzddavit.nobdobi                  ))		
       from mzddavit
       left join mzdyit on ( mzdyit.nrok       = mzddavit.nrok           and
                             mzdyit.nobdobi    = mzddavit.nobdobi        and
                             mzdyit.nosCisPrac = mzddavit.nosCisPrac     and
                             mzdyit.nporPraVzt = mzddavit.nporPraVzt     and
                             mzdyit.ndruhMzdy  = mzddavit.ndruhMzdy         )
       where ( mzdyit.nrok       = %yyyy and
               mzdyit.nobdobi    =   %mm and
               mzdyit.noscisPrac <> 0    and
               mzdyit.cdenik     = 'MH'    )							 
;

// sumace za klíč mzdyit -> mzdyhd
insert into mzdyhd ( nrok, nobdobi, noscisPrac, nporPraVzt, ndoklad)
       select        mzdyit.nrok      ,
	                 mzdyit.nobdobi   , 
                     mzdyit.noscisPrac,
                     mzdyit.nporPraVzt,
                     mzdyit.ndoklad   
       from mzdyit	
       where ( mzdyit.nrok       =  %yyyy and
               mzdyit.nobdobi    =    %mm and
               mzdyit.noscisPrac <> 0        )	
       group by mzdyit.nrok      ,
                mzdyit.nobdobi   ,
                mzdyit.nosCisPrac,
                mzdyit.nporPraVzt,
                mzdyit.ndoklad		 
;	

// doplní se položky ve mzdyhd, které nelze sumovat
update mzdyhd set ctask         = msprc_mo.ctask      ,
                  culoha        = msprc_mo.culoha     ,
//                cdenik        = mzdyit.cdenik            ?
                  cobdobi       = msprc_mo.cobdobi    ,
//                nrok          = msprc_mo.nrok            SUM
//                nobdobi       = msprc_mo.nobdobi         SUM
                  nrokObd       = msprc_mo.nrokObd    ,
                  nctvrtleti    = msprc_mo.nctvrtleti ,
//                ctypDoklad    = mzdyit.ctypDoklad        ?   
//                ctypPohybu    = mzdyit.ctypPohybu        ?
//                ndoklad       = mzdyit.ndoklad           SUM
                  ckmenStrPr    = msprc_mo.ckmenStrPr ,
//                noscisPrac    = msprc_mo.noscisPrac      SUM
                  cjmenoRozl    = msprc_mo.cjmenoRozl ,
                  cdruPraVzt    = msprc_mo.cdruPraVzt ,
//                nporPraVzt    = msprc_mo.nporPraVzt      SUM
                  ntypPraVzt    = msprc_mo.ntypPraVzt ,
                  cvznPraVzt    = msprc_mo.cvznPraVzt ,
                  ntypZamVzt    = msprc_mo.ntypZamVzt ,
                  nmimoPrVzt    = msprc_mo.nmimoPrVzt ,
                  cPracovnik    = left(msprc_mo.cPracovnik,30) ,
                  cmzdKatPra    = msprc_mo.cmzdKatPra ,
                  cpracZar      = msprc_mo.cpracZar   ,
                  ntypDuchod    = msprc_mo.ntypDuchod ,
                  nzdrPojis     = msprc_mo.nzdrPojis  ,
                  cdelkPrDob    = msprc_mo.cdelkPrDob ,
                  cprukazZPS    = msprc_mo.cprukazZPS ,
                  nfyzStaSoc    = msprc_mo.nfyzStaSoc ,
                  nfyzStaZdr    = msprc_mo.nfyzStaZdr ,
                  nfyzStavOb    = msprc_mo.nfyzStavOb , 
                  nfyzStavKo    = msprc_mo.nfyzStavKo ,
                  nfyzStavPr    = msprc_mo.nfyzStavPr ,
                  npreStavPr    = msprc_mo.npreStavPr ,
                  ctmKmStrPr    = msprc_mo.ctmKmStrPr 	   
       from msprc_mo
	   left join mzdyhd on ( mzdyhd.nrok       = msprc_mo.nrok        and
                             mzdyhd.nobdobi    = msprc_mo.nobdobi     and
                             mzdyhd.noscisPrac = msprc_mo.noscisPrac  and
                             mzdyhd.nporpraVzt = msprc_mo.nporpraVzt     )
       where ( mzdyhd.nrok       = %yyyy and
               mzdyhd.nobdobi    =   %mm and
               mzdyhd.noscisPrac <> 0       )					 								 
;	   

// nápočet mzdyit do mzdyhd dle nastavení podmínek v souboru drzhyMzd
// EXECUTE PROCEDURE UpdateItems();

//drop table	#msprc_moW
//;
//drop procedure UpdateItems
//;
		   