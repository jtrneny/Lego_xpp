TYPE(drgForm) DTYPE(10) TITLE(Faktura vystavená ...) SIZE(110,27) ;
                                                     FILE(FAKVYSHDw) POST(postValidate)

*  TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené) 
  TYPE(Action) CAPTION(      ~Likvidace)      EVENT(set_likvidace_in)  TIPTEXT(Uloží doklad a nabídne likvidaci faktury vystavené) ICON1(101) ATYPE(3)
  TYPE(Action) CAPTION(~KontrPøepoèet)        EVENT(fin_KontrPrepocet) TIPTEXT(Kontrolní pøepoèet položek dokladu)
*

  TYPE(COMBOBOX) NAME(FAKVYSHDw->COBDOBI)     FPOS(16,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS( 2,0.2) PP(2) 
  TYPE(COMBOBOX) NAME(FAKVYSHDw->COBDOBIDAN)  FPOS(37,0.2) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(28,0.2) PP(2)
  TYPE(ComboBox) NAME(FAKVYSHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION() POST(fin_kurzit_get)


TYPE(Static) FPOS(1,1.4) SIZE(108,4.5) STYPE(9) RESIZE(y) CTYPE(2) NAME(mainFrame) 
  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .25)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .25) CLEN(12) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(28, .25) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(33, .25) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1,1.25) 
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.25) CLEN(33) BGND(13)

*  TYPE(TEXT) NAME(M->system_culice)  CPOS(15,2.3) CLEN(31) BGND(13)
*  TYPE(TEXT) NAME(M->system_cpsc)    CPOS(15,3.3) CLEN( 8) BGND(13)
*  TYPE(TEXT) NAME(M->system_csidlo)  CPOS(25,3.3) CLEN(21) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.3)                    FONT(6)   
  TYPE(TEXT) NAME(FAKVYSHDw->NICO)   CPOS(15,2.3)  CLEN(12) BGND(13) FONT(5) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(28,2.3)  CLEN( 5)          
  TYPE(TEXT) NAME(FAKVYSHDw->CDIC)   CPOS(33,2.3)  CLEN(15) BGND(13) FONT(5)
  TYPE(TEXT) NAME(FAKVYSHDw->CNAZEV) CPOS(15,3.3)  CLEN(33) BGND(13) FONT(5)


  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.2) RESIZE(yy) 
    TYPE(GET) NAME(FAKVYSHDw->NCISFAK)        FPOS(19, 0.5) FLEN(13) FCAPTION(2. Faktura èíslo)     CPOS(1,0.5)          PP(2) FONT(5) NOREVISION()
    TYPE(CHECKBOX) NAME(fakvyshdw->lno_indph) FPOS(36, 0.5) FLEN(16) VALUES(T:vstupuje do DPH,F:vstupuje do DPH) 

    TYPE(TEXT) CAPTION(Daò_dokl/Var_symbol ...) CPOS( 1, 1.5) CLEN(18) PP(2)
    TYPE(GET)  NAME(FAKVYSHDw->cdanDoklad)      FPOS(19, 1.5) FLEN(20) PP(2) 
    TYPE(GET)  NAME(FAKVYSHDw->CVARSYM)         FPOS(41, 1.5) FLEN(10)

    TYPE(GET) NAME(FAKVYSHDw->NKONSTSYMB) FPOS(19, 2.5) FLEN(10) FCAPTION(   Konstantní symbol) CPOS(1,2.5) CLEN(15) PP(2)
    TYPE(TEXT) NAME(C_KONSYM->CPOPISKS)   CPOS(31, 2.5) CLEN(21) BGND(13)

    TYPE(GET) NAME(FAKVYSHDw->CCISOBJ)    FPOS(19, 3.5) FLEN(32) FCAPTION(   Èíslo objednávky)  CPOS(1,3.5) CLEN(15)
  TYPE(END)
TYPE(End)

* 1- ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,6) SIZE(110,20.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT() SUBTABS(A1,A2)

******
*  TYPE(TEXT) CAPTION(Penìžní ústav)         CPOS( 4,0.1) CLEN(11)  
*  TYPE(TEXT) CAPTION(Èíslo úètu)            CPOS(42,0.1) CLEN(10)
  TYPE(TEXT) CAPTION(Vnitro úèet)           CPOS( 4,0.1) CLEN(11)

  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce :) CPOS(1,3  ) FONT(5)
  TYPE(TEXT) CAPTION(6. Zpùsob dopravy   :) CPOS(1,7  ) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.5) SIZE(108.8,18.8  ) STYPE(9) RESIZE(yy)

* POD PENÌŽNÍM ÚSTAVEM
    TYPE(STATIC) FPOS(0.01,2) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(END)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,6.01) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ POD STÁTEM
    TYPE(STATIC) FPOS(0.01,8.9) SIZE(40,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(40,2.01) SIZE(.2,16.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(0.01,13.8) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

******
*    TYPE(TEXT) NAME(c_bankuc->cbank_naz)          CPOS( 3.5, 0.6) CLEN(28) FONT(2)
*    TYPE(GET)  NAME(FAKVYSHDw->CBANK_UCT)         FPOS(42  , 0.6) FLEN(25)                                 PP(2)
*    TYPE(TEXT) CAPTION( v  )                      CPOS(69  , 0.6) CLEN( 2)
*    TYPE(TEXT) NAME(c_bankuc->czkratMeny)         CPOS(71  , 0.6) CLEN( 5) FONT(5)
    TYPE(GET)  NAME(FAKVYSHDw->CVNBAN_UCT)        FPOS(3.5  , 0.6) FLEN(25)                                 

* 2 - FAKTURAÈNÍ ADRESA
    TYPE(TabPage) SIZE(68.2,8.3) FPOS(40.3,0.7) CAPTION(FaktAdresa)   OFFSET( 0,80) PRE(tabSelect) SUB(A1) TABHEIGHT(.8)
      TYPE(Get)  NAME(FAKVYSHDw->NCISFIRMY)         FPOS(12, .5) FLEN(10) FCAPTION(Odbìratel )         CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fin_firmy_sel)
      TYPE(Get)  NAME(FAKVYSHDw->NICO)              FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
      TYPE(Get)  NAME(FAKVYSHDw->CDIC)              FPOS(47, .5) FLEN(10) FCAPTION(Diè)                CPOS(43, .5)  
      TYPE(Get)  NAME(FAKVYSHDw->CNAZEV)            FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
      TYPE(Get)  NAME(FAKVYSHDw->CNAZEV2)           FPOS(12,2.5) FLEN(27)                                                
      TYPE(Get)  NAME(FAKVYSHDw->CULICE)            FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
      TYPE(Get)  NAME(FAKVYSHDw->CPSC)              FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
      TYPE(Get)  NAME(FAKVYSHDw->CSIDLO)            FPOS(26,4.5) FLEN(27)                                                
      TYPE(Get)  NAME(FAKVYSHDw->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2) POST(fin_kurzit_get)
      TYPE(TEXT) NAME(c_staty->cnazevstat)          CPOS(26,5.5) CLEN(28) BGND(13)       
    TYPE(End)

* 3 - DODACÍ ADRESA
    TYPE(TabPage) SIZE(68.2,8.3) FPOS(40.3,0.7) CAPTION(DodAdresa)  OFFSET(20,60) PRE(tabSelect) SUB(A2) TABHEIGHT(.8)
      TYPE(Get)  NAME(FAKVYSHDw->NCISFIRDOA)         FPOS(12, .5) FLEN(10) FCAPTION(Místo dodání)       CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fin_firmy_sel)
*      TYPE(Get)  NAME(FAKVYSHDw->NICODOA)            FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
*      TYPE(Get)  NAME(FAKVYSHDw->CDICDOA)            FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
      TYPE(Get)  NAME(FAKVYSHDw->CNAZEVDOA)          FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
      TYPE(Get)  NAME(FAKVYSHDw->CNAZEVDOA2)         FPOS(12,2.5) FLEN(27)                                                
      TYPE(Get)  NAME(FAKVYSHDw->CULICEDOA)          FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
      TYPE(Get)  NAME(FAKVYSHDw->CPSCDOA)            FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
      TYPE(Get)  NAME(FAKVYSHDw->CSIDLODOA)          FPOS(24,4.5) FLEN(27)                                                
**    TYPE(Get)  NAME(FAKVYSHDw->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2)
**    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(24,5.5) CLEN(28) BGND(13)    
    TYPE(End)

    TYPE(Get)  NAME(FAKVYSHDw->CZKRTYPUHR)        FPOS(70, 9.5) FLEN(11) FCAPTION(Forma úhrady)         CPOS(50, 9.5)   PP(2) 
    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR)          CPOS(83, 9.5) CLEN(25) BGND(13)
    TYPE(Get)  NAME(FAKVYSHDw->DVYSTFAK)          FPOS(70,10.5) FLEN(11) FCAPTION(Datum vystavení)      CPOS(50,10.5)   PP(2) PUSH(CLICKDATE) 
    TYPE(Get)  NAME(FAKVYSHDw->DPOVINFAK)         FPOS(70,11.5) FLEN(11) FCAPTION(Datum uskuteènìní)    CPOS(50,11.5)   PP(2) PUSH(CLICKDATE) 
    TYPE(Get)  NAME(FAKVYSHDw->DSPLATFAK)         FPOS(70,12.5) FLEN(11) FCAPTION(Datum splatnosti)     CPOS(50,12.5)   PP(2) PUSH(CLICKDATE) 


**
    TYPE(GET)  NAME(FAKVYSHDw->CBANK_UCT)         FPOS( 70,14.3) FLEN(25)  FCAPTION(Uhradit na úèet) CLEN(12)  CPOS(50,14.3)    PP(2) POST(fin_kurzit_get)
    TYPE(TEXT) CAPTION( v  )                      CPOS( 98,14.3) CLEN( 2)
    TYPE(TEXT) NAME(c_bankuc->czkratMeny)         CPOS(101,14.3) CLEN( 5) FONT(5)
    TYPE(TEXT) NAME(c_bankuc->cbank_naz)          CPOS( 70,15.25) CLEN(28) GROUPS(SETFONT,7.Arial CE) 

    TYPE(ComboBox) FPOS(70,16.3) FLEN(26) NAME(FAKVYSHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(Mìna) CPOS(50,16.3) PP(2) POST(fin_kurzit_get)

    TYPE(Get)  NAME(FAKVYSHDw->NKURZAHMEN)        FPOS(70,17.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,17.3)   PP(2)
    TYPE(Get)  NAME(FAKVYSHDw->NMNOZPREP)         FPOS(83,17.3) FLEN(12)                                                PP(2)
    TYPE(GET)  NAME(FAKVYSHDw->CPRIJEMCE1)        FPOS( 2, 3.5) FLEN(25)
    TYPE(GET)  NAME(FAKVYSHDw->CPRIJEMCE2)        FPOS( 2, 4.5) FLEN(25)
    TYPE(Get)  NAME(FAKVYSHDw->CZKRZPUDOP)        FPOS( 2, 7.5) FLEN(25)

    TYPE(Get)  NAME(FAKVYSHDw->NPROCSLEV)         FPOS(16, 9.5) FLEN(10) FCAPTION(Sleva/Pøirážka)        CPOS( 2, 9.5)   
    TYPE(Get)  NAME(FAKVYSHDw->CZKRPRODEJ)        FPOS(16,10.5) FLEN(10) FCAPTION(Prodejce)              CPOS( 2,10.5)   
    TYPE(Get)  NAME(FAKVYSHDw->CUCET_UCT)         FPOS(16,12  ) FLEN(10) FCAPTION(Úèet odbìratele)       CPOS( 2,12  )  PP(2)

    TYPE(Get) NAME(FAKVYSHDw->CJMENOVYS)         FPOS(10,15.8) FLEN(25) FCAPTION(Vystavil)             CPOS( 2,15.8)   PP(2)
    TYPE(PushButton) POS(105.5,17.6) SIZE(3,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakvyshdw->mpopisfak,1)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* 4 - POLOŽKY
TYPE(TabPage) FPOS(0,6) SIZE(110,20.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()

* faktura
  TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 4,0.01) CLEN(11) CTYPE(1)                         GROUPS(FAK) 
    TYPE(Text)  CAPTION([)                 CPOS(.8,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(FAKVYSITw->ccissklad) CPOS( 2,0.80) CLEN(15) CTYPE(1)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(16,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloDodListu)       CPOS(21,0.01) CLEN(10) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloObjednávky)     CPOS(39,0.01) CLEN(13) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloVýrZakázky)     CPOS(68,0.01) CLEN(12) CTYPE(1)                         GROUPS(FAK)
    TYPE(Text)  CAPTION([)                 CPOS(62,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(FAKVYSITw->cskp)      CPOS(63,0.80) CLEN(15) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(82,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloZálFaktury)     CPOS(93,0.01) CLEN(12) CTYPE(2)                         GROUPS(FAK)

* penalizace
  TYPE(Text)  CAPTION(èísloFaktury)        CPOS( 4,0.01) CLEN(11) CTYPE(1)                         GROUPS(PEN) 


  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,18.7) CTYPE(3) PP(2) 

    TYPE(DBrowse) FPOS(.5,11.4) SIZE(108,6.9) FILE(FAKVYSITw)                      ;
                                              FIELDS(M->cenPol:c:2.6::2          , ;
                                                     M->isSest:s:2.6::2          , ; 
                                                     nintcount:polDokl           , ;
                                                     csklpol:sklPoložka          , ;
                                                     cnazzbo:název zboží:28      , ;
                                                     nfaktmnoz:faktMnož          , ;
                                                     M->k_disp_fak:k_dispozici:10, ;
                                                     czkratjedn:mj               , ;     
                                                     M->cena_za_mj:cena/mj:10    , ;
                                                     ncecprkdz:cenaCelkem          );
                                              CURSORMODE(3) PP(6) RESIZE(x) SCROLL(ny) POPUPMENU(nn) GROUPS(FAK)

    TYPE(DBrowse) FPOS(.5,11.4) SIZE(108,6.9) FILE(FAKVYSITw)                      ;
                                              FIELDS(nintcount:polDokl           , ;
                                                     ncisPenFak:èísloFaktury     , ;  
                                                     cdoplntxt:text položky:43.5 , ;
                                                     ncenJedZak:zaDenPøekr       , ;
                                                     nfaktmnoz:dnyPøekr          , ;
                                                     ncenZahCel:celkemPenále       );
                                              CURSORMODE(3) PP(6) RESIZE(x) SCROLL(ny) POPUPMENU(nn) GROUPS(PEN)


* faktura
    TYPE(Get) NAME(FAKVYSITw->CSKLPOL)    FPOS( 1,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
     TYPE(Text)  NAME(M->cenzboz_kDis)    CPOS( 2,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKVYSITw->NCISLODL)   FPOS(18,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
     TYPE(Text)  NAME(M->dodlstit_kDis)   CPOS(19,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKVYSITw->CCISLOBINT) FPOS(35,1.2) FLEN(20) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
     TYPE(Text)  NAME(M->objitem_kDis)    CPOS(36,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKVYSITw->CCISZAKAZI) FPOS(57,1.2) FLEN(33) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
     TYPE(Text)  NAME(M->vyrzak_kDis)     CPOS(53,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

    TYPE(Get) NAME(FAKVYSITw->NCISZALFAK) FPOS(92,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)

    TYPE(Get) NAME(FAKVYSITw->CNAZZBO)    FPOS( 1,3.2) FLEN(32)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKVYSITw->NFAKTMNOZ)  FPOS(35,3.2) FLEN(15)  PP(2)                             GROUPS(FAK)
    TYPE(Get) NAME(FAKVYSITw->CZKRATJEDN) FPOS(52,3.2) FLEN( 6)  PP(2)                             GROUPS(FAK)

    TYPE(Text) NAME(vykdph_iw->comboText) CPOS(85,3.2) CLEN( 0) BGND(13)                           GROUPS(FAK)
*   
    TYPE(GET) NAME(FAKVYSITw->NFAKTMNO2)  FPOS(69,3.2) FLEN(15)                                    GROUPS(FAK)
    TYPE(Get) NAME(FAKVYSITw->CZKRATJED2) FPOS(86,3.2) FLEN( 6)                                    GROUPS(FAK)
*
*
    TYPE(TEXT) CAPTION(% danì)       CPOS( 3,4.3) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(rv_dph)       CPOS(13,4.3) CLEN( 6)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(CENA)         CPOS(22,4.3) CLEN( 5)                                         GROUPS(FAK) FONT(5) 
    TYPE(TEXT) CAPTION(základní)     CPOS(33,4.2) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(sleva)        CPOS(50,4.2) CLEN( 5)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(% slevy)      CPOS(65,4.2) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(se slevou)    CPOS(81,4.2) CLEN( 8)                                         GROUPS(FAK) 
    TYPE(TEXT) CAPTION(celkem)       CPOS(97,4.2) CLEN( 6)                                         GROUPS(FAK)
  
    TYPE(Text) CAPTION(za MJ   )     CPOS(22,5.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)   
    TYPE(Text) CAPTION(za POL  )     CPOS(22,6.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)

    TYPE(TEXT) NAME(FAKVYSITw->ncenzakcel) CPOS(29,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKVYSITw->nsazdan)    CPOS(77,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKVYSITw->ncenzakced) CPOS(93,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)

    TYPE(STATIC) STYPE(12) FPOS( 1,4.8) SIZE(107, 3) CTYPE(2)                                      GROUPS(FAK)
* 1
      TYPE(Get)   NAME(FAKVYSITw->NPROCDPH)      FPOS( 1,0.5) FLEN( 7)                             GROUPS(FAK) PP(2)
      TYPE(Get)   NAME(FAKVYSITw->NRADVYKDPH)    FPOS(12,0.5) FLEN( 6)                             GROUPS(FAK) PUSH(fin_vykdph_rv_sel) 
      TYPE(COMBOBOX) NAME(FAKVYSITw->NKODPLNENI) FPOS( 1,1.6) FLEN(18) REF(NKODPLNENI)             GROUPS(FAK)

      TYPE(Get)   NAME(FAKVYSITw->NCEJPRZBZ)  FPOS(28,0.5) FLEN(13)   PP(2)                        GROUPS(FAK) PUSH(FIN_CMDPH)
      TYPE(Get)   NAME(FAKVYSITw->NHODNSLEV)  FPOS(44,0.5) FLEN(13)                                GROUPS(FAK) 
      TYPE(Get)   NAME(FAKVYSITw->NPROCSLEV)  FPOS(60,0.5) FLEN(13)                                GROUPS(FAK)
      TYPE(Text)  NAME(FAKVYSITw->ncejprkbz)  CPOS(76,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
      TYPE(Text)  NAME(FAKVYSITw->ncejprkdz)  CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
* 2
      TYPE(Text)  NAME(FAKVYSITw->ncecprzbz)  CPOS(28,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKVYSITw->ncelkslev)  CPOS(44,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) 
      TYPE(Text)  NAME(FAKVYSITw->ncecprkbz)  CPOS(76,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKVYSITw->ncecprkdz)  CPOS(92,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
    TYPE(End)

* penalizace
    TYPE(Get)  NAME(FAKVYSITw->NCISPENFAK) FPOS( 1, .5) FLEN(15) PP(2)    PUSH(fakturovat_z_sel)   GROUPS(PEN)
    TYPE(Text) CAPTION([)                  CPOS(21,0.3) CLEN( 2) CTYPE(2)                          GROUPS(PEN,SETFONT,8.Arial CE) 
    TYPE(Text) NAME(FAKVYSHDw->ncisfirmy)  CPOS(25,0.3) CLEN( 6) CTYPE(2)                          GROUPS(PEN,SETFONT,9.Arial CE) 
    TYPE(TEXT) NAME(FAKVYSHDw->Cnazev)     CPOS(32,0.3) CLEN(25) PP(2)                             GROUPS(PEN,SETFONT,9.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(58,0.3) CLEN( 2) CTYPE(2)                          GROUPS(PEN,SETFONT,8.Arial CE) 

    TYPE(Text)  CAPTION(celkemFakturováno)    CPOS(87,0.3) CLEN(15) CTYPE(1)                       GROUPS(PEN) 
    TYPE(TEXT)  NAME(FAKVYSITw->ncelpenfak)   CPOS(86,1.5) CLEN(16) BGND(13) PP(2) CTYPE(2)        GROUPS(PEN,SETFONT,9.Arial CE) 

    TYPE(Text) CAPTION(Datum uskuteènìní ZP ___) CPOS(  1,1.7) CLEN(20)                            GROUPS(PEN) 
    TYPE(Text) NAME(FAKVYSHDw->dpovinfak)        CPOS( 22,1.7) CLEN(13) BGND(13) PP(2) CTYPE(2)    GROUPS(PEN) NOREVISION()
    TYPE(Text) CAPTION(Datum splatnosti ____)    CPOS( 53,1.7) CLEN(18)                            GROUPS(PEN,SETFONT,8.Arial CE)
    TYPE(Text) NAME(FAKVYSITw->dsplatfak)        CPOS( 71,1.7) CLEN(13) BGND(13) PP(2) CTYPE(2)    GROUPS(PEN)

    TYPE(Text) CAPTION(Datum vystavení ________) CPOS(  1,2.7) CLEN(20)                            GROUPS(PEN)
    TYPE(Text) NAME(FAKVYSHDw->dvystfak)         CPOS( 22,2.7) CLEN(13) BGND(13) PP(2) CTYPE(2)    GROUPS(PEN)
    TYPE(Text) CAPTION(Datum úhrady ______)      CPOS( 53,2.7) CLEN(18)                            GROUPS(PEN)
    TYPE(Text) NAME(FAKVYSITw->dposuhrfak)       CPOS( 71,2.7) CLEN(13) BGND(13) PP(2) CTYPE(2)    GROUPS(PEN)
    TYPE(Text) NAME(FAKVYSITw->nuhrcelfaz)       CPOS( 86,2.7) CLEN(16) BGND(13) PP(2) CTYPE(2)    GROUPS(PEN)

    TYPE(TEXT) CAPTION(penalizace)        CPOS(27,4.2) CLEN( 9)                                    GROUPS(PEN)
    TYPE(TEXT) CAPTION(dny pøekroèení)    CPOS(42,4.2) CLEN(12)                                    GROUPS(PEN) 
    TYPE(TEXT) CAPTION(% penále)          CPOS(64,4.2) CLEN( 8)                                    GROUPS(PEN) 
    TYPE(TEXT) CAPTION(za den pøekroèení) CPOS(76,4.2) CLEN(14)                                    GROUPS(PEN)
    TYPE(TEXT) CAPTION(celkem)            CPOS(97,4.2) CLEN( 6)                                    GROUPS(PEN)

    TYPE(STATIC) STYPE(13) FPOS( 1,4.8) SIZE(107, 2) CTYPE(2)                                      GROUPS(PEN)
      TYPE(TEXT) CAPTION(návrh penále) CPOS( 1, .8)                                                GROUPS(PEN,SETFONT,9.Arial CE,GRA_CLR_RED) 
      TYPE(Get)  NAME(FAKVYSITw->ncenpencel) FPOS(20,0.7) FLEN(13)   PP(2)                         GROUPS(PEN) 
      TYPE(GET)  NAME(FAKVYSITw->nfaktmnoz)  FPOS(38,0.7) FLEN(13)   PP(2)                         GROUPS(PEN)
      TYPE(GET)  NAME(FAKVYSITw->npen_odb)   FPOS(56,0.7) FLEN(13)   PP(2)                         GROUPS(PEN)
      TYPE(Text) NAME(FAKVYSITw->ncejprkbz)  CPOS(74,0.5) CLEN(14)   BGND(13) CTYPE(2)             GROUPS(PEN) 
      TYPE(Text) NAME(FAKVYSITw->ncecprkbz)  CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)             GROUPS(PEN) PICTURE(@N 9999999999.99)
    TYPE(END) 

    TYPE(Text) NAME(FAKVYSITw->CNAZZBO)    FPOS(0,0) CLEN(0)                                       GROUPS(PEN)  
* penalizace


    TYPE(COMBOBOX) NAME(FAKVYSITw->CTYPPREDAN)  FPOS( 1,8.23) FLEN(24) REF(CTYPPREDAN)             
    TYPE(Get)      NAME(FAKVYSITw->NPROCDPHpp)  FPOS(27,8.25) FLEN( 7) PP(2)                       
    TYPE(Get)      NAME(FAKVYSITw->CDOPLNTXT)   FPOS(38,8.25) FLEN(69) PP(2)

* ns
    TYPE(Get) NAME(FAKVYSITw->CUCET   ) FPOS(  1,10.15) FLEN( 9) FCAPTION(ÚèetTržeb)    CPOS( 1,9.2) CLEN(10) GROUPS(SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL1) FPOS( 27,10.15) FLEN(10) FCAPTION(VýrStøedisko) CPOS(27,9.2) CLEN( 9) GROUPS(SETFONT,7.Arial CE) 
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL2) FPOS( 40,10.15) FLEN(10) FCAPTION(Výrobek)      CPOS(40,9.2) CLEN( 6) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL3) FPOS( 53,10.15) FLEN(10) FCAPTION(Zakázka)      CPOS(53,9.2) CLEN( 6) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL4) FPOS( 66,10.15) FLEN(10) FCAPTION(VýrMísto)     CPOS(66,9.2) CLEN( 7) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL5) FPOS( 79,10.15) FLEN(10) FCAPTION(Stroj)        CPOS(79,9.2) CLEN( 4) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(FAKVYSITw->cNAZPOL6) FPOS( 92,10.15) FLEN(10) FCAPTION(VýrOperace)   CPOS(92,9.2) CLEN( 8) GROUPS(SETFONT,7.Arial CE)

    TYPE(STATIC) FPOS(0.4,9.6) SIZE(108.6,.2) STYPE(12) CTYPE(2)
    TYPE(End)

* memoEdit
    TYPE(PushButton) POS(105.5,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakvysitw->mpozzbo,0)

  TYPE(End)
TYPE(End)

* info
*TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2)
* 1 a 6
*  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8)                                          GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
*  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5)                                          GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
*  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8)                                          GROUPS(16) 
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
* 2 a 5
*  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8)                                  GROUPS(25)
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   GROUPS(25)
* 3 a 4
*  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9)                                  GROUPS(34)
*  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) FONT(5) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) FONT(5)   BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5)                                  GROUPS(34)
*  TYPE(Text) NAME(FAKVYSHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9)                                  GROUPS(34)
*  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) FONT(5) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*TYPE(END)


TYPE(Static) FPOS(36,25.5) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(16)
* 1 a 6
  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8)                                          
  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           
  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5)                                          
  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           
  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8)                                          
  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  
  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  
TYPE(END)


TYPE(Static) FPOS(36,25.6) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(25)
* 2 a 5
  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8)                                  
  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   
TYPE(END)

TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(34)
* 3 a 4
  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9)                                  
  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 5) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(34,SETFONT,8.Arial,GRA_CLR_RED)
  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(13  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1) 
  TYPE(Text) CAPTION(Kurz )              CPOS(26  , 0.01) CLEN( 5)                                  
  TYPE(Text) NAME(M->KURZAHMEN)          CPOS(31  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(34,SETFONT,8.Arial,GRA_CLR_RED)  
  TYPE(Text) CAPTION(Celkem v )          CPOS(44  , 0.01) CLEN( 9)                                  
  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) FONT(5) BGND(1) PP(3) CTYPE(1) 
  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS(60  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   
TYPE(END)


* neviditelné pomocné položky
TYPE(TEXT) NAME(fakvysitw->cfile_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nrecs_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nnapocet)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nnapocetpp)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nvypsazdan)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->njeddan)     FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->ncountDL)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->ncislPolob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->ncisPOLzak)  FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakvysitw->nisParZal)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nnullDph)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nCeJPrZDZ)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->ncenaSzbo)   FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakvysitW->nzboziKat)   FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakvysitw->nparZalFak)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nparZahFak)  FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(fakvysitw->nIND_zaokr)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nhmotnostJ)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(fakvysitw->nobjemJ)     FPOS(0,0) CLEN(0)
*
TYPE(MLE)  NAME(fakvysitw->mpozzbo)     FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(MLE)  NAME(fakvysitw->mapolSest)   FPOS(0,0) SIZE(0,0) READONLY(y)
*
TYPE(TEXT) NAME(fakvysitw->_nrecor)     FPOS(0,0) CLEN(0)


