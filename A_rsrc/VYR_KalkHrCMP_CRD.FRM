TYPE(drgForm) DTYPE(10) TITLE(HROMADNÁ KALKULACE) SIZE(100,15) FILE(KALKULw);
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n);
              POST(postValidate)

TYPE(Action) CAPTION(~Spustit výpoèet)  EVENT(btn_KalkCMP) TIPTEXT(Spustit výpoèet hromadné kalkulace)
*
  TYPE(Static) STYPE(12) SIZE(99,1.4) FPOS(0.5,0.1) RESIZE(yn)
    TYPE(Text) CAPTION(Nastavení parametrù výpoètu hromadné kalkulace) CPOS( 2, 0.2) CLEN( 96) CTYPE(3) FONT(5)
  TYPE(End)

* Nastavení výpoètu hromadné KALKULACE
  TYPE(Static) STYPE(13) SIZE(99,5) FPOS(0.5, 1.5) RESIZE(yn)
    TYPE(COMBOBOX) NAME(nTypRezie)         FPOS(17, 0.4) FLEN( 13) FCAPTION(Typ režie)           CPOS( 1, 0.4) PP(2)
    TYPE(GET)      NAME(M->nMnKalk)        FPOS(17, 1.4) FLEN( 12) FCAPTION(Kalkulaèní množství) CPOS( 1, 1.4) PP(2) PICTURE(@N 99,999,999.99)
    TYPE(GET)      NAME(nMnozDavky)        FPOS(17, 2.4) FLEN( 12) FCAPTION(Množství v dávce)    CPOS( 1, 2.4) PP(2)

    TYPE(COMBOBOX) NAME(cDruhCeny)         FPOS(50, 0.4) FLEN( 16) FCAPTION(Druh ceny materiálu) CPOS(32, 0.4) PP(2)
    TYPE(GET)      NAME(cZkratMENY)        FPOS(50, 1.4) FLEN( 15) FCAPTION(Mìna kalkulace)      CPOS(32, 1.4) PP(2)
    TYPE(COMBOBOX) NAME(cTypKalk)          FPOS(50, 2.4) FLEN( 16) FCAPTION(Typ kalkulace)       CPOS(32, 2.4) PP(2)

    TYPE(GET)      NAME(nRokVyp)           FPOS(80, 0.4) FLEN( 12) FCAPTION(Rok výpoètu)         CPOS(68, 0.4) PP(2)
    TYPE(GET)      NAME(nObdMes)           FPOS(80, 1.4) FLEN( 12) FCAPTION(Období)              CPOS(68, 1.4) PP(2)
    TYPE(GET)      NAME(dDatAktual)        FPOS(80, 2.4) FLEN( 12) FCAPTION(Den - datum)         CPOS(68, 2.4) PP(2) PUSH(CLICKDATE)
    TYPE(GET)      NAME(nPorKalDen)        FPOS(80, 3.4) FLEN( 12) FCAPTION(Poøadí ve dnu)       CPOS(68, 3.4) PP(2)
  TYPE(End)
*
  TYPE(Static) STYPE(13) SIZE(99,8.2)  FPOS(0.5, 6.6) RESIZE(yn) CTYPE(2)
    TYPE(GET)      NAME(nZiskProcP)        FPOS(20, 0.4) FLEN( 12) FCAPTION(Procento zisku )        CPOS( 1, 0.4)
    TYPE(COMBOBOX) NAME(M->lKalkToCen)     FPOS(20, 1.4) FLEN( 13) FCAPTION(Pøenést do ceníku)      CPOS( 1, 1.4) REF( LYESNO)
    TYPE(COMBOBOX) NAME(M->lKalkSetAKT)    FPOS(20, 2.4) FLEN( 13) FCAPTION(Nastavit jako aktuální) CPOS( 1, 2.4) REF( LYESNO)
*    TYPE(GET)      NAME(M->cVyrPolOD)      FPOS(20, 3.4) FLEN( 20) FCAPTION(Výpoèet v rozsahu Od:)  CPOS( 1, 3.4) PUSH(VYRPOL_SEL)
*    TYPE(GET)      NAME(M->cVyrPolDO)      FPOS(47, 3.4) FLEN( 20) FCAPTION(Do:)                    CPOS(42, 3.4) PUSH(VYRPOL_SEL)
  TYPE(End)