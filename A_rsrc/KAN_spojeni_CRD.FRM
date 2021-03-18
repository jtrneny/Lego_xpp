TYPE(drgForm) DTYPE(10) TITLE(Spojení...) SIZE(80,14) FILE(SPOJENIW) ;
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n)           ;
              POST(postValidate)

  TYPE(Static) STYPE(13) SIZE(78,13.5) FPOS(1,0.1) RESIZE(yn)

    TYPE(TEXT) CAPTION(Èíslo spojení)   CPOS( 1, 0.3)
    TYPE(TEXT) NAME(ncisSpoj)           CPOS(18, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

    TYPE(GET)  NAME(czkrSpoj)           FPOS(18, 1.3) FLEN( 12) FCAPTION(Zkratka spojení)         CPOS( 1, 1.3) NOREVISION()
    TYPE(TEXT) NAME(c_spojen->cnazSpoj) CPOS(32, 1.3)  

    TYPE(GET)  NAME(cnazSpoj)           FPOS(18, 2.3) FLEN( 50) FCAPTION(Název spojení)           CPOS( 1, 2.3)

* mìní se CAPTION podle c_typSpoj->cnazTyp
*                       Elektronické spojení

    TYPE(TEXT) NAME(M->caption_adrElSpoj) CPOS( 1, 3.3) CLEN( 17) GROUPS(SETFONT,9.Arial CE) 
    TYPE(GET)  NAME(cadrElSpoj)           FPOS(18, 3.3) FLEN( 50)                                                 GROUPS(NO_ADR)

    TYPE(GET)  NAME(mUsrElSpoj)           FPOS(18, 4.3) FLEN( 50) FCAPTION(Elektronické pøihlášení) CPOS( 1, 4.3) GROUPS(NO_ADR)
*    TYPE(GET)  NAME(madrPoSpoj)           FPOS(18, 5.3) FLEN( 50) FCAPTION(Poštovní adresa)         CPOS( 1, 5.3)


* 1 - základní údaje pro SPOJENÍ
   TYPE(Static) FPOS(0.5,6.8) SIZE(77,5.9) CAPTION(Základní údaje)
     TYPE(Text) CAPTION(Poštovní adresa)            CPOS( 1, 0.8) CLEN(20) FONT(5)
     TYPE(GET)  NAME(culice)               FPOS(15, 2) FLEN(30) FCAPTION(Ulice/è.popisné)   CPOS(2,2) GROUPS(ADR)
     TYPE(GET)  NAME(ccisPopis)            FPOS(48, 2) FLEN(15)                                       GROUPS(ADR)
     TYPE(GET)  NAME(cmisto)               FPOS(15, 3) FLEN(30) FCAPTION(Místo)             CPOS(2,3) GROUPS(ADR)
     TYPE(GET)  NAME(cpsc)                 FPOS(15, 4) FLEN( 8) FCAPTION(PSÈ)               CPOS(2,4) GROUPS(ADR)
     TYPE(TEXT) NAME(C_PSC->CMISTO)        CPOS(25,4) CLEN(21) BGND(13)
     TYPE(GET)  NAME(czkratStat)           FPOS(15, 5) FLEN( 8) FCAPTION(Stát)              CPOS(2,5) GROUPS(ADR)
     TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT)  CPOS(25,5) CLEN(21) BGND(13)
   TYPE(End)
*
*    TYPE(MLE) NAME('ukoly->mpopisUkol') FPOS( .5,16) SIZE(53,3.5) RESIZE(yx) SCROLL(ny)
  TYPE(End)