TYPE(drgForm) DTYPE(10) TITLE();
              SIZE( 65, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

*TYPE(Action) CAPTION( ~P�ecen�n� skladu)  EVENT() TIPTEXT(Automatizovan� p�ecen�n� z kalkulac�)
*TYPE(Action) CAPTION( ~Akt.p��m�ch mezd)  EVENT() TIPTEXT(Automatizovan� aktualizace p��m�ch mezd z kalkulac�)

  TYPE(Static) STYPE(12) SIZE(64.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction)             CPOS( 0.2, 0) BGND(12) CLEN( 64.6)  FONT(2) CTYPE(3)

    TYPE(GET)  NAME(m->cCisSKLAD)           FPOS( 20, 2) FLEN( 12) FCAPTION( ��slo skladu) CPOS( 2, 2 ) PUSH(SKLADY_sel)
    TYPE(Text) NAME(C_SKLADY->cNazSklad)    CPOS( 34, 2) CLEN( 30) BGND(13) FONT(5)
    TYPE(GET)  NAME(m->cTypPol)             FPOS( 20, 3) FLEN( 12) FCAPTION( Typ vyr�b�n� polo�ky) CPOS( 2, 3 ) PUSH(TYPPOL_sel)
    TYPE(Text) NAME(C_TypPOL->cNazTypPol)   CPOS( 34, 3) CLEN( 30) BGND(13) FONT(5)

    TYPE(PushButton) POS( 10, 6) SIZE(25,1.2) CAPTION(~Spustit podklady operace) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 40, 6) SIZE(12,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)