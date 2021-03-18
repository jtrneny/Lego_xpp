TYPE(drgForm) DTYPE(10) TITLE(Karty zv��at - st�jov� registr SKOTU) SIZE(110,25) FILE(ZVIRATA);
              CARGO( ZVI_opeZvirata_CRD) OBDOBI(ZVI)

TYPE(Action) CAPTION(~P�e��slovat) EVENT(OpePrecisReg) TIPTEXT(P�e��slov�n� st�jov�ho registru skotu)

  TYPE(DBrowse) FILE(ZVIRATA) INDEXORD(1) ;
                FIELDS( nKusy:Ks zv.    ,;
                        CNAZPOL1:St�ed.   ,;
                        CNAZPOL4   ,;
                        NZVIRKAT   ,;
                        KategZVI->cNazevKAT ,;
                        cNazPol2   ,;
                        nInvCis    ,;
                        ZVI_Pohlavi():Pohl. ,;
                        nInvCisMat  ,;
                        nCenaZV     ,;
                        cPlemeno    ,;
                        dNarozZvir  ,;
                        dDatpZV     ,;
                        nUcetSkup   ,;
                        nFarma      ,;
                        dDatKdyOdk  ,;
                        dDatKdyKam  ,;
                        nPorCisLis  ,;
                        nPorCisRad  );
                SIZE(110,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Zm�ny ��ETN�
  TYPE(TabPage) TTYPE(4) CAPTION(Pohyby na kart�ch) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(1, 82) PRE( tabSelect)

    TYPE(DBrowse) FILE(ZvZmenIT) INDEXORD(4);
                  FIELDS( dDatZmZv  ,;
                          cTypPohybu:Pohyb  ,;
                          C_TypPoh->cNazTypPoh::25,;
                          nDrPohybP  ,;
                          C_DRPOHP->cNazevPoh ,;
                          nCisReg    ,;
                          nFarmaODK  ,;
                          nFarmaKAM  );
                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(n)
  TYPE(End)

* Zm�ny NE��ETN�
*  TYPE(TabPage) TTYPE(4) CAPTION(Zm�ny ne��etn�) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(16,68)  PRE( tabSelect)
*
*    TYPE(DBrowse)  FILE(ZVKARTYZ) INDEXORD(1);
*                  FIELDS(dDatZmeny   ,;
*                         cPopisZme::15   ,;
*                         cNazPolZme::20  ,;
*                         cOldHodn::30    ,;
*                         cNewHodn::30    );
*                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(n)
*  TYPE(End)

* Z�kladn� �daje
  TYPE(TabPage) TTYPE(4) CAPTION(Z�kladn� �daje) FPOS(0, 14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(16,68) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(109.5 ,9.4) FPOS(0.2, 0.1) RESIZE(yx)
*   1.SL.
    TYPE(Text) CAPTION(Stredisko )         CPOS(  2, 0.5) CLEN( 17)
    TYPE(Text) NAME( cNazPol1)              CPOS( 20, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
**    TYPE(Text) NAME(KategZvi->cNazevKat)     CPOS( 25, 0.5) CLEN( 30) BGND( 13)
*    TYPE(Text) CAPTION(Typ skladov� ceny)     CPOS(  2, 1.5) CLEN( 17)
*    TYPE(Text) NAME(cTypVypCen)               CPOS( 20, 1.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) CAPTION(Typ SKP)               CPOS(  2, 2.5) CLEN( 17)
*    TYPE(Text) NAME(cTypSKP)                  CPOS( 20, 2.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)

**    TYPE(STATIC) STYPE(16)                    CPOS(  2,  7) SIZE(100,1)

*    TYPE(Text) CAPTION(Z�kladn� m�na)         CPOS(  2, 4) CLEN( 17)
*    TYPE(Text) NAME(cZkratMeny)               CPOS( 20, 4) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) CAPTION(Skladov� cena/MJ)      CPOS(  2, 5) CLEN( 17)
*    TYPE(Text) NAME(nCenaSZV)                 CPOS( 20, 5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) CAPTION(Skladov� cena CELKEM)  CPOS(  2, 6) CLEN( 17)
*    TYPE(Text) NAME(nCenaCZV)                 CPOS( 20, 6) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) CAPTION(Prodejn� cena bez Dph) CPOS(  2, 7) CLEN( 17)
*    TYPE(Text) NAME(nCenaPZV)                 CPOS( 20, 7) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) CAPTION(Prodejn� cena s Dph)   CPOS(  2, 8) CLEN( 17)
*    TYPE(Text) NAME(nCenaMZV)                 CPOS( 20, 8) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)

**   2.SL
*    TYPE(Text)  CAPTION(M�rn� jednotka)        CPOS( 53, 4) CLEN( 18)
*    TYPE(TEXT)  NAME(cZkratJedn)               CPOS( 73, 4) CLEN( 15) BGND(13) FONT(5) GROUPS( clrGREY)
*    TYPE(Text)  CAPTION(Mno�stv� na st�ji)     CPOS( 53, 5) CLEN( 18)
*    TYPE(TEXT)  NAME(nMnozSZV)                 CPOS( 73, 5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
*    TYPE(Text)  CAPTION(Kusy zv��at)           CPOS( 53, 6) CLEN( 18)
*    TYPE(TEXT)  NAME(nKusyZV)                  CPOS( 73, 6) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
*    TYPE(Text)  CAPTION(Krmn� dny)             CPOS( 53, 7) CLEN( 18)
*    TYPE(TEXT)  NAME(nKD)                      CPOS( 73, 7) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

*    TYPE(End)
*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)