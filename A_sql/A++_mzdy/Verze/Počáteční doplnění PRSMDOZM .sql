delete from prsmdozm where nPorZmeny = 1 ;
insert into prsmdozm(cCisloSmDo,nPorZmeny,dDatZmeny,cTypZmSmDo,cPopisZmen,nCisOsoby,nRok,nOsCisPrac,cPracovnik,cOsoba,cJmenoRozl,cRodCisPra,cDruPraVzt,nPorPraVzt,
                       nTypPraVzt,cVznPraVzt,nTypZamVzt,dDatVznPrV,dDatNast,dDatVyst,dDatPredVy,nTypUkoPrV,cPracZar,cFunPra,cKmenStrPr,cOrgUsek,nPRSMLDOH,nOSOBY)
           select cCisloSmDo,1,dDatNast,'NASTUP','Nástup do zaměstnání',nCisOsoby,nRok,nOsCisPrac,cPracovnik,cOsoba,cJmenoRozl,cRodCisPra,cDruPraVzt,nPorPraVzt,
                       nTypPraVzt,cVznPraVzt,nTypZamVzt,dDatVznPrV,dDatNast,dDatVyst,dDatPredVy,nTypUkoPrV,cPracZar,cFunPra,cKmenStrPr,cOrgUsek,sID,nOSOBY 
           from prsmldoh
