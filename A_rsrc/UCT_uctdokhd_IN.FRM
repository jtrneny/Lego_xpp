TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava úèetního dokladu ...) SIZE(100,25) FILE (UCTDOKHDw)   ;
                                                                                 POST(postValidate)

* TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,8.2) STYPE(13) CTYPE(2)
    TYPE(COMBOBOX) NAME(UCTDOKHDw->COBDOBI)    FPOS(73,0.5) FLEN(11) VALUES(a,a,a,a) FCAPTION(OBD_úè/daò) CLEN(11) CPOS(59,0.5) PP(2) FONT(5)
    TYPE(COMBOBOX) NAME(UCTDOKHDw->COBDOBIDAN) FPOS(85,0.5) FLEN(11) VALUES(a,a,a,a) 
    TYPE(Get)      NAME(UCTDOKHDw->dPORIZDOK)  FPOS(18,1.5) FLEN(11) FCAPTION(Datum poøízení ) CPOS( 3,1.5) PUSH(CLICKDATE)

    TYPE(ComboBox) NAME(UCTDOKHDw->cTYPPOHYBU) FPOS( 3,0.4) FLEN(27) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ITEMMARKED(comboItemSelected) NOREVISION()

*    TYPE(ComboBox) NAME(UCTDOKHDw->cTYPDOKLAD) FPOS( 3,0.4) FLEN(27) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ;
*                                                                                   ITEMMARKED(comboItemSelected)


    TYPE(Get)      NAME(UCTDOKHDw->nDOKLAD)    FPOS(18,2.5) FLEN(11) FCAPTION(Doklad         ) CPOS( 3,2.5) FONT(5) PP(2) NOREVISION()
    TYPE(Get)      NAME(UCTDOKHDw->cUCET_UCT)  FPOS(18,3.5) FLEN(11) FCAPTION(SuAu_Ø )         CPOS( 3,3.5) PP(2)
    TYPE(Text)     NAME(M->CNAZ_UCT_HD)        CPOS(30,3.5) CLEN(24) BGND(13)
    TYPE(Get)      NAME(UCTDOKHDw->cTEXTDOK)   FPOS(18,4.5) FLEN(35) FCAPTION(Text dokladu   ) CPOS( 3,4.5) 
* P
*    TYPE(Get)      NAME(UCTDOKHDw->cKEYS_PZ)   FPOS(73,1.5) FLEN(15) FCAPTION(Doklad úhrady)  CPOS(59,1.5) 
*    TYPE(Get)      NAME(UCTDOKHDw->nCISFAK)    FPOS(73,2.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(59,2.5) 
    TYPE(Get)      NAME(UCTDOKHDw->cVARSYM)    FPOS(73,3.5) FLEN(15) FCAPTION(VarSymbol)       CPOS(59,3.5) 
    TYPE(Get)      NAME(UCTDOKHDw->nCENZAKCEL) FPOS(73,4.5) FLEN(15) FCAPTION(Celkem/TYP)      CPOS(59,4.5) FONT(5)
    TYPE(Text)     NAME(M->typObratu)          CPOS(90,4.5) CLEN( 6) BGND(13) FONT(5)

* DPH
*    TYPE(TEXT) CAPTION(daò z pøidané hodnoty)    CPOS(3,5.8) CLEN(17)

*    TYPE(GET)      NAME(UCTDOKHDw->DVYSTDOK)     FPOS(18,6.8) FLEN(13) FCAPTION(Datum uzp      ___)  CPOS(3,6.8) PUSH(CLICKDATE)

*    TYPE(TEXT)     CAPTION(Bez danì       ________________) CPOS(35,6.8  ) CLEN(25)
*    TYPE(GET)      NAME(UCTDOKHDw->NOSVODDAN)    FPOS(60,6.8) FLEN(13) CTYPE(2) PUSH(FIN_VYKDPH_IN)

*    TYPE(TEXT)     CAPTION(Základ danì   ____)   CPOS(35,7.8) CLEN(15)
*    TYPE(ComboBox) NAME(UCTDOKHDw->nPROCDAN_1)   FPOS(50,7.8) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,7.8) CLEN( 3)
*    TYPE(GET)      NAME(UCTDOKHDw->NZAKLDAN_1)   FPOS(60,7.8) FLEN(13) PUSH(FIN_CMDPH)
*    TYPE(TEXT)     CAPTION(daò)                  CPOS(76,7.8) CLEN( 5)
*    TYPE(GET)      NAME(UCTDOKHDw->NSAZDAN_1)    FPOS(82,7.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

*    TYPE(TEXT)     CAPTION(Základ danì   ____)   CPOS(35,8.8) CLEN(15)
*    TYPE(ComboBox) NAME(UCTDOKHDw->nPROCDAN_2)   FPOS(50,8.8) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,8.8) CLEN( 3)
*    TYPE(GET)      NAME(UCTDOKHDw->NZAKLDAN_2)   FPOS(60,8.8) FLEN(13) PUSH(FIN_CMDPH)
*    TYPE(TEXT)     CAPTION(daò)                  CPOS(76,8.8) CLEN( 5)
*    TYPE(GET)      NAME(UCTDOKHDw->NSAZDAN_2)    FPOS(82,8.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL1) FPOS(  3,6.8) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,5.75) CLEN(10)
    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL2) FPOS( 19,6.8) FLEN(10) FCAPTION(Výrobek)      CPOS(19,5.75) CLEN( 8)
    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL3) FPOS( 35,6.8) FLEN(10) FCAPTION(Zakázka)      CPOS(35,5.75) CLEN( 8)
    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL4) FPOS( 51,6.8) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,5.75) CLEN( 8)
    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL5) FPOS( 67,6.8) FLEN(10) FCAPTION(Stroj)        CPOS(67,5.75) CLEN( 8)
    TYPE(GET) NAME(UCTDOKHDw->cNAZPOL6) FPOS( 83,6.8) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,5.75) CLEN(10) 

    TYPE(STATIC) FPOS(0.4,6.2) SIZE(98.6,.1) STYPE(12)
    TYPE(End)

* memoEdit
    TYPE(PushButton) POS(95.5,6.8) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(uctdokhdw->mpoznamka,1) 

  TYPE(End)


  TYPE(STATIC) FPOS(0.4,8.5) SIZE(99.2,16.2) STYPE(12)  CTYPE(2)

* IT-L
     TYPE(Get)  NAME(UCTDOKITw->cUCETDAL)   FPOS(18,0.5)   FLEN(10) FCAPTION(SuAu_S)       CPOS( 3,0.5) FONT(5) PP(2)
     TYPE(Text) NAME(M->CNAZ_UCT_IT)        CPOS(29,0.5)   CLEN(24) BGND(13)
     TYPE(Get)  NAME(UCTDOKITw->cSYMBOL)    FPOS(18,1.5)   FLEN(15) FCAPTION(VarSymbol)    CPOS( 3,1.5) FONT(5)
     TYPE(Get)  NAME(UCTDOKITw->cTEXT)      FPOS(18,2.5)   FLEN(34) FCAPTION(Text položky) CPOS( 3,2.5) FONT(5)
* IT-P
    TYPE(STATIC) STYPE(2) SIZE(40,3.5) FPOS(58,.1) CTYPE(2)
      TYPE(Get)  NAME(UCTDOKITw->nKCMD)      FPOS(16,0.6)   FLEN(13) FCAPTION(Celkem      _pol) CPOS( 1,0.6) FONT(5)
      TYPE(Get)  NAME(UCTDOKITw->nMNOZNAT)   FPOS(16,1.6)   FLEN(13) FCAPTION(Množství   _pol)  CPOS( 1,1.6) FONT(5)
      TYPE(Get)  NAME(UCTDOKITw->cZKRATJEDN) FPOS(31,1.6)   FLEN( 6)
      TYPE(Get)  NAME(UCTDOKITw->nMNOZNAT2)  FPOS(16,2.6)   FLEN(13) FCAPTION(Množství2 _pol)   CPOS( 1,2.6) FONT(5)
      TYPE(Get)  NAME(UCTDOKITw->cZKRATJED2) FPOS(31,2.6)   FLEN( 6)
    TYPE(End)

* NS
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL1) FPOS(  3,5.2) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.15) CLEN(10)
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL2) FPOS( 19,5.2) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.15) CLEN( 8)
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL3) FPOS( 35,5.2) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.15) CLEN( 8)
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL4) FPOS( 51,5.2) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.15) CLEN( 8)
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL5) FPOS( 67,5.2) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.15) CLEN( 8)
    TYPE(GET) NAME(UCTDOKITw->cNAZPOL6) FPOS( 83,5.2) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.15) CLEN(10) 

    TYPE(STATIC) FPOS(0.4,4.6) SIZE(98.6,.1) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS(.4,6.8) SIZE(98.4,8.8) FILE(UCTDOKITw)                    ;
                                             FIELDS(NORDITEM:polDok            , ;
                                                    COBDOBI:úèObd              , ;
                                                    CTEXT:text dokladu:52      , ;
                                                    CUCETMD:SuAu_Ø             , ;
                                                    NKCMD:celkem               , ;
                                                    CUCETDAL:SuAu_S            , ;
                                                    uct_uctdokit_bc('w'):typ:4 ) ;
                                             CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy)

  TYPE(End)

