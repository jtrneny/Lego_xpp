TYPE(drgForm) DTYPE(10) TITLE(Položka výrobní zakázky) SIZE(105,26) FILE(VYRZAKITw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE)
*              CBSAVE(OnSave)

*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Kopie param.)  EVENT( ZAK_CopyPRM) TIPTEXT(Kopírování parametrù z jiných zakázek)

TYPE(Static) STYPE(13) SIZE(104, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) FCAPTION(Zakázka)          CPOS( 2,0.2) CLEN( 10) FONT(2)
  TYPE(TEXT) NAME(VYRZAK->cCisZakaz)    CPOS( 2,1.2) CLEN( 30) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(TEXT) NAME(VYRZAK->cNazevZak1)   CPOS( 2,2.2) CLEN(100) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(TEXT) CAPTION(Položka è.)        CPOS(45,0.2) CLEN( 10) FONT(2)
  TYPE(TEXT) NAME(NORDITEM)   CPOS(45,1.2) CLEN( 10) BGND( 13) TYPE(2) FONT(5) GROUPS(clrGREY)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,22) FPOS(0,4)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(104, 17.5) FPOS( 0.5,0.2) RESIZE(yn)
      TYPE(GET)  NAME(cVyrobCisl)        FPOS( 18, 1) FLEN( 40) FCAPTION(Výrobní èíslo)  CPOS( 2, 1) NOREVISION()
      TYPE(GET)  NAME(nMnozPlano)        FPOS( 18, 3) FLEN( 20) FCAPTION(Množství)       CPOS( 2, 3)
      TYPE(GET)  NAME(cZkratJedn)        FPOS( 40, 3) FLEN(  5) NOREVISION()
      TYPE(GET)  NAME(cBarva)            FPOS( 18, 4) FLEN( 20) FCAPTION(Barva vnìjší)   CPOS( 2, 4)
      TYPE(GET)  NAME(cBarva_2)          FPOS( 18, 5) FLEN( 20) FCAPTION(Barva vnitøní)  CPOS( 2, 5)


      TYPE(GET)  NAME(DZAPIS)     FPOS(77, 3) FLEN( 11) FCAPTION(Založení - Uzavøení zakázky)          CPOS(50, 3) PUSH(CLICKDATE)
      TYPE(TEXT) NAME(DUZAVZAKA)  CPOS(90, 3) CLEN(  9) BGND( 13)
      TYPE(GET)  NAME(DZPRADOKPL) FPOS(77, 4) FLEN( 11) FCAPTION(Zprac. dokumentace konstrukèní)       CPOS(50, 4) PUSH(CLICKDATE)
      TYPE(GET)  NAME(DZPRADOKSK) FPOS(77, 5) FLEN( 11) FCAPTION(Zprac. dokumentace technologické)     CPOS(50, 5) PUSH(CLICKDATE)
      TYPE(GET)  NAME(DODVEDZAKA) FPOS(77, 6) FLEN( 11) FCAPTION(Datum odvedení požadované)            CPOS(50, 6) PUSH(CLICKDATE)
      TYPE(GET)  NAME(DMOZODVZAK) FPOS(77, 7) FLEN( 11) FCAPTION(Datum odvedení možné)                 CPOS(50, 7) PUSH(CLICKDATE)
      TYPE(GET)  NAME(DSKUODVZAK) FPOS(77, 8) FLEN( 11) FCAPTION(Datum odvedení skuteèné)              CPOS(50, 8) PUSH(CLICKDATE)
      TYPE(GET)  NAME(dPredVykr)  FPOS(77, 9) FLEN( 11) FCAPTION(Datum pøedání výkresù do výroby)      CPOS(50, 9) PUSH(CLICKDATE)
      TYPE(GET)  NAME(dObDokKonP) FPOS(77,10) FLEN( 11) FCAPTION(Dat.pøedání obch.dok.do konst.pož.)   CPOS(50,10) PUSH(CLICKDATE)
      TYPE(GET)  NAME(dObDokKonS) FPOS(77,11) FLEN( 11) FCAPTION(Dat.pøedání obch.dok.do konst.skut.)  CPOS(50,11) PUSH(CLICKDATE)
    TYPE(END)

    TYPE(Static) STYPE(13) SIZE(104,3) FPOS(0.5,17.8)  RESIZE(yn)
      TYPE(GET)      NAME(cJmeOsZAL)     FPOS(17, 0.5) FLEN( 25)  FCAPTION(Založila osoba)   CPOS( 1, 0.5) PUSH(VYR_Osoby_sel)
      TYPE(GET)      NAME(cJmeOsOdp)     FPOS(17, 1.5) FLEN( 25)  FCAPTION(Zodpovídá osoba)  CPOS( 1, 1.5) PUSH(VYR_Osoby_sel)
*      TYPE(GET)      NAME(nCisOsZAL)     FPOS(17, 0.5) FLEN( 10)  FCAPTION(Založila osoba)   CPOS( 1, 0.5) PUSH(VYR_Osoby_sel)
*      TYPE(GET)      NAME(cJmeOsZAL)     FPOS(29, 0.5) FLEN( 25)
*      TYPE(GET)      NAME(nCisOsOdp)     FPOS(17, 1.5) FLEN( 10)  FCAPTION(Zodpovídá osoba)  CPOS( 1, 1.5) PUSH(VYR_Osoby_sel)
*      TYPE(GET)      NAME(cJmeOsOdp)     FPOS(29, 1.5) FLEN( 25)
    TYPE(End)
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

      TYPE(TEXT)   CAPTION(DODACÍ ADRESA)  CPOS( 2, 2.5) CLEN(14)
      TYPE(Static) STYPE(17) SIZE(102, 0.1) FPOS( 0, 3) RESIZE(yx)

      TYPE(GET)  NAME(nCisFirDoA)      FPOS(  7 ,3.5) FLEN( 8) FCAPTION(Firma)  CPOS(  1,3.5)  PUSH( VYR_Firmy_sel)
      TYPE(GET)  NAME(cNazevDoA)       FPOS( 25, 3.5) FLEN(51) FCAPTION(Název)  CPOS( 18,3.5)
      TYPE(GET)  NAME(cUliceDoa)       FPOS( 25, 4.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,4.5)
      TYPE(GET)  NAME(cSidloDoa)       FPOS( 53, 4.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,4.5)

*      TYPE(GET)  NAME(dDatVyklad)      FPOS( 90, 3.5) FLEN(11) FCAPTION(Dat.vykládky)  CPOS( 79,3.5) PUSH(CLICKDATE)
*      TYPE(GET)  NAME(cCasVyklad)      FPOS( 90, 4.5) FLEN(11) FCAPTION(Èas vykládky)  CPOS( 79,4.5)
    TYPE(End)
*
    TYPE(Static) STYPE(13) SIZE(103,14) FPOS(1, 7)  RESIZE(yn)
*      TYPE(GET)      NAME(nCisloEL)      FPOS( 17, 0.5) FLEN( 12) FCAPTION( Expedièní list)  CPOS( 1, 0.5)

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
      TYPE(GET)      NAME(NCISFAK)       FPOS(55, 4) FLEN( 18) FCAPTION(Èíslo faktury)     CPOS(40, 4)
      TYPE(GET)      NAME(CMISTOOBJ)     FPOS(55, 5) FLEN( 25) FCAPTION(Místo urèení)      CPOS(40, 5)
      TYPE(GET)      NAME(CZKRTYPUHR)    FPOS(55, 6) FLEN( 18) FCAPTION(Typ úhrady)        CPOS(40, 6)
      TYPE(GET)      NAME(CZKRZPUDOP)    FPOS(55, 7) FLEN( 18) FCAPTION(Zpùsob dopravy)    CPOS(40, 7)
      TYPE(GET)      NAME(CTYPDODPOD)    FPOS(55, 8) FLEN( 18) FCAPTION(Typ dodací podm.)  CPOS(40, 8)
    TYPE(End)

  TYPE(End)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(34,50)  PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(104,17) FPOS(0.5, 0.5)  RESIZE(yn)
     TYPE(GET)      NAME(nVahaPred)        FPOS(18, 0.5) FLEN( 13) FCAPTION(Hmotnost pøedbìžná)   CPOS(1,0.5)
     TYPE(GET)      NAME(cMJVahaP)         FPOS(32, 0.5) FLEN(  6)
     TYPE(GET)      NAME(nVahaSkut)        FPOS(18, 1.5) FLEN( 13) FCAPTION(Hmotnost skuteèná)    CPOS(1,1.5)
     TYPE(GET)      NAME(cMJVahaS)         FPOS(32, 1.5) FLEN(  6)
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

    TYPE(End)
  TYPE(End)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(50,34) PRE( tabSelect)
    TYPE(MLE) NAME(MPOPISZAK) FPOS(2,1) SIZE(100,19)
  TYPE(End)

TYPE(End)