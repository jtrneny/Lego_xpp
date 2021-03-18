TYPE(drgForm) DTYPE(10) TITLE(Denní kapacita pracovištì) SIZE(75,24) FILE(KAPP_DENw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

TYPE(Static) STYPE(12) SIZE(74, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)

  TYPE(Text) CAPTION(Datum vyhotov.plán) CPOS( 2, 1.4)
  TYPE(GET)  NAME(dVyhotPlan)         FPOS( 20, 1.4) FLEN( 15)   FONT(5) PP(2) PUSH(CLICKDATE)  NOREVISION()
  TYPE(Text) CAPTION(Den)             CPOS( 42, 0.4) CLEN(  5)
  TYPE(Text) NAME(M->cDenBlok)        CPOS( 42, 1.4) CLEN(  8)   BGND( 13) FONT(5)
  TYPE(GET)  NAME(nTydKapBlo)         FPOS( 52, 1.4) FLEN(  4)   FCAPTION(Týden)     CPOS( 52, 0.4) CLEN( 6)
  TYPE(GET)  NAME(nObdobi)            FPOS( 59, 1.4) FLEN(  4)   FCAPTION(Mìsíc)     CPOS( 60, 0.4)
  TYPE(GET)  NAME(nRokVytvor)         FPOS( 66, 1.4) FLEN(  4)   FCAPTION(Rok)       CPOS( 67, 0.4)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 75,20.5) FPOS(0,3.7)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74,19) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cOznPrac)             FPOS( 20, 1 ) FLEN( 15) FCAPTION(Pracovištì)          CPOS( 1, 1) NOREVISION()
      TYPE(Text)     NAME(C_Pracov->cNazevPrac) CPOS( 37, 1 ) CLEN( 30) BGND( 13)
      TYPE(GET)      NAME(cStred)               FPOS( 20, 2 ) FLEN( 15) FCAPTION(Výrobní støedisko)   CPOS( 1, 2) NOREVISION()
      TYPE(Text)     NAME(C_Stred->cNazStr)     CPOS( 37, 2 ) CLEN( 30) BGND( 13)
      TYPE(GET)      NAME(nPracoDoba)           FPOS( 20, 3 ) FLEN( 15) FCAPTION(Pracovní doba)       CPOS( 1, 3)
      TYPE(GET)      NAME(nPocetStro)           FPOS( 20, 4 ) FLEN( 15) FCAPTION(Poèet strojù)        CPOS( 1, 4)
      TYPE(GET)      NAME(nPocSmen)             FPOS( 20, 5 ) FLEN( 15) FCAPTION(Poèet smìn)          CPOS( 1, 5)
*      TYPE(GET)      NAME(nViceObslu)          FPOS( 20, 6 ) FLEN( 15) FCAPTION()                     CPOS( 1, 6)

      TYPE(TEXT)     CAPTION(DENNÍ KAPACITA PRACOVIŠTÌ)         CPOS( 1, 6.2) CLEN(26) FONT(5)
      TYPE(Static) STYPE(17) SIZE(15, 0.1) FPOS( 21, 6.8) RESIZE(yx)
      TYPE(GET)      NAME(nKapacNhod)           FPOS(20, 7.5) FLEN( 15) FCAPTION(- Teoretická kapacita) CPOS( 3, 7.5)
      TYPE(GET)      NAME(nBlokaceNh)           FPOS(20, 8.5) FLEN( 15) FCAPTION(- Blokovaná kapacita)  CPOS( 3, 8.5)
      TYPE(GET)      NAME(nVolnaKapa)           FPOS(20, 9.5) FLEN( 15) FCAPTION(- Volná kapacita)      CPOS( 3, 9.5)
      TYPE(Static) STYPE(17) SIZE(35, 0.1) FPOS( 1, 11) RESIZE(yx)

      TYPE(GET)      NAME(cPoznamka)            FPOS(20,16) FLEN( 50) FCAPTION(Poznámka)            CPOS( 1,16)

    TYPE(End)
  TYPE(END)

* POPIS PRACOVIŠTÌ
*  TYPE(TabPage) TTYPE(4) CAPTION(Popis pracovištì) OFFSET(24,52)
*    TYPE(MLE) NAME(mPopisPrac) FPOS(1, 0.5) SIZE(73,18)
*  TYPE(End)

TYPE(End)