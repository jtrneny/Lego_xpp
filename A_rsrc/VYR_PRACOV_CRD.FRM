TYPE(drgForm) DTYPE(10) TITLE(PracoviötÏ) SIZE(75,24) FILE(C_PRACOVw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

*TYPE(Action) CAPTION(~NÏjak· ekön) EVENT() TIPTEXT()

TYPE(Static) STYPE(12) SIZE(74, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)

  TYPE(Text) CAPTION(PracoviötÏ)       CPOS( 4, 0.4) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(cOznPrac)            FPOS( 4, 1.6) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(N·zev pracoviötÏ) CPOS(21, 0.4) CLEN( 15) FONT(2)
  TYPE(GET)  NAME(cNazevPrac)          FPOS(21, 1.6) FLEN( 50) FONT(5) PP(2)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 75,20.5) FPOS(0,3.7)  RESIZE(yy)

* Z¡KLADNÕ ⁄DAJE
  TYPE(TABPAGE) CAPTION(Z·kladnÌ ˙daje) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74,19) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypPracov)           FPOS(20, 1) FLEN( 15) FCAPTION(Typ pracoviötÏ)     CPOS( 1, 1)
      TYPE(GET)      NAME(cNazPol4)             FPOS(20, 2) FLEN( 15) FCAPTION(V˝robnÌ mÌsto)      CPOS( 1, 2)
      TYPE(Text)     NAME(cNazPol4->cNazev)     CPOS(37, 2) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cStred)               FPOS(20, 3) FLEN( 15) FCAPTION(V˝robnÌ st¯edisko)  CPOS( 1, 3)
      TYPE(Text)     NAME(C_Stred->cNazStr)     CPOS(37, 3) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nViceStroj)           FPOS(20, 4) FLEN( 15) FCAPTION(VÌcestrojov· obsluha)    CPOS( 1, 4)
      TYPE(GET)      NAME(nKoefViSt)            FPOS(20, 5) FLEN( 15) FCAPTION(Koef.vÌcestroj. obsluhy) CPOS( 1, 5)
      TYPE(GET)      NAME(nViceObslu)           FPOS(20, 6) FLEN( 15) FCAPTION(VÌceobsluûn˝ stroj)      CPOS( 1, 6)
      TYPE(GET)      NAME(nKoefViOb)            FPOS(20, 7) FLEN( 15) FCAPTION(Koef.vÌceobsl. stroje)   CPOS( 1, 7)
      TYPE(GET)      NAME(nKoefSmCas)           FPOS(20, 8) FLEN( 15) FCAPTION(Koef. smÏnovÈho Ëasu)    CPOS( 1, 8)
      TYPE(GET)      NAME(nDruhMzdy)            FPOS(20, 9) FLEN( 15) FCAPTION(Druh mzdy)               CPOS( 1, 9)
      TYPE(Text)     NAME(DruhyMzd->cNazevDmz)  CPOS(37, 9) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cPracZar)             FPOS(20,10) FLEN( 15) FCAPTION(PracovnÌ zaûazenÌ)       CPOS( 1,10)
      TYPE(Text)     NAME(C_PracZa->cNazPracZa) CPOS(37,10) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nPocPrac)             FPOS(20,11) FLEN( 15) FCAPTION(PoËet pracoviöù)         CPOS( 1,11)
      TYPE(COMBOBOX) NAME(lVykNorma)            FPOS(20,12) FLEN( 16) FCAPTION(V˝konov· norma)          CPOS( 1,12)
      TYPE(GET)      NAME(nTranMnoz)            FPOS(20,13) FLEN( 15) FCAPTION(TransportnÌ mn.)         CPOS( 1,13)
      TYPE(GET)      NAME(cTypKalend)           FPOS(20,14) FLEN( 15) FCAPTION(Typ pracov. kalend·¯e)   CPOS( 1,14)
      TYPE(GET)      NAME(nSazbaStro)           FPOS(20,15) FLEN( 15) FCAPTION(Sazba stroje)            CPOS( 1,15)
      TYPE(GET)      NAME(nPoradi)              FPOS(20,16) FLEN( 15) FCAPTION(Po¯adÌ)                  CPOS( 1,16)

    TYPE(End)
  TYPE(END)

* POPIS PRACOVIäTÃ
  TYPE(TabPage) TTYPE(4) CAPTION(Popis pracoviötÏ) OFFSET(24,52)
    TYPE(MLE) NAME(mPopisPrac) FPOS(1, 0.5) SIZE(73,18)
  TYPE(End)

TYPE(End)