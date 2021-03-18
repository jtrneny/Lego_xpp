TYPE(drgForm) DTYPE(2) TITLE(Èíselník výrobních míst) SIZE(60,15) FILE(CNAZPOL4) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(CNAZPOL4) FIELDS(CNAZPOL4,CNAZEV, cKodPozZN);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CNAZPOL4)  FPOS(15,1) FLEN(8)  FCAPTION(Výr. místo)            CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV)    FPOS(15,2) FLEN(25) FCAPTION(Název místa)           CPOS(1,2)
  TYPE(GET) NAME(cKodPozZN) FPOS(15,3) FLEN(8)  FCAPTION(Kód pozemku zel.nafta) CPOS(1,3)
TYPE(End)

