TYPE(drgForm) DTYPE(2) TITLE(Èíselník názvù øádkù výkazù) SIZE(60,15) FILE(C_VYKRAD);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_VYKRAD) FIELDS(nRadekVyk,cNazRaVyk1,cNazRaVyk2,cNazRaVyk3,cNazRaVyk4,cNazRaVyk5) ;
                            CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nRadekVyk)   FPOS(15,1) FLEN(3)  FCAPTION(Øádek výkazu)         CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazRaVyk1)  FPOS(15,2) FLEN(25) FCAPTION(Název øádku výkazu_1) CPOS(1,2)
  TYPE(GET) NAME(cNazRaVyk2)  FPOS(15,3) FLEN(25) FCAPTION(Název øádku výkazu_2) CPOS(1,3)
  TYPE(GET) NAME(cNazRaVyk3)  FPOS(15,4) FLEN(25) FCAPTION(Název øádku výkazu_3) CPOS(1,4)
  TYPE(GET) NAME(cNazRaVyk4)  FPOS(15,5) FLEN(25) FCAPTION(Název øádku výkazu_4) CPOS(1,5)
  TYPE(GET) NAME(cNazRaVyk5)  FPOS(15,6) FLEN(25) FCAPTION(Název øádku výkazu_5) CPOS(1,6)
TYPE(End)