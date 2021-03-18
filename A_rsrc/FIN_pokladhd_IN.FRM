TYPE(drgForm) DTYPE(10) TITLE(Pokladní doklad ...) SIZE(100,24) FILE(POKLADHDw) ;
                                                                GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar) ;
                                                                POST(postValidate)   

* TYPE(Action) CAPTION(~Likvidace)      EVENT(fin_likvidace_in)    TIPTEXT(Likvidace pokladního dokladu)

TYPE(Action) CAPTION(      ~Likvidace) EVENT(set_likvidace_in)    TIPTEXT(Uloží doklad a nabídne likvidaci pokladního dokladu) ICON1(101) ATYPE(3)
TYPE(Action) CAPTION(~Výkaz DPH)       EVENT(fin_vykdph_in)       TIPTEXT(Øádky výkazu DPH)
TYPE(Action) CAPTION(Ú~hrady faktur)   EVENT(FIN_banvyphd_in_pok) TIPTEXT(Úhrady faktur)


  TYPE(Static) STYPE(13) SIZE(98,15.5) FPOS(1,0.3) RESIZE(y)
    TYPE(GET)      NAME(DPORIZDOK)      FPOS( 9,0.5) FLEN(11) FCAPTION(Datum)  CPOS( 2,0.5) PP(2) PUSH(CLICKDATE)
    TYPE(COMBOBOX) NAME(COBDOBI)        FPOS(29, .5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(22,0.5) PP(2)
    TYPE(COMBOBOX) NAME(COBDOBIDAN)     FPOS(49, .5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(40,0.5) PP(2)

    TYPE(STATIC) STYPE(9) FPOS(62.6,.5) SIZE(34,1.1) 
      TYPE(GET)  NAME(nPOKLADNA)      FPOS(0.3,0.01) FLEN( 7)   PUSH(FIN_POKLADMS_SEL) NOREVISION() 
      TYPE(TEXT) NAME(cNAZPOKLAD)     CPOS(8.4,0.01) PP(2) FONT(5) CTYPE(2)
    TYPE(End)    

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(96,12.6)

** POD VNITRO ÚÈET
      TYPE(STATIC) STYPE(9) FPOS(0,5.5) SIZE(48,.1) 
      TYPE(End)    

** POD TEXT DOKLADU
      TYPE(STATIC) STYPE(9) FPOS(0,7.3) SIZE(48,.1) 
      TYPE(End)    

** POD ÚHRADY FAKTUR
      TYPE(STATIC) STYPE(9) FPOS(0,10.9) SIZE(96,.05)
      TYPE(End)

      TYPE(ComboBox) NAME(POKLADHDw->CTYPPOHYBU) FPOS(15,1) FLEN(31) ;
                                                 FCAPTION(Typ dokladu  ____) CPOS( 1,1) CLEN(14) ;
                                                 VALUES(a,a,a) ITEMSELECTED(comboItemSelected) NOREVISION()
** PRO NCISOSOBY
      TYPE(STATIC) STYPE(9) FPOS(48,.92) SIZE(47,1.1) 
        TYPE(Get)  NAME(NCISOSOBY)   FPOS(.5,.01) FLEN(10) PUSH(FIN_pokladhd_osb_sel) NOREVISION()
        TYPE(Text) NAME(CJMENOPRIJ)  CPOS(12,.01) CLEN(28) FONT(5) CTYPE(2)
      TYPE(END)

      TYPE(TEXT) CAPTION(Doklad/Daò_dokl _)        CPOS( 1  ,2) CLEN(14) PP(2)
      TYPE(GET)  NAME(ndoklad)                     FPOS(15  ,2) FLEN(10) PP(2) NOREVISION()
      TYPE(GET)  NAME(cdanDoklad)                  FPOS(26.5,2) FLEN(19) PP(2)      

*      TYPE(GET)  NAME(NDOKLAD)    FPOS(15,2) FLEN(10) FCAPTION(Èíslo dokladu ____) CPOS( 1,2) PP(2) CLEN(14) NOREVISION()
      TYPE(GET)  NAME(CUCET_UCT)  FPOS(15,3) FLEN(10) FCAPTION(SuAu_Ø ________)    CPOS( 1,3) PP(2) CLEN(14)
      TYPE(TEXT) NAME(C_UCTOSN->CNAZ_UCT) CPOS(27,3) CLEN(19)

      TYPE(GET)  NAME(CVNBAN_UCT) FPOS(15,4) FLEN(30) FCAPTION(Vnitro úèet ______) CPOS( 1,4) CLEN(14)         
      TYPE(GET)  NAME(CTEXTDOK)   FPOS( 1,6) FLEN(44)

     TYPE(STATIC) STYPE(2) FPOS(48,2) SIZE(47.3,8) 
      TYPE(GET)  NAME(NCISFIRMY)           FPOS(10,1) FLEN( 8) FCAPTION(Firma ...  )       CPOS(1,1)             PP(2) PUSH(fin_firmy_sel)
      TYPE(GET)  NAME(NICO)                FPOS(10,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )    CPOS(1,2)  CLEN(10)  CTYPE(2) 
      TYPE(GET)  NAME(CDIC)                FPOS(22,2) FLEN(15)                                                       
      TYPE(GET)  NAME(CNAZEV)              FPOS(10,3) FLEN(27) FCAPTION(Název ...  )       CPOS(1,3)          
      TYPE(GET)  NAME(CNAZEV2)             FPOS(10,4) FLEN(27)                                                       
      TYPE(GET)  NAME(CULICE)              FPOS(10,5) FLEN(27) FCAPTION(Ulice ...  )       CPOS(1,5)          
      TYPE(GET)  NAME(CPSC)                FPOS(10,6) FLEN( 8) FCAPTION(Místo ...  )       CPOS(1,6)          
      TYPE(GET)  NAME(CSIDLO)              FPOS(22,6) FLEN(22)                                                       
      TYPE(GET)  NAME(CZKRATSTAT)          FPOS(10,7) FLEN( 8) FCAPTION(Stát ...  )        CPOS(1,7)             PP(2)
      TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(22,7) CLEN(23) BGND(13)
     TYPE(End)

      TYPE(Text) CAPTION(Celkem z dokladu ____) CPOS( 1, 7.7) CLEN(17)
      TYPE(Text) CAPTION(Úhrady faktur _______) CPOS( 1, 8.7) CLEN(17)
      TYPE(Text) CAPTION(Celkem  ____________)  CPOS( 1, 9.7) CLEN(17)

      TYPE(Text) NAME(M->zkratMenZ)               CPOS(34, 8.2) SIZE(10,2) CTYPE(3) 

*  TYPE(TEXT) NAME(NPARZAHFAK)                               CPOS(17,0.4) CLEN(14) BGND(13) PP(2) CTYPE(2)
*        TYPE(PUSHBUTTON)                                           POS(31,0.4) SIZE(2.9,1) CAPTION(...) EVENT(FIN_PARPRZAL)


* tuzemská
      TYPE(GET) NAME(NCENCEL_HD)  FPOS(18, 7.7) FLEN(13) GROUPS(1)   PUSH(FIN_banvyphd_in_pok)  
      TYPE(GET) NAME(NCENCEL_IT)  FPOS(18, 8.7) FLEN(13) GROUPS(1:0)
      TYPE(GET) NAME(NCENZAKCEL)  FPOS(18, 9.7) FLEN(13) GROUPS(1:0) 

* zahranièní
      TYPE(GET) NAME(NCENZAH_HD)  FPOS(18, 7.7) FLEN(13) GROUPS(2)   PUSH(FIN_banvyphd_in_pok)   
      TYPE(GET) NAME(NCENZAH_IT)  FPOS(18, 8.7) FLEN(13) GROUPS(2:0) 
      TYPE(GET) NAME(NCENZAHCEL)  FPOS(18, 9.7) FLEN(13) GROUPS(2:0) 

      TYPE(GET) NAME(CJMENOPOKL)  FPOS( 1,11.82) FLEN(40) FCAPTION(Pokladník)             CPOS( 1,10.9)
      TYPE(GET) NAME(CJMENOSCHV)  FPOS(49,11.82) FLEN(40) FCAPTION(Schválil)              CPOS(49,10.9)
    TYPE(End)
  TYPE(End)

* Tuzemská pokladna - 1
  TYPE(Static) STYPE(13) SIZE(98,6.3) FPOS(1,16.2) RESIZE(y) GROUPS(1)
    TYPE(GET)      NAME(DVYSTDOK) FPOS(15,.5) FLEN(13) FCAPTION(Datum uzp ) CPOS(1, .5) PUSH(CLICKDATE) GROUPS(1) NOREVISION()

    TYPE(TEXT)     CAPTION(Bez danì )      CPOS(1,2.5) PP(2) CLEN(10)       GROUPS(1)
    TYPE(GET)      NAME(NOSVODDAN)               FPOS(15,2.5) FLEN(13) CTYPE(2) PUSH(FIN_VYKDPH_IN) GROUPS(1)

    TYPE(TEXT)                                             CAPTION(Sazba danì )          CPOS(40,0.5)                   PP(2)
    TYPE(TEXT)                                             CAPTION(Základ danì)          CPOS(40,1.5)                   PP(2)
    TYPE(TEXT)                                             CAPTION(Odvod danì)           CPOS(40,2.5)                   PP(2)

    TYPE(ComboBox) NAME(nPROCDAN_3)  FPOS(55,0.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(63,0.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_3)  FPOS(52,1.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_3)   FPOS(52,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_1)  FPOS(70,0.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(78,0.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_1)  FPOS(67,1.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_1)   FPOS(67,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(ComboBox) NAME(nPROCDAN_2)  FPOS(85,0.5) FLEN(8)  VALUES(a,a,a) FCAPTION(%)     CPOS(93,0.5) CLEN(3)           PP(2) GROUPS(1)
    TYPE(GET)      NAME(NZAKLDAN_2)  FPOS(82,1.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_CMDPH)
    TYPE(GET)      NAME(NSAZDAN_2)   FPOS(82,2.5) FLEN(13)                                                                     GROUPS(1) PUSH(FIN_VYKDPH_IN)

    TYPE(TEXT)     NAME( M->lno_inDPH ) CPOS( 40, 4.3) SIZE(50,2) CTYPE(3)  GROUPS(1)

    TYPE(TEXT)     CAPTION(Rozdíl )              CPOS( 1,4.8) FONT(5)  GROUPS(1)       
    TYPE(TEXT)     NAME(M->rozdilDokl)           CPOS(15,4.8) CLEN(14) BGND(13) CTYPE(2) GROUPS(1)
  TYPE(End)


* Zahranièní pokladna - 2
  TYPE(Static) STYPE(13) SIZE(98,6.3) FPOS(1,16.2) RESIZE(y) GROUPS(2)
    TYPE(ComboBox) NAME(CZKRATMENZ) FPOS(50, .5) FLEN(29) FCAPTION(Zahranièní mìna  __________)     CPOS(27, .5)                GROUPS(2) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) CLEN(23) 

    TYPE(GET)      NAME(NKURZAHMEN) FPOS(50,2.5) FLEN(13) FCAPTION(Aktuální kurz/ pøepoèet  _____ ) CPOS(20,2.5) CTYPE(2) PP(2) GROUPS(2)
    TYPE(TEXT)     CAPTION(/) CPOS(65,2.5) CLEN(3)
    TYPE(GET)      NAME(NMNOZPREP)  FPOS(68,2.5) FLEN(10)                                                                       GROUPS(2)
    TYPE(GET)      NAME(NCENCEL_HD) FPOS(50,3.5) FLEN(13) FCAPTION(Celkem v základní mìnì  _____)   CPOS(20,3.5) CTYPE(2)       GROUPS(2)
  TYPE(End)

* info
  TYPE(Static) STYPE(8) SIZE(69,1.1) FPOS(30,22.7)
    TYPE(Text) NAME(M->nazTypPoh) CPOS( 1,.01) CLEN(30)
    TYPE(Text) NAME(M->celDoklad) CPOS(30,.01) CLEN(13)

    TYPE(Text) CAPTION('stav pokladny')  CPOS(44,.01) CLEN(15)
    TYPE(Text) NAME(M->aktStav)          CPOS(54,.01) CLEN(13) CTYPE(2)
*-    TYPE(Text) NAME(pokladhdw->npocstav) CPOS(0,0)    CLEN( 0)
*-    TYPE(Text) NAME(pokladhdw->npocstav) CPOS(54,.01) CLEN(13) CTYPE(2)
  TYPE(End)




