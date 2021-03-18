TYPE(drgForm) DTYPE(2) TITLE(Èíselník tarifních stupnic) SIZE(60,15) FILE(C_KPRACI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_KPRACI) FIELDS(nCisPrace,cNazPrace) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nCisPrace)  FPOS(15,1) FLEN(3)  FCAPTION(Èíslo práce) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazPrace) FPOS(15,2) FLEN(25) FCAPTION(Název práce)  CPOS(1,2)
TYPE(End)
