TYPE(drgForm) DTYPE(10) TITLE(Ro�n� ��etn� a da�ov� z�v�rka ) ;
              SIZE( 75, 20) GUILOOK(Message:y,Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(74.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yn)
    TYPE(Text) CAPTION(��ETN�  A  DA�OV�  Z�V�RKA  ZA  ROK)  CPOS(  4, 0.3)   CLEN( 38)  FONT(7)
    TYPE(Text) NAME(M->nROK)                                 CPOS( 42, 0.3)   CLEN(  8)  FONT(7)
*
    TYPE(Static) FPOS( 4,1.5) SIZE(65,3) STYPE(2) CAPTION() RESIZE(xx)
      TYPE(CHECKBOX) NAME( M->lDouctovat)       FPOS( 1, 1)   FLEN(40) ;
         VALUES(T:do��tovat p��padn� rozd�ly do v��e pl�nu,;
                F:do��tovat p��padn� rozd�ly do v��e pl�nu)
    TYPE(END)

    TYPE(PushButton) POS(32, 7) SIZE(17,1.2) CAPTION(s~Tart z�v�rky ) EVENT(StartZaverka) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(52, 7) SIZE(17,1.2) CAPTION(~Storno z�v�rky) EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)
  TYPE(END)
*
  TYPE(Static) STYPE(12) SIZE( 74, 11) FPOS( 0.5, 9) RESIZE(yy)
    TYPE(Static) STYPE( 12) SIZE(74, 1.2) FPOS(0.5, 0) RESIZE(yn)
      TYPE(Text)   CAPTION(Protokol o chyb�ch)      CPOS( 1, 0.1) CLEN( 20) FONT(5)
    TYPE(End)
    TYPE(MLE)  NAME(M->cErrorLog) FPOS(0.2, 1.2) SIZE(74, 9.5) RESIZE(yy) READONLY(y)
  TYPE(End)
