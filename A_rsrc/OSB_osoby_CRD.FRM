TYPE(drgForm) DTYPE(10) TITLE(Aktualizace osoby) SIZE(100,20.5) ;
              GUILOOK(Action:n,Border:y) ;
              PRE(preValidate) POST(postValidate) ITEMMARKED(onItemMarked)


  TYPE(Static) STYPE(12) FPOS(0.5,0.3) SIZE(99,4.4)  RESIZE(yn) CTYPE(3)

    TYPE(TEXT) CAPTION(Pøíjmení)         CPOS( 1, .5) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)            CPOS(28, .5) CLEN(15)
    TYPE(TEXT) CAPTION(rozlOsoby)        CPOS(45, .5) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)       CPOS(62, .5) CLEN(10)
    TYPE(TEXT) CAPTION(Titul za)         CPOS(76, .5) CLEN(10)
    TYPE(TEXT) CAPTION(zkrOsoby)         CPOS(90, .5) CLEN(10)

    TYPE(GET) NAME(OSOBYw->CPRIJOSOB)    FPOS( 1,1.5) FLEN(25)
    TYPE(GET) NAME(OSOBYw->CJMENOOSOB)   FPOS(28,1.5) FLEN(15)
    TYPE(GET) NAME(osobyW->crozlJmena)   FPOS(45,1.5) FLEN(15)
    TYPE(GET) NAME(OSOBYw->CTITULPRED)   FPOS(62,1.5) FLEN(12)
    TYPE(GET) NAME(OSOBYw->CTITULZA)     FPOS(76,1.5) FLEN(12)
    TYPE(GET) NAME(OSOBYw->cZkrOsob)     FPOS(90,1.5) FLEN( 6)

* èíslo osoby
    TYPE(Text)  CAPTION([)               CPOS( 1, 3) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(osobyW->ncisOsoby)  CPOS( 3, 3) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
    TYPE(Text)  CAPTION(])               CPOS(11, 3) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

* osbní èíslo pracovníka
    TYPE(TEXT)  CAPTION(OsÈís/Poø)        CPOS(20, 3) CLEN( 8)
    TYPE(GET)   NAME(osobyW->nosCisPrac)  FPOS(28, 3) FLEN( 9) PP(2) FONT(5) CTYPE(2) NOREVISION()
    TYPE(TEXT)  FCAPTION(/)               CPOS(39, 3) CLEN( 2)
    TYPE(TEXT)  NAME(osobyW->nporPraVzt)  CPOS(42, 2.7) CLEN(10) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)
  TYPE(End)


* 1 základní údaje --> osobyW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET( 1,85) CAPTION(Základní údaje) PRE(tabSelect) RESIZE(yy) SUBTABS(A2,A3)

    TYPE(Text) CAPTION(Adresa)             CPOS( 1, 0.8) CLEN(20) FONT(5)
     TYPE(GET)  NAME(OSOBYw->CULICE)        FPOS(15, 2) FLEN(30) FCAPTION(Ulice/è.popisné) CPOS(2,2)
     TYPE(GET)  NAME(OSOBYw->CCISPOPIS)     FPOS(48, 2) FLEN(15)
     TYPE(GET)  NAME(OSOBYw->CMISTO)        FPOS(15, 3) FLEN(30) FCAPTION(Místo)         CPOS(2,3)
     TYPE(GET)  NAME(OSOBYw->CPSC)          FPOS(15, 4) FLEN( 8) FCAPTION(PSÈ)           CPOS(2,4)
     TYPE(TEXT) NAME(C_PSC->CMISTO)         CPOS(25, 4) CLEN(21) BGND(13)
     TYPE(GET)  NAME(OSOBYw->CZKRATSTAT)    FPOS(15, 5) FLEN( 8) FCAPTION(Stát)          CPOS(2,5)
     TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT)   CPOS(25, 5) CLEN(21) BGND(13)
 
* 2 pracovní zaøazení --> osobyW
    TYPE(TabPage) FPOS(1.5,7.5) SIZE(96.5,7.7)  TTYPE(3) OFFSET( 1,82) CAPTION(Pracovní zaøazení) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A2)
      TYPE(GET)  NAME(OSOBYw->cpracZar)        FPOS(15,  .5)  FLEN(10) FCAPTION(pracZaøazení)   CPOS( 2, .5)
      TYPE(TEXT) NAME(c_pracZa->cnazPRACza)    CPOS(27,  .5)  CLEN(30) BGND(13) PP(3)

      TYPE(GET)  NAME(OSOBYw->cfunPra)         FPOS(15, 1.5)  FLEN(10) FCAPTION(funkcePrac)     CPOS( 2, 1.5)
      TYPE(TEXT) NAME(c_funcPr->cnazFUNCpr)    CPOS(27, 1.5)  CLEN(30) BGND(13) PP(3)

      TYPE(GET)  NAME(OSOBYw->corgUsek)        FPOS(15, 2.5)  FLEN(10) FCAPTION(orgÚsek)        CPOS( 2, 2.5)          
      TYPE(TEXT) NAME(c_ORGUSEK ->cNazev)      CPOS(27, 2.5)  CLEN(30) BGND(13) PP(3)

      TYPE(GET)  NAME(OSOBYw->ckmenSTRpr)      FPOS(15, 3.5)  FLEN(10) FCAPTION(kmen_Støedisko) CPOS( 2, 3.5)
      TYPE(TEXT) NAME(cnazPol1->cnazev)        CPOS(27, 3.5)  CLEN(30) BGND(13) PP(3)

      TYPE(GET)  NAME(OSOBYw->cnazPol4)        FPOS(15, 4.5)  FLEN(10) FCAPTION(pracovištì)     CPOS( 2, 4.5)
      TYPE(TEXT) NAME(cnazPol4->cnazev)        CPOS(27, 4.5)  CLEN(30) BGND(13) PP(3)
 
      TYPE(GET)  NAME(OSOBYw->cnazPol1)        FPOS(15, 5.5)  FLEN(10) FCAPTION(nákl_Støedisko) CPOS( 2, 5.5)
      TYPE(TEXT) NAME(cnazPol1ns->cnazev)      CPOS(27, 5.5)  CLEN(30) BGND(13) PP(3)
    TYPE(End)

* 3 docházka -- osobyW
    TYPE(TabPage) FPOS(1.5,7.5) SIZE(96.5,7.7) TTYPE(3) OFFSET( 18,64) CAPTION(Docházka) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A3)
      TYPE(GET)  NAME(osobyW->cIdOsKarty)       FPOS(15,  .5)  FLEN(29) FCAPTION(identÈís_osKarty)  CPOS( 2,  .5)  CLEN(13)

      TYPE(GET)  NAME(osobyW->ctypPraKal)       FPOS(15, 1.5)  FLEN(20) FCAPTION(pracovní kalenáø)  CPOS( 2, 1.5)  CLEN(13)
      TYPE(TEXT) NAME(C_PRACKA->cnazPraKal)     CPOS(37, 1.5)  CLEN(50) BGND(13) PP(3)

      TYPE(GET)  NAME(osobyW->cdelkPrDob)       FPOS(15, 2.5)  FLEN(20) FCAPTION(pracovní doba )    CPOS( 2, 2.5)  CLEN(13)
      TYPE(TEXT) NAME(C_PRACDO->cnazDelPrD)     CPOS(37, 2.5)  CLEN(50) BGND(13) PP(3)

      TYPE(GET)  NAME(osobyW->ctypSmeny)        FPOS(15, 3.5)  FLEN(20) FCAPTION(pracovní smìny)    CPOS( 2, 3.5)  CLEN(13)
      TYPE(TEXT) NAME(C_PRACSM->cnazSmeny)      CPOS(37, 3.5)  CLEN(50) BGND(13) PP(3)

      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

  TYPE(End)

* 4 spojení        --> spojeni -> vazSpojeW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(14,72) CAPTION(Spojení) PRE(tabSelect)  RESIZE(yy)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(50,14) FILE(vazSpojeW) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) GROUPS(2) RESIZE(yy)

     TYPE(GET)      NAME(vazSpojew->nItem)        FLEN(4)  FCAPTION(Poø)
     TYPE(CHECKBOX) NAME(vazSpojew->lHlavVazba)   FLEN(3)  VALUES(T:,F:)     CAPTION(hl)
     TYPE(GET)      NAME(vazSpojeW->ncisSpoj)     FLEN(10) FCAPTION(ÈísSpoj) PUSH(selSpoj)
*
     TYPE(TEXT)     NAME(vazSpojeW->czkrspoj)     CLEN(9)  CAPTION(Zkratka)
     TYPE(TEXT)     NAME(vazSpojeW->cnazspoj)     CLEN(9)  CAPTION(Název)
     TYPE(TEXT)     NAME(vazSpojeW->cadrelspoj)   CLEN(25) CAPTION(Adresa-èíslo)
     TYPE(TEXT)     NAME(vazSpojeW->mUsrElSpoj)   CLEN(20) CAPTION(Elektronické pøihlášení) SCROLL(nn) PP(2)
     TYPE(TEXT)     NAME(vazSpojeW->mAdrPoSpoj)   CLEN(20) CAPTION(Poštovní adresa)         SCROLL(nn) PP(2)
    TYPE(End)

    TYPE(Static) STYPE(2) SIZE(46.7,13.6) FPOS(51.2,0.1) RESIZE(nn)

      TYPE(TEXT) CAPTION(Èíslo spojení)              CPOS( 1, 0.5)
        TYPE(TEXT) NAME(spojeni->ncisSpoj)           CPOS(18, 0.5) CLEN( 12) BGND(13) PP(2) CTYPE(2)
        TYPE(PushButton)                             POS( 30,  .4) ;
                                                     SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                     CAPTION(4)

      TYPE(TEXT)  CAPTION(Zkratka spojení)          CPOS( 1, 1.6)
        TYPE(TEXT) NAME(spojeni->czkrSpoj)         CPOS(18, 1.6) CLEN( 12) BGND(13) PP(2)
        TYPE(TEXT) NAME(c_spojen->cnazSpoj)         CPOS(30, 1.6) CLEN( 16)  

      TYPE(TEXT)  CAPTION(Název spojení)            CPOS( 1, 2.7) 
        TYPE(TEXT) NAME(spojeni->cnazSpoj)         CPOS(18, 2.7) CLEN( 28) BGND(13)

* mìní se CAPTION podle c_typSpoj->cnazTyp
*                       Elektronické spojení

      TYPE(TEXT) NAME(M->caption_adrElSpoj)          CPOS( 1, 3.8) CLEN( 17) GROUPS(SETFONT,9.Arial CE)  
        TYPE(TEXT) NAME(spojeni->cadrElSpoj)       CPOS(18, 3.8) CLEN( 28) BGND(13) 

      TYPE(TEXT)  CAPTION(Elektronické pøihlášení)  CPOS( 1, 4.9) CLEN(17)
        TYPE(TEXT) NAME(spojeni->mUsrElSpoj)       CPOS(18, 4.9) CLEN( 28) BGND(13)


* 1 - základní údaje pro SPOJENÍ
      TYPE(Static) FPOS(0.5,7.0) SIZE(45.6,6.0) CAPTION(Základní údaje) RESIZE(xx)
        TYPE(Text) CAPTION(Poštovní adresa)       CPOS( 1, 0.8) CLEN(20) FONT(5)

        TYPE(TEXT)   CAPTION(Ulice/è.popisné)     CPOS( 2, 2) CLEN(12)
          TYPE(TEXT) NAME(spojeni->culice)        CPOS(15, 2) CLEN(30) BGND(13) 
*          TYPE(TEXT) NAME(spojeni->ccisPopis)     CPOS(48, 2) CLEN(15) BGND(13)

        TYPE(TEXT)   CAPTION(Místo)               CPOS(2,3)
          TYPE(TEXT) NAME(spojeni->cmisto)        CPOS(15, 3) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 4) CLEN(12)
          TYPE(TEXT) NAME(spojeni->cpsc)          CPOS(15, 4) FLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)        CPOS(25, 4) CLEN(20) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 5) 
          TYPE(TEXT) NAME(spojeni->czkratStat)    CPOS(15, 5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)  CPOS(25, 5) CLEN(20) BGND(13)
      TYPE(End)
*
*     TYPE(MLE) NAME('ukoly->mpopisUkol') FPOS( .5,16) SIZE(53,3.5) RESIZE(yx) SCROLL(ny)
    TYPE(End)
  TYPE(END)


* 5 firmy          --> firmy -> vazFirmyW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(27,59) CAPTION(Firmy) PRE(tabSelect)  RESIZE(yy)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(50,14) FILE(vazFirmyW) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) GROUPS(3)

     TYPE(GET)   NAME(vazFirmyw->nItem)       FLEN(4)   FCAPTION(Poø)
     TYPE(GET)   NAME(vazFirmyW->ncisfirmy)   FLEN(5)   FCAPTION(ÈísFirmy) PUSH(selFirma)
     TYPE(TEXT)  NAME(vazFirmyW->cnazev)      CLEN(25)  CAPTION(Název)
     TYPE(GET)   NAME(vazFirmyW->cfunpra)     FLEN(10)  FCAPTION(FunkcePrac)
     TYPE(TEXT)  NAME(c_funcpr->cnazfuncpr)   CLEN(25)  CAPTION(NazevFunkce)
    TYPE(End)

    TYPE(Static) STYPE(2) SIZE(46.7,13.6) FPOS(51.2,0.1) RESIZE(nn) 
* P
      TYPE(Text) CAPTION(Èíslo firmy)    CPOS( 5,  .3) CLEN(10)  
      TYPE(Text) NAME(firmy->NCISFIRMY)  CPOS( 5, 1.3) CLEN(10) BGND(13) PP(2)
      TYPE(PushButton)                   POS( 15, 1.2) ;
                                         SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                         CAPTION(5)

      TYPE(Text) CAPTION(Název firmy)    CPOS(18,  .3) 
      TYPE(Text) NAME(firmy->CNAZEV)     CPOS(18, 1.3) CLEN(25) BGND(13) PP(2)     
      TYPE(Text) CAPTION([)              CPOS( 5, 2.3) CLEN( 2) 
      TYPE(Text) NAME(firmy->ccinnost)   CPOS( 7, 2.3) CLEN(35) FONT(5) CTYPE(1)
*      TYPE(Text) NAME(firmy->CZASTUPCE) CPOS( 7, 2.1) CLEN(35) FONT(5) CTYPE(1)
      TYPE(Text) CAPTION(])              CPOS(43, 2.3) CLEN( 2) 

      TYPE(Text) CAPTION(Sídlo firmy)   CPOS(50,  .1)   
      TYPE(Text) NAME(firmy->CULICE)    CPOS(50, 1.1) CLEN(38) BGND(13) PP(2)
      TYPE(Text) NAME(firmy->cPSC)      CPOS(50, 2.1) CLEN(10) BGND(13) PP(2)
      TYPE(Text) NAME(firmy->cSIDLO)    CPOS(63, 2.1) CLEN(25) BGND(13) PP(2)      

      TYPE(Static) STYPE(16) SIZE(46.5,1) FPOS(0,2.5) RESIZE(y)

      TYPE(Text) CAPTION(ObchZástupce)   CPOS( 5, 3.7)   
      TYPE(Text) NAME(firmy->CZASTOBCH)  CPOS(18, 3.7) CLEN(25) BGND(13) PP(2)
      TYPE(Text) CAPTION(Telefon)        CPOS( 5, 4.7)   
      TYPE(Text) NAME(firmy->CTELEFON)   CPOS(18, 4.7) CLEN(25) BGND(13) PP(2)
      TYPE(Text) NAME(firmy->CTELEFON2)  CPOS(18, 4.7) CLEN(25) BGND(13) PP(2)
      TYPE(Text) CAPTION(Èíslo_Faxu)     CPOS( 5, 5.7)   
      TYPE(Text) NAME(firmy->CFAX)       CPOS(18, 5.7) CLEN(25) BGND(13) PP(2)
      TYPE(Text) CAPTION(Mobil)          CPOS( 5, 6.7)   
      TYPE(Text) NAME(firmy->CMOBILTEL)  CPOS(18, 6.7) CLEN(25) BGND(13) PP(2)

* 1 - základní údaje pro SPOJENÍ
      TYPE(Static) FPOS(0.5,7.7) SIZE(45.6,5.5) CAPTION(Sídlo firmy) RESIZE(xx)

        TYPE(TEXT)   CAPTION(Ulice/è.popisné)     CPOS( 2, 1.5) CLEN(12)
          TYPE(TEXT) NAME(firmy->culice)          CPOS(15, 1.5) CLEN(30) BGND(13) 
*          TYPE(TEXT) NAME(spojeni->ccisPopis)    CPOS(48, 1.5) CLEN(15) BGND(13)

        TYPE(TEXT)   CAPTION(Místo)               CPOS( 2, 2.5)
          TYPE(TEXT) NAME(firmy->csidlo)          CPOS(15, 2.5) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 3.5) CLEN(12)
          TYPE(TEXT) NAME(firmy->cpsc)            CPOS(15, 3.5) FLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_PSC_3->CMISTO)          CPOS(25, 3.5) CLEN(20) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 4.5) 
          TYPE(TEXT) NAME(firmy->czkratStat)      CPOS(15, 4.5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_3->cNAZEVSTAT)    CPOS(25, 4.5) CLEN(20) BGND(13)

      TYPE(END)
    TYPE(END)
  TYPE(End)


* 6 úkoly          --> ukoly -> vazUkolyW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(40,46) CAPTION(Úkoly) PRE(tabSelect)  RESIZE(yy)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(50,14) FILE(vazUkolyW)  CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) GROUPS(4)

     TYPE(GET)   NAME(vazUkolyW->nItem)        FLEN( 4)  FCAPTION(Poø)
     TYPE(GET)   NAME(vazUkolyW->ncisUkolu)    FLEN(10)  FCAPTION(ÈísÚkolu) PUSH(selUkol)
     TYPE(TEXT)  NAME(vazUkolyW->czkrUkolu)    CLEN(10)  CAPTION(Zkratka)
     TYPE(TEXT)  NAME(vazUkolyW->cnazUkolu)    CLEN(25)  CAPTION(Název)
    TYPE(End)

  
    TYPE(Static) STYPE(2) SIZE(46.7,13.6) FPOS(51.2,0.1) RESIZE(nn)

      TYPE(TEXT)   CAPTION(Èíslo úkolu)        CPOS( 1, 0.7)
        TYPE(TEXT) NAME(ukoly->ncisUkolu)      CPOS(14, 0.7) CLEN( 12) BGND(13) PP(2) CTYPE(2)
        TYPE(PushButton)                       POS( 26, 0.6) ;
                                               SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                               CAPTION(6)

      TYPE(TEXT)   CAPTION(Zkratka úkolu)      CPOS( 1, 1.7) 
        TYPE(TEXT) NAME(ukoly->czkrUkolu)      CPOS(14, 1.7) CLEN( 12) BGND(13)
        TYPE(TEXT) NAME(c_ukoly->cnazUkolu)    CPOS(26, 1.7) 

      TYPE(TEXT)   CAPTION(Název úkolu)        CPOS( 1, 2.7)
        TYPE(TEXT) NAME(ukoly->cnazUkolu)      CPOS(14, 2.7) CLEN( 32) BGND(13)

      TYPE(TEXT)   CAPTION(Stav øešení)        CPOS( 1, 3.7) 
        TYPE(TEXT) NAME(ukoly->czkrStaRes)     CPOS(14, 3.7) CLEN( 12) BGND(13)

      TYPE(TEXT)   CAPTION(Plánováno_od)       CPOS( 1, 4.7)
        TYPE(TEXT) NAME(ukoly->dplzacUkol)     CPOS(14, 4.7) CLEN( 12) BGND(13)

      TYPE(TEXT)   CAPTION(do)                 CPOS(30, 4.7) CLEN(  3)
        TYPE(TEXT) NAME(ukoly->dplkonUkol)     CPOS(34, 4.7) CLEN( 12) BGND(13)

      TYPE(TEXT)   CAPTION(Zahájeno_od)        CPOS( 1, 5.7) 
        TYPE(TEXT) NAME(ukoly->dzacUkolu)      CPOS(14, 5.7) CLEN( 12) BGND(13)

      TYPE(TEXT)   CAPTION(do)                 CPOS(30, 5.7) CLEN(  3)
        TYPE(TEXT) NAME(ukoly->dkonUkolu)      CPOS(34, 5.7) CLEN( 12) BGND(13)
*
       TYPE(MLE) NAME('ukoly->mpopisUkol') FPOS( 1,7.7) SIZE(44,5.5) RESIZE(nn) SCROLL(nn) READONLY(y)
    TYPE(End)
  TYPE(End)


* 7 dokumenty      --> dokument -> vazDokumW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(53,33) CAPTION(Dokumenty) PRE(tabSelect)  RESIZE(yy)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(50,14) FILE(vazDokumW)  CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) GROUPS(5) RESIZE(yy)

     TYPE(GET)   NAME(vazDokumw->nItem)          FLEN(4)   FCAPTION(Poø) 
     TYPE(GET)   NAME(vazDokumW->cIDdokum)       FLEN(5)   FCAPTION(OznDokum) PUSH(selDok)
     TYPE(TEXT)  NAME(vazDokumW->czkrdokum)      CLEN(10)  CAPTION(Zkratka)
     TYPE(TEXT)  NAME(vazDokumW->cnazdokum)      CLEN(50)  CAPTION(Název dokumentu)
    TYPE(End)

    TYPE(Static) STYPE(2) FPOS(51.2,0.01) SIZE(46.7,13.6)  RESIZE(nn)

      TYPE(TEXT)   CAPTION(Typ dokumentu     __)         CPOS( 1, 0.7) CLEN( 17)
        TYPE(TEXT) NAME(dokument->cID)                   CPOS(18, 0.7) CLEN( 21) BGND(13)
        TYPE(PushButton)                                 POS( 39, 0.2) ;
                                                         SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                         CAPTION(7)

      TYPE(TEXT)   CAPTION(identifikace            __)   CPOS( 1, 1.7) CLEN(17)
        TYPE(TEXT) NAME(dokument->cIDdokum)              CPOS(18, 1.7) CLEN( 21) BGND(13) 

      TYPE(TEXT)   CAPTION(Úloha                     __) CPOS( 1, 3.3) CLEN( 17) 
        TYPE(TEXT) NAME(dokument->cTASK)                 CPOS(18, 3.3) CLEN( 21) BGND(13)

      TYPE(TEXT)   CAPTION(Typ dokumentu      __)        CPOS( 1, 4.3) CLEN( 17)
        TYPE(TEXT) NAME(dokument->czkrDokum)             CPOS(18, 4.3) CLEN( 21) BGND(13)

      TYPE(TEXT)   CAPTION(Název dokumentu  __)          CPOS( 1, 5.3) CLEN( 17)
        TYPE(TEXT) NAME(dokument->cnazDokum)             CPOS(18, 5.3) CLEN( 28) BGND(13)

      TYPE(TEXT)   CAPTION(Typ editoru            __)    CPOS( 1, 6.3) CLEN( 17) 
        TYPE(TEXT) NAME(dokument->ctypEdit)              CPOS(18, 6.3) CLEN( 21) BGND(13)

      TYPE(TEXT)   CAPTION(Umístìní souboru)             CPOS( 1, 8.3) FONT( 2)
        TYPE(TEXT) NAME(dokument->csoubor)               CPOS( 1, 9.8) CLEN( 45) BGND(13) 

    TYPE(END)
  TYPE(End)


* 8 skupiny        --> osobySkW - osobyVaW
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(66,20) CAPTION(Skupiny) PRE(tabSelect)  RESIZE(yy)
    TYPE(DBrowse) FPOS(.5,1.4) SIZE(50,13.8) FILE(osobySKw) RESIZE(yy)               ;
                                             FIELDS(M->setSkup:_:2.6::2            , ;
                                                    czkr_skup:skup:5               , ;
                                                    M->cnaz_Skup:název skupiny:41 ) ;
                                             CURSORMODE(3) PP(7) SCROLL(nn) GROUPS(6)


    TYPE(MLE)  NAME(osobySkW->mPOZNAMKA) FPOS(53.5,1.3) SIZE(44,12.8) FONT(5) SCROLL(nn) PP(3) RESIZE(ny)

    TYPE(Static) STYPE(12) FPOS(0.5,0.05) SIZE(49.7,1.0)  RESIZE(yn)
      TYPE(TEXT) CAPTION(skupiny) CPOS( .5, .01) CLEN(50.0) FONT(5) GROUPS(TEXT-6)
    TYPE(End)

    TYPE(Static) STYPE(12) FPOS(53.5,0.05) SIZE(43.5,1.0)  RESIZE(nn)
      TYPE(TEXT) CAPTION(informace o zaøazení/vyøazení ze skupiny) CPOS( .5, .01) CLEN(48.0) FONT(5) BGND(12) GROUPS(TEXT-6)     
    TYPE(End)

  TYPE(END)

* 9 poznámka       --> osobyW 
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) OFFSET(79, 7) CAPTION(Poznámka) PRE(tabSelect)   RESIZE(yy)
    TYPE(MLE) NAME(OSOBYw->mPOZNAMKA) FPOS(.5,0.15) SIZE(97,13.8) FONT(5) SCROLL(nn) PP(3) RESIZE(yy)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

