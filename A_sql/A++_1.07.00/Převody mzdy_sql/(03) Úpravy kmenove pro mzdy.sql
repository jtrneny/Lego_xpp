update msprc_mo set nrokobd = nrok*100+nobdobi   ;
update msprc_mo set cRoObCpPPv = '' ;
update msprc_mo set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update msprc_mo set cRoCpPPv   = '' ;
update msprc_mo set cRoCpPPv   =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update msprc_mo set cCpPPv = Substring( cRoObCpPPv, 7, 8)   ;
update msprc_mo set ndokladCM  = CAST( Substring( cRoObCpPPv,3,9 ) + Right(cRoObCpPPv,1) as SQL_NUMERIC)  ;

update mssrz_mo set nrokobd = nrok*100+nobdobi   ;
update mssrz_mo set cRoObCpPPv = '' ;
update mssrz_mo set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update msodppol set cRoCpPPv = '' ;
update msodppol set cRoCpPPv =  Substring(Ltrim(CAST(nrok as SQL_CHAR)),1,4)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
update msprc_md set cCpPPv    = '' ;
update msprc_md set cCpPPv    =   REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
						  	
update MZPRKAHD set cRoObCpPPv = '' ;
update MZPRKAHD set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;
								  	
update MZPRKAIT set cRoObCpPPv = '' ;
update MZPRKAIT set cRoObCpPPv =  Substring(Ltrim(CAST(nrokobd as SQL_CHAR)),1,6)+
                                  REPEAT( '0', 5-LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+Substring(Ltrim(CAST(noscisprac as SQL_CHAR)),1,LENGTH(Ltrim(CAST(noscisprac as SQL_CHAR))))+
								  REPEAT( '0', 3-LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))+Substring(Ltrim(CAST(nporpravzt as SQL_CHAR)),1,LENGTH(Ltrim(CAST(nporpravzt as SQL_CHAR))))  ;

update osoby set cjmenoRozl = rtrim( cprijOsob)+' ' +
                              rtrim(cjmenoOsob)     +
                              IIF( crozlJmena is null, ' ', ' ' +RTRIM(crozlJmena) )   ;         


update osoby set cosoba = IIF( cTitulPred is null or ctitulPred = '', '', RTRIM(cTitulPred) +' ' ) +
                               rtrim( cprijOsob)+' ' +
                               rtrim(cjmenoOsob)     +
                               IIF( cTitulZa is null or ctitulZa = '', '', ',' +RTRIM(cTitulZa) )      ;      


update msprc_mo set msprc_mo.ncisosoby   =osoby.ncisosoby,
                    msprc_mo.cPrijOsob   =osoby.cPrijOsob,
                    msprc_mo.cJmenoOsob  =osoby.cJmenoOsob,     
                    msprc_mo.cosoba      =osoby.cosoba,
                    msprc_mo.ctitulpred  =osoby.ctitulpred,
                    msprc_mo.ctitulza    =osoby.ctitulza,
                    msprc_mo.cPrijPrac   =osoby.cPrijOsob,
                    msprc_mo.cJmenoPrac  =osoby.cJmenoOsob,     
                    msprc_mo.cpracovnik  =osoby.cosoba,
                    msprc_mo.cjmenoRozl  =osoby.cjmenoRozl,
  	            msprc_mo.nosoby      =osoby.sid
       from osoby    
       where msprc_mo.noscisprac=osoby.noscisprac                       ;

update msprc_mo set msprc_mo.ldanprvzt   =TRUE,
                    msprc_mo.ldanrezid   =TRUE
       where msprc_mo.nrok>=2012                        ;

update msprc_mo set msprc_mo.nclenspol   = 1  where msprc_mo.ntypzamvzt = 3                    ;


update msprc_mo set msprc_mo.cTypPraKal   ='ZAKJEDS_8'
       where (msprc_mo.nrok=2012 or msprc_mo.nrok=2013) and ( msprc_mo.cTypPraKal   = ' ' or  msprc_mo.cTypPraKal is null)    ;

update mssrz_mo set mssrz_mo.ncisosoby   =osoby.ncisosoby,
                    mssrz_mo.cjmenoRozl  =osoby.cjmenoRozl,
                    mssrz_mo.nRokObdSta  =(mssrz_mo.nRokObd*10)+mssrz_mo.nStavem, 
  	            mssrz_mo.nosoby      =osoby.sid
       from osoby    
       where mssrz_mo.noscisprac=osoby.noscisprac                       ;

update mssrz_mo set ctyppohzav='GENSRAZKA'  where ctypabo = 'PRUH_H' or ctypabo = 'PRUH_I'    ;


update personal set personal.ncisosoby   =osoby.ncisosoby,
                    personal.cPrijOsob   =osoby.cPrijOsob,
                    personal.cJmenoOsob  =osoby.cJmenoOsob,     
                    personal.cosoba      =osoby.cosoba,
                    personal.ctitulpred  =osoby.ctitulpred,
                    personal.ctitulza    =osoby.ctitulza,
                    personal.cPrijPrac   =osoby.cPrijOsob,
                    personal.cJmenoPrac  =osoby.cJmenoOsob,     
                    personal.cpracovnik  =osoby.cosoba
       from osoby    
       where personal.noscisprac=osoby.noscisprac                       ;

update osoby set osoby.nis_ZAM=1 from msprc_mo where osoby.noscisprac=msprc_mo.noscisprac and osoby.noscisprac <> 0;
update osoby set osoby.nis_PER=1 from personal where osoby.noscisprac=personal.noscisprac and osoby.noscisprac <> 0;

update mstarind  set mstarind.ctask = 'MZD',mstarind.culoha = 'M',mstarind.cjmenoRozl = msprc_mo.cjmenoRozl,mstarind.ncisosoby = msprc_mo.ncisosoby
                 from msprc_mo 
                 where mstarind.noscisprac = msprc_mo.noscisprac and mstarind.nporpravzt = msprc_mo.nporpravzt and msprc_mo.nrokobd=201312 ;
