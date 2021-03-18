TYPE(drgForm) SIZE(80,15) DTYPE(10) TITLE(Èíselník skupin úètù ...) ;
              FILE(C_SKUPUC)  ;        
              GUILOOK(Action:n,IconBar:y)  

  TYPE(DBrowse) FPOS(.5,3.5) SIZE(80,11.5) FILE(C_SKUPUC)                      ;
                                           FIELDS(UCT_c_skupuc_CB()::1::2    , ;
                                                  cSKUPUCT:Skupina:10        , ;
                                                  cNAZSKUPUC:Název skupiny:36, ;
                                                  cUSERABB:Uživatel:15       , ;
                                                  dDATZMENY:DatZmìny:13        ) ;
                                           CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7)

  TYPE(Static) FPOS(.5,.5) SIZE(79,2.5) STYPE(13) CTYPE(2)
    TYPE(GET)  NAME(C_SKUPUC->cSKUPUCT)   FPOS( 1, 1.2) FLEN( 8) FCAPTION(Skupina )      CPOS( 1, .1) 
    TYPE(GET)  NAME(C_SKUPUC->cNAZSKUPUC) FPOS(11, 1.2) FLEN(34) FCAPTION(Název skupiny) CPOS(11, .1) POST(postLastField)

    TYPE(Text) CAPTION(Uživatel)          CPOS(47,  .1) CLEN(10) 
    TYPE(Text) NAME(C_SKUPUC->cUSERABB)   CPOS(47, 1.2) CLEN(14) PP(1) BGND(13)
    TYPE(Text) CAPTION(DatZmìny)          CPOS(62,  .1) CLEN(10) 
    TYPE(Text) NAME(C_SKUPUC->dDATZMENY)  CPOS(62, 1.2) CLEN(14) PP(1) BGND(13)
  TYPE(End)



