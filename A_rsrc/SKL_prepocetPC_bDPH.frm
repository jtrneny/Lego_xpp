TYPE(drgForm) DTYPE(10) TITLE(Pøepoèet prodejních cen bez Dph);
              SIZE( 55, 8) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(54.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) CAPTION(Zvýšení-pøepoèet prodejních cen bez DPH) CPOS( 0.2, 0) BGND(12) CLEN( 54.6)  FONT(2) CTYPE(3)

    TYPE(GET)  NAME(m->nProcEdit)           FPOS( 22, 2) FLEN( 12) FCAPTION( Zvýšení prodejní ceny o ) CPOS( 2, 2 )
    TYPE(Text) CAPTION(%)                   CPOS( 36, 2) CLEN( 4.0)  FONT(2) 
    TYPE(GET)  NAME(m->nZpusZaok)           FPOS( 22, 3) FLEN( 12) FCAPTION( Zpùsob zaokrouhlení     ) CPOS( 2, 3 ) PUSH( c_zaokr)

    TYPE(PushButton) POS( 10, 6) SIZE(12,1.2) CAPTION(~Start ) EVENT( btn_START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS( 30, 6) SIZE(12,1.2) CAPTION(S~torno) EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)