TYPE(drgForm) DTYPE(10) TITLE(Karta zvíøete - operativní evidence) SIZE(90,23) FILE(ZVIRATAw);
              GUILOOK(Action:y,IconBar:y:MyIconBar,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

TYPE(Static) STYPE(13) SIZE( 89, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) CAPTION( Stredisko )       CPOS(  4, 0.2) CLEN( 12) FONT(2)
  TYPE(TEXT) CAPTION( Stáj      )       CPOS(  4, 1.2) CLEN( 12) FONT(2)
  TYPE(TEXT) CAPTION( Kategorie )       CPOS(  4, 2.2) CLEN( 12) FONT(2)

  TYPE(GET)  NAME( cNazPol1)            FPOS( 18, 0.2) FLEN( 15) FONT(5) PP(2)
  TYPE(GET)  NAME( cNazPol4)            FPOS( 18, 1.2) FLEN( 15) FONT(5) PP(2)
  TYPE(GET)  NAME( nZvirKat)            FPOS( 18, 2.2) FLEN( 15) FONT(5) PP(2)
  TYPE(TEXT) NAME( cNazPol1->cNazev)    CPOS( 35, 0.2) CLEN( 50) FONT(5)
  TYPE(TEXT) NAME( cNazPol4->cNazev)    CPOS( 35, 1.2) CLEN( 50) FONT(5)
  TYPE(TEXT) NAME( KategZvi->cNazevKat) CPOS( 35, 2.2) CLEN( 50) FONT(5)

TYPE(End)

TYPE(Static) STYPE(13) SIZE( 90,22) FPOS(0,4)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE( 89, 17.5) FPOS( 0.5,0.2) RESIZE(yn)

      TYPE(GET)      NAME(nInvCis)      FPOS(21, 1) FLEN(20) FCAPTION( Inventární èíslo) CPOS( 4, 1) PP(2)
      TYPE(GET)      NAME(cNazev)       FPOS(21, 2) FLEN(50) FCAPTION( Název zvíøete)    CPOS( 4, 2)
      TYPE(GET)      NAME(dNarozZvir)   FPOS(21, 3) FLEN(20) FCAPTION( Datum narození)   CPOS( 4, 3) PUSH(ClickDate)
      TYPE(GET)      NAME(cZvireZem)    FPOS(21, 4) FLEN(20) FCAPTION( Zemì pùvodu)      CPOS( 4, 4)
      TYPE(GET)      NAME(cPlemeno)     FPOS(21, 5) FLEN(20) FCAPTION( Plemeno)          CPOS( 4, 5) PP(2)
      TYPE(TEXT)     NAME( c_Plemen->cNazPlemen)   CPOS( 43, 5) CLEN( 30) BGND( 13)
      TYPE(COMBOBOX) NAME(nPohlavi)     FPOS(21, 6) FLEN(21) FCAPTION( Pohlavi)          CPOS( 4, 6) VALUES(1:1 - On, 2:2 - Ona)
      TYPE(GET)      NAME(nInvCisMat)   FPOS(21, 7) FLEN(20) FCAPTION( Inv. èíslo matky) CPOS( 4, 7)
      TYPE(GET)      NAME(cMatkaZem)    FPOS(21, 8) FLEN(20) FCAPTION( Zemì pùvodu matky)CPOS( 4, 8)

      TYPE(GET)      NAME(nUcetSkup)    FPOS(21, 9.5) FLEN(20) FCAPTION( Úèetní skupina) CPOS( 4, 9.5) PP(2)
      TYPE(GET)      NAME(cDanPZBO)     FPOS(21,10.5) FLEN(20) FCAPTION( JCD)            CPOS( 4,10.5)
      TYPE(GET)      NAME(cTypSKP)      FPOS(21,11.5) FLEN(20) FCAPTION( Typ SKP)        CPOS( 4,11.5) PP(2)
      TYPE(GET)      NAME(cNazPol2)     FPOS(21,12.5) FLEN(20) FCAPTION( Výkon)          CPOS( 4,12.5) PP(2)
      TYPE(TEXT)     NAME( C_UctSkZ->cNazUctSk)    CPOS( 43, 9.5) CLEN( 30) BGND( 13)
      TYPE(TEXT)     NAME( C_TypSKP->cNazTypSkp)   CPOS( 43,11.5) CLEN( 30) BGND( 13)
      TYPE(TEXT)     NAME( cNazPol2->cNazev)       CPOS( 43,12.5) CLEN( 30) BGND( 13)

      TYPE(GET)      NAME(nCenaZV)      FPOS(21, 14) FLEN(20) FCAPTION( Cena zvíøete)    CPOS( 4, 14)
      TYPE(GET)      NAME(nKusy)        FPOS(21, 15) FLEN(20) FCAPTION( Kus zvíøete)     CPOS( 4, 15)
      TYPE(GET)      NAME(nFarma)       FPOS(21, 16) FLEN(20) FCAPTION( Èíslo farmy)     CPOS( 4, 16)

      TYPE(GET)      NAME(dDatPorKar)   FPOS( 74, 15 ) FLEN( 10) FCAPTION( Datum poøízení)        CPOS( 60,  15)
      TYPE(GET)      NAME(dDatPZV)      FPOS( 74, 16 ) FLEN( 10) FCAPTION( Poslední zmìna)        CPOS( 60,  16)
    TYPE(END)
  TYPE(END)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(18,66)  PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE( 89, 17.5) FPOS( 0.5,0.2) RESIZE(yn)

      TYPE(GET)  NAME(cFarmaODK)     FPOS(  22, 1)   FLEN( 15) FCAPTION( Registr.è.farmy odkud) CPOS(  4, 1)
      TYPE(GET)  NAME(dDatKdyODK)    FPOS(  52, 1)   FLEN( 12) FCAPTION( Datum pøísunu)         CPOS( 40, 1) PUSH( ClickDate)
      TYPE(GET)  NAME(cFarmaKAM)     FPOS(  22, 2)   FLEN( 15) FCAPTION( Registr.è.farmy kam)   CPOS(  4, 2)
      TYPE(GET)  NAME(dDatKdyKAM)    FPOS(  52, 2)   FLEN( 12) FCAPTION( Datum odsunu)          CPOS( 40, 2) PUSH( ClickDate)
      TYPE(GET)  NAME(nPorCisLis)    FPOS(  22, 3.5) FLEN( 15) FCAPTION( Èíslo listu)           CPOS(  4, 3.5)
      TYPE(GET)  NAME(nPorCisRad)    FPOS(  22, 4.5) FLEN( 15) FCAPTION( Èíslo øádku)           CPOS(  4, 4.5)

*      TYPE(GET)  NAME(dDatPorKar)    FPOS(  22, 15 ) FLEN( 10) FCAPTION( Datum poøízení)        CPOS(  4,  15)
*      TYPE(GET)  NAME(dDatPZV)       FPOS(  22, 16 ) FLEN( 10) FCAPTION( Poslední zmìna)        CPOS(  4,  16)
    TYPE(END)
  TYPE(END)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(34, 50) PRE( tabSelect)
    TYPE(MLE)   NAME(MPOPIS)  FPOS( 1, 0.5) SIZE( 88, 17.4) RESIZE(yy)

  TYPE(End)

TYPE(End)