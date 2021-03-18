TYPE(drgForm) DTYPE(2) TITLE(Èíselník tarifních stupnic) SIZE(60,15) FILE(C_TARSTU);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TARSTU) FIELDS(cTarifStup,cNazTarStu) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTarifStup)  FPOS(15,1) FLEN(3)  FCAPTION(Kód tarifní stupnice) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTarStu) FPOS(15,2) FLEN(25) FCAPTION(Název tarifní stupnice) CPOS(1,2)
TYPE(End)
