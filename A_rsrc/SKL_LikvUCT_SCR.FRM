TYPE(drgForm) DTYPE(10) TITLE( Likvidace dle úèetních pøedpisù ) SIZE(100,26) ;
              GUILOOK(Action:n)

* Pøehled úèetních pøedpisù
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(5);
               FIELDS(cUcetMD, cUcetDAL, nKcMD, nKcDAL, cText, nDoklad, cObdobi, cDenik) ;
               FPOS(0,.1) SIZE(100,12) CURSORMODE(3)  SCROLL(ny) PP(7) POPUPMENU(y);
               ITEMMARKED( ItemMarked)

* Hlavièka dokladu
  TYPE(Static) STYPE(13) SIZE(98,5.8) FPOS(1,12.2) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Hlavièka dokladu)     CPOS( 2, .2)   BGND( 12) FONT(5)
    TYPE(TEXT) CAPTION(èíslo)                CPOS(19, 0.2)  CLEN( 5)
    TYPE(TEXT) NAME(PVPHEAD->nDOKLAD)        CPOS(25, 0.2)  BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Èíslo skladu)         CPOS( 2, 2.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPHEAD->cCisSklad)      CPOS(15, 2.2)  BGND( 13) PP(2)
    TYPE(TEXT) NAME(C_SKLADY->cNazSKLAD)     CPOS(23, 2.2)  BGND( 13) PP(1)
    TYPE(TEXT) CAPTION(Druh pohybu)          CPOS( 2, 3.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPHEAD->nCislPoh)       CPOS(15, 3.2)  CLEN(  8) BGND(13) PP(2)
    TYPE(TEXT) NAME(C_DrPohy->cNazevPoh)     CPOS(23, 3.2)  CLEN( 25) BGND( 13) PP(1)
    TYPE(TEXT) CAPTION(Èíslo faktury)        CPOS( 2, 4.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPHEAD->nCisFak)        CPOS(15, 4.2)  BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Cena na dokladu)      CPOS(52, 2.2)  CLEN( 18)
    TYPE(TEXT) NAME(PVPHEAD->nCenaDokl)      CPOS(70, 2.2)  BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Nutné vedl. náklady)  CPOS(52, 3.2)  CLEN( 18)
    TYPE(TEXT) NAME(PVPHEAD->cCisSklad)      CPOS(70, 3.2)  BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Datum likvidace)      CPOS(52, 4.2)  CLEN( 18)
    TYPE(TEXT) NAME(PVPHEAD->dDatLikv)       CPOS(70, 4.2)  BGND( 13) PP(2)
  TYPE(End)

* Položka dokladu
  TYPE(Static) STYPE(13) SIZE(98,5.8) FPOS(1,18.2) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Položka dokladu)      CPOS( 2,  .2)  BGND( 12) FONT(5)
    TYPE(TEXT) CAPTION(èíslo)                CPOS(19, 0.2)  CLEN( 5)
    TYPE(TEXT) NAME(PVPHEAD->nDOKLAD)        CPOS(25, 0.2)  BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Skl. položka)         CPOS( 2, 2.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPITEM->cSklPol)        CPOS(15, 2.2)  CLEN( 15) BGND( 13) PP(2)
    TYPE(TEXT) NAME(PVPITEM->cNazZbo)        CPOS(30, 2.2)  CLEN( 30) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(úè.skup.)             CPOS(62, 2.2)  CLEN(  8)
    TYPE(TEXT) NAME(PVPITEM->nUcetSkup)      CPOS(71, 2.2)  CLEN(  5) BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Mn.na dokladu)        CPOS( 2, 3.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPITEM->nMnozPrDod)     CPOS(15, 3.2)  CLEN( 12) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Cena na dokladu)      CPOS(30, 3.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPITEM->nCenNapDod)     CPOS(44, 3.2)  CLEN( 12) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Cena celkem)          CPOS(58, 3.2)  CLEN( 10)
    TYPE(TEXT) NAME(PVPITEM->nCenaCelk)      CPOS(70, 3.2)  CLEN( 12) BGND( 13) PP(2)

  TYPE(End)


