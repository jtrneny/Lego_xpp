TYPE(drgForm) DTYPE(10) TITLE(Stavy za období dle kategorií) SIZE(100,21);
               GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar) OBDOBI(ZVI)

TYPE(Action) CAPTION(info ~Kategorie)   EVENT(ZVI_KATEGZVI_INFO) TIPTEXT(Informaèní karta kategorie zvíøete)
TYPE(Action) CAPTION(~Pøepoèet stavù)   EVENT(ZVI_KUMUL)         TIPTEXT(Pøepoèet stavù za kategorie a období )
*TYPE(Action) CAPTION(~ZvKatObd_PRN)     EVENT(ZVI_ZVKATOBD_PRN) TIPTEXT(Pøepoèet stavù za kategorie a období)

  TYPE(DBrowse) FPOS( 0,0.2) SIZE(80,14.1) FILE(KategZvi) INDEXORD(1)  ;
                FIELDS( nZvirKat    ,;
                        cNazevKAT   ,;
                        nUcetSkup   ,;
                        C_UctSkZ->cNazUctSk::23,;
                        cTypSkp     ,;
                        cNazPol2    ,;
                        lVzrust     ,;
                        nZvirKatPR  ,;
                        cNazPol2PR ) ;
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny);
                ITEMMARKED(ItemMarked) POPUPMENU(y)

  TYPE(DBrowse) FPOS( 80.5, 0.2 ) SIZE(19,14.1) FILE(ZvKatObdw) INDEXORD(1) ;
                FIELDS( nROK:Úèetní rok        ,;
                        nObdobi:Období  );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny) POPUPMENU(n)

  TYPE(Static) STYPE(13) SIZE(99.6, 6.4) FPOS(0.2,14.4) RESIZE(yx)
   TYPE(Text) CAPTION(Kusy        )           CPOS( 2,  1.5) CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Množství    )           CPOS( 2,  2.5) CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Cena celkem )           CPOS( 2,  3.5) CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Krmné dny   )           CPOS( 2,  4.5) CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Na poèátku  )           CPOS( 20, 0.5) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Pøíjem      )           CPOS( 41, 0.5) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Výdej       )           CPOS( 59, 0.5) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Na konci    )           CPOS( 73, 0.5) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Rozdíl      )           CPOS( 91, 0.5) CLEN( 10) FONT(2)

   TYPE(Text) NAME(ZvKatObdw->nKusyPoc)        CPOS( 15, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKusyPrij)       CPOS( 32, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKusyVydej)      CPOS( 49, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKusyKon)        CPOS( 66, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKusyRoz)        CPOS( 83, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKatObdw->nMnozPoc)        CPOS( 15, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nMnozPrij)       CPOS( 32, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nMnozVydej)      CPOS( 49, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nMnozKon)        CPOS( 66, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nMnozRoz)        CPOS( 83, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKatObdw->nCenaPoc)        CPOS( 15, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nCenaPrij)       CPOS( 32, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nCenaVydej)      CPOS( 49, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nCenaKon)        CPOS( 66, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nCenaRoz)        CPOS( 83, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKatObdw->nKDPoc)          CPOS( 15, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKDPrij)         CPOS( 32, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKDVydej)        CPOS( 49, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKDKon)          CPOS( 66, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKatObdw->nKDRoz)          CPOS( 83, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

  TYPE(End)