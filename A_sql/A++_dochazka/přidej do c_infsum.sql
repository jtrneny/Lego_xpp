DELETE FROM C_INFSUM  ;

INSERT INTO C_INFSUM(cKodSumRad,cNazSumRad,nPORADI,lACTIVe,lSumHod,lSumDny,cKodPrer,mcKODprer,nKodPrer,mnKODprer,
                     nDistrib,dVznikZazn)
       SELECT cKodSumRad,cNazSumRad,nPORADI,lACTIVe,lSumHod,lSumDny,cKodPrer,mcKODprer,nKodPrer,mnKODprer,
                     2,dVznikZazn FROM C_INFSUM_
