TYPE(drgForm) DTYPE(10) TITLE(Aktu�ln� prodejn� ceny ...) FILE(AktProcH) SIZE(110,25)  ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)


TYPE(Action) CAPTION(gen~AktCeny) EVENT(PRO_aktproceny_gen) TIPTEXT(Generov�n� aktu�ln�ch prodejn�ch cen)
*TYPE(Action) CAPTION(cen�k_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvo�en� kopie cen�ku)

* 1 - procenhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,7) FILE(AktProcH)                                           ;
                                      INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy) ;
                                      STABLEBLOCK(stableBlock)

    TYPE(GET)      NAME(AktProcH->ncisFirmy)  FLEN( 7)          CAPTION(firma)          PUSH(pro_firmy_sel) 
    TYPE(TEXT)     NAME(       M->nazFirmy)   CLEN(35)          CAPTION(n�zev firmy)  
    TYPE(GET)      NAME(AktProcH->ccisSklad)  FLEN( 7)          CAPTION(sklad)      
    TYPE(TEXT)     NAME(       M->nazSkladu)  CLEN(30)          CAPTION(n�zev skladu)
    TYPE(GET)      NAME(AktProcH->ddatum)     FLEN(15)          CAPTION(k datu)         PUSH(clickDate) 
    TYPE(TEXT)     NAME(AktProcH->ddatZprac)  CLEN(15)          CAPTION(datZprac) 
  TYPE(END)

  TYPE(DBrowse) FPOS(0,7.2) SIZE(109,18) FILE(cenZboz)             ;
                FIELDS( ccisSklad:��sSklad                       , ;
                        csklPol:sklPolo�ka                       , ;
                        nzboziKat:katZbo                         , ; 
                        cnazZbo:n�zev zbo��:25                   , ;
                        czkratJedn:mj                            , ;
                        M->procDph:dph                           , ; 
                        M->procento:% slevy::99999.999           , ;
                        M->nCeJPrZBZ:z�klCenaBDan�::99999999.9999, ;       
                        M->nCeJPrKBZ:koncCenaBDan�::99999999.9999, ;       
                        M->nCeJPrKDZ:z�klCenaSDan�::99999999.9999, ;       
                        M->nCeJPrZDZ:koncCenaSDan�::99999999.9999, ;       
                        cenProdc->ncenaPZbo:prodejn�Cena           ) ;
                CURSORMODE(3) PP(7) INDEXORD(3) RESIZE(yy) POPUPMENU(y) 

TYPE(END)



