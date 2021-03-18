INSERT INTO c_odpoc (nPorOdpPol,cTypOdpPol,cNazOdpPol,dPlatnOd,dPlatnDo,nOdpocObd,nOdpocRok,nDanUlObd,nDanUlRok,nRok,
                      nObdobi,cObdobi,lAktMesOdp,lOdpocet,lDanUleva,nDruhMzdy,nDruhMzdy2,nDruhMzdy3,nDruhMzdy4,nDruhMzdy5,
                       nPoradi,nVAZOSOBY,nDistrib,dVznikZazn,mPoznamka)  
             SELECT nPorOdpPol,cTypOdpPol,cNazOdpPol,dPlatnOd,dPlatnDo,nOdpocObd,nOdpocRok,nDanUlObd,nDanUlRok,nRok,
                      nObdobi,cObdobi,lAktMesOdp,lOdpocet,lDanUleva,nDruhMzdy,nDruhMzdy2,nDruhMzdy3,nDruhMzdy4,nDruhMzdy5,
                       nPoradi,nVAZOSOBY,nDistrib,dVznikZazn,mPoznamka
               FROM c_odpoc_