TYPE(drgForm) DTYPE(2) TITLE(Algoritmy rozpouštìní režií) SIZE(80,15) FILE(C_ALGREZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ALGREZ) FIELDS( nAlgRezie, cPopisAlg);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70)  RESIZE(yn) PRE( tabSelect)
  TYPE(GET) NAME(nAlgRezie)   FPOS(15,1) FLEN( 4) FCAPTION(Algoritmus)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisAlg)   FPOS(15,2) FLEN(60) FCAPTION(Popis algoritmu)   CPOS(1,2) POST( postLastField_2)
TYPE(End)

