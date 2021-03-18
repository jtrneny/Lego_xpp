TYPE(drgForm) DTYPE(2) TITLE(Èíselník výplatních mmíst) SIZE(60,15) FILE(C_VYPLMI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84)  PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_VYPLMI) FIELDS(cVyplMist,cNazVyplMi) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cVyplMist)  FPOS(15,1) FLEN(8)  FCAPTION(Kód výplatního místa) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazVyplMi) FPOS(15,2) FLEN(25) FCAPTION(Název výplatního místa) CPOS(1,2)
TYPE(End)
