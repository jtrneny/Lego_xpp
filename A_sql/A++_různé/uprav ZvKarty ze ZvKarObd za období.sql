update zvkarty set zvkarty.nmnozszv=zvkarobd.nmnozkon, zvkarty.nkusyzv=zvkarobd.nkusykon, zvkarty.nkd=zvkarobd.nkdkon,
                     zvkarty.ncenaczv=zvkarobd.ncenakon, zvkarty.ncenaszv=zvkarobd.nprumcena
	   FROM zvkarobd WHERE zvkarobd.cObdobi = '06/11' and zvkarty.cnazpol1=zvkarobd.cnazpol1
                                 and zvkarty.cnazpol4=zvkarobd.cnazpol4 and zvkarty.nzvirkat=zvkarobd.nzvirkat
