update mzdyhd set nDanZaklSP = nzdanmzdap where nDanZaklSP=0   ;
delete from mzdyit where nrok=2013 and (ndruhmzdy=901 or ndruhmzdy=911)  ;

insert into mzdyit (ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
	   	            nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		            nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		            nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav)                                  
       select       mzdyhd.ctask,mzdyhd.cUloha,'MC',mzdyhd.cobdobi,mzdyhd.nRok,mzdyhd.nObdobi,mzdyhd.nRokObd,mzdyhd.CTYPDOKLAD,
                    mzdyhd.CTYPPOHYBU,mzdyhd.ndoklad,0,mzdyhd.cKmenStrPr,
                    mzdyhd.nOsCisPrac,mzdyhd.cPracovnik,mzdyhd.nPorPraVzt,mzdyhd.nTypPraVzt,
                    mzdyhd.cjmenoRozl,mzdyhd.nTypZamVzt,mzdyhd.nClenSpol,mzdyhd.cMzdKatPra,mzdyhd.cPracZar,
                    '',mzdyhd.dZmenaZazn,'901',901,
                    0,0,0,0,mzdyhd.nDanZaklSP,0,0,0,
                    0,0,0,0,0,0,'',0,
                    mzdyhd.nZdrPojis,mzdyhd.nMimoPrVzt,mzdyhd.nTypDuchod,'',0,CAST( '00.00.0000' as SQL_DATE),CAST( '00.00.0000' as SQL_DATE), mzdyhd.nDnyVylocD,
                    0,0,'','',msprc_mo.cVyplMist,0,0,mzdyhd.cTmKmStrPr,0,0,0,0,Substring(mzdyhd.cRoCpPPv,5,8),mzdyhd.sID,mzdyhd.cRoObCpPPv,mzdyhd.cRoCpPPv,'',
                    '','',1,1,'' 
       from mzdyhd
       left outer join msprc_mo on ( mzdyhd.nrok  = msprc_mo.nrok        and                           
                               mzdyhd.nobdobi    = msprc_mo.nobdobi     and 
                               mzdyhd.noscisPrac = msprc_mo.noscisPrac  and 
                               mzdyhd.nporpraVzt = msprc_mo.nporpraVzt     ) 
	  where mzdyhd.nrok=2013 and mzdyhd.nDanZaklSP <> 0 and mzdyhd.nsrazkodan = 0     ;

insert into mzdyit (ctask,cUloha,cDenik,cObdobi,nRok,nObdobi,nRokObd,CTYPDOKLAD,
                    CTYPPOHYBU,nDoklad,nOrdItem,cKmenStrPr,nOsCisPrac,cPracovnik,nPorPraVzt,nTypPraVzt,cjmenoRozl,                                                         
                    nTypZamVzt,nClenSpol,cMzdKatPra,cPracZar,cPracZarDo,dDatPoriz,CUCETSKUP,nDruhMzdy,
                    nDnyDoklad,nHodDoklad,nMnPDoklad,nSazbaDokl,nMzda,nZaklSocPo,nZaklZdrPo, nDnyFondKD,
		            nDnyFondPD,nHodFondKD,nHodFondPD,nHodPresc,nHodPrescS,nHodPripl,cZkratJEDN,nLikCelDOK,
		            nZdrPojis,nMimoPrVzt,nTypDuchod,cVarSym,nPoradi,dDatumOD,dDatumDO,nDnyVylocD,
		            nDnyVylDOD,nDnyDovol,cZkrTypZAV,cPolVyplPa,cVyplMist,nKLikvid,nZLikvid,cTmKmStrPr,
                    nTMPnum1,nTMPnum2,nstavNapHM,ndokladorg,cCpPPv,nmzdyhd,cRoObCpPPv,cRoCpPPv,cpohZavFir,
                    czkratMeny,czkratMenz,nkurZahMen,nmnozPrep,ctypPohZav)                                  
       select       mzdyhd.ctask,mzdyhd.cUloha,'MC',mzdyhd.cobdobi,mzdyhd.nRok,mzdyhd.nObdobi,mzdyhd.nRokObd,mzdyhd.CTYPDOKLAD,
                    mzdyhd.CTYPPOHYBU,mzdyhd.ndoklad,0,mzdyhd.cKmenStrPr,
                    mzdyhd.nOsCisPrac,mzdyhd.cPracovnik,mzdyhd.nPorPraVzt,mzdyhd.nTypPraVzt,
                    mzdyhd.cjmenoRozl,mzdyhd.nTypZamVzt,mzdyhd.nClenSpol,mzdyhd.cMzdKatPra, mzdyhd.cPracZar,
                    '',mzdyhd.dZmenaZazn,'911',911,
                    0,0,0,0,mzdyhd.nDanZaklSP,0,0,0,
                    0,0,0,0,0,0,'',0,
                    mzdyhd.nZdrPojis,mzdyhd.nMimoPrVzt,mzdyhd.nTypDuchod,'',0,CAST( '00.00.0000' as SQL_DATE),CAST( '00.00.0000' as SQL_DATE), mzdyhd.nDnyVylocD,
                    0,0,'','',msprc_mo.cVyplMist,0,0,mzdyhd.cTmKmStrPr,0,0,0,0,Substring(mzdyhd.cRoCpPPv,5,8),mzdyhd.sID,mzdyhd.cRoObCpPPv,mzdyhd.cRoCpPPv,'',
                    '','',1,1,'' 
       from mzdyhd
       left outer join msprc_mo on ( mzdyhd.nrok       = msprc_mo.nrok        and                           
                               mzdyhd.nobdobi    = msprc_mo.nobdobi     and 
                               mzdyhd.noscisPrac = msprc_mo.noscisPrac  and 
                               mzdyhd.nporpraVzt = msprc_mo.nporpraVzt     ) 
 	   where mzdyhd.nrok=2013 and mzdyhd.nDanZaklSP <> 0 and mzdyhd.nsrazkodan <> 0     ; 