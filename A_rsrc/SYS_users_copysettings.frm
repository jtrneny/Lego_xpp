TYPE(drgForm) DTYPE(10) TITLE(Kopírovat nastavení uživatele ) ;
              SIZE( 75, 13) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

*  TYPE(Static) STYPE(10) SIZE(74.8, 2.8) FPOS( 0.1, 0.1) RESIZE(yx)
*    TYPE(Text) CAPTION(Z  uživatele:)    CPOS( 4, 0.3)   CLEN( 13) FONT(2)
*    TYPE(GET)  NAME(M->cOsobaFROM)        FPOS(18, 0.3)   FLEN( 50) FONT(2) PUSH(users_sel)
*    TYPE(Text) CAPTION(Na uživatele:)    CPOS( 4, 1.3)   CLEN( 13) FONT(2)
*    TYPE(Text) NAME(Users->cOsoba)       CPOS(18, 1.3)   CLEN( 50) FONT(7)
*  TYPE(END)

*
  TYPE(Static) STYPE(12) SIZE(74.8, 2.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) CAPTION(Z  uživatele:)    CPOS( 4, 0.3)   CLEN( 13) FONT(2)
    TYPE(GET)  NAME(M->cOsobaFROM)       FPOS(18, 0.3)   FLEN( 49) FONT(2) PUSH(users_sel)
    TYPE(Text) CAPTION(Na uživatele:)    CPOS( 4, 1.4)   CLEN( 13) FONT(2)
    TYPE(Text) NAME(Users->cOsoba)       CPOS(18, 1.4)   CLEN( 50) FONT(4) BGND(13) GROUPS(clrGREEN)
  TYPE(END)

  TYPE(Static) FPOS( 0.1,3) SIZE(74.8,7) STYPE(12) CAPTION() RESIZE(xx)
*  TYPE(Static) FPOS( 4,2.9) SIZE(65,7) STYPE(2) CAPTION() RESIZE(xx)
    TYPE(Text) CAPTION(Položky ke kopírování:) CPOS( 4, 0.5)   CLEN( 18)
    TYPE(Text) CAPTION(Menu)           CPOS( 23, 0.5)   CLEN( 15)  FONT(7)
    TYPE(Text) CAPTION(Konfigurace)    CPOS( 23, 1.5)   CLEN( 15)  FONT(7)
    TYPE(Text) CAPTION(Oprávnìní)      CPOS( 23, 2.5)   CLEN( 15)  FONT(7)
    TYPE(Text) CAPTION(Formuláøe)      CPOS( 23, 3.5)   CLEN( 15)  FONT(7)
    TYPE(Text) CAPTION(Filtry)         CPOS( 23, 4.5)   CLEN( 15)  FONT(7)
    TYPE(Text) CAPTION(Komunikace)     CPOS( 23, 5.5)   CLEN( 15)  FONT(7)

    TYPE(CHECKBOX) NAME( M->isMenu)      FPOS( 40, 0.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cMenu)       CPOS( 45, 0.5) CLEN( 25)
    TYPE(CHECKBOX) NAME( M->isConfig)    FPOS( 40, 1.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cConfig)     CPOS( 45, 1.5) CLEN( 25)
    TYPE(CHECKBOX) NAME( M->isOpravneni) FPOS( 40, 2.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cOpravneni)  CPOS( 45, 2.5) CLEN( 25)
    TYPE(CHECKBOX) NAME( M->isForms)     FPOS( 40, 3.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cForms)      CPOS( 45, 3.5) CLEN( 25)
    TYPE(CHECKBOX) NAME( M->isFilters)   FPOS( 40, 4.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cFilters)    CPOS( 45, 4.5) CLEN( 25)
    TYPE(CHECKBOX) NAME( M->isKomunik)   FPOS( 40, 5.5) FLEN(3.5)  VALUES(T:,F:)
    TYPE(Text)     NAME( M->cKomunik)    CPOS( 45, 5.5) CLEN( 25)
  TYPE(END)

  TYPE(PushButton) POS(20, 11) SIZE(18,1.2) CAPTION(s~Tart kopírování ) EVENT(Start_copy)   PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS(40, 11) SIZE(18,1.2) CAPTION(~Storno kopírování) EVENT(140000002)           ICON1(102) ICON2(202) ATYPE(3)

  TYPE(END)