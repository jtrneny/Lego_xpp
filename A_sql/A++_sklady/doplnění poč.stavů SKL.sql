delete from CENZB_PS where nrok=2015 ;
insert into CENZB_PS(nRok,ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenapoc,nmnozpoc)
       select 2015,ccissklad,csklpol,nzbozikat,nucetskup,
                      ncenakon,nmnozkon			
	   from PVPKUMUL where (cObdPoh = '12/14') ;
update cenzboz set ncenapoc = 0,nmnozpoc=0 ;
update cenzboz set cenzboz.ncenapoc = cenzb_ps.ncenapoc,cenzboz.nmnozpoc=cenzb_ps.nmnozpoc
               from cenzb_ps
               where cenzboz.ccissklad = cenzb_ps.ccissklad and
			           cenzboz.csklpol = cenzb_ps.csklpol and 
					    cenzb_ps.nrok = 2015
   
