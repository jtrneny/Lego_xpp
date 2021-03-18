TYPE(drgForm) DTYPE(10) TITLE(Pohyby majetku ...) SIZE(105, 25) FILE(MAJ);
               GUILOOK(Action:y,Message:n,IconBar:y:drgStdBrowseIconBar,Menu:n);
               CARGO( HIM_MAJ_CRD) POST(POSTVALIDATE) OBDOBI(HIM)

TYPE(Action) CAPTION( info ~Majetku) EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku )
TYPE(Action) CAPTION( ~Likvidace)    EVENT(LikvDOKL)     TIPTEXT(zaúètování dokladu )

* Seznam pohybù
  TYPE(TEXT) CAPTION(Úèetní zmìny) CPOS(.1,15.5) CLEN(104.9) FONT(5) PP(3) BGND(11)  RESIZE(yn) CTYPE(1)
  TYPE(DBrowse) FILE(ZMAJUw) INDEXORD(2);
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
  TYPE(Static) STYPE(12) SIZE(104,2.8) FPOS(0.5,0.1) RESIZE(yx)
    TYPE(Text) CAPTION(Inventární èíslo)   CPOS( 2, 0.2) CLEN( 15)
    TYPE(Text) NAME(nInvCis)               CPOS( 2, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREEN) CTYPE(2)
    TYPE(Text) CAPTION( Název majetku)     CPOS(23, 0.2) CLEN( 16)
    TYPE(Text) NAME(cNazev)                CPOS(23, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Typ maj.)           CPOS(64, 0.2) CLEN( 10)
    TYPE(Text) NAME(nTypMAJ)               CPOS(64, 1.2) CLEN( 10) BGND(13) FONT(5) GROUPS(clrGREEN) CTYPE(2)
    TYPE(Text) CAPTION(Název typu)         CPOS(75, 0.2) CLEN( 10)
    TYPE(Text) NAME(C_TypMAJ->cNazTypu)    CPOS(75, 1.2) CLEN( 28) BGND(13) PP(2) FONT(5) GROUPS(clrGREEN)
  TYPE(End)

* Karta pohybu
  TYPE(Static) STYPE(12) SIZE(104,12.2) FPOS(0.5, 3) RESIZE(yx) CTYPE(2)
**    TYPE(GET)  NAME(ZMAJUw->nDrPohyb)     FPOS(15, 0.5) FLEN(10) FCAPTION(Druh pohybu) CPOS(2,0.5) PUSH(DrPohyb_sel)
**    TYPE(Text) NAME(C_DrPohI->cNazevPoh)  CPOS(27, 0.5) CLEN( 30) BGND(13) PP(2)
    TYPE(GET)  NAME(ZMAJUw->cTypPohybu)   FPOS(  15, 0.5) FLEN(10) FCAPTION(Druh pohybu) CPOS( 2,0.5) PP(2) PUSH(C_TypPoh_sel)
    TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh) CPOS(  27, 0.5) CLEN(50) FONT(5)

    TYPE(Text) CAPTION( Období)           CPOS(80, 0.5) CLEN( 6) PP(2)
    TYPE(Text) NAME(M->nAktObd)           CPOS(86, 0.5) CLEN( 5) BGND(13) PP(2) FONT(5) GROUPS(clrINFO)
    TYPE(Text) CAPTION(/)                 CPOS(91, 0.5) CLEN( 2)          PP(2) FONT(5)
    TYPE(Text) NAME(M->nAktROK)           CPOS(93, 0.5) CLEN( 6) BGND(13) PP(2) FONT(5) GROUPS(clrINFO)

    TYPE(Static) FPOS( 0.5, 1.7) SIZE(103,.2) STYPE(16) RESIZE(yy) CTYPE(2)
*
    TYPE(GET)  NAME(ZMAJUw->nDoklad)     FPOS(25, 2.5) FLEN(15) FCAPTION(Èíslo dokladu) CPOS(2, 2.5) GROUPS(100,201,202,203,204,207,301)
    TYPE(GET)  NAME(ZMAJUw->dDatZmeny)   FPOS(25, 3.5) FLEN(15) FCAPTION(Datum zmìny)   CPOS(2, 3.5) PUSH(CLICKDATE) GROUPS(100,201,202,203,204,207,301)
*
**    TYPE(Text) CAPTION(Tech.zhodn. vst.ceny úèetní o)  CPOS( 2, 4.5) CLEN( 23) GROUPS(201)
**    TYPE(Text) CAPTION(Zvýšení vst.ceny úèetní o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(207)
**    TYPE(Text) CAPTION(Snížení vst.ceny úèetní o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(202,203)
**    TYPE(Text) CAPTION(Tech.zhodn. vst.ceny daòové o)  CPOS( 2, 5.5) CLEN( 23) GROUPS(201)
**    TYPE(Text) CAPTION(Zvýšení vst.ceny daòové o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(207)
**    TYPE(Text) CAPTION(Snížení vst.ceny daòové o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(202,203)
**    TYPE(Text) CAPTION(Snížení oprávek úèetních o)     CPOS( 2, 6.5) CLEN( 20) GROUPS(203)
**    TYPE(Text) CAPTION(Snížení oprávek daòových o)     CPOS( 2, 7.5) CLEN( 22) GROUPS(203)

**    TYPE(GET)  NAME(ZMAJUw->nZmenVstCU)  FPOS(25, 4.5) FLEN(15) GROUPS(201,202,203,207)
**    TYPE(GET)  NAME(ZMAJUw->nZmenVstCD)  FPOS(25, 5.5) FLEN(15) GROUPS(201,202,203,207)
**    TYPE(GET)  NAME(ZMAJUw->nZmenOprU)   FPOS(25, 6.5) FLEN(15) GROUPS(203)
**    TYPE(GET)  NAME(ZMAJUw->nZmenOprD)   FPOS(25, 7.5) FLEN(15) GROUPS(203)

    TYPE(Text) CAPTION(Tech.zhodn. vst.ceny daòové o)  CPOS( 2, 4.5) CLEN( 23) GROUPS(201)
    TYPE(Text) CAPTION(Zvýšení vst.ceny daòové o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(207)
    TYPE(Text) CAPTION(Snížení vst.ceny daòové o)      CPOS( 2, 4.5) CLEN( 20) GROUPS(202,203)
    TYPE(Text) CAPTION(Tech.zhodn. vst.ceny úèetní o)  CPOS( 2, 5.5) CLEN( 23) GROUPS(201)
    TYPE(Text) CAPTION(Zvýšení vst.ceny úèetní o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(207)
    TYPE(Text) CAPTION(Snížení vst.ceny úèetní o)      CPOS( 2, 5.5) CLEN( 20) GROUPS(202,203)
    TYPE(Text) CAPTION(Snížení oprávek daòových o)     CPOS( 2, 6.5) CLEN( 22) GROUPS(203)
    TYPE(Text) CAPTION(Snížení oprávek úèetních o)     CPOS( 2, 7.5) CLEN( 20) GROUPS(203)

    TYPE(GET)  NAME(ZMAJUw->nZmenVstCD)  FPOS(25, 4.5) FLEN(15) GROUPS(201,202,203,207)
    TYPE(GET)  NAME(ZMAJUw->nZmenVstCU)  FPOS(25, 5.5) FLEN(15) GROUPS(201,202,203,207)
    TYPE(GET)  NAME(ZMAJUw->nZmenOprD)   FPOS(25, 6.5) FLEN(15) GROUPS(203)
    TYPE(GET)  NAME(ZMAJUw->nZmenOprU)   FPOS(25, 7.5) FLEN(15) GROUPS(203)

*
    TYPE(Text) CAPTION(Variabilní symbol) CPOS( 2, 4.5) CLEN(20) GROUPS(301)
    TYPE(GET)  NAME(ZMAJUw->cVarSym)      FPOS(25, 4.5) FLEN(15) GROUPS(301)
*
    TYPE(Text) CAPTION( Hodnota)                  CPOS(67, 1.8) CLEN( 8) GROUPS(201,202,203,207)
    TYPE(Text) CAPTION( PÙVODNÍ)                  CPOS(77, 1.8) CLEN( 8) GROUPS(201,202,203,207)
    TYPE(Text) CAPTION(    NOVÁ)                  CPOS(97, 1.8) CLEN( 5) GROUPS(201,202,203,207)
***
    TYPE(Text) CAPTION( Vstupní cena úèetní)      CPOS(45, 2.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstUo)           FPOS(67, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstUn)           FPOS(85, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Vstupní cena daòová)      CPOS(45, 3.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstDo)           FPOS(67, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstDn)           FPOS(85, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Roèní daòový odpis - %)   CPOS(45, 4.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nProcDanOo)           FPOS(67, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nProcDanOn)           FPOS(85, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Roèní daòový odpis - KÈ)  CPOS(45, 5.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nDanOdpRo)            FPOS(67, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nDanOdpRn)            FPOS(85, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Roèní úèetní odpis - %)   CPOS(45, 6.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nProcUctOo)           FPOS(67, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nProcUctOn)           FPOS(85, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Roèní úèetní odpis - KÈ)  CPOS(45, 7.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpRo)            FPOS(67, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpRn)            FPOS(85, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)

    TYPE(Text) CAPTION( Mìsíèní úèetní odpis)     CPOS(45, 8.8) CLEN( 20) GROUPS(201,202,207)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpMo)            FPOS(67, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpMn)            FPOS(85, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(201,202,207,clrINFO)
***
    TYPE(Text) CAPTION( Vstupní cena úèetní)      CPOS(45, 2.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstUo)           FPOS(67, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstUn)           FPOS(85, 2.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Vstupní cena daòová)      CPOS(45, 3.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstDo)           FPOS(67, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nCenaVstDn)           FPOS(85, 3.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Oprávky úèetní)           CPOS(45, 4.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nOprUcto)             FPOS(67, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nOprUctn)             FPOS(85, 4.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Oprávky daòové)           CPOS(45, 5.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nOprDano)             FPOS(67, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nOprDann)             FPOS(85, 5.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Roèní daòový odpis - %)   CPOS(45, 6.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nProcDanOo)           FPOS(67, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nProcDanOn)           FPOS(85, 6.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Roèní daòový odpis - KÈ)  CPOS(45, 7.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nDanOdpRo)            FPOS(67, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nDanOdpRn)            FPOS(85, 7.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Roèní úèetní odpis - %)   CPOS(45, 8.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nProcUctOo)           FPOS(67, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nProcUctOn)           FPOS(85, 8.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Roèní úèetní odpis - KÈ)  CPOS(45, 9.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpRo)            FPOS(67, 9.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpRn)            FPOS(85, 9.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

    TYPE(Text) CAPTION( Mìsíèní úèetní odpis)     CPOS(45,10.8) CLEN( 20) GROUPS(203)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpMo)            FPOS(67,10.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)
    TYPE(GET ) NAME(ZMAJUw->nUctOdpMn)            FPOS(85,10.8) FLEN( 17) BGND(13) PP(2) CTYPE(2) GROUPS(203,clrINFO)

* Karta 204 = úèetní odpis
    TYPE(Text) CAPTION(Úèetní odpis)              CPOS( 2, 4.5) CLEN( 20) GROUPS(204)
    TYPE(TEXT) NAME(ZMAJUw->nUctOdpMes)           CPOS(25, 4.5) CLEN( 16) BGND(13) PP(2) CTYPE(2) GROUPS(204)

  TYPE(End)
TYPE(End)