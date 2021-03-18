TYPE(drgForm) DTYPE(1) TITLE(Pracovní postup) SIZE(75,15) FILE(PRACPOST );
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE)

*TYPE(Action) CAPTION(~Nìjaká ekšn) EVENT() TIPTEXT()

TYPE(Static) STYPE(12) SIZE(74, 3.5) RESIZE(yn) FPOS( 0.5,0.1) CTYPE(2)

  TYPE(Text) CAPTION(Oznaèení)       CPOS( 4, 0.4) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(cOznPrPo)          FPOS( 4, 1.6) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Název postupu)  CPOS(21, 0.4) CLEN( 15) FONT(2)
  TYPE(GET)  NAME(cNazPrPo)          FPOS(21, 1.6) FLEN( 50) FONT(5) PP(2)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) FPOS( 0,3.7) SIZE( 75, 11) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74, 9.5) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypPrPo)             FPOS(20, 1) FLEN( 15) FCAPTION(Typ postupu)        CPOS( 1, 1)
      TYPE(GET)      NAME(cStred)               FPOS(20, 2) FLEN( 15) FCAPTION(Výrobní støedisko)  CPOS( 1, 2)
      TYPE(Text)     NAME(C_Stred->cNazStr)     CPOS(37, 2) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cOznPrac)             FPOS(20, 3) FLEN( 15) FCAPTION(Pracovištì)         CPOS( 1, 3)
      TYPE(Text)     NAME(C_Pracov->cNazevPrac) CPOS(37, 3) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cStavPrPo)            FPOS(20, 4) FLEN( 15) FCAPTION(Stav prac. postupu) CPOS( 1, 4)
    TYPE(End)
  TYPE(END)

* TEXT POSTUPU
  TYPE(TabPage) TTYPE(4) CAPTION(Text postupu) FPOS( 0,3.7) SIZE( 75, 11) OFFSET(24,52)
    TYPE(MLE) NAME(mTextPrPo) FPOS(1, 0.5) SIZE(73, 9)
  TYPE(End)