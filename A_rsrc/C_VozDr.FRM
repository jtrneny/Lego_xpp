TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhù vozidel) SIZE(60,15) FILE(C_VOZDR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_VOZDR) FIELDS(cVozDruh,cNazVozDr) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cVozDruh)   FPOS(15,1) FLEN( 10) FCAPTION(Druh vozidla)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazVozDr)  FPOS(15,2) FLEN( 20) FCAPTION(Název druhu vozidla) CPOS(1,2) POST( postLastField_2)
TYPE(End)

