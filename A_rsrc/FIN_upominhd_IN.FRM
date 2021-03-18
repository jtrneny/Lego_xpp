TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava upomínky ...) SIZE(100,23) FILE(UPOMINHDw)             ;
                                                                         GUILOOK(Action:n,IconBar:y) ;
                                                                         POST(postValidate)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,8.2) STYPE(14) CTYPE(2)
    TYPE(STATIC) FPOS(45,0) SIZE(.5,8.05) STYPE(14) CTYPE(2)
    TYPE(END)

    TYPE(STATIC) FPOS(45,6.5) SIZE(54,.05) STYPE(14) CTYPE(2)
    TYPE(END)

*    TYPE(STATIC) FPOS(45,6.5) SIZE(54,1.55) STYPE(14) CTYPE(2)
*    TYPE(END)
* L
    TYPE(TEXT) CAPTION(dodavatel)      CPOS( 1, .6) CLEN(15) FONT(5)
    TYPE(TEXT) CAPTION(ièo/diè)        CPOS( 1,2.2) CLEN( 6)
    TYPE(TEXT) NAME(M->SYSTEM_nico)    CPOS( 7,2.2) CLEN(15) BGND(13) 
    TYPE(TEXT) CAPTION(/)              CPOS(23,2.2) CLEN(2) 
    TYPE(TEXT) NAME(M->SYSTEM_cdic)    CPOS(26,2.2) CLEN(15) BGND(13)
    TYPE(TEXT) NAME(M->SYSTEM_cpodnik) CPOS( 7,3.2) CLEN(34) BGND(13)
    TYPE(TEXT) NAME(M->SYSTEM_culice)  CPOS( 7,4.2) CLEN(34) BGND(13)
    TYPE(TEXT) NAME(M->SYSTEM_cpsc)    CPOS( 7,5.2) CLEN( 8) BGND(13)
    TYPE(TEXT) NAME(M->SYSTEM_csidlo)  CPOS(17,5.2) CLEN(24) BGND(13)

* P
    TYPE(GET)  NAME(UPOMINHDw->nCISFIRMY)  FPOS(57, .2) FLEN(10) PP(2) FCAPTION(odbìratel) CPOS(46, .2) PUSH(FIN_upominhd_fir_SEL) FONT(5)
    TYPE(GET)  NAME(UPOMINHDw->CZKRATSTAT) FPOS(74, .2) FLEN(10) PP(2) FCAPTION(stát)      CPOS(69, .2)
    TYPE(GET)  NAME(UPOMINHDw->NICO)       FPOS(57,1.2) FLEN(10)       FCAPTION(ièo/diè)   CPOS(50,1.2) 
*    TYPE(TEXT) CAPTION(/) CPOS(69,1.2) CLEN(2) 
    TYPE(GET)  NAME(UPOMINHDw->CDIC)       FPOS(72,1.2) FLEN(12) 
    TYPE(GET)  NAME(UPOMINHDw->CNAZEV)     FPOS(57,2.2) FLEN(27)       FCAPTION(název)     CPOS(50,2.2)
    TYPE(GET)  NAME(UPOMINHDw->CNAZEV2)    FPOS(57,3.2) FLEN(27)
    TYPE(GET)  NAME(UPOMINHDw->CULICE)     FPOS(57,4.2) FLEN(27)       FCAPTION(ulice)     CPOS(50,4.2)
    TYPE(GET)  NAME(UPOMINHDw->CPSC)       FPOS(57,5.2) FLEN( 8)       FCAPTION(obec)      CPOS(50,5.2)
    TYPE(GET)  NAME(UPOMINHDw->CSIDLO)     FPOS(69,5.2) FLEN(25)  

    TYPE(GET)  NAME(UPOMINHDw->nCISUPOMIN) FPOS(57,6.8) FLEN(10)       FCAPTION(èísUpom)   CPOS(46,6.8) FONT(5)
    TYPE(GET)  NAME(UPOMINHDw->dUPOMINKY)  FPOS(83,6.8) FLEN(12)       FCAPTION(ze dne)    CPOS(70,6.8) FONT(5) PUSH(CLICKDATE)
  TYPE(End)

* IT
  TYPE(TEXT) CAPTION(èíslo Faktury)    CPOS( 1,9) CLEN(12)
  TYPE(TEXT) CAPTION(název Odbìratele) CPOS(17,9)
  TYPE(TEXT) CAPTION(splatnáDne)       CPOS(46,9)
  TYPE(TEXT) CAPTION(úhradaDne)        CPOS(60,9)
  TYPE(TEXT) CAPTION(celkem Faktura)   CPOS(74,9) CLEN(12)
  TYPE(TEXT) CAPTION(v)                CPOS(91,9) CLEN( 2)

  TYPE(STATIC) FPOS(0.4,9.5) SIZE(99.2,13.4) STYPE(12)  CTYPE(1)
    TYPE(GET)    NAME(UPOMINITw->nCISFAK)    FPOS( 1, .5) FLEN(12) PP(2) PUSH(FIN_upominit_fv_SEL) 
    TYPE(TEXT)   NAME(UPOMINITw->cNAZEV)     CPOS(17, .5) BGND(13)
    TYPE(TEXT)   NAME(UPOMINITw->dSPLATFAK)  CPOS(46, .5) BGND(13)
    TYPE(TEXT)   NAME(UPOMINITw->dPOSUHRFAK) CPOS(60, .5) BGND(13)
    TYPE(TEXT)   NAME(UPOMINITw->nCENZAKCEL) CPOS(74, .5) BGND(13) CTYPE(2) CLEN(14)
    TYPE(TEXT)   NAME(UPOMINITw->cZKRATMENY) CPOS(90, .5) CLEN( 5) FONT(5)

* NÁVRH UPOMÍNKY
    TYPE(TEXT)  CAPTION(Návrh upomínky)  CPOS( 2,2) CLEN(15) FONT(5)
    TYPE(TEXT)  CAPTION(dny poSplatn)    CPOS(60,2) CLEN(12) FONT(5)
    TYPE(TEXT)  CAPTION(èástka Upomínky) CPOS(74,2) CLEN(15) FONT(5) 

    TYPE(STATIC) FPOS(0.4,2.5) SIZE(98.6,.1) STYPE(13)
    TYPE(End)

    TYPE(GET)   NAME(UPOMINITw->cDOPLNTXT)  FPOS( 1,3) FLEN(54)
    TYPE(GET)   NAME(UPOMINITw->nDNYPREK)   FPOS(60,3) FLEN( 9) PP(2)
    TYPE(GET)   NAME(UPOMINITw->nCENUPOCEL) FPOS(74,3) FLEN(13) POST(postLastField) 
    TYPE(TEXT)  NAME(UPOMINITw->cZKRATMENY) CPOS(90,3) CLEN( 5) FONT(5)

    TYPE(DBrowse) FPOS(.2,4.5) SIZE(98.8,8.8) FILE(UPOMINITw)                     ;
                                              FIELDS( nINTCOUNT:polUpom         , ; 
                                                      nCISFAK:èíslo Faktury     , ;
                                                      cVARSYM:varSymbol         , ;
                                                      cDOPLNTXT:text Upomínky:40, ;
                                                      nDNYPREK:poSplan          , ;
                                                      nCENUPOCEL:èástkaUpom       ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemMarked)
  TYPE(END) 