update procenho set ntyphodn=1 from procenit where  procenho.ncisprocen=procenit.ncisprocen and
                                                    procenho.npolprocen=procenit.npolprocen   ; 
update procenho set ntyphodn=9 where  procenho.ntyphodn=0 ;
update procenho set ntyphodn=0 where  procenho.ntyphodn=1 ;
									  
select procenho.* from procenho where procenho.ntyphodn=9
