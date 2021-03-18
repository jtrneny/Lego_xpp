TYPE(drgForm) DTYPE(10) TITLE(Režijní náklady) SIZE(70,11) FILE(FIXNAKLw) ;
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n) ;
              POST(postValidate)

  TYPE(Static) STYPE(13) SIZE(68,5) FPOS(1,0.1) RESIZE(yn)

    TYPE(GET)  NAME(nRokVyp)            FPOS(18, 0.3) FLEN( 12) FCAPTION(Rok pro výpoèty)     CPOS( 1, 0.3)
    TYPE(GET)  NAME(cNazPol1)           FPOS(18, 1.3) FLEN( 12) FCAPTION(Nákladové støedisko) CPOS( 1, 1.3)
    TYPE(TEXT) NAME(CNazPol1->CNAZEV)   CPOS(32, 1.3) CLEN( 30) BGND(13)
    TYPE(GET)  NAME(nObdMes)            FPOS(18, 2.3) FLEN( 12) FCAPTION(Období)              CPOS( 1, 2.3)
    TYPE(GET)  NAME(cNazPol2)           FPOS(18, 3.3) FLEN( 12) FCAPTION(Úèetní výrobek)      CPOS( 1, 3.3)
    TYPE(TEXT) NAME(CNazPol2->CNAZEV)   CPOS(32, 3.3) CLEN( 30) BGND(13)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(68,5.7) FPOS(1, 5.2) RESIZE(yn)

*   1.øádek
    TYPE(Text) CAPTION(R E Ž I E)    CPOS(  1, 0.2)   CLEN( 15) FONT(5)
    TYPE(Text) CAPTION(Vypoètená)    CPOS( 22, 0.2)   CLEN( 12) FONT(2) CTYPE(2)
    TYPE(Text) CAPTION(Nastavená)    CPOS( 42, 0.2)   CLEN( 12) FONT(2) CTYPE(2)

    TYPE(TEXT) NAME(M->cNazRezie1)    CPOS(  3, 1.2)   CLEN( 18)
    TYPE(TEXT) NAME(M->cNazRezie2)    CPOS(  3, 2.2)   CLEN( 18)
    TYPE(TEXT) NAME(M->cNazRezie3)    CPOS(  3, 3.2)   CLEN( 18)
    TYPE(TEXT) NAME(M->cNazRezie4)    CPOS(  3, 4.2)   CLEN( 18)

    TYPE(GET)  NAME(nOdbytReVy)      FPOS(21, 1.2) FLEN( 12)
    TYPE(GET)  NAME(nVyrobReVy)      FPOS(21, 2.2) FLEN( 12)
    TYPE(GET)  NAME(nZasobReVy)      FPOS(21, 3.2) FLEN( 12)
    TYPE(GET)  NAME(nSpravReVy)      FPOS(21, 4.2) FLEN( 12)
    TYPE(Text) CAPTION( %)           CPOS(34, 1.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(34, 2.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(34, 3.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(34, 4.2) CLEN(  3) FONT(2)

    TYPE(GET)  NAME(nOdbytReNa)      FPOS(41, 1.2) FLEN( 12)
    TYPE(GET)  NAME(nVyrobReNa)      FPOS(41, 2.2) FLEN( 12)
    TYPE(GET)  NAME(nZasobReNa)      FPOS(41, 3.2) FLEN( 12)
    TYPE(GET)  NAME(nSpravReNa)      FPOS(41, 4.2) FLEN( 12)
    TYPE(Text) CAPTION( %)           CPOS(54, 1.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(54, 2.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(54, 3.2) CLEN(  3) FONT(2)
    TYPE(Text) CAPTION( %)           CPOS(54, 4.2) CLEN(  3) FONT(2)

  TYPE(End)