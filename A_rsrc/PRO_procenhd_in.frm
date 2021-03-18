TYPE(drgForm) DTYPE(10) TITLE(Nastavení prodejních cen a slev ...) FILE(procenhd) SIZE(120,25) ;
                                                                   PRE(preValidate)            ; 
                                                                   POST(postValidate)          ;
                                                                   COMMFILES( procenhd:,proCenHo: ) 

TYPE(Action) CAPTION(ceník_~Firmy) EVENT(PRO_procenfi_IN)  TIPTEXT(Nastavení vazby mezi ceníky/firmy)
TYPE(Action) CAPTION(ceník_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvoøení kopie ceníku)


TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(cenotvorba) PRE(tabSelect) EXT() SUBTABS(A1,A2,A3)

* 1 - procenhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,9.7) FILE(procenhd)                                                     ;
                                        INDEXORD(2) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
   
    TYPE(TEXT)     NAME(       M->hlaProCen)           CLEN( 2) CAPTION() BITMAP()
    TYPE(TEXT)     NAME(procenhd->ncisProCen)          CLEN(11) CAPTION(èísloCeníku) 
    TYPE(COMBOBOX) NAME(procenhd->ntypprocen) FLEN(20) VALUES(1:Procento slevy z prodCeny   , ; 
                                                              2:Množstevní sleva            , ;
                                                              3:Sleva na zboží  -obrat      , ;
                                                              4:Sleva na zboží  -fakturace  , ;
                                                              5:Sleva na doklad -obrat      , ;
                                                              6:Sleva na doklad -fakturace  , ;
                                                              7:Maloobchodní cena           , ;
                                                              8:Prodejní cena               , ;
                                                              9:Procento pøirážky k prodCenì  ) CAPTION(prodejní ceník) NOREVISION()

    TYPE(GET)      NAME(procenhd->coznprocen) FLEN(15)          CAPTION(oznCeníku)
    TYPE(GET)      NAME(procenhd->cnazprocen) FLEN(30)          CAPTION(název ceníku)
    TYPE(GET)      NAME(procenhd->ncisfirmy)  FLEN( 7)          CAPTION(firma)         PUSH(fir_firmy_sel) 
    TYPE(TEXT)     NAME(procenhd->cNazev)     CLEN(25)          CAPTION(název firmy)
    TYPE(TEXT)     NAME(       M->zkrProdej)  CLEN( 5)          CAPTION(prod)
    TYPE(GET)      NAME(procenhd->czkratmeny) FLEN( 7)          CAPTION(mìna)
    TYPE(GET)      NAME(procenhd->dplatnyod)  FLEN(12)          CAPTION(platn_od)      PUSH(clickdate)
    TYPE(GET)      NAME(procenhd->dplatnydo)  FLEN(12)          CAPTION(platn_do)      PUSH(clickdate)
  TYPE(END)


* 2 - procenit 
*     typ --> 1.2.3.4 - column 1,2,3,5
*     typ --> 5.6     - column 4,5
*
   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(Kopletní)    OFFSET( 1,82) PRE(tabSelect) SUB(A1) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(sklPoložky)  OFFSET(17,67) PRE(tabSelect) SUB(A2) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(katZboží)    OFFSET(32,52) PRE(tabSelect) SUB(A3) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
*                      
  TYPE(EBrowse) FPOS(0,10.8) SIZE(65.8,12.8) FILE(procenit)                                            ;
                                            INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(y)

    TYPE(TEXT)     NAME(procenit->ccissklad)             CLEN( 6)  CAPTION(sklad)
    TYPE(GET)      NAME(procenit->csklpol)    FLEN(15)             CAPTION(sklPoložka) PUSH(skl_cenzboz_sel)
    TYPE(GET)      NAME(procenit->nzbozikat)  FLEN( 5)             CAPTION(katZbo)
    TYPE(GET)      NAME(procenit->czkrtypuhr) FLEN( 5)             CAPTION(typÚhr)
    TYPE(TEXT)     NAME(M->nazZbo)                       CLEN(35)  CAPTION(název položky)
  TYPE(END) 

*
* 3 - procenho  9.8
  TYPE(EBrowse) FPOS(66,10) SIZE(88,13.8) FILE(procenho)                                  ;
                                             INDEXORD(17)  CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(nn)

    TYPE(GET)      NAME(procenho->dplatnyod)  FLEN(11.5)           CAPTION(platn_od)  PUSH(clickdate)
    TYPE(GET)      NAME(procenho->dplatnydo)  FLEN(11.5)           CAPTION(platn_do)  PUSH(clickdate)
    TYPE(TEXT)     NAME(procenho->ncenaPZbo)             CLEN(11)  CAPTION(záklCena)                    
    TYPE(GET)      NAME(procenho->nprocento)  FLEN( 9)             CAPTION(%)                         PICTURE(999.99)
    TYPE(GET)      NAME(procenho->nhodnota)   FLEN(10)             CAPTION(hodnota)                   PICTURE(99999999.9999) 
  TYPE(END) 

* èárky pro oddìlìní oblastí
*  TYPE(Static) FPOS(0.1,9.45) SIZE(119.9,.6) STYPE(7)
*  TYPE(End)
*  TYPE(Static) FPOS(65.714,9.5) SIZE(.5,15.4) STYPE(7) CTYPE(2)
*  TYPE(End)

* horní nastavení
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletní seznam nastavení) EVENT(createContext) RESIZE(x)
TYPE(END)


TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET(10.5,79) CAPTION(prodejníCeník) PRE(tabSelect) EXT()
   TYPE(DBrowse) SIZE(120,15.5) FILE(CENPRODC) INDEXORD(3) ;
                 FIELDS( ccisSklad:èísSklad  , ;
                         csklPol:sklPoložka  , ;
                         cnazZbo:název zboží , ;
                         ncenCNZbo:nákCena   , ;
                         ncenaPZbo:prodCena  , ;
                         nprocMarz:% marže   , ;
                         ncenaMZbo:cenaSMarží  ) ;
                 CURSORMODE(3) PP(7) POPUPMENU(yy)

     TYPE(Static) SIZE(118.9,7.6) FPOS(0.5,15.35) RESIZE(yx)
       TYPE(STATIC) SIZE(118.9,1) FPOS(0,0) 
         TYPE(Text) CAPTION([)                CPOS(20, .4) CLEN( 2) BGND(1) FONT(5)     
         TYPE(TEXT) NAME(cenprodc->ccisSklad) CPOS(21, .4) CLEN(10) BGND(1) FONT(5)     
         TYPE(TEXT) NAME(cenprodc->csklPol)   CPOS(31, .4) CLEN(15) BGND(1) FONT(5)     
         TYPE(TEXT) NAME(cenprodc->cnazZbo)   CPOS(46, .4) CLEN(50) BGND(1) FONT(5)
         TYPE(Text) CAPTION(])                CPOS(96, .4) CLEN( 2) BGND(1) FONT(5)     
       TYPE(END) 

       TYPE(Text) CAPTION(Nakupní cenCena)      CPOS( 2,1.7) CLEN(26) PP(2) FONT(8)
       TYPE(GET)  NAME(cenprodc->ncenCNZbo)     FPOS(44,1.8) FLEN(11) 

       TYPE(Text) CAPTION(Marže)                CPOS( 33,2.8) CLEN( 6) PP(2)
       TYPE(Text) CAPTION(Èástka)               CPOS( 46,2.8) CLEN( 6) PP(2)
       TYPE(Text) CAPTION(Marže)                CPOS( 87,2.8) CLEN( 6) PP(2)
       TYPE(Text) CAPTION(Èástka)               CPOS(101,2.8) CLEN( 6) PP(2)
       TYPE(Static) STYPE(15) SIZE(118,.2) FPOS(0.5,3.2) CTYPE(2)
       TYPE(END)  
*
       TYPE(Text) CAPTION(Prodejní ceny)        CPOS( 2,3.8) CLEN(12) BGND(1) FONT(5)
       TYPE(Text) CAPTION( - základní bez danì) CPOS(15,3.8) CLEN(15)
       TYPE(Text) CAPTION( - základní   s daní) CPOS(15,4.8) CLEN(15)
*
       TYPE(GET)  NAME(cenprodc->nprocMarz)  FPOS(31,3.8) FLEN( 8)
       TYPE(TEXT) CAPTION(%)                 CPOS(40,3.8) CLEN( 3) PP(2)
       TYPE(GET)  NAME(cenprodc->ncenaPZbo)  FPOS(44,3.8) FLEN(11)
       TYPE(TEXT) NAME(M->procDph)           CPOS(31,4.8) CLEN( 9) BGND(10) CTYPE(2)
       TYPE(TEXT) CAPTION(%)                 CPOS(40,4.8) CLEN( 3) PP(2)
       TYPE(GET)  NAME(cenprodc->ncenaMZbo)  FPOS(44,4.8) FLEN(11)

       TYPE(Text) CAPTION( - pc_1  bez danì)  CPOS(70,3.5) CLEN(15)
       TYPE(Text) CAPTION( - pc_2  bez danì)  CPOS(70,4.5) CLEN(15)
       TYPE(Text) CAPTION( - pc_3  bez danì)  CPOS(70,5.5) CLEN(15)
       TYPE(Text) CAPTION( - pc_4  bez danì)  CPOS(70,6.5) CLEN(15)
          
       TYPE(GET)  NAME(CenProdC->NPROCMARZ1) FPOS(85,3.8)   FLEN( 8)
       TYPE(TEXT) CAPTION(%)                 CPOS(94,3.8)   CLEN( 3) PP(2)
       TYPE(GET)  NAME(CenProdC->NCENAP1ZBO) FPOS(98,3.8)   FLEN(11)

       TYPE(GET)  NAME(CenProdC->NPROCMARZ2) FPOS(85,4.8)   FLEN( 8)
       TYPE(TEXT) CAPTION(%)                 CPOS(94,4.8)   CLEN( 3) PP(2)
       TYPE(GET)  NAME(CenProdC->NCENAP2ZBO) FPOS(98,4.8)   FLEN(11)

       TYPE(GET)  NAME(CenProdC->NPROCMARZ3) FPOS(85,5.8)   FLEN( 8)
       TYPE(TEXT) CAPTION(%)                 CPOS(94,5.8)   CLEN( 3) PP(2)
       TYPE(GET)  NAME(CenProdC->NCENAP3ZBO) FPOS(98,5.8)   FLEN(11)

       TYPE(GET)  NAME(CenProdC->NPROCMARZ4) FPOS(85,6.8)   FLEN( 8)
       TYPE(TEXT) CAPTION(%)                 CPOS(94,6.8)   CLEN( 3) PP(2)
       TYPE(GET)  NAME(CenProdC->NCENAP4ZBO) FPOS(98,6.8)   FLEN(11)
     TYPE(End)
TYPE(END)



