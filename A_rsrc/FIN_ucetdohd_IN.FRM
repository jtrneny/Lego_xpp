TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava úèetního dokladu ...) SIZE(100,27) FILE (UCETDOHDw)   ;
                                                                                 POST(postValidate)

 TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,10.2) STYPE(13) CTYPE(2)
    TYPE(COMBOBOX) NAME(UCETDOHDw->COBDOBI)    FPOS(73,0.5) FLEN(11) VALUES(a,a,a,a) FCAPTION(OBD_úè/daò) CLEN(11) CPOS(59,0.5) PP(2) FONT(5)
    TYPE(COMBOBOX) NAME(UCETDOHDw->COBDOBIDAN) FPOS(85,0.5) FLEN(11) VALUES(a,a,a,a) 
    TYPE(Get)      NAME(UCETDOHDw->dPORIZDOK)  FPOS(20,1.5) FLEN(12) FCAPTION(Datum poøízení   __) CPOS( 3,1.5) CLEN(17) FONT(5) PUSH(CLICKDATE)

    TYPE(ComboBox) NAME(UCETDOHDw->cTYPPOHYBU) FPOS( 3,0.4) FLEN(27) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ;
                                                                                   ITEMMARKED(comboItemSelected)   ;
                                                                                   NOREVISION()

*    TYPE(ComboBox) NAME(UCETDOHDw->cTYPDOKLAD) FPOS( 3,0.4) FLEN(27) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ;
*                                                                                   ITEMMARKED(comboItemSelected)   


    TYPE(Get)      NAME(UCETDOHDw->nDOKLAD)    FPOS(20,2.5) FLEN(11) FCAPTION(Doklad/Daò_dokl __)         CPOS( 3,2.5) CLEN(17) FONT(5) PP(2)
    TYPE(Get)      NAME(UCETDOHDw->cdanDoklad) FPOS(33,2.5) FLEN(22) 

    TYPE(Get)      NAME(UCETDOHDw->cUCET_UCT)  FPOS(20,3.5) FLEN(11) FCAPTION(SuAu_Ø                  __) CPOS( 3,3.5) CLEN(17) FONT(5) PP(2)
    TYPE(Text)     NAME(M->CNAZ_UCT_HD)        CPOS(33,3.5) CLEN(23) BGND(13)
    TYPE(Get)      NAME(UCETDOHDw->cTEXTDOK)   FPOS(20,4.5) FLEN(35) FCAPTION(Text dokladu   ) CPOS( 3,4.5) 
* P
    TYPE(Get)      NAME(UCETDOHDw->cKEYS_PZ)   FPOS(73,1.5) FLEN(15) FCAPTION(Doklad úhrady)  CPOS(59,1.5) 
    TYPE(Get)      NAME(UCETDOHDw->nCISFAK)    FPOS(73,2.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(59,2.5) 
    TYPE(Get)      NAME(UCETDOHDw->cVARSYM)    FPOS(73,3.5) FLEN(15) FCAPTION(VarSymbol)      CPOS(59,3.5) 
    TYPE(Get)      NAME(UCETDOHDw->nCENZAKCEL) FPOS(73,4.5) FLEN(15) FCAPTION(Celkem/TYP)     CPOS(59,4.5) FONT(5)
    TYPE(Text)     NAME(M->typObratu)          CPOS(90,4.5) CLEN( 6) BGND(13) FONT(5)

* DPH
    TYPE(TEXT) CAPTION(daò z pøidané hodnoty)    CPOS(3,5.3) CLEN(17)

    TYPE(GET)      NAME(UCETDOHDw->cDIC)         FPOS(18,6.5) FLEN(13) FCAPTION(DIÈ                 ___)  CPOS(3,6.5) PUSH(firmyico_sel)    
    TYPE(GET)      NAME(UCETDOHDw->DVYSTDOK)     FPOS(18,7.5) FLEN(13) FCAPTION(Datum uzp      ___)       CPOS(3,7.5) PUSH(CLICKDATE) NOREVISION()
    TYPE(GET)      NAME(UCETDOHDw->NOSVODDAN)    FPOS(18,8.5) FLEN(13) FCAPTION(Bez danì        ___)      CPOS(3,8.5) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)     CAPTION(Sazba danì    ____)   CPOS(35,6.5) CLEN(15)
    TYPE(TEXT)     CAPTION(Základ danì   ____)   CPOS(35,7.5) CLEN(15)
    TYPE(TEXT)     CAPTION(Odvod danì   ____)    CPOS(35,8.5) CLEN(15)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_3)   FPOS(53,6.5) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_3)   FPOS(50,7.5) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_3)    FPOS(50,8.5) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_1)   FPOS(69,6.5) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_1)   FPOS(66,7.5) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_1)    FPOS(66,8.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_2)   FPOS(85,6.5) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_2)   FPOS(82,7.5) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_2)    FPOS(82,8.5) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(STATIC) FPOS(0.4,5.8) SIZE(98.6,.1) STYPE(12)
    TYPE(End)

  TYPE(End)


  TYPE(STATIC) FPOS(0.4,10.5) SIZE(99.2,16.2) STYPE(12)  CTYPE(2)

* IT-L
     TYPE(Get)  NAME(UCETDOITw->cUCETDAL)   FPOS(18,0.5)   FLEN(10) FCAPTION(SuAu_S)       CPOS( 3,0.5) FONT(5) PP(2)
     TYPE(Text) NAME(M->CNAZ_UCT_IT)        CPOS(29,0.5)   CLEN(24) BGND(13)
     TYPE(Get)  NAME(UCETDOITw->cSYMBOL)    FPOS(18,1.5)   FLEN(15) FCAPTION(VarSymbol)    CPOS( 3,1.5) FONT(5)
     TYPE(Get)  NAME(UCETDOITw->cTEXT)      FPOS(18,2.5)   FLEN(34) FCAPTION(Text položky) CPOS( 3,2.5) FONT(5)
* IT-P
    TYPE(STATIC) STYPE(2) SIZE(40,3.5) FPOS(58,.1) CTYPE(2)
      TYPE(Get)  NAME(UCETDOITw->nKCMD)      FPOS(16,0.6)   FLEN(13) FCAPTION(Celkem      _pol) CPOS( 1,0.6) FONT(5)
      TYPE(Get)  NAME(UCETDOITw->nMNOZNAT)   FPOS(16,1.6)   FLEN(13) FCAPTION(Množství   _pol)  CPOS( 1,1.6) FONT(5)
      TYPE(Get)  NAME(UCETDOITw->cZKRATJEDN) FPOS(31,1.6)   FLEN( 6)
      TYPE(Get)  NAME(UCETDOITw->nMNOZNAT2)  FPOS(16,2.6)   FLEN(13) FCAPTION(Množství2 _pol)   CPOS( 1,2.6) FONT(5)
      TYPE(Get)  NAME(UCETDOITw->cZKRATJED2) FPOS(31,2.6)   FLEN( 6)
    TYPE(End)

* NS
    TYPE(GET) NAME(UCETDOITw->cNAZPOL1) FPOS(  3,5.2) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.15) CLEN(10)
    TYPE(GET) NAME(UCETDOITw->cNAZPOL2) FPOS( 19,5.2) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.15) CLEN( 8)
    TYPE(GET) NAME(UCETDOITw->cNAZPOL3) FPOS( 35,5.2) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.15) CLEN( 8)
    TYPE(GET) NAME(UCETDOITw->cNAZPOL4) FPOS( 51,5.2) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.15) CLEN( 8)
    TYPE(GET) NAME(UCETDOITw->cNAZPOL5) FPOS( 67,5.2) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.15) CLEN( 8)
    TYPE(GET) NAME(UCETDOITw->cNAZPOL6) FPOS( 83,5.2) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.15) CLEN(10) 

    TYPE(STATIC) FPOS(0.4,4.6) SIZE(98.6,.1) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS(.4,6.8) SIZE(98.4,8.8) FILE(UCETDOITw)                    ;
                                             FIELDS(NORDITEM:polDok            , ;
                                                    COBDOBI:úèObd              , ;
                                                    CTEXT:text dokladu:52      , ;
                                                    CUCETMD:SuAu_Ø             , ;
                                                    NKCMD:celkem               , ;
                                                    CUCETDAL:SuAu_S            , ;
                                                    fin_ucetdoit_bc('w'):typ:4 ) ;
                                             CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy)

  TYPE(End)

