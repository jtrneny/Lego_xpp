TYPE(drgForm) DTYPE(2) TITLE(Èíselník oblastí akcionáøù...) SIZE(90,15) FILE(C_OBLASA) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_OBLASA)                         ;
                            FIELDS( cZkrOblast:zkrObl            , ;
                                    cNazevObl:název oblasti      , ;     
                                    dplatnyOd:platnýOd           , ;
                                    dplatnyDo:platnýDo             ) ;
                                    CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cZkrOblast)  FPOS(18, 2) FLEN(12) FCAPTION(Zkratka oblasti    )       CPOS(1, 2)
  TYPE(GET)      NAME(cNazevObl)   FPOS(18, 3) FLEN(12) FCAPTION(Název oblasti      )       CPOS(1, 3)
  TYPE(GET)      NAME(dplatnyOd)   FPOS(18, 4) FLEN(12) FCAPTION(Datum platnosti_OD )       CPOS(1, 4)   
  TYPE(GET)      NAME(dplatnyDo)   FPOS(18, 5) FLEN(12) FCAPTION(Datum platnosti_DO )       CPOS(1, 5)   
TYPE(End)
