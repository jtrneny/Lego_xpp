TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava vzájemného zápoètu ...) SIZE(100,26) FILE (BANVYPITw)   ;
                                                                                   POST(postValidate) ;
                                                                                   GUILOOK(Action:n,IconBar:n)


  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,6) STYPE(13) CTYPE(2) 
* L
    TYPE(Get)      NAME(BANVYPHDw->nICO)        FPOS(11,0.5) FLEN(15) FCAPTION(Ièo ...)        CPOS( 1, .5) PUSH(FIN_FIRMY_ICO_SEL)
    TYPE(Text)     CAPTION(Firma ...)           CPOS( 1,1.5) 
    TYPE(Text)     NAME(BANVYPHDw->cNAZEV)      CPOS(11,1.5) CLEN(36) BGND(13)
    TYPE(Get)      NAME(BANVYPHDw->cUCET_UCT)   FPOS(11,2.5) FLEN(10) FCAPTION(SuAu_Ø ...)     CPOS( 1,2.5)
    TYPE(Get)      NAME(BANVYPHDw->nDOKLAD)     FPOS(11,3.5) FLEN(10) FCAPTION(Doklad ...)     CPOS( 1,3.5)
    TYPE(Get)      NAME(BANVYPHDw->dDATPORIZ)   FPOS(36,3.5) FLEN(10) FCAPTION(ze dne)         CPOS(26,3.4) CLEN(10)
    TYPE(ComboBox) NAME(BANVYPHDw->CZKRATMENY)  FPOS(11,4.5) FLEN(36) FCAPTION(Mìna mìna ... ) CPOS( 1,4.5) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)

* P
    TYPE(Get)  NAME(BANVYPHDw->cOBDOBI)     FPOS(86, .5) FLEN( 5) FCAPTION(Období)  CPOS(78, .5) FONT(5)       
    TYPE(Text) CAPTION(Ve prospìch úètu)    CPOS(55,2.5)          FONT(5)
**
    TYPE(Text) NAME(BANVYPHDw->nPRIJEM)     CPOS(78,2.5) CLEN(14) CTYPE(2) BGND(13)
    TYPE(Text) NAME(BANVYPHDw->nPRIJEMz)    CPOS(78,2.5) CLEN(14) CTYPE(2) BGND(13)
*
    TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)  CPOS(94,2.5) CLEN( 4)          BGND(13)
    TYPE(Text) CAPTION(Na vrub úètu)        CPOS(55,3.5)          FONT(5)
**
    TYPE(Text) NAME(BANVYPHDw->nVYDEJ)      CPOS(78,3.5) CLEN(14) CTYPE(2) BGND(13)
    TYPE(Text) NAME(BANVYPHDw->nVYDEJz)     CPOS(78,3.5) CLEN(14) CTYPE(2) BGND(13)
*
    TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)  CPOS(94,3.5) CLEN( 4)          BGND(13)
    TYPE(TEXT) CAPTION(Rozdíl ...)          CPOS(55,4.5) 
    TYPE(Text) NAME(BANVYPHDw->nZUSTATEK)   CPOS(78,4.5) CLEN(14) CTYPE(2) BGND(13)
    TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)  CPOS(94,4.5) CLEN( 4)          BGND(13)
  TYPE(End)

  TYPE(STATIC) FPOS(0.4,6.5) SIZE(99.2,19) STYPE(12)  CTYPE(2)
    TYPE(Get)  NAME(cVARSYM)    FPOS(15, .5)   FLEN(15) FCAPTION(VarSymbol ...)    CPOS( 1, .5) PUSH(FIN_CVARSYM) 
    TYPE(Text) NAME(cNAZEV)     CPOS(32, .5) CLEN(24) FONT(5) BGND(13)
    TYPE(Get)  NAME(nCISFAK)    FPOS(15,1.5)   FLEN(10) FCAPTION(ÈFak/DatÚh ...)   CPOS(1,1.5)
    TYPE(Text)                                            CAPTION(uhrazeno)         CPOS(27,1.5) CLEN( 8)
    TYPE(Get)  NAME(dDATUHRADY) FPOS(35,1.5)   FLEN(10)
    TYPE(Text)                                            CAPTION(/ v)              CPOS(48,1.5) CLEN( 3)
    TYPE(Text) NAME(cZKRATMENF) CPOS(52,1.5)   CLEN( 4)         BGND(13)                                      
    TYPE(Get)  NAME(cUCET_UCT)  FPOS(15,2.5)   FLEN(10) FCAPTION(SuAu_S ...)       CPOS(1,2.5) 
    TYPE(Get)  NAME(cTEXT)      FPOS(15,3.5)   FLEN(30) FCAPTION(TextÚHR ...)      CPOS(1,3.5)

    TYPE(STATIC) STYPE(2) SIZE(40,4) FPOS(58,.1) CTYPE(2)
**
      TYPE(Get)  NAME(nCENZAKCEL) FPOS(18, .8)   FLEN(13) FCAPTION(Èástka_TYP ...)      CPOS( 3, .8)
      TYPE(Get)  NAME(nCENZAHCEL) FPOS(18, .8)   FLEN(13) FCAPTION(Èástka_TYP ...)      CPOS( 3, .8)
*
      TYPE(Get)  NAME(cTYPOBRATU)   FPOS(34, .8) FLEN( 3)
      TYPE(Get)  NAME(nUHRCELFAK)   FPOS(18,1.8) FLEN(13) FCAPTION(Úhrada_FAK ...)      CPOS( 3,1.8)
      TYPE(Text) NAME(cZKRATMENU)   CPOS(34,1.8) CLEN( 4) BGND(13)
      TYPE(Get)  NAME(nLIKPOLBAV)   FPOS(18,2.8) FLEN(13) FCAPTION(Likvid_POL ...)      CPOS( 3,2.8)                   PUSH(FIN_BANVYPHD_KR)
      TYPE(Text) NAME(cZKRATMENY)   CPOS(34,2.8) CLEN( 4) BGND(13)
    TYPE(End)

* NS
    TYPE(GET) NAME(cNAZPOL1) FPOS(  3,5.9) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.85) CLEN(10)
    TYPE(GET) NAME(cNAZPOL2) FPOS( 19,5.9) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.85) CLEN( 8)
    TYPE(GET) NAME(cNAZPOL3) FPOS( 35,5.9) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.85) CLEN( 8)
    TYPE(GET) NAME(cNAZPOL4) FPOS( 51,5.9) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.85) CLEN( 8)
    TYPE(GET) NAME(cNAZPOL5) FPOS( 67,5.9) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.85) CLEN( 8)
    TYPE(GET) NAME(cNAZPOL6) FPOS( 83,5.9) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.85) CLEN(10)

    TYPE(STATIC) FPOS(0.4,5.2) SIZE(98.6,.2) STYPE(12)
    TYPE(End)

    TYPE(Browse) FPOS(.4,7.4) SIZE(98.4,11.2) FILE(BANVYPITw) INDEXORD(1) ;
                                              FIELDS(FIN_banvypit_BC(11)::5.4::2   , ;
                                                     cVARSYM:varSymbol             , ;
                                                     FIN_banvypit_BC(13):faktura:10, ; 
                                                     cUCET_UCT:SuAu_s              , ;
                                                     cTEXT:Text úhrady:26          , ;
                                                     FIN_banvypit_BC(160):èástka:13, ; 
                                                     nLIKPOLBAV:likvidace          , ;
                                                     FIN_banvypit_BC(18):typ:2.7::2  ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy)
  TYPE(End)
