TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava daòového dokladu ...) SIZE(100,12.5)     ;
                                                                    FILE(UCETDOHDw)    ;
                                                                    POST(postValidate) ;
                                                                    GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)

  TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,10.5) STYPE(13) CTYPE(2)
    TYPE(COMBOBOX) NAME(UCETDOHDw->COBDOBI)    FPOS(72,0.5) FLEN(12) VALUES(a,a,a,a) FCAPTION(OBD_úè/daò) CLEN(11) CPOS(58,0.5) PP(2) FONT(5)
    TYPE(COMBOBOX) NAME(UCETDOHDw->COBDOBIDAN) FPOS(86,0.5) FLEN(12) VALUES(a,a,a,a)
    TYPE(Get)      NAME(UCETDOHDw->dPORIZDOK)  FPOS(20,1.5) FLEN(12) FCAPTION(Datum poøízení   __) CPOS( 3,1.5) CLEN(17) FONT(5) PUSH(CLICKDATE)

    TYPE(ComboBox) NAME(UCETDOHDw->cTYPPOHYBU) FPOS( 3,0.4) FLEN(28) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ITEMMARKED(comboItemSelected)

    TYPE(Get)      NAME(UCETDOHDw->nDOKLAD)    FPOS(20,2.5) FLEN(12) FCAPTION(Doklad/Daò_dokl __)                 CPOS( 3,2.5) CLEN(17) FONT(5) PP(2) NOREVISION()
    TYPE(Get)      NAME(UCETDOHDw->cdanDoklad) FPOS(34,2.5) FLEN(22) 

    TYPE(Get)      NAME(UCETDOHDw->cUCET_UCT)  FPOS(20,3.5) FLEN(12) FCAPTION(SuAu_Ø                  __)         CPOS( 3,3.5) CLEN(17) FONT(5) PP(2)
    TYPE(Text)     NAME(M->CNAZ_UCT_HD)        CPOS(34,3.5) CLEN(23) BGND(13)
    TYPE(Get)      NAME(UCETDOHDw->cTEXTDOK)   FPOS(20,4.5) FLEN(36) FCAPTION(Text dokladu   ) CPOS( 3,4.5) 
* P
    TYPE(COMBOBOX) NAME(UCETDOHDw->CKEYS_PZ)   FPOS(72,1.5) FLEN(26) VALUES(a,a,a,a) FCAPTION(Doklad úhrady) CPOS(58,1.5) CLEN(14) FONT(5)
    TYPE(Get)      NAME(UCETDOHDw->nCISFAK)    FPOS(72,2.5) FLEN(15)                 FCAPTION(Èíslo faktury) CPOS(58,2.5)
    TYPE(Get)      NAME(UCETDOHDw->cVARSYM)    FPOS(72,3.5) FLEN(15)                 FCAPTION(VarSymbol)     CPOS(58,3.5)
    TYPE(Get)      NAME(UCETDOHDw->nCENZAKCEL) FPOS(72,4.5) FLEN(15)                 FCAPTION(Celkem/TYP)    CPOS(58,4.5) FONT(5)
    TYPE(Text)     NAME(M->typObratu)          CPOS(90,4.5) CLEN( 6) BGND(13) FONT(5)

* DPH
    TYPE(TEXT) CAPTION(daò z pøidané hodnoty)    CPOS(3,5.8) CLEN(17)

    TYPE(GET)      NAME(UCETDOHDw->cDIC)         FPOS(18,6.8) FLEN(13) FCAPTION(DIÈ                 ___)  CPOS(3,6.8) CLEN(14) PUSH(firmyico_sel) 
    TYPE(GET)      NAME(UCETDOHDw->DVYSTDOK)     FPOS(18,7.8) FLEN(13) FCAPTION(Datum uzp      ___)  CPOS(3,7.8) PUSH(CLICKDATE)
    TYPE(GET)      NAME(UCETDOHDw->NOSVODDAN)    FPOS(18,8.8) FLEN(13) FCAPTION(Bez danì        ___) CPOS(3,8.8) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)     CAPTION(Sazba danì    ____)   CPOS(35,6.8) CLEN(15)
    TYPE(TEXT)     CAPTION(Základ danì   ____)   CPOS(35,7.8) CLEN(15)
    TYPE(TEXT)     CAPTION(Odvod danì   ____)    CPOS(35,8.8) CLEN(15)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_3)   FPOS(53,6.8) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_3)   FPOS(50,7.8) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_3)    FPOS(50,8.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_1)   FPOS(69,6.8) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_1)   FPOS(66,7.8) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_1)    FPOS(66,8.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(UCETDOHDw->nPROCDAN_2)   FPOS(85,6.8) FLEN( 8) VALUES(a,a,a) FCAPTION(%) CPOS(38,6.8) CLEN( 3)
    TYPE(GET)      NAME(UCETDOHDw->NZAKLDAN_2)   FPOS(82,7.8) FLEN(13) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(UCETDOHDw->NSAZDAN_2)    FPOS(82,8.8) FLEN(13) PUSH(FIN_VYKDPH_IN)

    TYPE(STATIC) FPOS(0.4,6.2) SIZE(98.6,.1) STYPE(12)
    TYPE(End)
  TYPE(END)

  TYPE(STATIC) FPOS(0.4,10.85) SIZE(99.2,1.4) STYPE(12) CTYPE(2)
    TYPE(TEXT)     CAPTION(Úhrada faktury )      CPOS( 3,0.05)  CLEN(15) FONT(2)
    TYPE(TEXT)     NAME(ucetdohdw->nuhrCelFAK)   CPOS(18,0.05) CLEN(14) FONT(2) BGND(9) CTYPE(2) GROUPS(0)
    TYPE(TEXT)     NAME(ucetdohdw->nuhrCelFAZ)   CPOS(18,0.05) CLEN(14) FONT(2) BGND(9) CTYPE(2) GROUPS(1)
    TYPE(TEXT)     NAME(ucetdohdw->czkratMenF)   CPOS(33,0.05) CLEN( 5) FONT(2) BGND(9)

    TYPE(TEXT)     CAPTION(kurz/pøepoèet)        CPOS(43,0.05)  CLEN(15) FONT(2)
    TYPE(TEXT)     NAME(ucetdohdw->nkurzMENU)    CPOS(60,0.05) CLEN(15) FONT(2) BGND(9) CTYPE(2)
    TYPE(TEXT)     CAPTION(/)                    CPOS(77,0.1)  CLEN( 2) FONT(5)
    TYPE(TEXT)     NAME(ucetdohdw->nmnozPREU)    CPOS(82,0.05) CLEN( 9) FONT(2) BGND(9) CTYPE(2)
  TYPE(END)