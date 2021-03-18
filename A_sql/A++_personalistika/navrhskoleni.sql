//select ncisOsoby, ¨
//       czkratka,
//       dposlSKOLE,
//       nperioOpak,
//       czkratJedn,
//       ddalsSKOLE,
//       year(curDate()) -year(dposlSKOLE),
//       ( year(curDate()) -year(dposlSKOLE)     )/nperioOpak as npredp_predp,
//       dposlSKOLE + ( ( ( ( year(curDate()) -year(dposlSKOLE))/nperioOpak ) nperioOpak ) 365 ) as dpredp_skol,
//       round( ( year(curDate()) -year(dposlSKOLE) +.00)/nperioOpak, 0) as ndals_skol,
//       dposlSKOLE + ( ( round( ( year(curDate()) -year(dposlSKOLE) +.00)/nperioOpak, 0) nperioOpak )  365 ) as ddals_skol
//   from skoleni
//   where not empty(dposlSKOLE)
//   order by ncisOsoby;


/*
select persitem.crodCisPra, persitem.ddatPREDko, 
       lekprohl.ncisOsoby, lekprohl.dposlLEKpr, lekprohl.nperioOpak, lekprohl.czkratJedn, lekprohl.ddalsLEKpr 
       from persitem
       left join lekprohl on persitem.crodCisPra = lekprohl.crodCisPra
	   order by persitem.crodCisPra, persitem.ddatPREDko; 

select persitem.crodCisPra, persitem.ddatPREDko 
       from persitem
	   where persitem.crodCisPra = '95-10-10/2646';
	   


SELECT DISTINCT [ddatPREDko], [czkratka], [coblastTyp], count(*)
       FROM persitem
       GROUP BY ddatPREDko,czkratka, coblastTyp ;  
*/

// lekprohl
select ncisOsoby, czkratka, dposlLEKpr, nperioOpak, czkratJedn, ddalsLEKpr,
       year(curDate()) -year(dposlLEKpr),
	   ( year(curDate()) -year(dposlLEKpr)     )/nperioOpak as npredp_lekPr,
	   dposlLEKpr + ( ( ( ( year(curDate()) -year(dposlLEKpr))/nperioOpak ) *nperioOpak ) *365 ) as dpredp_lekPr,
	   round( ( year(curDate()) -year(dposlLEKpr) +.00)/nperioOpak, 0) as ndals_lekPr,
	   dposlLEKpr + ( ( round( ( year(curDate()) -year(dposlLEKpr) +.00)/nperioOpak, 0) *nperioOpak ) * 365 ) as ddals_lekPr 
       from lekprohl
	   where not empty(dposlLEKpr) and nperioOpak <> 0 
	   order by ncisOsoby;	   
	
/*	   
// skoleni
select ncisOsoby, czkratka, dposlSKOLE, nperioOpak, czkratJedn, ddalsSKOLE,
       year(curDate()) -year(dposlSKOLE),
	   ( year(curDate()) -year(dposlSKOLE)     )/nperioOpak as npredp_predp,
	   dposlSKOLE + ( ( ( ( year(curDate()) -year(dposlSKOLE))/nperioOpak ) *nperioOpak ) *365 ) as dpredp_skol,
	   round( ( year(curDate()) -year(dposlSKOLE) +.00)/nperioOpak, 0) as ndals_skol,
	   dposlSKOLE + ( ( round( ( year(curDate()) -year(dposlSKOLE) +.00)/nperioOpak, 0) *nperioOpak ) * 365 ) as ddals_skol 
       from skoleni
	   where not empty(dposlSKOLE) and nperioOpak <> 0
	   order by ncisOsoby;	   
*/	   