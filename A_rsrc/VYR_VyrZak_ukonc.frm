TYPE(drgForm) DTYPE(10) TITLE(Ukon�en� zak�zky) FILE(VYRZAK);
              SIZE( 80, 6) GUILOOK(Action:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(info ~Zak�zky) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informa�n� karta v�robn� zak�zky)

  TYPE(Static) STYPE(12) SIZE(79.8, 2.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) CAPTION(Zak�zka)               CPOS(  3, 0.3)   CLEN( 10)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.3)   CLEN( 40) BGND( 13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(N�zev zak�zky)         CPOS( 44, 0.3)   CLEN( 15)
    TYPE(Text) NAME(cNazevZak1)               CPOS( 44, 1.3)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrBLUE)
  TYPE(END)

  TYPE(GET)  NAME( M->dUzavZAKA) FPOS( 25, 4)   FLEN( 12) FCAPTION( Datum ukon�en� zak�zky) CPOS( 3, 4) PUSH(CLICKDATE) POST( PostLastField)

  