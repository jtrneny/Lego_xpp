TYPE(drgForm) DTYPE(2) TITLE(��seln�k typ� akcion���...) SIZE(90,15) FILE(C_TYPAR) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_TYPAR)                          ;
                            FIELDS( cZkrTypAr:zkrTypu            , ;
                                    cNazevAr:n�zev typuAkcion��e , ; 
                                    lucastNaVH:��astNaVH         , ;  
                                    dplatnyOd:platn�Od           , ;
                                    dplatnyDo:platn�Do             ) ;
                                    CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrTypAr)        FPOS(20, 2) FLEN(12) FCAPTION(Zkratka typu akcion��e) CPOS(1, 2) CLEN(18)
  TYPE(GET) NAME(cNazevAr)         FPOS(20, 3) FLEN(12) FCAPTION(N�zev typu akcion��e  ) CPOS(1, 3)
  TYPE(CHECKBOX) NAME(lucastNaVH)  FPOS(20, 4) FLEN( 7) FCAPTION(��astn�k valn� hromady) CPOS(1, 4) VALUES(F:NE,T:ANO) CLEN(18)
  TYPE(GET) NAME(dplatnyOd)        FPOS(20, 5) FLEN(12) FCAPTION(Datum platnosti_OD    ) CPOS(1, 5)   
  TYPE(GET) NAME(dplatnyDo)        FPOS(20, 6) FLEN(12) FCAPTION(Datum platnosti_DO    ) CPOS(1, 6)   
TYPE(End)
