TYPE(drgForm) DTYPE(2) TITLE(Èíselník tarifních stupnic) SIZE(60,15) FILE(C_TARIFY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TARIFY) FIELDS(cTarifStup,cTarifTrid,cDelkPrDob,dPlatTarOd,nTarSazHod,nTarSazMes,nHodSazFir  ;
                               ,nMesSazFir, lAktTarif) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTarifStup)  FPOS(15,1) FLEN(8)  FCAPTION(Tarifní stupnice)    CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cTarifTrid) FPOS(15,2) FLEN(8)   FCAPTION(Tarifní tøída)       CPOS(1,2)
  TYPE(GET) NAME(cDelkPrDob) FPOS(15,3) FLEN(15)  FCAPTION(Pracovní doba)       CPOS(1,3)
  TYPE(GET) NAME(dPlatTarOd) FPOS(15,4) FLEN(10)  FCAPTION(Platnost OD)         CPOS(1,4)
  TYPE(GET) NAME(nTarSazHod) FPOS(15,5) FLEN(10)  FCAPTION(Hodinová sazba)      CPOS(1,5)
  TYPE(GET) NAME(nTarSazMes) FPOS(15,6) FLEN(10)  FCAPTION(Mìsíèní sazba)       CPOS(1,6)
  TYPE(GET) NAME(nHodSazFir) FPOS(15,7) FLEN(10)  FCAPTION(Hod.saz.min.fir.)    CPOS(1,7)
  TYPE(GET) NAME(lAktTarif)  FPOS(15,8) FLEN(3)   FCAPTION(Aktuální tarif)      CPOS(1,8)

TYPE(End)
