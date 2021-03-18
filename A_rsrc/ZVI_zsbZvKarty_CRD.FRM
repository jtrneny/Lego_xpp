TYPE(drgForm) DTYPE(10) TITLE(Karta zvíøete - zásobová evidence) SIZE(90,22) FILE(ZvKARTYw);
              GUILOOK(Action:y,IconBar:y:MyIconBar,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

*TYPE(Action) CAPTION(~Opravy a emise)  EVENT( OPRAVY_EMISE) TIPTEXT(Opravy a emise)
*TYPE(Action) EVENT( SEPARATOR)

TYPE(Static) STYPE(13) SIZE( 89, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) CAPTION( Stredisko )       CPOS(  4, 0.2) CLEN( 12) FONT(2)
  TYPE(TEXT) CAPTION( Stáj      )       CPOS(  4, 1.2) CLEN( 12) FONT(2)
  TYPE(TEXT) CAPTION( Kategorie )       CPOS(  4, 2.2) CLEN( 12) FONT(2)

  TYPE(GET)  NAME( cNazPol1)            FPOS( 18, 0.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(GET)  NAME( cNazPol4)            FPOS( 18, 1.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(GET)  NAME( nZvirKat)            FPOS( 18, 2.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(TEXT) NAME( cNazPol1->cNazev)    CPOS( 35, 0.2) CLEN( 50) FONT(5)
  TYPE(TEXT) NAME( cNazPol4->cNazev)    CPOS( 35, 1.2) CLEN( 50) FONT(5)
  TYPE(TEXT) NAME( KategZvi->cNazevKat) CPOS( 35, 2.2) CLEN( 50) FONT(5)

TYPE(End)

TYPE(Static) STYPE(13) SIZE( 90,22) FPOS(0,4)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE( 89, 16.5) FPOS( 0.5,0.2) RESIZE(yn)

      TYPE(COMBOBOX) NAME(cTypEvid)     FPOS(21, 1) FLEN(21) FCAPTION( Typ evidence)   CPOS( 4,1) PP(2) REF(TypEvid) NOREVISION()
      TYPE(GET)      NAME(cNazev)       FPOS(21, 2) FLEN(30) FCAPTION( Název zvíøete)  CPOS( 4,2)
      TYPE(COMBOBOX) NAME(cTypZvr)      FPOS(21, 3) FLEN(21) FCAPTION( Typ zvíøete)    CPOS( 4,3) REF(TypZvr)

      TYPE(GET)      NAME(nUcetSkup)    FPOS(21, 4.5) FLEN(20) FCAPTION( Úèetní skupina) CPOS( 4,4.5) PP(2)
      TYPE(GET)      NAME(cDanPZBO)     FPOS(21, 5.5) FLEN(20) FCAPTION( JCD)            CPOS( 4,5.5)
      TYPE(GET)      NAME(cTypSKP)      FPOS(21, 6.5) FLEN(20) FCAPTION( Typ SKP)        CPOS( 4,6.5) PP(2)
      TYPE(GET)      NAME(cNazPol2)     FPOS(21, 7.5) FLEN(20) FCAPTION( Výkon)          CPOS( 4,7.5) PP(2)
      TYPE(TEXT)     NAME( C_UctSkZ->cNazUctSk)    CPOS( 43, 4.5) CLEN( 30) BGND( 13)
      TYPE(TEXT)     NAME( C_TypSKP->cNazTypSkp)   CPOS( 43, 6.5) CLEN( 30) BGND( 13)
      TYPE(TEXT)     NAME( cNazPol2->cNazev)       CPOS( 43, 7.5) CLEN( 30) BGND( 13)

      TYPE(COMBOBOX) NAME(cTypVypCen)   FPOS(21,  9) FLEN(21) FCAPTION( Typ ceny)        CPOS( 4,  9) PP(2)  REF(TypSklCen)
      TYPE(GET)      NAME(nKlicDph)     FPOS(21, 10) FLEN(20) FCAPTION( Kliè DPH)        CPOS( 4, 10) PP(2)
      TYPE(GET)      NAME(cZkratJedn)   FPOS(21, 11) FLEN(20) FCAPTION( Mìrná jednotka)  CPOS( 4, 11) PP(2)
      TYPE(GET)      NAME(cZkratMeny)   FPOS(21, 12) FLEN(20) FCAPTION( Základní mìna)   CPOS( 4, 12) PP(2)
      TYPE(GET)      NAME(nZvirKatPr)   FPOS(21, 13) FLEN(20) FCAPTION( Kategorie pro pøevod)  CPOS( 4, 13)
      TYPE(GET)      NAME(cNazPol2Pr)   FPOS(21, 14) FLEN(20) FCAPTION( Výkon pro pøevod)  CPOS( 4, 14)
      TYPE(TEXT)     NAME( C_Dph->nProcDph)      CPOS( 43, 10) CLEN(  5) BGND( 13)
      TYPE(TEXT)     CAPTION( %)                 CPOS( 48, 10) CLEN(  3)
      TYPE(TEXT)     NAME( C_Jednot->cNazJednot) CPOS( 43, 11) CLEN( 30) BGND( 13)
      TYPE(TEXT)     NAME( C_Meny->cNazMeny)     CPOS( 43, 12) CLEN( 30) BGND( 13)

    TYPE(END)
  TYPE(END)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(18,66)  PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE( 89, 16.5) FPOS( 0.5,0.2) RESIZE(yn)

      TYPE(TEXT) CAPTION(Aktuální stav)   CPOS( 25, 1) CLEN( 15) FONT(2)
      TYPE(TEXT) CAPTION(Poèáteèní stav)  CPOS( 44, 1) CLEN( 15) FONT(2)
      TYPE(Static) STYPE(17) SIZE(48, 0.1) FPOS( 4, 1.6) RESIZE(yx)

      TYPE(GET)  NAME(nCenaSZV)       FPOS(  21, 2) FLEN( 15) FCAPTION( Cena za MJ)   CPOS( 4 , 2)
      TYPE(GET)  NAME(nCenaCZV)       FPOS(  21, 3) FLEN( 15) FCAPTION( Cena CELKEM)  CPOS( 4 , 3)
      TYPE(GET)  NAME(nCenaPocZV)     FPOS(  40, 3) FLEN( 15)
      TYPE(GET)  NAME(nKusyZV)        FPOS(  21, 5) FLEN( 15) FCAPTION( Kusy zvíøat)  CPOS( 4 , 5)
      TYPE(GET)  NAME(nKusyPocZV)     FPOS(  40, 5) FLEN( 15)
      TYPE(GET)  NAME(nMnozSZV)       FPOS(  21, 6) FLEN( 15) FCAPTION( Množství na stáji)  CPOS( 4 , 6)
      TYPE(GET)  NAME(nMnozPocZV)     FPOS(  40, 6) FLEN( 15)
      TYPE(GET)  NAME(nKD)            FPOS(  21, 7) FLEN( 15) FCAPTION( Krmné dny )   CPOS( 4 , 7)
      TYPE(GET)  NAME(nKDPocZV)       FPOS(  40, 7) FLEN( 15)

*      TYPE(Static) STYPE(17) SIZE(80, 0.1) FPOS( 4, 8.5) RESIZE(yx)

      TYPE(TEXT) CAPTION(narození)    CPOS(  29, 8.5) CLEN( 8) FONT(2)
      TYPE(TEXT) CAPTION(pøírùstek)   CPOS(  48, 8.5) CLEN(10) FONT(2)
      TYPE(Static) STYPE(17) SIZE(52, 0.1) FPOS( 4, 9.1) RESIZE(yx)
      TYPE(GET)  NAME(nCenaV1ZV)      FPOS(  21, 9.5) FLEN( 15) FCAPTION( Vnitropodnikové ceny )   CPOS( 4, 9.5)
      TYPE(GET)  NAME(nCenaV2ZV)      FPOS(  40, 9.5) FLEN( 15)

      TYPE(TEXT) CAPTION(bez Dph)     CPOS(  30, 10.5) CLEN( 8) FONT(2)
      TYPE(TEXT) CAPTION(s Dph)       CPOS(  51, 10.5) CLEN( 6) FONT(2)
      TYPE(Static) STYPE(17) SIZE(52, 0.1) FPOS( 4, 11.1) RESIZE(yx)
      TYPE(GET)  NAME(nCenaPZV)       FPOS(  21, 11.5) FLEN( 15) FCAPTION( Prodejní ceny )   CPOS( 4, 11.5)
      TYPE(GET)  NAME(nCenaMZV)       FPOS(  40, 11.5) FLEN( 15)

      TYPE(TEXT) CAPTION(ceníková)    CPOS(  29, 12.5) CLEN( 8) FONT(2)
      TYPE(TEXT) CAPTION(poslední)    CPOS(  48, 12.5) CLEN( 8) FONT(2)
      TYPE(Static) STYPE(17) SIZE(52, 0.1) FPOS( 4, 13.1) RESIZE(yx)
      TYPE(GET)  NAME(NCENCNZV)       FPOS(  21, 13.5) FLEN( 15) FCAPTION( Nákupní ceny )   CPOS( 4, 13.5)
      TYPE(GET)  NAME(NCENANZV)       FPOS(  40, 13.5) FLEN( 15)

    TYPE(End)
  TYPE(END)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(34, 50) PRE( tabSelect)
    TYPE(MLE)   NAME(MPOPIS)  FPOS( 1, 0.5) SIZE( 88, 16.4) RESIZE(yy)

  TYPE(End)

* POHYBY
*  TYPE(TabPage) TTYPE(4) CAPTION(Pohyby) FPOS( 1,6)  OFFSET(50,34) PRE( tabSelect)

*    TYPE(Browse) FILE(KALKUL) INDEXORD(1) ;
*                 FIELDS(dDatAktual                ,;
*                        nCenMatMJP:Mat/MJ - Plán  ,;
*                        nCenMzdVDP:Mzdy VD-Plán   ,;
*                        nCenKalkP:CenaKALK - Plán ,;
*                        nCenMatMJS:Mat/MJ - Skut  ,;
*                        nCenMzdVDS:Mzdy VD-Skut   ,;
*                        nCenKalkS:CenaKALK - Skut) ;
*                 SIZE(100,18.5) FPOS(2, 0.5) SCROLL(ny) CURSORMODE(3) PP(7)
*  TYPE(End)

TYPE(End)