TYPE(drgForm) DTYPE(10) TITLE( ZVI - Likvidace dle úèetních pøedpisù ) SIZE(110,25) ;
              GUILOOK(Action:y)

TYPE(Action) CAPTION(info ~Zvíøete )  EVENT( ZVI_ZVKARTY_INFO) TIPTEXT(Informaèní karta zvíøete )

* Pøehled úèetních pøedpisù
  TYPE(DBrowse) FPOS(0,0.1) SIZE(110,16) FILE(UCETPOL) INDEXORD(1);
                 FIELDS( cObdobi:Úè. období    ,;
                         cUcetMD    ,;
                         cUcetDAL   ,;
                         nKcMD      ,;
                         nKcDAL     ,;
                         cText:Text:40      ,;
                         nDoklad:Doklad    ,;
                         cUzavreni:Uzv.  );
                 CURSORMODE(3) SCROLL(ny) PP(7) Resize(ny) POPUPMENU(y);
                 ITEMMARKED( ItemMarked)

  TYPE(Text) CAPTION( POPIS DOKLADU)   CPOS( 0.1,16.2) CLEN( 109.8) BGND(12) FONT(5) CTYPE(1) RESIZE(y)

  TYPE(Static) STYPE(12) SIZE(108,7.6) FPOS(1,17.3) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Doklad)             CPOS( 1, 0.2) CLEN( 16)
    TYPE(TEXT) NAME(ZvZmenHD->nDoklad)     CPOS(18, 0.2) CLEN( 12) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Položka dokladu )   CPOS( 1, 1.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nOrdItem)    CPOS(18, 1.2) CLEN( 12) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Druh pohybu )       CPOS( 1, 2.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nDrPohyb)    CPOS(18, 2.2) CLEN( 12) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Stredisko )         CPOS( 1, 3.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->cNazPol1)    CPOS(18, 3.2) CLEN( 12) BGND( 13)          FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Stáj )              CPOS( 1, 4.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->cNazPol4)    CPOS(18, 4.2) CLEN( 12) BGND( 13)          FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Kategorie )         CPOS( 1, 5.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nZvirKat)    CPOS(18, 5.2) CLEN( 12) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Výkon )             CPOS( 1, 6.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->cNazPol2)    CPOS(18, 6.2) CLEN( 12) BGND( 13)          FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Skladová cena )     CPOS( 35, 2.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaSZV)    CPOS( 52, 2.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Kusy zvíøat)        CPOS( 35, 3.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nKusyZV)     CPOS( 52, 3.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Množství na stáji)  CPOS( 35, 4.2) CLEN( 14)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaSZV)    CPOS( 52, 4.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Cena celkem )       CPOS( 35, 5.2) CLEN( 12)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaCZV)    CPOS( 52, 5.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(PC zákl. bez danì)  CPOS( 72, 2.2) CLEN( 14)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaPZV)    CPOS( 89, 2.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(PC zákl. s daní)    CPOS( 72, 3.2) CLEN( 14)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaMZV)    CPOS( 89, 3.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(PC celkem bez danì) CPOS( 72, 4.2) CLEN( 16)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaPCeZV)  CPOS( 89, 4.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(PC celkem s daní)   CPOS( 72, 5.2) CLEN( 14)
    TYPE(TEXT) NAME(ZvZmenHD->nCenaMCeZV)  CPOS( 89, 5.2) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS( clrGREY)


  TYPE(End)

* Nákladová struktura
*  TYPE(Static) STYPE(11) SIZE(103,2.6) FPOS(1,23.3) RESIZE(y) CTYPE(2)
*    TYPE(Text) CAPTION(Nákl. struktura)      CPOS( 2,1.2) FONT(5)
*    TYPE(Text) CAPTION(Výr.støed.)           CPOS(17, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS(17,1.2) CLEN(12) BGND(13) PP(2)
*    TYPE(Text) FCAPTION(Výrobek)             CPOS(30, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(30,1.2) CLEN(12) BGND(13) PP(2)
*    TYPE(Text) FCAPTION(Zakázka)             CPOS(43, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(43,1.2) CLEN(12) BGND(13) PP(2)
*    TYPE(Text) FCAPTION(Výr. místo)          CPOS(56, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(56,1.2) CLEN(12) BGND(13) PP(2)
*    TYPE(Text) FCAPTION(Stroj)               CPOS(69, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(69,1.2) CLEN(12) BGND(13) PP(2)
*    TYPE(Text) FCAPTION(Výr. operace)        CPOS(82, .2)          BGND( 1) PP(3)
*    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(82,1.2) CLEN(12) BGND(13) PP(2)
*  TYPE(End)