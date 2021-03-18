TYPE(drgForm) DTYPE(10) TITLE(Výkres) SIZE(80,15) FILE(VYKRESYw);
              GUILOOK(Action:n,IconBar:y:MyIconBar,Menu:y:MyMenuBar);
              POST( POSTVALIDATE) CBSAVE(ONSAVE)

TYPE(Static) STYPE(12) SIZE(79, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)

*  TYPE(Text) CAPTION(Poø. èíslo)               CPOS( 1, 0.4) CLEN( 10) FONT(2)
*  TYPE(GET)  NAME(nPorVyk)                     FPOS( 1, 1.6) FLEN(  8) FONT(5) PP(2) NOREVISION()
*  TYPE(Text) CAPTION(Evidenèní èíslo výkresu)  CPOS(11, 0.4) CLEN( 20) FONT(2)
*  TYPE(GET)  NAME(cCisVyk)                     FPOS(11, 1.6) FLEN( 32) FONT(5) PP(2) NOREVISION()
*  TYPE(Text) CAPTION(Modifikace)               CPOS(45, 0.4) CLEN( 10) FONT(2)
*  TYPE(GET)  NAME(cModVyk)                     FPOS(45, 1.6) FLEN(  8) FONT(5) PP(2) NOREVISION()
*  TYPE(Text) CAPTION(Název výkresu)            CPOS(55, 0.4) CLEN( 15) FONT(2)
*  TYPE(GET)  NAME(cNazVyk)                     FPOS(55, 1.6) FLEN( 22) FONT(5)

  TYPE(Text) CAPTION(Poø. èíslo výkresu)       CPOS( 1, 0.2) CLEN( 15)
  TYPE(GET)  NAME(nPorVyk)                     FPOS(18, 0.2) FLEN(  8) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Evidenèní èís. výkresu)   CPOS( 1, 1.2) CLEN( 17)
  TYPE(GET)  NAME(cCisVyk)                     FPOS(18, 1.2) FLEN( 32) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Modifikace výkresu)       CPOS(52, 1.2) CLEN( 15)
  TYPE(GET)  NAME(cModVyk)                     FPOS(68, 1.2) FLEN(  8) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Název výkresu)            CPOS( 1, 2.2) CLEN( 15)
  TYPE(GET)  NAME(cNazVyk)                     FPOS(18, 2.2) FLEN( 58) FONT(5)

TYPE(End)

TYPE(Static) STYPE(13) SIZE( 80,11.5) FPOS(0,3.7)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) OFFSET(1, 80)

    TYPE(Static) STYPE(11) SIZE( 79,10) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypVyk)               FPOS(20, 1) FLEN( 20) FCAPTION(Typ výkresu)         CPOS( 1, 1)
      TYPE(Text)     NAME(C_TYPVYKR->cTypVykNaz) CPOS(42, 1) CLEN( 25) BGND( 13) GROUPS(clrGREY)
      TYPE(GET)      NAME(cAutor)                FPOS(20, 2) FLEN( 20) FCAPTION(Autor výkresu)       CPOS( 1, 2)
      TYPE(GET)      NAME(cStred)                FPOS(20, 3) FLEN( 20) FCAPTION(Vlastnící støedisko) CPOS( 1, 3)
      TYPE(Text)     NAME(C_STRED->cNazStr)      CPOS(42, 3) CLEN( 25) BGND( 13) GROUPS(clrGREY)
      TYPE(COMBOBOX) NAME(lVyhISO)               FPOS(20, 4) FLEN( 21) FCAPTION(Splòuje ISO 9001)    CPOS( 1, 4) REF(LYESNO)
      TYPE(GET)      NAME(cVypujKdo)             FPOS(20, 5) FLEN( 20) FCAPTION(Zapùjèeno komu)      CPOS( 1, 5)
      TYPE(GET)      NAME(dVypujDat)             FPOS(20, 6) FLEN( 20) FCAPTION(Zapùjèeno kdy)       CPOS( 1, 6) PUSH(CLICKDATE)
    TYPE(End)
  TYPE(END)

* POPIS VÝKRESU
  TYPE(TabPage) TTYPE(4) CAPTION(Popis výkresu) OFFSET(20,61)
    TYPE(MLE) NAME(mPopisVyk) FPOS(0.4, 0.2) SIZE(79, 10)
  TYPE(End)

TYPE(End)