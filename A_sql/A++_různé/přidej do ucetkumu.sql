INSERT INTO ucetkumu (
  cObdobi,nRok,nObdobi,cUcetMD,cUcetTR,cUcetSK,cUcetSY,nKcMDpsO,nKcDALpsO,nKcMDobrO,nKcDALobrO,nKcMDpsR,nKcDALpsR,nKcMDobrR,
  nKcDALobrR,nKcMDksR,nKcDALksR,nMnozNat,nMnozNat2,nMNOZnatR,nMNOZnat2R,cUserAbb,
  dDatZmeny,cCasZmeny,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR)
        SELECT cObdobi,nRok,nObdobi,cUcetMD,cUcetTR,cUcetSK,cUcetSY,nKcMDpsO,nKcDALpsO,nKcMDobrO,nKcDALobrO,nKcMDpsR,nKcDALpsR,nKcMDobrR,
  nKcDALobrR,nKcMDksR,nKcDALksR,nMnozNat,nMnozNat2,nMNOZnatR,nMNOZnat2R,cUserAbb,
  dDatZmeny,cCasZmeny,dVznikZazn,dZmenaZazn,mPOZNAMKA,mUserZmenR
          FROM ucetkumu_