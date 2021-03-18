TYPE(drgForm) DTYPE(10) TITLE(Úèetní zmìny na kartì zvíøete ...) SIZE(105, 17) FILE(ZvZmenHDw);
               GUILOOK(Action:y,Message:n,IconBar:y:drgStdBrowseIconBar,Menu:y);
               POST(POSTVALIDATE) CBSAVE( OnSave) OBDOBI(ZVI)

*TYPE(Action) CAPTION( info ~Zvíøete)     EVENT(ZVI_ZvKarty_INFO) TIPTEXT(informaèní karta zvíøete - zásoby)
TYPE(Action) CAPTION( ~Individuální ev.)  EVENT(EVID_INDIVID)     TIPTEXT(Individuální evidence )

TYPE(Static) STYPE(12) SIZE(104.8, 16.8) FPOS(0.1,0.1) RESIZE(yn) CTYPE(2)
* ID Zvíøete
  TYPE(Static) STYPE(13) SIZE( 104, 3.8) FPOS( 0.5,0.1) RESIZE(yx) CTYPE(2)
    TYPE(TEXT) CAPTION( Stredisko )       CPOS(  4, 0.2) CLEN( 12) FONT(2)
    TYPE(TEXT) CAPTION( Stáj      )       CPOS(  4, 1.2) CLEN( 12) FONT(2)
    TYPE(TEXT) CAPTION( Kategorie )       CPOS(  4, 2.2) CLEN( 12) FONT(2)

    TYPE(GET)  NAME( ZvZmenHDw->cNazPol1)            FPOS( 18, 0.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
    TYPE(GET)  NAME( ZvZmenHDw->cNazPol4)            FPOS( 18, 1.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
    TYPE(GET)  NAME( ZvZmenHDw->nZvirKat)            FPOS( 18, 2.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
    TYPE(TEXT) NAME( M->cNazSTRED)        CPOS( 35, 0.2) CLEN( 50) FONT(5)
    TYPE(TEXT) NAME( M->cNazSTAJ)         CPOS( 35, 1.2) CLEN( 50) FONT(5)
    TYPE(TEXT) NAME( M->cNazKATEG)        CPOS( 35, 2.2) CLEN( 50) FONT(5)

*    TYPE(TEXT) NAME( cNazPol1->cNazev)    CPOS( 35, 0.2) CLEN( 50) FONT(5)
*    TYPE(TEXT) NAME( cNazPol4->cNazev)    CPOS( 35, 1.2) CLEN( 50) FONT(5)
*    TYPE(TEXT) NAME( KategZvi->cNazevKat) CPOS( 35, 2.2) CLEN( 50) FONT(5)

  TYPE(End)


* Karta pohybu
  TYPE(Static) STYPE(12) SIZE(104,12.7) FPOS(0.5, 4) RESIZE(yx) CTYPE(2)
*   Spoleèné prvky
    TYPE(GET)  NAME(ZvZmenHDw->cTypPohybu) FPOS(  15, 0.5) FLEN(10) FCAPTION(Druh pohybu) CPOS( 2,0.5) PP(2) PUSH(C_TypPoh_sel)
    TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh)  CPOS(  27, 0.5) CLEN(50) FONT(5)

    TYPE(Text) CAPTION( Období)            CPOS(60, 0.5) CLEN(  6)
    TYPE(Text) NAME(M->cObdobi)            CPOS(67, 0.5) CLEN( 10) BGND(13) FONT(5)
*    TYPE(Text) NAME(M->nAktObd)           CPOS(67, 0.5) CLEN(  4) FONT(5)
*    TYPE(Text) CAPTION(/)                 CPOS(71, 0.5) CLEN(  2) FONT(5)
*    TYPE(Text) NAME(M->nAktROK)           CPOS(73, 0.5) CLEN(  6) FONT(5)
    TYPE(Text) CAPTION( Evidence)          CPOS(82, 0.5) CLEN(  8)
    TYPE(Text) NAME(M->NazTypEvid)         CPOS(91, 0.5) CLEN( 12) BGND(13) FONT(5)


    TYPE(Static) FPOS( 0.5, 1.9) SIZE(103,.2) STYPE(16) RESIZE(yy) CTYPE(2)
*
    TYPE(GET)  NAME(ZvZmenHDw->dDatPoriz)   FPOS(15, 2.5) FLEN(15) FCAPTION(Datum poøízení) CPOS(2, 2.5) PUSH(ClickDATE) GROUPS(400,410,420,430,431,440,450,500,510,511,512,513,514,515,516,600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->nDokladUsr)  FPOS(15, 3.5) FLEN(12) FCAPTION(Èíslo dokladu)  CPOS(2, 3.5)                 GROUPS(400,410,420,430,431,440,450,500,510,511,512,513,514,515,516,600,610,620)
    TYPE(Text) CAPTION(-)                   CPOS(29, 3.5) CLEN( 2)                                                       GROUPS(400,410,420,430,431,440,450,500,510,511,512,513,514,515,516,600,610,620) FONT(5)
    TYPE(GET)  NAME(ZvZmenHDw->nDoklad)     FPOS(31, 3.5) FLEN(10)                                                       GROUPS(400,410,420,430,431,440,450,500,510,511,512,513,514,515,516,600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->dDatZmZV)    FPOS(15, 4.5) FLEN(15) FCAPTION(Datum zmìny)    CPOS(2, 4.5) PUSH(ClickDATE) GROUPS(400,410,420,430,431,440,450,500,510,511,512,513,514,515,516,600,610,620)

*   Karta 400 - Pøíjem bez vazby na dodavatele
    TYPE(GET)  NAME(ZvZmenHDw->nCisFak)     FPOS(15, 5.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(2, 5.5) GROUPS(400)
    TYPE(GET)  NAME(ZvZmenHDw->cVarSym)     FPOS(15, 6.5) FLEN(15) FCAPTION(V-Symbol)       CPOS(2, 6.5) GROUPS(400)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(400)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(400)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(400)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(400)

*   Karta 410 - Pøíjem s vazbou na dodavatele
    TYPE(GET)  NAME(ZvZmenHDw->nCisFak)     FPOS(15, 5.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(2, 5.5) GROUPS(410)
    TYPE(GET)  NAME(ZvZmenHDw->cVarSym)     FPOS(15, 6.5) FLEN(15) FCAPTION(V-Symbol)       CPOS(2, 6.5) GROUPS(410)
    TYPE(GET)  NAME(ZvZmenHDw->nCisFirmy)   FPOS(15, 8.5) FLEN(15) FCAPTION(Èíslo firmy)    CPOS(2, 8.5) GROUPS(410) PUSH( Firmy_sel)
    TYPE(Text) NAME(M->cNazFirmy)           CPOS(32, 8.5) CLEN( 40) BGND(13) FONT(5) GROUPS(410)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(410)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(410)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(410)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(410)

*   Karta 420 - Pøíjem ostatní
    TYPE(GET)  NAME(ZvZmenHDw->nCisFak)     FPOS(15, 5.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(2, 5.5) GROUPS(420)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(420)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(420)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(420)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(420)

*   Karta 430, 431 -  Pøíjem + Pøíjem narození
    TYPE(GET)  NAME(ZvZmenHDw->nCisFak)     FPOS(15, 5.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(2, 5.5) GROUPS(430,431)
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol2)    FPOS(15, 8.5) FLEN(15) FCAPTION(Výkon)          CPOS(2, 8.5) GROUPS(430,431)
    TYPE(Text) NAME(M->cNazVykon)           CPOS(32, 8.5) CLEN( 40) BGND(13) FONT(5) GROUPS(430,431)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(430,431)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(430,431)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(430,431)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(430,431)

*   Karta 440 - Pøíjem krmné dny
    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(440)
    TYPE(GET)  NAME(ZvZmenHDw->nKD)         FPOS(60,  3.5) FLEN(15) FCAPTION(Krmné dny)     CPOS(48, 3.5) GROUPS(440)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 4.5) GROUPS(440)

*   Karta 450 - Ostatní pøíjem bez kusù
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol2)    FPOS(15,  6.5) FLEN(15) FCAPTION(Výkon)         CPOS(2, 6.5) GROUPS(450)
    TYPE(Text) NAME(M->cNazVykon)           CPOS(32,  6.5) CLEN( 40) BGND(13) FONT(5) GROUPS(450)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(450)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  3.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 3.5) GROUPS(450)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 4.5) GROUPS(450)

*   Karta 500 - Výdej, spotøeba
    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(500)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(500)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(500)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(500)

*   Karta 510, 511 - Prodej bez vazby/s vazbou na odbìratele
    TYPE(GET)  NAME(ZvZmenHDw->nCisloDL)    FPOS(15, 5.5) FLEN(15) FCAPTION(Èíslo dod.listu)CPOS(2, 5.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->nCisFak)     FPOS(15, 6.5) FLEN(15) FCAPTION(Èíslo faktury)  CPOS(2, 6.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->cVarSym)     FPOS(15, 7.5) FLEN(15) FCAPTION(V-Symbol)       CPOS(2, 7.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->nCisFirmy)   FPOS(15, 8.5) FLEN(15) FCAPTION(Èíslo firmy)    CPOS(2, 8.5) GROUPS(    511) PUSH( Firmy_sel)
    TYPE(Text) NAME(M->cNazFirmy)           CPOS(32, 8.5) CLEN( 40) BGND(13) FONT(5)                     GROUPS(    511)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(510,511)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(510,511)

*   Karta 512 - Výdej množství
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  3.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 3.5) GROUPS(512)

*   Karta 513 - Výdej kusy, množství
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(513)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(513)

*   Karta 514 - Výdej kusy
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(514)

*   Karta 515 - Výdej výkon, kusy
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol2)    FPOS(15, 6.5) FLEN(15) FCAPTION(Výkon)          CPOS( 2, 6.5) GROUPS(515)
    TYPE(Text) NAME(M->cNazVykon)           CPOS(32, 6.5) CLEN( 40) BGND(13) FONT(5)                      GROUPS(515)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60, 4.5) FLEN(15) FCAPTION(Kusy)           CPOS(48, 4.5) GROUPS(515)

*   Karta 516 - Výdej cena celkem
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  3.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 3.5) GROUPS(516)

*   Karta 600, 610, 620 - Pøevod mezi stájemi automatický=600, do základního stáda =610, mezi kategoriemi autom.=620
    TYPE(TEXT) CAPTION(Pøevádí se na)      CPOS( 15, 6.3) CLEN( 12) FONT(5) GROUPS(600,610,620)
    TYPE(Static) FPOS( 2, 6.7) SIZE(29,.2) STYPE(16) RESIZE(yy) CTYPE(2)    GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol1_N) FPOS(15, 7.5) FLEN(15) FCAPTION(Stredisko)      CPOS(2, 7.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol4_N) FPOS(15, 8.5) FLEN(15) FCAPTION(Stáj)           CPOS(2, 8.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->nZvirKat_N) FPOS(15, 9.5) FLEN(15) FCAPTION(Kategorie)      CPOS(2, 9.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->cNazPol2_N) FPOS(15,10.5) FLEN(15) FCAPTION(Výkon)          CPOS(2,10.5) GROUPS(600,610,620)

    TYPE(TEXT) NAME(cNazPol1->cNazev)      CPOS( 32, 7.5) CLEN( 30) BGND(13) GROUPS(600,610,620)
    TYPE(TEXT) NAME(cNazPol4->cNazev)      CPOS( 32, 8.5) CLEN( 30) BGND(13) GROUPS(600,610,620)
    TYPE(TEXT) NAME(KategZvi->cNazevKat)   CPOS( 32, 9.5) CLEN( 30) BGND(13) GROUPS(600,610,620)
    TYPE(TEXT) NAME(cNazPol2->cNazev)      CPOS( 32,10.5) CLEN( 30) BGND(13) GROUPS(600,610,620)

    TYPE(GET)  NAME(ZvZmenHDw->nCenaSZV)    FPOS(60,  2.5) FLEN(15) FCAPTION(Cena za MJ)    CPOS(48, 2.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->nKusyZV)     FPOS(60,  3.5) FLEN(15) FCAPTION(Kusy)          CPOS(48, 3.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->nMnozSZV)    FPOS(60,  4.5) FLEN(15) FCAPTION(Množství)      CPOS(48, 4.5) GROUPS(600,610,620)
    TYPE(GET)  NAME(ZvZmenHDw->nCenaCZV)    FPOS(60,  5.5) FLEN(15) FCAPTION(Cena celkem)   CPOS(48, 5.5) GROUPS(600,610,620)

*    TYPE(PushButton) CAPTION( INDIVIDUÁLNÍ evidence)    POS(70, 10.5) SIZE(20, 1.1) EVENT() PRE(2) FONT(5)
  TYPE(End)
TYPE(End)