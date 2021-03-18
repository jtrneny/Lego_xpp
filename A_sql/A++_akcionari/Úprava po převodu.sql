// AKCIONARI - OSOBY
	   
update akcionar set akcionar.ncisOsoby  = osoby.ncisOsoby,
                    akcionar.cosoba     = osoby.cosoba,
					akcionar.cjmenoRozl = osoby.cjmenoRozl,
					akcionar.nOSOBY     = osoby.sID
					from osoby where Akcionar.cRodCisAkc = osoby.cRodCisOsb;
					
// AKCIONARI - AKCIE
					
update akcie set akcie.nAKCIONAR = akcionar.sID
 			 from akcionar where akcie.cRodCisAkc = akcionar.cRodCisAkc; 

update akcie set akcie.nzakHODakc = nhodnotaAk
       from  
	      ( select cserCISakc, sum(nhodnotaAk) hodnotaAk
		    from akcie
			group by cserCISakc ) b
	   where akcie.cserCISakc = b.cserCISakc;		 		 
			 
// APOHYBYAK - v nAKCIONAR je nový majitel akcie			 
update apohybak set apohybak.nAKCIONAR = akcionar.sID
 			 from akcionar where apohybak.cRodCisNew = akcionar.cRodCisAkc;
			 			 
// APOHYBYAK - v nAKCIONARp je původní majitel akcie						 
update apohybak set apohybak.nAKCIONARp = akcionar.sID
 			 from akcionar where apohybak.cRodCisAkc = akcionar.cRodCisAkc;						 
						 	 
update apohybak set apohybak.nAKCIE = akcie.sID
 			    from akcie where akcie.cserCISakc = apohybak.cserCISakc ;	
 
			 
// neco			 
	   
update avalhrit set avalhrit.nAKCIONAR = akcionar.sID
 			 from akcionar where avalhrit.cRodCisAkc = akcionar.cRodCisAkc;	   
			 
			 