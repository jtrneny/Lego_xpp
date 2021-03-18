TYPE(drgForm) DTYPE(10) TITLE(Pohybové doklady - dle dokladù);
              SIZE(105,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              OBDOBI(ZVI)

TYPE(Action) CAPTION(~Tvorba dokladù) EVENT( zsbPohyby)         TIPTEXT(Poøizování pohybových dokladù )
TYPE(Action) CAPTION(info ~Zvíøete )  EVENT( ZVI_ZVKARTY_INFO)  TIPTEXT(Informaèní karta zvíøete )
TYPE(Action) CAPTION(info ~Kategorie) EVENT( ZVI_KATEGZVI_INFO) TIPTEXT(Informaèní karta kategorie zvíøete )

* Seznam Dokladù
  TYPE(DBrowse) FILE(ZVZmenHD) INDEXORD(3);
                FIELDS( nDoklad ,;
                        nOrdItem,;
                        cObdobi ,;
                        cNazPol1,;
                        cNazPol4,;
                        nZvirKat,;
                        nUcetSkup,;
                        cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu) ;
                SIZE(105,17) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)
* M->IsDoklad_LIK:L:2,;

* TYPE(Static) STYPE(12) SIZE(105,10.5) FPOS(0,14.2) Resize(nx) CTYPE(2)

* Detail dokladu
  TYPE(TabPage) TTYPE(4) CAPTION(Detail dokladu) SIZE(105,7.7) FPOS(0,17.2) RESIZE(yx) OFFSET(1,82)
    TYPE(Static) STYPE(13) SIZE(104, 6.5) FPOS(0.5, .01) RESIZE(yx) CTYPE(2)
      TYPE(TEXT) CAPTION(Mìrná jednotka)      CPOS( 1, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cZkratJedn)   CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Klíè Dph)            CPOS( 1, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKlicDph)     CPOS(18, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Typ skladové ceny)   CPOS( 1, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cTypVypCen)   CPOS(18, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Èís.dodacího listu)  CPOS( 1, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCisloDL)     CPOS(18, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Èíslo faktury)       CPOS( 1, 4.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCisFak)      CPOS(18, 4.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Variabilní symbol)   CPOS( 1, 5.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cVarSym)      CPOS(18, 5.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

      TYPE(TEXT) CAPTION(Kusy zvíøat)         CPOS(35, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKusyZV)      CPOS(51, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Množství na stáji)   CPOS(35, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nMnozSZV)     CPOS(51, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Krmné dny)           CPOS(35, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKD)          CPOS(51, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Skladová cena celkem)CPOS(35, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCenaCZV)     CPOS(51, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

      TYPE(TEXT) CAPTION(Støed.-nové)         CPOS(68, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol1_n)   CPOS(84, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Stáj-nová)           CPOS(68, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol4_n)   CPOS(84, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Kategorie-nová)      CPOS(68, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nZvirKat_n)   CPOS(84, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Úè.skup.-nová)       CPOS(68, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nUcetSkupn)   CPOS(84, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Výkon-nový)          CPOS(68, 4.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol2_n)   CPOS(84, 4.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

    TYPE(End)

  TYPE(End)

* Detail majetku
**  TYPE(TabPage) TTYPE(4) CAPTION(Detail majetku)  SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(16,68)

*   INFO
*   1.øádek
**    TYPE(Text) CAPTION(Inv.èíslo)                 CPOS(  3, 0.5)   CLEN(  8) FONT(5)
**    TYPE(Text) NAME(MAJ->nInvCis)       CPOS(  3, 1.5)   CLEN(  8) BGND( 13) PP(2)
**  TYPE(End)