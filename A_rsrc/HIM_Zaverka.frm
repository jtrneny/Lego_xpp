TYPE(drgForm) DTYPE(10) TITLE(Ro�n� ��etn� a da�ov� z�v�rka ) ;
              SIZE( 75, 9) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(74.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) CAPTION(RO�N� ��ETN� A DA�OV� Z�V�RKA)              CPOS( 4, 0.3)   CLEN( 35)  FONT(5)

* Export PRASAT
    TYPE(Static) FPOS( 4,1.5) SIZE(65,3) STYPE(2) CAPTION() RESIZE(xx)
      TYPE(CHECKBOX) NAME( M->lDouctovat)       FPOS( 1, 1)   FLEN(40) ;
         VALUES(T:do��tovat p��padn� rozd�ly do v��e pl�nu,;
                F:do��tovat p��padn� rozd�ly do v��e pl�nu)
    TYPE(END)

    TYPE(PushButton) POS(35, 7) SIZE(15,1.2) CAPTION(s~Tart z�v�rky )  EVENT(Start_prenos)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(53, 7) SIZE(15,1.2) CAPTION(~Storno z�v�rky)  EVENT(140000002)            ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)