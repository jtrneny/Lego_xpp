update c_prepmj set c_prepmj.cVychoziMJ = 'XXX', c_prepmj.cVychoziMJ = 'XXX' from cenzboz
                    where c_prepmj.ccissklad=cenzboz.ccissklad and c_prepmj.cSklPol=cenzboz.cSklPol and 
					       c_prepmj.cVychoziMJ=cenzboz.CZKRATJEDN and c_prepmj.cCilovaMJ=cenzboz.CZKRATJEDN   ;
delete from c_prepmj where c_prepmj.cVychoziMJ = 'XXX' and c_prepmj.cVychoziMJ = 'XXX'                        ;						    
INSERT INTO c_prepmj( cCisSklad,cSklPol,nPocVychMJ,cVychoziMJ,nPocCilMJ,cCilovaMJ,nKoefPrVC)
       SELECT ccissklad,csklpol,1,CZKRATJEDN,1,CZKRATJEDN,1
	   FROM cenzboz 
