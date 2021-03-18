TYPE(drgForm) DTYPE(2) TITLE(Èíselník daòové aktivace) SIZE(60,15) FILE(C_AKTIVD);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_AKTIVD) FIELDS( NZNAKAKTD,cPopisAKT);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(NZNAKAKTD)   FPOS(15,1) FLEN( 4) FCAPTION(Znak aktivace)          CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisAkt)   FPOS(15,2) FLEN(30) FCAPTION(Popis znaku aktivace)   CPOS(1,2) POST( postLastField_2)

TYPE(End)