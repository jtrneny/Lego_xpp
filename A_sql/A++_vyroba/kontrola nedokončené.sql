//select sum(ncenacelk) from pvpitem where cnazpol3='13221' and (cobdobi='09/18' or cobdobi='08/18') and czkratmeny='CZK'
//select sum(nkcnaopesk) from listit where cciszakaz='13221' and (cobdobi='09/18' or cobdobi='08/18')
//select sum(nkcmd) from ucetpol where cnazpol3='13221' and (cobdobi='09/18' or cobdobi='08/18') and cdenik = 'MH' //and cdenik <> 'S'
//select * from ucetpol where cnazpol3='13221' and (cobdobi='09/18' or cobdobi='08/18') and cdenik <> 'MH' //and cdenik <> 'S'
//select * from listit where cciszakaz='13221' and (cobdobi='09/18' or cobdobi='08/18') and ckmenstrpr ='51'
//select sum(nkcnaopesk),sum(nkcopeprem),sum(nkcopeprip) from listit where cciszakaz='13221' and (cobdobi='09/18' or cobdobi='08/18') and ckmenstrpr='51' 
//select sum(nkcnaopesk),sum(nkcopeprem),sum(nkcopeprip) from listit where cciszakaz='13221' and (cobdobi='09/18' or cobdobi='08/18') and (ckmenstrpr='91' or ckmenstrpr='99')
//select sum(nkcmd) from ucetpol where cnazpol3='13221' and cobdobi='09/18' and norducto = 1 //and cdenik <> 'S'
select * from ucetpol where cnazpol3='13221' and cobdobi='09/18' and norducto = 1 //and cdenik <> 'S'