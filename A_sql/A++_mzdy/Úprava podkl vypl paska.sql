update mzdyit set mzdyit.cpolvyplpa=druhymzd.cpolvyplpa from druhymzd 
                where mzdyit.cobdobi='07/13' and
        			 mzdyit.nrok=druhymzd.nrok and mzdyit.nobdobi=druhymzd.nobdobi and 
		    	        mzdyit.ndruhmzdy=druhymzd.ndruhmzdy    ;
update mzdyit set mzdyit.cpolvyplpa='0300' where mzdyit.cobdobi='07/13' and ndruhmzdy=900  ;
update mzdyit set mzdyit.cpolvyplpa='0500' where mzdyit.cobdobi='07/13' and ndruhmzdy=950  ;

 						