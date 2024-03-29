// AKCIONARI - OSOBY
select nhodnotaAK, nhodnotaVH, npocetHLAS from akcionar where npocetHlas <> 0;

select Akcionar.cRodCisAkc, akcionar.cJmenoAkci,
       osoby.ncisOsoby, osoby.cRodCisOsb, osoby.cosoba 
       from akcionar
       left join osoby on Akcionar.cRodCisAkc = osoby.cRodCisOsb; 
	   
update akcionar set akcionar.ncisOsoby  = osoby.ncisOsoby,
                    akcionar.cosoba     = osoby.cosoba,
					akcionar.cjmenoRozl = osoby.cjmenoRozl,
					akcionar.nOSOBY     = osoby.sID
					from osoby where Akcionar.cRodCisAkc = osoby.cRodCisOsb;
					
// AKCIONARI - AKCIE
select akcie.cRodCisAkc, akcie.cJmenoAkci, akcie.cSerCisAkc,
       Akcionar.cRodCisAkc, akcionar.cJmenoAkci
       from akcie
       left join akcionar on akcie.cRodCisAkc = akcionar.cRodCisAkc
	   order by akcie.cRodCisAkc; 
					
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
						 
update apohybak set apohybak.dzmenaZazn = pohybak.ddatZmeny
                from pohybak where apohybak.ndoklad = pohybak.ndoklad;			 
			 
update apohybak set apohybak.nAKCIE = akcie.sID
 			    from akcie where akcie.cserCISakc = apohybak.cserCISakc ;	
		 
			 
// neco			 
select count(*), cserCisAkc, sum(nhodnotaAk)
       from akcie 
       group by cserCisAkc   
	   order by cserCisAkc;       			 
	   
update avalhrit set avalhrit.nAKCIONAR = akcionar.sID
 			 from akcionar where avalhrit.cRodCisAkc = akcionar.cRodCisAkc;	   
			 
select distinct(czkrTYPpoh) from apohybak order by czkrTYPpoh;			 