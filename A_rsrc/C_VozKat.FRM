TYPE(drgForm) DTYPE(2) TITLE(Èíselník kategorií vozidel) SIZE(60,15) FILE(C_VOZKAT);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_VOZKAT) FIELDS(cVozKateg,cNazVozKat) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cVozKateg)   FPOS(15,1) FLEN( 10) FCAPTION(Kategorie vozidla)  CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazVozKat)  FPOS(15,2) FLEN( 20) FCAPTION(Název kategorie)    CPOS(1,2) POST( postLastField_2)
TYPE(End)

