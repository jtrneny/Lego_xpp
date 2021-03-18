TYPE(drgForm) DTYPE(10) TITLE(Typová operace) SIZE(75,24) FILE(OPERACEw);
              GUILOOK(Action:y,IconBar:y:MyIconBar,Menu:y:myMenuBar);
              POST( POSTVALIDATE)

TYPE(Static) STYPE(12) SIZE(74, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)

  TYPE(Text) CAPTION(Typová operace)   CPOS( 4, 0.3) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(cOznOper)            FPOS( 4, 1.5) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Název operace)    CPOS(21, 0.3) CLEN( 15) FONT(2)
  TYPE(GET)  NAME(cNazOper)            FPOS(21, 1.5) FLEN( 50) FONT(5) PP(2)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 75,20.5) FPOS(0,3.7)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) OFFSET(1, 75) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE( 74,19) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypOper)             FPOS(20, 1) FLEN( 15) FCAPTION(Typ operace)        CPOS( 1, 1)
      TYPE(Text)     NAME(C_TypOp->cPopisOper)  CPOS(37, 1) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(cStred)               FPOS(20, 2) FLEN( 15) FCAPTION(Výrobní støedisko)  CPOS( 1, 2)
      TYPE(Text)     NAME(C_Stred->cNazStr)     CPOS(37, 2) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(cOznPrac)             FPOS(20, 3) FLEN( 15) FCAPTION(Pracovištì)         CPOS( 1, 3)
      TYPE(Text)     NAME(C_Pracov->cNazevPrac) CPOS(37, 3) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(cPracZar)             FPOS(20, 4) FLEN( 15) FCAPTION(Pracovní zaøazení)  CPOS( 1, 4)
      TYPE(Text)     NAME(C_PracZa->cNazPracZa) CPOS(37, 4) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(nDruhMzdy)            FPOS(20, 5) FLEN( 15) FCAPTION(Druh mzdy)          CPOS( 1, 5)
      TYPE(Text)     NAME(DruhyMzd->cNazevDmz)  CPOS(37, 5) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(cTarifStup)           FPOS(20, 6) FLEN( 15) FCAPTION(Tarifní stupnice)   CPOS( 1, 6)
      TYPE(Text)     NAME(C_TarStu->cNazTarStu) CPOS(37, 6) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(cTarifTrid)           FPOS(20, 7) FLEN( 15) FCAPTION(Tarifní tøída)      CPOS( 1, 7)
      TYPE(Text)     NAME(C_TarTri->cNazTarTri) CPOS(37, 7) CLEN( 30) GROUPS(clrGREY)
      TYPE(GET)      NAME(nKusovCas)            FPOS(20, 8) FLEN( 15) FCAPTION(Kusový èas)         CPOS( 1, 8)
      TYPE(GET)      NAME(nPriprCas)            FPOS(20, 9) FLEN( 15) FCAPTION(Pøípravný èas)      CPOS( 1, 9)
      TYPE(COMBOBOX) NAME(lVykazML)             FPOS(20,10) FLEN( 16) FCAPTION(Vykazovat mzd.lístky)    CPOS( 1,10)
      TYPE(GET)      NAME(nKoefSmCas)           FPOS(20,11) FLEN( 15) FCAPTION(Koef. smìnového èasu)    CPOS( 1,11)
      TYPE(GET)      NAME(nKoefViSt)            FPOS(20,12) FLEN( 15) FCAPTION(Koef.vícestroj. obsluhy) CPOS( 1,12)
      TYPE(GET)      NAME(nKoefViOb)            FPOS(20,13) FLEN( 15) FCAPTION(Koef.víceobsl. stroje)   CPOS( 1,13)
      TYPE(COMBOBOX) NAME(nRozOper)             FPOS(20,14) FLEN( 16) FCAPTION(Rozlišení operace)       CPOS( 1,14)
    TYPE(End)
  TYPE(END)

* POPIS OPERACE
  TYPE(TabPage) TTYPE(4) CAPTION(Popis operace) OFFSET(24,52)  PRE( tabSelect)
    TYPE(MLE) NAME(mTextOper) FPOS(1, 0.5) SIZE(73,18)
  TYPE(End)

* ATRIBUTY
  TYPE(TabPage) TTYPE(4) CAPTION(Atributy operace)  OFFSET(47,29) PRE( tabSelect)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(DBrowse) FILE(HodAtrib) INDEXORD(1);
                  FIELDS( cOznOper  ,;
                          cAtribOper  ,;
                          cHodnAtrC   ,;
                          nHodnAtrN   );
                  SIZE(70, 10.8) FPOS(2, 0.5) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)

    TYPE(Static) STYPE(13) SIZE( 74,7.5) FPOS(0.5, 11.5) RESIZE(yn)
      TYPE(GET)      NAME(HodAtrib->cAtribOper)  FPOS( 3, 1.2) FLEN( 8)  FCAPTION(Atribut)           CPOS( 3, 0.2)
      TYPE(GET)      NAME(HodAtrib->cHodnAtrC)   FPOS(13, 1.2) FLEN( 20) FCAPTION(Hodnota atr.znak.) CPOS(13, 0.2)
      TYPE(GET)      NAME(HodAtrib->nHodnAtrN)   FPOS(35, 1.2) FLEN( 20) FCAPTION(Hodnota atr.num.)  CPOS(35, 0.2)
      TYPE(MLE)      NAME(HodAtrib->mPoznamka)   FPOS( 3,  3.2) SIZE(70, 4) FCAPTION(Poznámka)       CPOS( 3, 2.2)
    TYPE(End)
  TYPE(End)

* PRACOVNÍ POSTUPY
  TYPE(TabPage) TTYPE(4) CAPTION(Postupy k operaci) OFFSET(70, 6) PRE( tabSelect)

    TYPE(DBrowse) FILE(PPOper) INDEXORD(1);
                  FIELDS( cOznPrPo    ,;
                          PracPost->cTypPrPo    ,;
                          PracPost->cNazPrPo    ,;
                          PracPost->cStred      ,;
                          PracPost->cOznPrac    ,;
                          PracPost->cStavPrPo  ) ;
                  SIZE(73, 10.5) FPOS(0.5, 0.5) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)

    TYPE(Static) STYPE(13) SIZE( 74,7.5)    FPOS(0.5, 11.5) RESIZE(yn)
      TYPE(GET)  NAME(PPOper->cOznPrPo)     FPOS( 3, 1.2) FLEN(12) FCAPTION(Prac. postup)  CPOS( 3, 0.2)
      TYPE(MLE)  NAME(PracPost->mTextPrPo)  FPOS( 3,  3.2) SIZE(70, 4) FCAPTION(Poznámka)  CPOS( 3, 2.2);
                                            READONLY(y)
    TYPE(End)

  TYPE(End)

TYPE(End)