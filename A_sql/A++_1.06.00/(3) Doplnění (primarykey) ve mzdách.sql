update msprc_mo set RoObCpPp = '' ;
update msprc_mo set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update mssrz_mo set RoObCpPp = '' ;
update mssrz_mo set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update msvprum set RoObCpPp = '' ;
update msvprum set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;							  	
//update msprc_md set RoObCpPp = '' ;
//update msprc_md set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
//                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
//								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
						  	
update MZPRKAHD set RoObCpPp = '' ;
update MZPRKAHD set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
								  	
update MZPRKAIT set RoObCpPp = '' ;
update MZPRKAIT set RoObCpPp =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
								  	
