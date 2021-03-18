delete from MSMZDYHD  ;

insert into MSMZDYHD ( ctask,cUloha,cDenik,noscisprac,nporpravzt,lautovyphm,lzaklmatr,nkeymatr,cnazMatr)
select ctask,cUloha,'MH',noscisprac,nporpravzt,lautovyphm,false,1,'Základní mzda'
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm
