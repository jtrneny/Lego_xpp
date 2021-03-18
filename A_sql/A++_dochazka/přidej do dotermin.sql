INSERT INTO DOTERMIN( cIdOsKarty,cTypPrer,cRok,nRok,cMesic,nMesic,cDen,nDen,cCas,cKodPrer,cDenVTydnu,cAdrTerm,cSNTerm,dDatum,tPohyb,nStavAkt,cInOut,bBlock,ctable,id,ctableid,
                     dVznikZazn,dZmenaZazn,mPoznamka,mUserZmenR)
       SELECT cIdOsKarty,cTypPrer,cRok,nRok,cMesic,nMesic,cDen,nDen,cCas,cKodPrer,cDenVTydnu,cAdrTerm,cSNTerm,dDatum,tPohyb,nStavAkt,cInOut,bBlock,ctable,id,ctableid,
                     dVznikZazn,dZmenaZazn,mPoznamka,mUserZmenR FROM DOTERMIN_
