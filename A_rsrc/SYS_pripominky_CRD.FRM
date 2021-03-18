TYPE(drgForm) DTYPE(10) TITLE(Pøipomínka...) SIZE(110,27) FILE(ASYSPRHDw) POST(postValidate) GUILOOK(Action:n,IconBar:y,Menu:y,Message:n)


* TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené) 
* TYPE(ComboBox) NAME(EXPLSTHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()



  TYPE(Static) FPOS(0.7,0.1) SIZE(108,6.5) STYPE(8) RESIZE(y) CTYPE(3) GROUPS(HEAD)
    TYPE(TEXT) CAPTION(ID pøipomínky ) CPOS( 1,0.4) CLEN(12)
    TYPE(TEXT)  NAME(ASYSPRHDw->nIDpripom)  CPOS(13,0.4) CLEN(15) BGND(13)
    TYPE(TEXT) CAPTION(-) CPOS( 26,0.4) CLEN(2)
    TYPE(TEXT)  NAME(ASYSPRHDw->cIDpripom)  CPOS(30,0.4) CLEN(15) BGND(13)
    TYPE(TEXT) CAPTION(z ) CPOS( 46,0.4) CLEN(2)
    TYPE(TEXT)  NAME(ASYSPRHDw->dVznikZazn)  CPOS(49,0.4) CLEN(10) BGND(13)
    TYPE(TEXT) CAPTION(UzivDB ) CPOS( 61,0.4) CLEN(7)
    TYPE(Get)  NAME(ASYSPRHDw->NIDUZIVSW)  FPOS(68,0.4) FLEN(7)
    TYPE(TEXT)  NAME(ASYSPRHDw->cnazfirmy)  CPOS(78,0.4) CLEN(29) BGND(13)

    TYPE(Get)  NAME(ASYSPRHDw->cTypPripom)  FPOS(13,1.6) FLEN(14) FCAPTION(Typ pøipomínky ) CPOS( 1,1.6) CLEN(12)
    TYPE(TEXT)  NAME(C_PRIPOM->cNazPripom)  CPOS(29,1.6) CLEN(30)
    TYPE(Get)  NAME(ASYSPRHDw->cTask)       FPOS(13,2.7) FLEN(14) FCAPTION(Úloha )          CPOS( 1,2.7) CLEN(12)
    TYPE(TEXT)  NAME(C_TASK->cNazUlohy)     CPOS(29,2.7) CLEN(30)
    TYPE(Get)  NAME(ASYSPRHDw->cVerze)      FPOS(13,3.8) FLEN(14) FCAPTION(Verze )          CPOS(1,3.8) CLEN(12) PUSH(sys_verze_sel)
*
    TYPE(ComboBox) NAME(ASYSPRHDw->nRecFiltrs) FPOS(68,1.6) FLEN(30)   ;
                   VALUES(0:bez omezení,           ;
                          1:veøejné záznamy,       ;
                          2:uživatelské záznamy,   ;
                          3:interní záznamy,       ;
                          4:distribuèní záznamy)   ;
                   FCAPTION(Pøístup) CPOS(61,1.6) CLEN(7)
    TYPE(ComboBox) NAME(ASYSPRHDw->nPriPripom) FPOS(68,2.7) FLEN(30)   ;
                   VALUES(0:nízká,            ;
                          1:støední,          ;
                          2:vysoká,           ;
                          3:velmi vysoká)     ;
                   FCAPTION(Priorita) CPOS(61,2.7) CLEN(7)
    TYPE(Get) NAME(ASYSPRHDw->nStaPripom) FPOS(68,3.8) FLEN(10)   ;
                                                     FCAPTION(Stav)     CPOS(61,3.8) CLEN(7)
    TYPE(TEXT)  NAME(C_STAPRI->cNazStaPri)  CPOS(80,3.8) CLEN(27)

    TYPE(Get)  NAME(ASYSPRHDw->cPripomink)  FPOS(13,5.1) FLEN(93) FCAPTION(Zkrácený popis ) CPOS( 1,5.2) CLEN(12)
  TYPE(END)

* ZÁKLADNÍ ÚDAJE
  TYPE(Static) FPOS(0.7,7) SIZE(108,19.5) STYPE(8) RESIZE(y) CTYPE(3)
    TYPE(Text) CAPTION(Pøipomínku zapsal ) CPOS(  1,0.5) CLEN(15)
    TYPE(Text)  NAME(ASYSPRHDw->cUser)   CPOS(17,0.5) CLEN(13)   BGND(13)
      TYPE(Text) NAME(ASYSPRHDw->cOsoba)  CPOS(33,0.5) CLEN(60)  BGND(13)
    TYPE(Get)  NAME(ASYSPRHDw->dZacPripom)  FPOS(17,1.6) FLEN(12) FCAPTION(Od kdy)             CPOS(  1,1.6) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dKonPripom)  FPOS(48,1.6) FLEN(12) FCAPTION(Do kdy)             CPOS( 33,1.6) CLEN(12) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dPozVyjadr)  FPOS(17,2.7) FLEN(12) FCAPTION(Vyjádøení do)       CPOS(  1,2.7) CLEN(15) PUSH(CLICKDATE)
    TYPE(Get)  NAME(ASYSPRHDw->dPozReseni)  FPOS(48,2.7) FLEN(12) FCAPTION(Øešení do)          CPOS( 33,2.7) CLEN(12) PUSH(CLICKDATE)
    TYPE(Mle)  NAME(ASYSPRHDw->mPripomink)  FPOS( 1,5.7) FLEN(93) FCAPTION(Popis pøipomínky )  CPOS(  1,3.8) SIZE(104,11.2) SCROLL(nn) PP(2) READONLY(n)

  TYPE(End)

TYPE(End)

