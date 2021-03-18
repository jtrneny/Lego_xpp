TYPE(drgForm) DTYPE(10) TITLE(Dodací list vystavený ...) SIZE(110,27) ;
                                                         FILE(DODLSTHDw) POST(postValidate)

* TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)

  TYPE(COMBOBOX) NAME(DODLSTHDw->COBDOBI)     FPOS(16,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS( 2,0.2) PP(2)
  TYPE(COMBOBOX) NAME(DODLSTHDw->COBDOBIDAN)  FPOS(37,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(28,0.2) PP(2)
  TYPE(ComboBox) NAME(DODLSTHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()

TYPE(Static) FPOS(1,1.4) SIZE(108,4.5) STYPE(9) RESIZE(y) CTYPE(2)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .25)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .25) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .25) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .25) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.25)
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.25) CLEN(31) BGND(13)

*  TYPE(TEXT) NAME(M->system_culice)  CPOS(15,2.3) CLEN(31) BGND(13)
*  TYPE(TEXT) NAME(M->system_cpsc)    CPOS(15,3.3) CLEN( 8) BGND(13)
*  TYPE(TEXT) NAME(M->system_csidlo)  CPOS(25,3.3) CLEN(21) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.3)                    FONT(6)   
  TYPE(TEXT) NAME(DODLSTHDw->NICO)   CPOS(15,2.3)  CLEN(10) BGND(13) FONT(5) 
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26,2.3)  CLEN( 5)          
  TYPE(TEXT) NAME(DODLSTHDw->CDIC)   CPOS(31,2.3)  CLEN(15) BGND(13) FONT(5)
  TYPE(TEXT) NAME(DODLSTHDw->CNAZEV) CPOS(15,3.3)  CLEN(31) BGND(13) FONT(5)


  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.2) RESIZE(yy)
    TYPE(GET) NAME(DODLSTHDw->NDOKLAD)    FPOS(24, 1.5) FLEN(10) FCAPTION(2. Dodací list èíslo)  CPOS(5,1.5)          PP(2) FONT(5) CLEN(16) NOREVISION()

*   TYPE(GET) NAME(DODLSTHDw->CVARSYM)    FPOS(80, 1.5) FLEN(10) FCAPTION(   Variabilní symbol) CPOS(65,1.5) CLEN(15) PP(2)
*   TYPE(GET) NAME(DODLSTHDw->NKONSTSYMB) FPOS(80, 2.5) FLEN(10) FCAPTION(   Konstantní symbol) CPOS(65,2.5) CLEN(15) PP(2)
*   TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(92, 2.5) CLEN(15) BGND(13)

    TYPE(GET) NAME(DODLSTHDw->CCISOBJ)    FPOS(24, 3) FLEN(25) FCAPTION(   Èíslo objednávky)  CPOS(7,3) CLEN(15) PP(2)
  TYPE(End)
TYPE(End)

* 1 - ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,6) SIZE(110,20.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) EXT()
*  TYPE(TEXT) CAPTION(Penìžní ústav)         CPOS( 4,0.1) CLEN(11)
*  TYPE(TEXT) CAPTION(Èíslo úètu)            CPOS(42,0.1) CLEN(10)
*  TYPE(TEXT) CAPTION(Vnitro úèet)           CPOS(80,0.1) CLEN(11)

  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1,3  ) FONT(5)
  TYPE(TEXT) CAPTION(6. Zpùsob dopravy   :) CPOS(1,7  ) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.5) SIZE(108.8,16.8  ) STYPE(9) RESIZE(yy)

* OKRASA PRO RADOST
    TYPE(STATIC) FPOS(1,.1) SIZE(106.7,1.5) STYPE(2) RESIZE(yy)
      TYPE(TEXT) CAPTION(DODACÍ LIST VYSTAVENÝ) CPOS(1,.7) CTYPE(1) FONT(5) CLEN(100) 
    TYPE(END)

* POD PENÌŽNÍM ÚSTAVEM
*    TYPE(STATIC) FPOS(0.01,2) SIZE(108.7,14.7  ) STYPE(9)  RESIZE(yx)
*    TYPE(End)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,6.01) SIZE(40,.15) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ POD ZPÚSOBEM DOPRAVY - PSÈ
    TYPE(STATIC) FPOS(0.01,9.01) SIZE(108.8,.15) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(40,2.01) SIZE(.2,14.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD PRODEJCEM
    TYPE(STATIC) FPOS(0.01,13.8) SIZE(108.8,.15) STYPE(9)  RESIZE(yx)
    TYPE(End)

*    TYPE(GET) NAME(DODLSTHDw->CBANK_UCT)         FPOS(42, 0.6) FLEN(25)                                 PP(2)
*    TYPE(GET) NAME(DODLSTHDw->CVNBAN_UCT)        FPOS(80, 0.6) FLEN(25)                                 PP(2)

    TYPE(Get) NAME(DODLSTHDw->NCISFIRMY)         FPOS(58,2.5) FLEN(10) FCAPTION(3. Odbìratel )         CPOS(47, 2.5)  PP(2) FONT(5) CLEN(11) PUSH(fin_firmy_sel)
    TYPE(Get) NAME(DODLSTHDw->NICO)              FPOS(58,3.5) FLEN(10) FCAPTION(Ièo)                   CPOS(50, 3.5)  PP(2)
    TYPE(Get) NAME(DODLSTHDw->CDIC)              FPOS(76,3.5) FLEN(10) FCAPTION(Diè)                   CPOS(71, 3.5)  PP(2)

    TYPE(Get) NAME(DODLSTHDw->CNAZEV)            FPOS(58,4.5) FLEN(28) FCAPTION(Název)                 CPOS(50, 4.5)  PP(2)
    TYPE(Get) NAME(DODLSTHDw->CNAZEV2)           FPOS(58,5.5) FLEN(28)                                                PP(2)
    TYPE(Get) NAME(DODLSTHDw->CULICE)            FPOS(58,6.5) FLEN(28) FCAPTION(Ulice)                 CPOS(50, 6.5)  PP(2)
    TYPE(Get) NAME(DODLSTHDw->CPSC)              FPOS(58,7.5) FLEN(10) FCAPTION(PSè)                   CPOS(50, 7.5)  PP(2)
    TYPE(Get) NAME(DODLSTHDw->CSIDLO)            FPOS(72,7.5) FLEN(27)                                                PP(2)
    TYPE(Get) NAME(DODLSTHDw->CZKRATSTAT)        FPOS(76,2.5) FLEN(10) FCAPTION(Stát)                  CPOS(71, 2.5)  PP(2)
    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(72,7.5) CLEN(28) BGND(13)

    TYPE(Get) NAME(DODLSTHDw->DVYSTFAK)          FPOS(70, 9.5) FLEN(11) FCAPTION(Datum vystavení)      CPOS(50, 9.5)   PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(DODLSTHDw->DPOVINFAK)         FPOS(70,10.5) FLEN(11) FCAPTION(Datum uskuteènìní)    CPOS(50,10.5)   PP(2) PUSH(CLICKDATE)

    TYPE(GET) NAME(DODLSTHDw->CPRIJEMCE1)        FPOS( 2, 3.5) FLEN(25)
    TYPE(GET) NAME(DODLSTHDw->CPRIJEMCE2)        FPOS( 2, 4.5) FLEN(25)
    TYPE(Get) NAME(DODLSTHDw->CZKRZPUDOP)        FPOS( 2, 7.5) FLEN(25)

    TYPE(Get) NAME(DODLSTHDw->NPROCSLEV)         FPOS(16, 9.5) FLEN(10) FCAPTION(Sleva/Pøirážka)        CPOS( 2, 9.5)   PP(2)
    TYPE(Get) NAME(DODLSTHDw->CZKRPRODEJ)        FPOS(16,10.5) FLEN(10) FCAPTION(Prodejce)              CPOS( 2,10.5)   PP(2)
*    TYPE(Get) NAME(DODLSTHDw->CUCET_UCT)         FPOS(16,12  ) FLEN(10) FCAPTION(Úèet odbìratele)       CPOS( 2,12  )   PP(2)


*    TYPE(Get) NAME(DODLSTHDw->DSPLATFAK)         FPOS(70,11.5) FLEN(11) FCAPTION(Datum splatnosti)     CPOS(50,11.5)   PP(2) PUSH(CLICKDATE)
*    TYPE(Get) NAME(DODLSTHDw->CZKRTYPUHR)        FPOS(70,12.5) FLEN(11) FCAPTION(Forma úhrady)         CPOS(50,12.5)   PP(2)
*    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(83,12.5) CLEN(25) BGND(13)

    TYPE(Get) NAME(DODLSTHDw->CJMENOVYS)         FPOS(10,14.3) FLEN(25) FCAPTION(Vystavil)             CPOS( 2,14.3)   PP(2)
** LOGIKA

    TYPE(ComboBox) FPOS(70,14.3) FLEN(25) NAME(DODLSTHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(Zahranièní mìna) CPOS(50,14.3)

    TYPE(Get) NAME(DODLSTHDw->NKURZAHMEN)        FPOS(70,15.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,15.3)   PP(2)
    TYPE(Get) NAME(DODLSTHDw->NMNOZPREP)         FPOS(83,15.3) FLEN(11)                                                PP(2)

    TYPE(PushButton) POS(105.5,15.6) SIZE(3,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(dodlsthdw->mpopisfak,1)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* 2 - POLOŽKY
TYPE(TabPage) FPOS(0,6) SIZE(110,20.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()

* dodací list
  TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 4,0.01)   CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS(.8,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(DODLSTITw->ccissklad)  CPOS( 2,0.80)   CLEN(15) CTYPE(1)                          GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                  CPOS(16,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(èísloObjednávky)    CPOS(21,0.01)   CLEN(13) CTYPE(2)
  TYPE(Text)  CAPTION(èísloVýrZakázky)    CPOS(37,0.01)   CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS(34.8,0.80) CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(DODLSTITw->cskp)       CPOS(35,0.80)   CLEN(15) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                  CPOS(50,0.80)   CLEN( 2) CTYPE(2)                          GROUPS(SETFONT,7.Arial CE)


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,18.7) CTYPE(3) PP(2)
    TYPE(DBrowse) FPOS(.5,11.4) SIZE(108,6.9) FILE(DODLSTITw)                  ;
                                              FIELDS(M->cenPol:c:2.6::2      , ;
                                                     M->isSest:s:2.6::2      , ; 
                                                     nintcount:polDokl       , ;
                                                     ccissklad:sklad         , ;
                                                     csklpol:sklPoložka      , ;
                                                     cnazzbo:název zboží:26  , ;
                                                     nfaktmnoz:faktMnož      , ;
                                                     czkratjedn:mj           , ;
                                                     M->cena_za_mj:cena/mj:10, ;
                                                     ncecprkdz:cenaCelkem      );
                                              CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)

* dodací list
    TYPE(Get)  NAME(DODLSTITw->CSKLPOL)    FPOS( 1,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)
     TYPE(Text)  NAME(M->cenzboz_kDis)     CPOS( 2,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get)  NAME(DODLSTITw->CCISLOBINT) FPOS(18,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)
      TYPE(Text)  NAME(M->objitem_kDis)    CPOS(19,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get)  NAME(DODLSTITw->CCISZAKAZI) FPOS(35,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)
     TYPE(Text)  NAME(M->vyrzak_kDis)      CPOS(36,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get)  NAME(DODLSTITw->CNAZZBO)    FPOS( 1,3.2) FLEN(32)  PP(2)
    TYPE(Get)  NAME(DODLSTITw->NFAKTMNOZ)  FPOS(35,3.2) FLEN(15)  PP(2)
    TYPE(Get)  NAME(DODLSTITw->CZKRATJEDN) FPOS(52,3.2) FLEN( 6)  PP(2) PUSH()
    TYPE(Text) CAPTION(daò)                CPOS(64,3.2) CLEN( 4)  GROUPS(SETFONT,8.Arial CE)
    TYPE(Get)  NAME(DODLSTITw->NPROCDPH)   FPOS(75,3.2) FLEN( 7)  FCAPTION(%) CPOS(83,3.2) CLEN(3)

*    TYPE(ComboBox) NAME(DODLSTITw->NRADVYKDPH) FPOS(80,2.2) FLEN(28) VALUES(a,a,a,a)

    TYPE(TEXT) CAPTION(CENA)         CPOS( 2,4.2) CLEN( 5)
    TYPE(TEXT) CAPTION(základní)     CPOS(25,4.2) CLEN( 7)
    TYPE(TEXT) CAPTION(sleva)        CPOS(43,4.2) CLEN( 5)
    TYPE(TEXT) CAPTION(% slevy)      CPOS(61,4.2) CLEN( 7)
    TYPE(TEXT) CAPTION(se slevou)    CPOS(79,4.2) CLEN( 8)
    TYPE(TEXT) CAPTION(celkem)       CPOS(97,4.2) CLEN( 6)

    TYPE(Text) CAPTION(za MJ  v)     CPOS( 2,5.3)
    TYPE(Text) CAPTION(za POL v)     CPOS( 2,6.3)
    TYPE(TEXT) NAME(DODLSTITw->ncenzakcel) CPOS(21,7.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE) PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(DODLSTITw->nsazdan)    CPOS(75,7.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE) PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(DODLSTITw->ncenzakced) CPOS(93,7.3) CTYPE(2) CLEN(14)                          GROUPS(SETFONT,8.Arial CE) PICTURE(@N 9999999999.99)

    TYPE(STATIC) STYPE(13) FPOS( 1,4.8) SIZE(107, 3) CTYPE(2)
* 1
      TYPE(Get)   NAME(DODLSTITw->NCEJPRZBZ) FPOS(20,0.5) FLEN(13)   PP(2)
      TYPE(Get)   NAME(DODLSTITw->NHODNSLEV) FPOS(38,0.5) FLEN(13)   PP(2)
      TYPE(Get)   NAME(DODLSTITw->NPROCSLEV) FPOS(56,0.5) FLEN(13)   PP(2)
      TYPE(Text)  NAME(DODLSTITw->ncejprkbz) CPOS(74,0.5) CLEN(14)   BGND(13) CTYPE(2)
      TYPE(Text)  NAME(DODLSTITw->ncejprkdz) CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)
* 2
      TYPE(Text)  NAME(DODLSTITw->ncecprzbz) CPOS(20,1.5) CLEN(14)   BGND(13) CTYPE(2)
      TYPE(Text)  NAME(DODLSTITw->ncelkslev) CPOS(38,1.5) CLEN(14)   BGND(13) CTYPE(2)
      TYPE(Text)  NAME(DODLSTITw->ncecprkbz) CPOS(74,1.5) CLEN(14)   BGND(13) CTYPE(2)
      TYPE(Text)  NAME(DODLSTITw->ncecprkdz) CPOS(92,1.5) CLEN(14)   BGND(13) CTYPE(2)
    TYPE(End)

    TYPE(Get) NAME(DODLSTITw->CDOPLNTXT) FPOS( 1,8.25) FLEN(69) PP(2)
    TYPE(Get) NAME(DODLSTITw->CUCET)     FPOS(97,8.25) FLEN(10) FCAPTION(Nákladový úèet)   CPOS(84,8.25) CLEN(12) 

* ns
    TYPE(GET) NAME(DODLSTITw->cNAZPOL1) FPOS(  3,10.15) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,9.2) CLEN(10) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(DODLSTITw->cNAZPOL2) FPOS( 21,10.15) FLEN(10) FCAPTION(Výrobek)      CPOS(21,9.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(DODLSTITw->cNAZPOL3) FPOS( 39,10.15) FLEN(10) FCAPTION(Zakázka)      CPOS(39,9.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(DODLSTITw->cNAZPOL4) FPOS( 57,10.15) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,9.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(DODLSTITw->cNAZPOL5) FPOS( 75,10.15) FLEN(10) FCAPTION(Stroj)        CPOS(75,9.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(DODLSTITw->cNAZPOL6) FPOS( 93,10.15) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,9.2) CLEN(10) GROUPS(SETFONT,7.Arial CE)

* memoEdit
    TYPE(PushButton) POS(105.5,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(dodlstitw->mpozzbo,0)

    TYPE(STATIC) FPOS(0.4,9.6) SIZE(108.6,.2) STYPE(12) CTYPE(2)
    TYPE(End)
  TYPE(End)
TYPE(End)

* info
TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(12) RESIZE(y) CTYPE(2)
* 1 a 6
  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8) FONT(5)                          GROUPS(16)
  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5) FONT(5)                          GROUPS(16)
  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8) FONT(5)                          GROUPS(16)
  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
  TYPE(Text) NAME(DODLSTHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
* 2 a 5
  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8) FONT(5)                  GROUPS(25)
  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(25)
* 3 a 4
  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(DODLSTHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
  TYPE(Text) NAME(DODLSTHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(DODLSTHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
  TYPE(Text) NAME(DODLSTHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
TYPE(END)

** INFO PRO nFINTYP 1 a 6 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(16)
*  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8) FONT(5)                         GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)          GROUPS(16)
*  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5) FONT(5)                         GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)          GROUPS(16)
*  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8) FONT(5)                         GROUPS(16)
*  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1) GROUPS(16)
*  TYPE(Text) NAME(DODLSTHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1) GROUPS(16)
*TYPE(End)

** INFO PRO nFINTYP 2 a 5 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(25)
*  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8) FONT(5)                 GROUPS(25)
*  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(25)
*TYPE(End)


** INFO PRO nFINTYP 3 a 4 **
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(DODLSTHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(DODLSTHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(DODLSTHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(DODLSTHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(DODLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(dodlstitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(dodlstitw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(dodlstitw->nnapocet)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(dodlstitw->nvypsazdan) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(dodlstitw->njeddan)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(dodlstitw->nCeJPrZDZ)  FPOS(0,0) CLEN(0)
*
TYPE(MLE)  NAME(dodlstitw->mpozzbo)    FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(MLE)  NAME(dodlstitw->mapolSest)  FPOS(0,0) SIZE(0,0) READONLY(y)
