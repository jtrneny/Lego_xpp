
update mzddavit set cRoObCpPPv = ''  where nrok=2014 and ndruhmzdy=500  ;
update mzddavit set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  where nrok=2014 and ndruhmzdy=500 ;


update mzddavit set cRoCpPPv = '' where nrok=2014 and ndruhmzdy=500 ;
update mzddavit set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  where nrok=2014 and ndruhmzdy=500   ;

update mzdyit set cRoObCpPPv = '' where nrok=2014 and ndruhmzdy=500 ;
update mzdyit set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  where nrok=2014 and ndruhmzdy=500   ;

update mzdyit set cRoCpPPv = '' where nrok=2014 and ndruhmzdy=500 ;
update mzdyit set cRoCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  where nrok=2014 and ndruhmzdy=500  ;

update mzdyit set cCpPPv = Substring( cRoObCpPPv, 7, 8)  where nrok=2014 and ndruhmzdy=500  ;

