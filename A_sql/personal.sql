select TOP 200 * from cenZboz where ccisSklad = '2'

/*
select objitem.csklPol,
       objitem.nmnozObODB, 
       objitem.nmnozPoODB,
	   objitem.nmnozDZbo , 
	   objitem.nmnozKoDOD, 
	   objitem.nmnozReODB,
	   cenZboz.nmnozDZbo as cen_D, 
	   cenZboz.nmnozKzbo as cen_K,
	   cenzboz.nmnozRzbo as cen_R 
       from objitem
	   left join cenZboz on ( objitem.ccisSklad = cenZboz.ccisSklad and
	                           objitem.csklPol   = cenZboz.csklPol       )
/*
select csklPol, nmnozDzbo, nmnozSzbo, nmnozRzbo, nmnozKzbo from cenZboz
       where csklPol = '218000'     or
	         csklPol = '2101000102' or
			 csklPol = '21010001051'  							   
   
	   
/*
delete from mzdyit
       where (nrok = 2011 and nobdobi = 10 and noscisPrac = 19075 )
;
insert into mzdyit ( nrok       , 
                     nobdobi    , 
					 noscisPrac , 
					 nporPraVzt , 
					 ndruhMzdy  ,
	                 ndnyDoklad ,
	                 nhodDoklad ,
                     nmnPDoklad )
       select nrok, nobdobi, noscisPrac, nporPraVzt, ndruhMzdy,
	   sum(ndnyDoklad) as ndnyDoklad, 
	   sum(nhodDoklad) as nhodDoklad,
	   sum(nmnPDoklad) as nmnPDoklad
       from mzddavit  							 									             		 
       where (nrok = 2011 and nobdobi = 10 and noscisPrac = 19075 and cdenik = 'MH') 
       group by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy
//       order by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy
   
/*
select a.nrok, a.nobdobi, a.noscisPrac, a.nporPraVzt, a.ndruhMzdy,
	   sum(a.ndnyDoklad) as dnyDoklad, 
	   sum(a.nhodDoklad) as hodDoklad,
	   sum(a.nmnPDoklad) as mnPDoklad,
	   sum(a.nMzda)      as mzda     ,
	   sum(a.nhodPresc)  as hodPresc ,
	   sum(a.nhodPrescS) as hodPrescS,
	   sum(a.nhodPripl)  as hodPripl ,
	   sum(a.ndnyVylocD) as dnyVylocD,
	   sum(a.ndnyVylDOD) as dnyVylDOD,
	   sum(a.ndnyDovol)  as dnyDovol 
       from mzddavit as a 							 									             		 
       where (a.nrok = 2011 and a.nobdobi = 10 and a.noscisPrac = 19075 and a.cdenik = 'MH')   
       group by a.nrok, a.nobdobi, a.nosCisPrac, a.nporPraVzt, a.ndruhMzdy
       order by a.nrok, a.nobdobi, a.nosCisPrac, a.nporPraVzt, a.ndruhMzdy
	   
	    
	   right join mzdavit as b on ( a.nrok       = b.nrok       and
	                                a.nobdobi    = b.nobdobi    and
									a.nosCisPrac = b.nosCisPrac and
									a.nporPraVzt = b.nporPraVzt and
									a.ndruhMzdy  = b.ndruhMzdy     )
	   




/*
// vazLekpr
update vazLekpr
       set nosoby = osoby.sID
       from osoby
       where (vazLekpr.nosCisPrac = osoby.nosCisPrac)
	   
insert into vazlekpr(nitem,lekprohl,noscisPrac)
       select lekprohl.nporadi    ,
	          lekprohl.sID        ,
			  lekprohl.noscisPrac
	   from lekprohl
		   
// vazOsoby rodinní pøíslušníci
update vazOsoby
       set osoby = osoby.sID
       from osoby
       where (vazOsoby.nosCisPrac = osoby.nosCisPrac)  

insert into vazosoby(nosoby,ctypRodPRI,noscisPrac)
       select osoby.sID           ,
	          rodprisl.ctypRodPRI  ,
	          rodprisl.noscisPrac       
	   from osoby
	   right join rodprisl on rodprisl.crodCisRP = osoby.crodcisOsb
	   
select rodprisl.noscisPrac,
       rodprisl.crodCisRP ,
       osoby.crodcisOsb   ,
	   osoby.ncisOsoby    , 
	   osoby.cosoba       ,
	   osoby.cprijOsob   
	   from osoby
	   right join rodprisl on rodprisl.crodCisRP = osoby.crodcisOsb
       order by osoby.cprijOsob
	   
update osoby
       set nis_ZAM = 0
	   where osoby.crodcisOsb NOT IN ( select msprc_mo.crodcisPra from msprc_mo)


update osoby
       set nis_PER = 0
	   where osoby.crodcisOsb NOT IN ( select personal.crodcisPra from personal)

update duchody
   set duchody.ncisOsoby = osoby.ncisOsoby
   from osoby
 where (duchody.nosCisPrac = osoby.nosCisPrac) 
*/
