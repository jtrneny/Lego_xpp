TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù odpoèitatelných položek - výbìr) SIZE(90,15) FILE(C_ODPOC);
              OBDOBI(MZD) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_ODPOC) FIELDS(nPorOdpPol,cTypOdpPol,cNazOdpPol,dPlatnOd,dPlatnDo,nDanUlObd,nDanUlRok,nOdpocObd,nOdpocRok  ;
                                   ,nRok,nObdobi,cObdobi,lAktMesOdp,nDruhMzdy,nrok);
                            CURSORMODE(3) PP(7) POPUPMENU(y)
TYPE(End)

