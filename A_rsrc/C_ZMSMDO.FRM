TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù zmìn prac.smluv a dohod) SIZE(60,15) FILE(C_ZMSMDO);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ZMSMDO) FIELDS(cTypZmSmDo,cPopisZmen:Popis typu zmìny:39) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypZmSmDo)   FPOS(15,1) FLEN(8)  FCAPTION(Zkrataka typu)   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisZmen) FPOS(15,2) FLEN(30) FCAPTION(Popis typu zmìny)  CPOS(1,2)
TYPE(End)
