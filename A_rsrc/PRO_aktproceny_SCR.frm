TYPE(drgForm) DTYPE(10) TITLE(Aktu�ln� prodejn� ceny ...) FILE(CenZboz) SIZE(110,25)  ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)


*TYPE(Action) CAPTION(gen~AktCeny) EVENT(PRO_aktproceny_gen) TIPTEXT(Generov�n� aktu�ln�ch prodejn�ch cen)
*TYPE(Action) CAPTION(cen�k_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvo�en� kopie cen�ku)



   TYPE(STATIC) STYPE(12) SIZE(70,1.50) FPOS(0.7,0.3) 
*    TYPE(Text) CAPTION([)                CPOS(20, .4) CLEN( 2) BGND(1) FONT(5)     
     TYPE(TEXT) NAME(firmy->ncisfirmy) CPOS(0.3, 0.3) CLEN( 9) BGND(1) FONT(5)     
     TYPE(TEXT) NAME(firmy->cnazev)    CPOS(9.3, 0.3) CLEN(60) BGND(1) FONT(5)  
   TYPE(END)  

* M->cenPol::2.6::2     , ;


   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)          ;
                FIELDS( M->typSlevy:F��S���K:6::2                , ;
                        ccisSklad:��sSklad                       , ;
                        csklPol:sklPolo�ka                       , ;
                        nzboziKat:katZbo                         , ; 
                        cnazZbo:n�zev zbo��:25                   , ;
                        czkratJedn:mj                            , ;
                        c_dph->nprocDph:dph                      , ; 
                        M->procento:% slevy::99999.999           , ;
                        M->nCeJPrZBZ:z�klCenaBDan�::99999999.9999, ;       
                        M->nCeJPrKBZ:koncCenaBDan�::99999999.9999, ;       
                        M->nCeJPrKDZ:z�klCenaSDan�::99999999.9999, ;       
                        M->nCeJPrZDZ:koncCenaSDan�::99999999.9999, ;       
                        cenProdc->ncenaPZbo:prodejn�Cena           ) ;
                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 

   TYPE(STATIC) STYPE(12) SIZE(37,1.50) FPOS(71,0.3) 
     TYPE(Text) CAPTION(k datumu :)         CPOS( 2,0.3) CLEN(10) BGND(1) FONT(5)     
     TYPE(GET) NAME(M->kDatumu)             FPOS(18,0.2) FLEN(15) BGND(1) FONT(5) PUSH(clickDate)    
   TYPE(END)  

* TYPE(END)



*   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)             ;
*                FIELDS( ccisSklad:��sSklad                       , ;
*                        csklPol:sklPolo�ka                       , ;
*                        nzboziKat:katZbo                         , ; 
*                        cnazZbo:n�zev zbo��:25                   , ;
*                        czkratJedn:mj                            , ;
*                        M->procDph:dph                           , ; 
*                        M->procento:% slevy::99999.999           , ;
*                        M->nCeJPrZBZ:z�klCenaBDan�::99999999.9999, ;       
*                        M->nCeJPrKBZ:koncCenaBDan�::99999999.9999, ;       
*                        M->nCeJPrKDZ:z�klCenaSDan�::99999999.9999, ;       
*                        M->nCeJPrZDZ:koncCenaSDan�::99999999.9999, ;       
*                        cenProdc->ncenaPZbo:prodejn�Cena           ) ;
*                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 




*   TYPE(DBrowse) FPOS(0.1,2.0) SIZE(109,23) FILE(cenZboz)             ;
*                FIELDS( ccisSklad:��sSklad                       , ;
*                        nzboziKat:katZbo                         , ; 
*                        csklPol:sklPolo�ka                       , ;
*                        cnazZbo:n�zev zbo��:35                   , ;
*                        czkratJedn:mj                            , ;
*                        cenProdc->ncenaPZbo:prodejn�Cena         , ;
*                        M->procento:% slevy::99999.999           , ;
*                        M->nCeJPrKBZ:koncCenaBDan�::99999999.9999  ) ;
*                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 
