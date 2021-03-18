TYPE(drgForm) DTYPE(10) TITLE(Likvidace ) SIZE(110,26) FILE (FAKVNPHDw)  ;
                                          POST(postValidate)             ;
                                          GUILOOK(Action:n)


  TYPE(STATIC) FPOS(0.4,0.2) SIZE(109.2,7) STYPE(13) CTYPE(2) GROUPS(HD)
    TYPE(ComboBox) NAME(fakVNPhdW->cTYPPOHYBU) FPOS( 1,  .4) FLEN(30) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ITEMMARKED(comboItemSelected) NOREVISION()
    TYPE(COMBOBOX) NAME(M->obdLikv)            FPOS( 76, .5) FLEN(16) FCAPTION(OBD_úè _____)       CPOS(63, .5) CLEN(13) VALUES(a,a,a,a)  FONT(5)

    TYPE(Get)      NAME(FAKVNPHDw->dVYSTFAK)   FPOS( 19,1.5) FLEN(11) FCAPTION(Datum poøízení _)   CPOS(  1,1.5) CLEN(15) PUSH(CLICKDATE) FONT(5) NOREVISION()
    TYPE(Get)      NAME(FAKVNPHDw->nCISFAK)    FPOS( 48,1.5) FLEN(11) FCAPTION(èíslo Faktury ___)  CPOS( 33,1.5) CLEN(15) FONT(5)                 NOREVISION()
    TYPE(Get)      NAME(FAKVNPHDw->CVARSYM)    FPOS( 76,1.5) FLEN(15) FCAPTION(varSymbol ____)     CPOS( 63,1.5) CLEN(13)                         NOREVISION()  

    TYPE(Get)      NAME(FAKVNPHDw->cNAZPOL1)   FPOS( 19,2.5) FLEN(11) FCAPTION(Dodavatel _____)    CPOS( 1,2.5) CLEN(15)  FONT(5)                 NOREVISION()   
    TYPE(Text)     NAME(dod_stred->cnazev)     CPOS( 33,2.5) CLEN(40) 

    TYPE(Get)      NAME(FAKVNPHDw->cNAZPOL1O)  FPOS( 19,3.5) FLEN(11) FCAPTION(Odbìratel ___)      CPOS( 1,3.5) CLEN(15)  FONT(5)                 NOREVISION() 
    TYPE(Text)     NAME(odb_stred->cnazev)     CPOS( 33,3.5) CLEN(40)  

    TYPE(Get)      NAME(FAKVNPHDw->cJMENOVYS)  FPOS( 76,4.5) FLEN(30) FCAPTION(Vystavil ___)       CPOS( 63,4.5) CLEN(13) PUSH(osb_osoby_sel)     NOREVISION() 
    TYPE(Get)      NAME(FAKVNPHDw->cTEXTFAKT)  FPOS(15,5.5) FLEN(43) FCAPTION(Text faktury ___)    CPOS( 1,5.5) CLEN(13)                          NOREVISION()   

    TYPE(Text)    CAPTION(Celkem faktura ________) CPOS( 63,5.5) CLEN(20)
    TYPE(Text) NAME(FAKVNPHDw->nCENZAKCEL)         CPOS( 90,5.5) CLEN(13) BGND(13) CTYPE(2) FONT(5)
    TYPE(Text) NAME(FAKVNPHDw->cZKRATMENY)         CPOS(103,5.5) CLEN( 4) BGND(13) 
  TYPE(End)


  TYPE(STATIC) FPOS(0.4,7.5) SIZE(109.2,18) STYPE(12) CTYPE(2)
    TYPE(STATIC) STYPE(12) SIZE(109.2,7) FPOS(0,0) CTYPE(2)
* 1
      TYPE(GET) NAME(FAKVNPITw->cucet)        FPOS(15, .5) FLEN(10) FCAPTION(SuAu_Ø)        CPOS( 1, .5) PP(2) GROUPS(1)
      TYPE(Text) NAME(M->cnaz_ucet)           CPOS(27, .5) CLEN(27) 
      TYPE(GET)  NAME(fakVnpitW->ncenZAKcel)  FPOS(76, .5) FLEN(13) FCAPTION(celkem_Dod)    CPOS(63, .5) PICTURE(@N 999999999999.99)
      TYPE(TEXT) NAME(M->mena_Dod)            CPOS(91, .5) CLEN( 6) BGND(13)      
* 2
      TYPE(GET) NAME(FAKVNPITw->cucet_Uct)    FPOS(15, 1.5) FLEN(10) FCAPTION(SuAu_S)       CPOS( 1, 1.5) PP(2) GROUPS(1)
      TYPE(Text) NAME(M->cnaz_ucet_Uct)       CPOS(27, 1.5) CLEN(27) 
      TYPE(GET)  NAME(fakVnpitW->ncenZAKlik)  FPOS(76, 1.5) FLEN(13) FCAPTION(celkem_Odb)   CPOS(63,1.5) PICTURE(@N 999999999999.99)
      TYPE(TEXT) NAME(M->mena_Odb)            CPOS(91, 1.5) CLEN( 6) BGND(13)   
* 3 
      TYPE(GET)  NAME(FAKVNPITw->nFAKTmnoz)   FPOS(76, 2.5) FLEN(13) FCAPTION(možsví_Pol)   CPOS(63,2.5)
      TYPE(GET)  NAME(FAKVNPITw->cZKRATjedn)  FPOS(91, 2.5) FLEN( 5) 
* 4
      TYPE(GET) NAME(FAKVNPITw->cnazZbo)      FPOS(15, 3.5) FLEN(35) FCAPTION(text_Položky) CPOS( 1,3.5)
      TYPE(GET)  NAME(FAKVNPITw->nFAKTmno2)   FPOS(76, 3.5) FLEN(13) FCAPTION(možsví_Pol_2) CPOS(63,3.5)
      TYPE(GET)  NAME(FAKVNPITw->cZKRATjed2)  FPOS(91, 3.5) FLEN( 5)

* NS
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL1) FPOS(  3,5.7) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.7) CLEN(10)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL2) FPOS( 19,5.7) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.7) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL3) FPOS( 35,5.7) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.7) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL4) FPOS( 51,5.7) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.7) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL5) FPOS( 67,5.7) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.7) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL6) FPOS( 83,5.7) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.7) CLEN(10)  

    TYPE(STATIC) FPOS( .2,5) SIZE(108.6,.3) STYPE(12) GROUPS(IT)
    TYPE(End)
 TYPE(End)

    TYPE(DBrowse) FPOS(.15,7.2) SIZE(108.9,11) FILE(FAKVNPITw)                         ;
                                                FIELDS(M->stavPol::2.7::2             , ;
                                                       M->orditem:polDok:6            , ;
                                                       M->subUcto::5::2               , ;
                                                       cNAZZBO:text_Položky:33        , ;                                                      
                                                       nFAKTMNOZ:faktMnož:10          , ;
                                                       czkratjedn:mj                  , ;
                                                       cucet:SuAu_Ø                   , ;
                                                       M->celkem_Dod:celkem_Dod:13    , ;
                                                       M->celkem_Odb:celkem_Odb:13    , ;  
                                                       cucet_uct:SuAu_S               , ;
                                                       M->typ_Pol::4                    ) ;
                                                CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) FOOTER(y) STABLEBLOCK(stableBlock)

  TYPE(End)



