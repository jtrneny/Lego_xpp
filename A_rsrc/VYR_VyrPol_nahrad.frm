TYPE(drgForm) DTYPE(10) TITLE() FILE(VYRPOL);
              SIZE( 90, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

*TYPE(Action) CAPTION(info ~Zakázka)  EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)

  TYPE(Static) STYPE(12) SIZE(89.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction)              CPOS( 3, 0.3)   CLEN( 15)  FONT(5)

    TYPE(Text) CAPTION(Zakázka)              CPOS( 19, 1.3)   CLEN( 10) FONT(2)
    TYPE(Text) CAPTION(Vyrábìná položka)     CPOS( 56, 1.3)   CLEN( 20) FONT(2)
    TYPE(Text) CAPTION(Varianta)             CPOS( 78, 1.3)   CLEN(  8) FONT(2)
    TYPE(Text) CAPTION(Pùvodní oznaèení :)   CPOS(  3, 2.3)   CLEN( 15)
    TYPE(Text) CAPTION(Nové    oznaèení :)   CPOS(  3, 3.5)   CLEN( 15)
*
    TYPE(Text) NAME(cCisZakaz)                CPOS( 19, 2.3)   CLEN( 36) BGND( 13) FONT(5)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 56, 2.3)   CLEN( 21) BGND( 13) FONT(5)
    TYPE(Text) NAME(nVarCis)                  CPOS( 78, 2.3)   CLEN(  9) BGND( 13) FONT(5)

    TYPE(GET)  NAME(M->newZAK)                FPOS( 19, 3.5)   FLEN( 35) BGND( 13) FONT(5) PICTURE &X30
    TYPE(GET)  NAME(M->newPOL)                FPOS( 56, 3.5)   FLEN( 20) BGND( 13) FONT(5) PICTURE &X15
    TYPE(GET)  NAME(M->newVAR)                FPOS( 78, 3.5)   FLEN(  8) BGND( 13) FONT(5)

    TYPE(PushButton) POS(60, 6) SIZE(12,1.2) CAPTION( ~OK    )    EVENT(But_SAVE)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(75, 6) SIZE(12,1.2) CAPTION(~Storno)     EVENT(140000002)        ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)