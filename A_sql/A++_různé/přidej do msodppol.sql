  INSERT IN TO (ctask, cUloha, nRok,cKmenStrPr, nOsCisPrac, cPracovnik, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                 cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                  nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv)
        select  ctask, cUloha, 2014, cKmenStrPr, nOsCisPrac, cPracovnik, cJmenoRozl, nPorPraVzt, nPorOdpPol, cTypOdpPol,
                 cNazOdpPol, dPlatnOd, dPlatnDo, cObdOd, cObdDo, nOdpocObd, nOdpocRok,nDanUlObd, nDanUlRok, cRodCisRP, nCisOsoRP,
                  nRodPrisl, lAktiv, lAktMesOdp, lOdpocet, lDanUleva, cTmKmStrPr, cRoCpPPv
        from msodppol_   