update UCETPRIT set mpodminka = 'mzddavitw ->nTypPraVzt <> 5 .and. mzddavitw ->nTypPraVzt <> 6 .and. mzddavitw ->nTypPraVzt <> 55' WHERE cTypUct = 'MZ_HRMZZEM' and cTypPohybu = 'HRUBMZDA' and 
                                                                                                                                         cucetskup <> '170' and cucetskup <> '171' and cucetskup <> '172' ;

INSERT INTO UCETPRIT (CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,cUcetMD,cUcetDAL,cNazPol1,cNazPol2,
                        cNazPol3,cNazPol4,cNazPol5,cNazPol6,mPodminka,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR) 
  SELECT CTASK,cUloha,cTypDoklad,cMAINFILE,cTypPohybu,cUcetSkup,cNazUcPred,dPlatnyOd,nPolUctPr,nSubPolUc,cTypUct,'521910',cUcetDAL,cNazPol1,cNazPol2,
          cNazPol3,cNazPol4,cNazPol5,cNazPol6,'mzddavitw ->nTypPraVzt = 5 .or. mzddavitw ->nTypPraVzt = 6 .or. mzddavitw ->nTypPraVzt = 55'
		  ,mKLikvid,mZLikvid,lWrtRecHD,mPopisUcPr,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR 
   FROM ucetprit WHERE cTypUct = 'MZ_HRMZZEM' and cTypPohybu = 'HRUBMZDA' and cucetskup <> '170' and cucetskup <> '171' and cucetskup <> '172'  ;
