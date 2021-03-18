drop table #mzdy_ITw ;
// drop table #mzdy_ITa ;

EXECUTE PROCEDURE sp_GetTables( NULL, NULL, 'mzdy_ITw', 'Local Temporary' ); 

select nrok, nobdobi, noscisPrac, nporPraVzt, ndruhMzdy, ndoklad,
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
       where (nrok = 2011 and nobdobi = 5 and noscisPrac = 631 and nporPraVzt = 1 and ctypDoklad = 'MZD_PRIJEM')   
       group by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy, ndoklad
       order by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy
;
select * into #mzdy_ITa
         from mzddavit           		 
         where nrok = 2011 and nobdobi = 5 and noscisPrac = 631 and nporPraVzt = 1
         order by nrok, nobdobi, nosCisPrac, nporPraVzt, ndruhMzdy  
;
select a.noscisPrac, a.mzda, b.cpracovnik
       from #mzdy_ITw as a 
       right join #mzdy_ITa as b on ( a.nrok       = b.nrok       and 
                     	             a.nobdobi    = b.nobdobi    and 
			                         a.noscisPrac = b.nosCisPrac and 
                                     a.nporPraVzt = b.nporPraVzt     )


		 		   