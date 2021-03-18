TYPE(drgForm) DTYPE(2) TITLE(Èíselník typy daní) SIZE(60,15) FILE(C_TypDan);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TypDan) FIELDS(nTypDane,cNazTypDan,cVyuzUlohD,nProcDan,dDatPlatOd,cPopisDan) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nTypDane)    FPOS(15,1) FLEN(4)  FCAPTION(Typ danì)   CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTypDan)  FPOS(15,2) FLEN(30) FCAPTION(Název typu danì)        CPOS(1,2)
  TYPE(GET) NAME(cVyuzUlohD)  FPOS(15,3) FLEN(2)  FCAPTION(Úlohy využívající daò)  CPOS(1,3)
  TYPE(GET) NAME(nProcDan)    FPOS(15,4) FLEN(2)  FCAPTION(Procento danì)          CPOS(1,4)
  TYPE(GET) NAME(dDatPlatOd)  FPOS(15,5) FLEN(2)  FCAPTION(Datum platnosti OD)     CPOS(1,5)
  TYPE(GET) NAME(cPopisDan)   FPOS(15,6) FLEN(2)  FCAPTION(Popis pøíslušné danì)   CPOS(1,6)
TYPE(End)
