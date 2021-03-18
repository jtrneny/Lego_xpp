TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù lékaøských prohlídek) SIZE(63,15) FILE(C_LEKPRO);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_LEKPRO) FIELDS(cZkratka:zkr                    , ;
                                                  cNazev:název lékaøské prohlídky , ;
                                                  nPerioOpak:perOp                , ;
                                                  cZkratJedn:                     , ;
                                                  nDelkaProh:délkaPr              , ;
                                                  cZkratJed2:                       );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkratka)   FPOS(20,1) FLEN(8)  FCAPTION(Zkratka)                   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazev)     FPOS(20,2) FLEN(30) FCAPTION(Název prohlídky)           CPOS(1,2)
  TYPE(GET) NAME(nPerioOpak) FPOS(20,3) FLEN( 5) FCAPTION(Perioda opakování prohl.)  CPOS(1,3)
  TYPE(GET) NAME(cZkratJedn) FPOS(20,4) FLEN( 6) FCAPTION(MJ periody opakování)      CPOS(1,4)

  TYPE(GET) NAME(nDelkaProh) FPOS(20,5) FLEN( 5) FCAPTION(Délka lékProhl)            CPOS(1,5)
  TYPE(GET) NAME(cZkratJed2) FPOS(20,6) FLEN( 6) FCAPTION(MJ délky lékProhl)         CPOS(1,6)
TYPE(End)
