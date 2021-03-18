TYPE(drgForm) DTYPE(10) TITLE(Nastavení aktuálních KALKULACÍ) SIZE(80, 7);
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(~Spustit aktual.)  EVENT(btn_KalkAKT) TIPTEXT(Spustit hromadné nastavení aktuálních kalkulací)
*
  TYPE(Static) STYPE(12) SIZE(79,1.4) FPOS(0.5,0.1) RESIZE(yn)
    TYPE(Text) CAPTION(Nastavení parametrù aktuální kalkulace) CPOS( 2, 0.2) CLEN( 76) CTYPE(3) FONT(5)
  TYPE(End)

* Nastavení parametrù aktuální KALKULACE
  TYPE(Static) STYPE(13) SIZE(79,5.4) FPOS(0.5, 1.5) RESIZE(yn)
    TYPE(GET)      NAME(M->dDatumKALK)      FPOS(20, 1.2) FLEN( 15) FCAPTION(Den kalkulace:) CPOS( 1, 1.2) PUSH(ClickDate)
    TYPE(GET)      NAME(M->nPoradiKALK)     FPOS(52, 1.2) FLEN( 15) FCAPTION(Poøadí ve dni:) CPOS(37, 1.2)
  TYPE(End)