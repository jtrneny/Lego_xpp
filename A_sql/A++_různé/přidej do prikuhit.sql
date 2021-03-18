INSERT INTO prikuhit                               (cUloha,CTASK,CSUBTASK,cTypDoklad,cTypPohybu,cTypPlatby,nDoklad,nOrdItem,dPorizPri,cTextPol,nCisFak,cVarSym,cZkrTypFak,cZkrTypUhr,nCenZakCel,
           nPriUhrCel,nPriUhrPri,cZkratMenU,nUhrCelFak,cZkratMeny,nCenZahCel,nUhrCelFaZ,cZkratMenZ,nKurZahMen,nMnozPrep,nKonstSymb,cSpecSymb,cPlatTitul,
           nCisFirmy,cNazev,cUlice,cSidlo,cPsc,cZkratStat,cDIC,cUcet,dSplatFak,dPosUhrFak,dUhrBanDne,cIBAN,cBIC,cBANIS,cNCC,cBank_Naz,cBank_Uct,cBank_Uce,
           cUcet_Uct,cBank_Uli,cBank_PSC,cBank_Sid,cBank_Sta,cPoplatUhr,cPoplatUct,cZkratMenP,nPrioriUhr,cPopis1Plt,cPopis2Plt,cPopis3Plt,cPopis4Plt,
           cPopis1Uhr,cPopis2Uhr,cPopis3Uhr,cPopis4Uhr,cPopis1Ban,cPopis2Ban,cPopis3Ban,cZkrOznam1,cOznameni1,cZkrOznam2,cOznameni2,cZkrOznam3,cOznameni3,
           cZkrOznam4,cOznameni4,cJmenoPrev,dDatPrevz,dDatVratil,cZkrProdej,nCisFak_Or,nPriUhr_Or,cDenik,cObdobi,nROK,nOBDOBI,cZkrTypZAV,dVznikZazn,dZmenaZazn,
           mPoznamka)
  SELECT  cUloha,CTASK,CSUBTASK,cTypDoklad,cTypPohybu,cTypPlatby,nDoklad,nOrdItem,dPorizPri,cTextPol,nCisFak,cVarSym,cZkrTypFak,cZkrTypUhr,nCenZakCel,
          nPriUhrCel,nPriUhrPri,cZkratMenU,nUhrCelFak,cZkratMeny,nCenZahCel,nUhrCelFaZ,cZkratMenZ,nKurZahMen,nMnozPrep,nKonstSymb,cSpecSymb,cPlatTitul,
          nCisFirmy,cNazev,cUlice,cSidlo,cPsc,cZkratStat,cDIC,cUcet,dSplatFak,dPosUhrFak,dUhrBanDne,cIBAN,cBIC,cBANIS,cNCC,cBank_Naz,cBank_Uct,cBank_Uce,
          cUcet_Uct,cBank_Uli,cBank_PSC,cBank_Sid,cBank_Sta,cPoplatUhr,cPoplatUct,cZkratMenP,nPrioriUhr,cPopis1Plt,cPopis2Plt,cPopis3Plt,cPopis4Plt,
          cPopis1Uhr,cPopis2Uhr,cPopis3Uhr,cPopis4Uhr,cPopis1Ban,cPopis2Ban,cPopis3Ban,cZkrOznam1,cOznameni1,cZkrOznam2,cOznameni2,cZkrOznam3,cOznameni3,
          cZkrOznam4,cOznameni4,cJmenoPrev,dDatPrevz,dDatVratil,cZkrProdej,nCisFak_Or,nPriUhr_Or,cDenik,cObdobi,nROK,nOBDOBI,cZkrTypZAV,dVznikZazn,dZmenaZazn,
          mPoznamka)
  FROM prikuhit_