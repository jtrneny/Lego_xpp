INSERT INTO C_CELSAZ (cDanpZBO,cNazDanp,cKODintr,cNadDanpZB,mNazevZCSP,cZkratJEDN,cTypCla,cTmpKey,
                       dPlatnyOD,dPlatnyDO,nDistrib,dVznikZazn,dZmenaZazn,mPOZNAMKA) 
       SELECT  cDanpZBO,cNazDanp,cKODintr,cNadDanpZB,mNazevZCSP,cZkratJEDN,cTypCla,cTmpKey,
                       dPlatnyOD,dPlatnyDO,nDistrib,dVznikZazn,dZmenaZazn,mPOZNAMKA  
         FROM C_CELSAZ_