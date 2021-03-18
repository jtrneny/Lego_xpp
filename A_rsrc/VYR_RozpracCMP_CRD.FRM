TYPE(drgForm) DTYPE(10) TITLE(NEDOKONÈENÁ VÝROBA) SIZE(100,15);
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n);
              POST(postValidate)

TYPE(Action) CAPTION(~Spustit výpoèet)  EVENT(btn_RozpracCmp) TIPTEXT(Spustit výpoèet nedokonèené výroby)
*
  TYPE(Static) STYPE(12) SIZE(99,1.4) FPOS(0.5,0.1) RESIZE(yn)
    TYPE(Text) CAPTION(Nastavení parametrù výpoètu nedokonèené výroby) CPOS( 2, 0.2) CLEN( 96) CTYPE(3) FONT(5)
  TYPE(End)

* Nastavení výpoètu NEDOKONÈENÉ VÝROBY
  TYPE(Static) STYPE(13) SIZE(99,5) FPOS(0.5, 1.5) RESIZE(yn)
    TYPE(COMBOBOX) NAME(M->cREL)            FPOS(18, 0.4) FLEN( 7) FCAPTION(Období výpoètu)       CPOS( 1, 0.4) PP(2) VALUES(=:=,<=:<=)
    TYPE(COMBOBOX) NAME(M->nObdobi)         FPOS(26, 0.4) FLEN(13) REF( MESICE)
    TYPE(GET)      NAME(M->nRok)            FPOS(41, 0.4) FLEN( 5)
    TYPE(COMBOBOX) NAME(M->lVypocetPlanu)   FPOS(18, 1.4) FLEN( 7) FCAPTION(Vèetnì výpoètu plánu) CPOS( 1, 1.4) REF( LYESNO)
  TYPE(End)
*
  TYPE(Static) STYPE(13) SIZE(99,8.2)  FPOS(0.5, 6.6) RESIZE(yn) CTYPE(2)
  TYPE(End)