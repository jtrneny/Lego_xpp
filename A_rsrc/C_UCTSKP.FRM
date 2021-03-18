TYPE(drgForm) DTYPE(2) TITLE(Èíselník úèetních skladových skupin) SIZE(60,15) FILE(C_UCTSKP);
                       GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_UCTSKP) FIELDS(NUCETSKUP,CNAZUCTSK) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET) NAME(NUCETSKUP) FPOS(17,1) FLEN( 3) FCAPTION(Úèetní skupina)    CPOS(1,1) PP(2);
                              POST( drgPostUniqueKey)
    TYPE(GET) NAME(CNAZUCTSK) FPOS(17,2) FLEN(25) FCAPTION(Název úè. skupiny) CPOS(1,2) POST( postLastField_2)
  TYPE(End)
TYPE(End)