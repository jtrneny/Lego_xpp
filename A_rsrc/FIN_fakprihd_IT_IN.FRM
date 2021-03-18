TYPE(drgForm) DTYPE(10) TITLE(Faktura pøijatá) SIZE(110,27) FILE(FAKPRIHDW)   ;
                                                            POST(postValidate);
                                                            CBSAVE(onSave)    ;
                                                            GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)


**  TYPE(Action) CAPTION(~Likvidace)      EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)

  TYPE(Action) CAPTION(      ~Likvidace)      EVENT(set_likvidace_in) TIPTEXT(Uloží doklad a nabídne likvidaci faktury pøijaté) ICON1(101) ATYPE(3)
  TYPE(Action) CAPTION(~Výkaz DPH)            EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

*  TYPE(Static) STYPE(12) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y) CTYPE(2)

  TYPE(Static) STYPE(14) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y)
    TYPE(GET) NAME(DPORIZFAK)       FPOS(11,0.5) FLEN(11) FCAPTION(Datum ...   )  CPOS( 2,0.5) PP(2) PUSH(CLICKDATE)
    TYPE(COMBOBOX) NAME(COBDOBI)    FPOS(31,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(24,0.5) PP(2)
    TYPE(COMBOBOX) NAME(COBDOBIDAN) FPOS(50,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(42,0.5) PP(2)
    TYPE(ComboBox) NAME(cTYPPOHYBU) FPOS(66,0.5) FLEN(38) VALUES(a,a,a,a)             ;
                                                          ITEMMARKED(comboItemMarked) ;
                                                          ITEMSELECTED(comboItemSelected) PP(2) NOREVISION() 

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(106,9)
      TYPE(TEXT) CAPTION(Daòový doklad faktura) CPOS( 1,-.25) CLEN(17)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(54,-.25) CLEN(10)

      TYPE(GET) NAME(NCISFAK)    FPOS(18,1) FLEN(10) FCAPTION(Faktura èíslo ...     )  CPOS( 1,1)             PP(2) NOREVISION()
      TYPE(CHECKBOX) NAME(lno_indph) FPOS(30,1) FLEN(16) VALUES(T:vstupuje do DPH,F:vstupuje do DPH)

      TYPE(TEXT) CAPTION(Daò_dokl/V_symbol ...)   CPOS( 1,2) PP(2)
      TYPE(GET)  NAME(cdanDoklad)                 FPOS(18,2) FLEN(20) PP(2)      
      TYPE(GET)  NAME(CVARSYM)                    FPOS(40,2) FLEN(10) PP(2)

      TYPE(GET)  NAME(NKONSTSYMB) FPOS(18,3) FLEN(10) FCAPTION(Konstantní symbol ... )  CPOS( 1,3)             PP(2)
      TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(30,3) CLEN(18) 
*
      TYPE(STATIC) STYPE(2) FPOS(52,0) SIZE(54,9)
        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(27) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL)
         TYPE(TEXT)     CAPTION([)      CPOS(42,1) CLEN( 2)
         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(43,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
         TYPE(TEXT)     CAPTION(])      CPOS(49,1) CLEN( 2)
        
        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
        TYPE(GET) NAME(CDIC)       FPOS(25,2) FLEN(15)

        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(27) FCAPTION(Název ...  )             CPOS(2,3)
      TYPE(END)   
    TYPE(END)
  TYPE(END)    

***
  TYPE(TabPage) FPOS(1,6.5) SIZE(108,20.2) CAPTION(hlavièka) OFFSET( 1,82) PRE(tabSelect) TTYPE(3) TABHEIGHT(.8)

    TYPE(STATIC) STYPE(2) FPOS(1,-1) SIZE(106,6)
      TYPE(GET) NAME(CCISOBJ)    FPOS(18,1) FLEN(10) FCAPTION(Èíslo objednávky ...  )  CPOS( 1,1)  

      TYPE(STATIC) STYPE(2) FPOS(0,2) SIZE(52.1,4) CAPTION(ODBÌRATEL)
        TYPE(GET) NAME(CBANK_UCT)  FPOS(18,1) FLEN(25) FCAPTION(Uhradit z úètu ...  )   CPOS( 1,1)             PP(2)
        TYPE(GET) NAME(CVNBAN_UCT) FPOS(18,2) FLEN(25) FCAPTION(Vnitro úèet ...  )      CPOS( 1,2)
        TYPE(GET) NAME(CTEXTFAKT)  FPOS( 1,3)  FLEN(42)
      TYPE(End)

      TYPE(STATIC) STYPE(2) FPOS(52,-1) SIZE(54,9)
*        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(25) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL)
*         TYPE(TEXT)     CAPTION([)      CPOS(40,1) CLEN( 2)
*         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(41,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
*         TYPE(TEXT)     CAPTION(])      CPOS(47,1) CLEN( 2)
        
*        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
*         TYPE(GET) NAME(CDIC)       FPOS(23,2) FLEN(15)

*        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(25) FCAPTION(Název ...  )             CPOS(2,3)

        TYPE(GET) NAME(CNAZEV2)    FPOS(13,2) FLEN(27)
        TYPE(GET) NAME(CULICE)     FPOS(13,3) FLEN(27) FCAPTION(Ulice ...  )             CPOS(2,3)
        TYPE(GET) NAME(CPSC)       FPOS(13,4) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,4)
        TYPE(GET) NAME(CSIDLO)     FPOS(25,4) FLEN(24)
        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,5) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,5)             PP(2)
         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(25,5) CLEN(25) BGND(13)

        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,6) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,6)             PP(2)
         TYPE(TEXT) NAME(hd_ucet->CNAZ_UCT) CPOS(25,6) CLEN(25) BGND(13)
      TYPE(END)   
    TYPE(END)
*
    TYPE(STATIC) STYPE(2) FPOS(1,6) SIZE(106,3.5)
      TYPE(GET) NAME(DVYSTFAKDO) FPOS(74,  .8) FLEN(11) FCAPTION(Datum vyst/uzp ... )  CPOS(51,  .8) CTYPE(2) CLEN(15) PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(DVYSTFAK)   FPOS(88,  .8) FLEN(11)                                              CTYPE(2)          PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(DSPLATFAK)  FPOS(74, 1.8) FLEN(11) FCAPTION(Datum splatnosti... ) CPOS(51, 1.8) CTYPE(2) CLEN(15) PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(CZKRTYPUHR) FPOS(74, 2.8) FLEN(11) FCAPTION(Typ úhrady ... )      CPOS(52, 2.8)          CLEN(12) PP(2)
        TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(87,2.8) CLEN(20)

      TYPE(GET) NAME(NCENZAHCEL) FPOS(18,  .8) FLEN(13) FCAPTION(Uhradit celkem  ... ) CPOS( .7,  .8) CLEN(15) CTYPE(2)

      TYPE(STATIC) STYPE(2) FPOS(1,1.8) SIZE(32.5,1.05) GROUPS(1,4,6)
        TYPE(TEXT)                  CAPTION(Párovaná záloha ... ) CPOS( 1,0.4) CLEN(15)          PP(2)     GROUPS(1,4,6)
        TYPE(GET)  NAME(NPARZAHFAK)                               FPOS(17,0.4) FLEN(14) PUSH(fin_parprzal) GROUPS(1,4,6)
      TYPE(END)
    TYPE(End)

* FAKPB - Bìžná faktura - 1 / FAKPEU - Euro faktura - 6
  TYPE(Static) STYPE(13) SIZE(106,7)  FPOS(1,10) RESIZE(y) GROUPS(1)
    TYPE(ComboBox) NAME(CZKRATMENZ)  FPOS(18, .5) FLEN(26) FCAPTION(Zahranièní mìna ... ) CPOS( 1, .5)                   PP(2) GROUPS(1) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate) NOREVISION()
    TYPE(GET)      NAME(NKURZAHMEN)  FPOS(18,1.5) FLEN(13) FCAPTION(Kurz/Pøepoèet ... )   CPOS( 1,1.5) CLEN(15) CTYPE(2) PP(2) GROUPS(1) NOREVISION()
    TYPE(GET)      NAME(NMNOZPREP)   FPOS(33,1.5) FLEN(10)                                                      CTYPE(2) PP(2) GROUPS(1) NOREVISION()

    TYPE(GET)      NAME(NCENZAKCEL)  FPOS(18,3.5) FLEN(13) FCAPTION(V základní mìnì ... ) CPOS( 1,3.5)          CTYPE(2)       GROUPS(1)

    TYPE(TEXT)     CAPTION(Rozdíl ____________) CPOS( 1,4.5) CLEN(17)          GROUPS(1)
    TYPE(TEXT)     NAME(NZUSTPOZAO)             CPOS(18,4.5) CLEN(14) BGND(13) GROUPS(1) PP(2) CTYPE(2)
*-
    TYPE(GET)      NAME(NKURZAHMED)  FPOS(63, .5) FLEN(10) FCAPTION(Kurz/Pøep ... )       CPOS(52, .5)                   PP(2) GROUPS(1)
    TYPE(GET)      NAME(NMNOZPRED)   FPOS(75, .5) FLEN( 8)                                                      CTYPE(2) PP(2) GROUPS(1)
    TYPE(TEXT)     CAPTION([)        CPOS(87, .5) CLEN( 2)
    TYPE(TEXT)     NAME(M->prepZakl) CPOS(88, .5) CLEN(12) CTYPE(2) PICTURE(@N 9999999999.99)
    TYPE(TEXT)     CAPTION(])        CPOS(100, .5) CLEN( 2)

    TYPE(TEXT)                                             CAPTION(Bez danì)             CPOS(52,2.0)                   PP(2)
    TYPE(GET)      NAME(NOSVODDAN)   FPOS(63,2.0) FLEN(13)                                                      CTYPE(2)       GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Sazba danì )          CPOS(52,3.8)                   PP(2)
    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(52,4.8)                   PP(2)
    TYPE(TEXT)                                             CAPTION(Odvod danì)           CPOS(52,5.8)                   PP(2)


    TYPE(ComboBox) NAME(nPROCDAN_3)  FPOS(66,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(74,3.8) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_3)  FPOS(63,4.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_3)   FPOS(63,5.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_1)  FPOS(80,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(88,3.8) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_1)  FPOS(77,4.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(77,5.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(94,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(102,3.8) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(91,4.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(91,5.8) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

  TYPE(End)

* FAKPC - Celní faktura -2
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(2)

    TYPE(TEXT)    CAPTION(ROZÚÈTOVÁNÍ Z CELNÍHO ÚØADU) CPOS(52, .5) CLEN(30)
    TYPE(TEXT)    CAPTION(snížená_2                snížená                    základní)     CPOS(67,1.5) CLEN(50)
    TYPE(GET)     NAME(NCELZAKL_3) FPOS(66,2.5) FLEN(12) FCAPTION(Základ clo  )      CPOS(51,2.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_3)  FPOS(66,3.5) FLEN(12) FCAPTION(Clo  )             CPOS(51,3.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_3)  FPOS(66,4.5) FLEN(12) FCAPTION(Spd  )             CPOS(51,4.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_3)  FPOS(66,5.5) FLEN(12) FCAPTION(Další náklady )    CPOS(51,5.5)  CTYPE(2) GROUPS(2)

    TYPE(GET)     NAME(NCELZAKL_1) FPOS(79,2.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_1)  FPOS(79,3.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_1)  FPOS(79,4.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_1)  FPOS(79,5.5) FLEN(12)                                               CTYPE(2) GROUPS(2)

    TYPE(GET)     NAME(NCELZAKL_2) FPOS(92,2.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_2)  FPOS(92,3.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_2)  FPOS(92,4.5) FLEN(12)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_2)  FPOS(92,5.5) FLEN(12)                                               CTYPE(2) GROUPS(2)

    TYPE(GET)      NAME(NOSVODDAN)  FPOS(18, .5) FLEN(13) FCAPTION(Bez danì ... )        CPOS( 1, .5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Sazba danì )          CPOS(1,3.8)   CLEN(10)        PP(2)
    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(1,4.8)   CLEN(10)        PP(2)
    TYPE(TEXT)                                             CAPTION(Odvod danì)           CPOS(1,5.8)   CLEN(10)        PP(2)

    TYPE(ComboBox) NAME(nPROCDAN_3)  FPOS(14,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(22,3.8) CLEN(3)           PP(2) GROUPS(2)
    TYPE(GET)      NAME(NZAKLDAN_3)  FPOS(12,4.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_3)   FPOS(12,5.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_1)  FPOS(27,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(35,3.8) CLEN(3)           PP(2) GROUPS(2)
    TYPE(GET)      NAME(NZAKLDAN_1)  FPOS(25,4.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(25,5.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(40,3.8) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(48,3.8) CLEN(3)           PP(2) GROUPS(2)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(38,4.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(38,5.8) FLEN(12)                                                                    GROUPS(2) PUSH(FIN_VYKDPH_IN)


*    TYPE(GET)      NAME(NZAKLDAN_1) FPOS(18,1.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,1.5)  CTYPE(2)       GROUPS(2)
*    TYPE(ComboBox) NAME(nPROCDAN_1) FPOS(33,1.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,1.5)   CLEN(5) PP(2) GROUPS(2)
*    TYPE(GET     ) NAME(NSAZDAN_1)  FPOS(18,2.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,2.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

*    TYPE(GET)      NAME(NZAKLDAN_2) FPOS(18,3.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,3.5)  CTYPE(2)       GROUPS(2)
*    TYPE(ComboBox) NAME(nPROCDAN_2) FPOS(33,3.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,3.5)   CLEN(5) PP(2) GROUPS(2)
*    TYPE(GET)      NAME(NSAZDAN_2)  FPOS(18,4.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,4.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)
  TYPE(End)

* FAKPZ - Zálohová faktura - 3
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(3)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(33, 2)                GROUPS(3) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) NOREVISION()
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(3) NOREVISION()
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(3) NOREVISION()
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(3)
  TYPE(End)

* FAKPZB - Zahranièní bìžná - 4
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(4)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(20, 2)                GROUPS(4) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) NOREVISION()
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(4) NOREVISION()
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(4) NOREVISION()
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(4)
  TYPE(End)

* FAKPZZ - Zahranièní zálohová - 5
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(5)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna     ... )     CPOS(33, 2)                GROUPS(5) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) NOREVISION()
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )      CPOS(20, 3) CTYPE(2) PP(2) GROUPS(5) NOREVISION()
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)        CPOS(20, 4) CTYPE(2) PP(2) GROUPS(5) NOREVISION()
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )  CPOS(20, 5) CTYPE(2)       GROUPS(5)
  TYPE(End)


 TYPE(GET) NAME(CJMENOPREV) FPOS(12,17.5) FLEN(25)  FCAPTION(Pøevzal ...)               CPOS( 2,17.5) CLEN(10)
 TYPE(GET) NAME(DDATPREVZ)  FPOS(50,17.5) FLEN(11)  FCAPTION(Dne ... )                  CPOS(40,17.5)           PUSH(CLICKDATE)
 TYPE(GET) NAME(DDATVRATIL) FPOS(76,17.5) FLEN(11)  FCAPTION(Vrátil ...)                CPOS(66,17.5)           PUSH(CLICKDATE)

 TYPE(PushButton) POS(93,17.5) SIZE(5,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakprihdw->mpopisfak,1)
TYPE(End)


* položky
TYPE(TabPage) FPOS(1,6.5) SIZE(108,20.2) CAPTION(položky)  OFFSET(16,68) PRE(tabSelect) TTYPE(3) TABHEIGHT(.8)

  TYPE(Text)  CAPTION(typPoložky)          CPOS(1,0.01) CLEN(11) CTYPE(1)                      

  TYPE(DBrowse) FPOS(0,11.4) SIZE(107,8.2) FILE(FAKPRIITw)                      ;
                                           FIELDS(M->cenPol:c:2.6::2          , ;
                                                  M->isZalFak:z:3.6::2        , ; 
                                                  nintcount:polDokl           , ;
                                                  csklpol:sklPoložka:15       , ;
                                                  cnazzbo:název zboží:28      , ;
                                                  nfaktmnoz:faktMnož          , ;
                                                  czkratjedn:mj               , ;     
                                                  M->cena_za_mj:cena/mj:10    , ;
                                                  ncecprkdz:cenaCelkem        , ;
                                                  ncisloDD:odklad_Pz          , ;
                                                  M->bc_osvOdDane:osvOdDanì:12, ;
                                                  M->bc_zaklDph_s:zaklDph_s:12, ;
                                                  M->bc_sazDph_s:sazDph_s:12  , ;
                                                  M->bc_zaklDph_z:zaklDph_z:12, ;
                                                  M->bc_sazDph_z:sazDph_z:12    ) ;
                                           CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(nn) 

  TYPE(CHECKBOX) NAME(FAKPRIITw->lcelPol)  FPOS(2,1.1) FLEN(10) VALUES(T:celní,F:obecná) 

 
* bìžná položka dokladu
    TYPE(STATIC) FPOS(15,0) SIZE(92.5,2.4) CTYPE(3) PP(2) GROUPS(FAB)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 3  ,-0.1) CLEN(12) CTYPE(1) GROUPS(FAB,SETFONT,8.Cambria,GRA_CLR_BLACK)  
        TYPE(Text)  CAPTION([)                 CPOS(.2  , 0.5) CLEN( 2) CTYPE(2) GROUPS(FAB,SETFONT,7.Arial CE) 
        TYPE(Text)  NAME(FAKPRIITw->ccissklad) CPOS( 2  , 0.5) CLEN(14) CTYPE(1) GROUPS(FAB,SETFONT,7.Arial CE) 
        TYPE(Text)  CAPTION(])                 CPOS(15.8, 0.5) CLEN( 2) CTYPE(2) GROUPS(FAB,SETFONT,7.Arial CE) 
      TYPE(Text)  CAPTION(èísloDodListu)       CPOS(19  ,-0.1) CLEN(12) CTYPE(2) GROUPS(FAB,SETFONT,8.Cambria,GRA_CLR_BLACK)   
      TYPE(Text)  CAPTION(èísloObjednávky)     CPOS(39  ,-0.1) CLEN(13) CTYPE(2) GROUPS(FAB,SETFONT,8.Cambria,GRA_CLR_BLACK)   
      TYPE(Text)  CAPTION(èísloZálFaktury)     CPOS(59  ,-0.1) CLEN(12) CTYPE(2) GROUPS(FAB,SETFONT,8.Cambria,GRA_CLR_BLACK)   
        TYPE(Text)  CAPTION([)                 CPOS(56  , 0.5) CLEN( 2) CTYPE(2) GROUPS(FAB,SETFONT,7.Arial CE) 
**        TYPE(Text)  NAME(FAKPRIITw->ncisloDD)  CPOS(57  , 0.5) CLEN(14) CTYPE(1) GROUPS(FAB,SETFONT,7.Arial CE)
        TYPE(TEXT)  NAME(M->parPrzal_kDis)     CPOS(57  , 0.6) CLEN(14) CTYPE(1) GROUPS(FAB,SETFONT,8.Arial CE)
        TYPE(Text)  CAPTION(])                 CPOS(71.8, 0.5) CLEN( 2) CTYPE(2) GROUPS(FAB,SETFONT,7.Arial CE) 


      TYPE(Get) NAME(FAKPRIITw->CSKLPOL)       FPOS( 1, 1.55) FLEN(15) PP(2) PUSH(fakturovat_z_sel) GROUPS(FAB)  
      TYPE(Get) NAME(FAKPRIITw->NCISLODL)      FPOS(18, 1.55) FLEN(15) PP(2) PUSH(fakturovat_z_sel) GROUPS(FAB)  
      TYPE(Get) NAME(FAKPRIITw->CCISLOBINT)    FPOS(35, 1.55) FLEN(20) PP(2) PUSH(fakturovat_z_sel) GROUPS(FAB)  
      TYPE(Get) NAME(FAKPRIITw->NCISZALFAK)    FPOS(57, 1.55) FLEN(15) PP(2) PUSH(fakturovat_z_sel) GROUPS(FAB)  
    TYPE(END)

* celní položka dokladu
    TYPE(STATIC) FPOS(15,0) SIZE(92.5,2.4) CTYPE(3) PP(2) GROUPS(FAC)
      TYPE(Text)  CAPTION(Základ Clo)          CPOS( 3,-0.1) CLEN(11) CTYPE(1) GROUPS(FAC,SETFONT,8.Cambria,GRA_CLR_BLACK)  
      TYPE(Text)  CAPTION(clo)                 CPOS(15,-0.1) CLEN(10) CTYPE(2) GROUPS(FAC,SETFONT,8.Cambria,GRA_CLR_BLACK)  
      TYPE(Text)  CAPTION(Spd)                 CPOS(29,-0.1) CLEN(13) CTYPE(2) GROUPS(FAC,SETFONT,8.Cambria,GRA_CLR_BLACK)  
      TYPE(Text)  CAPTION(dalšíNáklad)         CPOS(48,-0.1) CLEN(12) CTYPE(2) GROUPS(FAC,SETFONT,8.Cambria,GRA_CLR_BLACK)  
      TYPE(Text)  CAPTION(dovPøirážka)         CPOS(64,-0.1) CLEN(12) CTYPE(2) GROUPS(FAC,SETFONT,8.Cambria,GRA_CLR_BLACK)  

      TYPE(GET) NAME(FAKPRIITw->NCELZAKL)      FPOS( 1,1.2) FLEN(13) GROUPS(FAC) 
      TYPE(GET) NAME(FAKPRIITw->NCELCLO)       FPOS(17,1.2) FLEN(13) GROUPS(FAC)
      TYPE(GET) NAME(FAKPRIITw->NCELSPD)       FPOS(33,1.2) FLEN(13) GROUPS(FAC)
      TYPE(GET) NAME(FAKPRIITw->NCELDAL)       FPOS(49,1.2) FLEN(13) GROUPS(FAC)
      TYPE(GET) NAME(FAKPRIITw->NCELDOVP)      FPOS(65,1.2) FLEN(13) GROUPS(FAC)
    TYPE(END)


    TYPE(Get) NAME(FAKPRIITw->CNAZZBO)    FPOS( 1,3.2) FLEN(32)  PP(2)                            
    TYPE(Get) NAME(FAKPRIITw->NFAKTMNOZ)  FPOS(35,3.2) FLEN(15)  PP(2)                            
    TYPE(Get) NAME(FAKPRIITw->CZKRATJEDN) FPOS(52,3.2) FLEN( 6)  PP(2)                            
*   
    TYPE(GET) NAME(FAKPRIITw->NFAKTMNO2)  FPOS(69,3.2) FLEN(15)                                  
    TYPE(Get) NAME(FAKPRIITw->CZKRATJED2) FPOS(86,3.2) FLEN( 6)                                  
*
    TYPE(TEXT) CAPTION(% danì)       CPOS( 2,4.3) CLEN( 7)                                       
    TYPE(TEXT) CAPTION(rv_dph)       CPOS(10,4.3) CLEN( 6)                                       
    TYPE(TEXT) CAPTION(pdp)          CPOS(17,4.3) CLEN( 4)
    TYPE(TEXT) CAPTION(CENA)         CPOS(26,4.3) CLEN( 5) FONT(5) 
    TYPE(TEXT) CAPTION(základní)     CPOS(38,4.3) CLEN( 7)                                         
    TYPE(TEXT) CAPTION(sleva)        CPOS(52,4.3) CLEN( 5)                                         
    TYPE(TEXT) CAPTION(% slevy)      CPOS(61,4.3) CLEN( 7)                                         
    TYPE(TEXT) CAPTION(základ danì)  CPOS(71,4.3) CLEN(10) 
    TYPE(TEXT) CAPTION(daò)          CPOS(86,4.3) CLEN( 4)                                         
    TYPE(TEXT) CAPTION(celkem)       CPOS(99,4.3) CLEN( 6)                                         
  
    TYPE(Text) CAPTION(za MJ v)            CPOS(23.8,5.5) CLEN(6)                                     GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text) NAME(FakPriHdW->czkratMenZ) CPOS(29.2,5.5) CLEN(4)                                     GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text) CAPTION(za POL v)           CPOS(23.8,6.5) CLEN(7)                                     GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text) NAME(FakPriHdW->czkratMenZ) CPOS(30.2,6.5) CLEN(4)                                     GROUPS(FAK,SETFONT,7.Arial CE)      
    TYPE(Text) CAPTION(celkem v)           CPOS(23.8,7.5) CLEN(7)                                     GROUPS(FAK,SETFONT,7.Arial CE,GRA_CLR_RED)      
    TYPE(Text) NAME(FakPriHdW->czkratMenY) CPOS(30.2,7.5) CLEN(4)                                     GROUPS(FAK,SETFONT,7.Arial CE,GRA_CLR_RED)            
* 1
      TYPE(Get)   NAME(FAKPRIITw->NPROCDPH)      FPOS( 1,5.3 ) FLEN( 7)                             PP(2)
      TYPE(Get)   NAME(FAKPRIITw->NRADVYKDPH)    FPOS(10,5.3 ) FLEN( 6)                             PUSH(fin_vykdph_rv_sel) 
      TYPE(CHECKBOX) NAME(FAKPRIITw->lpreDanPov) FPOS(17,5.28) FLEN( 6.5) VALUES(T:ano,F:ne) 

      TYPE(COMBOBOX) NAME(FAKPRIITw->CTYPPREDAN)  FPOS( 1,6.25) FLEN(22) REF(CTYPPREDAN)          

      TYPE(Get)   NAME(FAKPRIITw->CUCETu_DPH)    FPOS( 1,8.22) FLEN( 7)   FCAPTION(úèetDph)    CPOS( 1,7.29) GROUPS(FAK,SETFONT,7.Arial CE) 
      TYPE(Get)   NAME(FAKPRIITw->nKRACE_nar)    FPOS(10,8.22) FLEN(10)   FCAPTION(kráceníDph) CPOS(12,7.29) GROUPS(FAK,SETFONT,7.Arial CE) 

* pohle konzultace JT-JP tento údaj od 1.1.2012 není povinný pro výkazy
*      TYPE(GET)      NAME(FAKPRIITw->cdanPzbo)    FPOS(20,8.20) FLEN(12) FCAPTION(jcd)         CPOS(17,8.20) CLEN(3) GROUPS(FAK,SETFONT,8.Arial CE) 
*      TYPE(TEXT)     NAME(c_celSaz->cnazDanp)     CPOS(33,8.20) CLEN(30)                                             GROUPS(FAK,SETFONT,7.Arial CE) 

      TYPE(Get)   NAME(FAKPRIITw->NCEJPRZBZ)  FPOS(34.2,5.5) FLEN(13)   PP(2)                        PUSH(cejPrZbz_push)
      TYPE(Get)   NAME(FAKPRIITw->NHODNSLEV)  FPOS(49  ,5.5) FLEN(10)                                
      TYPE(Get)   NAME(FAKPRIITw->NPROCSLEV)  FPOS(61  ,5.5) FLEN( 5)                                
      TYPE(Text)  NAME(FAKPRIITw->ncejprkbz)  CPOS(68  ,5.5) CLEN(13)  BGND(13) CTYPE(2)            
      TYPE(Text)  NAME(FAKPRIITw->ncejprkdz)  CPOS(94  ,5.5) CLEN(13)  BGND(13) CTYPE(2)  

* daò za MJ
      TYPE(TEXT)  NAME(M->txt_zaMJ_dan)       CPOS(80.5,5.5) CLEN(13)  CTYPE(2)                      PICTURE(@N 9999999999.99) GROUPS(FAK,SETFONT,8.Arial CE)             
* 2
      TYPE(Text)  NAME(FAKPRIITw->ncecprzbz)  CPOS(34.2,6.5) CLEN(14)  BGND(13) CTYPE(2)             PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKPRIITw->ncelkslev)  CPOS(49  ,6.5) CLEN(11)  BGND(13) CTYPE(2)             
      TYPE(GET)   NAME(FAKPRIITw->ncecprkbz)  FPOS(68  ,6.5) FLEN(12)  BGND(12) CTYPE(2)             PICTURE(@N 999999999.99)
      TYPE(GET)   NAME(FAKPRIITw->nsazDan_Z)  FPOS(81.5,6.5) FLEN(11)                                PICTURE(@N 99999999.99)    
      TYPE(Text)  NAME(FAKPRIITw->ncecprkdz)  CPOS(94  ,6.5) CLEN(13)  BGND(13) CTYPE(2)             PICTURE(@N 9999999999.99)

* daò za POL
*      TYPE(TEXT)  NAME(M->txt_zaPOL_dan)      CPOS(80.5,6.5) CLEN(13)  CTYPE(2)                      PICTURE(@N 9999999999.99) GROUPS(FAK,SETFONT,8.Arial CE)             
* 3
      TYPE(GET)  NAME(FAKPRIITw->ncenzakcel)  FPOS(68.2,7.5) CTYPE(2) FLEN(12)                       GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 999999999.99)
      TYPE(GET)  NAME(FAKPRIITw->nsazdan)     FPOS(81.5,7.5) CTYPE(2) FLEN(11)                       GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)       
      TYPE(TEXT) NAME(FAKPRIITw->ncenzakced)  CPOS(94  ,7.5) CTYPE(2) CLEN(13)                       GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)


* nákladový úèet + ns
    TYPE(Get) NAME(FAKPRIITw->CUCET)    FPOS(  1,10.15) FLEN( 9) FCAPTION(nákladovýÚèet) CPOS( 1,9.2) CLEN(10) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL1) FPOS( 27,10.15) FLEN(10) FCAPTION(VýrStøedisko)  CPOS(27,9.2) CLEN( 9) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL2) FPOS( 40,10.15) FLEN(10) FCAPTION(Výrobek)       CPOS(40,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL3) FPOS( 53,10.15) FLEN(10) FCAPTION(Zakázka)       CPOS(53,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL4) FPOS( 66,10.15) FLEN(10) FCAPTION(VýrMísto)      CPOS(66,9.2) CLEN( 7) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL5) FPOS( 79,10.15) FLEN(10) FCAPTION(Stroj)         CPOS(79,9.2) CLEN( 4) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL6) FPOS( 92,10.15) FLEN(10) FCAPTION(VýrOperace)    CPOS(92,9.2) CLEN( 8) GROUPS(FAK,SETFONT,7.Arial CE)

    TYPE(STATIC) FPOS(0.4,9.6) SIZE(108.6,.15) STYPE(8) CTYPE(2)
    TYPE(End)

* støední oddìlení dph a ceny
    TYPE(STATIC) FPOS(23.5,4.8) SIZE( .35,4.8) STYPE(7) CTYPE(3)
    TYPE(End)
    
*    TYPE(STATIC) FPOS(28,7.9) SIZE( 48, .05) STYPE(7) CTYPE(3)
*    TYPE(End)

*    TYPE(STATIC) FPOS(90,7.9) SIZE( 20, .05) STYPE(7) CTYPE(3)
*    TYPE(End)
*
    TYPE(STATIC) FPOS(0.4,4.8) SIZE(108.6,.15) STYPE(8) CTYPE(3)
    TYPE(End)

* memoEdit
    TYPE(PushButton) POS(104,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakpriITw->mpozzbo,0)
TYPE(End)


TYPE(Static) FPOS(36,26) SIZE(73.5,0.9) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(16)
* 1 a 6
  TYPE(TEXT) CAPTION(Uhradit v)          CPOS( 1  , 0.01) CLEN( 8)                                            
  TYPE(TEXT) NAME(FAKPRIHDw->czkratMenY) CPOS( 8.7, 0.01) CLEN( 4) 
  TYPE(Text) NAME(FAKPRIHDw->nCENZAKCEL) CPOS( 13 , 0.01) CLEN(12) FONT(5) BGND(1) PP(3) CTYPE(1) PICTURE(999999999.99)    
 
  TYPE(TEXT) CAPTION(bez danì)           CPOS(26, 0.01) CLEN( 8) GROUPS(FAK,SETFONT,7.Arial CE)
  TYPE(TEXT) NAME(fakpriHdw->_nsumCen)   CPOS(35, 0.01) CLEN(12) FONT(5) BGND(1) PP(3) CTYPE(1) PICTURE(999999999.99)   

  TYPE(Text) CAPTION(daò )               CPOS(47, 0.01) CLEN( 5) GROUPS(FAK,SETFONT,7.Arial CE)                                        
  TYPE(TEXT) NAME(fakpriHdw->_nsumDph)   CPOS(52, 0.01) CLEN(12) FONT(5) BGND(1) PP(3) CTYPE(1) PICTURE(999999999.99)   

  TYPE(Text) NAME(fakpriHdw->_nrozDok)   CPOS(62, 0.01) CLEN(12) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(FAK,SETFONT,9.Cambria,GRA_CLR_RED)   
TYPE(END)



* neviditelné pomocné položky
TYPE(TEXT) NAME(fakpriitw->cfile_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nrecs_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nnapocet)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nvypsazdan)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->njeddan)     FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncountDL)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncislPolob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nisParZal)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncisloDD)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nnullDph)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nCeJPrZDZ)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncenaSzbo)   FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakpriitw->nsubCount)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nparZalFak)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nparZahFak)  FPOS(0,0) CLEN(0)
*
TYPE(MLE)  NAME(fakpriitw->mpozzbo)     FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(MLE)  NAME(fakpriitw->mapolSest)   FPOS(0,0) SIZE(0,0) READONLY(y)
*
TYPE(TEXT) NAME(fakpriitw->_nrecor)     FPOS(0,0) CLEN(0)



