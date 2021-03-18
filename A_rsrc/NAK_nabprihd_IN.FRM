TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava nabídky pøijatì ...) SIZE(110,29) ;
                                                                   FILE(NABPRIHDw) POST(postValidate)


TYPE(ComboBox) NAME(NABPRIHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()
*TYPE(PushButton) POS(90.0, 27.8) SIZE(17,1) EVENT(KusTree) ICON1(101) ICON2(201) ATYPE(3) CAPTION(Kalkulace výrobku)
TYPE(Static) FPOS(1,1.5) SIZE(108,5) STYPE(9) RESIZE(y) CTYPE(2)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .5)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .5) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .5) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .5) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.5)
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.5) CLEN(31) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.7)                    FONT(6)
  TYPE(TEXT) NAME(NABPRIHDw->NICO)   CPOS(15,2.7)  CLEN(10) BGND(14) FONT(5)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26,2.7)  CLEN( 5)
  TYPE(TEXT) NAME(NABPRIHDw->CDIC)   CPOS(31,2.7)  CLEN(15) BGND(14) FONT(5)
  TYPE(TEXT) NAME(NABPRIHDw->CNAZEV) CPOS(15,3.7)  CLEN(31) BGND(14) FONT(5)

  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.6) RESIZE(yy)
    TYPE(GET)  NAME(NABPRIHDw->ndoklad)     FPOS(24, 1  ) FLEN(13) FCAPTION(2. Nabídka èíslo) CPOS(4,1) PP(2) FONT(5) CLEN(19)  NOREVISION()
    TYPE(Text) CAPTION(int_èísloNabídky)    CPOS( 6, 2.5) CLEN(15)    
    TYPE(Text) NAME(NABPRIHDw->cnazPrij)    CPOS(24, 2.5) CLEN(28) BGND(13)
    TYPE(Get)  NAME(NABPRIHDw->ccisNabDo)   FPOS(24, 3.6) FLEN(13) FCAPTION(èís_nabDodavatele)   CPOS(6,3.6) CLEN(16)
  TYPE(End)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT()
  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1, 0.6) FONT(5)
  TYPE(TEXT) CAPTION(5. Zpùsob dopravy   :) CPOS(1, 4.6) FONT(5)
  TYPE(TEXT) CAPTION(6. Prodejce         :) CPOS(1, 8.6) FONT(5)
  TYPE(TEXT) CAPTION(7. Uplatnìní slev   :) CPOS(1,12.1) FONT(5) CLEN(16)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.2) SIZE(108.8,20) STYPE(9) RESIZE(yy)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,4.01) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ POD STÁTEM
    TYPE(STATIC) FPOS(40.01,7.01) SIZE(68.5,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(40,0.01) SIZE(.2,14.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ POD ÈÍSLEM TRASY
    TYPE(STATIC) FPOS(0.01,8.01) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(0.01,11.8) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ PDO KURZ/PTØEPOÈET
    TYPE(STATIC) FPOS(0.01,14.7) SIZE(108.8,.2) STYPE(9)  RESIZE(yx)
    TYPE(End)

    TYPE(Get)  NAME(NABPRIHDw->NCISFIRMY)       FPOS(58, 0.5) FLEN(10) FCAPTION(3. Dodavatel)  CPOS(45, 0.5)  FONT(5) CLEN(12) PUSH(fir_firmy_sel) NOREVISION()
    TYPE(Text) CAPTION(Ièo)                     CPOS(71, 0.5) CLEN( 4)
    TYPE(Text) NAME(NABPRIHDw->NICO)            CPOS(76, 0.5) CLEN(10) BGND(13)
    TYPE(Text) CAPTION(Diè)                     CPOS(88, 0.5) CLEN( 4)
    TYPE(Text) NAME(NABPRIHDw->CDIC)            CPOS(93, 0.5) CLEN(15) BGND(13)
    TYPE(Text) CAPTION(Název)                   CPOS(50, 1.5) CLEN( 6)
    TYPE(Text) NAME(NABPRIHDw->CNAZEV)          CPOS(58, 1.5) CLEN(28) BGND(13)
    TYPE(Text) NAME(NABPRIHDw->CNAZEV2)         CPOS(58, 2.5) CLEN(28) BGND(13)
    TYPE(Text) CAPTION(Ulice)                   CPOS(50, 3.5)
    TYPE(Text) NAME(NABPRIHDw->CULICE)          CPOS(58, 3.5) CLEN(28) BGND(13)
    TYPE(Text) CAPTION(PSè)                     CPOS(50, 4.5) CLEN( 4)
    TYPE(Text) NAME(NABPRIHDw->CPSC)            CPOS(58, 4.5) CLEN(10) BGND(13)
    TYPE(Text) NAME(NABPRIHDw->CSIDLO)          CPOS(70, 4.5) CLEN(27) BGND(13)
    TYPE(Text) CAPTION(Stát)                    CPOS(50, 5.5)
    TYPE(Text) NAME(NABPRIHDw->CZKRATSTAT)      CPOS(58, 5.5) CLEN(10) BGND(13)
    TYPE(Text) NAME(c_staty->cnazevstat)        CPOS(70, 5.5) CLEN(27) BGND(13)

    TYPE(Get)  NAME(NABPRIHDw->ddatPrij)        FPOS(70, 7.5) FLEN(12) PUSH(clickdate) FCAPTION(nabízeno Dne) CPOS(50, 7.5) CLEN(13)
    TYPE(Get)  NAME(NABPRIHDw->ddatDoDod)       FPOS(70, 8.5) FLEN(12) PUSH(clickdate) FCAPTION(datum Dodání)  CPOS(50, 8.5) CLEN(12)
    TYPE(Get)  NAME(NABPRIHDw->czkrtypuhr)      FPOS(70,10.5) FLEN(12)                 FCAPTION(forma Úhrady)  CPOS(50,10.5) CLEN(12)
    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(83,10.5) CLEN(25) BGND(13)

    TYPE(GET)  NAME(NABPRIHDw->CPRIJEMCE1)      FPOS( 2, 1.5) FLEN(25)
    TYPE(GET)  NAME(NABPRIHDw->CPRIJEMCE2)      FPOS( 2, 2.5) FLEN(25)

    TYPE(Get)  NAME(NABPRIHDw->CZKRZPUDOP)      FPOS( 2, 5.5) FLEN(25)
    TYPE(Get)  NAME(NABPRIHDw->czkrprodej)      FPOS( 2, 9.5) FLEN( 8)
    TYPE(Text) NAME(c_prodej->cnazprodej)       CPOS(12, 9.5) CLEN(27) BGND(13)

    TYPE(Text) CAPTION([základní])              CPOS( 2,12.6) CLEN( 9)
    TYPE(Text) CAPTION(+)                       CPOS(11,12.6) CLEN( 2)
    TYPE(Text) CAPTION([hotovostní])            CPOS(14,12.6) CLEN(10)
    TYPE(Text) CAPTION(=)                       CPOS(26,12.6) CLEN( 2)
    TYPE(Text) CAPTION([celkem])                CPOS(30,12.6) CLEN(10)

    TYPE(Get)  NAME(NABPRIHDw->nprocslfao)      FPOS( 2,13.6) FLEN( 6)
    TYPE(Text) CAPTION(+)                       CPOS(11,13.6) CLEN( 2)
    TYPE(Get)  NAME(NABPRIHDw->nprocslhot)      FPOS(14,13.6) FLEN( 8)
    TYPE(Text) CAPTION(=)                       CPOS(26,13.6) CLEN( 2)
    TYPE(Text) NAME(NABPRIHDw->nprocslev)       CPOS(30,13.6) CLEN( 7)  BGND(13)  CTYPE(2)

    TYPE(ComboBox) FPOS(70,12.3) FLEN(25) NAME(NABPRIHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(mìna) CPOS(50,12.3) PP(2)
    TYPE(Get) NAME(NABPRIHDw->NKURZAHMEN)       FPOS(70,13.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,13.3)   PP(2)
    TYPE(Get) NAME(NABPRIHDw->NMNOZPREP)        FPOS(83,13.3) FLEN(11)                                                PP(2)

    TYPE(Get)  NAME(NABPRIHDw->cintpracov)      FPOS(14,15  ) FLEN(25) PUSH(osb_osoby_sel) FCAPTION(nabídku pøijal) CPOS( .2,15)   CLEN(13)
    TYPE(Get)  NAME(NABPRIHDw->cnazpracov)      FPOS(70,15  ) FLEN(37) PUSH(osb_osoby_sel) FCAPTION(kontaktní osoba)   CPOS(50,15)   CLEN(13)

    TYPE(MLE) NAME('NABPRIHDw->mpoznNab') FPOS( .5,16) SIZE(53,3.5) RESIZE(yx) SCROLL(ny)
    TYPE(MLE) NAME('NABPRIHDw->mpoznamka') FPOS(54 ,16) SIZE(54,3.5) RESIZE(yx) SCROLL(ny)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()
  TYPE(Text)  CAPTION(katalogovéÈíslo)   CPOS( 2  ,0.01) CLEN(13) CTYPE(1)                       
  TYPE(Text)  CAPTION([)                 CPOS(  .8,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(NABPRIITw->ccissklad) CPOS( 2  ,0.80) CLEN(11) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                 CPOS(16  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)

  TYPE(Text)  CAPTION(název zboží)      CPOS(19 ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                CPOS(19 ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
**  TYPE(text)  NAME(M->typ_objitem)      CPOS(22 ,0.80) CLEN(10) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                CPOS(39 ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(% dph)            CPOS(58 ,0.01) CLEN( 6) CTYPE(1)

  TYPE(Text)  CAPTION(nabízenoDne)      CPOS(67 ,0.01) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)      CPOS(82 ,0.01) CLEN(10) CTYPE(1)
*  TYPE(Text)  CAPTION(datumVýroby)      CPOS(96 ,0.01) CLEN(12) CTYPE(1)


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,19.7) CTYPE(3) PP(2)
   TYPE(DBrowse) FPOS(.15,9.8) SIZE(108.9,9.8) FILE(NABPRIITw)                  ;
                                               FIELDS(nintcount:polDokl       , ;
                                                      ccisSklad:sklad         , ;
                                                      csklpol:sklPoložka      , ;
                                                      cnazzbo:název zboží:34  , ;
                                                      nmnozNOdes:mn_nabízeno  , ;
                                                      czkratJedn:mj           , ;
                                                      ncenZakCel:cenCelk      , ;
                                                      ncenZakCed:cenaCelksDPH   ) ;
                                               CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) POPUPMENU(nn)

* položka objednávky
    TYPE(Get)  NAME(NABPRIITw->ckatCzbo)    FPOS( 1,1.2  ) FLEN(15) PP(2) 
*    TYPE(Get)  NAME(NABPRIITw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(skl_cenzboz_sel)
*     TYPE(Text)  NAME(M->cenzboz_kDis)    CPOS( 2,2.2) CLEN(13) CTYPE(1) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)

    TYPE(Get)  NAME(NABPRIITw->cnazzbo)    FPOS(19,1.2  ) FLEN(36) PP(2)
   TYPE(Get)   NAME(NABPRIITw->NPROCDPH)   FPOS(57,1.2  ) FLEN( 7) PP(2)

*    TYPE(Text) NAME(NABPRIITw->nklicdph)   CPOS(59,1.2  ) CLEN( 0) BGND(13)
*    TYPE(Text) NAME(M->procDph)            CPOS(58,1.2  ) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) NAME(NABPRIHDw->ddatPrij)   CPOS(67,1.2  ) CLEN(12) BGND(13) CTYPE(1) FONT(5)
    TYPE(Get)  NAME(NABPRIITw->ddatDoDod)  FPOS(80.5,1.2) FLEN(12) PUSH(clickdate)

    TYPE(Text) CAPTION(nabízeno)          CPOS(16,3.5) CLEN( 9)

    TYPE(STATIC) FPOS(1,4) SIZE(107,3.8) STYPE(13) CTYPE(2)

* množství
      TYPE(Text) CAPTION(Množství  )          CPOS( 1,0.5) CLEN( 9)
      TYPE(Get)  NAME(NABPRIITw->nMnoznOdes)  FPOS(15,0.5) FLEN(13) PP(2)
      TYPE(Get)  NAME(NABPRIITw->CZKRATJEDN)  FPOS(30,0.5) FLEN( 6) PP(2) 

* ceny
      TYPE(Text) CAPTION(Ceny v )             CPOS( 1,2.5) CLEN( 7)
      TYPE(Text) NAME(NABPRIHDw->czkratmeny)  CPOS(10,2.5) CLEN( 4) CTYPE(1) FONT(5)

      TYPE(Text) CAPTION(cenaZákladní)        CPOS(15,1.5) CLEN(10)
      TYPE(Get)  NAME(NABPRIITw->ncenaZakl)   FPOS(15,2.5) FLEN(13) PUSH(KusTree)

      TYPE(Text) CAPTION(slevaZákladní)       CPOS(31,1.5) CLEN(11)
      TYPE(Get)  NAME(NABPRIITw->nhodnslev)   FPOS(31,2.5) FLEN(13)

      TYPE(Text) CAPTION([)                   CPOS(44,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABPRIITw->nprocslfao)  CPOS(45,1.5) CLEN( 5) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(+)                   CPOS(48,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABPRIITw->nprocslhot)  CPOS(50,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(+)                   CPOS(53,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABPRIITw->nprocslmno)  CPOS(55,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(])                   CPOS(58,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)

      TYPE(Get)  NAME(NABPRIITw->nprocslev)   FPOS(48,2.5) FLEN(7)

      TYPE(Text) CAPTION(prodejní cena)       CPOS(61,1.5) CLEN(11) CTYPE(2)
      TYPE(Text) NAME(NABPRIITw->ncenJedZak)  CPOS(59,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)     CPOS(75,1.5) CLEN(13) CTYPE(2)
      TYPE(Text) NAME(NABPRIITw->ncenZakCel)  CPOS(75,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)       CPOS(95,1.5) CLEN(10) CTYPE(2)
      TYPE(Text) NAME(NABPRIITw->ncenZakCed)  CPOS(91,2.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Static) FPOS(.3,1.5) SIZE(107, .01) STTYPE(9)
      TYPE(End)
    TYPE(End)

    TYPE(Get) NAME(NABPRIITw->CDOPLNTXT)  FPOS( 1, 8.25) FLEN(100)    PP(2)

* memoEdit
    TYPE(PushButton) POS(105.0,8.25) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(nabpriitw->mpoznamka,0)
 TYPE(End)

*TYPE(PushButton) POS(90.0, 27.8) SIZE(17,1) EVENT(KusTree) ICON1(101) ICON2(201) ATYPE(3) CAPTION(Kalkulace výrobku)

* neviditelné pomocné položky
*TYPE(TEXT) NAME(objitemw->nmnozPlOdb) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabpriitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabpriitw->nrecs_iv)   FPOS(0,0) CLEN(0)
*TYPE(MLE)  NAME(objitemw->mpoznamka)  FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(TEXT) NAME(nabpriitw->nzboziKat)  FPOS(0,0) CLEN(0)
*TYPE(TEXT) NAME(objitemw->nhmotnostJ) FPOS(0,0) CLEN(0)
*TYPE(TEXT) NAME(objitemw->nobjemJ)    FPOS(0,0) CLEN(0)