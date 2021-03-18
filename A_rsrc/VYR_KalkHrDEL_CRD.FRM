TYPE(drgForm) DTYPE(10) TITLE(HROMADNÉ RUŠENÍ KALKULACÍ) SIZE(80, 7);
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n)
*              POST(postValidate) CBSAVE(OnSave)

TYPE(Action) CAPTION(~Spustit rušení)  EVENT(btn_KalkDEL) TIPTEXT(Spustit hromadné rušení kalkulací)
*
  TYPE(Static) STYPE(12) SIZE(79,1.4) FPOS(0.5,0.1) RESIZE(yn)
    TYPE(Text) CAPTION(Nastavení parametrù hromadného rušení) CPOS( 2, 0.2) CLEN( 76) CTYPE(3) FONT(5)
  TYPE(End)

* Nastavení parametrù hromadného rušení KALKULACE
  TYPE(Static) STYPE(13) SIZE(79,5.4) FPOS(0.5, 1.5) RESIZE(yn)
    TYPE(GET)      NAME(M->dDatumOd)      FPOS(20, 1.2) FLEN( 15) FCAPTION(Èasový interval     Od:) CPOS( 1, 1.2) PUSH(ClickDate)
    TYPE(GET)      NAME(M->dDatumDo)      FPOS(42, 1.2) FLEN( 15) FCAPTION(Do:)                     CPOS(37, 1.2) PUSH(ClickDate)
  TYPE(End)
