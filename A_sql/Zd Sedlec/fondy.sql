update mzddavit set mzddavit.ndnyfondkd = mzddavit.ndnydoklad,
                    mzddavit.ndnyfondpd = mzddavit.ndnydoklad
			 from druhymzd where mzddavit.cobdobi='06/14' 
			        and mzddavit.ndruhmzdy = druhymzd.ndruhmzdy and mzddavit.cobdobi = druhymzd.cobdobi
					  and ( druhymzd.nnapochm = 0 or druhymzd.nnapochm = 2 or druhymzd.nnapochm = 4 or druhymzd.nnapochm = 5)
					   and  druhymzd.nnapocfpd = 1           ;
					   
update mzddavit set mzddavit.nhodfondkd = mzddavit.nhoddoklad,
                    mzddavit.nhodfondpd = mzddavit.nhoddoklad
			 from druhymzd where mzddavit.cobdobi='06/14' 
			        and mzddavit.ndruhmzdy = druhymzd.ndruhmzdy and mzddavit.cobdobi = druhymzd.cobdobi 
					  and ( druhymzd.nnapochm = 0 or druhymzd.nnapochm = 3 or druhymzd.nnapochm = 4 or druhymzd.nnapochm = 6)
					   and  druhymzd.nnapocfpd = 1           
					   