TYPE(drgForm) DTYPE(2) TITLE(Èíselník rozlišovacích atributù ) SIZE(60,15) FILE(C_ROATPR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ROATPR) FIELDS(CROZATRPRO,CNAZROZATE) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CROZATRPRO)      FPOS(15,1) FLEN(10)   FCAPTION(Rozlišovací atribut)             CPOS(1,1)
  TYPE(GET) NAME(CNAZROZATE)      FPOS(15,2) FLEN(30)   FCAPTION(Název rozl.atributu)             CPOS(1,2)
TYPE(End)

