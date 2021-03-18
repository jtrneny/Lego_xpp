update msprc_mo set primarykey = '' ;
update msprc_mo set primarykey =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
