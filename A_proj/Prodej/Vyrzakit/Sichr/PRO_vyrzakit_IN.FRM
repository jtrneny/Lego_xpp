TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázka) SIZE(105,26) FILE(vyrzakitw);
              GUILOOK(Action:y,IconBar:y:MyIconBar,Menu:n);
              POST( POSTVALIDATE)

TYPE(Static) STYPE(13) SIZE(104, 4.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) CAPTION(Zakázka)       CPOS( 1, 0.3)  CLEN( 10) FONT(2)
  TYPE(GET)  NAME(CCISZAKAZ)        FPOS(11, 0.3)  FLEN( 30) FONT(5)                            NOREVISION()

  TYPE(TEXT) CAPTION(Výrobní èíslo) CPOS(45, 0.3)  CLEN( 13) FONT(2)
  TYPE(TEXT) NAME(ccisZakazI)       CPOS(58, 0.3)  CLEN( 45) FONT(5) BGND(13)

  TYPE(GET)  NAME(CNAZEVZAK1)       FPOS( 2, 1.4) FLEN(100) FONT(5)

  TYPE(GET)  NAME(nRozm_del)        FPOS(18, 2.5) FLEN( 13) FCAPTION(Rozmìry          - délka) CPOS( 1, 2.5) CLEN(17)
  TYPE(GET)  NAME(nRozm_sir)        FPOS(38, 2.5) FLEN( 13) FCAPTION(šíøka)                    CPOS(33, 2.5) CLEN( 5)
  TYPE(GET)  NAME(nRozm_vys)        FPOS(58, 2.5) FLEN( 13) FCAPTION(výška)                    CPOS(53, 2.5) CLEN( 5)
  TYPE(GET)  NAME(cRozm_MJ)         FPOS(73, 2.5) FLEN(  6)

  TYPE(GET)  NAME(nRozmP_del)       FPOS(18, 3.5) FLEN( 13) FCAPTION(pøepravní        - délka) CPOS( 1, 3.5) CLEN(17)
  TYPE(GET)  NAME(nRozmP_sir)       FPOS(38, 3.5) FLEN( 13) FCAPTION(šíøka)                    CPOS(33, 3.5) CLEN( 5)
  TYPE(GET)  NAME(nRozmP_vys)       FPOS(58, 3.5) FLEN( 13) FCAPTION(výška)                    CPOS(53, 3.5) CLEN( 5)
  TYPE(GET)  NAME(cRozmP_MJ)        FPOS(73, 3.5) FLEN(  6)
TYPE(End)


TYPE(Static) STYPE(13) SIZE(105,22) FPOS(0,5.2)  RESIZE(yy)

* -1- ZÁKLADNÍ ÚDAJE 
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,8)  OFFSET(1,82) PRE( tabSelect)

    TYPE(TEXT) CAPTION(ODBÌRATEL)  CPOS( 3,-.3) CLEN(10) 
    TYPE(STATIC) STYPE(9)  FPOS(1,.2) SIZE( 103, 6 ) RESIZE(yn)
      TYPE(GET)  NAME(nCisFirmy)       FPOS(  7 ,0.5) FLEN( 8) FCAPTION(Firma)  CPOS( 1 ,0.5) PUSH(fir_firmy_sel)
      TYPE(GET)  NAME(cNazFirmy)       FPOS( 25, 0.5) FLEN(51) FCAPTION(Název)  CPOS( 18,0.5) 
      TYPE(GET)  NAME(cUlice)          FPOS( 25, 1.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,1.5)
      TYPE(GET)  NAME(cSidlo)          FPOS( 53, 1.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,1.5)
      TYPE(GET)  NAME(nICO)            FPOS( 87, 0.5) FLEN(14) FCAPTION(IÈO)    CPOS( 80,0.5)
      TYPE(GET)  NAME(cDIC)            FPOS( 87, 1.5) FLEN(14) FCAPTION(DIÈ)    CPOS( 80,1.5)

      TYPE(TEXT)   CAPTION(DODACÍ ADRESA)  CPOS( 2, 2.5) CLEN(14)
      TYPE(Static) STYPE(17) SIZE(102, 0.1) FPOS( 0, 3) RESIZE(yx)

      TYPE(GET)  NAME(nCisFirDoA)      FPOS(  7 ,3.5) FLEN( 8) FCAPTION(Firma)  CPOS(  1,3.5)  PUSH(fir_firmy_sel)
      TYPE(GET)  NAME(cNazevDoA)       FPOS( 25, 3.5) FLEN(51) FCAPTION(Název)  CPOS( 18,3.5)
      TYPE(GET)  NAME(cUliceDoa)       FPOS( 25, 4.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,4.5)
      TYPE(GET)  NAME(cSidloDoa)       FPOS( 53, 4.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,4.5)

*-      TYPE(GET)  NAME(dDatVyklad)      FPOS( 90, 3.5) FLEN(11) FCAPTION(Dat.vykládky)  CPOS( 79,3.5) PUSH(CLICKDATE)
*-      TYPE(GET)  NAME(cCasVyklad)      FPOS( 90, 4.5) FLEN(11) FCAPTION(Èas vykládky)  CPOS( 79,4.5)
    TYPE(End)


    TYPE(Static) STYPE(13) SIZE(103,10.8) FPOS(1,6.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypZak)          FPOS(12, .5) FLEN( 8) FCAPTION(Typ zakázky)      CPOS( 1,.5) NOREVISION()
      TYPE(Text)     NAME(C_TYPZAK->cNazev) CPOS(22, .5) CLEN(20) BGND(13)
      TYPE(COMBOBOX) NAME(CPRIORZAKA)       FPOS(55, .5) FLEN(15) FCAPTION(Priorita zakázky) CPOS(43,.5) CLEN(12)
*      TYPE(GET)      NAME(CTYPDODAVK)       FPOS(84, .5) FLEN(17) FCAPTION(Dodací podmínky)  CPOS(71,.5) CLEN(13)
      TYPE(GET)      NAME(CTYPDODPOD)       FPOS(84, .5) FLEN(17) FCAPTION(Dodací podmínky)  CPOS(71,.5) CLEN(13)

      TYPE(STATIC) FPOS(0.4,1.7) SIZE(102.6,.2) STYPE(12) 
      TYPE(End)

      TYPE(GET)      NAME(NMNOZPLANO)       FPOS(27, 2.5) FLEN( 13) FCAPTION(Množství plánované z objednávek)     CPOS( 1, 2.5)
      TYPE(GET)      NAME(cZKRATJEDN)       FPOS(42, 2.5) FLEN(  5) NOREVISION()
      TYPE(GET)      NAME(cBarva)           FPOS(27, 3.5) FLEN( 13) FCAPTION(Barva vnìjší/vnitøní)                CPOS( 1, 3.5)
      TYPE(GET)      NAME(cBarva_2)         FPOS(42, 3.5) FLEN( 13) 
      TYPE(GET)      NAME(DZAPIS)           FPOS(27, 4.5) FLEN( 13) FCAPTION(Založení - Uzavøení zakázky)         CPOS( 1, 4.5) PUSH(CLICKDATE)
      TYPE(TEXT)     NAME(DUZAVZAKA)        CPOS(42, 4.5) CLEN( 14) BGND( 13)
      TYPE(GET)      NAME(DODVEDZAKA)       FPOS(27, 5.5) FLEN( 13) FCAPTION(Datum odvedení požadované)           CPOS( 1, 5.5) PUSH(CLICKDATE)

      TYPE(GET)      NAME(DMOZODVZAK)       FPOS(27, 6.5) FLEN( 13) FCAPTION(Datum odvedení možné)                CPOS( 1, 6.5) PUSH(CLICKDATE)
      TYPE(GET)      NAME(DSKUODVZAK)       FPOS(27, 7.5) FLEN( 13) FCAPTION(Datum odvedení skuteèné)             CPOS( 1, 7.5) PUSH(CLICKDATE)
      TYPE(TEXT)     NAME(ntydenODV)        CPOS(42, 7.5) CLEN(  3)
      TYPE(TEXT)     CAPTION(/)             CPOS(45, 7.5) CLEN(  2)
      TYPE(TEXT)     NAME(nmesicODV)        CPOS(47, 7.5) CLEN(  3)
      TYPE(TEXT)     CAPTION(/)             CPOS(50, 7.5) CLEN(  2)
      TYPE(TEXT)     NAME(nrokODV)          CPOS(52, 7.5) CLEN(  5)

      TYPE(GET)      NAME(dObDokKonP)       FPOS(27, 8.5) FLEN( 13) FCAPTION(Dat.pøedání dok_do konst.pož.)       CPOS( 1, 8.5) PUSH(CLICKDATE)
      TYPE(GET)      NAME(dObDokKonS)       FPOS(27, 9.5) FLEN( 13) FCAPTION(Dat.pøedání dok_do konst.skut.)      CPOS( 1, 9.5) PUSH(CLICKDATE)

      TYPE(GET)      NAME(NCENAMJ)          FPOS(73, 2.5) FLEN( 13) FCAPTION(Cena za Mj)                          CPOS(58, 2.5)
      TYPE(GET)      NAME(CZKRATMENZ)       FPOS(92, 2.5) FLEN(  7) FCAPTION( v)                                  CPOS(88, 2.5) CLEN(4)
      TYPE(GET)      NAME(NCENACELK)        FPOS(73, 3.5) FLEN( 13) FCAPTION(Celkem bez DPH)                      CPOS(58, 3.5)

      TYPE(ComboBox) NAME(nklicDPH)         FPOS(92, 3.5) FLEN( 8) FCAPTION(dph)  CPOS(88, 3.5) CLEN(4) VALUES(a,a,a,a) 
*-      TYPE(GET)      NAME(M->procDph)       FPOS(92, 3.5) FLEN(  7) FCAPTION(dph)                                 CPOS(88, 3.5) CLEN(4)
      TYPE(TEXT)     CAPTION(%)             CPOS(99.8,3.5) CLEN(2.5)

      TYPE(GET)      NAME(NCENZAKCEL)       FPOS(73, 4.5) FLEN( 13) FCAPTION(Celkem s DPH)                        CPOS(58, 4.5)
      TYPE(GET)      NAME(NZALOHA)          FPOS(73, 5.5) FLEN( 13) FCAPTION(Zaplacená záloha)                    CPOS(58, 5.5)
      TYPE(GET)      NAME(nCenaPrepr)       FPOS(73, 6.5) FLEN( 13) FCAPTION(Cena pøepravy)                       CPOS(58, 6.5)
      TYPE(GET)      NAME(nCenaProd)        FPOS(73, 7.5) FLEN( 13) FCAPTION(Cena prodejní)                       CPOS(58, 7.5)
 
      TYPE(Get)      NAME(NKURZAHMEN)       FPOS(73, 8.5) FLEN( 13) FCAPTION(Kurz/pøepoèet)                       CPOS(58, 8.5)
      TYPE(Get)      NAME(NMNOZPREP)        FPOS(88, 8.5) FLEN( 11)     
      TYPE(TEXT)     CAPTION(Cena celkem )  CPOS(58, 9.7) 
      TYPE(TEXT)     NAME(NCENCELTUZ)       CPOS(73, 9.7) CLEN( 14) BGND(13) CTYPE(2) 
      TYPE(TEXT)     NAME(M->zaklMena)      CPOS(88, 9.7) CLEN(  4) FONT(5)
    TYPE(END)

    TYPE(Static) STYPE(13) SIZE(103,4.6) FPOS(1,17.2) RESIZE(yn)
*       TYPE(GET)      NAME(nCisOsZAL)     FPOS(17, 0.3) FLEN( 10)  FCAPTION(Založila osoba)   CPOS( 1, 0.3) PUSH(osb_osoby_sel)
*       TYPE(GET)      NAME(cJmeOsZAL)     FPOS(29, 0.3) FLEN( 25)
  
       TYPE(TEXT)                                                   CAPTION(Založila osoba)   CPOS( 1, 0.3)    
       TYPE(TEXT)     NAME(cjmeOsZal)     CPOS(17, 0.3) CLEN( 38)  BGND(13)
       TYPE(GET)      NAME(cJmeOsOdp)     FPOS(17, 1.3) FLEN( 37)  FCAPTION(Zodpovídá osoba)  CPOS( 1, 1.3) PUSH(osb_osoby_sel)

       TYPE(COMBOBOX) NAME(CSTAVZAKAZ)    FPOS(73, 0.3) FLEN( 30)  FCAPTION(Stav zakázky)      CPOS(58, 0.3) CLEN(10)
       TYPE(GET)      NAME(nProcUspRe)    FPOS(73, 1.3) FLEN( 13)  FCAPTION(Proc.úsp./storno)  CPOS(58, 1.3) CLEN(15)
       TYPE(GET)      NAME(dStornoZak)    FPOS(90, 1.3) FLEN( 12)  FCAPTION(/)                 CPOS(88, 1.3) CLEN( 2) PUSH(CLICKDATE)
 
    TYPE(END)
  TYPE(END)

* -2- DODACÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Doplòujíci údaje)  FPOS( 1,8) OFFSET(18,66)  PRE( tabSelect)

      TYPE(TEXT) CAPTION(Vyrábìná položka) CPOS( 4,1)
      TYPE(TEXT) NAME(cVyrPol)             CPOS(20, 1) CLEN(16) BGND(13)
      TYPE(Text) NAME(VYRPOL->cNazev)      CPOS(37, 1) CLEN(30) BGND(13)
      TYPE(GET)  NAME(nVarCis)             FPOS(80, 1) FLEN( 3) FCAPTION(Varianta)            CPOS(71,1)
      TYPE(GET)  NAME(cVyrobCisl)          FPOS(20, 2) FLEN(40) FCAPTION(Výrobní èíslo)       CPOS( 4,2)
      TYPE(GET)  NAME(CCISLOOBJ)           FPOS(20, 3) FLEN(53) FCAPTION(Èíslo objednávky)    CPOS( 4,3) 
      TYPE(GET)  NAME(CKATOZNODB)          FPOS(20, 4) FLEN(15) FCAPTION(Katal oznOdbìratele) CPOS( 4,4)

      TYPE(STATIC) FPOS(0.4,5.4) SIZE(104,.2) STYPE(12) 
      TYPE(End)

      TYPE(GET)  NAME(nVahaPred)        FPOS(20, 6) FLEN( 13) FCAPTION(Hmotnost pøedbìžná) CPOS( 4,6) 
      TYPE(GET)  NAME(cMJVahaP)         FPOS(35, 6) FLEN(  6)
      TYPE(GET)  NAME(nVahaSkut)        FPOS(20, 7) FLEN( 13) FCAPTION(Hmotnost skuteèná)  CPOS( 4,7)
      TYPE(GET)  NAME(cMJVahaS)         FPOS(35, 7) FLEN(  6)


* ns
      TYPE(GET) NAME(cNAZPOL1) FPOS(  3,15.15) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,14.2) CLEN(10) GROUPS(SETFONT,8.Arial CE) 
      TYPE(GET) NAME(cNAZPOL2) FPOS( 21,15.15) FLEN(10) FCAPTION(Výrobek)      CPOS(21,14.2) CLEN( 8) GROUPS(SETFONT,8.Arial CE)
      TYPE(GET) NAME(cNAZPOL3) FPOS( 39,15.15) FLEN(10) FCAPTION(Zakázka)      CPOS(39,14.2) CLEN( 8) GROUPS(SETFONT,8.Arial CE)
      TYPE(GET) NAME(cNAZPOL4) FPOS( 57,15.15) FLEN(10) FCAPTION(VýrMísto)     CPOS(57,14.2) CLEN( 8) GROUPS(SETFONT,8.Arial CE)
      TYPE(GET) NAME(cNAZPOL5) FPOS( 75,15.15) FLEN(10) FCAPTION(Stroj)        CPOS(75,14.2) CLEN( 8) GROUPS(SETFONT,8.Arial CE)
      TYPE(GET) NAME(cNAZPOL6) FPOS( 93,15.15) FLEN(10) FCAPTION(VýrOperace)   CPOS(93,14.2) CLEN(10) GROUPS(SETFONT,8.Arial CE)

      TYPE(STATIC) FPOS(0.4,14.6) SIZE(104,.2) STYPE(12)
      TYPE(End)
  TYPE(END)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,8) OFFSET(82, 2) PRE( tabSelect)
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