DELETE from UCETPRHD WHERE cTypDoklad = 'FIN_PODOPR' and cTypPohybu = 'POKLPRIEET' ;  
DELETE from UCETPRIT WHERE cTypDoklad = 'FIN_PODOPR' and cTypPohybu = 'POKLPRIEET' ;  

INSERT INTO UCETPRHD (CTASK,cUloha,cTypDoklad,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,mPodminka,mKLikvid,mZLikvid,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR)
  SELECT CTASK,cUloha,cTypDoklad,'POKLPRIEET',cUcetSkup,'Pøíjem do pokladny s vazbou na EET',dPlatnyOd,mPodminka,mKLikvid,mZLikvid,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR 
   FROM ucetprhd  WHERE cTypDoklad = 'FIN_PODOPR' and cTypPohybu = 'POKLPRIJ' ;

INSERT INTO UCETPRIT (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
                        cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR) 
  SELECT CTASK,cUloha,cTypDoklad,cMAINFILE,'POKLPRIEET',cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
          cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR 
   FROM ucetprit WHERE cTypDoklad = 'FIN_PODOPR' and cTypPohybu = 'POKLPRIJ' ;



DELETE from UCETPRHD WHERE cTypDoklad = 'PRO_REGPO' and cTypPohybu = 'PRODRPEET' ;  
DELETE from UCETPRIT WHERE cTypDoklad = 'PRO_REGPO' and cTypPohybu = 'PRODRPEET' ;  

INSERT INTO UCETPRHD (CTASK,cUloha,cTypDoklad,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,mPodminka,mKLikvid,mZLikvid,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR)
  SELECT CTASK,cUloha,cTypDoklad,'PRODRPEET',cUcetSkup,'Prodej pøes registr. pokladnu s vazbou na EET',dPlatnyOd,mPodminka,mKLikvid,mZLikvid,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR 
   FROM ucetprhd WHERE cTypDoklad = 'PRO_REGPO' and cTypPohybu = 'PRODEJRP' ;

INSERT INTO UCETPRIT (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
                        cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR) 
  SELECT CTASK,cUloha,cTypDoklad,cMAINFILE,'PRODRPEET',cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
          cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR 
   FROM ucetprit WHERE cTypDoklad = 'PRO_REGPO' and cTypPohybu = 'PRODEJRP' ;
