TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù akcií...) SIZE(90,15) FILE(C_TYPAKC) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_TYPAKC)                         ;
                            FIELDS( cZkrTypAkc:zkrTypu           , ;
                                    cNazevAkc:název typuAkcie    , ;  
                                    nZusobNapo:zpusNáp           , ;
                                    lzapocDOvh:zapdoVýphl        , ;    
                                    dplatnyOd:platnýOd           , ;
                                    dplatnyDo:platnýDo             ) ;
                                    CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cZkrTypAkc)  FPOS(18, 2) FLEN(12) FCAPTION(Zkratka typu akcie   )        CPOS(1, 2)
  TYPE(GET)      NAME(cNazevAkc)   FPOS(18, 3) FLEN(50) FCAPTION(Název typu akcie     )        CPOS(1, 3)
  TYPE(GET)      NAME(nzusobNapo)  FPOS(18, 4) FLEN( 2) FCAPTION(Zpùsob nápoètu akcie )        CPOS(1, 4)
  TYPE(CHECKBOX) NAME(lzapocDOvh)  FPOS(18, 5) FLEN( 7) FCAPTION(Zapoèítávat do výpoètu hlasù) CPOS(1, 5) VALUES(F:NE,T:ANO) CLEN(14)
  TYPE(GET)      NAME(dplatnyOd)   FPOS(18, 6) FLEN(12) FCAPTION(Datum platnosti_OD    )       CPOS(1, 6)   
  TYPE(GET)      NAME(dplatnyDo)   FPOS(18, 7) FLEN(12) FCAPTION(Datum platnosti_DO    )       CPOS(1, 7)   
TYPE(End)
