TYPE(drgForm) DTYPE(10) TITLE(Karty zvíøat - stájový registr PRASAT) SIZE(110,25) FILE(REGZVIPR);
              OBDOBI(ZVI)

TYPE(Action) CAPTION(~Aktualizace) EVENT(ZVI_RegZviPR) TIPTEXT( Aktualizace stájového registru prasat)
TYPE(Action) CAPTION(~Oprava reg.) EVENT(opeAktualREG) TIPTEXT( Oprava stájového registru prasat)

  TYPE(DBrowse) FILE(REGZVIPR) INDEXORD(1) ;
                FIELDS( cFarma      ,;
                        nPorCisLis  ,;
                        nPorCisRad  ,;
                        nKusyPocSt  ,;
                        nKusy       ,;
                        nKusyKonSt  ,;
                        nDrPohybP   ,;
                        C_DRPOHP->cNazevPoh ,;
                        CNAZPOL1:Støed.   ,;
                        CNAZPOL4   ,;
                        NZVIRKAT   ,;
                        cNazPol2   ,;
                        nCenaZV    ,;
                        cTypSkp    ,;
                        cUcetSkup  ,;
                        cTypEvid   ,;
                        cPlemeno   ,;
                        cZvireZem  );
                SIZE(110,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Základní údaje
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(1, 82) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(109.5 ,9.4) FPOS(0.2, 0.1) RESIZE(yx)
*   1.SL.
    TYPE(Text) CAPTION(Stredisko )         CPOS(  2, 0.5) CLEN( 17)
    TYPE(Text) NAME( cNazPol1)             CPOS( 20, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Stáj )              CPOS(  2, 1.5) CLEN( 17)
    TYPE(Text) NAME( cNazPol4)             CPOS( 20, 1.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Kategorie )         CPOS(  2, 2.5) CLEN( 17)
    TYPE(Text) NAME( nZvirKat)             CPOS( 20, 2.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Rok zmìny )         CPOS(  2, 3.5) CLEN( 17)
    TYPE(Text) NAME( nRok)                 CPOS( 20, 3.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Období zmìny )      CPOS(  2, 4.5) CLEN( 17)
    TYPE(Text) NAME( nObdobi)              CPOS( 20, 4.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Plemeno )           CPOS(  2, 5.5) CLEN( 17)
    TYPE(Text) NAME( cPlemeno)             CPOS( 20, 5.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Kód hospodáøství)   CPOS(  2, 6.5) CLEN( 17)
    TYPE(Text) NAME( cKodHosp)             CPOS( 20, 6.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Druh pohybu )       CPOS(  2, 7.5) CLEN( 17)
    TYPE(Text) NAME(cTypPohybu)            CPOS( 20, 7.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
*
*   TYPE(Static)   STYPE(17) SIZE(68, 0.5) FPOS( 40, 0.6)
    TYPE(Text) CAPTION( Èíslo )            CPOS( 62, 0.5) CLEN( 5)
    TYPE(Text) CAPTION( Okres )            CPOS( 74, 0.5) CLEN( 5)
    TYPE(Text) CAPTION( Podnik)            CPOS( 88, 0.5) CLEN( 6)
    TYPE(Text) CAPTION( Stáj  )            CPOS(104, 0.5) CLEN( 5)
    TYPE(Static)   STYPE(17) SIZE(68, 0.5) FPOS( 40, 0.6)
    TYPE(Static)   STYPE(17) SIZE(68, 0.5) FPOS( 40, 5.6)

    TYPE(Text) CAPTION(Farma )             CPOS( 40, 1.5) CLEN( 12)
    TYPE(Text) NAME( cFarma)               CPOS( 54, 1.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarmaKRJ)            CPOS( 68, 1.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarmaPOD)            CPOS( 82, 1.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarmaSTJ)            CPOS( 96, 1.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Farma zmìny )       CPOS( 40, 2.5) CLEN( 12)
    TYPE(Text) NAME( cFarmaZMN)            CPOS( 54, 2.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarZmnKRJ)           CPOS( 68, 2.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarZmnPOD)           CPOS( 82, 2.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarZmnSTJ)           CPOS( 96, 2.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Farma odkud )       CPOS( 40, 3.5) CLEN( 12)
    TYPE(Text) NAME( cFarmaOdk)            CPOS( 54, 3.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarOdkKRJ)           CPOS( 68, 3.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarOdkPOD)           CPOS( 82, 3.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarOdkSTJ)           CPOS( 96, 3.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Farma kam )         CPOS( 40, 4.5) CLEN( 12)
    TYPE(Text) NAME( cFarmaKam)            CPOS( 54, 4.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarKamKRJ)           CPOS( 68, 4.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarKamPOD)           CPOS( 82, 4.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cFarKamSTJ)           CPOS( 96, 4.5) CLEN( 12) BGND( 13) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Datum odsunu )      CPOS( 40, 6.5) CLEN( 14)
    TYPE(Text) NAME( dDatKdyODK)           CPOS( 54, 6.5) CLEN( 13) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Datum pøísunu )     CPOS( 40, 7.5) CLEN( 14)
    TYPE(Text) NAME( dDatKdyKAM)           CPOS( 54, 7.5) CLEN( 13) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(TEXT )              CPOS( 69, 6.5) CLEN(  5)
    TYPE(Text) NAME( cText1)               CPOS( 75, 6.5) CLEN( 30) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) NAME( cText2)               CPOS( 75, 7.5) CLEN( 30) BGND( 13) FONT(5) GROUPS( clrGREY)


  TYPE(End)
