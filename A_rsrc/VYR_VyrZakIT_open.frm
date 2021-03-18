TYPE(drgForm) DTYPE(10) TITLE(Znovuotevøení položky zakázky) FILE(VYRZAKIT);
              SIZE( 90, 6) GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( PostValidate)

TYPE(Action) CAPTION(info ~Zakázky) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)

  TYPE(Static) STYPE(12) SIZE(89.8, 2.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(GET)  NAME(M->CCISZAKAZI)    FPOS(  3, 1.3)   FLEN( 38) FCAPTION(Èíslo položky zakázky)  CPOS( 3, 0.3)
    TYPE(GET)  NAME(M->cNazevZak1)    FPOS( 44, 1.3)   FLEN( 44) FCAPTION(Název zakázky)          CPOS(44, 0.3)
  TYPE(END)

  TYPE(GET)  NAME( M->dZnovuOtvZ) FPOS( 30, 4)   FLEN( 12) FCAPTION( Datum znovuotevøení položky zakázky) CPOS( 3, 4) PUSH(CLICKDATE) POST( PostLastField)

  