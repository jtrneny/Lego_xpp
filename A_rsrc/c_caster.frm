TYPE(drgForm) DTYPE(2) TITLE(��seln�k �asov�ch term�n�...) SIZE(90,15) FILE(C_CASTER) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_CASTER)                              ;
                            FIELDS( cCasTermin:�asTerm�n              , ;
                                    cNazCasTer:N�zev �asov�ho term�nu , ; 
                                    nDny:dny                          , ;  
                                    nTyd:t�dny                        , ;  
                                    nMes:m�s�ce                       , ;  
                                    nRok:rok                          , ;  
                                    nDnyLast:dnyDO                    , ;  
                                    nTydLast:t�dnyDO                  , ;  
                                    nMesLast:m�s�ceDO                 , ;  
                                    nRokLast:rokDO                    , ;  
                                    cTask:�loha                       , ; 
                                    dplatnyOd:platn�Od           , ;
                                    dplatnyDo:platn�Do             ) ;
                                    CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cCasTermin)       FPOS(20, 2) FLEN(12) FCAPTION(�asov� term�n)            CPOS(1, 2) CLEN(18)
  TYPE(GET) NAME(cNazCasTer)       FPOS(20, 3) FLEN(50) FCAPTION(N�zev �asov�ho term�nu  ) CPOS(1, 3)
  TYPE(GET) NAME(nDny)             FPOS(20, 4) FLEN(12) FCAPTION(Dny   -platnosti DO )        CPOS(1, 4)
  TYPE(GET) NAME(nTyd)             FPOS(20, 5) FLEN(12) FCAPTION(T�dny -platnosti DO )      CPOS(1, 5)
  TYPE(GET) NAME(nMes)             FPOS(20, 6) FLEN(12) FCAPTION(M�s�ce-platnosti DO )     CPOS(1, 6)
  TYPE(GET) NAME(nRok)             FPOS(20, 7) FLEN(12) FCAPTION(Roky  -platnosti DO )       CPOS(1, 7)
  TYPE(GET) NAME(nDnyLast)         FPOS(38, 4) FLEN(12) 
  TYPE(GET) NAME(nTydLast)         FPOS(38, 5) FLEN(12) 
  TYPE(GET) NAME(nMesLast)         FPOS(38, 6) FLEN(12) 
  TYPE(GET) NAME(nRokLast)         FPOS(38, 7) FLEN(12) 
  TYPE(GET) NAME(cTask)            FPOS(20, 8) FLEN(12) FCAPTION(�loha )                   CPOS(1, 8)
  TYPE(GET) NAME(dplatnyOd)        FPOS(20, 9) FLEN(12) FCAPTION(Datum platnosti_OD    )   CPOS(1, 9)   
  TYPE(GET) NAME(dplatnyDo)        FPOS(20,10) FLEN(12) FCAPTION(Datum platnosti_DO    )   CPOS(1,10)   
TYPE(End)
