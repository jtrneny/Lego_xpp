TYPE(drgForm) DTYPE(10) TITLE();
              SIZE( 65, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(64.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction)  CPOS( 0.2, 0) BGND(12) CLEN( 64.6)  FONT(2) CTYPE(3)

    TYPE(GET)  NAME(m->cObdobi)        FPOS( 15, 2) FLEN( 4) FCAPTION( Za období)       CPOS( 2, 2 ) PICTURE(99/99)
    TYPE(TEXT) CAPTION(MM/RR)          CPOS( 21, 2) CLEN( 6)
    TYPE(GET)  NAME(m->cSklPol_Od)     FPOS( 15, 3) FLEN( 18) FCAPTION( Skl.položka Od) CPOS( 2, 3 ) PUSH(CENZBOZ_sel)
    TYPE(GET)  NAME(m->cSklPol_Do)     FPOS( 40, 3) FLEN( 18) FCAPTION( Do)             CPOS(36, 3 ) PUSH(CENZBOZ_sel)

    TYPE(PushButton) POS( 10, 6) SIZE(25,1.2) CAPTION(~Spustit podklady operace) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 40, 6) SIZE(12,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)