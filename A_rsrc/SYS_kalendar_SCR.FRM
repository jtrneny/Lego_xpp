TYPE(drgForm) DTYPE(10) TITLE( Kalendáø ) SIZE(100,26) POST(postValidate);
              GUILOOK( Menu:y) 

TYPE(Action) CAPTION(Generuj)  EVENT(NewKalendar) TIPTEXT( Generování nového kalendáøe)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

  TYPE(STATIC) STYPE(2) FPOS(0.2,-.25) SIZE(98.8,2.6) RESIZE(yy)
    TYPE(GET)  NAME(M->crok)      FPOS(24, 1  ) FLEN(10) FCAPTION(Rok pro generování) CPOS(4,1) PP(2) FONT(5) CLEN(19)
  TYPE(End)

  TYPE(DBrowse) FILE(Kalendar)  INDEXORD(1)            ;
               FIELDS(dDatum::15,                      ;
                      nDen,                            ;                             
                      nTyden,                          ;                              
                      nMesic,                          ;                             
                      nRok,                            ;                             
                      nPololeti,                       ;                             
                      nCtvrtleti,                      ;                             
                      cNazDne,                         ;                             
                      cNazMes,                         ;                             
                      cZkrNazDne,                      ;                             
                      cSvatJmeno,                      ;                             
                      cTypDne)                         ;
               FPOS(0,3.0) SIZE(98,22.4) CURSORMODE(3) SCROLL(ny) PP(7);
               ITEMMARKED(itemMarked) POPUPMENU(y)

