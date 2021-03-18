update zvirata set zvirata.nkusy=1
	   from zvzmenit where zvzmenit.cObdobi = '07/11' and zvzmenit.ntyppohyb = -1
	                         and zvirata.cnazpol1=zvzmenit.cnazpol1
                              and zvirata.cnazpol4=zvzmenit.cnazpol4 
 			  				   and zvirata.nzvirkat=zvzmenit.nzvirkat
 			  				    and zvirata.ninvcis=zvzmenit.ninvcis               ;

update zvirata set zvirata.nkusy=9
	   from zvzmenit where zvzmenit.cObdobi = '07/11' and zvzmenit.ntyppohyb = 1
	                         and zvirata.cnazpol1=zvzmenit.cnazpol1
                              and zvirata.cnazpol4=zvzmenit.cnazpol4 
 			  				   and zvirata.nzvirkat=zvzmenit.nzvirkat
 			  				    and zvirata.ninvcis=zvzmenit.ninvcis               ;

								
delete from zvirata where nkusy=9 
