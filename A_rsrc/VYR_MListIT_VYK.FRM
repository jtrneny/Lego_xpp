TYPE(drgForm) DTYPE(10) TITLE(Vykazov·nÌ ML) SIZE(80,12) FILE(ListITw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( PostValidate)

TYPE(Action) CAPTION(info ~PracovnÌka) EVENT() TIPTEXT( InformaËnÌ kmenov˝ list pracovnÌka)
TYPE(Action) CAPTION(info ~Zak·zky)    EVENT(VYR_VYRZAK_INFO) TIPTEXT(InformaËnÌ karta v˝robnÌ zak·zky)


  TYPE(Static) STYPE(12) SIZE(79,1.4) FPOS(0.5,0.1) RESIZE(yn) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(VYK¡Z¡NÕ  MZDOV…HO  LÕSTKU) CPOS( 2, 0.2) CLEN( 76) CTYPE(3) FONT(5)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 79,7.8) FPOS( 0.5, 1.5)  RESIZE(yn)

    TYPE(Text) CAPTION( Os. ËÌslo pracovnÌka :) CPOS(  1, 1) CLEN( 22) FONT(7)
    TYPE(GET)  NAME( nOsCisPrac)                FPOS( 25, 1) FLEN( 10) FONT(5)
    TYPE(Text) NAME(MsPrc_MD->cPracovnik)       CPOS( 37, 1) CLEN( 29) BGND(12) GROUPS(clrGREY)

    TYPE(Text) CAPTION( »Ìslo zak·zky :)        CPOS(  1, 2.1) CLEN( 22) FONT(7)
    TYPE(GET)  NAME( cCisZakazI)                FPOS( 25, 2.1) FLEN( 40) FONT(5) PUSH()

    TYPE(Text) CAPTION( »Ìslo operace :)        CPOS(  1, 3.2) CLEN( 20) FONT(7)
    TYPE(GET)  NAME( cOznOper)                  FPOS( 25, 3.2) FLEN( 10) FONT(5)

    TYPE(Text) CAPTION( MnoûstvÌ :)             CPOS(  1, 5) CLEN( 20) FONT(7)
    TYPE(GET)  NAME( nKusyCelk)                 FPOS( 25, 5) FLEN( 10) FONT(5) BGND(13)
  TYPE(End)


*  TYPE(Static) STYPE(2) SIZE( 78, 2) FPOS( 0.5, 9.3) RESIZE(nx)
*    TYPE(PushButton) POS(30, 1) SIZE(12,1.2) CAPTION( ~Uloûit )  EVENT()  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
*    TYPE(PushButton) POS(45, 1) SIZE(12,1.2) CAPTION( ~Storno )  EVENT(140000002)        ICON1(102) ICON2(202) ATYPE(3)
*  TYPE(End)

  TYPE(PushButton) POS(30, 10.5) SIZE(12,1.2) CAPTION( ~Uloûit )  EVENT()  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS(45, 10.5) SIZE(12,1.2) CAPTION( ~Storno )  EVENT(140000002)        ICON1(102) ICON2(202) ATYPE(3)
