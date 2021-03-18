DELETE FROM CENZB_PS where nrok=2011 ;
INSERT INTO CENZB_PS(ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenapoc,nmnozpoc)
       SELECT ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenakon,nmnozkon			
	   FROM PVPKUMUL WHERE (cObdPoh = '12/10') ;
UPDATE CENZB_PS	SET nRok = 2011 WHERE nrok = 0 ;    
