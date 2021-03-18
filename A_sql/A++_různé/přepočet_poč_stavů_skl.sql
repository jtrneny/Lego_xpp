DELETE FROM CENZB_PS where nrok=2013 ;
INSERT INTO CENZB_PS(ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenapoc,nmnozpoc)
       SELECT ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenakon,nmnozkon			
	   FROM PVPKUMUL WHERE (cObdPoh = '12/12') ;
UPDATE CENZB_PS	SET nRok = 2013 WHERE nrok = 0 ;    

update cenzboz set ncenapoc = 0,nmnozpoc=0;
update cenzboz set cenzboz.ncenapoc = cenzb_ps.ncenapoc,cenzboz.nmnozpoc=cenzb_ps.nmnozpoc
               from cenzb_ps
               where cenzboz.ccissklad = cenzb_ps.ccissklad and cenzboz.csklpol = cenzb_ps.csklpol and cenzb_ps.nrok = 2013
