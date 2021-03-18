TYPE(drgForm) DTYPE(2) TITLE(Èíselník èárových kódù) SIZE(60,15) FILE(C_CARKOD) ;
                       GUILOOK(Action:n)                                        ;
                       CBSAVE(save_c_carKod)  


TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE(tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_CARKOD)                          ;
                            FIELDS(  M->isMain_ean:set:3.6::2     , ;
                                     CZKRCARKOD:typKódu           , ;
                                     CNAZCARKOD:název typu kódu:41) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)      NAME(CZKRCARKOD) FPOS(15, 1) FLEN( 8) FCAPTION(Typ kódu)         CPOS( 1, 1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET)      NAME(CNAZCARKOD) FPOS(15, 2) FLEN(25) FCAPTION(Název typu kódu)  CPOS( 1, 2) 
    TYPE(CHECKBOX) NAME(LISMAIN)    FPOS(15, 3) FLEN(13) FCAPTION(Pøednastavit ...) CPOS( 1, 3) VALUES(F:NE,T:ANO) POST( postLastField_2)
  TYPE(End)
TYPE(End)
