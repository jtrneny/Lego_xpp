select mzddavit.ndruhMzdy, 
       msprc_mo.nosCisPrac, msprc_mo.cpracovnik,
	   druhyMzd.cnazevDMZ
       from mzddavit as mzddavit
	   left join msprc_mo as msprc_mo on ( mzddavit.nrok       = msprc_mo.nrok       and
	                                       mzddavit.nobdobi    = msprc_mo.nobdobi    and
										   mzddavit.nosCisPrac = msprc_mo.noscisPrac and
										   mzddavit.nporPraVzt = msprc_mo.nporPraVzt    )
       left join druhyMzd as druhyMzd on ( mzddavit.nrok       = druhyMzd.nrok       and
	   									   mzddavit.nobdobi    = druhyMzd.nobdobi    and
										   mzddavit.ndruhMzdy  = druhyMzd.ndruhMzdy     )      
       where (mzddavit.nrok       = 2011 and 
	          mzddavit.nobdobi    = 5    and 
			  mzddavit.noscisPrac = 631  and 
			  mzddavit.nporPraVzt = 1    and 
			  mzddavit.ctypDoklad = 'MZD_PRIJEM')   										   