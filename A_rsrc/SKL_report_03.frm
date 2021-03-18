TYPE(drgForm) DTYPE(10) TITLE();
              SIZE( 65, 12) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(64.8, 11.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction) CPOS( 0.2, 0) BGND(12) CLEN( 64.6)  FONT(2) CTYPE(3)

    TYPE(GET)  NAME(m->cObdobi)        FPOS( 15, 2) FLEN(  4) FCAPTION( Za období)      CPOS( 2, 2 ) PICTURE(99/99)
    TYPE(TEXT) CAPTION(MM/RR)          CPOS( 21, 2) CLEN( 6)
    TYPE(GET)  NAME(m->cPohyb_Od)      FPOS( 15, 3) FLEN( 18) FCAPTION( Pohyb Od)       CPOS( 2, 3 ) PUSH(TypPohybu_sel)
    TYPE(GET)  NAME(m->cPohyb_Do)      FPOS( 40, 3) FLEN( 18) FCAPTION( Do)             CPOS(36, 3 ) PUSH(TypPohybu_sel)
    TYPE(GET)  NAME(m->cVykon_Od)      FPOS( 15, 4) FLEN( 18) FCAPTION( Výkon Od)       CPOS( 2, 4 ) PUSH(NAZPOLn_sel)
    TYPE(GET)  NAME(m->cVykon_Do)      FPOS( 40, 4) FLEN( 18) FCAPTION( Do)             CPOS(36, 4 ) PUSH(NAZPOLn_sel)
    TYPE(GET)  NAME(m->cSklPol_Od)     FPOS( 15, 5) FLEN( 18) FCAPTION( Skl.položka Od) CPOS( 2, 5 ) PUSH(CENZBOZ_sel)
    TYPE(GET)  NAME(m->cSklPol_Do)     FPOS( 40, 5) FLEN( 18) FCAPTION( Do)             CPOS(36, 5 ) PUSH(CENZBOZ_sel)

    TYPE(PushButton) POS( 10, 10) SIZE(25,1.2) CAPTION(~Spustit generování podkladù) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 40, 10) SIZE(12,1.2) CAPTION(~Storno)                      EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)