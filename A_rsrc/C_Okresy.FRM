TYPE(drgForm) DTYPE(2) TITLE(Èíselník okresù) SIZE(75,15) FILE(C_OKRESY) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_OKRESY) FIELDS(cOkres,cCZ_NUTSok,cNAZ_okres,cZKR_okres,cStatKodZa,nKodOkrSoc) ;
               CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cOkres)     FPOS(15, 1) FLEN(10) FCAPTION(Zkrácený název okresu)   CPOS(1, 1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cCZ_NUTSok) FPOS(15, 2) FLEN( 6) FCAPTION(CZ-NUTS okresu)          CPOS(1, 2)
  TYPE(GET) NAME(cNAZ_okres) FPOS(15, 3) FLEN(50) FCAPTION(Název okresu)            CPOS(1, 3)
  TYPE(GET) NAME(cZKR_okres) FPOS(15, 4) FLEN( 2) FCAPTION(Zkratka okresu)          CPOS(1, 4)
  TYPE(GET) NAME(cStatKodZa) FPOS(15, 5) FLEN( 6) FCAPTION(Statistický kód záznamu) CPOS(1, 5)
  TYPE(GET) NAME(nKodOkrSoc) FPOS(15, 6) FLEN( 3) FCAPTION(Kód okresu pro ÈSSZ)     CPOS(1, 6)
TYPE(End)
