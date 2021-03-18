TYPE(drgForm) DTYPE(10) TITLE( Likvidace dle dokladù) SIZE(100,26) ;
              GUILOOK(Action:y,Menu:n)

TYPE(Action) CAPTION(info ~Majetku)  EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku  )
TYPE(Action) CAPTION(~Pøeúètuj)      EVENT(PREUCTUJ)     TIPTEXT(Pøeúètování vybraných pohybových dokladù )

* Doklady
  TYPE(DBrowse) FILE(ZMAJUZ) INDEXORD(3);
               FIELDS( nDoklad    ,;
                       cObdobi:Obd.zmìny ,;
                       nInvCis    ,;
                       nUcetSkup    ,;
                       C_UctSkZ->cNazUctSk ,;
                       cTypPohybu:Pohyb   ,;
                       C_TypPoh->cNazTypPoh:Název pohybu ) ;
               FPOS(0,.1) SIZE(100,12) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(ny) POPUPMENU(y) ;
               ITEMMARKED(itemMarked)

  TYPE(Static) STYPE(12) SIZE(98,5.8) FPOS(1,12.3) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Inventární èíslo)  CPOS( 1, 0.2) CLEN( 16)
    TYPE(TEXT) NAME(MAJZ->nInvCis)         CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) PP(2) FONT(5)
    TYPE(TEXT) NAME(MAJZ->cNazev)          CPOS(32, 0.2) CLEN( 31) BGND( 13) FONT(5)
    TYPE(Text) CAPTION(Èíslo dokladu )    CPOS(68, 0.2) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJUZ->nDOKLAD)       CPOS(81, 0.2) CLEN( 10) BGND( 13) CTYPE(2) PP(2) FONT(5)


    TYPE(TEXT) CAPTION(Vstupní cena úè.)    CPOS( 1, 1.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nCenaVstU)       CPOS(18, 1.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Oprávky úèetní)      CPOS( 1, 2.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nOprUct)         CPOS(18, 2.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Zùstatková cena úè.) CPOS( 1, 3.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nZustCenaU)      CPOS(18, 3.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Mìsíèní odpis)       CPOS( 1, 4.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nUctOdpMes)      CPOS(18, 4.4) CTYPE(2) BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Zmìna vst. ceny úè.)  CPOS(33, 1.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nZmenVstCU)       CPOS(50, 1.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Zmìna oprávek úèet.)  CPOS(33, 2.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nZmenOprU)        CPOS(50, 2.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Zmìna vst. ceny daò.) CPOS(33, 3.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nZmenVstCD)       CPOS(50, 3.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Zmìna oprávek daò.)   CPOS(33, 4.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJUZ->nZmenOprD)        CPOS(50, 4.4) CTYPE(2) BGND( 13) PP(2)

    TYPE(TEXT) CAPTION(Dodací list)          CPOS(68, 1.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJUZ->nCisloDL)         CPOS(81, 1.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Èíslo faktury)        CPOS(68, 2.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJUZ->nCisFak)          CPOS(81, 2.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(TEXT) CAPTION(Variab. symbol   )    CPOS(68, 3.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJUZ->cVarSym)          CPOS(81, 3.4) CTYPE(2) BGND( 13) PP(2)
  TYPE(End)

* Zaúètování položky dokladu
  TYPE(dBrowse) FILE(UCETPOL) INDEXORD(1);
               FIELDS(cUcetMD, cUcetDAL, nKcMD, nKcDAL, cText, nDoklad, cObdobi, cDenik) ;
               FPOS(0,18.1) SIZE(100,4.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx)

* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,23.1) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(Nákl. struktura)      CPOS( 2,1.2) FONT(5)
    TYPE(Text) CAPTION(Výr.støed.)           CPOS(17, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS(17,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výrobek)             CPOS(30, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(30,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Zakázka)             CPOS(43, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(43,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výr. místo)          CPOS(56, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(56,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Stroj)               CPOS(69, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(69,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Výr. operace)        CPOS(82, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(82,1.2) CLEN(12) BGND(13) PP(2)
  TYPE(End)