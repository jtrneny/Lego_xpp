TYPE(drgForm) DTYPE(10) TITLE(N�vrat do minul�ho obdob� ) ;
              SIZE( 60, 9) GUILOOK(Message:y,Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(59.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yn)
    TYPE(Text) CAPTION(N�VRAT DO MINUL�HO OBDOB� )  CPOS(  4, 0.3)   CLEN( 38)  FONT(7) CTYPE(3)
*
    TYPE(Static) FPOS( 4,1.5) SIZE(45,3) STYPE(2) CAPTION() RESIZE(xx)
      TYPE(Text) CAPTION( Posledn� zalo�en� obdob� :)    CPOS(  4, 1) CLEN( 20)
      TYPE(Text) NAME(M->cLastOBD)                       CPOS( 30, 1) CLEN(  8) FONT(5) BGND(13)GROUPS(clrGREEN)
      TYPE(Text) CAPTION( Mo�n� n�vrat do obdob� :)      CPOS(  4, 2) CLEN( 20)
      TYPE(Text) NAME(M->cPrevOBD)                       CPOS( 30, 2) CLEN(  8) FONT(5) BGND(13) GROUPS(clrGREEN)
    TYPE(END)

    TYPE(PushButton) POS(12, 7) SIZE(17,1.2) CAPTION(~Spustit n�vrat ) EVENT(Start)    PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(32, 7) SIZE(17,1.2) CAPTION(s~Torno n�vratu ) EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)
  TYPE(END)
