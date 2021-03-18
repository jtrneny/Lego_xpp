TYPE(drgForm) DTYPE(10) TITLE(Stavy za období) SIZE(100,21);
               GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar) OBDOBI(ZVI)

TYPE(Action) CAPTION(info ~Zvíøete)     EVENT(ZVI_ZVKARTY_INFO) TIPTEXT(Informaèní karta zvíøete)
TYPE(Action) CAPTION(~Pøepoèet stavù)   EVENT(ZVI_KUMUL)        TIPTEXT(Pøepoèet stavù za období pro všechny karty)
**TYPE(Action) CAPTION(~ZvKarObd_PRN)     EVENT(ZVI_OBRATOBD_PRN) TIPTEXT(Pøepoèet stavù za období pro všechny karty)

  TYPE(DBrowse) FPOS( 0,0.2) SIZE(80,14.1) FILE(ZvKarty) INDEXORD(1)  ;
                FIELDS( cNazPol1:Stredisko   ,;
                        cNazPol4   ,;
                        nZvirKat   ,;
                        KategZVI->cNazevKAT ,;
                        nUcetSkup  ,;
                        C_UCTSKZ->cNazUctSk ,;
                        cNazPol2   );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny);
                ITEMMARKED(ItemMarked) POPUPMENU(y)

  TYPE(DBrowse) FPOS( 80.5, 0.2 ) SIZE(19,14.1) FILE(ZvKarObdw) INDEXORD(1) ;
                FIELDS( nROK:Úèetní rok        ,;
                        nObdobi:Období  );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny) POPUPMENU(n)

  TYPE(Static) STYPE(13) SIZE(99.6, 6.4) FPOS(0.2,14.4) RESIZE(yx)
   TYPE(Text) CAPTION(Kusy        )           CPOS( 2,  1.5) CLEN( 11) FONT(2)
   TYPE(Text) CAPTION(Množství    )           CPOS( 2,  2.5) CLEN( 11) FONT(2)
   TYPE(Text) CAPTION(Cena celkem )           CPOS( 2,  3.5) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Krmné dny   )           CPOS( 2,  4.5) CLEN( 11) FONT(2)
   TYPE(Text) CAPTION(Na poèátku  )           CPOS( 20, 0.3) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Pøíjem      )           CPOS( 41, 0.3) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Výdej       )           CPOS( 59, 0.3) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Na konci    )           CPOS( 73, 0.3) CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Rozdíl      )           CPOS( 91, 0.3) CLEN( 10) FONT(2)

   TYPE(Text) NAME(ZvKarObdw->nKusyPoc)        CPOS( 15, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKusyPrij)       CPOS( 32, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKusyVydej)      CPOS( 49, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKusyKon)        CPOS( 66, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKusyRoz)        CPOS( 83, 1.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKarObdw->nMnozPoc)        CPOS( 15, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nMnozPrij)       CPOS( 32, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nMnozVydej)      CPOS( 49, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nMnozKon)        CPOS( 66, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nMnozRoz)        CPOS( 83, 2.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKarObdw->nCenaPoc)        CPOS( 15, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nCenaPrij)       CPOS( 32, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nCenaVydej)      CPOS( 49, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nCenaKon)        CPOS( 66, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nCenaRoz)        CPOS( 83, 3.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

   TYPE(Text) NAME(ZvKarObdw->nKDPoc)          CPOS( 15, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKDPrij)         CPOS( 32, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKDVydej)        CPOS( 49, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKDKon)          CPOS( 66, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
   TYPE(Text) NAME(ZvKarObdw->nKDRoz)          CPOS( 83, 4.5)   CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

  TYPE(End)