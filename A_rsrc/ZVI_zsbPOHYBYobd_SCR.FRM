TYPE(drgForm) DTYPE(10) TITLE(ZVI - Pohyby za období) SIZE(120,25);
               GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar) OBDOBI(ZVI)

  TYPE(Action) CAPTION(info ~Zvíøete )   EVENT(ZVI_ZvKARTY_INFO) TIPTEXT(informaèní karta zvíøete )
  TYPE(Action) CAPTION(~Pøep. pohybù)    EVENT(ZVI_KUMUL)        TIPTEXT(Pøepoèet pohybù za období pro celý ceník)

  TYPE(Static) STYPE(13) SIZE(79, 1) FPOS( 0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(Karty zvíøat) CPOS( 0, 0) CLEN( 79) CTYPE(3) FONT(5)
  TYPE(End)
  TYPE(DBrowse) FPOS( 0,1 ) SIZE(79,14.7) FILE(ZvKarty) INDEXORD(1)  ;
                FIELDS( cNazPol1:Stredisko   ,;
                        cNazPol4   ,;
                        nZvirKat   ,;
                        KategZVI->cNazevKAT ,;
                        cNazPol2   ,;
                        nUcetSkup  ,;
                        C_UCTSKZ->cNazUctSk );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny);
                ITEMMARKED(ItemMarked) POPUPMENU(y)

  TYPE(Static) STYPE(13) SIZE(39, 1) FPOS(80, 0) RESIZE(yn)
    TYPE(Text) CAPTION(Pohyby dle období) CPOS( 0, 0) CLEN( 39) CTYPE(3) FONT(5)
  TYPE(End)
  TYPE(DBrowse) FPOS( 80, 1 ) SIZE(40,23.7) FILE(ZvZmOBDw) INDEXORD(1) ;
                FIELDS( cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu:20,;
                        nROK:Úè.rok    ,;
                        nObdobi:Obd.   );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny) POPUPMENU(n)

  TYPE(Static) STYPE(13) SIZE(79, 1) FPOS( 0, 16) RESIZE(yx)
    TYPE(Text) CAPTION(Kumulativní hodnoty za období a pohyb) CPOS( 0, 0) CLEN( 79) CTYPE(3) FONT(5)
  TYPE(End)
  TYPE(Static) STYPE(13) SIZE(79, 7.8) FPOS(1,17) RESIZE(yx)
   TYPE(Text) CAPTION(Kusy        )           CPOS( 7, 1.5) CLEN( 20) FONT(2)
   TYPE(Text) CAPTION(Množství    )           CPOS( 7, 2.5) CLEN( 20) FONT(2)
   TYPE(Text) CAPTION(Krmné dny   )           CPOS( 7, 3.5) CLEN( 15) FONT(2)
   TYPE(Text) CAPTION(Cena celkem )           CPOS( 7, 4.5) CLEN( 15) FONT(2)
   TYPE(Text) CAPTION(PC celkem bez Dph )     CPOS( 7, 5.5) CLEN( 20) FONT(2)
   TYPE(Text) CAPTION(PC celkem s Dph )       CPOS( 7, 6.5) CLEN( 15) FONT(2)

   TYPE(Text) CAPTION(Aktuální )              CPOS( 40,0.3)   CLEN( 10) FONT(2)
   TYPE(Text) CAPTION(Od poèátku roku)        CPOS( 53,0.3)   CLEN( 15) FONT(2)

   TYPE(Text) NAME( ZvZmOBDw->nKusyZV)         CPOS( 32,1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nKusyZVOR)       CPOS( 52,1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nMnozSZV)        CPOS( 32,2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nMnozSZVOR)      CPOS( 52,2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nKD)             CPOS( 32,3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nKDOR)           CPOS( 52,3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaCZV)        CPOS( 32,4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaCZVOR)      CPOS( 52,4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaPCeZV)      CPOS( 32,5.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaPCeOR)      CPOS( 52,5.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaMCeZV)      CPOS( 32,6.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)
   TYPE(Text) NAME( ZvZmOBDw->nCenaMCeOR)      CPOS( 52,6.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrINFO)

  TYPE(End)