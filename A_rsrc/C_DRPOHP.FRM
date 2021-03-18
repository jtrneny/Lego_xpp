TYPE(drgForm) DTYPE(2) TITLE(Èíselník plemenáøských druhù pohybu) SIZE(60,15) FILE(C_DRPOHP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_DRPOHP) FIELDS( nDrPohybP, cNazevPoh);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)  NAME( nDrPohybP) FPOS(18,1) FLEN( 7) FCAPTION(Pohyb)              CPOS(1,1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET)  NAME( CNAZEVPOH) FPOS(18,2) FLEN(32) FCAPTION(Název druhu pohybu) CPOS(1,2)       POST( postLastField_2)
  TYPE(End)
TYPE(End)