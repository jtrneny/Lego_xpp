TYPE(drgForm) DTYPE(10) TITLE(Aktuální prodejní ceny ...) FILE(CenZboz) SIZE(110,25)  ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)


*TYPE(Action) CAPTION(gen~AktCeny) EVENT(PRO_aktproceny_gen) TIPTEXT(Generování aktuálních prodejních cen)
*TYPE(Action) CAPTION(ceník_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvoøení kopie ceníku)



   TYPE(STATIC) STYPE(12) SIZE(70,1.50) FPOS(0.7,0.3) 
*    TYPE(Text) CAPTION([)                CPOS(20, .4) CLEN( 2) BGND(1) FONT(5)     
     TYPE(TEXT) NAME(firmy->ncisfirmy) CPOS(0.3, 0.3) CLEN( 9) BGND(1) FONT(5)     
     TYPE(TEXT) NAME(firmy->cnazev)    CPOS(9.3, 0.3) CLEN(60) BGND(1) FONT(5)  
   TYPE(END)  

* M->cenPol::2.6::2     , ;


   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)          ;
                FIELDS( M->typSlevy:F  S   K:6::2                , ;
                        ccisSklad:èísSklad                       , ;
                        csklPol:sklPoložka                       , ;
                        nzboziKat:katZbo                         , ; 
                        cnazZbo:název zboží:25                   , ;
                        czkratJedn:mj                            , ;
                        c_dph->nprocDph:dph                      , ; 
                        M->procento:% slevy::99999.999           , ;
                        M->nCeJPrZBZ:záklCenaBDanì::99999999.9999, ;       
                        M->nCeJPrKBZ:koncCenaBDanì::99999999.9999, ;       
                        M->nCeJPrKDZ:záklCenaSDaní::99999999.9999, ;       
                        M->nCeJPrZDZ:koncCenaSDaní::99999999.9999, ;       
                        cenProdc->ncenaPZbo:prodejníCena           ) ;
                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 

   TYPE(STATIC) STYPE(12) SIZE(37,1.50) FPOS(71,0.3) 
     TYPE(Text) CAPTION(k datumu :)         CPOS( 2,0.3) CLEN(10) BGND(1) FONT(5)     
     TYPE(GET) NAME(M->kDatumu)             FPOS(18,0.2) FLEN(15) BGND(1) FONT(5) PUSH(clickDate)    
   TYPE(END)  

* TYPE(END)



*   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)             ;
*                FIELDS( ccisSklad:èísSklad                       , ;
*                        csklPol:sklPoložka                       , ;
*                        nzboziKat:katZbo                         , ; 
*                        cnazZbo:název zboží:25                   , ;
*                        czkratJedn:mj                            , ;
*                        M->procDph:dph                           , ; 
*                        M->procento:% slevy::99999.999           , ;
*                        M->nCeJPrZBZ:záklCenaBDanì::99999999.9999, ;       
*                        M->nCeJPrKBZ:koncCenaBDanì::99999999.9999, ;       
*                        M->nCeJPrKDZ:záklCenaSDaní::99999999.9999, ;       
*                        M->nCeJPrZDZ:koncCenaSDaní::99999999.9999, ;       
*                        cenProdc->ncenaPZbo:prodejníCena           ) ;
*                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 




*   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)             ;
*                FIELDS( ccisSklad:èísSklad                       , ;
*                        nzboziKat:katZbo                         , ; 
*                        csklPol:sklPoložka                       , ;
*                        cnazZbo:název zboží:35                   , ;
*                        czkratJedn:mj                            , ;
*                        cenProdc->ncenaPZbo:prodejníCena         , ;
*                        M->procento:% slevy::99999.999           , ;
*                        M->nCeJPrKBZ:koncCenaBDanì::99999999.9999  ) ;
*                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 
