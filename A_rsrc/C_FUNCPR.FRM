TYPE(drgForm) DTYPE(2) TITLE(Èíselník funkcí pracovníkù) SIZE(60,15) FILE(C_FUNCPR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_FUNCPR) FIELDS(cFunPra,cNazFuncPr:název funkce:46);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cFunPra)    FPOS(15,1)  FLEN(8)  FCAPTION(Zkratka)      CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazFuncPr) FPOS(15,2) FLEN(30) FCAPTION(Název funkce)  CPOS(1,2)
TYPE(End)
