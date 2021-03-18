TYPE(drgForm) DTYPE(10) TITLE(Pohyby majetkových zvíøat ...) SIZE(105, 25) FILE(MAJZ);
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:n);
               CARGO( HIM_MAJ_CRD) POST(POSTVALIDATE) OBDOBI(ZVI)

TYPE(Action) CAPTION( info ~Majetku) EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku zvíøat)
TYPE(Action) CAPTION( ~Likvidace)    EVENT(LikvDOKL)     TIPTEXT(zaúètování dokladu )

* Seznam pohybù
  TYPE(TEXT) CAPTION(Úèetní zmìny) CPOS(.1,15.5) CLEN(104.9) FONT(5) PP(3) BGND(11)  RESIZE(yn) CTYPE(1)
  TYPE(DBrowse) FILE(ZMAJUZw) INDEXORD(2);
                FIELDS( cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu:25,;
                        nDoklad     ,;
                        dDatZmeny   ,;
                        cObdobi     ,;
                        nUctOdpMes ,;
                        nCenaVstU  ,;
                        nZmenVstCU ,;
                        nZmenVstCD ,;
                        nOprUct    ,;
                        nZmenOprU  ,;
                        nZmenOprD  ,;
                        cUserAbb:Uživatel    );
              FPOS( 0.5 , 16.5) SIZE(104, 8.4) CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yy) POPUPMENU(yn);
              ITEMMARKED( ItemMarked)

TYPE(Static) STYPE(12) SIZE(104.8, 15.3) FPOS(0.1,0.1) RESIZE(yn) CTYPE(2)
* ID Majetku
  TYPE(Static) STYPE(12) SIZE(104,2.8) FPOS(0.5,0.1) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Inventární èíslo)   CPOS( 2, 0.2) CLEN( 15)
    TYPE(Text) NAME(nInvCis)               CPOS( 2, 1.2) CLEN( 20) BGND(13) FONT(5) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION( Název majetku)     CPOS(23, 0.2) CLEN( 16)
    TYPE(Text) NAME(cNazev)                CPOS(23, 1.2) CLEN( 40) BGND(13) FONT(5) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Úèet.sk.)           CPOS(64, 0.2) CLEN( 10)
    TYPE(Text) NAME(nUcetSkup)             CPOS(64, 1.2) CLEN( 10) BGND(13) FONT(5) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název skupiny)      CPOS(75, 0.2) CLEN( 14)
    TYPE(Text) NAME(C_UctSkZ->cNazUctSk)   CPOS(75, 1.2) CLEN( 28) BGND(13) FONT(5) GROUPS(clrGREEN)
  TYPE(End)

* Karta pohybu
  TYPE(Static) STYPE(12) SIZE(104,12.2) FPOS(0.5, 3) RESIZE(yx) CTYPE(2)
    TYPE(GET)  NAME(ZMAJUZw->cTypPohybu)   FPOS(  15, 0.5) FLEN(10) FCAPTION(Druh pohybu) CPOS( 2,0.5) PP(2) PUSH(C_TypPoh_sel)
    TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh) CPOS(  27, 0.5) CLEN(30) BGND(13)
    TYPE(Text) CAPTION( Období)           CPOS(80, 0.5) CLEN( 6) PP(2)
    TYPE(Text) NAME(M->nAktObd)           CPOS(86, 0.5) CLEN( 5) BGND(13) PP(2) FONT(5)
    TYPE(Text) CAPTION(/)                 CPOS(91, 0.5) CLEN( 2)          PP(2) FONT(5)
    TYPE(Text) NAME(M->nAktROK)           CPOS(93, 0.5) CLEN( 6) BGND(13) PP(2) FONT(5)

    TYPE(Static) FPOS( 0.5, 1.7) SIZE(103,.2) STYPE(16) RESIZE(yy) CTYPE(2)
*
    TYPE(GET)  NAME(ZMAJUZw->nDoklad)     FPOS(25, 2.5) FLEN(15) FCAPTION(Èíslo dokladu) CPOS(2, 2.5) GROUPS(100,201,202,203,204,301)
    TYPE(GET)  NAME(ZMAJUZw->dDatZmeny)   FPOS(25, 3.5) FLEN(15) FCAPTION(Datum zmìny)   CPOS(2, 3.5) PUSH(ClickDATE) GROUPS(100,201,202,203,204,301)

*   Karta 400
**    TYPE(Text) CAPTION(Zvýšení vst.ceny úèetní o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(201)
**    TYPE(Text) CAPTION(Snížení vst.ceny úèetní o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(202,203)
**    TYPE(Text) CAPTION(Zvýšení vst.ceny daòové o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(201)
**    TYPE(Text) CAPTION(Snížení vst.ceny daòové o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(202,203)
**    TYPE(Text) CAPTION(Snížení oprávek úèetních o)     CPOS( 2, 6.5) CLEN( 20) GROUPS(203)
**    TYPE(Text) CAPTION(Snížení oprávek daòových o)     CPOS( 2, 7.5) CLEN( 22) GROUPS(203)

**    TYPE(GET)  NAME(ZMAJUZw->nZmenVstCU)  FPOS(25, 4.5) FLEN(15) GROUPS(201,202,203)
**    TYPE(GET)  NAME(ZMAJUZw->nZmenVstCD)  FPOS(25, 5.5) FLEN(15) GROUPS(201,202,203)
**    TYPE(GET)  NAME(ZMAJUZw->nZmenOprU)   FPOS(25, 6.5) FLEN(15) GROUPS(203)
**    TYPE(GET)  NAME(ZMAJUZw->nZmenOprD)   FPOS(25, 7.5) FLEN(15) GROUPS(203)

    TYPE(Text) CAPTION(Zvýšení vst.ceny daòové o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(201)
    TYPE(Text) CAPTION(Snížení vst.ceny daòové o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(202,203)
    TYPE(Text) CAPTION(Zvýšení vst.ceny úèetní o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(201)
    TYPE(Text) CAPTION(Snížení vst.ceny úèetní o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(202,203)
    TYPE(Text) CAPTION(Snížení oprávek daòových o)     CPOS( 2, 6.5) CLEN( 20) GROUPS(203)
    TYPE(Text) CAPTION(Snížení oprávek úèetních o)     CPOS( 2, 7.5) CLEN( 22) GROUPS(203)

    TYPE(GET)  NAME(ZMAJUZw->nZmenVstCD)  FPOS(25, 4.5) FLEN(15) GROUPS(201,202,203)
    TYPE(GET)  NAME(ZMAJUZw->nZmenVstCU)  FPOS(25, 5.5) FLEN(15) GROUPS(201,202,203)
    TYPE(GET)  NAME(ZMAJUZw->nZmenOprD)   FPOS(25, 6.5) FLEN(15) GROUPS(203)
    TYPE(GET)  NAME(ZMAJUZw->nZmenOprU)   FPOS(25, 7.5) FLEN(15) GROUPS(203)

*
    TYPE(Text) CAPTION(Variabilní symbol) CPOS( 2, 4.5) CLEN(20) GROUPS(301)
    TYPE(GET)  NAME(ZMAJUZw->cVarSym)      FPOS(25, 4.5) FLEN(15) GROUPS(301)
*
    TYPE(Text) CAPTION( Hodnota)                  CPOS(67, 1.8) CLEN( 8)         GROUPS(201,202,203)
    TYPE(Text) CAPTION( pùvodní)                  CPOS(77, 1.8) CLEN( 8) FONT(5) GROUPS(201,202,203)
    TYPE(Text) CAPTION(    nová)                  CPOS(97, 1.8) CLEN( 5) FONT(5) GROUPS(201,202,203)

    TYPE(Text) CAPTION( Vstupní cena úèetní)      CPOS(45, 2.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nCenaVstUo)           FPOS(67, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nCenaVstUn)           FPOS(85, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Vstupní cena daòová)      CPOS(45, 3.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nCenaVstDo)           FPOS(67, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nCenaVstDn)           FPOS(85, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Roèní daòový odpis - %)   CPOS(45, 4.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nProcDanOo)           FPOS(67, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nProcDanOn)           FPOS(85, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Roèní daòový odpis - KÈ)  CPOS(45, 5.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nDanOdpRo)            FPOS(67, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nDanOdpRn)            FPOS(85, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Roèní úèetní odpis - %)   CPOS(45, 6.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nProcUctOo)           FPOS(67, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nProcUctOn)           FPOS(85, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Roèní úèetní odpis - KÈ)  CPOS(45, 7.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nUctOdpRo)            FPOS(67, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nUctOdpRn)            FPOS(85, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(Text) CAPTION( Mìsíèní úèetní odpis)     CPOS(45, 8.8) CLEN( 20) GROUPS(201,202)
    TYPE(GET ) NAME(ZMAJUZw->nUctOdpMo)            FPOS(67, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)
    TYPE(GET ) NAME(ZMAJUZw->nUctOdpMn)            FPOS(85, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,clrINFO)

    TYPE(Text) CAPTION( Vstupní cena úèetní)      CPOS(45, 2.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nCenaVstUo)           CPOS(67, 2.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nCenaVstUn)           CPOS(85, 2.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Vstupní cena daòová)      CPOS(45, 3.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nCenaVstDo)           CPOS(67, 3.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nCenaVstDn)           CPOS(85, 3.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Oprávky úèetní)           CPOS(45, 4.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nOprUcto)             CPOS(67, 4.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nOprUctn)             CPOS(85, 4.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Oprávky daòové)           CPOS(45, 5.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nOprDano)             CPOS(67, 5.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nOprDann)             CPOS(85, 5.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Roèní daòový odpis - %)   CPOS(45, 6.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nProcDanOo)           CPOS(67, 6.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nProcDanOn)           CPOS(85, 6.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Roèní daòový odpis - KÈ)  CPOS(45, 7.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nDanOdpRo)            CPOS(67, 7.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nDanOdpRn)            CPOS(85, 7.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Roèní úèetní odpis - %)   CPOS(45, 8.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nProcUctOo)           CPOS(67, 8.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nProcUctOn)           CPOS(85, 8.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Roèní úèetní odpis - KÈ)  CPOS(45, 9.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nUctOdpRo)            CPOS(67, 9.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nUctOdpRn)            CPOS(85, 9.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) CAPTION( Mìsíèní úèetní odpis)     CPOS(45,10.8) CLEN( 20) GROUPS(203)
    TYPE(Text) NAME(ZMAJUZw->nUctOdpMo)            CPOS(67,10.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(Text) NAME(ZMAJUZw->nUctOdpMn)            CPOS(85,10.8) CLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

* Karta 204 = úèetní odpis
    TYPE(Text) CAPTION(Úèetní odpis)              CPOS( 2, 4.5) CLEN( 20) GROUPS(204)
    TYPE(TEXT) NAME(ZMAJUZw->nUctOdpMes)           CPOS(25, 4.5) CLEN( 16) BGND(13) PP(2) CTYPE(2) GROUPS(204)

  TYPE(End)
TYPE(End)