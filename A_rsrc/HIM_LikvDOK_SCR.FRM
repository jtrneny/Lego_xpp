TYPE(drgForm) DTYPE(10) TITLE( Likvidace dle dokladù) SIZE(100,26) ;
              GUILOOK(Action:y,Menu:n)

TYPE(Action) CAPTION(info ~Majetku) EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku )
TYPE(Action) CAPTION(~Pøeúètuj)     EVENT(PREUCTUJ)     TIPTEXT(Pøeúètování vybraných pohybových dokladù )

* Doklady
  TYPE(DBrowse) FILE(ZMAJU) INDEXORD(3);
                FIELDS( nDoklad    ,;
                        cObdobi:Obd.zmìny ,;
                        nInvCis    ,;
                        nTypMaj    ,;
                        C_TypMaj->cNazTypu ,;
                        cTypPohybu:Pohyb   ,;
                        C_TypPoh->cNazTypPoh:Název pohybu ) ;
               FPOS(0,.1) SIZE(100,12) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(ny) POPUPMENU(y) ;
               ITEMMARKED(itemMarked)


  TYPE(Static) STYPE(12) SIZE(98,5.8) FPOS(1,12.3) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Inventární èíslo)  CPOS( 1, 0.2) CLEN( 16)
    TYPE(TEXT) NAME(MAJ->nInvCis)         CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) PP(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(TEXT) NAME(MAJ->cNazev)          CPOS(32, 0.2) CLEN( 31) BGND( 13) FONT(5)                GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Èíslo dokladu )    CPOS(68, 0.2) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJU->nDOKLAD)       CPOS(81, 0.2) CLEN( 10) BGND( 13) CTYPE(2) PP(2) FONT(5) GROUPS(clrGREEN)


    TYPE(TEXT) CAPTION(Vstupní cena úè.)    CPOS( 1, 1.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nCenaVstU)       CPOS(18, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Oprávky úèetní)      CPOS( 1, 2.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nOprUct)         CPOS(18, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Zùstatková cena úè.) CPOS( 1, 3.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nZustCenaU)      CPOS(18, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Mìsíèní odpis)       CPOS( 1, 4.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nUctOdpMes)      CPOS(18, 4.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

    TYPE(TEXT) CAPTION(Zmìna vst. ceny úè.)  CPOS(33, 1.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nZmenVstCU)       CPOS(50, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Zmìna oprávek úèet.)  CPOS(33, 2.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nZmenOprU)        CPOS(50, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Zmìna vst. ceny daò.) CPOS(33, 3.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nZmenVstCD)       CPOS(50, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Zmìna oprávek daò.)   CPOS(33, 4.4) CLEN( 16)
    TYPE(TEXT) NAME(ZMAJU->nZmenOprD)        CPOS(50, 4.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

    TYPE(TEXT) CAPTION(Dodací list)          CPOS(68, 1.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJU->nCisloDL)         CPOS(81, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Èíslo faktury)        CPOS(68, 2.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJU->nCisFak)          CPOS(81, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(TEXT) CAPTION(Variab. symbol   )    CPOS(68, 3.4) CLEN( 12)
    TYPE(TEXT) NAME(ZMAJU->cVarSym)          CPOS(81, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
  TYPE(End)

* Zaúètování položky dokladu
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                FIELDS( cUcetMD  ,;
                        cUcetDAL ,;
                        nKcMD    ,;
                        nKcDAL   ,;
                        cText    ,;
                        nDoklad  ,;
                        cObdobi  ,;
                        cDenik) ;
                FPOS(0,18.1) SIZE(100,4.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx)

* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,23.1) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(Výr.støed.)           CPOS( 2, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS( 2,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výrobek)             CPOS(18, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(18,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Zakázka)             CPOS(34, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(34,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výr. místo)          CPOS(50, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(50,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Stroj)               CPOS(66, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(66,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výr. operace)        CPOS(82, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(82,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)

  TYPE(End)