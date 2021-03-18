TYPE(drgForm) DTYPE(2) TITLE(Typy platebních titulù) SIZE(60,15) FILE(C_PLATIT);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(55,14) FILE(C_PLATIT) FIELDS( cPlatTitul, cPopisPlTi);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70)  RESIZE(yn) PRE( tabSelect)
  TYPE(GET) NAME(cPlatTitul)     FPOS(15,1) FLEN( 4) FCAPTION(Kód )                    CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisPlTi)     FPOS(15,2) FLEN(30) FCAPTION(Název platebního titulu) CPOS(1,2) POST( postLastField_2)
TYPE(End)
