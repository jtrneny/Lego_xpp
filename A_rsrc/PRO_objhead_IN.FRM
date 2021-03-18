TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava objednávky pøijaté ...) SIZE(110,29) ;
                                                                      FILE(OBJHEADw) POST(postValidate)

TYPE(Action) CAPTION(      ~Fakturace)      EVENT(set_fakVyshd_in) TIPTEXT(Uloží doklad a nabídne poøízení faktury vystavené) ICON1(101) ATYPE(3)


TYPE(ComboBox) NAME(OBJHEADw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()

TYPE(Static) FPOS(1,1.5) SIZE(108,5) STYPE(9) RESIZE(y) CTYPE(2)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .5)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .5) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .5) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .5) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.5) 
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.5) CLEN(31) BGND(13)

*  TYPE(TEXT) NAME(M->system_culice)  CPOS(15,2.5) CLEN(31) BGND(13)
*  TYPE(TEXT) NAME(M->system_cpsc)    CPOS(15,3.5) CLEN( 8) BGND(13)
*  TYPE(TEXT) NAME(M->system_csidlo)  CPOS(25,3.5) CLEN(21) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.7)                    FONT(6)   
  TYPE(TEXT) NAME(OBJHEADw->NICO)    CPOS(15,2.7)  CLEN(10) BGND(14) FONT(5) 
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26,2.7)  CLEN( 5)          
  TYPE(TEXT) NAME(OBJHEADw->CDIC)    CPOS(31,2.7)  CLEN(15) BGND(14) FONT(5)
  TYPE(TEXT) NAME(OBJHEADw->CNAZEV)  CPOS(15,3.7)  CLEN(31) BGND(14) FONT(5)

  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.6) RESIZE(yy)
    TYPE(GET)  NAME(OBJHEADw->ndoklad)      FPOS(24, 1  ) FLEN(13) FCAPTION(2. Objednávka èíslo) CPOS(4,1) PP(2) FONT(5) CLEN(19) NOREVISION()
    TYPE(Text) CAPTION(int_èísloObjednávky) CPOS( 6, 2.5) CLEN(15)
    TYPE(Text) NAME(OBJHEADw->ccislobint)   CPOS(24, 2.5) CLEN(28) BGND(13)
    TYPE(Get)  NAME(OBJHEADw->ccisobj)      FPOS(24, 3.6) FLEN(13) FCAPTION(èís_objOdbìratele)   CPOS(6,3.6) CLEN(16)
  TYPE(End)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,6.5) SIZE(110,22.1) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT() TABHEIGHT(.8)
  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1, 0.6) FONT(5)
  TYPE(TEXT) CAPTION(5. Zpùsob dopravy   :) CPOS(1, 4.6) FONT(5)
  TYPE(TEXT) CAPTION(6. Prodejce         :) CPOS(1, 8.6) FONT(5)
  TYPE(TEXT) CAPTION(7. Uplatnìní slev   :) CPOS(1,12.1) FONT(5) CLEN(16)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.2) SIZE(108.8,21) STYPE(9) RESIZE(yy)

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

* HORNI NAD FORMA ÚHRADY
    TYPE(STATIC) FPOS(40.01,9.8) SIZE(68.5,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(0.01,11.4) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* HORNI KURZ/PTØEPOÈET
    TYPE(STATIC) FPOS(40.01,13.1) SIZE(68.5,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ PDO KURZ/PTØEPOÈET
    TYPE(STATIC) FPOS(0.01,14.7) SIZE(108.8,.2) STYPE(9)  RESIZE(yx)
    TYPE(End)

    TYPE(Get)  NAME(OBJHEADw->NCISFIRMY)        FPOS(52, 0.5) FLEN(10) FCAPTION(3. Odbìratel )         CPOS(41, 0.5)  FONT(5) CLEN(11) PUSH(fir_firmy_sel) NOREVISION()
    TYPE(Text) CAPTION(Ièo)                     CPOS(65, 0.5) CLEN( 4) 
    TYPE(Get)  NAME(OBJHEADw->NICO)             FPOS(70,  .5) FLEN(10) 
    TYPE(Text) CAPTION(Diè)                     CPOS(84, 0.5) CLEN( 4)
    TYPE(Get)  NAME(OBJHEADw->CDIC)             FPOS(88,  .5) FLEN(15) 
    TYPE(Text) CAPTION(Název)                   CPOS(44, 1.5) CLEN( 6)   
    TYPE(Get)  NAME(OBJHEADw->CNAZEV)           FPOS(52, 1.5) FLEN(51) 
    TYPE(Get)  NAME(OBJHEADw->CNAZEV2)          FPOS(52, 2.5) FLEN(51)                                                
    TYPE(Text) CAPTION(Ulice)                   CPOS(44, 3.5) 
    TYPE(Get)  NAME(OBJHEADw->CULICE)           FPOS(52, 3.5) FLEN(51) 
    TYPE(Text) CAPTION(Místo)                   CPOS(44, 4.5)
    TYPE(Get)  NAME(OBJHEADw->CPSC)             FPOS(52, 4.5) FLEN(10)
    TYPE(Get)  NAME(OBJHEADw->CSIDLO)           FPOS(66, 4.5) FLEN(37)                                                
    TYPE(Text) CAPTION(Stát)                    CPOS(44, 5.5) 
    TYPE(Get)  NAME(OBJHEADw->CZKRATSTAT)       FPOS(52, 5.5) FLEN(10)
    TYPE(Text) NAME(c_staty->cnazevstat)        CPOS(66, 5.5) CLEN(37) 

    TYPE(Get)  NAME(OBJHEADw->ddatobj)            FPOS(57, 7.5) FLEN(12) PUSH(clickdate) FCAPTION(objednáno Dne) CPOS(44, 7.5) CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->ddatdoodb)          FPOS(89, 7.5) FLEN(12) PUSH(clickdate) FCAPTION(datum Dodání)  CPOS(77, 7.5) CLEN(12)
    TYPE(Get)  NAME(OBJHEADw->ddatodvvyr)         FPOS(89, 8.5) FLEN(12) PUSH(clickdate) FCAPTION(datum Výroby)  CPOS(77, 8.5) CLEN(12)
    TYPE(Get)  NAME(OBJHEADw->czkrtypuhr)         FPOS(57,10.1) FLEN(12)                 FCAPTION(forma Úhrady)  CPOS(44,10.1) CLEN(12)
    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR)          CPOS(72,10.1) CLEN(30) BGND(13)

    TYPE(GET)  NAME(OBJHEADw->CPRIJEMCE1)        FPOS( 2, 1.5) FLEN(25)
    TYPE(GET)  NAME(OBJHEADw->CPRIJEMCE2)        FPOS( 2, 2.5) FLEN(25)

    TYPE(Get)  NAME(OBJHEADw->CZKRZPUDOP)        FPOS( 2, 5.5) FLEN(25)
    TYPE(Text) CAPTION(èísloTrasy(pl/sk))        CPOS( 2, 6.7) CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->ccistrasyp)        FPOS(15, 6.7) FLEN(12) 
    TYPE(Text) NAME(OBJHEADw->ccistrasys)        CPOS(29, 6.7) CLEN(10) BGND(13)


    TYPE(Get)  NAME(OBJHEADw->czkrprodej)       FPOS( 2, 9.5) FLEN( 8)  
    TYPE(Text) NAME(c_prodej->cnazprodej)       CPOS(12, 9.5) CLEN(27) BGND(13)

    TYPE(Text) CAPTION([základní])              CPOS( 2,12.6) CLEN( 9)
    TYPE(Text) CAPTION(+)                       CPOS(11,12.6) CLEN( 2)
    TYPE(Text) CAPTION([hotovostní])            CPOS(14,12.6) CLEN(10)
    TYPE(Text) CAPTION(=)                       CPOS(26,12.6) CLEN( 2)
    TYPE(Text) CAPTION([celkem])                CPOS(30,12.6) CLEN(10)

    TYPE(Get)  NAME(OBJHEADw->nprocslfao)       FPOS( 2,13.6) FLEN( 6)  
    TYPE(Text) CAPTION(+)                       CPOS(11,13.6) CLEN( 2)
    TYPE(Get)  NAME(OBJHEADw->nprocslhot)       FPOS(14,13.6) FLEN( 8)
    TYPE(Text) CAPTION(=)                       CPOS(26,13.6) CLEN( 2)
    TYPE(Text) NAME(OBJHEADw->nprocslev)        CPOS(30,13.6) CLEN( 7)  BGND(13)  CTYPE(2)
 
      TYPE(ComboBox) FPOS(57,11.8) FLEN(25) NAME(OBJHEADw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(mìna/Kurz/Pøep) CPOS(44,11.8) PP(2)
    TYPE(Get) NAME(OBJHEADw->NKURZAHMEN)        FPOS(83,11.8) FLEN(10) 
*FCAPTION(Kurz/Pøep)            CPOS(44,13.3)   PP(2)
    TYPE(Get) NAME(OBJHEADw->NMNOZPREP)         FPOS(95,11.8) FLEN(6)                                                PP(2)

      TYPE(ComboBox) FPOS(57,13.5) FLEN(45) NAME(OBJHEADw->NSTAV_OBJP) ;   
                                          FCAPTION(stavDokladu) CPOS(44,13.5) PP(2) REF(cstavDokl)


    TYPE(Get)  NAME(OBJHEADw->cintpracov)       FPOS(14,15  ) FLEN(25) PUSH(osb_osoby_sel) FCAPTION(objednávku pøijal) CPOS( .2,15)   CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->cnazpracov)       FPOS(70,15  ) FLEN(37) PUSH(osb_osoby_sel) FCAPTION(kontaktní osoba)   CPOS(50,15)   CLEN(13)

    TYPE(MLE) NAME('OBJHEADw->mpoznobj' ) FPOS( .5,16) SIZE(53,4.5) RESIZE(yx) SCROLL(ny)
    TYPE(MLE) NAME('OBJHEADw->mpoznamka') FPOS(54 ,16) SIZE(54,4.5) RESIZE(yx) SCROLL(ny)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,6.5) SIZE(110,22.1) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT() TABHEIGHT(.8)
  TYPE(Text)  CAPTION(èísloSklPoložky)  CPOS( 4  ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                CPOS(  .8,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(OBJITEMw->ccissklad) CPOS( 2  ,0.80) CLEN(11) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                CPOS(16  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

*  TYPE(Text)  CAPTION(název zboží)      CPOS(19 ,0.01) CLEN(11) CTYPE(1)
 TYPE(Text)  CAPTION(èísloVystNabídky)  CPOS(19 ,0.01) CLEN(13) CTYPE(1)
  TYPE(Text)  CAPTION(>)                CPOS(47 ,3.95) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(text)  NAME(M->typ_objitem)      CPOS(49 ,3.80) CLEN(10)          GROUPS(SETFONT,10.Arial CE,GRA_CLR_RED) 
*  TYPE(Text)  CAPTION(])                CPOS(50 ,3.00) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  
  TYPE(Text)  CAPTION(rozlišení)        CPOS(45 ,0.01) CLEN( 8) CTYPE(1)
  TYPE(Text)  CAPTION(% dph)            CPOS(58 ,0.01) CLEN( 6) CTYPE(1)

  TYPE(Text)  CAPTION(objednánoDne)     CPOS(67 ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)      CPOS(81 ,0.01) CLEN(10) CTYPE(1)
  TYPE(Text)  CAPTION(datumVýroby)      CPOS(95 ,0.01) CLEN(11) CTYPE(1)


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,20.7) CTYPE(3) PP(2) 

   TYPE(DBrowse) FPOS(.15,10.8) SIZE(108.9,9.8) FILE(OBJITEMw)                  ;
                                               FIELDS(M->stav_objitemw::2.7::2, ;
                                                      M->stav_Svydw::2.7::2   , ;
                                                      csklpol:sklPoložka      , ;
                                                      cnazzbo:název zboží:36  , ;
                                                      nmnozobodb:množ_obj     , ;
                                                      nmnozpoodb:množ_povr    , ;
                                                      nkcsbdobj:cena_bezdanì  , ;
                                                      nkcszdobj:cena_sdaní      ) ;                                                      
                                               CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) POPUPMENU(nn)

* položka objednávky
    TYPE(Get)  NAME(OBJITEMw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(objhead_z_sel)
    TYPE(Get)  NAME(OBJITEMw->cnazOdes)   FPOS(19,1.2  ) FLEN(15) PP(2) PUSH(objhead_z_sel)
     TYPE(Text)  NAME(M->cenzboz_kDis)    CPOS( 2,2.2) CLEN(13) CTYPE(1) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)  

    TYPE(Get)  NAME(OBJITEMw->cnazzbo)    FPOS( 1,3.2  ) FLEN(44) PP(2)
    TYPE(Get)  NAME(OBJITEMw->crozatrpro) FPOS(45,1.2  ) FLEN(10) PP(2)
    TYPE(Text) NAME(OBJITEMw->nklicdph)   CPOS(59,1.2  ) CLEN( 0) BGND(13)
    TYPE(Text) NAME(M->procDph)           CPOS(58,1.2  ) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
*    TYPE(Text) NAME(M->datobj_hd)         CPOS(67,1.2  ) CLEN(12) BGND(13) CTYPE(1) FONT(5)
    TYPE(Get)  NAME(OBJITEMw->ddatobj)    FPOS(67,1.2)   FLEN(12) PUSH(clickdate)
    TYPE(Get)  NAME(OBJITEMw->ddatdoodb)  FPOS(81,1.2)   FLEN(12) PUSH(clickdate)
    TYPE(Get)  NAME(OBJITEMw->ddatodvvyr) FPOS(95,1.2  ) FLEN(12) PUSH(clickdate)

    TYPE(Text) CAPTION(èísloTrasy(pl/sk)) CPOS(66, 3.2  ) CLEN(14)
    TYPE(Get)  NAME(OBJITEMw->ccistrasyp) FPOS(81, 3.2  ) FLEN(12)
    TYPE(Text) NAME(OBJITEMw->ccistrasys) CPOS(95, 3.2  ) CLEN(13) BGND(13)

 
    TYPE(Text) CAPTION(objednáno)         CPOS(16,4.5) CLEN( 9)
    TYPE(Text) CAPTION(potvrzeno)         CPOS(32,4.5) CLEN( 9)
    TYPE(Text) CAPTION(k Výrobì)          CPOS(64,4.5) CLEN( 9) CTYPE(2)
    TYPE(Text) CAPTION(potvrVýrobou)      CPOS(77,4.5) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(potvrDokladem)     CPOS(94,4.5) CLEN(12) CTYPE(2)    


    TYPE(Text)  NAME(M->lastprocSlev)   CPOS(49,8.5) CLEN(10) CTYPE(1) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(STATIC) FPOS(1,5) SIZE(107,4) STYPE(9) CTYPE(3)

* množství
      TYPE(Text) CAPTION(Množství v )       CPOS( 1,0.5) CLEN( 9) 
      TYPE(Text) NAME(OBJITEMw->czkratjedn) CPOS(10,0.5) CLEN( 4) CTYPE(1) FONT(5)
* k dispozici
*      TYPE(Text)  CAPTION([)                CPOS(  .5,1.3) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
*      TYPE(Text)  NAME(cenZboz->nmnozDzbo)  CPOS( 2  ,1.3) CLEN(10) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
*      TYPE(Text)  CAPTION(])                CPOS(13  ,1.3) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

      TYPE(Get) NAME(OBJITEMw->nmnozobodb)  FPOS(15,0.5) FLEN(13) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozpoodb)  FPOS(31,0.5) FLEN(13) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozvpint)  FPOS(59,0.5) FLEN(12) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnpotvyr)   FPOS(75,0.5) FLEN(12) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozpdodb)  FPOS(91,0.5) FLEN(13) PP(2)     
* ceny
      TYPE(Text) CAPTION(Ceny v )           CPOS( 1,2.5) CLEN( 7) 
      TYPE(Text) NAME(OBJHEADw->czkratmenz) CPOS(10,2.5) CLEN( 5) CTYPE(1) FONT(5)

      TYPE(Text) CAPTION(cenaZákladní)      CPOS(15,1.5) CLEN(10)
      TYPE(Get)  NAME(OBJITEMw->ncenazakl)  FPOS(15,2.5) FLEN(13)   

      TYPE(Text) CAPTION(slevaZákladní)     CPOS(31,1.5) CLEN(11)
      TYPE(Get)  NAME(OBJITEMw->nhodnslev)  FPOS(31,2.5) FLEN(13)   

      TYPE(Text) CAPTION([)                 CPOS(44,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslfao) CPOS(45,1.5) CLEN( 5) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(+)                 CPOS(48,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslhot) CPOS(50,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(+)                 CPOS(53,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslmno) CPOS(55,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(])                 CPOS(58,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)   

      TYPE(Get)  NAME(OBJITEMw->nprocslev)  FPOS(47,2.5) FLEN(9) 

      TYPE(Text) CAPTION(prodejní cena)     CPOS(61,1.5) CLEN(11) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->ncenadlodb) CPOS(59,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)   CPOS(75,1.5) CLEN(13) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->nkcsbdobj)  CPOS(75,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)     CPOS(95,1.5) CLEN(10) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->nkcszdobj)  CPOS(91,2.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Static) FPOS(.3,1.5) SIZE(107, .01) STTYPE(9)
      TYPE(End)  
    TYPE(End)

    TYPE(Get) NAME(OBJITEMw->CDOPLNTXT)  FPOS( 1, 9.5) FLEN(100)    PP(2)
* memoEdit
    TYPE(PushButton) POS(105.0,9.55) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(objitemw->mpoznamka,0)
 TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(objitemw->nmnozPlOdb) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objitemw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objitemw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(MLE)  NAME(objitemw->mpoznamka)  FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(TEXT) NAME(objitemw->nzboziKat)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objitemw->nhmotnostJ) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objitemw->nobjemJ)    FPOS(0,0) CLEN(0)
 TYPE(Text) NAME(M->datobj_hd)        FPOS(0,0) CLEN(0) 

