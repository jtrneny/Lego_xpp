INSERT INTO c_typdok (CTASK,CPODULOHA,cTypDoklad,cNazTypDok,CULOHA,mPOPITYPDO,DPLATNYOD,DPLATNYDO,
                          nDistrib,dVznikZazn,dZmenaZazn,mPOZNAMKA,cUniqIdRec,mUserZmenR)
         SELECT CTASK,CPODULOHA,cTypDoklad,cNazTypDok,CULOHA,mPOPITYPDO,DPLATNYOD,DPLATNYDO,nDistrib,dVznikZazn,dZmenaZazn,mPOZNAMKA,cUniqIdRec,mUserZmenR
             FROM c_typdok_