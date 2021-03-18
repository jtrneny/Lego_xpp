TYPE(drgForm) DTYPE(10) TITLE(Faktura pøijatá) SIZE(100,25) FILE(FAKPRIHDW)   ;
                                                            POST(postValidate);
                                                            CBSAVE(onSave)    ;
                                                            GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)


  TYPE(Action) CAPTION(~Likvidace)      EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
  TYPE(Action) CAPTION(~Párování záloh) EVENT(FIN_PARPRZAL)     TIPTEXT(Párování zálohových faktur)


  TYPE(Static) STYPE(13) SIZE(98,15.5) FPOS(1,0.3) RESIZE(y)
    TYPE(GET) NAME(DPORIZFAK)       FPOS(11,0.5) FLEN(11) FCAPTION(Datum ...   )  CPOS( 2,0.5) PP(2) PUSH(CLICKDATE)
    TYPE(COMBOBOX) NAME(COBDOBI)    FPOS(31,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(24,0.5) PP(2)
    TYPE(COMBOBOX) NAME(COBDOBIDAN) FPOS(50,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(42,0.5) PP(2)
    TYPE(ComboBox) NAME(cTYPPOHYBU) FPOS(62,0.5) FLEN(35) VALUES(a,a,a,a)             ;
                                                          ITEMMARKED(comboItemMarked) ;
                                                          ITEMSELECTED(comboItemSelected) PP(2)

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(96,12.6)
      TYPE(TEXT) CAPTION(Daòový doklad faktura) CPOS( 1,-.25) CLEN(17)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(49,-.25) CLEN(10)

      TYPE(GET) NAME(NCISFAK)    FPOS(18,1) FLEN(10) FCAPTION(Faktura èíslo ...     )  CPOS( 1,1)             PP(2)
      TYPE(CHECKBOX) NAME(lno_indph) FPOS(30,1) FLEN(16) VALUES(T:vstupuje do DPH,F:vstupuje do DPH)

      TYPE(GET) NAME(CVARSYM)    FPOS(18,2) FLEN(10) FCAPTION(Variabilní symbol ... )  CPOS( 1,2)             PP(2)
      TYPE(GET) NAME(NKONSTSYMB) FPOS(18,3) FLEN(10) FCAPTION(Konstantní symbol ... )  CPOS( 1,3)             PP(2)
        TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(30,3) CLEN(15) BGND(13)

      TYPE(GET) NAME(CCISOBJ)    FPOS(18,4) FLEN(10) FCAPTION(Èíslo objednávky ...  )  CPOS( 1,4)

**    ODBÌRATEL
      TYPE(STATIC) STYPE(2) FPOS(0,5) SIZE(47.3,4) CAPTION(ODBÌRATEL)
        TYPE(GET) NAME(CBANK_UCT)  FPOS(18,1) FLEN(25) FCAPTION(Uhradit z úètu ...  )   CPOS( 1,1)             PP(2)
        TYPE(GET) NAME(CVNBAN_UCT) FPOS(18,2) FLEN(25) FCAPTION(Vnitro úèet ...  )      CPOS( 1,2)
        TYPE(GET) NAME(CTEXTFAKT)  FPOS( 1,3)  FLEN(42)
      TYPE(End)
*
      TYPE(STATIC) STYPE(2) FPOS(47,0) SIZE(50,9)
        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(25) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL)
         TYPE(TEXT)     CAPTION([)      CPOS(40,1) CLEN( 2)
         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(41,1) CLEN( 5) CTYPE(2) PICTURE(@N 99999)
         TYPE(TEXT)     CAPTION(])      CPOS(46,1) CLEN( 2)
        
        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
         TYPE(GET) NAME(CDIC)       FPOS(23,2) FLEN(15)

        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(25) FCAPTION(Název ...  )             CPOS(2,3)
        TYPE(GET) NAME(CNAZEV2)    FPOS(13,4) FLEN(25)
        TYPE(GET) NAME(CULICE)     FPOS(13,5) FLEN(25) FCAPTION(Ulice ...  )             CPOS(2,5)
        TYPE(GET) NAME(CPSC)       FPOS(13,6) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,6)
        TYPE(GET) NAME(CSIDLO)     FPOS(23,6) FLEN(24)
        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,7) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,7)             PP(2)
         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(23,7) CLEN(25) BGND(13)
        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,8) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,8)             PP(2)
         TYPE(TEXT) NAME(hd_ucet->CNAZ_UCT) CPOS(23,8) CLEN(25) BGND(13)
      TYPE(END)
*
      TYPE(GET) NAME(DVYSTFAKDO) FPOS(60, 9.8) FLEN(11) FCAPTION(Datum vyst/uzp ... )  CPOS(45, 9.8) CTYPE(2) CLEN(15) PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(DVYSTFAK)   FPOS(73, 9.8) FLEN(11)                                              CTYPE(2)          PP(2) PUSH(CLICKDATE)
*      TYPE(GET) NAME(DVYSTFAK)   FPOS(73, 9.8) FLEN(11)                                              CTYPE(2) PP(2) PUSH(CLICKDATE) NOREVISION()
      TYPE(GET) NAME(DSPLATFAK)  FPOS(60,10.8) FLEN(11) FCAPTION(Datum splatnosti... ) CPOS(45,10.8) CTYPE(2) CLEN(15) PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(CZKRTYPUHR) FPOS(60,11.8) FLEN(11) FCAPTION(Typ úhrady ... )      CPOS(46,11.8)          CLEN(12) PP(2)
        TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(73,11.8) CLEN(22) BGND(13)

      TYPE(GET) NAME(NCENZAHCEL) FPOS(18, 9.8) FLEN(13) FCAPTION(Uhradit celkem  ... ) CPOS( .7, 9.8) CLEN(15) CTYPE(2)

      TYPE(STATIC) STYPE(2) FPOS(1,10.8) SIZE(32.5,1.05) GROUPS(1,4,6)
        TYPE(TEXT)                  CAPTION(Párovaná záloha ... ) CPOS( 1,0.4) CLEN(15)          PP(2)
        TYPE(GET)  NAME(NPARZAHFAK)                               FPOS(17,0.4) FLEN(14) PP(2) PUSH(fin_parprzal) GROUPS(1,4,6)
      TYPE(END)

    TYPE(End)
  TYPE(End)

* FAKPB - Bìžná faktura - 1 / FAKPEU - Euro faktura - 6
  TYPE(Static) STYPE(13) SIZE(98,7)  FPOS(1,16.2) RESIZE(y) GROUPS(1)
    TYPE(ComboBox) NAME(CZKRATMENZ)  FPOS(18, .5) FLEN(26) FCAPTION(Zahranièní mìna ... ) CPOS( 1, .5)                   PP(2) GROUPS(1) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate)
    TYPE(GET)      NAME(NKURZAHMEN)  FPOS(18,1.5) FLEN(13) FCAPTION(Kurz/Pøepoèet ... )   CPOS( 1,1.5) CLEN(15) CTYPE(2) PP(2) GROUPS(1)
    TYPE(GET)      NAME(NMNOZPREP)   FPOS(33,1.5) FLEN(10)                                                      CTYPE(2) PP(2) GROUPS(1)

    TYPE(GET)      NAME(NCENZAKCEL)  FPOS(18,3.5) FLEN(13) FCAPTION(V základní mìnì ... ) CPOS( 1,3.5)          CTYPE(2)       GROUPS(1)

    TYPE(TEXT)     CAPTION(Rozdíl ____________) CPOS( 1,4.5) CLEN(17)          GROUPS(1)
    TYPE(TEXT)     NAME(NZUSTPOZAO)             CPOS(18,4.5) CLEN(14) BGND(13) GROUPS(1) PP(2) CTYPE(2)
*-
    TYPE(GET)      NAME(NKURZAHMED)  FPOS(61, .5) FLEN(10) FCAPTION(Kurz/Pøep ... )       CPOS(47, .5)                   PP(2) GROUPS(1)
    TYPE(GET)      NAME(NMNOZPRED)   FPOS(73, .5) FLEN( 8)                                                      CTYPE(2) PP(2) GROUPS(1)
    TYPE(TEXT)     CAPTION([)        CPOS(82, .5) CLEN( 2)
    TYPE(TEXT)     NAME(M->prepZakl) CPOS(83, .5) CLEN(12) CTYPE(2) PICTURE(@N 9999999999.99)
    TYPE(TEXT)     CAPTION(])        CPOS(95, .5) CLEN( 2)

    TYPE(TEXT)                                             CAPTION(Bez danì  ...)        CPOS(47,1.5)                   PP(2)
    TYPE(GET)      NAME(NOSVODDAN)   FPOS(73,1.5) FLEN(13)                                                      CTYPE(2)       GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(47,2.5)                   PP(2)
    TYPE(ComboBox) NAME(nPROCDAN_1)  FPOS(61,2.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(69,2.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_1)  FPOS(73,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(51,3.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(73,3.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(47,4.5)                   PP(2)
    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(61,4.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(69,4.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(73,4.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(51,5.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(73,5.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)
  TYPE(End)

* FAKPC - Celní faktura -2
  TYPE(Static) STYPE(13) SIZE(98,7) FPOS(1,16.2) RESIZE(y) GROUPS(2)

    TYPE(TEXT)    CAPTION(ROZÚÈTOVÁNÍ Z CELNÍHO ÚØADU) CPOS(51, .5) CLEN(30)
    TYPE(TEXT)    CAPTION(snížená                        základní)     CPOS(62,1.5) CLEN(30)
    TYPE(GET)     NAME(NCELZAKL_1) FPOS(62,2.5) FLEN(13) FCAPTION(Základ clo  ... )      CPOS(51,2.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_1)  FPOS(62,3.5) FLEN(13) FCAPTION(Clo  ... )             CPOS(51,3.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_1)  FPOS(62,4.5) FLEN(13) FCAPTION(Spd  ... )             CPOS(51,4.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_1)  FPOS(62,5.5) FLEN(13) FCAPTION(Další náklady ... )    CPOS(51,5.5)  CTYPE(2) GROUPS(2)

    TYPE(GET)     NAME(NCELZAKL_2) FPOS(78,2.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_2)  FPOS(78,3.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_2)  FPOS(78,4.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_2)  FPOS(78,5.5) FLEN(13)                                               CTYPE(2) GROUPS(2)

    TYPE(GET)      NAME(NOSVODDAN)  FPOS(18, .5) FLEN(13) FCAPTION(Bez danì ... )        CPOS( 1, .5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(GET)      NAME(NZAKLDAN_1) FPOS(18,1.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,1.5)  CTYPE(2)       GROUPS(2)
    TYPE(ComboBox) NAME(nPROCDAN_1) FPOS(33,1.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,1.5)   CLEN(5) PP(2) GROUPS(2)
    TYPE(GET     ) NAME(NSAZDAN_1)  FPOS(18,2.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,2.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(GET)      NAME(NZAKLDAN_2) FPOS(18,3.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,3.5)  CTYPE(2)       GROUPS(2)
    TYPE(ComboBox) NAME(nPROCDAN_2) FPOS(33,3.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,3.5)   CLEN(5) PP(2) GROUPS(2)
    TYPE(GET)      NAME(NSAZDAN_2)  FPOS(18,4.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,4.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)
  TYPE(End)

* FAKPZ - Zálohová faktura - 3
  TYPE(Static) STYPE(13) SIZE(98,7) FPOS(1,16.2) RESIZE(y) GROUPS(3)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(20, 2)                GROUPS(3) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(3)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(3)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(3)
  TYPE(End)

* FAKPZB - Zahranièní bìžná - 4
  TYPE(Static) STYPE(13) SIZE(98,7) FPOS(1,16.2) RESIZE(y) GROUPS(4)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(20, 2)                GROUPS(4) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(4)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(4)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(4)
  TYPE(End)

* FAKPZZ - Zahranièní zálohová - 5
  TYPE(Static) STYPE(13) SIZE(98,7) FPOS(1,16.2) RESIZE(y) GROUPS(5)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna     ... )     CPOS(33, 2)                GROUPS(5) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )      CPOS(20, 3) CTYPE(2) PP(2) GROUPS(5)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)        CPOS(20, 4) CTYPE(2) PP(2) GROUPS(5)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )  CPOS(20, 5) CTYPE(2)       GROUPS(5)
  TYPE(End)


 TYPE(GET) NAME(CJMENOPREV) FPOS(12,23.5) FLEN(25)  FCAPTION(Pøevzal ...)               CPOS( 2,23.5) CLEN(10)
 TYPE(GET) NAME(DDATPREVZ)  FPOS(50,23.5) FLEN(11)  FCAPTION(Dne ... )                  CPOS(40,23.5)           PUSH(CLICKDATE)
 TYPE(GET) NAME(DDATVRATIL) FPOS(76,23.5) FLEN(11)  FCAPTION(Vrátil ...)                CPOS(66,23.5)           PUSH(CLICKDATE)

 TYPE(PushButton) POS(93,23.5) SIZE(5,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakprihdw->mpopisfak,1)

** TYPE(PushButton) POS(95.8,23.5) SIZE(5,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakprihdw->mpopisfak,1)
