TYPE(drgForm) DTYPE(10) TITLE(Karty zvíøat - zásobová evidence) SIZE(100,25) FILE(ZVKARTY);
              CARGO( ZVI_zsbZvKarty_CRD) OBDOBI(ZVI)

TYPE(Action) CAPTION(~Tvorba dokladù)    EVENT(zsbPohyby)  TIPTEXT(Poøizování pohybových dokladù )
TYPE(Action) CAPTION(~Akt. poè.stavu)    EVENT(zsbPocStav) TIPTEXT(Pøepoèet poèáteèního stavu karty)
TYPE(Action) CAPTION(info ~Kategorie)    EVENT(KategZvi_INFO) TIPTEXT(informaèní karta kategorie zvíøete)
TYPE(Action) CAPTION( ~Individuální ev.) EVENT(zsbIndividEv)     TIPTEXT(Individuální evidence )

  TYPE(DBrowse) FILE(ZVKARTY) INDEXORD(1) ;
                FIELDS( CNAZPOL1:Stredisko ,;
                        CNAZPOL4   ,;
                        NZVIRKAT   ,;
                        KategZVI->cNazevKAT ,;
                        nCenaSZV   ,;
                        nKusyZV    ,;
                        nMnozSZV   ,;
                        nKD        ,;
                        nCenaV1ZV  ,;
                        nCenaV2ZV  ,;
                        nCenaCZV   ,;
                        cTypEvid   ,;
                        nUcetSkup  ,;
                        C_UCTSKZ->cNazUctSk ,;
                        cTypSKP    ,;
                        cNazPol2   );
                SIZE(100,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Zmìny ÚÈETNÍ
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny úèetní) FPOS(0,14.1) SIZE(100,10.7) RESIZE(yx) OFFSET(1, 82) PRE( tabSelect)

    TYPE(DBrowse) FILE(ZvZmenHD) INDEXORD(4);
                  FIELDS( cObdobi   ,;
                          cTypPohybu:Pohyb  ,;
                          C_TypPoh->cNazTypPoh:Název pohybu:30,;
                          nDoklad   ,;
                          dDatZmZv  ,;
                          nCenaSZV  ,;
                          nKusyZV   ,;
                          nMnozSZV  ,;
                          nCenaCZV  ,;
                          nKD       ,;
                          cNazPol1_n,;
                          cNazPol4_n,;
                          nZvirKat_n,;
                          cNazPol2_n,;
                          dDatPoriz );
                  SIZE(100,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) POPUPMENU(n)
  TYPE(End)

* Zmìny NEÚÈETNÍ
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny neúèetní) FPOS(0,14.1) SIZE(100,10.7) RESIZE(yx) OFFSET(18,66)  PRE( tabSelect)

    TYPE(DBrowse)  FILE(ZVKARTYZ) INDEXORD(1);
                  FIELDS(dDatZmeny   ,;
                         cPopisZme::15   ,;
                         cNazPolZme::20  ,;
                         cOldHodn::30    ,;
                         cNewHodn::30    );
                  SIZE(100,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(n)
  TYPE(End)

* Základní údaje
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0, 14.1) SIZE(100,10.7) RESIZE(yx) OFFSET(34,49) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(99.5 ,9.4) FPOS(0.2, 0.1) RESIZE(yx)
*   1.SL.
    TYPE(Text) CAPTION(Typ evidence )         CPOS(  2, 0.5) CLEN( 17)
    TYPE(Text) NAME(M->NazTypEvid)            CPOS( 20, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
*    TYPE(Text) NAME(KategZvi->cNazevKat)     CPOS( 25, 0.5) CLEN( 30) BGND( 13)
    TYPE(Text) CAPTION(Typ skladové ceny)     CPOS(  2, 1.5) CLEN( 17)
    TYPE(Text) NAME(cTypVypCen)               CPOS( 20, 1.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Typ SKP)               CPOS(  2, 2.5) CLEN( 17)
    TYPE(Text) NAME(cTypSKP)                  CPOS( 20, 2.5) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)

*    TYPE(STATIC) STYPE(16)                    CPOS(  2,  7) SIZE(100,1)

    TYPE(Text) CAPTION(Základní mìna)         CPOS(  2, 4) CLEN( 17)
    TYPE(Text) NAME(cZkratMeny)               CPOS( 20, 4) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Skladová cena/MJ)      CPOS(  2, 5) CLEN( 17)
    TYPE(Text) NAME(nCenaSZV)                 CPOS( 20, 5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Skladová cena CELKEM)  CPOS(  2, 6) CLEN( 17)
    TYPE(Text) NAME(nCenaCZV)                 CPOS( 20, 6) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Prodejní cena bez Dph) CPOS(  2, 7) CLEN( 17)
    TYPE(Text) NAME(nCenaPZV)                 CPOS( 20, 7) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Prodejní cena s Dph)   CPOS(  2, 8) CLEN( 17)
    TYPE(Text) NAME(nCenaMZV)                 CPOS( 20, 8) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)

*   2.SL
    TYPE(Text)  CAPTION(Mìrná jednotka)        CPOS( 53, 4) CLEN( 18)
    TYPE(TEXT)  NAME(cZkratJedn)               CPOS( 73, 4) CLEN( 15) BGND(13) FONT(5) GROUPS( clrGREY)
    TYPE(Text)  CAPTION(Množství na stáji)     CPOS( 53, 5) CLEN( 18)
    TYPE(TEXT)  NAME(nMnozSZV)                 CPOS( 73, 5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text)  CAPTION(Kusy zvíøat)           CPOS( 53, 6) CLEN( 18)
    TYPE(TEXT)  NAME(nKusyZV)                  CPOS( 73, 6) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text)  CAPTION(Krmné dny)             CPOS( 53, 7) CLEN( 18)
    TYPE(TEXT)  NAME(nKD)                      CPOS( 73, 7) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS( clrGREY)

    TYPE(End)
  TYPE(End)