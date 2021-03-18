TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù ukonèení vzdìlání) SIZE(60,15) FILE(C_VZDEUK);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_VZDEUK) FIELDS(cZkrUkoVzd,cNazUkoVzd::45) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrUkoVzd)  FPOS(15,1) FLEN( 8) FCAPTION(Zkratka)                        CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazUkoVzd)  FPOS(15,2) FLEN(30) FCAPTION(Název typu ukonèení vzdìlání)   CPOS(1,2)
TYPE(End)
