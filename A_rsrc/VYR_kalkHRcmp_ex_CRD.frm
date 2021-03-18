TYPE(drgForm) DTYPE(10) TITLE(HROMADN� KALKULACE_ex) SIZE(100,15) FILE(KALKULw);
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n);
              POST(postValidate)

TYPE(Action) CAPTION(~Spustit v�po�et)  EVENT(btn_KalkCMP) TIPTEXT(Spustit v�po�et hromadn� kalkulace)
*
  TYPE(Static) STYPE(12) SIZE(99,1.4) FPOS(0.5,0.1) RESIZE(yn)
    TYPE(Text) CAPTION(Nastaven� parametr� v�po�tu hromadn� kalkulace) CPOS( 2, 0.2) CLEN( 96) CTYPE(3) FONT(5)
  TYPE(End)

* Nastaven� v�po�tu hromadn� KALKULACE
  TYPE(Static) STYPE(13) SIZE(99,5) FPOS(0.5, 1.5) RESIZE(yn)
    TYPE(COMBOBOX) NAME(nTypRezie)         FPOS(17, 0.4) FLEN( 13) FCAPTION(Typ re�ie)           CPOS( 1, 0.4) PP(2)
    TYPE(GET)      NAME(M->nMnKalk)        FPOS(17, 1.4) FLEN( 12) FCAPTION(Kalkula�n� mno�stv�) CPOS( 1, 1.4) PP(2) PICTURE(@N 99,999,999.99)
    TYPE(GET)      NAME(nMnozDavky)        FPOS(17, 2.4) FLEN( 12) FCAPTION(Mno�stv� v d�vce)    CPOS( 1, 2.4) PP(2)

    TYPE(COMBOBOX) NAME(cDruhCeny)         FPOS(50, 0.4) FLEN( 16) FCAPTION(Druh ceny materi�lu) CPOS(32, 0.4) PP(2)
    TYPE(GET)      NAME(cZkratMENY)        FPOS(50, 1.4) FLEN( 15) FCAPTION(M�na kalkulace)      CPOS(32, 1.4) PP(2)
    TYPE(COMBOBOX) NAME(cTypKalk)          FPOS(50, 2.4) FLEN( 16) FCAPTION(Typ kalkulace)       CPOS(32, 2.4) PP(2)

    TYPE(GET)      NAME(nRokVyp)           FPOS(80, 0.4) FLEN( 12) FCAPTION(Rok v�po�tu)         CPOS(68, 0.4) PP(2)
    TYPE(GET)      NAME(nObdMes)           FPOS(80, 1.4) FLEN( 12) FCAPTION(Obdob�)              CPOS(68, 1.4) PP(2)
    TYPE(GET)      NAME(dDatAktual)        FPOS(80, 2.4) FLEN( 12) FCAPTION(Den - datum)         CPOS(68, 2.4) PP(2) PUSH(CLICKDATE)
    TYPE(GET)      NAME(nPorKalDen)        FPOS(80, 3.4) FLEN( 12) FCAPTION(Po�ad� ve dnu)       CPOS(68, 3.4) PP(2)
  TYPE(End)
*
  TYPE(Static) STYPE(13) SIZE(99,8.2)  FPOS(0.5, 6.6) RESIZE(yn) CTYPE(2)
    TYPE(GET)      NAME(nZiskProcP)        FPOS(20, 0.4) FLEN( 12) FCAPTION(Procento zisku )        CPOS( 1, 0.4)
    TYPE(COMBOBOX) NAME(M->lKalkToCen)     FPOS(20, 1.4) FLEN( 13) FCAPTION(P�en�st do cen�ku)      CPOS( 1, 1.4) REF( LYESNO)
    TYPE(COMBOBOX) NAME(M->lKalkSetAKT)    FPOS(20, 2.4) FLEN( 13) FCAPTION(Nastavit jako aktu�ln�) CPOS( 1, 2.4) REF( LYESNO)
*    TYPE(GET)      NAME(M->cVyrPolOD)      FPOS(20, 3.4) FLEN( 20) FCAPTION(V�po�et v rozsahu Od:)  CPOS( 1, 3.4) PUSH(VYRPOL_SEL)
*    TYPE(GET)      NAME(M->cVyrPolDO)      FPOS(47, 3.4) FLEN( 20) FCAPTION(Do:)                    CPOS(42, 3.4) PUSH(VYRPOL_SEL)

    TYPE(Text) CAPTION(KALKULACE)         CPOS(60,0.5) CLEN(10) FONT(4) SIZE(30,1.0) CTYPE(3)
    TYPE(Text) NAME(M->ctypKalk)          CPOS(60,1.8) CLEN(10) FONT(5) SIZE(30,1.0) CTYPE(3)


    TYPE(TEXT)     CAPTION(Po�et z�znam� ke zpracov�n� ->)  CPOS( 1, 7)  CLEN(24)
    TYPE(TEXT)     NAME(M->nrecCount)                       CPOS(25, 7)  CLEN(10) BGND(13)
    TYPE(TEXT)     CAPTION(zpracov�no ->)                   CPOS(37, 7)  CLEN(12)
    TYPE(TEXT)     NAME(M->nrecNo)                          CPOS(50, 7)  CLEN(10) BGND(13)
  TYPE(End)