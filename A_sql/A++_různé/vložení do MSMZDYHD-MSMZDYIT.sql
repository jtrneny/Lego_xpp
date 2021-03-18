delete from MSMZDYHD  ;
delete from MSMZDYIT  ;

insert into MSMZDYHD ( ctask,cUloha,cDenik,noscisprac,nporpravzt,lautovyphm,lzaklmatr,nkeymatr,cnazMatr)
select ctask,cUloha,'MH',noscisprac,nporpravzt,lautovyphm,false,1,'Základní mzda'
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm   ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,10,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',120
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm and cTypTarMZD = 'CASOVA'  ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,10,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',122
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm  and cTypTarMZD = 'MESICNI'  ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,20,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',150
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm   ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,30,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',127
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm   ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,40,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',156
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm   ;

insert into MSMZDYIT ( ctask,cUloha,cDenik,noscisprac,nporpravzt,nkeymatr,norditem,cnazpol1,cnazpol2,cnazpol3,cnazpol4,ndruhmzdy)
select ctask,cUloha,'MH',noscisprac,nporpravzt,1,50,cnazpol1,'',convert(convert(cnazpol1,SQL_INTEGER)+500,SQL_CHAR),'',199
from MSPRC_MO where nrok=2012 and nobdobi=10 and lautovyphm   ;


