TYPE(drgForm) DTYPE(2) TITLE(Èíselník obcí) SIZE(75,15) FILE(C_OBCE) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,19) FILE(C_OBCE) FIELDS(CZKRATSTAT,cKodOBCE,cNazOBCE,cTypOBCE,cKodOBCEOU,cNazOBCEOU,cKodOBCERP,cNazOBCERP,cCZ_NUTSok,cNAZ_okres,cCZ_NUTSkr,cNAZ_kraje,cCZ_NUTSob,cNAZ_oblas) ;
               CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)

  TYPE(GET) NAME(cZkratStat) FPOS(24, 1) FLEN( 6) FCAPTION(Zkratka státu)           CPOS(1, 1)
  TYPE(TEXT) NAME(C_STATY->cNazevStat) CPOS(32, 1) CLEN(30)                                     
  TYPE(GET) NAME(cKodOBCE)   FPOS(24, 2) FLEN( 6) FCAPTION(Kód obce)                CPOS(1, 2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazOBCE)   FPOS(24, 3) FLEN(48) FCAPTION(Název obce)              CPOS(1, 3)
  TYPE(COMBOBOX) NAME(cTypOBCE) FPOS(24,4) FLEN(49) FCAPTION(Typ obce)              CPOS(1, 4)    ; 
                 VALUES(H: H - hlavní mìsto,;
                        M: M - mìsto,;
                        O: O - obec,;
                        S: S - statutární mìsto,;
                        T: T - mìstys,;
                        U: U - vojenský újezd)
  TYPE(GET) NAME(cKodOBCEOU) FPOS(24, 6) FLEN( 5) FCAPTION(Kód-název obce s pov. OÚ)      CPOS(1, 6)
  TYPE(GET) NAME(cNazOBCEOU) FPOS(32, 6) FLEN(40) 
  TYPE(GET) NAME(cKodOBCERP) FPOS(24, 7) FLEN( 5) FCAPTION(Kód-název obce s rozš.pùsob)   CPOS(1, 7)
  TYPE(GET) NAME(cNazOBCERP) FPOS(32, 7) FLEN(40) 
  TYPE(GET) NAME(cCZ_NUTSok) FPOS(24, 8) FLEN( 5) FCAPTION(CZ_NUTS-název okresu)          CPOS(1, 8)
  TYPE(GET) NAME(cNAZ_okres) FPOS(32, 8) FLEN(40) 
  TYPE(GET) NAME(cCZ_NUTSkr) FPOS(24, 9) FLEN( 5) FCAPTION(CZ_NUTS-název kraje)           CPOS(1, 9)
  TYPE(GET) NAME(cNAZ_kraje) FPOS(32, 9) FLEN(40)
  TYPE(GET) NAME(cCZ_NUTSob) FPOS(24,10) FLEN( 5) FCAPTION(CZ_NUTS-název oblasti)         CPOS(1,10)
  TYPE(GET) NAME(cNAZ_oblas) FPOS(32,10) FLEN(40) 
TYPE(End)

