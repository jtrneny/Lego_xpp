TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhù oprav) SIZE(60,15) FILE(C_OPRAVY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_OPRAVY) FIELDS(nDruhOprav,cNazevDruh) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nDruhOprav)  FPOS(15,1) FLEN( 3) FCAPTION(Druh opravy)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazevDruh)  FPOS(15,2) FLEN(20) FCAPTION(Název druhu opravy) CPOS(1,2) POST( postLastField_2)
TYPE(End)

