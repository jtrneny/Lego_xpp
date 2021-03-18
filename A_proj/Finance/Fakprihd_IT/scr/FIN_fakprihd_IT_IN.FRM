TYPE(drgForm) DTYPE(10) TITLE(Faktura pøijatá) SIZE(110,27) FILE(FAKPRIHDW)   ;
                                                            POST(postValidate);
                                                            CBSAVE(onSave)    ;
                                                            GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)


  TYPE(Action) CAPTION(~Likvidace)      EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Výkaz DPH)      EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
  TYPE(Action) CAPTION(~Párování záloh) EVENT(FIN_PARPRZAL)     TIPTEXT(Párování zálohových faktur)


*  TYPE(Static) STYPE(12) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y) CTYPE(2)

  TYPE(Static) STYPE(14) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y)
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
         TYPE(TEXT) NAME(hd_ucet->CNAZ_UCT) CPOS(23,6) CLEN(25) BGND(13)
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
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(56,3.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(78,3.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(52,4.5)                   PP(2)
    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(66,4.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(74,4.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(78,4.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(TEXT)                                             CAPTION( daò ... )            CPOS(56,5.5)                   PP(2)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(78,5.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)
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

  TYPE(Text)  CAPTION(typPoložky)          CPOS(1,0.01) CLEN(11) CTYPE(1)                         GROUPS(FAK) 

  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,18.7) CTYPE(3) PP(2) 

    TYPE(DBrowse) FPOS(0,11.4) SIZE(107,7.2) FILE(FAKPRIITw)                       ;
                                              FIELDS(M->cenPol:c:2.6::2          , ;
                                                     nintcount:polDokl           , ;
                                                     csklpol:sklPoložka          , ;
                                                     cnazzbo:název zboží:28      , ;
                                                     nfaktmnoz:faktMnož          , ;
                                                     czkratjedn:mj               , ;     
                                                     M->cena_za_mj:cena/mj:10    , ;
                                                     ncecprkdz:cenaCelkem        , ;
                                                     M->bc_osvOdDane:osvOdDanì:12, ;
                                                     M->bc_zaklDph_s:zaklDph_s:12, ;
                                                     M->bc_sazDph_s:sazDph_s:12  , ;
                                                     M->bc_zaklDph_z:zaklDph_z:12, ;
                                                     M->bc_sazDph_z:sazDph_z:12    ) ;
                                              CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(nn) GROUPS(FAK)

  TYPE(CHECKBOX) NAME(FAKPRIITw->lcelPol)  FPOS(2,1.1) FLEN(10) VALUES(T:celní,F:obecná) 

 
* bìžná položka dokladu
    TYPE(STATIC) FPOS(15,0) STYPE(11)  SIZE(92.5,2.7) CTYPE(3) PP(2) 
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 3  ,-0.2) CLEN(12) CTYPE(1) GROUPS(FAK,SETFONT,8.Cambria)  
        TYPE(Text)  CAPTION([)                 CPOS(.2  , 0.5) CLEN( 2) CTYPE(2) GROUPS(FAK,SETFONT,7.Arial CE) 
        TYPE(Text)  NAME(FAKPRIITw->ccissklad) CPOS( 2  , 0.5) CLEN(14) CTYPE(1) GROUPS(FAK,SETFONT,7.Arial CE) 
        TYPE(Text)  CAPTION(])                 CPOS(15.8, 0.5) CLEN( 2) CTYPE(2) GROUPS(FAK,SETFONT,7.Arial CE) 
      TYPE(Text)  CAPTION(èísloDodListu)       CPOS(19  ,-0.2) CLEN(12) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
      TYPE(Text)  CAPTION(èísloObjednávky)     CPOS(39  ,-0.2) CLEN(13) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
      TYPE(Text)  CAPTION(èísloZálFaktury)     CPOS(59  ,-0.2) CLEN(12) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 

      TYPE(Get) NAME(FAKPRIITw->CSKLPOL)    FPOS( 1, 1.5) FLEN(15) PP(2) PUSH(fakturovat_z_sel)   
      TYPE(Get) NAME(FAKPRIITw->NCISLODL)   FPOS(18, 1.5) FLEN(15) PP(2) PUSH(fakturovat_z_sel)   
      TYPE(Get) NAME(FAKPRIITw->CCISLOBINT) FPOS(35, 1.5) FLEN(20) PP(2) PUSH(fakturovat_z_sel)   
      TYPE(Get) NAME(FAKPRIITw->NCISZALFAK) FPOS(57, 1.5) FLEN(15) PP(2) PUSH(fakturovat_z_sel)   
    TYPE(END)

* celní položka dokladu
*    TYPE(STATIC) FPOS(15,0) STYPE(11)  SIZE(92.5,2.7) CTYPE(3) PP(2) 
*      TYPE(Text)  CAPTION(Základ Clo)          CPOS( 3,-0.2) CLEN(11) CTYPE(1) GROUPS(FAK,SETFONT,8.Cambria) 
*      TYPE(Text)  CAPTION(clo)                 CPOS(15,-0.2) CLEN(10) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
*      TYPE(Text)  CAPTION(Spd)                 CPOS(29,-0.2) CLEN(13) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
*      TYPE(Text)  CAPTION(dalšíNáklad)         CPOS(48,-0.2) CLEN(12) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
*      TYPE(Text)  CAPTION(dovPøirážka)         CPOS(64,-0.2) CLEN(12) CTYPE(2) GROUPS(FAK,SETFONT,8.Cambria) 
*
*      TYPE(GET) NAME(FAKPRIITw->NCELZAKL) FPOS( 1,1.2) FLEN(13) 
*      TYPE(GET) NAME(FAKPRIITw->NCELCLO)  FPOS(17,1.2) FLEN(13) 
*      TYPE(GET) NAME(FAKPRIITw->NCELSPD)  FPOS(33,1.2) FLEN(13) 
*      TYPE(GET) NAME(FAKPRIITw->NCELDAL)  FPOS(49,1.2) FLEN(13) 
*      TYPE(GET) NAME(FAKPRIITw->NCELDOVP) FPOS(65,1.2) FLEN(13) 
*    TYPE(END)

    TYPE(Get) NAME(FAKPRIITw->CNAZZBO)    FPOS( 1,3.2) FLEN(32)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIITw->NFAKTMNOZ)  FPOS(35,3.2) FLEN(15)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIITw->CZKRATJEDN) FPOS(52,3.2) FLEN( 6)  PP(2)                             GROUPS(FAK)
*   
    TYPE(GET) NAME(FAKPRIITw->NFAKTMNO2)  FPOS(69,3.2) FLEN(15)                                    GROUPS(FAK)
    TYPE(Get) NAME(FAKPRIITw->CZKRATJED2) FPOS(86,3.2) FLEN( 6)                                    GROUPS(FAK)
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

    TYPE(TEXT) NAME(FAKPRIITw->ncenzakcel) CPOS(28,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKPRIITw->nsazdan)    CPOS(76,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKPRIITw->ncenzakced) CPOS(92,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)

*    TYPE(STATIC) STYPE(12) FPOS( .3,4.8) SIZE(107,4) CTYPE(2)                                    GROUPS(FAK)
    TYPE(STATIC) STYPE(1) FPOS( .3,5.2) SIZE(107,4) CTYPE(2)        GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)
* 1
      TYPE(Get)   NAME(FAKPRIITw->NPROCDPH)      FPOS( 1,0.5) FLEN( 7)                             GROUPS(FAK) PP(2)
      TYPE(Get)   NAME(FAKPRIITw->NRADVYKDPH)    FPOS(12,0.5) FLEN( 6)                             GROUPS(FAK) PUSH(fin_vykdph_rv_sel) 
      TYPE(COMBOBOX) NAME(FAKPRIITw->NKODPLNENI) FPOS( 1,1.6) FLEN(18) REF(NKODPLNENI)             GROUPS(FAK)

      TYPE(Get)   NAME(FAKPRIITw->CUCETu_DPH)    FPOS( 1,2.6) FLEN( 9) 
      TYPE(Get)   NAME(FAKPRIITw->nKRACE_nar)    FPOS(11,2.6) FLEN(10)

      TYPE(Get)   NAME(FAKPRIITw->NCEJPRZBZ)  FPOS(28,0.5) FLEN(13)   PP(2)                        GROUPS(FAK) PUSH(FIN_CMDPH)
      TYPE(Get)   NAME(FAKPRIITw->NHODNSLEV)  FPOS(44,0.5) FLEN(13)                                GROUPS(FAK) 
      TYPE(Get)   NAME(FAKPRIITw->NPROCSLEV)  FPOS(60,0.5) FLEN(13)                                GROUPS(FAK)
      TYPE(Text)  NAME(FAKPRIITw->ncejprkbz)  CPOS(76,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
      TYPE(Text)  NAME(FAKPRIITw->ncejprkdz)  CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
* 2
      TYPE(Text)  NAME(FAKPRIITw->ncecprzbz)  CPOS(28,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKPRIITw->ncelkslev)  CPOS(44,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) 
      TYPE(Text)  NAME(FAKPRIITw->ncecprkbz)  CPOS(76,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKPRIITw->ncecprkdz)  CPOS(92,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)

      TYPE(TEXT) CAPTION(nákladovýÚèet) CPOS( 1,3.5) CLEN(10) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(End)

* nákladový úèer + ns
    TYPE(Get) NAME(FAKPRIITw->CUCET)    FPOS(  1,10.25) FLEN( 9) FCAPTION(nákladovýÚèet) CPOS( 1,9.2) CLEN(10) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL1) FPOS( 27,10.25) FLEN(10) FCAPTION(VýrStøedisko)  CPOS(27,9.2) CLEN( 9) GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL2) FPOS( 40,10.15) FLEN(10) FCAPTION(Výrobek)       CPOS(40,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL3) FPOS( 53,10.15) FLEN(10) FCAPTION(Zakázka)       CPOS(53,9.2) CLEN( 6) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL4) FPOS( 66,10.15) FLEN(10) FCAPTION(VýrMísto)      CPOS(66,9.2) CLEN( 7) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL5) FPOS( 79,10.15) FLEN(10) FCAPTION(Stroj)         CPOS(79,9.2) CLEN( 4) GROUPS(FAK,SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKPRIITw->cNAZPOL6) FPOS( 92,10.15) FLEN(10) FCAPTION(VýrOperace)    CPOS(92,9.2) CLEN( 8) GROUPS(FAK,SETFONT,7.Arial CE)

    TYPE(STATIC) FPOS(0.4,9.6) SIZE(108.6,.2) STYPE(8) CTYPE(2)
    TYPE(End)

    TYPE(STATIC) FPOS(0.4,4.8) SIZE(108.6,.2) STYPE(8) CTYPE(3)
    TYPE(End)

* memoEdit
    TYPE(PushButton) POS(104,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakpriITw->mpozzbo,0)
**  
  TYPE(END)
TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(fakpriitw->cfile_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nrecs_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nnapocet)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nvypsazdan)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->njeddan)     FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncountDL)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncislPolob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nisParZal)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nnullDph)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nCeJPrZDZ)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->ncenaSzbo)   FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakpriitw->nparZalFak)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakpriitw->nparZahFak)  FPOS(0,0) CLEN(0)
*
TYPE(MLE)  NAME(fakpriitw->mpozzbo)     FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(MLE)  NAME(fakpriitw->mapolSest)   FPOS(0,0) SIZE(0,0) READONLY(y)
*
TYPE(TEXT) NAME(fakpriitw->_nrecor)     FPOS(0,0) CLEN(0)



