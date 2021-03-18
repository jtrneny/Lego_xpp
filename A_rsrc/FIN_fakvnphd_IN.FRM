TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava vnitroPodnikové faktury ...) SIZE(110,26) FILE (FAKVNPHDw) ;                                                                                       
                                                                                        PRE(preValidate) POST(postValidate)


  TYPE(Action) CAPTION(      ~Likvidace)      EVENT(set_likvidace_in) TIPTEXT(Uloží doklad a nabídne likvidaci faktury vystavené) ICON1(101) ATYPE(3)


  TYPE(STATIC) FPOS(0.4,0.2) SIZE(109.2,7) STYPE(13) CTYPE(2) 
    TYPE(ComboBox) NAME(fakVNPhdW->cTYPPOHYBU) FPOS( 1,  .4) FLEN(30) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ITEMMARKED(comboItemSelected) NOREVISION()
    TYPE(COMBOBOX) NAME(FAKVNPHDw->COBDOBI)    FPOS( 76, .5) FLEN(16) FCAPTION(OBD_úè _____)       CPOS(63, .5) CLEN(13) VALUES(a,a,a,a) PP(2) FONT(5)

    TYPE(Get)      NAME(FAKVNPHDw->dVYSTFAK)   FPOS( 18,1.5) FLEN(12) FCAPTION(Datum poøízení _)   CPOS(  1,1.5) CLEN(15) PUSH(CLICKDATE) FONT(5) NOREVISION()
    TYPE(Get)      NAME(FAKVNPHDw->nCISFAK)    FPOS( 48,1.5) FLEN(11) FCAPTION(èíslo Faktury ___)  CPOS( 33,1.5) CLEN(15) FONT(5)                 NOREVISION()
    TYPE(Get)      NAME(FAKVNPHDw->cVARSYM)    FPOS( 76,1.5) FLEN(15) FCAPTION(varSymbol ____)     CPOS( 63,1.5) CLEN(13) 

    TYPE(Get)      NAME(FAKVNPHDw->cNAZPOL1)   FPOS( 18,2.5) FLEN(12) FCAPTION(Dodavatel _____)    CPOS( 1,2.5) CLEN(15)  FONT(5)                NOREVISION()   
    TYPE(Text)     NAME(dod_stred->cnazev)     CPOS( 33,2.5) CLEN(30) PP(2) 

    TYPE(Get)      NAME(FAKVNPHDw->cNAZPOL1O)  FPOS( 18,3.5) FLEN(12) FCAPTION(Odbìratel ___)      CPOS( 1,3.5) CLEN(15)  FONT(5)                NOREVISION() 
    TYPE(Text)     NAME(odb_stred->cnazev)     CPOS( 33,3.5) CLEN(31) PP(2) 

*    TYPE(Get)      NAME(fakVNPhdW->cUCET_UCT)  FPOS( 19,4.5) FLEN(11) FCAPTION(SuAu_Ø )            CPOS(  1,4.5) PP(2)
*    TYPE(Text)     NAME(M->CNAZ_UCT_HD)        CPOS( 33,4.5) CLEN(24) 
    TYPE(Get)      NAME(FAKVNPHDw->cJMENOVYS)  FPOS( 76,4.5) FLEN(30) FCAPTION(Vystavil ___)       CPOS( 63,4.5) CLEN(13) PUSH(osb_osoby_sel)

    TYPE(Get)      NAME(FAKVNPHDw->cTEXTFAKT)  FPOS(15,5.5) FLEN(43) FCAPTION(Text faktury ___)    CPOS( 1,5.5) CLEN(13) 

    TYPE(Text)    CAPTION(Celkem faktura ________) CPOS( 63,5.5) CLEN(20)
    TYPE(Text) NAME(FAKVNPHDw->nCENZAKCEL)         CPOS( 90,5.5) CLEN(13) BGND(13) CTYPE(2) FONT(5)
    TYPE(Text) NAME(FAKVNPHDw->cZKRATMENY)         CPOS(103,5.5) CLEN( 4) BGND(13) 
  TYPE(End)

*
  TYPE(Text)  CAPTION(èísloDodListu)      CPOS(  4,7.01) CLEN(10) CTYPE(2)
  TYPE(Text)  CAPTION(èísloVýrZakázky)    CPOS( 21,7   ) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS( 17,7.75 ) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(FAKVNPITw->cskp)       CPOS( 18,7.75 ) CLEN(11) CTYPE(1) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                  CPOS( 33,7.75 ) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
 
  TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 38,7.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS( 34,7.75 ) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(FAKVNPITw->ccissklad)  CPOS( 35,7.75 ) CLEN(11) CTYPE(1) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                  CPOS( 50,7.75 ) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 

  TYPE(Text)  CAPTION(Text položky)       CPOS( 70,7.6)  CLEN(12) FONT(5)

*
  TYPE(STATIC) FPOS(0.4,7.5) SIZE(109.2,19) STYPE(12)  CTYPE(2)
*
    TYPE(Get) NAME(FAKVNPITw->NCISLODL)   FPOS( 1,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)
    TYPE(Get) NAME(FAKVNPITw->CCISZAKAZI) FPOS(18,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)
    TYPE(Get) NAME(FAKVNPITw->CSKLPOL)    FPOS(35,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)

    TYPE(Get) NAME(FAKVNPITw->CNAZZBO)    FPOS(70,1.2) FLEN(36) PP(2)

    TYPE(Text) CAPTION(Výpoèet položky)  CPOS( 2,4) CLEN(13) 
    TYPE(Text) CAPTION(množství)         CPOS(24,3) CLEN(7) 
    TYPE(Text) CAPTION(mj)               CPOS(38,3) CLEN(3)      
    TYPE(Text) CAPTION(cena/mj)          CPOS(54,3) CLEN(7)      
    TYPE(Text) CAPTION(celkem)           CPOS(98,3) CLEN(6)      

    TYPE(STATIC) STYPE(12) SIZE(107,1.7) FPOS(1,3.6) 
      TYPE(Get)  NAME(FAKVNPITw->nFAKTMNOZ)     FPOS(19,.3) FLEN(13) PP(2) 
      TYPE(Get)  NAME(FAKVNPITw->cZKRATJEDN)    FPOS(34,.3) FLEN( 6) PUSH()
      TYPE(Text) CAPTION(*)                     CPOS(44,.3) CLEN( 3) FONT(5)
      TYPE(Get)  NAME(FAKVNPITw->nCENAZAKL)     FPOS(49,.3) FLEN(13)
      TYPE(Text) CAPTION(=)                     CPOS(76,.3) CLEN( 3) FONT(5)
      TYPE(Text) NAME(FAKVNPITw->nCENZAKCEL)    CPOS(93,.3) CLEN(13) PP(2) BGND(13) CTYPE(2)
    TYPE(End)

    TYPE(Get)  NAME(FAKVNPITw->cDOPLNTXT) FPOS( 1,5.9) FLEN(51)
    TYPE(Get)  NAME(FAKVNPITw->cUCET)     FPOS(75,5.9) FLEN(10) FCAPTION(Úèet tržeb) CPOS(57,5.9)
    TYPE(TEXT) NAME(C_UCTOSN->cNAZ_UCT)   CPOS(87,5.9) CLEN(21) BGND(13) PP(1)   

* NS
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL1) FPOS(  3,7.9) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,6.85) CLEN(10)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL2) FPOS( 21,7.9) FLEN(10) FCAPTION(Výrobek)      CPOS(21,6.85) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL3) FPOS( 39,7.9) FLEN(10) FCAPTION(Zakázka)      CPOS(39,6.85) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL4) FPOS( 57,7.9) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,6.85) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL5) FPOS( 75,7.9) FLEN(10) FCAPTION(Stroj)        CPOS(75,6.85) CLEN( 8)
    TYPE(GET) NAME(FAKVNPITw->cNAZPOL6) FPOS( 93,7.9) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,6.85) CLEN(10) 

    TYPE(STATIC) FPOS(0.4,7.4) SIZE(108.6,.1) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS(.15,9.4) SIZE(108.9,9.4) FILE(FAKVNPITw)                         ;
                                                FIELDS(nINTCOUNT:podDokl              , ;
                                                       cSKLPOL:sklPoložka             , ;
                                                       cNAZZBO:název zboží:24         , ;
                                                       nFAKTMNOZ:faktMnož             , ;
                                                       czkratjedn:mj                  , ; 
                                                       nCENAZAKL:cenaZaJedn           , ;
                                                       M->dod_cenzakcel:dod_celkem:13 , ;
                                                       M->odb_cenzakcel:odb_celkem:13   );
                                                CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) FOOTER(y)

  TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(fakvnpitw->ncisPOLzak)  FPOS(0,0) CLEN(0)

TYPE(TEXT) NAME(fakvnpitw->cfile_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvnpitw->nrecs_iv)    FPOS(0,0) CLEN(0)

