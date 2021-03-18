TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù recyklaèních poplatkù) SIZE(103,15.5) FILE(C_RECPOP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(103,14.5) FILE(C_RECPOP)            ;
                FIELDS(cRecPopl:recPopl                , ;
                       cNazRecPop:název rec_Poplatku:50, ;
                       czkratJedn:mj:3                 , ; 
                       nrecPopl:hodnota:8              , ;
                       czkratMeny:mìna:3               , ;    
                       DPLATNYOD:platný_Od:10          , ;
                       DPLATNYDO:platný_Do:10) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cRecPopl)   FPOS(17,1) FLEN(10)    FCAPTION(typ rec_poplatku)      CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazRecPop) FPOS(17,2) FLEN(80)    FCAPTION(název rec_poplatku)    CPOS(1,2)

  TYPE(TEXT) CAPTION(rec_poplatek - mj)    CPOS( 1,4) CLEN(16) 
    TYPE(GET)  NAME(czkratJedn) FPOS(17,4)            FLEN(5) 
    TYPE(TEXT) CAPTION(hodnota)            CPOS(27,4) CLEN(8)  
    TYPE(GET)  NAME(nrecPopl)   FPOS(37,4)            FLEN(11)
    TYPE(GET)  NAME(czkratMeny) FPOS(51,4)            FLEN(6)

  TYPE(GET) NAME(DPLATNYOD)    FPOS(17,5) FLEN(11)    FCAPTION(Platnost OD)           CPOS(1,5) PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(_ do _) CPOS(30,5) CLEN(7)
    TYPE(GET) NAME(DPLATNYDO)  FPOS(37,5) FLEN(11)    PUSH(CLICKDATE)

¨ TYPE(MLE) NAME(MPOZNAMKA)  FPOS(17,7) SIZE(80,5)  FCAPTION(Poznámka)              CPOS(1,7)
TYPE(End)