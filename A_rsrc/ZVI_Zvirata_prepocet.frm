TYPE(drgForm) DTYPE(10) TITLE(P�epo�et souboru Zvirata ) ;
              SIZE( 60, 9) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(59.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) CAPTION(P�epo�et souboru operativn� evidence skotu)  CPOS( 4, 0.3) CLEN( 40)  FONT(5)

* Export SKOTU
    TYPE(Static) FPOS( 4,1.5) SIZE(50,2) STYPE(2) CAPTION() RESIZE(xx)
     TYPE(Text) CAPTION(Od data zm�ny :) CPOS( 4, 1) CLEN( 15)
     TYPE(GET) NAME(M->dDatumOD)        FPOS(20, 1) FLEN( 12)  PUSH( CLICKDATE)
    TYPE(END)

    TYPE(PushButton) POS(5,  6) SIZE(18,1.2) CAPTION(~P�epo�et spustit ) EVENT(Start)       PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(26, 6) SIZE(18,1.2) CAPTION(~Storno p�epo�tu  ) EVENT(140000002)          ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)