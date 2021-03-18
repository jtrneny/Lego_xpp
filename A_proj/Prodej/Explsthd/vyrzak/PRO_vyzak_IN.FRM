TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázka) SIZE(105,26) FILE(VYRZAKw);
              GUILOOK(Action:y,IconBar:y:MyIconBar,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

TYPE(Action) CAPTION(~Opravy a emise)  EVENT( OPRAVY_EMISE) TIPTEXT(Opravy a emise)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Kopie param.)  EVENT( ZAK_CopyPRM) TIPTEXT(Kopírování parametrù z jiných zakázek)
TYPE(Action) CAPTION(Výskyt v ~zak.) EVENT( PARAM_inZAK) TIPTEXT(Výskyt parametru v zakázkách)

TYPE(Static) STYPE(13) SIZE(104, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) CAPTION(Zakázka)           CPOS( 1,0.2) CLEN( 15) FONT(2)
  TYPE(GET) NAME(VYRZAKw->CCISZAKAZ)    FPOS( 1,1.2) FLEN( 30) FONT(5) NOREVISION()
  TYPE(GET) NAME(VYRZAKw->CNAZEVZAK1)   FPOS( 1,2.2) FLEN(100) FONT(5)
  TYPE(TEXT) CAPTION(Èíslo objednávky)  CPOS(45,0.2) CLEN( 15) FONT(2)
  TYPE(GET) NAME(VYRZAKw->CCISLOOBJ)    FPOS(45,1.2) FLEN( 56) FONT(5)
*   FCAPTION(Název zakázky)    CPOS(32,0.2) FONT(2)
*  TYPE(GET) NAME(VYRZAKw->CNAZEVZAK1)   FPOS(32,1.2) FLEN(70) FCAPTION(Název zakázky)    CPOS(32,0.2) FONT(2)
*  TYPE(GET) NAME(VYRZAKw->CCISLOOBJ)    FPOS(49,2.2) FLEN(53) FCAPTION(Èíslo objednávky) CPOS(32,2.2) FONT(2)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,22) FPOS(0,4)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(103, 4.5) FPOS( 1,0.2) RESIZE(yn)
      TYPE(GET)  NAME(cTypZak)          FPOS(20, 1) FLEN( 5) FCAPTION(Typ zakázky)      CPOS( 4,1)
      TYPE(Text) NAME(C_TYPZAK->cNazev) CPOS(27, 1) CLEN(20) BGND(13)
      TYPE(COMBOBOX) NAME(CPRIORZAKA)   FPOS(80, 1) FLEN(15) FCAPTION(Priorita zakázky) CPOS(67,1)
*      TYPE(GET)  NAME(cVyrobCisl)       FPOS(20, 2) FLEN(40) FCAPTION(Výrobní èíslo)    CPOS( 4,2)
      TYPE(GET)  NAME(cVyrPol)          FPOS(20, 2) FLEN(15) FCAPTION(Vyrábìná položka) CPOS( 4,2) PUSH( VYR_VYRPOL_SEL)
      TYPE(Text) NAME(VYRPOL->cNazev)   CPOS(37, 2) CLEN(30) BGND(13)
      TYPE(GET)  NAME(nVarCis)          FPOS(80, 2) FLEN( 3) FCAPTION(Varianta)         CPOS(71,2)
      TYPE(GET)  NAME(cVyrobCisl)       FPOS(20, 3) FLEN(40) FCAPTION(Výrobní èíslo)    CPOS( 4,3)
    TYPE(END)
*
    TYPE(Static) STYPE(13) SIZE(103,11.4) FPOS(1,4.8) RESIZE(yn)
     TYPE(GET)  NAME(NMNOZPLANO) FPOS(30, 1) FLEN( 12) FCAPTION(Množství plánované z objednávek) CPOS(4, 1) PUSH(ObjToVyrZAK)
     TYPE(TEXT) CAPTION(Množství zadané do výroby)         CPOS( 4, 2) CLEN( 25)
     TYPE(TEXT) NAME(NMNOZZADAN)                           CPOS(30, 2) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Množství vyrobené)                 CPOS( 4, 3) CLEN( 25)
     TYPE(TEXT) NAME(NMNOZVYROB)                           CPOS(30, 3) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Množství fakturované)              CPOS( 4, 4) CLEN( 25)
     TYPE(TEXT) NAME(NMNOZFAKT)                            CPOS(30, 4) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Poèet celých zapuštìní zakázky)    CPOS( 4, 5) CLEN( 25)
     TYPE(TEXT) NAME(NPOCCEZAPZ)                           CPOS(30, 5) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Poèet neúplných zapuštìní zakázky) CPOS( 4, 6) CLEN( 25)
     TYPE(TEXT) NAME(NPOCNEZAPZ)                           CPOS(30, 6) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Poè. celých odesl. mat. požadavkù) CPOS( 4, 7) CLEN( 25)
     TYPE(TEXT) NAME(NPOCCEODMA)                           CPOS(30, 7) CLEN( 13) CTYPE(2) BGND( 13)
     TYPE(TEXT) CAPTION(Poè. neúpl. odesl. mat. požadavkù) CPOS( 4, 8) CLEN( 25)
     TYPE(TEXT) NAME(NPOCNEODMA)                           CPOS(30, 8) CLEN( 13) CTYPE(2) BGND( 13)

     TYPE(GET)  NAME(NPLANPRUZA) FPOS(77, 1) FLEN(  6) FCAPTION(Prùbìh zakázky ve dnech)              CPOS(50, 1)
     TYPE(GET)  NAME(DZAPIS)     FPOS(77, 2) FLEN( 11) FCAPTION(Založení - Uzavøení zakázky)          CPOS(50, 2) PUSH(CLICKDATE)
     TYPE(TEXT) NAME(DUZAVZAKA)  CPOS(90, 2) CLEN(  9) BGND( 13)
     TYPE(GET)  NAME(DZPRADOKPL) FPOS(77, 3) FLEN( 11) FCAPTION(Zprac. dokumentace konstrukèní)       CPOS(50, 3) PUSH(CLICKDATE)
     TYPE(GET)  NAME(DZPRADOKSK) FPOS(77, 4) FLEN( 11) FCAPTION(Zprac. dokumentace technologické)     CPOS(50, 4) PUSH(CLICKDATE)
     TYPE(GET)  NAME(DODVEDZAKA) FPOS(77, 5) FLEN( 11) FCAPTION(Datum odvedení požadované)            CPOS(50, 5) PUSH(CLICKDATE)
     TYPE(GET)  NAME(DMOZODVZAK) FPOS(77, 6) FLEN( 11) FCAPTION(Datum odvedení možné)                 CPOS(50, 6) PUSH(CLICKDATE)
     TYPE(GET)  NAME(DSKUODVZAK) FPOS(77, 7) FLEN( 11) FCAPTION(Datum odvedení skuteèné)              CPOS(50, 7) PUSH(CLICKDATE)
     TYPE(GET)  NAME(dPredVykr)  FPOS(77, 8) FLEN( 11) FCAPTION(Datum pøedání výkresù do výroby)      CPOS(50, 8) PUSH(CLICKDATE)
     TYPE(GET)  NAME(dObDokKonP) FPOS(77, 9) FLEN( 11) FCAPTION(Dat.pøedání obch.dok.do konst.pož.)   CPOS(50, 9) PUSH(CLICKDATE)
     TYPE(GET)  NAME(dObDokKonS) FPOS(77,10) FLEN( 11) FCAPTION(Dat.pøedání obch.dok.do konst.skut.)  CPOS(50,10) PUSH(CLICKDATE)

*     TYPE(TEXT) CAPTION(Uzavøení výrobní zakázky) CPOS( 50, 9) CLEN( 25)
*     TYPE(TEXT) NAME(DUZAVZAKA)            CPOS(77, 9) CLEN(  9) BGND( 13)

    TYPE(END)
*
    TYPE(Static) STYPE(13) SIZE(103,4.6) FPOS(1,16.3) RESIZE(yn)
     TYPE(GET)      NAME(CNAZPOL1)          FPOS(20, 0.5) FLEN( 12) FCAPTION(Støedisko úèetní)  CPOS(4, 0.5)
     TYPE(Text)     NAME(CNAZPOL1->cNazev)  CPOS(34, 0.5) CLEN( 20) BGND(13)
     TYPE(GET)      NAME(CNAZPOL2)          FPOS(20, 1.5) FLEN( 12) FCAPTION(Výkon úèetní)      CPOS(4, 1.5)
     TYPE(Text)     NAME(CNAZPOL2->cNazev)  CPOS(34, 1.5) CLEN( 20) BGND(13)
     TYPE(GET)      NAME(CNAZPOL3)          FPOS(20, 2.5) FLEN( 12) FCAPTION(Zakázka úèetní)    CPOS(4, 2.5)
     TYPE(Text)     NAME(CNAZPOL3->cNazev)  CPOS(34, 2.5) CLEN( 20) BGND(13)
     TYPE(GET)      NAME(CNAZPOL4)          FPOS(20, 3.5) FLEN( 12) FCAPTION(Stroj úèetní)      CPOS(4, 3.5)
     TYPE(Text)     NAME(CNAZPOL4->cNazev)  CPOS(34, 3.5) CLEN( 20) BGND(13)
     TYPE(COMBOBOX) NAME(CSTAVZAKAZ)        FPOS(70, 0.5) FLEN(30) FCAPTION(Stav zakázky) CPOS(56, 0.5)
*     TYPE(COMBOBOX) NAME(CSTAVZAKAZ)        FPOS(20, 4.7) FLEN(30) FCAPTION(Stav zakázky) CPOS(4, 4.7)
    TYPE(END)

  TYPE(END)

* DODACÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Dodací údaje)  FPOS( 1,6) OFFSET(18,66)  PRE( tabSelect)

    TYPE(TEXT) CAPTION(OBJEDNAVATEL)  CPOS( 2, 0.5) CLEN(14)
    TYPE(STATIC) STYPE(9)  FPOS( 1, 1) SIZE( 103, 6 ) RESIZE(yn)
*      TYPE(TEXT) CAPTION(OBJEDNAVATEL)  CPOS( 2, -0.4) CLEN(14)
      TYPE(GET)  NAME(nCisFirmy)       FPOS(  7 ,0.5) FLEN( 8) FCAPTION(Firma)  CPOS( 1 ,0.5) PUSH( VYR_Firmy_sel)
      TYPE(GET)  NAME(cNazFirmy)       FPOS( 25, 0.5) FLEN(51) FCAPTION(Název)  CPOS( 18,0.5)
      TYPE(GET)  NAME(cUlice)          FPOS( 25, 1.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,1.5)
      TYPE(GET)  NAME(cSidlo)          FPOS( 53, 1.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,1.5)
      TYPE(GET)  NAME(nICO)            FPOS( 87, 0.5) FLEN(14) FCAPTION(IÈO)    CPOS( 80,0.5)
      TYPE(GET)  NAME(cDIC)            FPOS( 87, 1.5) FLEN(14) FCAPTION(DIÈ)    CPOS( 80,1.5)

*      TYPE(TEXT) CAPTION(Název)        CPOS( 19, 0.5) CLEN( 6)
*      TYPE(TEXT) NAME(FIRMY->cNazev)   CPOS( 27, 0.5) CLEN(55) BGND( 13)
*      TYPE(TEXT) CAPTION(Ulice)        CPOS( 19, 1.5) CLEN( 6)
*      TYPE(TEXT) NAME(FIRMY->cUlice)   CPOS( 27, 1.5) CLEN(20) BGND( 13)
*      TYPE(TEXT) CAPTION(Místo)        CPOS( 48, 1.5) CLEN( 6)
*      TYPE(TEXT) NAME(FIRMY->cSidlo)   CPOS( 55, 1.5) CLEN(27) BGND( 13)
*      TYPE(TEXT) CAPTION(IÈO)          CPOS( 83, 0.5) CLEN( 4)
*      TYPE(TEXT) NAME(FIRMY->nICO)     CPOS( 87, 0.5) CLEN(14) BGND( 13)
*      TYPE(TEXT) CAPTION(DIÈ)          CPOS( 83, 1.5) CLEN( 4)
*      TYPE(TEXT) NAME(FIRMY->cDIC)     CPOS( 87, 1.5) CLEN(14) BGND( 13)

      TYPE(TEXT)   CAPTION(DODACÍ ADRESA)  CPOS( 2, 2.5) CLEN(14)
      TYPE(Static) STYPE(17) SIZE(102, 0.1) FPOS( 0, 3) RESIZE(yx)

      TYPE(GET)  NAME(nCisFirDoA)      FPOS(  7 ,3.5) FLEN( 8) FCAPTION(Firma)  CPOS(  1,3.5)  PUSH( VYR_Firmy_sel)
      TYPE(GET)  NAME(cNazevDoA)       FPOS( 25, 3.5) FLEN(51) FCAPTION(Název)  CPOS( 18,3.5)
      TYPE(GET)  NAME(cUliceDoa)       FPOS( 25, 4.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,4.5)
      TYPE(GET)  NAME(cSidloDoa)       FPOS( 53, 4.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,4.5)

      TYPE(GET)  NAME(dDatVyklad)      FPOS( 90, 3.5) FLEN(11) FCAPTION(Dat.vykládky)  CPOS( 79,3.5) PUSH(CLICKDATE)
      TYPE(GET)  NAME(cCasVyklad)      FPOS( 90, 4.5) FLEN(11) FCAPTION(Èas vykládky)  CPOS( 79,4.5)
    TYPE(End)
*
    TYPE(Static) STYPE(13) SIZE(103,14) FPOS(1, 7)  RESIZE(yn)
      TYPE(GET)  NAME(nCisDodavk)           FPOS( 17, 0.5) FLEN( 12) FCAPTION( Èíslo dodávky)  CPOS( 1, 0.5)
      TYPE(TEXT) NAME(DociPodm->cOznDodavk) CPOS( 30, 0.5) CLEN(30) BGND( 13)

      TYPE(COMBOBOX) NAME(CTYPCENY)      FPOS(17, 2) FLEN( 14)  FCAPTION(Typ ceny)         CPOS(1, 2)
      TYPE(GET)      NAME(NKLICDPH)      FPOS(17, 3) FLEN(  6)  FCAPTION(Kód DPH)          CPOS(1, 3)
      TYPE(TEXT)     NAME(C_DPH->nProcDph) CPOS( 25, 3)   CLEN( 5)
      TYPE(TEXT)     CAPTION(%)            CPOS( 30, 3)   CLEN( 3)
      TYPE(GET)      NAME(NCENAMJ)       FPOS(17, 4) FLEN( 13)  FCAPTION(Cena za Mj)       CPOS(1, 4)
      TYPE(GET)      NAME(NCENACELK)     FPOS(17, 5) FLEN( 13)  FCAPTION(Celkem bez DPH)   CPOS(1, 5)
      TYPE(GET)      NAME(CZKRATMENZ)    FPOS(31, 5) FLEN(  6)
      TYPE(GET)      NAME(NCENZAKCEL)    FPOS(17, 6) FLEN( 13)  FCAPTION(Celkem s DPH)     CPOS(1, 6)
      TYPE(GET)      NAME(NZALOHA)       FPOS(17, 7) FLEN( 13)  FCAPTION(Zaplacená záloha) CPOS(1, 7)
      TYPE(GET)      NAME(NPRIRAZKA)     FPOS(17, 8) FLEN( 13)  FCAPTION(Pøirážka)         CPOS(1, 8)
      TYPE(GET)      NAME(nCenaPrepr)    FPOS(17, 9) FLEN( 13)  FCAPTION(Cena pøepravy)    CPOS(1, 9)
      TYPE(GET)      NAME(nCenaProd)     FPOS(17,10) FLEN( 13)  FCAPTION(Cena prodejní)    CPOS(1,10)

      TYPE(GET)      NAME(CSKP)          FPOS(55, 2) FLEN( 18)  FCAPTION(Typ SKP)          CPOS(40, 2)
      TYPE(TEXT)     NAME(C_TYPSKP->CNAZTYPSKP)  CPOS( 74, 2)  CLEN( 25) BGND( 13)
      TYPE(GET)      NAME(CDANPZBO)      FPOS(55, 3) FLEN( 18) FCAPTION(Daòová položka)    CPOS(40, 3)
      TYPE(GET)      NAME(NCISFAK)       FPOS(55, 4) FLEN( 10) FCAPTION(Èíslo faktury)     CPOS(40, 4)
      TYPE(GET)      NAME(CMISTOOBJ)     FPOS(55, 5) FLEN( 25) FCAPTION(Místo urèení)      CPOS(40, 5)
      TYPE(GET)      NAME(CZKRTYPUHR)    FPOS(55, 6) FLEN( 13)  FCAPTION(Typ úhrady)       CPOS(40, 6)
      TYPE(GET)      NAME(CZKRZPUDOP)    FPOS(55, 7) FLEN( 18) FCAPTION(Zpùsob dopravy)    CPOS(40, 7)
      TYPE(GET)      NAME(CTYPDODAVK)    FPOS(55, 8) FLEN( 18) FCAPTION(Dodací podmínky)   CPOS(40, 8)
    TYPE(End)

  TYPE(END)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(34,50)  PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(104,17) FPOS(0.5, 0.5)  RESIZE(yn)
     TYPE(GET)      NAME(NHMOTNOST)        FPOS(18, 0.5) FLEN( 13) FCAPTION(Hmotnost)             CPOS(1,0.5)
     TYPE(GET)      NAME(CZKRATJEDH)       FPOS(32, 0.5) FLEN(  6)
     TYPE(GET)      NAME(NOBJEM)           FPOS(18, 1.5) FLEN( 13) FCAPTION(Objem)                CPOS(1,1.5)
     TYPE(GET)      NAME(CZKRATJEDO)       FPOS(32, 1.5) FLEN(  6)
     TYPE(GET)      NAME(nRozm_vys)        FPOS(18, 2.5) FLEN( 13) FCAPTION(Rozmìry       - Výška)CPOS( 1,2.5)
     TYPE(GET)      NAME(nRozm_sir)        FPOS(18, 3.5) FLEN( 13) FCAPTION(- Šíøka)              CPOS(10,3.5)
     TYPE(GET)      NAME(nRozm_del)        FPOS(18, 4.5) FLEN( 13) FCAPTION(- Délka)              CPOS(10,4.5)
     TYPE(GET)      NAME(cRozm_MJ)         FPOS(32, 4.5) FLEN(  6)

     TYPE(GET)      NAME(CSTRED_ODB)       FPOS(18, 5.5) FLEN( 13) FCAPTION(Støedisko odbìratele) CPOS(1, 5.5)
     TYPE(TEXT)     NAME(C_STREOD->cNazev) CPOS(32, 5.5) CLEN( 20) BGND( 13)
     TYPE(GET)      NAME(CSTROJ_ODB)       FPOS(18, 6.5) FLEN( 13) FCAPTION(Stroj odbìratele)     CPOS(1, 6.5)
     TYPE(TEXT)     NAME(C_STRJOD->cNazev) CPOS(32, 6.5) CLEN( 20) BGND( 13)
     TYPE(GET)      NAME(CCISPLAN)         FPOS(18, 7.5) FLEN( 15) FCAPTION(Èíslo plánu)          CPOS(1, 7.5)
     TYPE(GET)      NAME(CKATOZNODB)       FPOS(18, 8.5) FLEN( 15) FCAPTION(Katal.ozn. odbìratele)CPOS(1, 8.5)
     TYPE(GET)      NAME(CKONSTRUKT)       FPOS(18, 9.5) FLEN( 30) FCAPTION(Konstruktér)          CPOS(1, 9.5)
     TYPE(GET)      NAME(CVYBAVA)          FPOS(18,10.5) FLEN( 70) FCAPTION(Výbava)               CPOS(1,10.5)
*
*   TYPE(Static) STYPE(16) SIZE(1, 10) FPOS( 45, 0.5) RESIZE(y)
*
    TYPE(End)

    TYPE(Static) STYPE(13) SIZE(104,3) FPOS(0.5,17.8)  RESIZE(yn)
      TYPE(GET)      NAME(nCisOsZAL)     FPOS(17, 0.5) FLEN( 10)  FCAPTION(Založila osoba)   CPOS( 1, 0.5) PUSH(VYR_Osoby_sel)
      TYPE(GET)      NAME(cJmeOsZAL)     FPOS(29, 0.5) FLEN( 25)
      TYPE(GET)      NAME(nCisOsOdp)     FPOS(17, 1.5) FLEN( 10)  FCAPTION(Zodpovídá osoba)  CPOS( 1, 1.5) PUSH(VYR_Osoby_sel)
      TYPE(GET)      NAME(cJmeOsOdp)     FPOS(29, 1.5) FLEN( 25)

*      TYPE(GET)      NAME(CZAPIS)     FPOS(17, 0.5) FLEN(  8)  FCAPTION(Zakázku založil)           CPOS( 1, 0.5)
*      TYPE(GET)      NAME(CODPOVPRAC) FPOS(17, 1.5) FLEN( 25)  FCAPTION(Za zak. odpovídá)          CPOS( 1, 1.5)
      TYPE(COMBOBOX) NAME(CINTID)     FPOS(85, 1.5) FLEN( 14)  FCAPTION(Interní rozlišení zakázky) CPOS(65, 1.5)
    TYPE(End)

  TYPE(End)

* KALKULACE
  TYPE(TabPage) TTYPE(4) CAPTION(Kalkulace) FPOS( 1,6)  OFFSET(50,34) PRE( tabSelect)

    TYPE(Browse) FILE(KALKUL) INDEXORD(1) ;
                 FIELDS(dDatAktual                ,;
                        nCenMatMJP:Mat/MJ - Plán  ,;
                        nCenMzdVDP:Mzdy VD-Plán   ,;
                        nCenKalkP:CenaKALK - Plán ,;
                        nCenMatMJS:Mat/MJ - Skut  ,;
                        nCenMzdVDS:Mzdy VD-Skut   ,;
                        nCenKalkS:CenaKALK - Skut) ;
                 SIZE(100,18.5) FPOS(2, 0.5) SCROLL(ny) CURSORMODE(3) PP(7)
  TYPE(End)

* PARAMETRY
  TYPE(TabPage) TTYPE(4) CAPTION(Parametry) FPOS( 1,6) OFFSET(66,18) PRE( tabSelect)

    TYPE(DBrowse) FILE(ZAKAPAR) INDEXORD(1) ;
                  FIELDS( nCisAtribZ  ,;
                          cAtrib      ,;
                          cHodnAtrC   ,;
                          nHodnAtrN   );
                  SIZE(100,17) FPOS(2, 0.5) SCROLL(ny) CURSORMODE(3) PP(7)

    TYPE(Static) STYPE(13) SIZE(102, 3) FPOS(2,17.7)  RESIZE(yx)
      TYPE(GET)  NAME(ZAKAPAR->nCisAtribZ)  FPOS(  1 ,1.5) FLEN( 8) FCAPTION(Èís.atributu)    CPOS( 1,0.5)
      TYPE(GET)  NAME(ZAKAPAR->cAtrib)      FPOS( 10 ,1.5) FLEN(20) FCAPTION(Atribut zakázky) CPOS(10,0.5)
      TYPE(GET)  NAME(ZAKAPAR->cHodnAtrC)   FPOS( 31 ,1.5) FLEN(40) FCAPTION(Hodnota znaková) CPOS(31,0.5)
      TYPE(GET)  NAME(ZAKAPAR->nHodnAtrN)   FPOS( 73 ,1.5) FLEN(15) FCAPTION(Hodnota èíselná) CPOS(73,0.5)
    TYPE(End)

  TYPE(End)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(82, 2) PRE( tabSelect)
*    TYPE(TEXT)  CAPTION(Popis 1) CPOS( 2, 1) CLEN( 8)
    TYPE(Static) STYPE( 9) SIZE(99.5, 1.2) FPOS( 2.5, 0.9) RESIZE(yn)
      TYPE(Text)   CAPTION(Popis 1)     CPOS( 1, 0.1) CLEN( 15)
    TYPE(End)
    TYPE(MLE)   NAME(MPOPISZAK)  FPOS( 2, 2) SIZE(100,9) RESIZE(yy)

*    TYPE(TEXT)  CAPTION(Popis 2) CPOS( 2,11) CLEN( 8)
    TYPE(Static) STYPE( 9) SIZE(99.5, 1.2) FPOS( 2.5, 11) RESIZE(yx)
      TYPE(Text)   CAPTION(Popis 2)     CPOS( 1, 0.1) CLEN( 15)
    TYPE(End)
    TYPE(MLE)   NAME(MPOPISZAK2) FPOS( 2,12.1) SIZE(100,9) RESIZE(yx)
  TYPE(End)

TYPE(End)