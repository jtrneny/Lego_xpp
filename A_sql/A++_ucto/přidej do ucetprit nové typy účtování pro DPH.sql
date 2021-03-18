INSERT INTO UCETPRIT (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,cUniqIdRec,mUserZmenR) SELECT 
CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,'FP_DPH_EU',cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
cNazPol3,cNazPol4,cNazPol5,cNazPol6,'(VYKDPH_Iw->lPREDANPOV .and. VYKDPH_Iw->nPREDANPOV > 0)',mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,cUniqIdRec,mUserZmenR FROM ucetprit where left(ctypuct,6)='FP_DPH'  
 