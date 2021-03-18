TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù majetku) SIZE(60,15) FILE(C_TYPMAJ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPMAJ)                           ;  
                            FIELDS(M->isEv_pozemky:poz:3.6::2      , ;
                                   NTYPMAJ:typMaj                  , ;
                                   CNAZTYPU: název typu majetku:44)  ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(NTYPMAJ)  FPOS(15,1) FLEN( 3) FCAPTION(Typ majetku)     CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(CNAZTYPU) FPOS(15,2) FLEN(25) FCAPTION(Popis typu)      CPOS(1,2) 
  TYPE(CHECKBOX) NAME(LPOZEMKY) FPOS(15,3) FLEN(13) FCAPTION(Evidece pozemkù) CPOS(1,3) VALUES(F:NE,T:ANO) POST( postLastField_2)
TYPE(End)

