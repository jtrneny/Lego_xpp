TYPE(drgForm) DTYPE(10) TITLE() FILE(PVPHEAD);
              SIZE( 90, 7) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(89,1.4) FPOS(0.5,0.1) RESIZE(yn) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(Párování dokladu dle V-symbolu) CPOS( 2, 0.2) CLEN( 86) CTYPE(3) FONT(5)
  TYPE(End)

  TYPE(Static) STYPE( 13) SIZE(89, 3.5) FPOS( 0.5, 1.5) RESIZE(yx)

    TYPE(Text) CAPTION(Doklad)            CPOS(  3, 0.8)   CLEN( 12)
    TYPE(Text) NAME(nDoklad)              CPOS(  3, 1.8)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(Cena na dokl.)     CPOS( 17, 0.8)   CLEN( 12)
    TYPE(Text) NAME(nCenaDokl)            CPOS( 17, 1.8)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Sklad)             CPOS( 31, 0.8)   CLEN(  7)
    TYPE(Text) NAME(cCisSklad)            CPOS( 31, 1.8)   CLEN( 10) BGND( 13) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 43, 0.8)   CLEN(  7)
    TYPE(Text) NAME(cTypPohybu)           CPOS( 43, 1.8)   CLEN( 10) BGND( 13) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Variabilní symbol) CPOS( 56, 0.8)   CLEN( 15)
    TYPE(GET)  NAME(M->cVarSym)           FPOS( 56, 1.8)   FLEN( 20) BGND( 13) FONT(5) PICTURE(XXXXXXXXXXXXXXX)

  TYPE(END)

  TYPE(PushButton) POS(60, 5.5) SIZE(12,1.2) CAPTION( ~OK   )   EVENT(btn_GoParovani) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS(75, 5.5) SIZE(12,1.2) CAPTION(~Storno)   EVENT(140000002)             ICON1(102) ICON2(202) ATYPE(3)
