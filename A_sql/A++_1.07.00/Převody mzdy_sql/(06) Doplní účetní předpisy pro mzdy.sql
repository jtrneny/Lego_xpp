update ucetpre  set ucetpre.mpoduct = Replace(ucetpre.mpoduct,'nUcetMzdy','nUcetXXXX') where ucetpre.culoha = 'M'   ;

delete from ucetprhd where left(ctyppohybu,1)='1' or
                            left(ctyppohybu,1)='2' or 
  			     left(ctyppohybu,1)='3' or 
			      left(ctyppohybu,1)='4' or 
		               left(ctyppohybu,1)='5' or 
			        left(ctyppohybu,1)='6' or 
				 left(ctyppohybu,1)='7' or 
				  left(ctyppohybu,1)='8' or
				   left(ctyppohybu,1)='9'        ;

delete from ucetprit where culoha = 'M'    ;

insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZDA',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='10'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZSZA',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='12'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZCFG',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='14'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZUCP',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='16'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZVYR',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='18'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZZEM',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='20'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Hrubá mzda - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
                      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_HRMZZEO',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='22'    ;



insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOJOR',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='50'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOOZE',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='54'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOOCA',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='58'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOOPL',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='62'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOOSL',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='64'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod soc.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),3,0,
      		      'MZ_SOPOOST',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='66'    ;



insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod zdr.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
 		      convert('01.01.2012',SQL_DATE),4,0,
      		      'MZ_ZDPOJOR',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='52'      ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod zdr.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
 		      convert('01.01.2012',SQL_DATE),4,0,
      		      'MZ_ZDPOOZE',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='56'      ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Odvod zdr.poj.org.- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
 		      convert('01.01.2012',SQL_DATE),4,0,
      		      'MZ_ZDPOOCA',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='60'      ;


  
insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
    		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
  		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_GENCM','MZDYITw','GENMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'Generovany dmz z CM- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),1,0,
      		      'MZ_SRAZGEN',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzdyitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='30'     ;
	     

insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'VNU zem.1-pracovník- DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),5,0,
      		      'MZ_VNUZEMP',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='70'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'VNU zem. 1 - stroj - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),5,0,
      		      'MZ_VNUZEMS',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='72'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'VNU zem. 2 - pracovník - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),5,0,
      		      'MZ_VNU2ZEP',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='74'    ;


insert into ucetprit (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,
 		      dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,
		      cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6, mPodminka)
  select              'MZD','M','MZD_PRIJEM','MZDDAVITw','HRUBMZDA',
 	   	      LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),10),
	  	      'VNU zem. 2 - stroj - DMZ ' + LEFT( convert(ucetpre.ndrpohyb,SQL_CHAR),5),
		      convert('01.01.2012',SQL_DATE),5,0,
      		      'MZ_VNU2ZES',ucetpre.cucetmd,ucetpre.cucetdal,
		      '','','','','','',Replace(ucetpre.mpoduct,'Mzdy','mzddavitw')    
  from ucetpre  where ucetpre.culoha = 'M' and ucetpre.ctypuctmd='76'      ;

update ucetprit set npoluctpr=2 where culoha = 'M' and (Upper(Replace(mpodminka,' ','')) = 'MZDYITW->NCLENSPOL=1' or
                                                  Upper(Replace(mpodminka,' ','')) = 'MZDDAVITW->NCLENSPOL=1')     ;

update ucetprit  set ucetprit.mpodminka = Replace(ucetprit.mpodminka,'nUcetXXXX','nUcetMzdy') where ucetprit.culoha = 'M'
