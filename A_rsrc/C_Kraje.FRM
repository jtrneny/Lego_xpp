TYPE(drgForm) DTYPE(2) TITLE(Èíselník krajù) SIZE(75,15) FILE(C_KRAJE) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_KRAJE) FIELDS(cKraj,cCZ_NUTSkr,cNAZ_kraje,cZKR_kraje,cStatKodZa) ;
               CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cKraj)      FPOS(15, 1) FLEN(10) FCAPTION(Zkrácený název kraje)    CPOS(1, 1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cCZ_NUTSkr) FPOS(15, 2) FLEN( 6) FCAPTION(CZ-NUTS kraje)           CPOS(1, 2)
  TYPE(GET) NAME(cNAZ_kraje) FPOS(15, 3) FLEN(50) FCAPTION(Název kraje)             CPOS(1, 3)
  TYPE(GET) NAME(cZKR_kraje) FPOS(15, 4) FLEN( 1) FCAPTION(Zkratka kraje)           CPOS(1, 4)
  TYPE(GET) NAME(cStatKodZa) FPOS(15, 5) FLEN( 6) FCAPTION(Statistický kód záznamu) CPOS(1, 5)
TYPE(End)
