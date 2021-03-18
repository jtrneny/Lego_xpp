TYPE(drgForm) DTYPE(10) TITLE(Pøepoèet souboru Zvirata ) ;
              SIZE( 75, 9) GUILOOK(Action:y,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(74.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(Pøepoèet souboru operativní evidence skotu)       CPOS( 4, 0.3)   CLEN( 35)  FONT(5)

* Export SKOTU
    TYPE(Static) FPOS( 4,1.5) SIZE(65,3) STYPE(2) CAPTION() RESIZE(xx)
     TYPE(Text) NAME(Od data zmìny) CPOS( 4, 1) CLEN( 15)  FONT(5)
*     TYPE(GET)  NAME(M->dDatumOD)   FPOS(27, 1) FLEN( 12)  PUSH( CLICKDATE)
    TYPE(END)

    TYPE(PushButton) POS(5, 7) SIZE(15,1.2) CAPTION(~Pøenos spustit )  EVENT(Start_prepoctu)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(23, 7) SIZE(15,1.2) CAPTION(~Storno pøenosu ) EVENT(140000002)              ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)