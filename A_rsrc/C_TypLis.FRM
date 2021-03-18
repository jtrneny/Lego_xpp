TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù mzdových lístkù) SIZE(60,15) FILE(C_TYPLIS);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPLIS) FIELDS(cTypListku,cPopisTypu,cKodListku);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypListku)  FPOS(15,1) FLEN( 3) FCAPTION(Typ mzd. lístku) CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisTypu)  FPOS(15,2) FLEN(20) FCAPTION(Název typu)      CPOS(1,2)
  TYPE(GET) NAME(cKodListku)  FPOS(15,3) FLEN( 2) FCAPTION(Kód typu lístku) CPOS(1,3) POST( postLastField_2)
TYPE(End)

