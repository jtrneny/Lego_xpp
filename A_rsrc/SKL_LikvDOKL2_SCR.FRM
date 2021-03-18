TYPE(drgForm) DTYPE(10) TITLE( Likvidace za doklad celkem ) SIZE(100,26) ;
              GUILOOK(Action:n)

* Seznam dokladù
  TYPE(DBrowse) FILE(PVPHEAD)  INDEXORD(1);
               FIELDS(COBDPOH, CCISSKLAD, NDOKLAD, NCISLPOH, C_DRPOHY->cNazevPoh,nCenaDokl,dDatPVP);
               FPOS(0,.1) SIZE(100,12) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
               ITEMMARKED(itemMarked)

* Zaúètování dokladu
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
               FIELDS(cUcetMD, cUcetDAL, nKcMD, nKcDAL, cText, nDoklad, cObdobi, cDenik) ;
               FPOS(0,12.2) SIZE(100,10.5) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)

* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,22.8) RESIZE(yx) CTYPE(2)
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