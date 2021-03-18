TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava objednávky pøijaté ...) SIZE(110,29) FILE (OBJHEADw) POST(postValidate)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(109.2,11) STYPE(13) CTYPE(2) 
    TYPE(STATIC) FPOS(62,.01) SIZE(47,8.2) STYPE(11)  RESIZE(yx)
    TYPE(End)
* L
    TYPE(Get)  NAME(OBJHEADw->NCISFIRMY)          FPOS(75, .5) FLEN(10) FCAPTION(1. Odbìratel) CPOS(63, .5) PP(2) FONT(5) CLEN(11) PUSH(fir_firmy_sel)
    TYPE(Text) CAPTION(stát)                      CPOS(87, .5)
    TYPE(Text) NAME(FIRMY->czkratstat)            CPOS(92, .5) CLEN(15) BGND(13)
    TYPE(Text) CAPTION(Ièo)                       CPOS(67,1.5) CLEN( 5)
    TYPE(Text) NAME(FIRMY->nico)                  CPOS(75,1.5) CLEN(11) BGND(13)   
    TYPE(Text) CAPTION(Diè)                       CPOS(87,1.5) CLEN( 5)
    TYPE(Text) NAME(FIRMY->cdic)                  CPOS(92,1.5) CLEN(15) BGND(13)
    TYPE(Text) CAPTION(Název)                     CPOS(67,2.5) CLEN( 8)
    TYPE(Text) NAME(FIRMY->cnazev)                CPOS(75,2.5) CLEN(32) BGND(13)
    TYPE(Text) NAME(FIRMY->cnazev2)               CPOS(75,3.5) CLEN(32) BGND(13)
    TYPE(Text) CAPTION(Ulice)                     CPOS(67,4.5) CLEN( 8) 
    TYPE(Text) NAME(FIRMY->culice)                CPOS(75,4.5) CLEN(32) BGND(13)
    TYPE(Text) CAPTION(Psè)                       CPOS(67,5.5) CLEN( 8)
    TYPE(Text) NAME(FIRMY->cpsc)                  CPOS(75,5.5) CLEN(10) BGND(13)
    TYPE(Text) NAME(FIRMY->csidlo)                CPOS(87,5.5) CLEN(20) BGND(13)

* P
    TYPE(Text) CAPTION(èísloObjednávky)           CPOS( 1, .5) CLEN(13)
    TYPE(Text) NAME(OBJHEADw->ccislobint)          CPOS(14, .5) CLEN(15) BGND(13)
    TYPE(Get)  NAME(OBJHEADw->ccisobj)             FPOS(45, .5) FLEN(15) PP(2)           FCAPTION(objOdbìratele) CPOS(32, .5) CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->ddatobj)             FPOS(14,1.5) FLEN(14) PUSH(clickdate) FCAPTION(objednánoDne)  CPOS( 1,1.5) CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->ddatdoodb)           FPOS(45,1.5) FLEN(14) PUSH(clickdate) FCAPTION(datumDodání)   CPOS(32,1.5) CLEN(10)
    TYPE(Get)  NAME(OBJHEADw->ddatodvvyr)          FPOS(45,2.5) FLEN(14) PUSH(clickdate) FCAPTION(datumVýroby)   CPOS(32,2.5) CLEN(12)
    TYPE(Get)  NAME(OBJHEADw->czkrtypuhr)          FPOS(14,3.5) FLEN(14)                 FCAPTION(zpúsobÚhrady)  CPOS( 1,3.5) CLEN(12)

* dáme sem combo místo getu
    TYPE(Get)  NAME(OBJHEADw->czkratmeny)          FPOS(45,3.5) FLEN( 8)        FCAPTION(v mìnì)        CPOS(32,3.5) CLEN( 8)
    TYPE(Get)  NAME(OBJHEADw->czkrzpudop)          FPOS(14,4.5) FLEN(20)        FCAPTION(zpùsobDopravy) CPOS( 1,4.5) CLEN(13)
    TYPE(Get)  NAME(OBJHEADw->cmistoobj)           FPOS(36,4.5) FLEN(23)
    TYPE(Get)  NAME(OBJHEADw->cnazpracov)          FPOS(14,5.5) FLEN(45) PUSH() FCAPTION(odpPracovník)  CPOS( 1,5.5)   CLEN(13)

    TYPE(STATIC) FPOS(1,6.7) SIZE(59,1.5) STYPE(13)  RESIZE(yx) 
      TYPE(Get)  NAME(OBJHEADw->nprocslfao)   FPOS(13, .2)   FLEN(5)  FCAPTION(sleva základní) CPOS( 1, .2) CLEN(12)
      TYPE(Get)  NAME(OBJHEADw->nprocslhot)   FPOS(35, .2)   FLEN(5)  FCAPTION( + hotovostní)  CPOS(22, .2) CLEN(13)
      TYPE(Text) CAPTION(=)                  CPOS(45, .2)   CLEN(3)  
      TYPE(Text) NAME(OBJHEADw->nprocslev)    CPOS(50, .2)   CLEN(8)  BGND(13)  CTYPE(2)
    TYPE(End)

   TYPE(MLE) NAME('OBJHEADw->mpoznobj') FPOS(1,8.5) SIZE(107,2) RESIZE(yx) SCROLL(ny)
  TYPE(End)

*
  TYPE(Text)  CAPTION(èísloSklPoložky)  CPOS( 4,11  ) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                CPOS( 1,11.6) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(OBJITEMw->ccissklad) CPOS( 2,11.7) CLEN(11) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                CPOS(16,11.6) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

  TYPE(Text)  CAPTION(název zboží)      CPOS(19,11  ) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                CPOS(19,11.6) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(text)  NAME(M->typ_objitem)      CPOS(22,11.7) CLEN(10) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                CPOS(39,11.6) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  
  TYPE(Text)  CAPTION(% dph)            CPOS(58,11  ) CLEN( 6) CTYPE(1)

  TYPE(Text)  CAPTION(objednánoDne)     CPOS(67,11  ) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)      CPOS(82,11  ) CLEN(10) CTYPE(1)
  TYPE(Text)  CAPTION(datumVýroby)      CPOS(96,11  ) CLEN(12) CTYPE(1)

  TYPE(STATIC) FPOS(.5,11.5) SIZE(109.2,17.2) STYPE(9)  CTYPE(2)
*    TYPE(Browse) FPOS(.15,7.1) SIZE(108.9,9.8) FILE(OBJITEMw)                  ;
*                                              FIELDS(M->stav_objitemw::2.7::2, ;
*                                                     csklpol:sklPoložka      , ;
*                                                     cnazzbo:název zboží:36  , ;
*                                                     nmnozobodb:množ_obj     , ;
*                                                     nmnozpoodb:množ_povr    , ;
*                                                     nkcsbdobj:cena_bezdanì  , ;
*                                                     nkcszdobj:cena_sdaní      ) ;                                                      
*                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy)


    TYPE(Get)  NAME(OBJITEMw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(OBJITEMw->cnazzbo)    FPOS(19,1.2  ) FLEN(36) PP(2)
    TYPE(Text) NAME(OBJITEMw->nklicdph)   CPOS(59,1.2  ) CLEN( 0) BGND(13)
    TYPE(Text) NAME(M->procDph)           CPOS(58,1.2  ) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) NAME(OBJHEADw->ddatobj)    CPOS(67,1.2  ) CLEN(12) BGND(13) CTYPE(1) FONT(5)
    TYPE(Get)  NAME(OBJITEMw->ddatdoodb)  FPOS(80.5,1.2) FLEN(12) PUSH(clickdate)
    TYPE(Get)  NAME(OBJITEMw->ddatodvvyr) FPOS(95,1.2  ) FLEN(12) PUSH(clickdate)

    TYPE(Text) CAPTION(objednáno)         CPOS(16,2.5) CLEN( 9)
    TYPE(Text) CAPTION(potvrzeno)         CPOS(32,2.5) CLEN( 9)
    TYPE(Text) CAPTION(k Výrobì)          CPOS(64,2.5) CLEN( 9) CTYPE(2)
    TYPE(Text) CAPTION(potvrVýrobou)      CPOS(77,2.5) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(potvrDokladem)     CPOS(94,2.5) CLEN(12) CTYPE(2)    

    TYPE(STATIC) FPOS(1,3) SIZE(107,3.8) STYPE(13) CTYPE(2)
* množství
      TYPE(Text) CAPTION(Množství v )       CPOS( 1,0.5) CLEN( 9) 
      TYPE(Text) NAME(OBJITEMw->czkratjedn)  CPOS(10,0.5) CLEN( 4) CTYPE(1) FONT(5)

      TYPE(Get) NAME(OBJITEMw->nmnozobodb)  FPOS(15,0.5) FLEN(13) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozpoodb)  FPOS(31,0.5) FLEN(13) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozvpint)  FPOS(59,0.5) FLEN(12) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnpotvyr)   FPOS(75,0.5) FLEN(12) PP(2)
      TYPE(Get) NAME(OBJITEMw->nmnozpdodb)  FPOS(91,0.5) FLEN(13) PP(2)     
* ceny
      TYPE(Text) CAPTION(Ceny v )           CPOS( 1,2.5) CLEN( 7) 
      TYPE(Text) NAME(OBJHEADw->czkratmeny) CPOS(10,2.5) CLEN( 4) CTYPE(1) FONT(5)

      TYPE(Text) CAPTION(cenaZákladní)      CPOS(15,1.5) CLEN(10)
      TYPE(Get)  NAME(OBJITEMw->ncenazakl)  FPOS(15,2.5) FLEN(13)   

      TYPE(Text) CAPTION(slevaZákladní)     CPOS(31,1.5) CLEN(11)
      TYPE(Get)  NAME(OBJITEMw->nhodnslev)  FPOS(31,2.5) FLEN(13)   

      TYPE(Text) CAPTION([)                 CPOS(44,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslfao) CPOS(45,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(+)                 CPOS(48,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslhot) CPOS(50,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(+)                 CPOS(53,1.5) CLEN( 3) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(OBJITEMw->nprocslmno) CPOS(55,1.5) CLEN( 4) PICTURE(@N 99.9) CTYPE(2)  
      TYPE(Text) CAPTION(])                 CPOS(58,1.5) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)   

      TYPE(Get)  NAME(OBJITEMw->nprocslev)  FPOS(48,2.5) FLEN(7)   

      TYPE(Text) CAPTION(prodejní cena)     CPOS(61,1.5) CLEN(11) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->ncenadlodb) CPOS(59,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)   CPOS(75,1.5) CLEN(13) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->nkcsbdobj)  CPOS(75,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)     CPOS(95,1.5) CLEN(10) CTYPE(2)
      TYPE(Text) NAME(OBJITEMw->nkcszdobj)  CPOS(91,2.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Static) FPOS(.3,1.5) SIZE(107, .01) STTYPE(9)
      TYPE(End)  
    TYPE(End)

    TYPE(Browse) FPOS(.15,7.1) SIZE(108.9,9.8) FILE(OBJITEMw)                  ;
                                              FIELDS(M->stav_objitemw::2.7::2, ;
                                                     csklpol:sklPoložka      , ;
                                                     cnazzbo:název zboží:36  , ;
                                                     nmnozobodb:množ_obj     , ;
                                                     nmnozpoodb:množ_povr    , ;
                                                     nkcsbdobj:cena_bezdanì  , ;
                                                     nkcszdobj:cena_sdaní      ) ;                                                      
                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy)
  TYPE(End)
