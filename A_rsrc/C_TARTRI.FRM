TYPE(drgForm) DTYPE(2) TITLE(Èíselník tarifních stupnic) SIZE(60,15) FILE(C_TARTRI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TARTRI) FIELDS(cTarifTrid,cNazTarTri) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTarifTrid)  FPOS(15,1) FLEN(3)  FCAPTION(Kód tarifní tøídy) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTarTri) FPOS(15,2) FLEN(25) FCAPTION(Název tarifní tøídy) CPOS(1,2)
TYPE(End)
