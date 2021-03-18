TYPE(drgForm) DTYPE(10) TITLE( Likvidace za doklad po položkách) SIZE(100,26) ;
              GUILOOK(Action:n) GUILOOK(Message:Y,Action:Y,IconBar:Y)

TYPE(Action) CAPTION(~Pøeúètuj) EVENT(PREUCTUJ) TIPTEXT(Pøeúètování vybraných pohybových dokladù )

* Seznam dokladù
  TYPE(DBrowse) FILE(PVPHEAD) INDEXORD(1);
                FIELDS( COBDPOH    ,;
                        CCISSKLAD  ,;
                        NDOKLAD    ,;
                        CTYPPOHYBU ,;
                        C_TYPPOH->cNazTypPoh,;
                        nCenaDokl  ,;
                        dDatPVP    ,;
                        nKlikvid   ,;
                        nZlikvid)   ;
                FPOS(0,.1) SIZE(100,9)  RESIZE(yn)  CURSORMODE(3)  SCROLL(ny) PP(7) POPUPMENU(y);
                ITEMMARKED(itemMarkedHD)

* Položky dokladu
  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(5);
                FIELDS( NORDITEM   ,;
                        CSKLPOL    ,;
                        CNAZZBO    ,;
                        NUCETSKUP  ,;
                        nMnozPrDOD ,;
                        nCenNapDod ,;
                        nCenaCelk  ,;
                        nKlikvid   ,;
                        nZlikvid)   ;
                FPOS(0,9.2) SIZE(100,8.5) CURSORMODE(3)  SCROLL(ny) PP(7);
                ITEMMARKED(itemMarkedIT)

* Zaúètování položky dokladu
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                FIELDS( cUcetMD ,;
                        cUcetDAL,;
                        nKcMD   ,;
                        nKcDAL  ,;
                        cText   ,;
                        nDoklad ,;
                        cObdobi ,;
                        cDenik)  ;
                FPOS(0,18) SIZE(100,5) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)


* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,23.1) RESIZE(yx) CTYPE(2)
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