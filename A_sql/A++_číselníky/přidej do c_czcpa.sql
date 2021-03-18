INSERT INTO c_czcpa (cPolOdpSk,cTypCZCPA,cNazCZCPA,cIdZatr,cTypSKp,nOdpiSkD,CODPISKD,nOdpiSk,CODPISK,mMETODIKA,nDistrib,dVznikZazn,dZmenaZazn )
        SELECT cPolOdpSk,cTypCZCPA,cNazCZCPA,cIdZatr,cTypSKp,nOdpiSkD,CODPISKD,nOdpiSk,CODPISK,mMETODIKA,nDistrib,dVznikZazn,dZmenaZazn
          FROM c_czcpa_