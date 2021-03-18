TYPE(drgForm) DTYPE(2) TITLE(Èíselník lékaøù) SIZE(80,15) FILE(C_LEKARI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_LEKARI) FIELDS(nCisOsoby:             , ;
                                                  cZkratLeka:zkr         , ;
                                                  cNazevLeka:název       , ;
                                                  cOdbornLek:specializace, ;
                                                  cUlice,cMisto,cPsc,cZkratStat,nCisFirmy);
                            CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(16,67) PRE( tabSelect)
  TYPE(GET) NAME(cZkratLeka)  FPOS(15,1)  FLEN( 8) FCAPTION(Zkratka)                 CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(nCisOsoby)   FPOS(15,2)  FLEN( 8) FCAPTION(Èíslo osoby)             CPOS(1,2)
    TYPE(TEXT) NAME(osoby->cosoba) CPOS(25,2)

  TYPE(GET) NAME(cNazevLeka)  FPOS(15,3)  FLEN(30) FCAPTION(Název lékaøe)            CPOS(1,3)
  TYPE(GET) NAME(cOdbornLek)  FPOS(15,4)  FLEN(30) FCAPTION(Odbornost lékaøe)        CPOS(1,4)
  TYPE(GET) NAME(cUlice)      FPOS(15,5)  FLEN(30) FCAPTION(Ulice)                   CPOS(1,5)
  TYPE(GET) NAME(cMisto)      FPOS(15,6)  FLEN(30) FCAPTION(Místo)                   CPOS(1,6)
  TYPE(GET) NAME(cPsc)        FPOS(15,7)  FLEN( 8) FCAPTION(Psè)                     CPOS(1,7)
    TYPE(TEXT) NAME(c_psc->cmisto) CPOS(25,7)

  TYPE(GET) NAME(cZkratStat)  FPOS(15,8)  FLEN( 6) FCAPTION(Zkratka státu)           CPOS(1,8)
  TYPE(GET) NAME(nCisFirmy)   FPOS(15,9)  FLEN( 8) FCAPTION(Èíslo firmy)             CPOS(1,9) 
    TYPE(TEXT) NAME(firmy->cnazev) CPOS(25,9) 
TYPE(End)
