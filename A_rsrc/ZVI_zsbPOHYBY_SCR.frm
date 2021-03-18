TYPE(drgForm) DTYPE(10) TITLE(Pohybov� doklady - dle doklad�);
              SIZE(105,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              OBDOBI(ZVI)

TYPE(Action) CAPTION(~Tvorba doklad�) EVENT( zsbPohyby)         TIPTEXT(Po�izov�n� pohybov�ch doklad� )
TYPE(Action) CAPTION(info ~Zv��ete )  EVENT( ZVI_ZVKARTY_INFO)  TIPTEXT(Informa�n� karta zv��ete )
TYPE(Action) CAPTION(info ~Kategorie) EVENT( ZVI_KATEGZVI_INFO) TIPTEXT(Informa�n� karta kategorie zv��ete )

* Seznam Doklad�
  TYPE(DBrowse) FILE(ZVZmenHD) INDEXORD(3);
                FIELDS( nDoklad ,;
                        nOrdItem,;
                        cObdobi ,;
                        cNazPol1,;
                        cNazPol4,;
                        nZvirKat,;
                        nUcetSkup,;
                        cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:N�zev pohybu) ;
                SIZE(105,17) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)
* M->IsDoklad_LIK:L:2,;

* TYPE(Static) STYPE(12) SIZE(105,10.5) FPOS(0,14.2) Resize(nx) CTYPE(2)

* Detail dokladu
  TYPE(TabPage) TTYPE(4) CAPTION(Detail dokladu) SIZE(105,7.7) FPOS(0,17.2) RESIZE(yx) OFFSET(1,82)
    TYPE(Static) STYPE(13) SIZE(104, 6.5) FPOS(0.5, .01) RESIZE(yx) CTYPE(2)
      TYPE(TEXT) CAPTION(M�rn� jednotka)      CPOS( 1, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cZkratJedn)   CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Kl�� Dph)            CPOS( 1, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKlicDph)     CPOS(18, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Typ skladov� ceny)   CPOS( 1, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cTypVypCen)   CPOS(18, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(��s.dodac�ho listu)  CPOS( 1, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCisloDL)     CPOS(18, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(��slo faktury)       CPOS( 1, 4.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCisFak)      CPOS(18, 4.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Variabiln� symbol)   CPOS( 1, 5.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cVarSym)      CPOS(18, 5.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

      TYPE(TEXT) CAPTION(Kusy zv��at)         CPOS(35, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKusyZV)      CPOS(51, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Mno�stv� na st�ji)   CPOS(35, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nMnozSZV)     CPOS(51, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Krmn� dny)           CPOS(35, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nKD)          CPOS(51, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Skladov� cena celkem)CPOS(35, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nCenaCZV)     CPOS(51, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

      TYPE(TEXT) CAPTION(St�ed.-nov�)         CPOS(68, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol1_n)   CPOS(84, 0.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(St�j-nov�)           CPOS(68, 1.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol4_n)   CPOS(84, 1.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(Kategorie-nov�)      CPOS(68, 2.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nZvirKat_n)   CPOS(84, 2.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(��.skup.-nov�)       CPOS(68, 3.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->nUcetSkupn)   CPOS(84, 3.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)
      TYPE(TEXT) CAPTION(V�kon-nov�)          CPOS(68, 4.2) CLEN( 16)
      TYPE(TEXT) NAME(ZvZmenHD->cNazPol2_n)   CPOS(84, 4.2) CLEN( 13) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrINFO)

    TYPE(End)

  TYPE(End)

* Detail majetku
**  TYPE(TabPage) TTYPE(4) CAPTION(Detail majetku)  SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(16,68)

*   INFO
*   1.��dek
**    TYPE(Text) CAPTION(Inv.��slo)                 CPOS(  3, 0.5)   CLEN(  8) FONT(5)
**    TYPE(Text) NAME(MAJ->nInvCis)       CPOS(  3, 1.5)   CLEN(  8) BGND( 13) PP(2)
**  TYPE(End)