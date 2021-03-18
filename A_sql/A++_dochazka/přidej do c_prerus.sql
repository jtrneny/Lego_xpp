INSERT INTO C_PRERUS( ctask,cKodPrer,nKodPrer,cNazPrer,nNapPrer,nMaskInp,nMaskOut,nSayScr,nSayCrd,nSayPrn,
                      lInfSum,cTypPrer,lIsEdit,lIsPovol,nCsPovol,nKodZaokr,nSUMfond,nSUMvyr,lPrestavka,nPritPrac,
                      nDruhMzdy,cInOut,nDistrib,dVznikZazn,dZmenaZazn,mPoznamka)
       SELECT ctask,cKodPrer,nKodPrer,cNazPrer,nNapPrer,nMaskInp,nMaskOut,nSayScr,nSayCrd,nSayPrn,
                      lInfSum,cTypPrer,lIsEdit,lIsPovol,nCsPovol,nKodZaokr,nSUMfond,nSUMvyr,lPrestavka,nPritPrac,
                      nDruhMzdy,cInOut,nDistrib,dVznikZazn,dZmenaZazn,mPoznamka FROM C_PRERUS_
