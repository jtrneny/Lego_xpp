TYPE(drgForm) DTYPE(2) TITLE(Èíselník organizaèních úsekù ...) SIZE(70,15) FILE(C_ORGUSEK) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ORGUSEK) FIELDS(CORGUSEK,CNAZEV,CNAZPOL1);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cOrgUsek)  FPOS(15,1) FLEN( 3) FCAPTION(Zkratka úseku)    CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV)    FPOS(15,2) FLEN(25) FCAPTION(Název  úseku)     CPOS(1,2)
  TYPE(GET) NAME(CNAZPOL1)  FPOS(15,3) FLEN(25) FCAPTION(Støedisko)        CPOS(1,3)
TYPE(End)

