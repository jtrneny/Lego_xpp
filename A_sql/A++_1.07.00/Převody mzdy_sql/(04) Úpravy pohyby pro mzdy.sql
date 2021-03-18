update mzddavhd set cRoObCpPPv = '' ;
update mzddavhd set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;

update mzddavhd set cRoCpPPv = '' ;
update mzddavhd set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;


update mzddavhd set cCpPPv = Substring( cRoObCpPPv, 7, 8)   ;
update mzddavhd set nclenspol   = 1  where ntypzamvzt = 3   ;


update mzddavit set cRoObCpPPv = '' ;
update mzddavit set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;


update mzddavit set cRoCpPPv = '' ;
update mzddavit set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update mzddavit set nclenspol   = 1  where ntypzamvzt = 3   ;



update mzdyhd set cRoObCpPPv = '' ;
update mzdyhd set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;

update mzdyhd set cRoCpPPv = '' ;
update mzdyhd set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
//update mzdyhd set nclenspol   = 1  where ntypzamvzt = 3   ;


update mzdyhd set cCpPPv = Substring( cRoObCpPPv, 7, 8)   ;



update mzdyit set cRoObCpPPv = '' ;
update mzdyit set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;

update mzdyit set cRoCpPPv = '' ;
update mzdyit set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;



update mzdyit set nclenspol  = 1  where ntypzamvzt = 3   ;
update mzdyit set cCpPPv = Substring( cRoObCpPPv, 7, 8)   ;

update mzddavit  set cucetskup = Left( convert( ndruhmzdy, SQL_CHAR), 4)   ;
update mzdyit    set cucetskup = Left( convert( ndruhmzdy, SQL_CHAR), 4)   ;
								  	
update mzddavhd set cjmenoRozl = msprc_mo.cjmenoRozl from msprc_mo where mzddavhd.cRoObCpPPv=msprc_mo.cRoObCpPPv  ;
update mzddavit set cjmenoRozl = msprc_mo.cjmenoRozl from msprc_mo where mzddavit.cRoObCpPPv=msprc_mo.cRoObCpPPv  ;
