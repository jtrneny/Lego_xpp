TYPE(drgForm) DTYPE(10) TITLE(Pøipomínka...) SIZE(110,27) FILE(ASYSPRHDw) POST(postValidate)

* TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
* TYPE(ComboBox) NAME(EXPLSTHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()


TYPE(Static) FPOS(1,0.3) SIZE(108,7.6) STYPE(8) RESIZE(y) CTYPE(3) GROUPS(HEAD)
  TYPE(TEXT) CAPTION(ID pøipomínky ) CPOS( 1,0.4) CLEN(12)
  TYPE(TEXT)  NAME(ASYSPRHDw->nIDpripom)  CPOS(13,0.4) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(-) CPOS( 28,0.4) CLEN(2)
  TYPE(TEXT)  NAME(ASYSPRHDw->cIDpripom)  CPOS(30,0.4) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(z ) CPOS( 46,0.4) CLEN(2)
  TYPE(TEXT)  NAME(ASYSPRHDw->dVznikZazn)  CPOS(49,0.4) CLEN(10) BGND(13)
  TYPE(TEXT) CAPTION(UzivDB ) CPOS( 61,0.4) CLEN(7)
  TYPE(Get)  NAME(ASYSPRHDw->NIDUZIVSW)  FPOS(69,0.4) FLEN(7)
   TYPE(TEXT)  NAME(ASYSPRHDw->cnazfirmy)  CPOS(78,0.4) CLEN(29) BGND(13)

*   FCAPTION(Typ pøipomínky ) CPOS( 1,1.6) CLEN(12)
*
  TYPE(Get)  NAME(ASYSPRHDw->cTypPripom)  FPOS(13,1.6) FLEN(14) FCAPTION(Typ pøipomínky ) CPOS( 1,1.6) CLEN(12)
  TYPE(TEXT)  NAME(C_PRIPOM->cNazPripom)  CPOS(29,1.6) CLEN(30)
  TYPE(Get)  NAME(ASYSPRHDw->cTask)       FPOS(13,2.7) FLEN(14) FCAPTION(Úloha )          CPOS( 1,2.7) CLEN(12)
  TYPE(TEXT)  NAME(C_TASK->cNazUlohy)     CPOS(29,2.7) CLEN(30)
  TYPE(Get)  NAME(ASYSPRHDw->cVerze)      FPOS(13,3.8) FLEN(14) FCAPTION(Verze exe )      CPOS(1,3.8) CLEN(12) PUSH(sys_verze_sel)
  TYPE(Get)  NAME(ASYSPRHDw->cVerzeDB)    FPOS(13,4.9) FLEN(14) FCAPTION(Verze db  )      CPOS(1,4.9) CLEN(12) PUSH(sys_verze_sel)
*
  TYPE(ComboBox) NAME(ASYSPRHDw->nRecFiltrs) FPOS(69,1.6) FLEN(38)   ;
                 VALUES(0:bez omezení,           ;
                        1:veøejné záznamy,       ;
                        2:uživatelské záznamy,   ;
                        3:interní záznamy,       ;
                        4:distribuèní záznamy)   ;
                 FCAPTION(Pøístup) CPOS(61,1.6) CLEN(7)
  TYPE(ComboBox) NAME(ASYSPRHDw->nPriPripom) FPOS(69,2.7) FLEN(38)   ;
                 VALUES(0:nízká,            ;
                        1:støední,          ;
                        2:vysoká,           ;
                        3:velmi vysoká)     ;
                 FCAPTION(Priorita) CPOS(61,2.7) CLEN(7)
  TYPE(ComboBox) NAME(ASYSPRHDw->nStaKomuni) FPOS(69,3.8) FLEN(38)   ;
                 VALUES(0:žádná,                               ;
                        1:proveden export -èeká se odpovìï,    ;
                        2:proveden import -došla odpovìï,      ;
                        3:èeká na export,                      ;
                        90:komunikace zakázána)                ;
                 FCAPTION(Komunik) CPOS(61,3.8) CLEN(7)

  TYPE(Get) NAME(ASYSPRHDw->nStaPripom) FPOS(69,4.9) FLEN(7)   ;
                                                     FCAPTION(Stav)     CPOS(61,4.9) CLEN(7) PUSH(c_stapri_sel)
  TYPE(TEXT)  NAME(C_STAPRI->cNazStaPri)  CPOS(78,4.9) CLEN(27)

*TYPE(STATIC) FPOS(1,4.5) SIZE(108,2.3) STYPE(8) GROUPS(HEAD)
   TYPE(Get)  NAME(ASYSPRHDw->cPripomink)  FPOS(13,6.2) FLEN(93) FCAPTION(Zkrácený popis ) CPOS( 1,6.3) CLEN(12)
TYPE(END)



* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0.7,8.1) SIZE(108,18.4) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) EXT() SUBTABS(A2,A3,A4,A5,A6) PRE(tabSelect)
  TYPE(TabPage) SIZE(106.2,16.4) FPOS(0.7,1.5) CAPTION(Pøipomínka)   OFFSET( 0,85) PRE(tabSelect) SUB(A2)
    TYPE(Text) CAPTION(Pøipomínku zapsal ) CPOS(  1,0.5) CLEN(15)
    TYPE(Text)  NAME(ASYSPRHDw->cUser)   CPOS(17,0.5) CLEN(13)   BGND(13)
      TYPE(Text) NAME(ASYSPRHDw->cOsoba)  CPOS(33,0.5) CLEN(60)  BGND(13)
    TYPE(Get)  NAME(ASYSPRHDw->dZacPripom)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dKonPripom)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dPozVyjadr)  FPOS(17,2.7) FLEN(12) FCAPTION(Vyjádøení do)       CPOS(  1,2.7) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dPozReseni)  FPOS(48,2.7) FLEN(12) FCAPTION(Øešení do)          CPOS( 33,2.7) CLEN(12) PUSH(CLICKDATE)
    TYPE(Mle)  NAME(ASYSPRHDw->mPripomink)  FPOS( 1,4.7) FLEN(93) FCAPTION(Popis pøipomínky )  CPOS(  1,3.8) SIZE(104,10.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,16.4) FPOS(0.7,1.5) CAPTION(Vyjádøení)    OFFSET(15,70) PRE(tabSelect) SUB(A3)
    TYPE(Get)  NAME(ASYSPRHDw->cUsrVyjadr)   FPOS(17,0.5) FLEN(12) FCAPTION(Vyjádøení zapsal) CPOS(  1,0.5) CLEN(15)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRHDw->cOsoVyjadr)  CPOS(33,0.5) CLEN(57)  BGND(13)
*    TYPE(Get)  NAME(ASYSPRHDw->cUsrVyjadr)  FPOS(17,0.5) FLEN(65) FCAPTION(Vyjádøení zapsal)   CPOS(  1,0.5) CLEN(15) PUSH(osb_osoby_sel)
    TYPE(Get)  NAME(ASYSPRHDw->dZacVyjadr)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dKonVyjadr)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Text) CAPTION(Vyjádøení do)        CPOS(  1,2.7) CLEN(15)
    TYPE(Text) NAME(ASYSPRHDw->dPozVyjadr)  CPOS(17,2.7) CLEN(13)  BGND(13)
    TYPE(Mle)  NAME(ASYSPRHDw->mVyjadreni)  FPOS( 1,4.7) FLEN(93) FCAPTION(Popis vyjádøení)    CPOS(  1,3.8) SIZE(104,10.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,16.4) FPOS(0.7,1.5) CAPTION(Øešení)       OFFSET(30,55) PRE(tabSelect) SUB(A4)
    TYPE(Get)  NAME(ASYSPRHDw->cUsrReseni)   FPOS(13,0.5) FLEN(12) FCAPTION(Øešitel) CPOS(  1,0.5) CLEN(10)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRHDw->cOsoReseni)  CPOS(28,0.5) CLEN(77)  BGND(13)
*    TYPE(Get)  NAME(ASYSPRHDw->cUsrReseni)  FPOS(17,0.5) FLEN(65) FCAPTION(Øešení zapsal)      CPOS(  1,0.5) CLEN(10) PUSH(osb_osoby_sel)
    TYPE(Get)  NAME(ASYSPRHDw->dPriReseni)  FPOS(13,1.6) FLEN(12)  FCAPTION(Pøiøazeno)          CPOS(  1,1.6) CLEN(10) PUSH(CLICKDATE)
    TYPE(Text) CAPTION(Vyøešit do)           CPOS( 1,2.7) CLEN(10)
    TYPE(Text) NAME(ASYSPRHDw->dPozReseni)  CPOS(13,2.7) CLEN(13) BGND(13)
    TYPE(Get)  NAME(ASYSPRHDw->dZacReseni)  FPOS(38,1.6) FLEN(12) FCAPTION(Øešení od)          CPOS( 28,1.6) CLEN(8) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dKonReseni)  FPOS(38,2.7) FLEN(12) FCAPTION(Øešení do)          CPOS( 28,2.7) CLEN(8) PUSH(CLICKDATE)

    TYPE(Get)  NAME(ASYSPRHDw->dPozTest)    FPOS(63,1.6) FLEN(12) FCAPTION(Test do)            CPOS( 54,1.6) CLEN(9) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->cVerReseni)  FPOS(90,1.6) FLEN(14) FCAPTION(Verze EXE)          CPOS( 80,1.6) CLEN(10) PUSH(sys_verze_sel)
    TYPE(Get)  NAME(ASYSPRHDw->cVerResDB)   FPOS(90,2.7) FLEN(14) FCAPTION(Verze DB)           CPOS( 80,2.7) CLEN(10) PUSH(sys_verze_sel)
    TYPE(Mle)  NAME(ASYSPRHDw->mReseni)     FPOS( 1,4.7) FLEN(93) FCAPTION(Popis øešení)       CPOS(  1,3.8) SIZE(104,10.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,16.4) FPOS(0.7,1.5) CAPTION(Test)         OFFSET(45,40) PRE(tabSelect) SUB(A5)
    TYPE(Get)  NAME(ASYSPRHDw->cUsrTest)   FPOS(17,0.5) FLEN(12) FCAPTION(Test zapsal) CPOS(  1,0.5) CLEN(15)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRHDw->cOsoTest)  CPOS(33,0.5) CLEN(57)  BGND(13)
*    TYPE(Get)  NAME(ASYSPRHDw->cUsrTest)    FPOS(17,0.5) FLEN(65) FCAPTION(Test zapsal)        CPOS(  1,0.5) CLEN(15) PUSH(osb_osoby_sel)
    TYPE(Get)  NAME(ASYSPRHDw->dZacTest)    FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
s    TYPE(Get)  NAME(ASYSPRHDw->dKonTest)    FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->cVerTest)    FPOS(77,1.6) FLEN(12) FCAPTION(Verze)              CPOS( 63,1.6) CLEN(12) PUSH(sys_verze_sel)
    TYPE(Text) CAPTION(Testování do)        CPOS( 1,2.7) CLEN(15)
    TYPE(Text) NAME(ASYSPRHDw->dPozTest)    CPOS(17,2.7) CLEN(13) BGND(13)
    TYPE(Mle)  NAME(ASYSPRHDw->mTest)       FPOS( 1,4.7) FLEN(93) FCAPTION(Popis testu)        CPOS(  1,3.8) SIZE(104,10.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,16.4) FPOS(0.7,1.5) CAPTION(Pøílohy)      OFFSET(60,25) PRE(tabSelect) SUB(A6)
    TYPE(EBrowse) FPOS(0.5,0.2) SIZE(104.7,14.7) FILE(dokumentw)                ;
                            CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)
      TYPE(GET)  NAME(dokumentw->cIDdokum)    FLEN(10) FCAPTION(IDdokumentu)
      TYPE(GET)  NAME(dokumentw->cZkrDokum)   FLEN(10) FCAPTION(zkratka)
      TYPE(GET)  NAME(dokumentw->cNazDokum)   FLEN(10) FCAPTION(název)
      TYPE(GET)  NAME(dokumentw->cSoubor)     FLEN(10) FCAPTION(soubor)
      TYPE(MLE)  NAME(dokumentw->mAdresar)    FLEN(50) FCAPTION(adresáø) SCROLL(nn)
    TYPE(End)
  TYPE(End)

TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0.7,8.1) SIZE(108,18.4) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) EXT() SUBTABS(A8,A9,A0,A10,A11) PRE(tabSelect)
*  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,20.7) CTYPE(3) PP(2)
    TYPE(DBrowse) FPOS(0.7,10.1) SIZE(106,6.9) FILE(ASYSPRITw)                   ;
                                              FIELDS(norditem                 , ;
                                                     dZacPripom               , ;
                                                     dKonPripom               , ;
                                                     cPripomink               , ;
                                                     mPripomink               ) ;
                                              CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)

  TYPE(TabPage) SIZE(106.2,9.4) FPOS(0.7,1.5) CAPTION(Pøipomínka)   OFFSET( 0,85) PRE(tabSelect) SUB(A8)
    TYPE(Text) CAPTION(Pøipomínku zapsal ) CPOS(  1,0.5) CLEN(15)
    TYPE(Text)  NAME(ASYSPRITw->cUser)   CPOS(17,0.5) CLEN(13)   BGND(13)
      TYPE(Text) NAME(ASYSPRITw->cOsoba)  CPOS(33,0.5) CLEN(60)  BGND(13)
    TYPE(Get)  NAME(ASYSPRITw->dZacPripom)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dKonPripom)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dPozVyjadr)  FPOS(17,2.7) FLEN(12) FCAPTION(Vyjádøení do)       CPOS(  1,2.7) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dPozReseni)  FPOS(48,2.7) FLEN(12) FCAPTION(Øešení do)          CPOS( 33,2.7) CLEN(12) PUSH(CLICKDATE)
    TYPE(Mle)  NAME(ASYSPRITw->mPripomink)  FPOS( 1,4.7) FLEN(93) FCAPTION(Popis pøipomínky )  CPOS(  1,3.8) SIZE(104,3.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,9.4) FPOS(0.7,1.5) CAPTION(Vyjádøení)    OFFSET(15,70) PRE(tabSelect) SUB(A9)
    TYPE(Get)  NAME(ASYSPRITw->cUsrVyjadr)   FPOS(17,0.5) FLEN(12) FCAPTION(Vyjádøení zapsal) CPOS(  1,0.5) CLEN(15)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRITw->cOsoVyjadr)  CPOS(33,0.5) CLEN(57)  BGND(13)
    TYPE(Get)  NAME(ASYSPRITw->dZacVyjadr)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dKonVyjadr)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Text) CAPTION(Vyjádøení do)        CPOS(  1,2.7) CLEN(15)
    TYPE(Text) NAME(ASYSPRITw->dPozVyjadr)  CPOS(17,2.7) CLEN(13)  BGND(13)
    TYPE(Mle)  NAME(ASYSPRITw->mVyjadreni)  FPOS( 1,4.7) FLEN(93) FCAPTION(Popis vyjádøení)    CPOS(  1,3.8) SIZE(104,3.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,9.4) FPOS(0.7,1.5) CAPTION(Øešení)       OFFSET(30,55) PRE(tabSelect) SUB(A0)
    TYPE(Get)  NAME(ASYSPRITw->cUsrReseni)   FPOS(17,0.5) FLEN(12) FCAPTION(Øešení zapsal) CPOS(  1,0.5) CLEN(15)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRITw->cOsoReseni)  CPOS(33,0.5) CLEN(57)  BGND(13)
    TYPE(Get)  NAME(ASYSPRITw->dZacReseni)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dKonReseni)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->cVerReseni)  FPOS(77,1.6) FLEN(12) FCAPTION(Verze)              CPOS( 63,1.6) CLEN(12) PUSH(sys_verze_sel)
    TYPE(Text) CAPTION(Øešení do)           CPOS( 1,2.7) CLEN(15)
    TYPE(Text) NAME(ASYSPRITw->dPozReseni)  CPOS(17,2.7) CLEN(13) BGND(13)
    TYPE(Get)  NAME(ASYSPRITw->dPozTest)    FPOS(48,2.7) FLEN(12) FCAPTION(Testování do)       CPOS( 33,2.7) CLEN(15) PUSH(CLICKDATE)
    TYPE(Mle)  NAME(ASYSPRITw->mReseni)     FPOS( 1,4.7) FLEN(93) FCAPTION(Popis øešení)       CPOS(  1,3.8) SIZE(104,3.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,9.4) FPOS(0.7,1.5) CAPTION(Test)         OFFSET(45,40) PRE(tabSelect) SUB(A10)
    TYPE(Get)  NAME(ASYSPRITw->cUsrTest)   FPOS(17,0.5) FLEN(12) FCAPTION(Test zapsal) CPOS(  1,0.5) CLEN(15)  PUSH(sys_users_sel)
      TYPE(Text) NAME(ASYSPRITw->cOsoTest)  CPOS(33,0.5) CLEN(57)  BGND(13)
    TYPE(Get)  NAME(ASYSPRITw->dZacTest)    FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->dKonTest)    FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRITw->cVerTest)    FPOS(77,1.6) FLEN(12) FCAPTION(Verze)              CPOS( 63,1.6) CLEN(12) PUSH(sys_verze_sel)
    TYPE(Text) CAPTION(Testování do)        CPOS( 1,2.7) CLEN(15)
    TYPE(Text) NAME(ASYSPRITw->dPozTest)    CPOS(17,2.7) CLEN(13) BGND(13)
    TYPE(Mle)  NAME(ASYSPRITw->mTest)       FPOS( 1,4.7) FLEN(93) FCAPTION(Popis testu)        CPOS(  1,3.8) SIZE(104,3.1) SCROLL(nn) PP(2) READONLY(n)
  TYPE(End)

  TYPE(TabPage) SIZE(106.2,9.4) FPOS(0.7,1.5) CAPTION(Pøílohy)      OFFSET(60,25) PRE(tabSelect) SUB(A11)
    TYPE(EBrowse) FPOS(0.5,0.2) SIZE(104.7,7.9) FILE(dokumentw)                ;
                            CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)
      TYPE(GET)  NAME(dokumentw->cIDdokum)    FLEN(10) FCAPTION(IDdokumentu)
      TYPE(GET)  NAME(dokumentw->cZkrDokum)   FLEN(10) FCAPTION(zkratka)
      TYPE(GET)  NAME(dokumentw->cNazDokum)   FLEN(30) FCAPTION(název)
      TYPE(GET)  NAME(dokumentw->cSoubor)     FLEN(30) FCAPTION(soubor)
      TYPE(MLE)  NAME(dokumentw->mAdresar)    FLEN(50) FCAPTION(adresáø) SCROLL(nn)
    TYPE(End)
  TYPE(End)

TYPE(End)

* neviditelné pomocné položky
*TYPE(TEXT) NAME(explstitw->cfile_iv) FPOS(0,0) CLEN(0)