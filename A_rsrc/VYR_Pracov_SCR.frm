TYPE(drgForm) DTYPE(10) TITLE(Katalog pracoviš) FILE(C_PRACOV);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_Pracov_crd)
* CBSAVE(OnSave)

*TYPE(Action) CAPTION() EVENT() TIPTEXT()

* C_Pracov ... katalog pracoviš
  TYPE(DBrowse) FILE(C_PRACOV) INDEXORD(1);
                FIELDS( cOznPrac   ,;
                        cNazevPrac ,;
                        cTypPracov ,;
                        cNazPol4  ,;
                        cStred    ,;
                        cPracZar  ,;
                        nDruhMzdy) ;
                SIZE(100,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Základní údaje
  TYPE(TabPage) CAPTION( Základní údaje) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(1,82) PRE(tabSelect)
    TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
*       1.SL
      TYPE(Text)  CAPTION(Typ pracovišrì)      CPOS( 1, 0.5) CLEN( 12)
      TYPE(TEXT)  NAME(cTypPracov)             CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5)
**        TYPE(Text)  NAME(C_TypOp->cPopisOper)  CPOS(31, 0.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Úèetní oznaèení)     CPOS( 1, 1.5) CLEN( 12)
      TYPE(TEXT)  NAME(cNazPol4)               CPOS(15, 1.5) CLEN( 15) BGND(13) FONT(5)
*        TYPE(Text)  NAME(cNazPol4->cNazevPrac)  CPOS(31, 1.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Výr. støedisko)      CPOS( 1, 2.5) CLEN( 12)
      TYPE(TEXT)  NAME(cStred)                 CPOS(15, 2.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  NAME(C_Stred->cNazStr)       CPOS(31, 2.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Pracovní zaøazení)   CPOS( 1, 3.5) CLEN( 13)
      TYPE(TEXT)  NAME(cPracZar)               CPOS(15, 3.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  NAME(C_PracZa->cNazPracZa)   CPOS(31, 3.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Druh mzdy)           CPOS( 1, 4.5) CLEN( 12)
      TYPE(TEXT)  NAME(nDruhMzdy)              CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  NAME(DruhyMzd->cNazevDmz)    CPOS(31, 4.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Poèet pracoviš)     CPOS( 1, 5.5) CLEN( 12)
      TYPE(TEXT)  NAME(nPocPrac)               CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5) CTYPE(2)
      TYPE(Text)  CAPTION(Poøadí pracovištì)   CPOS( 1, 6.5) CLEN( 12)
      TYPE(TEXT)  NAME(nPoradi)                CPOS(15, 6.5) CLEN( 15) BGND(13) FONT(5) CTYPE(2)
      TYPE(Text)  CAPTION(Transportní mn.)     CPOS( 1, 7.5) CLEN( 12)
      TYPE(TEXT)  NAME(nTranMnoz)              CPOS(15, 7.5) CLEN( 15) BGND(13) FONT(5) CTYPE(2)

*       2.SL
      TYPE(Text)  CAPTION(Vícestrojová obsluha)    CPOS(63, 0.5) CLEN( 18)
      TYPE(TEXT)  NAME(nViceStroj)                 CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Koef.vícestroj. obsluhy) CPOS(63, 1.5) CLEN( 18)
      TYPE(TEXT)  NAME(nKoefViSt)                  CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Víceobslužný stroj)      CPOS(63, 2.5) CLEN( 18)
      TYPE(TEXT)  NAME(nViceObslu)                 CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Koef.víceobsluž. stroje) CPOS(63, 3.5) CLEN( 18)
      TYPE(TEXT)  NAME(nKoefViSt)                  CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Koef. smìnového èasu)    CPOS(63, 4.5) CLEN( 18)
      TYPE(TEXT)  NAME(nKoefSmCas)                 CPOS(82, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Typ kalendáøe)           CPOS(63, 5.5) CLEN( 18)
      TYPE(TEXT)  NAME(cTypKalend)                 CPOS(82, 5.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  CAPTION(Sazba stroje)            CPOS(63, 6.5) CLEN( 18)
      TYPE(TEXT)  NAME(nSazbaStro)                 CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Výkonová norma)          CPOS(63, 7.5) CLEN( 18)
*      TYPE(TEXT)  NAME(lVykNorma)                  CPOS(82, 7.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)
  TYPE(End)

* Popis Pracovištì
  TYPE(TabPage) CAPTION( Popis pracovištì) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66) PRE(tabSelect)
    TYPE(MLE) NAME('C_Pracov->mPopisPrac') FPOS( 1, 0.2) SIZE( 98, 9) RESIZE(yx) READONLY(y)
  TYPE(End)