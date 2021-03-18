update zvzmenit set ncislodl = 5 from zvirata where zvzmenit.cObdobi = '07/11' and zvzmenit.ntyppohyb = -1
	                         and zvirata.cnazpol1=zvzmenit.cnazpol1
                              and zvirata.cnazpol4=zvzmenit.cnazpol4 
 			  				   and zvirata.nzvirkat=zvzmenit.nzvirkat
 			  				    and zvirata.ninvcis=zvzmenit.ninvcis               ;

