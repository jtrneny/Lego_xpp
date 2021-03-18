TYPE(drgForm) DTYPE(10) TITLE(Výrobní èísla ke skl. položce) SIZE(110,22) FILE(VYRCIS);
              GUILOOK(Action:y,IconBar:y);
              POST( postVALIDATE)

TYPE(Action) CAPTION(info C~eník) EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

TYPE(Static) STYPE(13) SIZE(109.8, 3) FPOS( 0.1, 0.1)
  TYPE(Text) CAPTION(Sklad)              CPOS(  3, 0.3) CLEN( 10) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cCisSklad)    CPOS(  3, 1.5) CLEN( 10) BGND(13) FONT(5) GROUPS(clrGREY)
*  TYPE(Text) NAME(C_SKLADY->cNazSklad)  CPOS( 14, 1.5) CLEN( 25) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(Text) CAPTION(Sklad. položka)     CPOS( 14, 0.3) CLEN( 20) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cSklPol)      CPOS( 14, 1.5) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREEN)
  TYPE(Text) CAPTION(Název zboží)        CPOS( 35, 0.3) CLEN( 40) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cNazZbo)      CPOS( 35, 1.5) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREEN)

  TYPE(Text) CAPTION(Mn. výr.èísla)      CPOS( 77, 0.3) CLEN( 13) FONT(2)
  TYPE(Text) NAME(M->nSumMnozVD)         CPOS( 77, 1.5) CLEN( 13) BGND(13) FONT(5) GROUPS(clrGREY) CTYPE(2)
  TYPE(Text) CAPTION(Mn. výdejka)        CPOS( 94, 0.3) CLEN( 13) FONT(2)
  TYPE(Text) NAME(M->nMnozPrDod)         CPOS( 94, 1.5) CLEN( 13) BGND(13) FONT(5) GROUPS(clrGREY) CTYPE(2)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 110, 18.8) FPOS( 0, 3.2) RESIZE(yx)

  TYPE(TabPage) CAPTION(Výrobní èísla) RESIZE(yy) OFFSET( 1,80) PRE( tabSelect)

    TYPE(DBrowse) FILE(VYRCIS) INDEXORD(1);
                  FIELDS( nPoradi    ,;
                          cVyrobCIS  ,;
                          nMnozP     ,;
                          nMnozV     ,;
                          nZust      ,;
                          FMnozV():Mn.vydané dokladem,;
                          nDoklad:Èís.pøíjemky ,;
                          dDatPrijem ,;
                          nZaruka    ,;
                          nMnozPoc   ,;
                          nMnoz      ,;
                          cVady      ,;
                          nDokladV:Èís.výdejky ,;
                          dDatProdej );
                  SIZE(110, 17.5) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy);
                  ITEMMARKED( ItemMarked) POPUPMENU(y) FOOTER(y)
  TYPE(End)

  TYPE(TabPage) CAPTION(Detail) RESIZE(yy) OFFSET(20,65) PRE( tabSelect)

    TYPE(Static) STYPE(2) SIZE( 108, 9.5) FPOS( 1, 0) RESIZE(yn) FONT(5)
      TYPE(STATIC) STYPE(16) CPOS( 1,2) SIZE(105, 1.5 )
      TYPE(STATIC) STYPE(16) CPOS( 1,2) SIZE(105, 1.6 )

* Karta výr.èísla
      TYPE(Text) CAPTION(Výrobní èíslo) CPOS( 1, 1) CLEN( 12) FONT(5)
      TYPE(GET)  NAME( cVyrobCis)       FPOS(15, 1) FLEN( 30) FONT(5)
      TYPE(GET)  NAME( nMnoz)           FPOS(55, 1) FLEN( 17) FCAPTION(Množství) CPOS(47,1)
      TYPE(GET)  NAME( nZust)           FPOS(87, 1) FLEN( 17) FCAPTION(Zùstatek) CPOS(77,1) GROUPS(B)
* Záruka
      TYPE(Text) CAPTION( Dny)   CPOS( 23, 3) CLEN( 6)
      TYPE(Text) CAPTION( Týdny) CPOS( 32, 3) CLEN( 6)
      TYPE(Text) CAPTION( Roky)  CPOS( 44, 3) CLEN( 6)
      TYPE(Text) CAPTION( Délka záruky) CPOS( 5, 4) CLEN( 12)
      TYPE(GET)  NAME(NZARUKA)      FPOS(20, 4) FLEN( 6)
      TYPE(GET)  NAME(M->nZarukaT)  FPOS(30, 4) FLEN( 6)
      TYPE(GET)  NAME(M->nZarukaR)  FPOS(40, 4) FLEN( 7)
      TYPE(Text) CAPTION( Do konce záruky) CPOS( 5, 5) CLEN( 15)
      TYPE(GET)  NAME(M->nKonZarukaD)  FPOS(20, 5) FLEN( 6)
      TYPE(GET)  NAME(M->nKonZarukaT)  FPOS(30, 5) FLEN( 6)
      TYPE(GET)  NAME(M->nKonZarukaR)  FPOS(40, 5) FLEN( 7)
* Doklady
      TYPE(Text) CAPTION( Pøíjem)        CPOS( 75, 3) CLEN( 6)
      TYPE(Text) CAPTION( Výdej)         CPOS( 91, 3) CLEN( 6)
      TYPE(Text) CAPTION( Èíslo dokladu) CPOS( 55, 4) CLEN( 12)
      TYPE(Text) CAPTION( Datum pohybu)  CPOS( 55, 5) CLEN( 12)
      TYPE(GET)  NAME(NDOKLAD)     FPOS(67, 4) FLEN( 12)
      TYPE(GET)  NAME(DDATPRIJEM)  FPOS(67, 5) FLEN( 12) PUSH(CLICKDATE)
      TYPE(GET)  NAME(NDOKLADV)    FPOS(82, 4) FLEN( 12)
      TYPE(GET)  NAME(DDATPRODEJ)  FPOS(82, 5) FLEN( 12) PUSH(CLICKDATE)
*
      TYPE(Text) CAPTION( Zkr. èár.kódu)     CPOS( 5, 6.5) CLEN( 15)
      TYPE(GET)  NAME(cZkrCarKod)            FPOS(20, 6.5) FLEN( 20)
      TYPE(Text) NAME( C_CarKod->cNazCarKod) CPOS(42, 6.5) CLEN( 50)
      TYPE(Text) CAPTION( Èárový kód)        CPOS( 5, 7.5) CLEN( 15)
      TYPE(GET)  NAME(cCarKod)               FPOS(20, 7.5) FLEN( 74)
      TYPE(Text) CAPTION( Vady - chyby)      CPOS( 5, 8.5) CLEN( 15)
      TYPE(GET)  NAME(CVADY)                 FPOS(20, 8.5) FLEN( 74)
    TYPE(End)


* Doplòující údaje

    TYPE(Text) CAPTION( Doplòující údaje) CPOS( 3, 10.4) CLEN( 12) RESIZE(yn)
    TYPE(Static) STYPE(2) SIZE( 108, 6) FPOS( 1, 10.5) RESIZE(yn)

      TYPE(Text) NAME( M->cText1) CPOS( 5, 1) CLEN( 25)
      TYPE(Text) NAME( M->cText2) CPOS( 5, 2) CLEN( 25)
      TYPE(Text) NAME( M->cText3) CPOS( 5, 3) CLEN( 25)
      TYPE(Text) NAME( M->cText4) CPOS( 5, 4) CLEN( 25)
      TYPE(Text) NAME( M->cText5) CPOS( 5, 5) CLEN( 25)

      TYPE(GET)  NAME(CPOPIS1)  FPOS(31, 1) FLEN(15)
      TYPE(GET)  NAME(CPOPIS2)  FPOS(31, 2) FLEN(15)
      TYPE(GET)  NAME(CPOPIS3)  FPOS(31, 3) FLEN(15)
      TYPE(GET)  NAME(CPOPIS4)  FPOS(31, 4) FLEN(15)
      TYPE(GET)  NAME(CPOPIS5)  FPOS(31, 5) FLEN(15)

      TYPE(Text) NAME( M->cText6) CPOS( 55, 1) CLEN( 25)
      TYPE(Text) NAME( M->cText7) CPOS( 55, 2) CLEN( 25)
      TYPE(Text) NAME( M->cText8) CPOS( 55, 3) CLEN( 25)
      TYPE(Text) NAME( M->cText9) CPOS( 55, 4) CLEN( 25)

      TYPE(GET)  NAME(NVALUE1)  FPOS(80, 1) FLEN(15)
      TYPE(GET)  NAME(NVALUE2)  FPOS(80, 2) FLEN(15)
      TYPE(GET)  NAME(NVALUE3)  FPOS(80, 3) FLEN(15)
      TYPE(GET)  NAME(NVALUE4)  FPOS(80, 4) FLEN(15)
    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)
TYPE(End)