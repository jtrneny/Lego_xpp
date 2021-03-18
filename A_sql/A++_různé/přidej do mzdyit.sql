insert into mzdyit (ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	   	    nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		    nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		    nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav)                                  
       select       ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	   	    nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		    nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		    nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,0,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav
       from mzdyit_
