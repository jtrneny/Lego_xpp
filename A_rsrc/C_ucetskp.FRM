TYPE(drgForm) DTYPE(2) TITLE(Èíselník úèetních odpisových skupin) SIZE(60,15) FILE(C_UCETSKP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) FPOS(0,2) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_UCETSKP); 
                            FIELDS( cOdpiSk:Úè.sk. ,;
                                    NODPISK:Úè.sk. ,;
                                    NROKYODPIS,;
                                    NROPRVNI  ,;
                                    NRODALSI  );
                            CURSORMODE(3) PP(7) LFREEZE(1) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) FPOS(0,2) OFFSET(14,70)  PRE( tabSelect)
  TYPE(GET) NAME(cODPISK)      FPOS(20, 1) FLEN( 10) FCAPTION(Úèetní skupina)        CPOS( 4, 1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(NODPISK)      FPOS(20, 2) FLEN( 10) FCAPTION(Úèetní skupina)        CPOS( 4, 2)
  TYPE(GET) NAME(NROKYODPIS)   FPOS(20, 3) FLEN( 10) FCAPTION(Roky odpisu)           CPOS( 4, 3)
  TYPE(GET) NAME(NROprvni)     FPOS(20, 4) FLEN( 10) FCAPTION(Odpis 1.rok)           CPOS( 4, 4)
  TYPE(GET) NAME(NROdalsi)     FPOS(20, 5) FLEN( 10) FCAPTION(Odpis další roky)      CPOS( 4, 5) POST( postLastField_2)
TYPE(End)
