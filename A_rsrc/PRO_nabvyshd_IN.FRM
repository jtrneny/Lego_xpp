TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava nabídky vystavené ...) SIZE(110,29) ;
                                                                     FILE(NABVYSHDw) POST(postValidate)

TYPE(Action) CAPTION(pøepoèet C~eny)  EVENT( prepocetCENy ) TIPTEXT(Pøepoèet cenové kalkulace nabídky )

TYPE(ComboBox) NAME(NABVYSHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()
*TYPE(PushButton) POS(90.0, 27.8) SIZE(17,1) EVENT(KusTree) ICON1(101) ICON2(201) ATYPE(3) CAPTION(Kalkulace výrobku)
TYPE(Static) FPOS(1,1.5) SIZE(108,5) STYPE(9) RESIZE(y) CTYPE(2)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .5)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .5) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .5) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .5) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.5)
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.5) CLEN(31) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.7)                    FONT(6)
  TYPE(TEXT) NAME(NABVYSHDw->NICO)   CPOS(15,2.7)  CLEN(10) BGND(14) FONT(5)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26,2.7)  CLEN( 5)
  TYPE(TEXT) NAME(NABVYSHDw->CDIC)   CPOS(31,2.7)  CLEN(15) BGND(14) FONT(5)
  TYPE(TEXT) NAME(NABVYSHDw->CNAZEV) CPOS(15,3.7)  CLEN(31) BGND(14) FONT(5)

  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.6) RESIZE(yy)
    TYPE(GET)  NAME(NABVYSHDw->ndoklad)     FPOS(24, 1  ) FLEN(13) FCAPTION(2. Nabídka èíslo) CPOS(4,1) PP(2) FONT(5) CLEN(19) NOREVISION()
    TYPE(Text) CAPTION(int_èísloNabídky)    CPOS( 6, 2.5) CLEN(15)
    TYPE(Text) NAME(NABVYSHDw->cnazOdes)    CPOS(24, 2.5) CLEN(28) BGND(13)
    TYPE(Get)  NAME(NABVYSHDw->ccisNabOd)   FPOS(24, 3.6) FLEN(13) FCAPTION(èís_nabOdbìratele)   CPOS(6,3.6) CLEN(16)
  TYPE(End)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT()
  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1, 0.6) FONT(5)
  TYPE(TEXT) CAPTION(5. Nabízené ceny       :) CPOS(1, 4.4) FONT(5)
  TYPE(TEXT) CAPTION(6. Zpùsob dopravy   :) CPOS(1, 6.8) FONT(5)
  TYPE(TEXT) CAPTION(7. Prodejce         :) CPOS(1, 9.6) FONT(5)
  TYPE(TEXT) CAPTION(8. Uplatnìní slev   :) CPOS(1,12.1) FONT(5) CLEN(16)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.2) SIZE(108.8,20) STYPE(9) RESIZE(yy)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,3.90) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ POD STÁTEM
    TYPE(STATIC) FPOS(40.01,7.01) SIZE(68.5,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(40,0.01) SIZE(.2,14.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ POD ÈÍSLEM ZPUSOB DOPRAVY
    TYPE(STATIC) FPOS(0.01,9.01) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(0.01,11.8) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ PDO KURZ/PTØEPOÈET
    TYPE(STATIC) FPOS(0.01,14.7) SIZE(108.8,.2) STYPE(9)  RESIZE(yx)
    TYPE(End)

    TYPE(Get)  NAME(NABVYSHDw->NCISFIRMY)       FPOS(52, 0.5) FLEN(10) FCAPTION(3. Odbìratel )         CPOS(41, 0.5)  FONT(5) CLEN(11) PUSH(fir_firmy_sel) NOREVISION()
    TYPE(Text) CAPTION(Ièo)                     CPOS(65, 0.5) CLEN( 4) 
    TYPE(Get)  NAME(NABVYSHDw->NICO)            FPOS(70,  .5) FLEN(10) 
    TYPE(Text) CAPTION(Diè)                     CPOS(84, 0.5) CLEN( 4)
    TYPE(Get)  NAME(NABVYSHDw->CDIC)            FPOS(88,  .5) FLEN(15) 
    TYPE(Text) CAPTION(Název)                   CPOS(44, 1.5) CLEN( 6)   
    TYPE(Get)  NAME(NABVYSHDw->CNAZEV)          FPOS(52, 1.5) FLEN(51) 
    TYPE(Get)  NAME(NABVYSHDw->CNAZEV2)         FPOS(52, 2.5) FLEN(51)                                                
    TYPE(Text) CAPTION(Ulice)                   CPOS(44, 3.5) 
    TYPE(Get)  NAME(NABVYSHDw->CULICE)          FPOS(52, 3.5) FLEN(51) 
    TYPE(Text) CAPTION(Místo)                   CPOS(44, 4.5)
    TYPE(Get)  NAME(NABVYSHDw->CPSC)            FPOS(52, 4.5) FLEN(10)
    TYPE(Get)  NAME(NABVYSHDw->CSIDLO)          FPOS(66, 4.5) FLEN(37)                                                
    TYPE(Text) CAPTION(Stát)                    CPOS(44, 5.5) 
    TYPE(Get)  NAME(NABVYSHDw->CZKRATSTAT)      FPOS(52, 5.5) FLEN(10)
    TYPE(Text) NAME(c_staty->cnazevstat)        CPOS(66, 5.5) CLEN(37) 

    TYPE(Get)  NAME(NABVYSHDw->ddatOdes)        FPOS(70, 7.5) FLEN(12) PUSH(clickdate) FCAPTION(nabízeno Dne)   CPOS(50, 7.5) CLEN(13)
    TYPE(Get)  NAME(NABVYSHDw->ccasTermin)      FPOS(70, 8.5) FLEN(12)                 FCAPTION(termín Dodání)  CPOS(50, 8.5) CLEN(12)
    TYPE(TEXT) NAME(C_casTer->cNazCasTer)       CPOS(83, 8.5) CLEN(25) BGND(13)
    TYPE(Get)  NAME(NABVYSHDw->ddatPlat)        FPOS(70, 9.5) FLEN(12) PUSH(clickdate) FCAPTION(platnost Do)    CPOS(50, 9.5) CLEN(13)
  
    TYPE(Get)  NAME(NABVYSHDw->czkrtypuhr)      FPOS(70,10.5) FLEN(12)                 FCAPTION(forma Úhrady)  CPOS(50,10.5) CLEN(12)
    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR)        CPOS(83,10.5) CLEN(25) BGND(13)

    TYPE(GET)  NAME(NABVYSHDw->CPRIJEMCE1)      FPOS( 2, 1.5) FLEN(35)
    TYPE(GET)  NAME(NABVYSHDw->CPRIJEMCE2)      FPOS( 2, 2.5) FLEN(35)

    TYPE(COMBOBOX) NAME(NABVYSHDw->NTYPCENNAB)  FPOS( 2, 5.2) FLEN(36) REF(NTYPCENNAB)

    TYPE(Get)  NAME(NABVYSHDw->CZKRZPUDOP)      FPOS( 2, 7.6) FLEN(35)
    TYPE(Get)  NAME(NABVYSHDw->czkrprodej)      FPOS( 2,10.4) FLEN( 8)
    TYPE(Text) NAME(c_prodej->cnazprodej)       CPOS(12,10.4) CLEN(27) BGND(13)

    TYPE(Text) CAPTION([základní])              CPOS( 2,12.6) CLEN( 9)
    TYPE(Text) CAPTION(+)                       CPOS(11,12.6) CLEN( 2)
    TYPE(Text) CAPTION([hotovostní])            CPOS(14,12.6) CLEN(10)
    TYPE(Text) CAPTION(=)                       CPOS(26,12.6) CLEN( 2)
    TYPE(Text) CAPTION([celkem])                CPOS(30,12.6) CLEN(10)

    TYPE(Get)  NAME(NABVYSHDw->nprocslfao)      FPOS( 2,13.6) FLEN( 6)
    TYPE(Text) CAPTION(+)                       CPOS(11,13.6) CLEN( 2)
    TYPE(Get)  NAME(NABVYSHDw->nprocslhot)      FPOS(14,13.6) FLEN( 8)
    TYPE(Text) CAPTION(=)                       CPOS(26,13.6) CLEN( 2)
    TYPE(Text) NAME(NABVYSHDw->nprocslev)       CPOS(30,13.6) CLEN( 7)  BGND(13)  CTYPE(2)

    TYPE(ComboBox) FPOS(70,12.3) FLEN(25) NAME(NABVYSHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(mìna) CPOS(50,12.3) PP(2)
    TYPE(Get) NAME(NABVYSHDw->NKURZAHMEN)       FPOS(70,13.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,13.3)   PP(2)
    TYPE(Get) NAME(NABVYSHDw->NMNOZPREP)        FPOS(83,13.3) FLEN(11)                                                PP(2)

    TYPE(Get)  NAME(NABVYSHDw->cintpracov)      FPOS(14,15  ) FLEN(25) PUSH(osb_osoby_sel) FCAPTION(nabídku vystavil)  CPOS( .2,15)   CLEN(13)
    TYPE(Get)  NAME(NABVYSHDw->cnazpracov)      FPOS(70,15  ) FLEN(37) PUSH(osb_osoby_sel) FCAPTION(kontaktní osoba)   CPOS(50,15)   CLEN(13)

    TYPE(MLE) NAME('NABVYSHDw->mpoznNab') FPOS( .5,16) SIZE(53,3.5) RESIZE(yx) SCROLL(ny)
    TYPE(MLE) NAME('NABVYSHDw->mpoznamka') FPOS(54 ,16) SIZE(54,3.5) RESIZE(yx) SCROLL(ny)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()
  TYPE(Text)  CAPTION(èísloSklPoložky)   CPOS( 4  ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                 CPOS(  .8,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(NABVYSITw->ccissklad) CPOS( 2  ,0.80) CLEN(11) CTYPE(2) GROUPS(SETFONT,7.Arial CE,GRA_CLR_RED)
  TYPE(Text)  CAPTION(])                 CPOS(16  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)

  TYPE(TEXT)  CAPTION(èíslo vyrPoložky)  CPOS(18  ,0.01) CLEN(13) CTYPE(1)
  TYPE(TEXT)  CAPTION(èíslo Výkresu)     CPOS(35  ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                 CPOS(17  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(NABVYSITw->ccisZakaz) CPOS(14  ,0.80) CLEN(30) CTYPE(1) GROUPS(SETFONT,7.Arial CE,GRA_CLR_RED)
  TYPE(Text)  CAPTION(])                 CPOS(49  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)

  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,19.7) CTYPE(3) PP(2) RESIZE(y,y)
   TYPE(DBrowse) FPOS(.15,9.8) SIZE(108.9,9.8) FILE(NABVYSITw)                  ;
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
*    TYPE(Get)  NAME(NABVYSITw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(NABVYSITw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(nabvyshd_z_sel)
    TYPE(GET)  NAME(nabvysitw->cvyrPol)    FPOS(18,1.2  ) FLEN(15) PP(2) PUSH(nabvyshd_z_sel)
    TYPE(GET)  NAME(nabvysitw->ccisVyk)    FPOS(35,1.2  ) FLEN(27) PP(2) PUSH(nabvyshd_z_sel)

    TYPE(Get)  NAME(NABVYSITw->cnazzbo)    FPOS( 1  ,2.3) FLEN(61) PP(2)

    TYPE(Text) CAPTION(nabízenoDne)        CPOS(75  ,1.3) CLEN(12) CTYPE(1) GROUPS(SETFONT,9.Cambria)
    TYPE(Text) NAME(NABVYSHDw->ddatOdes)   CPOS(76  ,2.3) CLEN(13) BGND(13) CTYPE(1) FONT(5)

    TYPE(Text) CAPTION(datumDodání)        CPOS(91  ,1.3) CLEN(12) CTYPE(1) GROUPS(SETFONT,9.Cambria)
    TYPE(Get)  NAME(NABVYSITw->ddatDoOdb)  FPOS(92  ,2.3) FLEN(13) PUSH(clickdate)

    TYPE(Text) CAPTION(nabízeno)          CPOS(16,3.5) CLEN( 9)

    TYPE(STATIC) FPOS(1,4) SIZE(107,4) STYPE(13) CTYPE(2) RESIZE(y,n)

* množství
      TYPE(Text) CAPTION(Množství v )         CPOS( 1,0.5) CLEN( 9)
      TYPE(Get)  NAME(NABVYSITw->nMnoznOdes)  FPOS(15,0.5) FLEN(13) PP(2)
      TYPE(Get)  NAME(NABVYSITw->czkratJedn)  FPOS(30,0.5) FLEN( 6) PP(2)
      TYPE(Text)  CAPTION(dph)                CPOS(40,0.5) CLEN( 5) CTYPE(1) GROUPS(SETFONT,8.Cambria)
      TYPE(Get)  NAME(NABVYSITw->NPROCDPH)    FPOS(48,0.5) FLEN( 7) PP(2)
      TYPE(Text)  CAPTION(%)                  CPOS(56,0.5) CLEN( 3) CTYPE(1) GROUPS(SETFONT,8.Cambria)

* ceny
      TYPE(Text) CAPTION(Ceny v )             CPOS( 1,2.7) CLEN( 7)
      TYPE(Text) NAME(NABVYSHDw->czkratmenZ)  CPOS( 9,2.7) CLEN( 5) CTYPE(1) FONT(5)

      TYPE(Text) CAPTION(cenaZákladní)        CPOS(15,1.7) CLEN(10)
      TYPE(Get)  NAME(NABVYSITw->ncenaZakl)   FPOS(15,2.7) FLEN(13) PUSH(KusTree)

      TYPE(Text) CAPTION(slevaZákladní)       CPOS(31,1.7) CLEN(11)
      TYPE(Get)  NAME(NABVYSITw->nhodnslev)   FPOS(31,2.7) FLEN(13)

      TYPE(Text) CAPTION([)                   CPOS(44,1.7) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABVYSITw->nprocslfao)  CPOS(45,1.7) CLEN( 5) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(+)                   CPOS(48,1.7) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABVYSITw->nprocslhot)  CPOS(50,1.7) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(+)                   CPOS(53,1.7) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(NABVYSITw->nprocslmno)  CPOS(55,1.7) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)
      TYPE(Text) CAPTION(])                   CPOS(58,1.7) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)

      TYPE(Get)  NAME(NABVYSITw->nprocslev)   FPOS(48,2.7) FLEN(7)
      TYPE(Text) CAPTION(%)                   CPOS(56,2.7) CLEN(3) CTYPE(1) GROUPS(SETFONT,8.Cambria)

      TYPE(Text) CAPTION(prodejní cena)       CPOS(61,1.7) CLEN(11) CTYPE(2)
      TYPE(Text) NAME(NABVYSITw->ncenJedZak)  CPOS(59,2.7) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)     CPOS(75,1.7) CLEN(13) CTYPE(2)
      TYPE(Text) NAME(NABVYSITw->ncenZakCel)  CPOS(75,2.7) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)       CPOS(95,1.7) CLEN(10) CTYPE(2)
      TYPE(Text) NAME(NABVYSITw->ncenZakCed)  CPOS(91,2.7) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Static) FPOS(.3,1.5) SIZE(107, .01) STTYPE(9)
      TYPE(End)
    TYPE(End)

    TYPE(Get) NAME(NABVYSITw->CDOPLNTXT)  FPOS( 1, 8.25) FLEN(100)    PP(2)

* memoEdit
    TYPE(PushButton) POS(105.0,8.25) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(nabvysitw->mpoznamka,0)
 TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(nabvysitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabvysitw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabvysitw->cciszakazi) FPOS(0,0) CLEN(0)
TYPE(Text) NAME(NABVYSITw->nklicdph)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabvysitw->nzboziKat)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabvysitw->nhmotnostJ) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(nabvysitw->nobjemJ)    FPOS(0,0) CLEN(0)
