TYPE(drgForm) DTYPE(10) TITLE(Znovuotev�en� zak�zky) FILE(VYRZAK);
              SIZE( 90, 6) GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( PostValidate)

TYPE(Action) CAPTION(info ~Zak�zky) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informa�n� karta v�robn� zak�zky)

  TYPE(Static) STYPE(12) SIZE(89.8, 2.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(GET)  NAME(M->CCISZAKAZ)             FPOS(  3, 1.3)   FLEN( 38) FCAPTION(��slo zak�zky)  CPOS( 3, 0.3) PUSH(VYRZAK_SEL)
    TYPE(GET)  NAME(M->cNazevZak1)            FPOS( 44, 1.3)   FLEN( 44) FCAPTION(N�zev zak�zky)  CPOS(44, 0.3)
  TYPE(END)

  TYPE(GET)  NAME( M->dZnovuOtvZ) FPOS( 27, 4)   FLEN( 12) FCAPTION( Datum znovuotev�en� zak�zky) CPOS( 3, 4) PUSH(CLICKDATE) POST( PostLastField)

