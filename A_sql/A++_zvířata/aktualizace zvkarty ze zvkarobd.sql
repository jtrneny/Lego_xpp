update zvkarty set zvkarty.NCENACZV = zvkarobd.ncenakon,
                   zvkarty.NMNOZSZV = zvkarobd.nmnozkon,
                   zvkarty.NKUSYZV = zvkarobd.nkusykon,
                   zvkarty.NKD = zvkarobd.nkdkon
				from zvkarobd    
			    where  zvkarobd.cobdobi = '08/18' and zvkarty.CNAZPOL1 = zvkarobd.CNAZPOL1 and zvkarty.CNAZPOL4 = zvkarobd.CNAZPOL4 and
				         zvkarty.NZVIRKAT = zvkarobd.NZVIRKAT  