TYPE(drgForm) DTYPE(2) TITLE(Èíselník støedisek) SIZE(75,15) FILE(CNAZPOL1) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(CNAZPOL1) FIELDS(CNAZPOL1,CNAZEV);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CNAZPOL1)   FPOS(15, 1) FLEN( 8) FCAPTION(Støedisko)       CPOS( 1, 1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV)     FPOS(15, 2) FLEN(25) FCAPTION(Název støediska) CPOS( 1, 2)
TYPE(End)

