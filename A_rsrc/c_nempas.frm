TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù nemocenských pásem ...) SIZE(90,15) FILE(C_NEMPAS)   ;
                                                                   OBDOBI(MZD) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_NEMPAS)                ;
                            FIELDS( ctypdoklad:typDokl  , ;
                                    ctypPohybu:typPohybu, ;
                                    dplatnyOd:platnýOd  , ;
                                    nrok:rok            , ;
                                    npasmo:pasmo        , ;
                                    npasmoOd:dnyOd:10   , ;
                                    npasmoDo:dnyDo:10   , ;
                                    ndruhMzdy:druhMzdy  , ;
                                    nDnyNeplPD:neplPD   , ;
                                    nDnyNeplKD:neplKD     ) ;
                                    CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(ctypDoklad)  FPOS(18, 2) FLEN(12) FCAPTION( Typ dokladu     ) CPOS(1, 2)
  TYPE(GET) NAME(ctypPohybu)  FPOS(18, 3) FLEN(12) FCAPTION( Typ pohybu      ) CPOS(1, 3)
  TYPE(GET) NAME(dplatnyOd)   FPOS(18, 4) FLEN(12) FCAPTION( Datum platnosti ) CPOS(1, 4)   
  TYPE(GET) NAME(nrok)        FPOS(18, 5) FLEN( 4) FCAPTION( Rok platnosti   ) CPOS(1, 5)
  TYPE(GET) NAME(npasmo)      FPOS(18, 6) FLEN( 4) FCAPTION( Pásmo nemocenky ) CPOS(1, 6)      
  TYPE(GET) NAME(npasmoOd)    FPOS(18, 7) FLEN(10) FCAPTION( Dny pásma_OD    ) CPOS(1, 7)  
  TYPE(GET) NAME(npasmoDo)    FPOS(18, 8) FLEN(10) FCAPTION( Dny pásma_DO    ) CPOS(1, 8)  
  TYPE(GET) NAME(ndruhMzdy)   FPOS(18, 9) FLEN( 6) FCAPTION( Druh mzdy       ) CPOS(1, 9)
  TYPE(GET) NAME(nDnyNeplPD)  FPOS(18,10) FLEN( 6) FCAPTION( Neplacené PR_dny) CPOS(1,10)
  TYPE(GET) NAME(nDnyNeplKD)  FPOS(18,11) FLEN( 6) FCAPTION( Neplacené KD_dny) CPOS(1,11)
TYPE(End)
