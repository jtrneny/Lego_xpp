TYPE(drgForm) DTYPE(10) TITLE(Exepedièní list  ...) SIZE(110,27) ;
                                                    FILE(EXPLSTHDw) POST(postValidate)

* TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené) 

  TYPE(COMBOBOX) NAME(EXPLSTHDw->COBDOBI)     FPOS(16,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS( 2,0.2) PP(2) 
  TYPE(COMBOBOX) NAME(EXPLSTHDw->COBDOBIDAN)  FPOS(37,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(28,0.2) PP(2)
  TYPE(ComboBox) NAME(EXPLSTHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()

TYPE(Static) FPOS(1,1.5) SIZE(108,5) STYPE(12) RESIZE(y) CTYPE(2)
  TYPE(STATIC) STYPE(9) FPOS(55,-.1) SIZE(108.8,6.2) RESIZE(yy)
  TYPE(End)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .5)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .5) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .5) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .5) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.5) 
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.5) CLEN(31) BGND(13)
  TYPE(TEXT) NAME(M->system_culice)  CPOS(15,2.5) CLEN(31) BGND(13)
  TYPE(TEXT) NAME(M->system_cpsc)    CPOS(15,3.5) CLEN( 8) BGND(13)
  TYPE(TEXT) NAME(M->system_csidlo)  CPOS(25,3.5) CLEN(21) BGND(13)

  TYPE(GET) NAME(EXPLSTHDw->NDOKLAD)    FPOS(80, 0.5) FLEN(10) FCAPTION(2. Expedièní list èíslo)  CPOS(64,0.5)          PP(2) FONT(5) CLEN(16)
*  TYPE(GET) NAME(EXPLSTHDw->CVARSYM)    FPOS(80, 1.5) FLEN(10) FCAPTION(   Variabilní symbol) CPOS(65,1.5) CLEN(15) PP(2)
*  TYPE(GET) NAME(EXPLSTHDw->NKONSTSYMB) FPOS(80, 2.5) FLEN(10) FCAPTION(   Konstantní symbol) CPOS(65,2.5) CLEN(15) PP(2)
*  TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(92, 2.5) CLEN(15) BGND(13)

  TYPE(GET) NAME(EXPLSTHDw->CCISOBJ)    FPOS(80, 1.5) FLEN(10) FCAPTION(   Èíslo objednávky)  CPOS(64,1.5) CLEN(15) PP(2)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,7) SIZE(110,19.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) EXT()
*  TYPE(TEXT) CAPTION(Penìžní ústav)         CPOS( 4,0.1) CLEN(11)  
*  TYPE(TEXT) CAPTION(Èíslo úètu)            CPOS(42,0.1) CLEN(10)
*  TYPE(TEXT) CAPTION(Vnitro úèet)           CPOS(80,0.1) CLEN(11)

  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1,3  ) FONT(5)
  TYPE(TEXT) CAPTION(6. Zpùsob dopravy   :) CPOS(1,7  ) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.5) SIZE(108.8,16.8  ) STYPE(9) RESIZE(yy)

* POD PENÌŽNÍM ÚSTAVEM
    TYPE(STATIC) FPOS(0.01,2) SIZE(108.7,14.7  ) STYPE(9)  RESIZE(yx)
    TYPE(End)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,6.01) SIZE(40,3  ) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ POD PSÈ
    TYPE(STATIC) FPOS(0.01,2.01) SIZE(108.8,7  ) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(0.01,2.01) SIZE(40,14.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(0.01,13.8) SIZE(108.8,2.9) STYPE(9)  RESIZE(yx)
    TYPE(End)

*    TYPE(GET) NAME(EXPLSTHDw->CBANK_UCT)         FPOS(42, 0.6) FLEN(25)                                 PP(2)
*    TYPE(GET) NAME(EXPLSTHDw->CVNBAN_UCT)        FPOS(80, 0.6) FLEN(25)                                 PP(2)
    TYPE(GET) NAME(EXPLSTHDw->CPRIJEMCE1)        FPOS( 2, 3.5) FLEN(25)
    TYPE(GET) NAME(EXPLSTHDw->CPRIJEMCE2)        FPOS( 2, 4.5) FLEN(25)
    TYPE(Get) NAME(EXPLSTHDw->CZKRZPUDOP)        FPOS( 2, 7.5) FLEN(25)
    TYPE(Get) NAME(EXPLSTHDw->NCISFIRMY)         FPOS(58,2.5) FLEN(10) FCAPTION(3. Odbìratel )         CPOS(47, 2.5)  PP(2) FONT(5) CLEN(11) PUSH(fin_firmy_sel)
    TYPE(Get) NAME(EXPLSTHDw->CZKRATSTAT)        FPOS(75,2.5) FLEN(10) FCAPTION(Stát)                  CPOS(70, 2.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->NICO)              FPOS(58,3.5) FLEN(10) FCAPTION(Ièo)                   CPOS(50, 3.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CDIC)              FPOS(75,3.5) FLEN(10) FCAPTION(Diè)                   CPOS(70, 3.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CNAZEV)            FPOS(58,4.5) FLEN(27) FCAPTION(Název)                 CPOS(50, 4.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CNAZEV2)           FPOS(58,5.5) FLEN(27)                                                PP(2)
    TYPE(Get) NAME(EXPSTHDw->CULICE)            FPOS(58,6.5) FLEN(27) FCAPTION(Ulice)                 CPOS(50, 6.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CPSC)              FPOS(58,7.5) FLEN(10) FCAPTION(PSè)                   CPOS(50, 7.5)  PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CSIDLO)            FPOS(70,7.5) FLEN(27)                                                PP(2)

*    TYPE(Get) NAME(EXPLSTHDw->NPROCSLEV)         FPOS(16, 9.5) FLEN(10) FCAPTION(Sleva/Pøirážka)        CPOS( 2, 9.5)   PP(2)
    TYPE(Get) NAME(EXPLSTHDw->CZKRPRODEJ)        FPOS(16,10.5) FLEN(10) FCAPTION(Prodejce)              CPOS( 2,10.5)   PP(2)
*    TYPE(Get) NAME(EXPLSTHDw->CUCET_UCT)         FPOS(16,12  ) FLEN(10) FCAPTION(Úèet odbìratele)       CPOS( 2,12  )   PP(2)

    TYPE(Get) NAME(EXPLSTHDw->DVYSTFAK)          FPOS(70, 9.5) FLEN(11) FCAPTION(Datum vystavení)      CPOS(50, 9.5)   PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(EXPLSTHDw->DPOVINFAK)         FPOS(70,10.5) FLEN(11) FCAPTION(Datum uskuteènìní)    CPOS(50,10.5)   PP(2) PUSH(CLICKDATE)
*    TYPE(Get) NAME(EXPLSTHDw->DSPLATFAK)         FPOS(70,11.5) FLEN(11) FCAPTION(Datum splatnosti)     CPOS(50,11.5)   PP(2) PUSH(CLICKDATE)
*    TYPE(Get) NAME(EXPLSTHDw->CZKRTYPUHR)        FPOS(70,12.5) FLEN(11) FCAPTION(Forma úhrady)         CPOS(50,12.5)   PP(2) 
*    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(83,12.5) CLEN(25) BGND(13)

    TYPE(Get) NAME(EXPLSTHDw->CJMENOVYS)         FPOS(10,14.3) FLEN(25) FCAPTION(Vystavil)             CPOS( 2,14.3)   PP(2)
** LOGIKA

    TYPE(ComboBox) FPOS(70,14.3) FLEN(25) NAME(EXPLSTHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(Zahranièní mìna) CPOS(50,14.3)

    TYPE(Get) NAME(EXPLSTHDw->NKURZAHMEN)        FPOS(70,15.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,15.3)   PP(2)
    TYPE(Get) NAME(EXPLSTHDw->NMNOZPREP)         FPOS(83,15.3) FLEN(11)                                                PP(2)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,7) SIZE(110,19.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()

* dodací list
  TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 4,0.01)   CLEN(11) CTYPE(1)                          
  TYPE(Text)  CAPTION([)                  CPOS(.8,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(EXPLSTITw->ccissklad)  CPOS( 2,0.80)   CLEN(15) CTYPE(1)                          GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                  CPOS(16,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloObjednávky)    CPOS(21,0.01)   CLEN(13) CTYPE(2)                          
  TYPE(Text)  CAPTION(èísloVýrZakázky)    CPOS(37,0.01)   CLEN(12) CTYPE(1)                          
  TYPE(Text)  CAPTION([)                  CPOS(34.8,0.80) CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(EXPLSTITw->cskp)       CPOS(35,0.80)   CLEN(15) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                  CPOS(50,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE) 


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,17.7) CTYPE(3) PP(2) 
    TYPE(Browse) FPOS(.5,10.4) SIZE(108,6.9) FILE(EXPLSTITw)                  ;
                                             FIELDS(M->cenPol::2.6::2       , ;
                                                    nintcount:polDokl       , ;
                                                    ccissklad:sklad         , ;  
                                                    csklpol:sklPoložka      , ;
                                                    cnazzbo:název zboží:26  , ;
                                                    nfaktmnoz:faktMnož      , ;
                                                    czkratjedn:mj           , ;     
                                                    M->cena_za_mj:cena/mj:13, ;
                                                    ncecprkdz:cenaCelkem      );
                                             CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)

* dodací list
    TYPE(Get)  NAME(EXPLSTITw->CSKLPOL)    FPOS( 1,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       
    TYPE(Get)  NAME(EXPLSTITw->CCISLOBINT) FPOS(18,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       
    TYPE(Get)  NAME(EXPLSTITw->CCISZAKAZ)  FPOS(35,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       

    TYPE(Get)  NAME(EXPLSTITw->CNAZZBO)    FPOS( 1,2.2) FLEN(32)  PP(2)                             
    TYPE(Get)  NAME(EXPLSTITw->NFAKTMNOZ)  FPOS(35,2.2) FLEN(15)  PP(2)                             
    TYPE(Get)  NAME(EXPLSTITw->CZKRATJEDN) FPOS(52,2.2) FLEN( 6)  PP(2) PUSH() 
    TYPE(Text) CAPTION(daò)                CPOS(64,2.2) CLEN( 4)  GROUPS(SETFONT,8.Arial CE)                    
    TYPE(Get)  NAME(EXPLSTITw->NPROCDPH)   FPOS(75,2.2) FLEN( 7)  FCAPTION(%) CPOS(83,2.2) CLEN(3)  

*    TYPE(ComboBox) NAME(EXPLSTITw->NRADVYKDPH) FPOS(80,2.2) FLEN(28) VALUES(a,a,a,a)               

    TYPE(TEXT) CAPTION(CENA)         CPOS( 2,3.2) CLEN( 5)                                         
    TYPE(TEXT) CAPTION(základní)     CPOS(25,3.2) CLEN( 6)                                         
    TYPE(TEXT) CAPTION(sleva)        CPOS(43,3.2) CLEN( 5)                                         
    TYPE(TEXT) CAPTION(% slevy)      CPOS(61,3.2) CLEN( 7)                                         
    TYPE(TEXT) CAPTION(se slevou)    CPOS(79,3.2) CLEN( 8)                                         
    TYPE(TEXT) CAPTION(celkem)       CPOS(97,3.2) CLEN( 6)                                         
  
    TYPE(Text) CAPTION(za MJ  v)     CPOS( 2,4.2)                                                  
    TYPE(Text) CAPTION(za POL v)     CPOS( 2,5.2)                                                  
    TYPE(TEXT) NAME(EXPLSTITw->ncenzakcel) CPOS(21,6.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE)  
    TYPE(TEXT) NAME(EXPLSTITw->nsazdan)    CPOS(75,6.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE)  
    TYPE(TEXT) NAME(EXPLSTITw->ncenzakced) CPOS(93,6.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE)  

    TYPE(STATIC) STYPE(13) FPOS( 1,3.8) SIZE(107, 3) CTYPE(2)                                      
* 1
      TYPE(Get)   NAME(EXPLSTITw->NCEJPRZBZ) FPOS(20,0.5) FLEN(13)   PP(2)                         
      TYPE(Get)   NAME(EXPLSTITw->NHODNSLEV) FPOS(38,0.5) FLEN(13)   PP(2)                         
      TYPE(Get)   NAME(EXPLSTITw->NPROCSLEV) FPOS(56,0.5) FLEN(13)   PP(2)                         
      TYPE(Text)  NAME(EXPLSTITw->ncejprkbz) CPOS(74,0.5) CLEN(14)   BGND(13) CTYPE(2)             
      TYPE(Text)  NAME(EXPLSTITw->ncejprkdz) CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)             
* 2
      TYPE(Text)  NAME(EXPLSTITw->ncecprzbz) CPOS(20,1.5) CLEN(14)   BGND(13) CTYPE(2)             
      TYPE(Text)  NAME(EXPLSTITw->ncelkslev) CPOS(38,1.5) CLEN(14)   BGND(13) CTYPE(2)             
      TYPE(Text)  NAME(EXPLSTITw->ncecprkbz) CPOS(74,1.5) CLEN(14)   BGND(13) CTYPE(2)             
      TYPE(Text)  NAME(EXPLSTITw->ncecprkdz) CPOS(92,1.5) CLEN(14)   BGND(13) CTYPE(2)             
    TYPE(End)

    TYPE(Get) NAME(EXPLSTITw->CDOPLNTXT) FPOS( 1,7.25) FLEN(69) PP(2)
    TYPE(Get) NAME(EXPLSTITw->CUCET)     FPOS(93,7.25) FLEN(10) FCAPTION(Nákladový úèet)   CPOS(75,7.25) CLEN(12) GROUPS(SETFONT,8.Arial CE)

* ns
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL1) FPOS(  3,9.15) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,8.2) CLEN(10) GROUPS(SETFONT,7.Arial CE) 
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL2) FPOS( 21,9.15) FLEN(10) FCAPTION(Výrobek)      CPOS(21,8.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL3) FPOS( 39,9.15) FLEN(10) FCAPTION(Zakázka)      CPOS(39,8.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL4) FPOS( 57,9.15) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,8.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL5) FPOS( 75,9.15) FLEN(10) FCAPTION(Stroj)        CPOS(75,8.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(EXPLSTITw->cNAZPOL6) FPOS( 93,9.15) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,8.2) CLEN(10) GROUPS(SETFONT,7.Arial CE)

    TYPE(STATIC) FPOS(0.4,8.6) SIZE(108.6,.1) STYPE(12)
    TYPE(End)
  TYPE(End)
TYPE(End)

* info
TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2)
* 1 a 6
  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8) FONT(5)                          GROUPS(16)
  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5) FONT(5)                          GROUPS(16)
  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8) FONT(5)                          GROUPS(16) 
  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
* 2 a 5
  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8) FONT(5)                  GROUPS(25)
  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(25)
* 3 a 4
  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(EXPLSTHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
TYPE(END)

** INFO PRO nFINTYP 1 a 6 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(16)
*  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8) FONT(5)                         GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)          GROUPS(16)
*  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5) FONT(5)                         GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)          GROUPS(16)
*  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8) FONT(5)                         GROUPS(16) 
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1) GROUPS(16)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1) GROUPS(16)
*TYPE(End)

** INFO PRO nFINTYP 2 a 5 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(25)
*  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8) FONT(5)                 GROUPS(25)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(25)
*TYPE(End)


** INFO PRO nFINTYP 3 a 4 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(explstitw->cfile_iv) FPOS(0,0) CLEN(0)
