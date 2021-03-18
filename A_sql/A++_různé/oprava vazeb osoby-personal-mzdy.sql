update rodprisl set rodprisl.ncisosoby=osoby.ncisosoby from osoby    
     where rodprisl.noscisprac=osoby.noscisprac                       ;

update rodprisl set rodprisl.ncisosobrp=osoby.ncisosoby from osoby    
     where rodprisl.crodcisrp=osoby.crodcisosb                        ;
	 
update msprc_mo set msprc_mo.ncisosoby=osoby.ncisosoby from osoby    
     where msprc_mo.noscisprac=osoby.noscisprac                       ;
	 