TYPE(drgForm) DTYPE(2) TITLE(Èíselník výplatního proužku) SIZE(60,15) FILE(C_NAZRVP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_NAZRVP) FIELDS(nPoradi,cNaz_Vp1,nTyp_Vp1,cRzn_Vp1, cNaz_Vp2,nTyp_Vp2,cRzn_Vp2  ;
                               ,cNaz_Vp3,nTyp_Vp3,cRzn_Vp3,cNaz_Vp4,nTyp_Vp4,cRzn_Vp4           ;
                               ,cRz_Vp);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nPoradi)    FPOS(15,1)   FLEN( 3)  FCAPTION(Poøadí)           CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNaz_Vp1)   FPOS(15,2)   FLEN(17)  FCAPTION(Sloupec 1)        CPOS(1,2)
  TYPE(GET) NAME(nTyp_Vp1)   FPOS(15,3)   FLEN( 2)  FCAPTION(Typ nápoètu 1)    CPOS(1,3)
  TYPE(GET) NAME(cRzn_Vp1)   FPOS(15,4)   FLEN( 4)  FCAPTION(Øídící znak 1)    CPOS(1,4)
  TYPE(GET) NAME(cNaz_Vp2)   FPOS(15,5)   FLEN(17)  FCAPTION(Sloupec 2)        CPOS(1,2)
  TYPE(GET) NAME(nTyp_Vp2)   FPOS(15,6)   FLEN( 2)  FCAPTION(Typ nápoètu 2)    CPOS(1,3)
  TYPE(GET) NAME(cRzn_Vp2)   FPOS(15,7)   FLEN( 4)  FCAPTION(Øídící znak 2)    CPOS(1,4)
  TYPE(GET) NAME(cNaz_Vp3)   FPOS(15,8)   FLEN(17)  FCAPTION(Sloupec 3)        CPOS(1,2)
  TYPE(GET) NAME(nTyp_Vp3)   FPOS(15,9)   FLEN( 2)  FCAPTION(Typ nápoètu 3)    CPOS(1,3)
  TYPE(GET) NAME(cRzn_Vp3)   FPOS(15,10)  FLEN( 4)  FCAPTION(Øídící znak 3)    CPOS(1,4)
  TYPE(GET) NAME(cNaz_Vp4)   FPOS(15,11)  FLEN(17)  FCAPTION(Sloupec 4)        CPOS(1,2)
  TYPE(GET) NAME(nTyp_Vp4)   FPOS(15,12)  FLEN( 2)  FCAPTION(Typ nápoètu 4)    CPOS(1,3)
  TYPE(GET) NAME(cRzn_Vp4)   FPOS(15,13)  FLEN( 4)  FCAPTION(Øídící znak 4)    CPOS(1,4)
  TYPE(GET) NAME(cRz_Vp)     FPOS(15,14)  FLEN( 4)  FCAPTION(Øídící znak 1)    CPOS(1,4)
TYPE(End)