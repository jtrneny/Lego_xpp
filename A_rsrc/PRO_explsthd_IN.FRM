TYPE(drgForm) DTYPE(10) TITLE(Exepedièní list  ...) SIZE(110,27) ;
                                                    FILE(EXPLSTHDw) POST(postValidate)


* TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené) 
  TYPE(ComboBox) NAME(EXPLSTHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()


TYPE(Static) FPOS(1,1.2) SIZE(108,1.5) RESIZE(y) CTYPE(3) 
  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .6)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .6) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .6) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .6) CLEN(15) BGND(13)

  TYPE(STATIC) FPOS(55,0) SIZE(53,1.5) RESIZE(yy)
    TYPE(GET) NAME(EXPLSTHDw->NDOKLAD)    FPOS(24,.6) FLEN(10) FCAPTION(2. Expedièní list èíslo)  CPOS(1,0.5)  PP(2) FONT(5) CLEN(18) NOREVISION()
  TYPE(End)
TYPE(END)

TYPE(STATIC) FPOS(1,3.3) SIZE(108,3.3) GROUPS(HEAD)
  TYPE(TEXT) CAPTION(Dodavatel)      CPOS( 1, -.1) 
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,  .5) CLEN(31) BGND(13)
  TYPE(TEXT) NAME(M->system_culice)  CPOS(15, 1.5) CLEN(31) BGND(13)
  TYPE(TEXT) NAME(M->system_cpsc)    CPOS(15, 2.5) CLEN( 8) BGND(13)
  TYPE(TEXT) NAME(M->system_csidlo)  CPOS(25, 2.5) CLEN(21) BGND(13)
TYPE(END)



* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,7.5) SIZE(109.9,19) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) EXT() PRE(tabSelect) 
  TYPE(TEXT) CAPTION(3. Dopravu zabezpeèí :) CPOS(1,2.5) FONT(5)
*-*  TYPE(TEXT) CAPTION(6. Zpùsob dopravy   :) CPOS(1,7  ) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.5) SIZE(108.6,16.8  ) STYPE(9) RESIZE(yy)

* OKRASA PRO RADOST
    TYPE(STATIC) FPOS(.2,-.25) SIZE(108.3,1.3) STYPE(2) RESIZE(yy)
      TYPE(TEXT) CAPTION(EXPEDIÈNÍ LIST OBCHODNÍHO PØÍPADU) CPOS(1,.42) CTYPE(1) FONT(7) CLEN(100) 
    TYPE(END)

* POD SPZ NÁVÌSU
    TYPE(STATIC) FPOS(0.01,9) SIZE(108.3,.12) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(40,2.3) SIZE(.2,14.7) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD DATUM EXPEDICE
    TYPE(STATIC) FPOS(0.01,13.8) SIZE(108.8,.15) STYPE(9)  RESIZE(yx)
    TYPE(End)

   TYPE(Static)  FPOS(40,1.7) SIZE(68.5,6.9) CAPTION(Dopravce) 
     TYPE(Get)  NAME(EXPLSTHDw->NCISFIRDOP)         FPOS(12,1.5) FLEN(10) FCAPTION(Dopravce )          CPOS( 1,1.5) CLEN(11) PUSH(fir_firmy_sel)
     TYPE(Get)  NAME(EXPLSTHDw->NICODOP)            FPOS(28,1.5) FLEN(11) FCAPTION(Ièo)                CPOS(24,1.5) CLEN( 4)
     TYPE(Get)  NAME(EXPLSTHDw->CDICDOP)            FPOS(45,1.5) FLEN(15) FCAPTION(Diè)                CPOS(41,1.5)  
     TYPE(Get)  NAME(EXPLSTHDw->CNAZEVDOP)          FPOS(12,2.5) FLEN(27) FCAPTION(Název)              CPOS( 3,2.5)  
     TYPE(Get)  NAME(EXPLSTHDw->CNAZEVDOP2)         FPOS(12,3.5) FLEN(27)                                                
     TYPE(Get)  NAME(EXPLSTHDw->CULICEDOP)          FPOS(12,4.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,4.5)  
     TYPE(Get)  NAME(EXPLSTHDw->CPSCDOP)            FPOS(12,5.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,5.5)  PP(2)
     TYPE(Get)  NAME(EXPLSTHDw->CSIDLODOP)          FPOS(24,5.5) FLEN(27)                                                
*
**    TYPE(Get)  NAME(EXPLSTHDw->CZKRATSTAT)        FPOS(12,6.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,6.5)  PP(2)
**    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(24,5.5) CLEN(28) BGND(13)    
   TYPE(End)


   TYPE(GET)  NAME(EXPLSTHDw->CJMENORID)         FPOS(11, 3.5) FLEN(25) FCAPTION(øidiè)       CPOS( 1,3.5) PUSH(osb_osoby_sel)
   TYPE(GET)  NAME(EXPLSTHDw->CCISLOOP)          FPOS(11, 4.5) FLEN(15) FCAPTION(èíslo_op)    CPOS( 1,4.5) CLEN( 7)
   TYPE(GET)  NAME(EXPLSTHDw->CSPZ)              FPOS(11, 5.8) FLEN(15) FCAPTION(spz_vozidla) CPOS( 1,5.8) CLEN( 9)
   TYPE(GET)  NAME(EXPLSTHDw->VLEKSPZ)           FPOS(11, 6.8) FLEN(15) FCAPTION(spz_návìsu)  CPOS( 1,6.8) CLEN(10)   

*-*    TYPE(Get) NAME(EXPLSTHDw->CZKRPRODEJ)        FPOS(16,10.5) FLEN(10) FCAPTION(Prodejce)              CPOS( 2,10.5)   PP(2)

    TYPE(Get) NAME(EXPLSTHDw->DVYSTFAK)          FPOS(70, 9.5) FLEN(11) FCAPTION(Datum vystavení)     CPOS(50, 9.5)  PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(EXPLSTHDw->DNAKLADKY)         FPOS(70,10.5) FLEN(11) FCAPTION(Datum nakládky)      CPOS(50,10.5)  PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(EXPLSTHDw->CCASNAKLAD)        FPOS(95,10.5) FLEN(11) FCAPTION(èas nakládky)        CPOS(84,10.5)  PP(2) PICTURE(@N 99:99:99)

    TYPE(Get) NAME(EXPLSTHDw->DVYKLADKY)         FPOS(70,12  ) FLEN(11) FCAPTION(Datum vykládky)      CPOS(50,12  )  PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(EXPLSTHDw->CCASVYKLAD)        FPOS(95,12  ) FLEN(11) FCAPTION(èas vykládky)        CPOS(84,12  )  PP(2) PICTURE(@N 99:99:99)

*-*    TYPE(Get) NAME(EXPLSTHDw->DEXPEDICE)         FPOS(70,11.5) FLEN(11) FCAPTION(Datum expedice)      CPOS(50,11.5)  PP(2) PUSH(CLICKDATE)

    TYPE(Get) NAME(EXPLSTHDw->CJMENOVYS)         FPOS(10,14.8) FLEN(25) FCAPTION(Vystavil)            CPOS( 2,14.8)  PP(2) PUSH(osb_osoby_sel)

*-*    TYPE(ComboBox) FPOS(70,14.3) FLEN(25) NAME(EXPLSTHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
*-*                                          FCAPTION(Zahranièní mìna) CPOS(50,14.3)
*-*    TYPE(Get) NAME(EXPLSTHDw->NKURZAHMEN)        FPOS(70,15.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,15.3)   PP(2)
*-*    TYPE(Get) NAME(EXPLSTHDw->NMNOZPREP)         FPOS(83,15.3) FLEN(11)                                                PP(2)

    TYPE(PushButton) POS(104.8,15.5) SIZE(3,1)  EVENT(rtfEdit) ICON1(459) ICON2(214) ATYPE(1) CAPTION(explstHDw->mpoznamka,1)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,3.6) SIZE(109.9,22.9) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) EXT() SUBTABS(A1,A2) PRE(tabSelect) 

* expedièní list
  TYPE(Text)  CAPTION(typPoložky)          CPOS( 0.8,0.01) CLEN( 9) CTYPE(1)
  TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS(14  ,0.01) CLEN(11) CTYPE(1)                          
    TYPE(Text)  CAPTION([)                 CPOS(10.8,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(EXPLSTITw->ccissklad) CPOS(12  ,0.80) CLEN(15) CTYPE(1)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(26  ,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(èísloDodListu)       CPOS(31  ,0.01) CLEN(10) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloObjednávky)     CPOS(46  ,0.01) CLEN(13) CTYPE(2)                         GROUPS(FAK)
  TYPE(Text)  CAPTION(èísloVýrZakázky)     CPOS(64  ,0.01) CLEN(12) CTYPE(1)                         GROUPS(FAK)
    TYPE(Text)  CAPTION([)                 CPOS(62  ,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(EXPLSTITw->cskp)      CPOS(63  ,0.80) CLEN(15) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(77  ,0.80) CLEN( 2) CTYPE(2)                         GROUPS(FAK,SETFONT,7.Arial CE) 

  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,20.7) CTYPE(3) PP(2) 
    TYPE(DBrowse) FPOS(.5,13.4) SIZE(108,6.9) FILE(EXPLSTITw)                   ;
                                              FIELDS(M->cenPol::2.6::2       , ;
                                                     nintcount:polDokl       , ;
                                                     ccisZakaz:položka       , ;
                                                     cnazzbo:název položky:47, ;
                                                     nfaktmnoz:expMnož       , ;
                                                     czkratjedn:mj             ) ;     
                                              CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)

* expedièní list
  TYPE(CHECKBOX) NAME(M->typPOL)         FPOS( 1,1.1) FLEN(10) VALUES(T:dodávka,F:odbìr)

  TYPE(Get) NAME(EXPLSTITw->CSKLPOL)     FPOS(11,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
    TYPE(Text)  NAME(M->cenzboz_kDis)    CPOS(12,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

  TYPE(Get) NAME(EXPLSTITw->NCISLODL)    FPOS(28,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
    TYPE(Text)  NAME(M->dodlstit_kDis)   CPOS(28,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 

  TYPE(Get) NAME(EXPLSTITw->CCISLOBINT)  FPOS(45,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
    TYPE(Text)  NAME(M->objitem_kDis)    CPOS(46,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)

  TYPE(Get) NAME(EXPLSTITw->CCISZAKAZI)  FPOS(62,1.2) FLEN(15) PP(2) PUSH(fakturovat_z_sel)       GROUPS(FAK)
    TYPE(Text)  NAME(M->vyrzak_kDis)     CPOS(63,2.2) CLEN(13) CTYPE(1)                           GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED) 
  
  TYPE(STATIC) FPOS(.2,3.4) SIZE(108.6,.2) STYPE(12) CTYPE(2)
  TYPE(END)

  TYPE(Get) NAME(EXPLSTITw->CNAZZBO)     FPOS( 1,4.0) FLEN(42) PP(2)                             
  TYPE(Get) NAME(EXPLSTITw->NFAKTMNOZ)   FPOS(18,5.1) FLEN(15) PP(2) FCAPTION(Množství ___________) CPOS(1,5.1) CLEN(17)      
  TYPE(GET) NAME(EXPLSTITw->CZKRATJEDN)  FPOS(35,5.1) FLEN( 8) PP(2)
  TYPE(ComboBox) NAME(EXPLSTITw->NTYPPRILOH) FPOS(18,6.1) FLEN(26)   ;
                 VALUES(0:bez pøíloh,1:vlastní dodací list,2:cizí dodací list) FCAPTION(Typ pøíloh __________) CPOS(1,6.1) CLEN(17)       


  TYPE(STATIC) FPOS( 1, 9) SIZE(30,2.2) CTYPE(3) CAPTION( Datum a èas vykládky zboží ...)
    TYPE(Get) NAME(EXPLSTITw->DVYKLADKY)         FPOS(  2, 1 ) FLEN(11)                         PP(2) PUSH(CLICKDATE)
    TYPE(Get) NAME(EXPLSTITw->CCASVYKLAD)        FPOS( 18, 1 ) FLEN( 9) FCAPTION(v) CPOS(15,1)  PP(2) PICTURE(@N 99:99:99) 
  TYPE(END)  


    TYPE(TabPage) SIZE(58,8) FPOS(50.3,4) CAPTION(Odbìratel)   OFFSET( 0,80) PRE(tabSelect) SUB(A1) TABHEIGHT(.8)
      TYPE(Get)  NAME(EXPLSTITw->NCISFIRMY)         FPOS(12, .5) FLEN(10) FCAPTION(Odbìratel )         CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fir_firmy_sel)
      TYPE(Get)  NAME(EXPLSTITw->NICO)              FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
      TYPE(Get)  NAME(EXPLSTITw->CDIC)              FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
      TYPE(Get)  NAME(EXPLSTITw->CNAZEV)            FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
      TYPE(Get)  NAME(EXPLSTITw->CNAZEV2)           FPOS(12,2.5) FLEN(27)                                                
      TYPE(Get)  NAME(EXPLSTITw->CULICE)            FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
      TYPE(Get)  NAME(EXPLSTITw->CPSC)              FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
      TYPE(Get)  NAME(EXPLSTITw->CSIDLO)            FPOS(24,4.5) FLEN(27)                                                
      TYPE(Get)  NAME(EXPLSTITw->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2)
      TYPE(TEXT) NAME(c_staty->cnazevstat)          CPOS(24,5.5) CLEN(28) BGND(13)       
    TYPE(End)

    TYPE(TabPage) SIZE(58,8) FPOS(50.3,4) CAPTION(Místo dodání)  OFFSET(20,60) PRE(tabSelect) SUB(A2) TABHEIGHT(.8)
      TYPE(Get)  NAME(EXPLSTITw->NCISFIRDOA)         FPOS(12, .5) FLEN(10) FCAPTION(Místo dodání)       CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fir_firmy_sel)
      TYPE(Get)  NAME(EXPLSTITw->NICODOA)            FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
      TYPE(Get)  NAME(EXPLSTITw->CDICDOA)            FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
      TYPE(Get)  NAME(EXPLSTITw->CNAZEVDOA)          FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
      TYPE(Get)  NAME(EXPLSTITw->CNAZEVDOA2)         FPOS(12,2.5) FLEN(27)                                                
      TYPE(Get)  NAME(EXPLSTITw->CULICEDOA)          FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
      TYPE(Get)  NAME(EXPLSTITw->CPSCDOA)            FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
      TYPE(Get)  NAME(EXPLSTITw->CSIDLODOA)          FPOS(24,4.5) FLEN(27)                                                
**    TYPE(Get)  NAME(EXPLSTITw->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2)
**    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(24,5.5) CLEN(28) BGND(13)    
    TYPE(End)

    TYPE(Get) NAME(EXPLSTITw->CDOPLNTXT) FPOS( 1,12.25) FLEN(102) PP(2)
    TYPE(PushButton) POS(104.8,12.25) SIZE(3,1)  EVENT(rtfEdit) ICON1(459) ICON2(214) ATYPE(1) CAPTION(explstitw->mpoznamka,0)
  TYPE(End)
TYPE(End)

* info
TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2)
* 1 a 6
*  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8) FONT(5)                          GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
*  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5) FONT(5)                          GROUPS(16)
*  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)           GROUPS(16)
*  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8) FONT(5)                          GROUPS(16) 
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)  GROUPS(16)
* 2 a 5
  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8) FONT(5)                  GROUPS(25)
  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(25)
* 3 a 4
*  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAHCEL) CPOS(13, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Kurz )              CPOS(26, 0.01) CLEN( 5) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nKURZAHMEN) CPOS(31, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
*  TYPE(Text) CAPTION(Celkem v )          CPOS(44, 0.01) CLEN( 9) FONT(5)                  GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) BGND(1) PP(3) CTYPE(1) GROUPS(34)
*  TYPE(Text) NAME(EXPLSTHDw->nCENZAKCEL) CPOS(60, 0.01) CLEN(13) BGND(1) PP(3) CTYPE(1)   GROUPS(34)
TYPE(END)


* neviditelné pomocné položky
TYPE(TEXT) NAME(explstitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(explstitw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(explstitw->ncountDL)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(explstitw->ncislPolob) FPOS(0,0) CLEN(0)

TYPE(TEXT) NAME(explstitw->mpoznamka)  FPOS(0,0) CLEN(0)


