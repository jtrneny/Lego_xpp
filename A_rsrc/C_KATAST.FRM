TYPE(drgForm) DTYPE(2) TITLE(Èíselník katastrù pozemkù) SIZE(60,15) FILE(C_KATAST);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_KATAST) FIELDS(cku_Kod,cku_Nazev::45) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cku_Kod)      FPOS(18,1) FLEN(10) FCAPTION(kód katastr_Území)    CPOS(1,1)
  TYPE(GET) NAME(cku_Nazev)    FPOS(18,2) FLEN(30) FCAPTION(název katastr_Území)  CPOS(1,2)
TYPE(End)

