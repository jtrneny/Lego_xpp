//select * from akcionar where ncisosoby is null 
//update akcionar set ncisosoby = 0 where ncisosoby is null
//update akcionar set cosoba = cjmenoakci, cjmenorozl = cjmenoakci  where ncisosoby = 0

//update akcionar set akcionar.ncisOsoby  = osoby.ncisOsoby,
//                    akcionar.cosoba     = osoby.cosoba,
//					akcionar.cjmenoRozl = osoby.cjmenoRozl,
//					akcionar.cpretel    = '9999',
//					akcionar.nOSOBY     = osoby.sID
//					from osoby where Left(Akcionar.cRodCisAkc,12) = Left(osoby.cRodCisOsb,12)
					
update akcie set akcie.ncisOsoby  = akcionar.ncisOsoby,
                 akcie.cosoba     = akcionar.cosoba,
                 akcie.cjmenoRozl = akcionar.cjmenoRozl
 			 from akcionar where akcie.nAKCIONAR = akcionar.sID; 
					
