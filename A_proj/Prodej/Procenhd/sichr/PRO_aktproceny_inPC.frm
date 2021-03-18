TYPE(drgForm) DTYPE(10) TITLE(Aktuální prodejní ceny ...) FILE(AktProcH) SIZE(110,25)  ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)


TYPE(Action) CAPTION(gen~AktCeny) EVENT(PRO_aktproceny_gen) TIPTEXT(Generování aktuálních prodejních cen)
*TYPE(Action) CAPTION(ceník_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvoøení kopie ceníku)

* 1 - procenhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,7) FILE(AktProcH)                                           ;
                                      INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy) ;
                                      STABLEBLOCK(stableBlock)

    TYPE(GET)      NAME(AktProcH->ncisFirmy)  FLEN( 7)          CAPTION(firma)          PUSH(pro_firmy_sel) 
    TYPE(TEXT)     NAME(       M->nazFirmy)   CLEN(35)          CAPTION(název firmy)  
    TYPE(GET)      NAME(AktProcH->ccisSklad)  FLEN( 7)          CAPTION(sklad)      
    TYPE(TEXT)     NAME(       M->nazSkladu)  CLEN(30)          CAPTION(název skladu)
    TYPE(GET)      NAME(AktProcH->ddatum)     FLEN(15)          CAPTION(k datu)         PUSH(clickDate) 
    TYPE(TEXT)     NAME(AktProcH->ddatZprac)  CLEN(15)          CAPTION(datZprac) 
  TYPE(END)

  TYPE(DBrowse) FPOS(0,7.2) SIZE(109,18) FILE(cenZboz)             ;
                FIELDS( ccisSklad:èísSklad                       , ;
                        csklPol:sklPoložka                       , ;
                        nzboziKat:katZbo                         , ; 
                        cnazZbo:název zboží:25                   , ;
                        czkratJedn:mj                            , ;
                        M->procDph:dph                           , ; 
                        M->procento:% slevy::99999.999           , ;
                        M->nCeJPrZBZ:záklCenaBDanì::99999999.9999, ;       
                        M->nCeJPrKBZ:koncCenaBDanì::99999999.9999, ;       
                        M->nCeJPrKDZ:záklCenaSDaní::99999999.9999, ;       
                        M->nCeJPrZDZ:koncCenaSDaní::99999999.9999, ;       
                        cenProdc->ncenaPZbo:prodejníCena           ) ;
                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 

TYPE(END)



