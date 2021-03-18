drop table #mzdy_ITw ;
// drop table #mzdy_ITa ;

select nrok, nobdobi, noscisPrac, nporPraVzt, ndruhMzdy,
	   sum(ndnyDoklad) as dnyDoklad, 
	   sum(nhodDoklad) as hodDoklad,
	   sum(nmnPDoklad) as mnPDoklad,
	   sum(nMzda)      as mzda     ,
	   sum(nhodPresc)  as hodPresc ,
	   sum(nhodPrescS) as hodPrescS,
	   sum(nhodPripl)  as hodPripl ,
	   sum(ndnyVylocD) as dnyVylocD,
	   sum(ndnyVylDOD) as dnyVylDOD,
	   sum(ndnyDovol)  as dnyDovol 
       into #mzdy_ITw
       from mzddavit           		 
       where nrok = 2011 and nobdobi = 5 and noscisPrac = 631 and nporPraVzt = 1 and ctypDoklad = 'MZD_PRIJEM'   
       group by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy
;
select a.nosCisPrac, a.ndruhMzdy, b.cnazevDmz, b.nrok, b.nobdobi
       from #mzdy_ITw as a, druhyMzd as b
	   where ( a.ndruhMzdy  = b.ndruhMzdy )	   
//	   where ( a.ndruhMzdy  = b.ndruhMzdy and a.nobdobi = b.nobdobi)	
//       right join druhyMzd as b on ( a.ndruhMzdy  = b.ndruhMzdy )      

select a.nosCisPrac, a.ndruhMzdy, b.cnazevDmz, b.nrok, b.nobdobi
       from #mzdy_ITw as a
       left join druhyMzd as b on ( a.ndruhMzdy = b.ndruhMzdy and
	                                 a.nobdobi   = b.nobdobi      )
									  
select a.nosCisPrac, a.ndruhMzdy, b.ndoklad
         from #mzdy_ITw as a, mzddavit  as b         		 
         where (a.nrok       = b.nrok       and 
		        a.nobdobi    = b.nobdobi    and 
			    a.noscisPrac = b.noscisPrac and 
			    a.nporPraVzt = a.nporPraVzt     )   	   
	   
	   
/*	   
;  	     	   
select * into #mzdy_ITa
         from mzddavit           		 
         where nrok = 2011 and nobdobi = 5 and noscisPrac = 631 and nporPraVzt = 1
;
select a.noscisPrac, a.mzda, b.cpracovnik
       from #mzdy_ITw as a 
       right join #mzdy_ITa as b on ( a.nrok       = b.nrok       and 
                     	             a.nobdobi    = b.nobdobi    and 
			                         a.noscisPrac = b.nosCisPrac and 
                                     a.nporPraVzt = b.nporPraVzt     )
/*
select a.noscisPrac, a.mzda, b.cpracovnik
       from #mzdy_ITw as a 
       right join mzddavit as b on ( a.nrok       = b.nrok       and 
                     	             a.nobdobi    = b.nobdobi    and 
			                         a.noscisPrac = b.nosCisPrac and 
                                     a.nporPraVzt = b.nporPraVzt     )										  
  */                                