select *
			 from mzddavit,druhymzd where mzddavit.cobdobi='06/14' 
			        and mzddavit.ndruhmzdy = druhymzd.ndruhmzdy and mzddavit.cobdobi = druhymzd.cobdobi
					  and ( druhymzd.nnapochm = 2 or druhymzd.nnapochm = 4 or druhymzd.nnapochm = 5)
					   and  druhymzd.nnapocfpd = 1           ;
