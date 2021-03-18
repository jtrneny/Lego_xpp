DELETE FROM CENZB_PS where nrok=2017;

INSERT INTO CENZB_PS(nrok,ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenapoc,nmnozpoc)
       SELECT 2017,ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenakon,nmnozkon			
	   FROM PVPKUMUL WHERE (cObdPoh = '12/16') ;

update cenzboz set ncenapoc = 0,nmnozpoc=0;

update cenzboz set cenzboz.ncenapoc = cenzb_ps.ncenapoc,cenzboz.nmnozpoc=cenzb_ps.nmnozpoc
               from cenzb_ps
               where cenzboz.ccissklad = cenzb_ps.ccissklad and cenzboz.csklpol = cenzb_ps.csklpol and cenzb_ps.nrok = 2016
