TYPE(drgForm) DTYPE(10) TITLE(Evidence výrobních èísel) SIZE(100,22.5) FILE( VYRCISw);
              GUILOOK(Action:n,IconBar:n,Menu:n,Message:n);
              POST( PostValidate)

*  TYPE(Action) EVENT(SEPARATOR)
*  TYPE(Action) CAPTION(~ULOŽIT)  EVENT(DoSave) TIPTEXT( Uložit ... )

  TYPE(Static) STYPE(12) SIZE(99.3,1.2) FPOS(0.5, 0.1) CTYPE(2) RESIZE(yn)
    TYPE(Text) CAPTION(Skladová položka :) CPOS(  1, 0.05) CLEN( 18) FONT(2)
    TYPE(Text) NAME(PVPITEMww->cSklPOL)    CPOS( 21, 0.05) CLEN( 19) FONT(5) PP(2)
    TYPE(Text) NAME(PVPITEMww->cNazZbo)    CPOS( 41, 0.05) CLEN( 50) FONT(5) PP(2)
  TYPE(End)

  TYPE(DBrowse) FILE(VyrCISw) INDEXORD(1);
                FIELDS( cVyrobCis    ,;
                        nOrdItem:Poø.,;
                        nMnoz    );
                SIZE(45.5, 19.8) FPOS(0,1.3) CURSORMODE(3) PP(7) RESIZE(xy) SCROLL(ny) POPUPMENU(yy);
                ITEMMARKED( itemMarked)

  TYPE(Static) STYPE(13) SIZE(99.3,1.2) FPOS(0.5, 21.1) RESIZE(xx)
    TYPE(Text) CAPTION(CELKEM)     CPOS( 19, 0.1) CLEN(  7)
    TYPE(Text) NAME(M->nSumMnoz)   CPOS( 26, 0.05) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->cWarning)   CPOS( 39, 0.05) CLEN( 25) FONT(5) PP(2)
    TYPE(Text) NAME(PVPITEMww->nMnozPrDod) CPOS( 64, 0.05) CLEN( 12) FONT(5) BGND(13) PP(2)  CTYPE(2)
  TYPE(End)

* Výrobní èísla - karta
  TYPE(Static) STYPE(13) SIZE( 53.5, 19.8) FPOS(46, 1.3) RESIZE(yn)
    TYPE(TEXT) CAPTION(Výrobní èíslo)  CPOS( 1, 0.5) CLEN(12) PP(3) BGND( 1) FONT(5)
    TYPE(GET)  NAME( cVyrobCis)        FPOS( 1, 1.5) FLEN(23)       BGND(13) NOREVISION()
    TYPE(TEXT) CAPTION(Množství)       CPOS(26, 0.5) CLEN(10) PP(3) BGND( 1)
    TYPE(GET)  NAME( nMnoz)            FPOS(26, 1.5) FLEN(12)       BGND(13)
    TYPE(TEXT) CAPTION(Zùstatek)       CPOS(40, 0.5) CLEN(10) PP(3) BGND( 1)  GROUPS(B)
    TYPE(GET)  NAME( nZust)            FPOS(40, 1.5) FLEN(12)       BGND(13)  GROUPS(B)

    TYPE(TEXT) CAPTION(Záruèní doba)    CPOS( 1, 3.6) CLEN(10)  BGND( 1)
    TYPE(TEXT) CAPTION(Dny)             CPOS(15, 2.6) CLEN( 5)  BGND( 1)
    TYPE(GET)  NAME( nZaruka)           FPOS(15, 3.6) FLEN( 5)  BGND(13)
    TYPE(TEXT) CAPTION(Týdny)           CPOS(25, 2.6) CLEN( 6)  BGND( 1)
    TYPE(GET)  NAME(M->nZarukaT)        FPOS(25, 3.6) FLEN( 5)  BGND(13)
    TYPE(TEXT) CAPTION(Roky)            CPOS(35, 2.6) CLEN( 5)  BGND( 1)
    TYPE(GET)  NAME(M->nZarukaR)        FPOS(35, 3.6) FLEN( 5)  BGND(13) PICTURE(@N 99.99)

    TYPE(Static) STYPE(16)  SIZE( 52, 0.2) FPOS(1, 4.8) RESIZE(yn)

    TYPE(TEXT) CAPTION(Do konce záruky)  CPOS( 1, 5.1) CLEN(13)  BGND( 1)
    TYPE(GET)  NAME(M->nKonZarukaD)      FPOS(15, 5.1) FLEN( 5)  BGND(13)
    TYPE(GET)  NAME(M->nKonZarukaT)      FPOS(25, 5.1) FLEN( 5)  BGND(13)
    TYPE(GET)  NAME(M->nKonZarukaR)      FPOS(35, 5.1) FLEN( 5)  BGND(13) PICTURE(@N 99.99)

    TYPE(TEXT) CAPTION(Doklad èíslo)     CPOS( 1, 7.5) CLEN(10)  BGND( 1)
    TYPE(TEXT) CAPTION(Pøíjem)           CPOS(15, 6.5) CLEN( 6)  BGND( 1)
    TYPE(GET)  NAME( nDoklad)            FPOS(15, 7.5) FLEN(10)  BGND(13)
    TYPE(TEXT) CAPTION(Výdej)            CPOS(27, 6.5) CLEN( 6)  BGND( 1)
    TYPE(GET)  NAME( nDokladV)           FPOS(27, 7.5) FLEN(10)  BGND(13)

    TYPE(TEXT) CAPTION(Datum)           CPOS( 1, 8.5) CLEN(10)  BGND( 1)
    TYPE(GET)  NAME( dDatPrijem)        FPOS(15, 8.5) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( dDatProdej)        FPOS(27, 8.5) FLEN(10)  BGND(13)
*
    TYPE(Static) STYPE(16)  SIZE( 52, 0.2) FPOS(1, 9.7) RESIZE(yn)

    TYPE(TEXT) NAME(M->cText1)          CPOS(1, 10) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText2)          CPOS(1, 11) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText3)          CPOS(1, 12) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText4)          CPOS(1, 13) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText5)          CPOS(1, 14) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText6)          CPOS(1, 15) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText7)          CPOS(1, 16) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText8)          CPOS(1, 17) CLEN( 30)  BGND( 1)
    TYPE(TEXT) NAME(M->cText9)          CPOS(1, 18) CLEN( 30)  BGND( 1)

    TYPE(GET)  NAME( cPopis1) FPOS(32, 10) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( cPopis2) FPOS(32, 11) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( cPopis3) FPOS(32, 12) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( cPopis4) FPOS(32, 13) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( cPopis5) FPOS(32, 14) FLEN(10)  BGND(13)

    TYPE(GET)  NAME( nValue1) FPOS(32, 15) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( nValue2) FPOS(32, 16) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( nValue3) FPOS(32, 17) FLEN(10)  BGND(13)
    TYPE(GET)  NAME( nValue4) FPOS(32, 18) FLEN(10)  BGND(13)
  TYPE(End)


