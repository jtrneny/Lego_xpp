insert into mzdyit (ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	      nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nZdrPojis,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
	      nDnyVylDOD,nDnyDovol,cZkrTypZAV,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav)                                  
       select     ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,CAST( Substring( cRoObCpPPv,3,9 ) + Right(cRoObCpPPv,1) as SQL_NUMERIC),
					nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	      nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nZdrPojis,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
	      nDnyVylDOD,nDnyDovol,cZkrTypZAV,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,substring(cRoCpPPv,5,8),0,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav
       from mzddavit_
