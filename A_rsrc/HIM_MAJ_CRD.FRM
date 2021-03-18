TYPE(drgForm) DTYPE(10) TITLE(Karta investièního majetku) SIZE(105,25) FILE(MAJw);
              GUILOOK(Action:n,IconBar:y:MyIconBar,Menu:n);
              POST( POSTVALIDATE) PRE( PREVALIDATE) CBSAVE(ONSAVE)

TYPE(Static) STYPE(13) SIZE(104, 4.2)  FPOS( 0.5, 0.1) RESIZE(yn) CTYPE(2)  GROUPS(HIM)
  TYPE(GET)  NAME(nTypMaj)             FPOS(  14, 0.5) FLEN( 9) FCAPTION(Typ majetku)     CPOS( 3,0.5) PP(2) NOREVISION() GROUPS(HIM)
  TYPE(TEXT) NAME(C_TypMAJ->cNazTypu)  CPOS(  24, 0.5) CLEN(22) BGND(13)                                                  GROUPS(HIM)
  TYPE(GET)  NAME(cTypPohybu)          FPOS(  14, 1.5) FLEN( 9) FCAPTION(Druh nabytí)     CPOS( 3,1.5) PP(2) NOREVISION() PICTURE(@N99999) GROUPS(HIM) PUSH(C_TypPoh_sel)
  TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh) CPOS(  24, 1.5) CLEN(22) BGND(13)                                                  GROUPS(HIM)
  TYPE(GET)  NAME(nInvCis)             FPOS(  49, 1.5) FLEN(10) FCAPTION(Inv. èíslo)      CPOS( 49,0.5) FONT(5) PP(2) NOREVISION() GROUPS(HIM)
  TYPE(GET)  NAME(cNazev)              FPOS(  61, 1.5) FLEN(40) FCAPTION(Název majetku)   CPOS( 61,0.5) FONT(5)                    GROUPS(HIM)

  TYPE(Static) STYPE(12) SIZE(102,1.1)  FPOS(1,2.9) RESIZE(yn) CTYPE(2) GROUPS(HIM)
    TYPE(GET)  NAME(dDatPor)  FPOS(25,0) FLEN( 12) FCAPTION(Datum poøízení majetku)  CPOS( 6,0) PP(2)               PUSH(CLICKDATE) GROUPS(HIM)
    TYPE(GET)  NAME(dDatZar)  FPOS(65,0) FLEN( 12) FCAPTION(datum a období zaøazení) CPOS(42,0)       NOREVISION()  PUSH(CLICKDATE) GROUPS(HIM)
    TYPE(TEXT) CAPTION(->)    CPOS(80,0) CLEN(  3) FONT(5)                                                                          GROUPS(HIM)
    TYPE(GET)  NAME(cObdZar)  FPOS(85,0) FLEN(  5) CTYPE(3) FONT(5) PICTURE(99/99)                                                  GROUPS(HIM)
   TYPE(END)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(104, 4.2)  FPOS( 0.5, 0.1) RESIZE(yn) CTYPE(2)  GROUPS(ZVI)
  TYPE(GET)  NAME(nZvirKat)            FPOS(  14, 0.5) FLEN( 9) FCAPTION(Kategorie)     CPOS( 3,0.5) PP(2) NOREVISION()  GROUPS(ZVI)
  TYPE(TEXT) NAME(KategZvi->cNazevKat) CPOS(  24, 0.5) CLEN(22) BGND(13)                                                 GROUPS(ZVI)
  TYPE(GET)  NAME(cTypPohybu)          FPOS(  14, 1.5) FLEN( 9) FCAPTION(Druh nabytí)     CPOS( 3,1.5) PP(2) NOREVISION() PICTURE(@N99999) GROUPS(ZVI) PUSH(C_TypPoh_sel)
  TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh) CPOS(  24, 1.5) CLEN(22) BGND(13)                                                  GROUPS(ZVI)
  TYPE(GET)  NAME(nInvCis)             FPOS(  49, 1.5) FLEN( 10) FCAPTION(Evid. èíslo)   CPOS( 49,0.5) FONT(5) PP(2) NOREVISION() GROUPS(ZVI)
  TYPE(GET)  NAME(cNazev)              FPOS(  61, 1.5) FLEN( 40) FCAPTION(Název zvíøete) CPOS( 61,0.5) FONT(5)                    GROUPS(ZVI)

  TYPE(Static) STYPE(12) SIZE(102,1)  FPOS(1,2.8) RESIZE(yn) CTYPE(2) GROUPS(ZVI)
    TYPE(GET)  NAME(dDatPor)  FPOS(25,0) FLEN( 12) FCAPTION(Datum poøízení majetku)  CPOS( 6,0) PP(2)              PUSH(CLICKDATE) GROUPS(ZVI)
    TYPE(GET)  NAME(dDatZar)  FPOS(65,0) FLEN( 12) FCAPTION(datum a období zaøazení) CPOS(42,0)       NOREVISION() PUSH(CLICKDATE) GROUPS(ZVI)
    TYPE(TEXT) CAPTION(->)    CPOS(80,0) CLEN(  3) FONT(5)                                                                         GROUPS(ZVI)
    TYPE(GET)  NAME(cObdZar)  FPOS(85,0) FLEN(  5) CTYPE(3) FONT(5) PICTURE(99/99)                                                 GROUPS(ZVI)
   TYPE(END)

TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,21.4) FPOS(0,4.4)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,86) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(104, 20.1) FPOS(0.5,0.1) RESIZE(yn)
      TYPE(COMBOBOX) NAME(lHmotnyIM)        FPOS(25, 0.5) FLEN( 18) FCAPTION( Druh majetku)          CPOS( 4, 0.5) VALUES(T:Hmotný majetek,F:Nehmotný majetek)
      TYPE(GET)      NAME(cKlicSkMis)       FPOS(25, 1.5) FLEN( 17) FCAPTION(Skupinové místo)        CPOS( 4, 1.5) GROUPS(HIM)
      TYPE(GET)      NAME(cKlicOdMis)       FPOS(25, 2.5) FLEN( 17) FCAPTION(Odpovìdnostní místo)    CPOS( 4, 2.5)
      TYPE(GET)      NAME(ctypCZcpa)        FPOS(25, 3.5) FLEN( 17) FCAPTION(Klíè cz-cpa)            CPOS( 4, 3.5)
      TYPE(GET)      NAME(nTrObor)          FPOS(25, 4.5) FLEN( 17) FCAPTION(Tøída - obor)           CPOS( 4, 4.5)
      TYPE(GET)      NAME(nDoklad)          FPOS(25, 5.5) FLEN( 17) FCAPTION( Èíslo dokladu)         CPOS( 4, 5.5)

      TYPE(TEXT) CAPTION(Úèetní)         CPOS( 76, 0.5) CLEN( 8) FONT(5)
      TYPE(TEXT) CAPTION(Daòová)         CPOS( 92, 0.5) CLEN( 8) FONT(5)
      TYPE(Static) STYPE(17) SIZE(48, 0.1) FPOS( 50, 1.1) RESIZE(yx)
        TYPE(TEXT) CAPTION(Poøizovací cena)      CPOS( 50, 1.5) CLEN(15)
        TYPE(TEXT) CAPTION(Hodnota dotace)       CPOS( 50, 2.5) CLEN(15)
        TYPE(TEXT) CAPTION(Vstupní cena)         CPOS( 50, 3.5) CLEN(15)
        TYPE(TEXT) CAPTION(Oprávka celkem)       CPOS( 50, 4.5) CLEN(15)
        TYPE(TEXT) CAPTION(Zùstatková cena)      CPOS( 50, 5.5) CLEN(15)

        TYPE(GET)  NAME( nCenaPorU)          FPOS( 66, 1.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nCenaPorD)          FPOS( 83, 1.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nDotaceUct)         FPOS( 66, 2.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nDotaceDan)         FPOS( 83, 2.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nCenaVstU)          FPOS( 66, 3.5) FLEN(15)
        TYPE(GET)  NAME( nCenaVstD)          FPOS( 83, 3.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nOprUct)            FPOS( 66, 4.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( nOprDan)            FPOS( 83, 4.5) FLEN(15) PICTURE( @N 999 999 999.99)
        TYPE(GET)  NAME( M->nZustCenaU)      FPOS( 66, 5.5) FLEN(15) PICTURE( @N 9 999 999 999.99)
        TYPE(GET)  NAME( M->nZustCenaD)      FPOS( 83, 5.5) FLEN(15) PICTURE( @N 9 999 999 999.99)

      TYPE(TEXT)   CAPTION(DAÒOVÝ odpis )   CPOS( 4, 7.2) CLEN(13) FONT(5)
      TYPE(Static) STYPE(7) SIZE(46, 0.1)  FPOS( 3, 7.8) RESIZE(yx)
      TYPE(END)
      TYPE(TEXT)   CAPTION(ÚÈETNÍ odpis )   CPOS(54, 7.2) CLEN(12) FONT(5)
      TYPE(Static) STYPE(7) SIZE(47, 0.1)  FPOS(53, 7.8) RESIZE(yx)
      TYPE(END)

* Daòový odpis
      TYPE(GET)      NAME(cOdpiSkD)          FPOS(22, 8.2) FLEN(10) FCAPTION( Daò.odpisová skupina)   CPOS( 4, 8.2)
      TYPE(TEXT)     NAME(M->cTextDobaD)     CPOS(34, 8.2) CLEN(11)
      TYPE(GET)      NAME(nRokyOdpiD)        FPOS(45, 8.2) FLEN( 2)
      TYPE(GET)      NAME(nMesOdpiD)         FPOS(45, 8.2) FLEN( 4)
      TYPE(COMBOBOX) NAME(nTypDOdpi)         FPOS(22, 9.2) FLEN(26) FCAPTION( Typ odpisu)             CPOS( 4, 9.2) REF(TYPDODPI)
      TYPE(COMBOBOX) NAME(nUplProc)          FPOS(22,10.2) FLEN( 8) FCAPTION( Zvýšení odpisu)         CPOS( 4,10.2) REF(UPLPROC)
      TYPE(TEXT)     CAPTION( %)             CPOS(30,10.2) CLEN( 3) FONT(5)
      TYPE(GET)      NAME(nUplHodn)          FPOS(33,10.2) FLEN(14)
      TYPE(TEXT)     CAPTION( Kè)            CPOS(48,10.2) CLEN( 3) FONT(5)
      TYPE(GET)      NAME(nProcDanOd)        FPOS(22,11.2) FLEN( 7) FCAPTION( Plánovaný roèní odpis)  CPOS( 4,11.2) 
      TYPE(TEXT)     CAPTION( %)             CPOS(30,11.2) CLEN( 3) FONT(5)

*      TYPE(GET)      NAME(nhodnDanOd)        FPOS(33,11.2) FLEN(14)
*      TYPE(TEXT)     CAPTION( Kè)            CPOS(48,11.2) CLEN( 3) FONT(5)

      TYPE(GET)      NAME(nDanOdpRok)        FPOS(33,11.2) FLEN(14)
      TYPE(TEXT)     CAPTION( Kè)            CPOS(48,11.2) CLEN( 3) FONT(5)
      TYPE(COMBOBOX) NAME(nZnAktD)           FPOS(22,13.5) FLEN(26) FCAPTION( Stav daò.aktivace)      CPOS( 4,13.5) PP(2) VALUES(a,a,a)
* Úèetní odpis
      TYPE(GET)      NAME(cOdpiSk)           FPOS(72, 8.2) FLEN(10) FCAPTION( Úè. odpisová skupina)   CPOS( 54, 8.2)
      TYPE(TEXT)     CAPTION(Roky odpisu)    CPOS(84, 8.2) CLEN(10)
      TYPE(GET)      NAME(nRokyOdpiU)        FPOS(94, 8.2) FLEN( 3)
      TYPE(COMBOBOX) NAME(nTypUOdpi)         FPOS(72, 9.2) FLEN(26) FCAPTION( Typ odpisu)             CPOS( 54, 9.2) REF(TYPUODPI)
      TYPE(COMBOBOX) NAME(nTypVypUO)         FPOS(72,10.2) FLEN(26) FCAPTION( Typ výpoètu odpisu)     CPOS( 54,10.2) REF(NTYPVYPUO)
      TYPE(GET)      NAME(nProcUctOd)        FPOS(72,11.2) FLEN( 7) FCAPTION( Plánovaný roèní odpis)  CPOS( 54,11.2)
      TYPE(TEXT)     CAPTION( %)             CPOS(80,11.2) CLEN( 3) FONT(5)
      TYPE(GET)      NAME(nUctOdpRok)        FPOS(84,11.2) FLEN(13)
      TYPE(TEXT)     CAPTION( Kè)            CPOS(98,11.2) CLEN( 3) FONT(5)
      TYPE(GET)      NAME(nUctOdpMes)        FPOS(84,12.2) FLEN(13) FCAPTION( Plánovaný mìsíèní odpis)CPOS( 54,12.2)
      TYPE(TEXT)     CAPTION( Kè)            CPOS(98,12.2) CLEN( 3) FONT(5)
      TYPE(COMBOBOX) NAME(nZnAkt)            FPOS(72,13.5) FLEN(26) FCAPTION( Stav úè.aktivace)       CPOS( 54,13.5) VALUES(a,a,a,a)

      TYPE(Static) STYPE(7) SIZE(98, 0.1)  FPOS( 3, 14.8) RESIZE(yx)
      TYPE(END)

      TYPE(GET)      NAME(nKusy)             FPOS(22, 15.2) FLEN( 11) FCAPTION( Množství     )  CPOS(  4, 15.2)
      TYPE(GET)      NAME(nCisFak)           FPOS(50, 15.2) FLEN( 15) FCAPTION( Èís. faktury )  CPOS( 39, 15.2)
      TYPE(GET)      NAME(cVarSym)           FPOS(82, 15.2) FLEN( 15) FCAPTION( Var. symbol  )  CPOS( 72, 15.2)

      TYPE(GET) NAME(cNazPol1)    FPOS(  4,17.8)  FLEN( 13) FCAPTION(Støedisko  ) CPOS(  4,16.8) CLEN(10) FONT(5)
      TYPE(GET) NAME(cNazPol2)    FPOS( 20,17.8)  FLEN( 13) FCAPTION(Výkon)       CPOS( 20,16.8) CLEN( 6) FONT(5)
      TYPE(GET) NAME(cNazPol3)    FPOS( 36,17.8)  FLEN( 13) FCAPTION(Zakázka)     CPOS( 36,16.8) CLEN( 8) FONT(5)
      TYPE(GET) NAME(cNazPol4)    FPOS( 52,17.8)  FLEN( 13) FCAPTION(VýrMísto)    CPOS( 52,16.8) CLEN( 9) FONT(5)
      TYPE(GET) NAME(cNazPol5)    FPOS( 68,17.8)  FLEN( 13) FCAPTION(Stroj)       CPOS( 68,16.8) CLEN( 6) FONT(5)
      TYPE(GET) NAME(cNazPol6)    FPOS( 84,17.8)  FLEN( 13) FCAPTION(VýrOperace)  CPOS( 84,16.8) CLEN(11) FONT(5)
      TYPE(Static) STYPE(17) SIZE( 98, 0.1) FPOS( 3, 17.4) RESIZE(yx)

    TYPE(END)
  TYPE(END)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(13,74) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(104, 20.1) FPOS(0.5,0.1) RESIZE(yn)
     TYPE(COMBOBOX) NAME(nZpuOdpis)   FPOS(27, 0.5) FLEN( 19) FCAPTION(Zpùsob odpisování)           CPOS( 4, 0.5) REF(NZPUODPIS)
     TYPE(GET)      NAME(nOprUctPS)   FPOS(27, 1.5) FLEN( 15) FCAPTION(Úèetní opravka na poè. roku) CPOS( 4, 1.5)
     TYPE(GET)      NAME(nOprDanPS)   FPOS(27, 2.5) FLEN( 15) FCAPTION(Daòová opravka na poè. roku) CPOS( 4, 2.5)
     TYPE(GET)      NAME(nRokyDanOd)  FPOS(27, 3.5) FLEN( 15) FCAPTION(Poèet let daòového odpisu)   CPOS( 4, 3.5)
     TYPE(GET)      NAME(nRokZvDanO)  FPOS(27, 4.5) FLEN( 15) FCAPTION(Rok zvýšení daòového odpisu) CPOS( 4, 4.5)
     TYPE(GET)      NAME(cTypSKP)     FPOS(27, 5.5) FLEN( 17) FCAPTION(SKP-klasif. produkce)        CPOS( 4, 5.5)

     TYPE(GET)      NAME(dDatRevIM)   FPOS(27, 6.5) FLEN( 15) FCAPTION(Datum revize majetku)        CPOS( 4, 6.5) PUSH( CLICKDATE) GROUPS(HIM)
     TYPE(GET)      NAME(cVyrCisIM)   FPOS(27, 7.5) FLEN( 30) FCAPTION(Výrobní èíslo)               CPOS( 4, 7.5) GROUPS(HIM)
     TYPE(GET)      NAME(cKodKlas)    FPOS(27, 8.5) FLEN( 30) FCAPTION(Kód klasifikace CZ-CC)       CPOS( 4, 8.5) GROUPS(HIM)
     TYPE(GET)      NAME(cCelek)      FPOS(27, 9.5) FLEN( 30) FCAPTION(Celek)                       CPOS( 4, 9.5) GROUPS(HIM)
     TYPE(GET)      NAME(cVykres)     FPOS(27,10.5) FLEN( 30) FCAPTION(Výkres)                      CPOS( 4,10.5) GROUPS(HIM)
     TYPE(GET)      NAME(cUmisteni)   FPOS(27,11.5) FLEN( 30) FCAPTION(Umístìní)                    CPOS( 4,11.5) GROUPS(HIM)

     TYPE(GET)      NAME(cKatUzemi)   FPOS(27,13.5) FLEN( 30) FCAPTION(Èíslo katastráln.území)      CPOS( 4,13.5) GROUPS(HIM)
     TYPE(GET)      NAME(cCisParc)    FPOS(27,14.5) FLEN( 30) FCAPTION(Èíslo parcely)               CPOS( 4,14.5) GROUPS(HIM)
     TYPE(GET)      NAME(nRozlParc)   FPOS(27,15.5) FLEN( 30) FCAPTION(Rozloha parcely v m2)        CPOS( 4,15.5) GROUPS(HIM)
    TYPE(End)
  TYPE(End)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(25,62) PRE( tabSelect)

    TYPE(MLE) NAME(mPopis) FPOS(2,1) SIZE(100,19) RESIZE(yy)
  TYPE(End)

* pozemky
*  TYPE(TabPage) TTYPE(4) CAPTION(Pozemky) FPOS( 1,6) OFFSET(85,2) PRE( tabSelect) TABBROWSE(POZEMKYW)
*    TYPE(Static) STYPE(13) SIZE(104, 20.1) FPOS(0.5,0.1) RESIZE(yn)
*
*    TYPE(EBrowse) FPOS(-.1, .5) SIZE(104,19) FILE(POZEMKY) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) ;
*                                                                                          FOOTER(y)  ;   
*                                                                                          GUILOOK(sizecols:n,headmove:y)
*      
*      TYPE(GET)  NAME( POZEMKY->cku_Kod)                   CLEN(  9)  CAPTION(KU) 
*      TYPE(GET)  NAME( POZEMKY->nListVlast)                CLEN( 10)  CAPTION(LV)
*      TYPE(GET)  NAME( POZEMKY->cParcCis)                  CLEN( 15)  CAPTION(èísloParcely) 
*      TYPE(GET)  NAME( POZEMKY->cParcCisP)                 CLEN( 15)  CAPTION(èísloParcely_pùvodní) 
*      TYPE(GET)  NAME( POZEMKY->cPodil)                    CLEN(  7)  CAPTION(podíl) 
*      TYPE(GET)  NAME( POZEMKY->nVymera_m2)                CLEN( 10)  CAPTION(výmPoz_m2)  
*      TYPE(GET)  NAME( POZEMKY->npodVym_m2)                CLEN( 10)  CAPTION(podVým_m2)  
*
*      TYPE(GET)  NAME( POZEMKY->nDruhPozem)                CLEN( 10)  CAPTION(druh pozemku)
*      TYPE(TEXT) NAME( POZEMKY->cNazPozem)                 CLEN( 15)  CAPTION(název pozemku) 
*
*      TYPE(GET)  NAME( POZEMKY->nCenaPoz)                  CLEN( 11)  CAPTION(cena) 
*      TYPE(GET)  NAME( POZEMKY->nDanNabPoz)                CLEN( 11)  CAPTION(daò) 
*      TYPE(GET)  NAME( POZEMKY->nCenaSDaNa)                CLEN( 11)  CAPTION(cenaS_daní ) 
*      TYPE(GET)  NAME( POZEMKY->cBPEJ)                     CLEN(  6)  CAPTION(bonita) 
*      TYPE(MLE)  NAME( POZEMKY->mPOZNAMKA)                 FLEN( 15)  FCAPTION(pùvodní vlastník)
*    TYPE(END)  
*    TYPE(END)
*  TYPE(End)


TYPE(End)