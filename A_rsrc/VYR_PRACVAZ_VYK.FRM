TYPE(drgForm) DTYPE(10) TITLE(Vykazování vazeb pracoviš na den) SIZE(100,10) FILE(PRACVAZ);
              GUILOOK(Action:n,IconBar:n,Menu:n);
              POST( PostValidate)

*TYPE(Action) CAPTION(~Zaplánovat ) EVENT() TIPTEXT(Zaplánovat vazby na daný den)

  TYPE(Static) STYPE(13) SIZE( 99,3) FPOS( 0.5, 0.1)  RESIZE(yn)
    TYPE(Text) CAPTION(Zadej èíslo vazby :) CPOS(  1, 1) CLEN( 20) FONT(7)
    TYPE(GET)  NAME(M->cIdVazby)            FPOS( 21, 1) FLEN( 20) FONT(5) PICTURE(&12X)PP(2)
    TYPE(Text) CAPTION(Datum vykázání :)    CPOS( 50, 1) CLEN( 20) FONT(7)
    TYPE(GET)  NAME(M->dDatVykaz)           FPOS( 71, 1) FLEN( 15) FONT(5) PP(2) PUSH( clickDate)
  TYPE(End)