delete from firmyva where ncisfirmy = 0  ;
update firmy set nis_ODB=0,nis_DOD=0,nis_FAA=0,nis_DOP=0,nis_DOA=0,
                 nis_KON=0,nis_KOA=0,nis_ZAK=0,nis_MAF=0,nis_POJ=0,
				 nis_ZDP=0,nis_BAN=0,nis_INO=0     ;     
//				  ,nis_AKC=0                    ; 

update firmy set nis_ODB = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'ODB'    ;
update firmy set nis_DOD = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'DOD'    ;
update firmy set nis_FAA = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'FAA'    ;
update firmy set nis_DOP = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'DOP'    ;
update firmy set nis_DOA = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'DOA'    ;
update firmy set nis_KON = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'KON'    ;
update firmy set nis_KOA = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'KOA'    ;
update firmy set nis_ZAK = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'ZAK'    ;
update firmy set nis_MAF = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'MAF'    ;
update firmy set nis_POJ = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'POJ'    ;
update firmy set nis_ZDP = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'ZDP'    ;
update firmy set nis_BAN = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'BAN'    ;
update firmy set nis_INO = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
                                                 firmyva.czkr_Sk = 'INO'    ;
//update firmy set nis_AKC = 1 from firmyva where firmy.ncisfirmy = firmyva.ncisfirmy and
//                                                 firmyva.czkr_Sk = 'AKC'    ;
			

								 												    