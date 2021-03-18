TYPE(drgForm) DTYPE(10) TITLE(Seznam pøipomínek a nápadù ...) SIZE(110,25) ;
                                                                   PRINTFILES(asysprhd:cidpripom=cidpripom ) ;
                                                                   COMMFILES( asysprhd:cidpripom=cidpripom ) ;
                                                                   CARGO(SYS_pripominky_IN)

*  TYPE(Action) CAPTION(~Export) EVENT(export_pripom) TIPTEXT(Export pøipomínek)
*  TYPE(Action) CAPTION(~Import) EVENT(import_pripom) TIPTEXT(Import pøipomínek)

  TYPE(DBrowse) FPOS(0.1,0.1) SIZE(109.5,12.5) FILE(ASYSPRHD)         ;
                              FIELDS(M->stav_pripom:st:2.7::2, ;
                                     M->priorita_pripom:pr:2.7::2, ;
                                     M->komunik_pripom:ko:2.7::2, ;
                                     cIDpripom, ;
                                     cVerze::12, ;
                                     cTask:Úloha:4, ;
                                     cTypPripom, ;
                                     cPripomink, ;
                                     dZacPripom, ;
                                     dKonPripom, ;
                                     cOsoba, ;
                                     mPripomink, ;
                                     cUsrVyjadr, ;
                                     dPozVyjadr, ;
                                     dZacVyjadr, ;
                                     dKonVyjadr, ;
                                     dVyjadreni, ;
                                     mVyjadreni, ;
                                     cUsrReseni, ;
                                     dPozReseni, ;
                                     dZacReseni, ;
                                     dKonReseni, ;
                                     mReseni, ;
                                     cUsrTest, ;
                                     dPozTest, ;
                                     dZacTest, ;
                                     dKonTest, ;
                                     mTest          ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* tab 1 pøipomínky
  TYPE(TabPage) CAPTION(Pøipomínka) FPOS(0.5,12.8) SIZE(109,12.0) Resize(yx) OFFSET(1,81) SUBTABS(A1,A2)
    TYPE(TEXT) CAPTION(Zapsal:)   CPOS( 3, .4) CLEN(7)
     TYPE(TEXT) NAME(ASYSPRHD->cOsoba)    CPOS(10, .4) CLEN(40) BGND(1) CTYPE(4) PP(3)

    TYPE(TabPage) CAPTION(Detail) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(2,81) SUB(A1)
      TYPE(MLE) NAME('ASYSPRHD->mPripomink') FPOS(0.50,0.2) SIZE(106.2,8.00) ;
                READONLY(Y) FCAPTION(Popis pøipomínky) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(1.2,2.4) SIZE(107.4,9.4) Resize(yx) OFFSET(18,66) SUB(A2)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(47.0,8.0) FILE(ASYSPRIT)       ;
                              FIELDS(nOrdItem::3, ;
                                     cVerze::10, ;
                                     cOsoba, ;
                                     dZacPripom, ;
                                     dKonPripom, ;
                                     cPripomink, ;
                                     cTask, ;
                                     cTypPripom, ;
                                     mPripomink  ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

      TYPE(MLE) NAME('ASYSPRIT->mPripomink') FPOS(48.0,0.2) SIZE(59.0,8.00) ;
                READONLY(Y) FCAPTION(Popis pøipomínky) CPOS(1.5,17.8) CLEN(20)
    TYPE(End)
  TYPE(End)


* tab 2 vyjádøení
  TYPE(TabPage) CAPTION(Vyjádøení) FPOS(0.5,12.8) SIZE(109,12.0) OFFSET(18,66) Resize(yx) SUBTABS(B1,B2)
    TYPE(TEXT) CAPTION(Zapsal:)   CPOS( 3, .4) CLEN(7)
     TYPE(TEXT) NAME(ASYSPRHD->cOsoVyjadr)    CPOS(10, .4) CLEN(40) BGND(1) CTYPE(4) PP(3)

    TYPE(TabPage) CAPTION(Detail) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(2,81) SUB(B1)
      TYPE(MLE) NAME('ASYSPRHD->mVyjadreni') FPOS(0.50,0.2) SIZE(106.2,8.00) ;
                READONLY(Y) FCAPTION(Vyjádøení k pøipomínce) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)

    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(18,66) SUB(B2)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(47.0,8.0) FILE(ASYSPRIT)        ;
                              FIELDS(nOrdItem::3, ;
                                     cUsrVyjadr, ;
                                     dPozVyjadr, ;
                                     dZacVyjadr, ;
                                     dKonVyjadr, ;
                                     dVyjadreni, ;
                                     cTask, ;
                                     cTypPripom ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)
      TYPE(MLE) NAME('ASYSPRIT->mVyjadreni') FPOS(48.00,0.2) SIZE(59.0,8.00) ;
                READONLY(Y) FCAPTION(Popis vyjádøení) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)
  TYPE(End)


* tab 3 øešení
  TYPE(TabPage) CAPTION(Øešení) FPOS(0.5,12.8) SIZE(109,12.0) OFFSET(33,50) Resize(yx) SUBTABS(C1,C2)
    TYPE(TEXT) CAPTION(Zapsal:)   CPOS( 3, .4) CLEN(7)
     TYPE(TEXT) NAME(ASYSPRHD->cOsoReseni)    CPOS(10, .4) CLEN(40) BGND(1) CTYPE(4) PP(3)

    TYPE(TabPage) CAPTION(Detail) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(2,81) SUB(C1)
      TYPE(MLE) NAME('ASYSPRHD->mReseni') FPOS(0.50,0.2) SIZE(106.2,8.00) ;
                READONLY(Y) FCAPTION(Øešení pøipomínky) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(18,66) SUB(C2)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(47.0,8.0) FILE(ASYSPRIT)        ;
                              FIELDS(nOrdItem::3, ;
                                     cVerReseni::10, ;
                                     cUsrReseni, ;
                                     dPozReseni, ;
                                     dZacReseni, ;
                                     dKonReseni, ;
                                     cTask, ;
                                     cTypPripom ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

      TYPE(MLE) NAME('ASYSPRIT->mReseni') FPOS(48.00,0.2) SIZE(59.0,8.00) ;
                READONLY(Y) FCAPTION(Popis vyjádøení) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)
  TYPE(End)


* tab 4 test
  TYPE(TabPage) CAPTION(Testy) FPOS(0.5,12.8) SIZE(109,12.0) OFFSET(48,35) Resize(yx) SUBTABS(D1,D2)
    TYPE(TEXT) CAPTION(Zapsal:)   CPOS( 3, .4) CLEN(7)
     TYPE(TEXT) NAME(ASYSPRHD->cOsoTest)    CPOS(10, .4) CLEN(40) BGND(1) CTYPE(4) PP(3)

    TYPE(TabPage) CAPTION(Detail) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(2,81) SUB(D1)
      TYPE(MLE) NAME('ASYSPRHD->mTest') FPOS(0.50,0.2) SIZE(106.2,8.00) ;
                READONLY(Y) FCAPTION(Testování pøipomínky) CPOS(1.5, 17.8) CLEN(20)
    TYPE(End)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(18,66) SUB(D2)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(47.0,8.0) FILE(ASYSPRIT)        ;
                              FIELDS(nOrdItem::3, ;
                                     cVerTest::10, ;
                                     cUsrTest, ;
                                     dPozTest, ;
                                     dZacTest, ;
                                     dKonTest, ;
                                     cTask, ;
                                     cTypPripom ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

      TYPE(MLE) NAME('ASYSPRIT->mTest') FPOS(48.0,0.2) SIZE(59.0,8.00) ;
                READONLY(Y) FCAPTION(Popis testování) CPOS(1.5,17.8) CLEN(20)
    TYPE(End)
  TYPE(End)

* tab 5 pøílohy
  TYPE(TabPage) CAPTION(Pøílohy) FPOS(0.5,12.8) SIZE(109,12.0) OFFSET(63,20) Resize(yx) SUBTABS(E1,E2)
    TYPE(TEXT) CAPTION(Zapsal:)   CPOS( 3, .4) CLEN(7)
     TYPE(TEXT) NAME(ASYSPRHD->cOsoba)    CPOS(10, .4) CLEN(40) BGND(1) CTYPE(4) PP(3)

    TYPE(TabPage) CAPTION(Detail) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(2,81) SUB(E1)
*      TYPE(MLE) NAME('ASYSPRHD->mTest') FPOS(0.50,0.2) SIZE(106.2,8.00) ;
*                READONLY(Y) FCAPTION(Testování pøipomínky) CPOS(1.5, 17.8) CLEN(20)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(106.2,8.0) FILE(VAZDOKUM)        ;
                              FIELDS(cIDdokum::16, ;
                                     dokument->cZkrDokum,;
                                     dokument->cNazDokum,;
                                     dokument->cSoubor,;
                                     dokument->mAdresar,;
                                     dVznikZazn ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)
    TYPE(End)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(1.2,2.4) SIZE(107,9.4) Resize(yx) OFFSET(18,66) SUB(E2)
      TYPE(DBrowse) FPOS(0.5,0.2) SIZE(47.0,8.0) FILE(ASYSPRIT)        ;
                              FIELDS(nOrdItem::3, ;
                                     cVerTest::10, ;
                                     cUsrTest, ;
                                     dPozTest, ;
                                     dZacTest, ;
                                     dKonTest, ;
                                     cTask, ;
                                     cTypPripom ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

      TYPE(DBrowse) FPOS(48.0,0.2) SIZE(59.0,8.0) FILE(VAZDOKUM)        ;
                              FIELDS(cIDdokum::16, ;
                                     dokument->cZkrDokum,;
                                     dokument->cNazDokum,;
                                     dokument->cSoubor,;
                                     dokument->mAdresar,;
                                     dVznikZazn ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

    TYPE(End)
  TYPE(End)