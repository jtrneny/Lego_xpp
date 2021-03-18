TYPE(drgForm) DTYPE(10) TITLE();
              SIZE( 65, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

*TYPE(Action) CAPTION( ~Pøecenìní skladu)  EVENT() TIPTEXT(Automatizované pøecenìní z kalkulací)
*TYPE(Action) CAPTION( ~Akt.pøímých mezd)  EVENT() TIPTEXT(Automatizovaná aktualizace pøímých mezd z kalkulací)

  TYPE(Static) STYPE(12) SIZE(64.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction)             CPOS( 0.2, 0) BGND(12) CLEN( 64.6)  FONT(2) CTYPE(3)

    TYPE(GET)  NAME(m->cCisSKLAD)           FPOS( 20, 2) FLEN( 12) FCAPTION( Èíslo skladu) CPOS( 2, 2 ) PUSH(SKLADY_sel)
    TYPE(Text) NAME(C_SKLADY->cNazSklad)    CPOS( 34, 2) CLEN( 30) BGND(13) FONT(5)
    TYPE(GET)  NAME(m->cTypPol)             FPOS( 20, 3) FLEN( 12) FCAPTION( Typ vyrábìné položky) CPOS( 2, 3 ) PUSH(TYPPOL_sel)
    TYPE(Text) NAME(C_TypPOL->cNazTypPol)   CPOS( 34, 3) CLEN( 30) BGND(13) FONT(5)

    TYPE(PushButton) POS( 10, 6) SIZE(25,1.2) CAPTION(~Spustit podklady operace) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 40, 6) SIZE(12,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)