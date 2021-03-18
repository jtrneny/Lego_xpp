TYPE(drgForm) DTYPE(2) TITLE(Èíselník stavù dokladù) SIZE(60,15) FILE(C_STADOK);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_STADOK) FIELDS(NSTAVDOKL,CNAZSTADOK) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(NSTAVDOKL)      FPOS(15,1) FLEN(10)  FCAPTION(Kód stavu dokladù)             CPOS(1,1)
  TYPE(GET) NAME(CNAZSTADOK)     FPOS(15,2) FLEN(30)  FCAPTION(Název stavu dokladù)           CPOS(1,2)
TYPE(End)

