//select sum(nkcnaopesk) from listit where cciszakaz='13417' and cobdobi ='01/21' and ckmenstrpr='51'  ;
//select sum(nmzda) from mzddavit where cnazpol3='13417' and cobdobi ='12/20' and ndruhmzdy = 120   ;
//select sum(nmzda) from mzddavit where cnazpol3='13417' and cobdobi ='01/21'    ;
//select sum(nkcnaopesk) from listit where cciszakaz='13417' and cobdobi ='12/21'   ;
//select sum(nkcmd) from ucetpol where cnazpol3='13417' and cobdobi ='12/20' and cucetskup = '120' and ctypuct <> 'MZ_HRMZDA'  ;
//select sum(nkcmd) from ucetpol where cnazpol3='13417' and cobdobi ='01/21 ' and cucetskup = '120'   ;
//select sum(ncenacelk) from pvpitem where cciszakaz='13416' and cobdobi ='12/20' ;
select sum(nkcmd) from ucetpol where cnazpol3='13416' and cobdobi ='12/20' and ( cdenik = 'MH' or cdenik = 'D ') ;
//select sum(nkcmd) from ucetpol where cobdobi = '12/20' and cnazpol3='13416' and norducto = 1 and cdenik = 'MH'
//select sum(nkcmd) from ucetpola where cnazpol3='13416' and cobdobi ='12/20'    ;

