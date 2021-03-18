TYPE(drgForm) DTYPE(2) TITLE(Èíselník zpùsobu ukonèení školení) SIZE(60,15) FILE(C_SKOLUK);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_SKOLUK) FIELDS(cZkratkaUk,cNazev::46);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkratkaUk) FPOS(15,1) FLEN(8)  FCAPTION(Zkratka)                 CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazev)     FPOS(15,2) FLEN(30) FCAPTION(Název zpùsobu ukonèení)  CPOS(1,2)
TYPE(End)
