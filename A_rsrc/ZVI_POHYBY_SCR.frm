TYPE(drgForm) DTYPE(10) TITLE(Pohybové doklady - dle dokladù);
              SIZE(105,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(~Tvorba dokladù) EVENT(VYBER_POHYB)  TIPTEXT(Poøizování pohybových dokladù )
TYPE(Action) CAPTION(info ~Majetku)   EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku )
TYPE(Action) CAPTION(úèetní ~Odpisy ) EVENT(ODPISY_GEN)   TIPTEXT(Generování úèetních odpisù za období )

* Seznam Dokladù
  TYPE(DBrowse) FILE(ZMAJUZ) INDEXORD(3);
                FIELDS( M->IsDoklad_LIK:L:2,;
                        nDoklad ,;
                        cObdobi ,;
                        nInvCis ,;
                        cUcetSkup ,;
                        C_UCTSKZ->cNazUctSk,;
                        cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu) ;
                SIZE(105,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) ;
                ITEMMARKED( ItemMarked)

* TYPE(Static) STYPE(12) SIZE(100,10.5) FPOS(0,14.2) Resize(nx) CTYPE(2)

* Detail dokladu
  TYPE(TabPage) TTYPE(4) CAPTION(Detail dokladu) SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(1,82)
    TYPE(Static) STYPE(12) SIZE(103,6.8) FPOS(1, .01) RESIZE(yx) CTYPE(2)
      TYPE(TEXT) CAPTION(Inventární èíslo)   CPOS( 1, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nInvCis)       CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) PP(2) FONT(5)
      TYPE(TEXT) NAME(MAJZ->cNazev)          CPOS(32, 0.2) CLEN( 31) BGND( 13) FONT(5)
      TYPE(Text) CAPTION(Èíslo dokladu )     CPOS(68, 0.2) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJUZ->nDOKLAD)       CPOS(81, 0.2) CLEN( 10) BGND( 13) CTYPE(2) PP(2) FONT(5)

      TYPE(TEXT) CAPTION(Vstupní cena úè.)    CPOS( 1, 1.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nCenaVstU)      CPOS(18, 1.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Oprávky úèetní)      CPOS( 1, 2.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nOprUct)        CPOS(18, 2.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Zùstatková cena úè.) CPOS( 1, 3.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nZustCenaU)     CPOS(18, 3.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Mìsíèní odpis)       CPOS( 1, 4.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nUctOdpMes)     CPOS(18, 4.4) CTYPE(2) BGND( 13) PP(2)

      TYPE(TEXT) CAPTION(Zmìna vst. ceny úè.)  CPOS(33, 1.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nZmenVstCU)      CPOS(50, 1.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Zmìna oprávek úèet.)  CPOS(33, 2.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nZmenOprU)       CPOS(50, 2.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Zmìna vst. ceny daò.) CPOS(33, 3.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nZmenVstCD)      CPOS(50, 3.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Zmìna oprávek daò.)   CPOS(33, 4.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJUZ->nZmenOprD)       CPOS(50, 4.4) CTYPE(2) BGND( 13) PP(2)

      TYPE(TEXT) CAPTION(Dodací list)          CPOS(68, 1.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJUZ->nCisloDL)        CPOS(81, 1.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Èíslo faktury)        CPOS(68, 2.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJUZ->nCisFak)         CPOS(81, 2.4) CTYPE(2) BGND( 13) PP(2)
      TYPE(TEXT) CAPTION(Variab. symbol   )    CPOS(68, 3.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJUZ->cVarSym)         CPOS(81, 3.4) CTYPE(2) BGND( 13) PP(2)
    TYPE(End)

*   Nákladová struktura
    TYPE(Static) STYPE(11) SIZE(103,2.6) FPOS(1, 6.9) RESIZE(yx) CTYPE(2)
      TYPE(Text) CAPTION(Nákl. struktura)      CPOS( 2,1.2) FONT(5)
      TYPE(Text) CAPTION(Výr.støed.)           CPOS(17, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL1)        CPOS(17,1.2) CLEN(12) BGND(13) PP(2) GROUPS(clrYELLOW)
      TYPE(Text) FCAPTION(Výrobek)             CPOS(30, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL2)        CPOS(30,1.2) CLEN(12) BGND(13) PP(2)
      TYPE(Text) FCAPTION(Zakázka)             CPOS(43, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL3)        CPOS(43,1.2) CLEN(12) BGND(13) PP(2)
      TYPE(Text) FCAPTION(Výr. místo)          CPOS(56, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL4)        CPOS(56,1.2) CLEN(12) BGND(13) PP(2)
      TYPE(Text) FCAPTION(Stroj)               CPOS(69, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL5)        CPOS(69,1.2) CLEN(12) BGND(13) PP(2)
      TYPE(Text) FCAPTION(Výr. operace)        CPOS(82, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(ZMAJUZ->cNAZPOL6)        CPOS(82,1.2) CLEN(12) BGND(13) PP(2)
    TYPE(End)
  TYPE(End)

* Detail majetku
**  TYPE(TabPage) TTYPE(4) CAPTION(Detail majetku)  SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(16,68)

*   INFO
*   1.øádek
**    TYPE(Text) CAPTION(Inv.èíslo)                 CPOS(  3, 0.5)   CLEN(  8) FONT(5)
**    TYPE(Text) NAME(MAJ->nInvCis)       CPOS(  3, 1.5)   CLEN(  8) BGND( 13) PP(2)
**  TYPE(End)