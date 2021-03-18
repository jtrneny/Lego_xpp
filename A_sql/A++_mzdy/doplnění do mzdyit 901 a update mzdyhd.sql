insert into mzdyit (ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	   	            nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		            nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		            nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav) 
             select ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	   	            nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		            nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		            nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav                                  
           from Kovar_901	;				  

update mzdyhd set mzdyhd.ndanzaklmz=0,mzdyhd.ndanzaklsp=0 where cobdobi='01/13' or cobdobi='02/13' or cobdobi='03/13'  ;
update mzdyhd set mzdyhd.ndanzaklmz=mzdyit.nmzda,mzdyhd.ndanzaklsp=mzdyit.nmzda
        from mzdyit  
         where (mzdyhd.cobdobi='01/13' or mzdyhd.cobdobi='02/13' or mzdyhd.cobdobi='03/13') and
		    mzdyhd.cobdobi=mzdyit.cobdobi and mzdyhd.noscisprac=mzdyit.noscisprac and
			  mzdyhd.nporpravzt=mzdyit.nporpravzt and mzdyit.ndruhmzdy=901   ;

update mzdyit set mzdyit.ccpppv=mzdyhd.ccpppv,
                  mzdyit.croobcpppv=mzdyhd.croobcpppv,
                  mzdyit.crocpppv=mzdyhd.crocpppv,
                  mzdyit.nmzdyhd=mzdyhd.sid
        from mzdyhd 
         where (mzdyhd.cobdobi='01/13' or mzdyhd.cobdobi='02/13' or mzdyhd.cobdobi='03/13') and
		    mzdyhd.cobdobi=mzdyit.cobdobi and mzdyhd.noscisprac=mzdyit.noscisprac and
	  	    mzdyhd.nporpravzt=mzdyit.nporpravzt and mzdyit.ndruhmzdy=901 

update mzdyit set mzdyit.cjmenoRozl=msprc_mo.cjmenoRozl,
                  mzdyit.cucetskup='901'
        from msprc_mo
         where (mzdyit.cobdobi='01/13' or mzdyit.cobdobi='02/13' or mzdyit.cobdobi='03/13') and
		    msprc_mo.cobdobi=mzdyit.cobdobi and msprc_mo.noscisprac=mzdyit.noscisprac and
			  msprc_mo.nporpravzt=mzdyit.nporpravzt and mzdyit.ndruhmzdy=901 
	     