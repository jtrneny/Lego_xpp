TYPE(drgForm) DTYPE(2) TITLE(Èíselník zpùsobù srážení) SIZE(60,15) FILE(C_ZPUSRZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ZPUSRZ) FIELDS(cZpusSraz,cPopisZpSr) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZpusSraz)  FPOS(15,1) FLEN( 8) FCAPTION(Zkratka)                 CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisZpSr) FPOS(15,2) FLEN(40) FCAPTION(Popis zpùsobu srážení)   CPOS(1,2)
TYPE(End)
