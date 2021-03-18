TYPE(drgForm) DTYPE(1) TITLE(Investièní majetek) SIZE(75,15) FILE(C_MAJ );
              GUILOOK(Action:n,IconBar:n,Menu:n);
              POST( POSTVALIDATE)

*TYPE(Action) CAPTION(~Nìjaká ekšn) EVENT() TIPTEXT()

TYPE(Static) STYPE(12) SIZE(74, 3.5) RESIZE(yn) FPOS( 0.5,0.1) CTYPE(2)

  TYPE(Text) CAPTION(Inventární è.)  CPOS( 4, 0.4) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(nInvCis)           FPOS( 4, 1.4) FLEN( 15) FONT(5) PP(2) NOREVISION()
*  TYPE(Text) CAPTION(Inventární è.DIM)  CPOS( 4, 0.4) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(nInvCisDim)           FPOS( 4, 1.4) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Název majetku)  CPOS(21, 0.4) CLEN( 15) FONT(2)
  TYPE(GET)  NAME(cNazevMaj)         FPOS(21, 1.4) FLEN( 50) FONT(5) PP(2)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) FPOS( 0,3.7) SIZE( 75, 11) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74, 9.5) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(COMBOBOX) NAME(cTypMaj)              FPOS(20, 1) FLEN( 16) FCAPTION(Typ majetku)        CPOS( 1, 1)
      TYPE(GET)      NAME(nZivotNh)             FPOS(20, 2) FLEN( 15) FCAPTION(Životnost majetku)  CPOS( 1, 2)
      TYPE(GET)      NAME(cZkratJEDN)           FPOS(20, 3) FLEN( 15) FCAPTION(Mìrná jednotka)     CPOS( 1, 3)
*      TYPE(Text)     NAME(C_JEDNOT->cNazJednot) CPOS(37, 3) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cPouzMaj)             FPOS(20, 4) FLEN( 15) FCAPTION(Použití majetku)    CPOS( 1, 4)
    TYPE(End)
  TYPE(END)

* Popis majetku
  TYPE(TabPage) TTYPE(4) CAPTION(Popis majetku) FPOS( 0,3.7) SIZE( 75, 11) OFFSET(24,52)
    TYPE(MLE) NAME(mPopisMAJ) FPOS(1, 0.5) SIZE(73, 9)
  TYPE(End)

* Návod na použití
  TYPE(TabPage) TTYPE(4) CAPTION(Návod na použití) FPOS( 0,3.7) SIZE( 75, 11) OFFSET(47,29)
    TYPE(MLE) NAME(mNavodPouz) FPOS(1, 0.5) SIZE(73, 9)
  TYPE(End)