TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava ) SIZE(111,15) FILE (POKLADITw) ;
                                                             GUILOOK(Action:n,IconBar:y:myIconBar,Menu:n,Message:n);
                                                             POST(postValidate)


* èást hlavièky pro pkladit
*TYPE(TEXT) NAME(M->cnaz_uct_hd)              CPOS(22.3,2.75) CLEN(26)          BGND(13)
*TYPE(Text) CAPTION(Ve prospìch úètu _______)      CPOS(60.3,2.7 ) CLEN(23) FONT(5)
*TYPE(Text) CAPTION(Na vrub úètu          _______) CPOS(60.3,3.7 ) CLEN(23) FONT(5) 
*TYPE(TEXT) CAPTION(Rozdíl         _____________ ) CPOS(60.3,4.7 ) CLEN(23) FONT(5)

* pøíjem
*TYPE(Text) NAME(POKLADHDw->nPRIJEM)            CPOS( 86.3,2.7 ) CLEN(14) CTYPE(2) BGND(13)
*TYPE(Text) NAME(POKLADHDw->nPRIJEMz)           CPOS( 86.3,2.7 ) CLEN(14) CTYPE(2) BGND(13)
*TYPE(Text) NAME(POKLADHDw->cZKRATMENY)         CPOS(103.3,2.7 ) CLEN( 4)          BGND(13)

* výdej
*TYPE(Text) NAME(POKLADHDw->nVYDEJ)             CPOS( 86.3,3.7 ) CLEN(14) CTYPE(2) BGND(13)
*TYPE(Text) NAME(POKLADHDw->nVYDEJz)            CPOS( 86.3,3.7 ) CLEN(14) CTYPE(2) BGND(13)
*TYPE(Text) NAME(POKLADHDw->cZKRATMENY)         CPOS(103.3,3.7 ) CLEN( 4)          BGND(13)

* zústatek
*TYPE(Text) NAME(POKLADHDw->nAKTSTAV)           CPOS( 86.3,4.7 ) CLEN(14) CTYPE(2) BGND(13)
*TYPE(Text) NAME(POKLADHDw->cZKRATMENY)         CPOS(103.3,4.7 ) CLEN( 4)          BGND(13)


* pokladní doklady
*  TYPE(STATIC) FPOS(1,1) SIZE(109.2,6) STYPE(13) CTYPE(2) 
*  TYPE(COMBOBOX) NAME(POKLADHDw->CTYPPOHYBU) FPOS(0,0) FLEN(0) VALUES(a,a,a)
* L
*    TYPE(Text)                             CAPTION(Pokladna) CPOS( 1, .5)                   
*    TYPE(Text) NAME(POKLADHDw->nPOKLADNA)                    CPOS(11, .5) CLEN(10) BGND(13) CTYPE(2)
*    TYPE(Text)                             CAPTION(Název)    CPOS( 1,1.5) CLEN(10)                  
*    TYPE(Text) NAME(POKLADHDw->cNAZPOKLAD)                   CPOS(11,1.5) CLEN(37) BGND(13) 
*    TYPE(Text)                             CAPTION(SuAu_Ø)   CPOS( 1,2.5) CLEN(10)                  
*    TYPE(Text) NAME(POKLADHDw->cUCET_UCT)                    CPOS(11,2.5) CLEN(10) BGND(13) CTYPE(2)
*    TYPE(Text)                             CAPTION(Doklad)   CPOS( 1,3.5)                   
*    TYPE(Text) NAME(POKLADHDw->nDOKLAD)                      CPOS(11,3.5) CLEN(10) BGND(13) CTYPE(2) 
*    TYPE(Text)                             CAPTION(ze dne)   CPOS(26,3.4) CLEN( 8)          
*    TYPE(Text) NAME(POKLADHDw->dPORIZDOK)                    CPOS(35,3.5) CLEN(13) BGND(13) 
*  TYPE(End)


* položky úhrad faktur pokladním dokladem
*  TYPE(STATIC) FPOS(0,0) SIZE(111,19) STYPE(15) CTYPE(2) 
*  TYPE(End)

  TYPE(STATIC) FPOS(0,0) SIZE(111,19) STYPE(1) CTYPE(2) 
    TYPE(Get)  NAME(POKLADITw->cVARSYM)    FPOS(15, .5)   FLEN(15) FCAPTION(VarSymbol ...)     CPOS( 1, .5) PUSH(cvarsym_vld)
    TYPE(Text) NAME(POKLADITw->cNAZEV)                                                         CPOS(32, .5) CLEN(24) FONT(5)  BGND(13)
    TYPE(Get)  NAME(POKLADITw->nCISFAK)    FPOS(15,1.5)   FLEN(10)
    TYPE(Text)                                            CAPTION(uhrazeno)       CPOS(27,1.5) CLEN( 8)
    TYPE(Get)  NAME(POKLADITw->dDATUHRADY) FPOS(35,1.5)   FLEN(11) FCAPTION(ÈFak/DatÚh ...)    CPOS(1,1.5)  CLEN(10)         PUSH(CLICKDATE)
    TYPE(Text)                                            CAPTION(/ v)            CPOS(48,1.5) CLEN( 3)
    TYPE(Text) NAME(POKLADITw->cZKRATMENF)                                                     CPOS(52,1.5) CLEN( 4)         BGND(13)
    TYPE(Get)  NAME(POKLADITw->cUCET_UCT)  FPOS(15,2.5)   FLEN(10) FCAPTION(SuAu_S ...)        CPOS(1,2.5) PP(2)
    TYPE(TEXT) NAME(it_ucet->cnaz_uct)     CPOS(27,2.5)   CLEN(29) BGND(13)
    TYPE(Get)  NAME(POKLADITw->cTEXT)      FPOS(15,3.5)   FLEN(40) FCAPTION(TextÚHR ...)       CPOS(1,3.5)

    TYPE(STATIC) STYPE(2) SIZE(48,4) FPOS(60,.1) CTYPE(2)
**
      TYPE(Get)       NAME(POKLADITw->nCENZAKCEL)   FPOS(26, .8)   FLEN(13) FCAPTION(Èástka_typ           _________) CPOS( 3, .8)
      TYPE(Get)       NAME(POKLADITw->nCENZAHCEL)   FPOS(26, .8)   FLEN(13) FCAPTION(Èástka_typ           _________) CPOS( 3, .8)
      TYPE(COMBOBOX)  NAME(POKLADITw->nTYPOBRATU)   FPOS(42, .8)   FLEN( 5) VALUES(1:+,2:-) FONT(5)
      TYPE(Get)       NAME(POKLADITw->nUHRCELFAK)   FPOS(26,1.8)   FLEN(13) FCAPTION(Úhrada_faktury    _________)  CPOS( 3,1.8)
      TYPE(Get)       NAME(POKLADITw->nUHRCELFAZ)   FPOS(26,1.8)   FLEN(13) FCAPTION(Úhrada_faktury    _________)  CPOS( 3,1.8)

      TYPE(Text)      NAME(POKLADITw->cZKRATMENU)                                                     CPOS(42,1.8) CLEN( 5) BGND(13)
      TYPE(Get)       NAME(POKLADITw->nLIKPOLPOK)   FPOS(26,2.8)   FLEN(13) FCAPTION(Likvidace_položky _________)  CPOS( 3,2.8)   PUSH(likpol_krp)
      TYPE(Text)      NAME(POKLADHDw->cZKRATMENY)                                                      CPOS(42,2.8) CLEN( 5) BGND(13)
    TYPE(End)

* NS
    TYPE(GET) NAME(POKLADITw->cNAZPOL1) FPOS(  3,5.9) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.85) CLEN(10)
    TYPE(GET) NAME(POKLADITw->cNAZPOL2) FPOS( 21,5.9) FLEN(10) FCAPTION(Výrobek)      CPOS(21,4.85) CLEN( 8)
    TYPE(GET) NAME(POKLADITw->cNAZPOL3) FPOS( 39,5.9) FLEN(10) FCAPTION(Zakázka)      CPOS(39,4.85) CLEN( 8)
    TYPE(GET) NAME(POKLADITw->cNAZPOL4) FPOS( 57,5.9) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,4.85) CLEN( 8)
    TYPE(GET) NAME(POKLADITw->cNAZPOL5) FPOS( 75,5.9) FLEN(10) FCAPTION(Stroj)        CPOS(75,4.85) CLEN( 8)
    TYPE(GET) NAME(POKLADITw->cNAZPOL6) FPOS( 93,5.9) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,4.85) CLEN(10)

    TYPE(STATIC) FPOS(0.4,5.3) SIZE(108.6,.1) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS(.9,7.1) SIZE(109.4,7.8) INDEXORD(1) FILE(POKLADITw)                 ;
                                               FIELDS(M->treeView::5.4::2                , ;
                                                      cVARSYM:varSymbol                  , ;
                                                      M->cisFaktury:faktura:10           , ;
                                                      cTEXT:Text úhrady:24               , ;
                                                      cUCET_UCT:SuAu_s                   , ;
                                                      M->veProspech:ve Prospìch:13       , ;
                                                      M->naVrub:na Vrub:13               , ;
                                                      nLIKPOLPOK:likvidace               , ;
                                                      M->typObratu:typ:2.7::2              ) ;
                                               CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy) 

* neviditelné omocné položky
  TYPE(TEXT) NAME(pokladitw->cfile_iv) FPOS(0,0) CLEN(0)



