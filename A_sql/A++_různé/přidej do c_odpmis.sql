INSERT INTO c_aktivd (NZNAKAKTD,CPOPISAKT,mMETODIKA,nDistrib,dVznikZazn,dZmenaZazn,mPoznamka,cUniqIdRec,mUserZmenR)
        SELECT NZNAKAKTD,CPOPISAKT,mMETODIKA,nDistrib,dVznikZazn,dZmenaZazn,mPoznamka,cUniqIdRec,mUserZmenR
          FROM c_aktivd_