TYPE(drgForm) DTYPE(10) TITLE() FILE(PVPHEAD);
              SIZE( 90, 9.5) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(89,1.4) FPOS(0.5,0.1) RESIZE(yn) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(Párování dokladu dle V-symbolu) CPOS( 2, 0.2) CLEN( 86) CTYPE(3) FONT(5)
  TYPE(End)

  TYPE(Static) STYPE( 13) SIZE(89, 6) FPOS( 0.5, 1.5) RESIZE(yx)

    TYPE(Text) CAPTION(Doklad)            CPOS(  3, 0.8)   CLEN( 12)
    TYPE(Text) NAME(nDoklad)              CPOS(  3, 1.8)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(Sklad)             CPOS( 17, 0.8)   CLEN(  7)
    TYPE(Text) NAME(cCisSklad)            CPOS( 17, 1.8)   CLEN( 10) BGND( 13) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 29, 0.8)   CLEN(  7)
    TYPE(Text) NAME(cTypPohybu)           CPOS( 29, 1.8)   CLEN( 10) BGND( 13) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Èíslo faktury)     CPOS( 61, 0.8)   CLEN( 12)
    TYPE(GET)  NAME(M->nCisFak)           FPOS( 59, 1.8)   FLEN( 11) BGND( 13) FONT(5) PICTURE(9999999999)
    TYPE(Text) CAPTION(Èíslo dod.listu)   CPOS( 76, 0.8)   CLEN( 12)
    TYPE(GET)  NAME(M->nCisloDL)          FPOS( 74, 1.8)   FLEN( 11) BGND( 13) FONT(5) PICTURE(9999999999)

    TYPE(Text) CAPTION(Cena na dokl.)     CPOS(  3, 3 )   CLEN( 12)
    TYPE(Text) NAME(nCenaDokl)            CPOS(  3, 4 )   CLEN( 11) BGND( 13) CTYPE(2) GROUPS( clrGREY)
    TYPE(Text) CAPTION(+)                 CPOS( 15, 4 )   CLEN(  2)
    TYPE(Text) CAPTION(Nutné VN)          CPOS( 17, 3 )   CLEN(  9)
    TYPE(Text) NAME(nNutneVN)             CPOS( 17, 4 )   CLEN( 11) BGND( 13) CTYPE(2) GROUPS( clrGREY)
    TYPE(Text) CAPTION(-)                 CPOS( 29, 4 )   CLEN(  2)
    TYPE(Text) CAPTION(Suma položek)      CPOS( 31, 3 )   CLEN( 11)
    TYPE(Text) NAME(nCenaPol)             CPOS( 31, 4 )   CLEN( 11) BGND( 13) CTYPE(2) GROUPS( clrGREY)
    TYPE(Text) CAPTION(=)                 CPOS( 42, 4 )   CLEN(  2)
    TYPE(Text) CAPTION(Kontrolní rozdíl)  CPOS( 44, 3 )   CLEN( 12)
    TYPE(Text) NAME(nRozPrij)             CPOS( 44, 4 )   CLEN( 14) BGND( 13) CTYPE(2) GROUPS( clrGREY)

  TYPE(END)

  TYPE(PushButton) POS(60, 8) SIZE(12,1.2) CAPTION( ~Párování)  EVENT(btn_GoParovani) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS(75, 8) SIZE(12,1.2) CAPTION(~Storno)     EVENT(140000002)             ICON1(102) ICON2(202) ATYPE(3)
