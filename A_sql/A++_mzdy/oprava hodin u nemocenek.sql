update mzddavit set mzddavit.nhodfondpd = mzddavit.nvykazN_PD * c_pracdo.nhodden,
                     mzddavit.nhodfondkd = mzddavit.nvykazN_KD * c_pracdo.nhodden 
               from msprc_mo,c_pracdo  
                     where mzddavit.nrok = 2017 and
                             mzddavit.cobdobi = msprc_mo.cobdobi and
			       mzddavit.cdenik = 'MN' and
				  mzddavit.nmsprc_mo = msprc_mo.sid and   
				   msprc_mo.cdelkprdob = c_pracdo.cdelkprdob     ;

update mzdyit set mzdyit.nhodfondpd = mzdyit.ndnyfondpd * c_pracdo.nhodden,
                     mzdyit.nhodfondkd = mzdyit.ndnyfondkd * c_pracdo.nhodden 
                      from msprc_mo,c_pracdo  
                        where mzdyit.nrok = 2017 and
                             mzdyit.cobdobi = msprc_mo.cobdobi and
			       mzdyit.cdenik = 'MN' and
				  mzdyit.nmsprc_mo = msprc_mo.sid and   
				   msprc_mo.cdelkprdob = c_pracdo.cdelkprdob 