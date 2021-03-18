TYPE(drgForm) DTYPE(10) TITLE( Likvidace dle položek dokladù) SIZE(100,26) ;
              GUILOOK(Action:n)

* Položky dokladÙ
  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(5);
               FIELDS(NORDITEM,CSKLPOL,CNAZZBO, NUCETSKUP, nMnozPrDOD,nCenNapDod,nCenaCelk) ;
               FPOS(0,.1) SIZE(100,13) CURSORMODE(3)  SCROLL(ny) PP(7) POPUPMENU(y);
               ITEMMARKED(itemMarked)

  TYPE(Static) STYPE(12) SIZE(98,2.8) FPOS(1,13.3) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Doklad )            CPOS( 2, 0.2)  CLEN(  6)
    TYPE(TEXT) NAME(PVPHEAD->nDOKLAD)      CPOS(10, 0.2)  BGND( 13) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(Datum )             CPOS( 2, 1.2)  CLEN(  6)
    TYPE(TEXT) NAME(PVPHEAD->dDatLikv)     CPOS(10, 1.2)  BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Èíslo skladu)       CPOS(21, 0.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPHEAD->cCisSklad)    CPOS(33, 0.2)  BGND( 13) PP(2)
    TYPE(TEXT) NAME(C_SKLADY->cNazSKLAD)   CPOS(41, 0.2)  BGND( 13) PP(1)

    TYPE(TEXT) CAPTION(Druh pohybu)        CPOS(21, 1.2)  CLEN( 12)
    TYPE(TEXT) NAME(PVPHEAD->nCislPoh)     CPOS(33, 1.2)  CLEN(  8) BGND(13) PP(2)
    TYPE(TEXT) NAME(C_DrPohy->cNazevPoh)   CPOS(41, 1.2)  CLEN( 25) BGND( 13) PP(1)

    TYPE(TEXT) CAPTION(Cena na dokladu)      CPOS(67, 0.2)  CLEN( 15)
    TYPE(TEXT) NAME(PVPHEAD->nCenaDokl)      CPOS(82, 0.2)  BGND( 13) PP(2)

  TYPE(End)

* Zaúètování položky dokladu
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
               FIELDS(cUcetMD, cUcetDAL, nKcMD, nKcDAL, cText, nDoklad, cObdobi, cDenik) ;
               FPOS(0,16.1) SIZE(100,6.9) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)


* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,23.1)  RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Nákl. struktura)      CPOS( 2, .2)    FONT(5)
    TYPE(Text) CAPTION(Výr.støed.)           CPOS(17, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS(17,1.2)    BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výrobek)             CPOS(29, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(29,1.2)    BGND(13) PP(2)
    TYPE(Text) FCAPTION(Zakázka)             CPOS(41, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(41,1.2)    BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výr. místo)          CPOS(53, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(53,1.2)    BGND(13) PP(2)
    TYPE(Text) FCAPTION(Stroj)               CPOS(66, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(66,1.2)    BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výr. operace)        CPOS(78, .2)    BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(78,1.2)    BGND(13) PP(2)
  TYPE(End)