TYPE(drgForm) DTYPE(10) TITLE(Faktura pøijatá) SIZE(110,27) FILE(FAKPRIHDW)   ;
                                                            POST(postValidate);
                                                            CBSAVE(onSave)    ;
                                                            GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)


  TYPE(Action) CAPTION(~Likvidace)      EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
  TYPE(Action) CAPTION(~Párování záloh) EVENT(FIN_PARPRZAL)     TIPTEXT(Párování zálohových faktur)


  TYPE(Static) STYPE(12) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y) CTYPE(2)
    TYPE(GET) NAME(DPORIZFAK)       FPOS(11,0.5) FLEN(11) FCAPTION(Datum ...   )  CPOS( 2,0.5) PP(2) PUSH(CLICKDATE)
    TYPE(COMBOBOX) NAME(COBDOBI)    FPOS(31,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(24,0.5) PP(2)
    TYPE(COMBOBOX) NAME(COBDOBIDAN) FPOS(50,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(42,0.5) PP(2)
    TYPE(ComboBox) NAME(cTYPPOHYBU) FPOS(66,0.5) FLEN(38) VALUES(a,a,a,a)             ;
                                                          ITEMMARKED(comboItemMarked) ;
                                                          ITEMSELECTED(comboItemSelected) PP(2)

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(106,9)
      TYPE(TEXT) CAPTION(Daòový doklad faktura) CPOS( 1,-.25) CLEN(17)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(54,-.25) CLEN(10)

      TYPE(GET) NAME(NCISFAK)    FPOS(18,1) FLEN(10) FCAPTION(Faktura èíslo ...     )  CPOS( 1,1)             PP(2)
      TYPE(CHECKBOX) NAME(lno_indph) FPOS(30,1) FLEN(16) VALUES(T:vstupuje do DPH,F:nevstupuje do DPH)

      TYPE(GET) NAME(CVARSYM)    FPOS(18,2) FLEN(10) FCAPTION(Variabilní symbol ... )  CPOS( 1,2)             PP(2)
      TYPE(GET) NAME(NKONSTSYMB) FPOS(18,3) FLEN(10) FCAPTION(Konstantní symbol ... )  CPOS( 1,3)             PP(2)
        TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(30,3) CLEN(18) BGND(13)

*----
*----      TYPE(GET) NAME(CCISOBJ)    FPOS(18,4) FLEN(10) FCAPTION(Èíslo objednávky ...  )  CPOS( 1,4)

**    ODBÌRATEL
*----      TYPE(STATIC) STYPE(2) FPOS(0,5) SIZE(52.1,4) CAPTION(ODBÌRATEL)
*----        TYPE(GET) NAME(CBANK_UCT)  FPOS(18,1) FLEN(25) FCAPTION(Uhradit z úètu ...  )   CPOS( 1,1)             PP(2)
*----        TYPE(GET) NAME(CVNBAN_UCT) FPOS(18,2) FLEN(25) FCAPTION(Vnitro úèet ...  )      CPOS( 1,2)
*----        TYPE(GET) NAME(CTEXTFAKT)  FPOS( 1,3)  FLEN(42)
*----      TYPE(End)
*
      TYPE(STATIC) STYPE(2) FPOS(52,0) SIZE(54,9)
        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(25) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL)
         TYPE(TEXT)     CAPTION([)      CPOS(40,1) CLEN( 2)
         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(41,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
         TYPE(TEXT)     CAPTION(])      CPOS(47,1) CLEN( 2)
        
        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
        TYPE(GET) NAME(CDIC)       FPOS(23,2) FLEN(15)

        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(25) FCAPTION(Název ...  )             CPOS(2,3)
*----        TYPE(GET) NAME(CNAZEV2)    FPOS(13,4) FLEN(25)
*----        TYPE(GET) NAME(CULICE)     FPOS(13,5) FLEN(25) FCAPTION(Ulice ...  )             CPOS(2,5)
*----        TYPE(GET) NAME(CPSC)       FPOS(13,6) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,6)
*----        TYPE(GET) NAME(CSIDLO)     FPOS(23,6) FLEN(24)
*----        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,7) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,7)             PP(2)
*----         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(23,7) CLEN(25) BGND(13)
*----        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,8) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,8)             PP(2)
*----         TYPE(TEXT) NAME(C_UCTOSN->CNAZ_UCT) CPOS(23,8) CLEN(25) BGND(13)
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

        TYPE(GET) NAME(CNAZEV2)    FPOS(13,2) FLEN(25)
        TYPE(GET) NAME(CULICE)     FPOS(13,3) FLEN(25) FCAPTION(Ulice ...  )             CPOS(2,3)
        TYPE(GET) NAME(CPSC)       FPOS(13,4) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,4)
        TYPE(GET) NAME(CSIDLO)     FPOS(23,4) FLEN(24)
        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,5) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,5)             PP(2)
         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(23,5) CLEN(25) BGND(13)

        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,6) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,6)             PP(2)
         TYPE(TEXT) NAME(C_UCTOSN->CNAZ_UCT) CPOS(23,6) CLEN(25) BGND(13)
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
        TYPE(TEXT)                  CAPTION(Párovaná záloha ... ) CPOS( 1,0.4) CLEN(15)          PP(2)
        TYPE(GET)  NAME(NPARZAHFAK)                               FPOS(17,0.4) FLEN(14) PP(2) PUSH(fin_parprzal) GROUPS(1,4,6)
      TYPE(END)
    TYPE(End)

* FAKPB - Bìžná faktura - 1 / FAKPEU - Euro faktura - 6
  TYPE(Static) STYPE(13) SIZE(106,7)  FPOS(1,10) RESIZE(y) GROUPS(1)
    TYPE(ComboBox) NAME(CZKRATMENZ)  FPOS(18, .5) FLEN(26) FCAPTION(Zahranièní mìna ... ) CPOS( 1, .5)                   PP(2) GROUPS(1) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate)
    TYPE(GET)      NAME(NKURZAHMEN)  FPOS(18,1.5) FLEN(13) FCAPTION(Kurz/Pøepoèet ... )   CPOS( 1,1.5) CLEN(15) CTYPE(2) PP(2) GROUPS(1)
    TYPE(GET)      NAME(NMNOZPREP)   FPOS(33,1.5) FLEN(10)                                                      CTYPE(2) PP(2) GROUPS(1)

    TYPE(GET)      NAME(NCENZAKCEL)  FPOS(18,3.5) FLEN(13) FCAPTION(V základní mìnì ... ) CPOS( 1,3.5)          CTYPE(2)       GROUPS(1)

    TYPE(TEXT)     CAPTION(Rozdíl ____________) CPOS( 1,4.5) CLEN(17)          GROUPS(1)
    TYPE(TEXT)     NAME(NZUSTPOZAO)             CPOS(18,4.5) CLEN(14) BGND(13) GROUPS(1) PP(2) CTYPE(2)
*-
    TYPE(GET)      NAME(NKURZAHMED)  FPOS(66, .5) FLEN(10) FCAPTION(Kurz/Pøep ... )       CPOS(52, .5)                   PP(2) GROUPS(1)
    TYPE(GET)      NAME(NMNOZPRED)   FPOS(78, .5) FLEN( 8)                                                      CTYPE(2) PP(2) GROUPS(1)
    TYPE(TEXT)     CAPTION([)        CPOS(87, .5) CLEN( 2)
    TYPE(TEXT)     NAME(M->prepZakl) CPOS(88, .5) CLEN(12) CTYPE(2) PICTURE(@N 9999999999.99)
    TYPE(TEXT)     CAPTION(])        CPOS(100, .5) CLEN( 2)

    TYPE(TEXT)                                             CAPTION(Bez danì  ...)        CPOS(52,1.5)                   PP(2)
    TYPE(GET)      NAME(NOSVODDAN)   FPOS(78,1.5) FLEN(13)                                                      CTYPE(2)       GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(52,2.5)                   PP(2)
    TYPE(ComboBox) NAME(nPROCDAN_1)  FPOS(66,2.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(74,2.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_1)  FPOS(78,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(56,2.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(92,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(52,3.5)                   PP(2)
    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(66,3.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(74,3.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(78,3.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(56,3.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(92,3.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)
  TYPE(End)

* FAKPC - Celní faktura -2
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(2)

    TYPE(TEXT)    CAPTION(ROZÚÈTOVÁNÍ Z CELNÍHO ÚØADU) CPOS(52, .5) CLEN(30)
    TYPE(TEXT)    CAPTION(snížená                        základní)     CPOS(67,1.5) CLEN(30)
    TYPE(GET)     NAME(NCELZAKL_1) FPOS(67,2.5) FLEN(13) FCAPTION(Základ clo  ... )      CPOS(51,2.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_1)  FPOS(67,3.5) FLEN(13) FCAPTION(Clo  ... )             CPOS(51,3.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_1)  FPOS(67,4.5) FLEN(13) FCAPTION(Spd  ... )             CPOS(51,4.5)  CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_1)  FPOS(67,5.5) FLEN(13) FCAPTION(Další náklady ... )    CPOS(51,5.5)  CTYPE(2) GROUPS(2)

    TYPE(GET)     NAME(NCELZAKL_2) FPOS(83,2.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELCLO_2)  FPOS(83,3.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELSPD_2)  FPOS(83,4.5) FLEN(13)                                               CTYPE(2) GROUPS(2)
    TYPE(GET)     NAME(NCELDAL_2)  FPOS(83,5.5) FLEN(13)                                               CTYPE(2) GROUPS(2)

    TYPE(GET)      NAME(NOSVODDAN)  FPOS(18, .5) FLEN(13) FCAPTION(Bez danì ... )        CPOS( 1, .5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(GET)      NAME(NZAKLDAN_1) FPOS(18,1.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,1.5)  CTYPE(2)       GROUPS(2)
    TYPE(ComboBox) NAME(nPROCDAN_1) FPOS(33,1.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,1.5)   CLEN(5) PP(2) GROUPS(2)
    TYPE(GET     ) NAME(NSAZDAN_1)  FPOS(18,2.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,2.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)

    TYPE(GET)      NAME(NZAKLDAN_2) FPOS(18,3.5) FLEN(13) FCAPTION(Základ danì  % ... )  CPOS( 1,3.5)  CTYPE(2)       GROUPS(2)
    TYPE(ComboBox) NAME(nPROCDAN_2) FPOS(33,3.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)      CPOS(42,3.5)   CLEN(5) PP(2) GROUPS(2)
    TYPE(GET)      NAME(NSAZDAN_2)  FPOS(18,4.5) FLEN(13) FCAPTION( daò ... )            CPOS( 8,4.5)  CTYPE(2)       GROUPS(2) PUSH(FIN_VYKDPH_IN)
  TYPE(End)

* FAKPZ - Zálohová faktura - 3
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(3)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(33, 2)                GROUPS(3) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(3)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(3)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(3)
  TYPE(End)

* FAKPZB - Zahranièní bìžná - 4
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(4)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna ... )          CPOS(20, 2)                GROUPS(4) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )       CPOS(20, 3) CTYPE(2) PP(2) GROUPS(4)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)         CPOS(20, 4) CTYPE(2) PP(2) GROUPS(4)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )   CPOS(20, 5) CTYPE(2)       GROUPS(4)
  TYPE(End)

* FAKPZZ - Zahranièní zálohová - 5
  TYPE(Static) STYPE(13) SIZE(106,7) FPOS(1,10) RESIZE(y) GROUPS(5)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, 2) FLEN(26) FCAPTION(Zahranièní mìna     ... )     CPOS(33, 2)                GROUPS(5) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY)
    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50, 3) FLEN(13) FCAPTION(Aktuální kurz mìny ... )      CPOS(20, 3) CTYPE(2) PP(2) GROUPS(5)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(50, 4) FLEN(10) FCAPTION(Množství pøepoètu ...)        CPOS(20, 4) CTYPE(2) PP(2) GROUPS(5)
    TYPE(GET)      NAME(NCENZAKCEL) FPOS(50, 5) FLEN(13) FCAPTION(Celkem v základní mìnì ... )  CPOS(20, 5) CTYPE(2)       GROUPS(5)
  TYPE(End)


 TYPE(GET) NAME(CJMENOPREV) FPOS(12,17.5) FLEN(25)  FCAPTION(Pøevzal ...)               CPOS( 2,17.5) CLEN(10)
 TYPE(GET) NAME(DDATPREVZ)  FPOS(50,17.5) FLEN(11)  FCAPTION(Dne ... )                  CPOS(40,17.5)           PUSH(CLICKDATE)
 TYPE(GET) NAME(DDATVRATIL) FPOS(76,17.5) FLEN(11)  FCAPTION(Vrátil ...)                CPOS(66,17.5)           PUSH(CLICKDATE)

 TYPE(PushButton) POS(93,17.5) SIZE(5,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakprihdw->mpopisfak,1)
TYPE(End)


* položky
TYPE(TabPage) FPOS(1,6.5) SIZE(108,20.2) CAPTION(položky)  OFFSET(16,68) PRE(tabSelect) TTYPE(3) TABHEIGHT(.8)

* faktura
  TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 4,0.01) CLEN(11) CTYPE(1)                         GROUPS(FAK) 
    TYPE(Text)  CAPTION([)                 CPOS(.8,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(FAKPRIIT->ccissklad) CPOS( 2,0.80) CLEN(15) CTYPE(1)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(16,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloDodListu)       CPOS(21,0.01) CLEN(10) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloObjednávky)     CPOS(39,0.01) CLEN(13) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloVýrZakázky)     CPOS(68,0.01) CLEN(12) CTYPE(1)                         GROUPS(FAK)
    TYPE(Text)  CAPTION([)                 CPOS(62,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(FAKPRIIT->cskp)      CPOS(63,0.80) CLEN(15) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(82,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloZálFaktury)     CPOS(93,0.01) CLEN(12) CTYPE(2)                         GROUPS(FAK)


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,18.7) CTYPE(3) PP(2) 

    TYPE(DBrowse) FPOS(.5,11.4) SIZE(108,6.9) FILE(FAKPRIIT)                       ;
                                              FIELDS(M->cenPol:c:2.6::2          , ;
                                                     nintcount:polDokl           , ;
                                                     csklpol:sklPoložka          , ;
                                                     cnazzbo:název zboží:28      , ;
                                                     nfaktmnoz:faktMnož          , ;
                                                     M->k_disp_fak:k_dispozici:10, ;
                                                     czkratjedn:mj               , ;     
                                                     M->cena_za_mj:cena/mj:10    , ;
                                                     ncecprkdz:cenaCelkem          );
                                              CURSORMODE(3) PP(6) RESIZE(x) SCROLL(ny) POPUPMENU(nn) GROUPS(FAK)
 
* faktura
    TYPE(Get) NAME(FAKPRIIT->CSKLPOL)    FPOS( 1,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
**     TYPE(Text)  NAME(M->cenzboz_kDis)    CPOS( 2,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKPRIIT->NCISLODL)   FPOS(18,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
**     TYPE(Text)  NAME(M->dodlstit_kDis)   CPOS(19,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKPRIIT->CCISLOBINT) FPOS(35,1.2) FLEN(20) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
**     TYPE(Text)  NAME(M->objitem_kDis)    CPOS(36,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKPRIIT->CCISZAKAZI) FPOS(57,1.2) FLEN(33) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
**     TYPE(Text)  NAME(M->vyrzak_kDis)     CPOS(53,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKPRIIT->NCISZALFAK) FPOS(92,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)

    TYPE(Get) NAME(FAKPRIIT->CNAZZBO)    FPOS( 1,3.2) FLEN(32)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIIT->NFAKTMNOZ)  FPOS(35,3.2) FLEN(15)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIIT->CZKRATJEDN) FPOS(52,3.2) FLEN( 6)  PP(2)                             GROUPS(FAK)

**    TYPE(Text) NAME(vykdph_iw->comboText) CPOS(85,3.2) CLEN( 0) BGND(13)                           GROUPS(FAK)
*   
    TYPE(GET) NAME(FAKPRIIT->NFAKTMNO2)  FPOS(69,3.2) FLEN(15)                                    GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIIT->CZKRATJED2) FPOS(86,3.2) FLEN( 6)                                    GROUPS(FAK)
*
*
    TYPE(TEXT) CAPTION(% danì)       CPOS( 3,4.3) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(rv_dph)       CPOS(13,4.3) CLEN( 6)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(CENA)         CPOS(22,4.3) CLEN( 5)                                         GROUPS(FAK) FONT(5) 
    TYPE(TEXT) CAPTION(záklaní)      CPOS(33,4.2) CLEN( 6)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(sleva)        CPOS(50,4.2) CLEN( 5)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(% slevy)      CPOS(65,4.2) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(se slevou)    CPOS(81,4.2) CLEN( 8)                                         GROUPS(FAK) 
    TYPE(TEXT) CAPTION(celkem)       CPOS(97,4.2) CLEN( 6)                                         GROUPS(FAK)
  
    TYPE(Text) CAPTION(za MJ   )     CPOS(22,5.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)   
    TYPE(Text) CAPTION(za POL  )     CPOS(22,6.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)

    TYPE(TEXT) NAME(FAKPRIIT->ncenzakcel) CPOS(29,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKPRIIT->nsazdan)    CPOS(77,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKPRIIT->ncenzakced) CPOS(93,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)

    TYPE(STATIC) STYPE(12) FPOS( 1,4.8) SIZE(107, 3) CTYPE(2)                                      GROUPS(FAK)
* 1
      TYPE(Get)   NAME(FAKPRIIT->NPROCDPH)      FPOS( 1,0.5) FLEN( 7)                             GROUPS(FAK) PP(2)
      TYPE(Get)   NAME(FAKPRIIT->NRADVYKDPH)    FPOS(12,0.5) FLEN( 6)                             GROUPS(FAK) PUSH(fin_vykdph_rv_sel) 
      TYPE(COMBOBOX) NAME(FAKPRIIT->NKODPLNENI) FPOS( 1,1.6) FLEN(18) REF(NKODPLNENI)             GROUPS(FAK)

      TYPE(Get)   NAME(FAKPRIIT->NCEJPRZBZ)  FPOS(28,0.5) FLEN(13)   PP(2)                        GROUPS(FAK) PUSH(FIN_CMDPH)
      TYPE(Get)   NAME(FAKPRIIT->NHODNSLEV)  FPOS(44,0.5) FLEN(13)                                GROUPS(FAK) 
      TYPE(Get)   NAME(FAKPRIIT->NPROCSLEV)  FPOS(60,0.5) FLEN(13)                                GROUPS(FAK)
      TYPE(Text)  NAME(FAKPRIIT->ncejprkbz)  CPOS(76,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
      TYPE(Text)  NAME(FAKPRIIT->ncejprkdz)  CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
* 2
      TYPE(Text)  NAME(FAKPRIIT->ncecprzbz)  CPOS(28,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKPRIIT->ncelkslev)  CPOS(44,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) 
      TYPE(Text)  NAME(FAKPRIIT->ncecprkbz)  CPOS(76,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKPRIIT->ncecprkdz)  CPOS(92,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
    TYPE(End)

    TYPE(Get) NAME(FAKPRIIT->CDOPLNTXT) FPOS( 1, 8.25) FLEN(69)    PP(2)
    TYPE(Get) NAME(FAKPRIIT->CUCET)     FPOS(98,8.25) FLEN( 9)    FCAPTION(Úèet tržeb)   CPOS(88,8.25) CLEN(10)

* ns
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL1) FPOS(  3,10.15) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,9.2) CLEN( 9) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL2) FPOS( 21,10.15) FLEN(10) FCAPTION(Výrobek)      CPOS(21,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL3) FPOS( 39,10.15) FLEN(10) FCAPTION(Zakázka)      CPOS(39,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL4) FPOS( 57,10.15) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,9.2) CLEN( 7) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL5) FPOS( 75,10.15) FLEN(10) FCAPTION(Stroj)        CPOS(75,9.2) CLEN( 4) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIIT->cNAZPOL6) FPOS( 93,10.15) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,9.2) CLEN( 8) GROUPS(FAK,SETFONT,7.Arial CE)

    TYPE(STATIC) FPOS(0.4,9.6) SIZE(108.6,.2) STYPE(12) CTYPE(2)
    TYPE(End)

* memoEdit
    TYPE(PushButton) POS(105.5,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakpriit->mpozzbo,0)
**  
  TYPE(END)
TYPE(End)

