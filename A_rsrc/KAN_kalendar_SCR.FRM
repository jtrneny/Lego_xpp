TYPE(drgForm) DTYPE(10) TITLE( Kalendáø ) SIZE(100,26);
              GUILOOK( Menu:y) 

TYPE(Action) CAPTION(Generuj)  EVENT(NewKalendar) TIPTEXT( Generování nového kalendáøe)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

TYPE(DBrowse) FPOS(0.5,.05) SIZE(99,15) FILE(Kalendar)         ;
                                        FIELDS(dDatum        , ;
                                               nDen          , ;                             
                                               nTyden        , ;                             
                                               nMesic        , ;                             
                                               nRok          , ;                             
                                               nPololeti     , ;                             
                                               nCtvrtleti    , ;                             
                                               cNazDne       , ;                             
                                               cNazMes       , ;                             
                                               cZkrNazDne    , ;                             
                                               cSvatJmeno    , ;                             
                                               cTypDne         ) ;
                                        CURSORMODE(3) INDEXORD(1) SCROLL(yy) PP(7) ITEMMARKED(itemMarked) POPUPMENU(y)


TYPE(TabPage) CAPTION(Úkoly) OFFSET(1,86) FPOS(1,15.50) SIZE(98,10.2) PRE(tabSelect) SUBTABS(A1,A2,A3)
  TYPE(TabPage) CAPTION(Nezahájený) OFFSET(2,86) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96,8.5) PRE(tabSelect) SUB(A1)
    TYPE(DBrowse) FPOS(0.3,0.1) SIZE(95,7.2) FILE(UKOLY)                         ;
                                        FIELDS(nCisUkolu:úkol:7           , ;
                                               coznUkolu:oznÚkolu         , ;  
                                               czkrUkolu:Zkratka úkolu:10 , ;
                                               cNazUkolu:Název úkolu:50   , ;
                                               dzacUkolu:zaèDne           , ;
                                               dkonUkolu:ukonDne            )  ;
                                        CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(ny) PRE(SetFocus)

  TYPE(END)
  TYPE(TabPage) CAPTION(Probíhá) OFFSET(13,75) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96,8.5) PRE(tabSelect) SUB(A2)
    TYPE(DBrowse) FPOS(0.3,0.1) SIZE(95,7.2) FILE(UKOLY)                         ;
                                        FIELDS(nCisUkolu:úkol:7           , ;
                                               coznUkolu:oznÚkolu         , ;  
                                               czkrUkolu:Zkratka úkolu:10 , ;
                                               cNazUkolu:Název úkolu:50   , ;
                                               dzacUkolu:zaèDne           , ;
                                               dkonUkolu:ukonDne            )  ;
                                        CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(ny) PRE(SetFocus)

  TYPE(END)
  TYPE(TabPage) CAPTION(Dokonèený) OFFSET(24,64) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96,8.5) PRE(tabSelect) SUB(A3)
    TYPE(DBrowse) FPOS(0.3,0.1) SIZE(95,7.2) FILE(UKOLY)                         ;
                                        FIELDS(nCisUkolu:úkol:7           , ;
                                               coznUkolu:oznÚkolu         , ;  
                                               czkrUkolu:Zkratka úkolu:10 , ;
                                               cNazUkolu:Název úkolu:50   , ;
                                               dzacUkolu:zaèDne           , ;
                                               dkonUkolu:ukonDne            )  ;
                                        CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(ny) PRE(SetFocus)

  TYPE(END)
TYPE(END)



