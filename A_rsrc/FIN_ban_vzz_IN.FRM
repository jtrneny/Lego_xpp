TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava ) SIZE(110,26) FILE (BANVYPITw) POST(postValidate) 


* èást hlavièky pro ban/vzz/uhr
TYPE(Text) CAPTION(Ve prospìch úètu _______)      CPOS(60.3,2.7 ) CLEN(23) FONT(5)            GROUPS(uhr:1.2)
TYPE(Text) CAPTION(Na vrub úètu          _______) CPOS(60.3,3.7 ) CLEN(23) FONT(5)            GROUPS(uhr:2.2)
  
* pøíjem
TYPE(Text) NAME(M->veProspech_hd)                 CPOS( 86.3,2.7 ) CLEN(14) CTYPE(2) BGND(13) GROUPS(uhr:1.2)
TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)            CPOS(103.3,2.7 ) CLEN( 4)          BGND(13) GROUPS(uhr:1.2)

* výdej
TYPE(Text) NAME(M->naVrub_hd)                     CPOS( 86.3,3.7 ) CLEN(14) CTYPE(2) BGND(13) GROUPS(uhr:2.2)
TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)            CPOS(103.3,3.7 ) CLEN( 4)          BGND(13) GROUPS(uhr:2.2)

* zústatek
TYPE(Text) NAME(BANVYPHDw->nZUSTATEK)             CPOS( 86.3,4.7 ) CLEN(14) CTYPE(2) BGND(13) FONT(5) GROUPS(uhr:3.2)
TYPE(Text) NAME(BANVYPHDw->cZKRATMENY)            CPOS(103.3,4.7 ) CLEN( 4)          BGND(13)         GROUPS(uhr:3.2)  


* bankovní výpisy
  TYPE(STATIC) FPOS(0.4,0.2) SIZE(109.2,6.9) STYPE(13) CTYPE(2) GROUPS(1)
* L
    TYPE(COMBOBOX) NAME(BANVYPHDw->CTYPPOHYBU) FPOS(11, .5) FLEN(29) VALUES(a,a,a) GROUPS(1) NOREVISION()

    TYPE(Get)  NAME(BANVYPHDw->cBANK_UCT)  FPOS(11,1.5) FLEN(28) FCAPTION(Úèet)   CPOS( 1,1.5) PUSH(cbank_uct_vld) GROUPS(1) PP(2) FONT(5) NOREVISION()
    TYPE(Text) NAME(C_BANKUC->cBANK_NAZ)                                          CPOS(40,1.5) CLEN(20)            GROUPS(1) FONT(5)

    TYPE(Get)  NAME(BANVYpHDw->cFile_Imp)  FPOS(11,2.5) FLEN(36) FCAPTION(Import z) CPOS( 1,2.5) PUSH(import_bavy) GROUPS(1) FONT(5) NOREVISION()

    TYPE(Get)  NAME(BANVYPHDw->cUCET_UCT)  FPOS(11,3.5) FLEN( 9) FCAPTION(SuAu_Ø) CPOS( 1,3.5)                     GROUPS(1) PP(2) FONT(5)
    TYPE(TEXT) NAME(hd_ucet->cnaz_uct)                                            CPOS(22.1,3.5) CLEN(26)          GROUPS(9) BGND(13)
    TYPE(Get)  NAME(BANVYPHDw->nCISPOVYP)  FPOS(11,4.5) FLEN( 6) FCAPTION(Výpis)  CPOS( 1,4.5)                     GROUPS(1)       FONT(5) NOREVISION()
    TYPE(Text)                                                    CAPTION(/)      CPOS(19,4.5) CLEN( 2)            GROUPS(1)
    TYPE(Text) NAME(BANVYPHDw->nPOCPOLOZ)                                         CPOS(22,4.5) CLEN( 5) BGND(13)   GROUPS(1) CTYPE(2) 
    TYPE(Get)  NAME(BANVYPHDw->dDATPORIZ)  FPOS(36,4.5) FLEN(11) FCAPTION(ze dne) CPOS(28,4.5) PUSH(CLICKDATE)     GROUPS(1) PP(2)
    TYPE(Get)  NAME(BANVYPHDw->nDOKLAD)    FPOS(11,5.5) FLEN(10) FCAPTION(Doklad) CPOS( 1,5.5)                     GROUPS(1) PP(2) FONT(5) NOREVISION()          

    TYPE(GET)  NAME(BANVYPHDw->NKURZAHMEN) FPOS(36,5.5) FLEN(11) FCAPTION(kurz/pøep)       CPOS(27,5.5)  CLEN(8)         PP(2) GROUPS(1)
    TYPE(GET)  NAME(BANVYPHDw->NMNOZPREP)  FPOS(48,5.5) FLEN( 6)                                                CTYPE(2) PP(2) GROUPS(1)
* P
    TYPE(COMBOBOX) NAME(BANVYPHDw->COBDOBI)    FPOS(70, .5) FLEN(12) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(60,0.5)                 GROUPS(1) PP(2)
    TYPE(Get)      NAME(BANVYPHDw->dDATPOVYP)  FPOS(70,1.5) FLEN(11)                 FCAPTION(Stav dne)        CPOS(60,1.5) PUSH(CLICKDATE) GROUPS(1) NOREVISION()
    TYPE(Get)      NAME(BANVYPHDw->nPOSZUST)   FPOS(86,1.5) FLEN(13)                                                                        GROUPS(1)
    TYPE(Text)     NAME(BANVYPHDw->cZKRATMENY)                                                                 CPOS(103,1.5)                GROUPS(1) CLEN( 4) BGND(13)

    TYPE(Get)  NAME(BANVYPHDw->dDATZUST)    FPOS(70,4.5) FLEN(11) FCAPTION(Zùstatek )        CPOS(60,4.5) PUSH(CLICKDATE) GROUPS(1)
  TYPE(End)

* vzájemné zápoèty
  TYPE(STATIC) FPOS(0.4,0.2) SIZE(109.2,6.9) STYPE(13) CTYPE(2) GROUPS(2)
* L
    TYPE(COMBOBOX) NAME(BANVYPHDw->CTYPPOHYBU) FPOS(11, .5) FLEN(29) VALUES(a,a,a) GROUPS(2) NOREVISION()

    TYPE(Get)      NAME(BANVYPHDw->nICO)        FPOS(11,1.5) FLEN(15) FCAPTION(Ièo )       CPOS( 1,1.5) PUSH(firmyico_sel)      GROUPS(2) PP(2) FONT(5) NOREVISION()
    TYPE(Text)     CAPTION([)                                                              CPOS(28,1.5) CLEN( 2)                GROUPS(2) FONT(5) 
    TYPE(Text)     NAME(BANVYPHDw->nCISFIRMY)                                              CPOS(30,1.5) CLEN( 6)                GROUPS(2) PICTURE(99999)
    TYPE(Text)     CAPTION(])                                                              CPOS(36,1.5) CLEN( 2)                GROUPS(2) FONT(5) 
    TYPE(Text)     NAME(BANVYPHDw->cNAZEV)                                                 CPOS(38,1.5) CLEN(35)                GROUPS(2) 
    TYPE(Get)      NAME(BANVYPHDw->cUCET_UCT)   FPOS(11,2.5) FLEN(10) FCAPTION(SuAu_Ø)     CPOS( 1,2.5)                         GROUPS(2) PP(2) FONT(5)
    TYPE(TEXT)     NAME(hd_ucet->cnaz_uct)                                                 CPOS(22.1,2.5) CLEN(26)              GROUPS(9) BGND(13)
    TYPE(Get)      NAME(BANVYPHDw->nDOKLAD)     FPOS(11,3.5) FLEN(10) FCAPTION(Doklad)     CPOS( 1,3.5)                         GROUPS(2) PP(2) FONT(5) NOREVISION()
    TYPE(Get)      NAME(BANVYPHDw->dDATPORIZ)   FPOS(36,3.5) FLEN(11) FCAPTION(ze dne)     CPOS(28,3.4) CLEN(8) PUSH(CLICKDATE) GROUPS(2)
*
    TYPE(ComboBox) NAME(BANVYPHDw->CZKRATMENY)  FPOS(11,4.5) FLEN(15) FCAPTION(Mìna)       CPOS( 1,4.5) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) GROUPS(2) PP(2) FONT(5) ITEMSELECTED(comboItemSelected) 
    TYPE(GET)  NAME(BANVYPHDw->NKURZAHMEN) FPOS(36,4.5) FLEN(11) FCAPTION(kurz/pøep)       CPOS(27,4.5)  CLEN(8)         PP(2)  GROUPS(2)
    TYPE(GET)  NAME(BANVYPHDw->NMNOZPREP)  FPOS(48,4.5) FLEN( 6)                                                CTYPE(2) PP(2)  GROUPS(2)
* P
    TYPE(COMBOBOX) NAME(BANVYPHDw->COBDOBI)     FPOS(86, .5) FLEN(14) FCAPTION(OBD_úè __________________) CPOS(60,0.5) CLEN(23) ;
                   VALUES(a,a,a,a) GROUPS(2) PP(2)
    TYPE(TEXT) CAPTION(Rozdíl                      _______)          CPOS(60,4.5) GROUPS(2) FONT(5)
  TYPE(End)

* ùhrady ùèetním dokladem
  TYPE(STATIC) FPOS(0.4,0.01) SIZE(109.2,6.9) STYPE(13) CTYPE(2) GROUPS(3)
* L
    TYPE(COMBOBOX) NAME(BANVYPHDw->CTYPPOHYBU) FPOS(11, .2) FLEN(29) VALUES(a,a,a) GROUPS(3) NOREVISION()
 
    TYPE(Get)      NAME(BANVYPHDw->cUCET_UCT)   FPOS(11,1.2) FLEN(10) FCAPTION(SuAu_Ø)     CPOS( 1  ,1.2)                       GROUPS(3) PP(2) FONT(5)
    TYPE(TEXT)     NAME(hd_ucet->cnaz_uct)                                                 CPOS(22.1,1.2) CLEN(26)              GROUPS(9) BGND(13)
    TYPE(Get)      NAME(BANVYPHDw->nDOKLAD)     FPOS(11,2.2) FLEN(10) FCAPTION(Doklad)     CPOS( 1,2.2)                         GROUPS(3) PP(2) FONT(5) NOREVISION()
    TYPE(Get)      NAME(BANVYPHDw->dDATPORIZ)   FPOS(36,2.2) FLEN(11) FCAPTION(ze dne)     CPOS(28,2.2) CLEN(8) PUSH(CLICKDATE) GROUPS(3)
*
    TYPE(ComboBox) NAME(BANVYPHDw->CZKRATMENY)  FPOS(11,3.2) FLEN(15) FCAPTION(Mìna)       CPOS( 1,3.2) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) GROUPS(3) PP(2) FONT(5) ITEMSELECTED(comboItemSelected) 
    TYPE(GET)  NAME(BANVYPHDw->NKURZAHMEN) FPOS(36,3.2) FLEN(11) FCAPTION(kurz/pøep)       CPOS(27,3.2)  CLEN(8)         PP(2)  GROUPS(3)
    TYPE(GET)  NAME(BANVYPHDw->NMNOZPREP)  FPOS(48,3.2) FLEN( 6)                                                CTYPE(2) PP(2)  GROUPS(3)
* P
    TYPE(COMBOBOX) NAME(BANVYPHDw->COBDOBI)     FPOS(86, .2) FLEN(14) FCAPTION(OBD_úè __________________) CPOS(60,0.2) CLEN(23) ;
                   VALUES(a,a,a,a) GROUPS(3) PP(2)
    TYPE(TEXT) CAPTION(Rozdíl                      _______)          CPOS(60,3.2) GROUPS(3) FONT(5)

* NS
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL1u) FPOS(  3,5.6) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.6) CLEN(10) GROUPS(3)
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL2u) FPOS( 21,5.6) FLEN(10) FCAPTION(Výrobek)      CPOS(21,4.6) CLEN( 8) GROUPS(3)
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL3u) FPOS( 39,5.6) FLEN(10) FCAPTION(Zakázka)      CPOS(39,4.6) CLEN( 8) GROUPS(3)
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL4u) FPOS( 57,5.6) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,4.6) CLEN( 8) GROUPS(3)
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL5u) FPOS( 75,5.6) FLEN(10) FCAPTION(Stroj)        CPOS(75,4.6) CLEN( 8) GROUPS(3)
    TYPE(GET) NAME(BANVYPHDw->cNAZPOL6u) FPOS( 93,5.6) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,4.6) CLEN(10) GROUPS(3)

    TYPE(STATIC) FPOS(0.4,4.9) SIZE(108.6,.3) STYPE(12) CTYPE(2)
    TYPE(End)
  TYPE(End)



* položky bankovního výpisu/ vzájemného zápoètu/ ùhrad ùèetním dokladem
  TYPE(STATIC) FPOS(0.4,7.3) SIZE(109.2,18) STYPE(12)  CTYPE(2)

* LEFT    

    TYPE(Get)  NAME(BANVYPITw->cVARSYM)    FPOS(15,0.5)   FLEN(15) FCAPTION(VarSymbol..)       CPOS( 1,0.5) FONT( 5) PUSH(cvarsym_vld) 
    TYPE(Text) NAME(BANVYPITw->cNAZEV)                                                         CPOS(32,0.5) CLEN(24) FONT(5)  BGND(13)
    TYPE(Get)  NAME(BANVYPITw->nCISFAK)    FPOS(15,1.5)   FLEN(10) 
    TYPE(Text)                                            CAPTION(uhrazeno)                    CPOS(27,1.5) CLEN( 8)
    TYPE(Get)  NAME(BANVYPITw->dDATUHRADY) FPOS(35,1.5)   FLEN(11) FCAPTION(ÈFak/DatÚh ...)    CPOS( 1,1.5) CLEN(10)         PUSH(CLICKDATE)
    TYPE(Text)                                            CAPTION(/ v)                         CPOS(48,1.5) CLEN( 3)
    TYPE(Text) NAME(BANVYPITw->cZKRATMENF)                                                     CPOS(52,1.5) CLEN( 4) BGND(13)
    TYPE(Get)  NAME(BANVYPITw->cUCET_UCT)  FPOS(15,2.5)   FLEN(10) FCAPTION(SuAu_S ...)        CPOS( 1,2.5)                    PP(2)
    TYPE(TEXT) NAME(it_ucet->cnaz_uct)                                                         CPOS(27,2.5) CLEN(29) BGND(13)
    TYPE(Get)  NAME(BANVYPITw->cTEXT)      FPOS(15,3.5)   FLEN(40) FCAPTION(TextÚHR ...)       CPOS( 1,3.5)

* RIGHT

    TYPE(STATIC) STYPE(2) SIZE(48,4) FPOS(60,.1) CTYPE(2)
      TYPE(Get)       NAME(BANVYPITw->nCENZAKCEL)   FPOS(26, .8)   FLEN(13) FCAPTION(Èástka_typ           _________) CPOS( 3, .8)
      TYPE(Get)       NAME(BANVYPITw->nCENZAHCEL)   FPOS(26, .8)   FLEN(13) FCAPTION(Èástka_typ        _________)    CPOS( 3, .8)
      TYPE(COMBOBOX)  NAME(BANVYPITw->nTYPOBRATU)   FPOS(42, .8)   FLEN( 5) VALUES(1: + ,2: - ) FONT(5)

      TYPE(Get)       NAME(BANVYPITw->nUHRCELFAK)   FPOS(26,1.8)   FLEN(13) FCAPTION(Úhrada_faktury    _________)  CPOS( 3,1.8)
      TYPE(Get)       NAME(BANVYPITw->nUHRCELFAZ)   FPOS(26,1.8)   FLEN(13) FCAPTION(Úhrada_faktury    _________)  CPOS( 3,1.8)
      TYPE(Text)      NAME(BANVYPITw->cZKRATMENU)                                                     CPOS(42,1.8) CLEN( 5) BGND(13)

      TYPE(Get)       NAME(BANVYPITw->nLIKPOLBAV)   FPOS(26,2.8)   FLEN(13) FCAPTION(Likvidace_položky _________)  CPOS( 3,2.8)      PUSH(likpol_krp)
      TYPE(Text)      NAME(M->zaklMena)                                                                            CPOS(42,2.8) CLEN( 5) BGND(13)
    TYPE(End)

* NS
    TYPE(GET) NAME(BANVYPITw->cNAZPOL1) FPOS(  3,5.6) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.6) CLEN(10)
    TYPE(GET) NAME(BANVYPITw->cNAZPOL2) FPOS( 21,5.6) FLEN(10) FCAPTION(Výrobek)      CPOS(21,4.6) CLEN( 8)
    TYPE(GET) NAME(BANVYPITw->cNAZPOL3) FPOS( 39,5.6) FLEN(10) FCAPTION(Zakázka)      CPOS(39,4.6) CLEN( 8)
    TYPE(GET) NAME(BANVYPITw->cNAZPOL4) FPOS( 57,5.6) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,4.6) CLEN( 8)
    TYPE(GET) NAME(BANVYPITw->cNAZPOL5) FPOS( 75,5.6) FLEN(10) FCAPTION(Stroj)        CPOS(75,4.6) CLEN( 8)
    TYPE(GET) NAME(BANVYPITw->cNAZPOL6) FPOS( 93,5.6) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,4.6) CLEN(10)

    TYPE(STATIC) FPOS(0.4,4.9) SIZE(108.6,.3) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS( 0,6.9) SIZE(108.4,11.2) INDEXORD(1) FILE(BANVYPITw)                 ;
                                                FIELDS(M->errImp::2.4::2                  , ;
                                                       M->treeView::5.4::2                , ;
                                                       cVARSYM:varSymbol                  , ;
                                                       M->cisFaktury:faktura:10           , ;
                                                       cTEXT:Text úhrady:23               , ;
                                                       cUCET_UCT:SuAu_s                   , ;
                                                       M->veProspech:ve Prospìch:12       , ;
                                                       M->naVrub:na Vrub:12               , ;
                                                       nLIKPOLBAV:likvidace               , ;
                                                       M->typObratu:typ:2.7::2              ) ;
                                                CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy) 

* neviditelné omocné položky
TYPE(TEXT) NAME(banvypitw->cfile_iv) FPOS(0,0) CLEN(0)
