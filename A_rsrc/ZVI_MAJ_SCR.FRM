TYPE(drgForm) DTYPE(10) TITLE(Kmenové údaje souboru zvíøat) SIZE(110,25) FILE(MAJZ);
              CARGO( HIM_MAJ_CRD) OBDOBI(ZVI)  ;
              PRINTFILES(zmajuz:ntypmaj=ntypmaj+ninvcis=ninvcis)

TYPE(Action) CAPTION(~Pohyby) EVENT(HIM_POHYBY) TIPTEXT(Pohyby majetkových zvíøat)

  TYPE(DBrowse) FILE(MAJZ) INDEXORD(1) ;
                FIELDS( HIM_ZnAkt('MAJZ';'U'):sU:2.6::2,;
                        HIM_ZnAkt('MAJZ';'D'):sD:2.6::2,;
                        CNAZPOL1:Stredisko ,;
                        CNAZPOL4   ,;
                        NZVIRKAT   ,;
                        NINVCIS    ,;
                        CNAZEV     ,;
                        NCENAVSTU  ,;
                        NOPRUCT    ,;
                        NCENAVSTD  ,;
                        NOPRDAN    ,;
                        nCenaPorU  ,;
                        nDotaceUct ,;
                        nCenaPorD  ,;
                        nDotaceDan );
                SIZE(110,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Základní údaje
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0, 14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(1,82) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(109.5 ,9.4) FPOS(0.2, 0.1) RESIZE(yx)
*   1.SL.
    TYPE(Text) CAPTION(Úèetní skupina)    CPOS(  1, 0.5) CLEN( 14)
    TYPE(Text) NAME(nUcetSkup)            CPOS( 16, 0.5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(C_UctSkZ->cNazUctSk)  CPOS( 25, 0.5) CLEN( 30) BGND(13)                   GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Tøída - obor)      CPOS(  1, 1.5) CLEN( 14)
    TYPE(Text) NAME(nTrObor)              CPOS( 16, 1.5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Umístìní majetku)  CPOS(  1, 2.5) CLEN( 14)
*    TYPE(Text) NAME(cUmisteni)            CPOS( 16, 2.5) CLEN( 30) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text)  CAPTION( ------------------------Úèetní)   CPOS(  1, 3.7) CLEN( 27) FONT(2)
    TYPE(Text)  CAPTION( ------------------------Daòová)   CPOS( 18, 3.7) CLEN( 27) FONT(2)
    TYPE(Text) CAPTION( Odpisová skupina) CPOS(  1, 5) CLEN( 14)
    TYPE(Text) NAME(cOdpiSk)              CPOS( 16, 5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(cOdpiSkD)             CPOS( 33, 5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ odpisu)        CPOS(  1, 6) CLEN( 14)
    TYPE(Text) NAME(nTypUOdpi)            CPOS( 16, 6) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(nTypDOdpi)            CPOS( 33, 6) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Doba odpisu)       CPOS(  1, 7) CLEN( 14)
    TYPE(Text) NAME(nRokyOdpiU)           CPOS( 16, 7) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(nRokyOdpiD)           CPOS( 33, 7) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Znak aktivity)     CPOS(  1, 8) CLEN( 14)
    TYPE(Text) NAME(nZnAkt)               CPOS( 16, 8) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(nZnAktD)              CPOS( 33, 8) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)

*   2.SL
    TYPE(Text)  CAPTION( ------------Úèetní)   CPOS( 75, 0.3) CLEN( 16) FONT(2)
    TYPE(Text)  CAPTION( ------------Daòová)   CPOS( 92, 0.3) CLEN( 16) FONT(2)
*
    TYPE(Text)  CAPTION(Poøizovací cena)       CPOS(57, 1.5) CLEN( 18)
    TYPE(TEXT)  NAME(nCenaPorU)                CPOS(75, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text)  CAPTION(Hodnota dotace)        CPOS(57, 2.5) CLEN( 18)
    TYPE(TEXT)  NAME(nDotaceUct)               CPOS(75, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text)  CAPTION(Vstupní cena )         CPOS(57, 3.5) CLEN( 15)
    TYPE(TEXT)  NAME(nCenaVstU)                CPOS(75, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text)  CAPTION( Oprávky celkem)       CPOS(57, 4.5) CLEN( 15)
    TYPE(TEXT)  NAME(nOprUct)                  CPOS(75, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text)  CAPTION(Zùstatková cena)       CPOS(57, 5.5) CLEN( 18)
    TYPE(TEXT)  NAME(M->ZustCenaU)             CPOS(75, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
*
    TYPE(TEXT)  NAME(nCenaPorD)                CPOS(92, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(TEXT)  NAME(nDotaceDan)               CPOS(92, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(TEXT)  NAME(nCenaVstD)                CPOS(92, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(TEXT)  NAME(nOprDan)                  CPOS(92, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(TEXT)  NAME(M->ZustCenaD)             CPOS(92, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrYELLOW)

*
    TYPE(Text)  CAPTION(Období zaøazení-vyøazení)CPOS(55, 8) CLEN( 20)
    TYPE(TEXT)  NAME(cObdZar)                  CPOS(75, 8) CLEN( 6) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text)  CAPTION(-)                     CPOS(82, 8) CLEN(  2)
    TYPE(TEXT)  NAME(cObdVyraz)                CPOS(86, 8) CLEN( 6) BGND(13) FONT(5) GROUPS(clrGREY)

    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* Zmìny ÚÈETNÍ
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny úèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(16,68) PRE( tabSelect)

    TYPE(DBrowse) FILE(ZMAJUZ) INDEXORD(9);
                  FIELDS( cTypPohybu:Pohyb,;
                          C_TYPPOH->cNazTypPoh:Název pohybu:20,;
                          nDoklad    ,;
                          nOrdItem   ,;
                          dDatZmeny  ,;
                          cObdobi:Období,;
                          nUctOdpMes ,;
                          nCenaVstU  ,;
                          nZmenVstCU ,;
                          nZmenVstCD ,;
                          nOprUct    ,;
                          nZmenOprU  ,;
                          nZmenOprD  );
                  SIZE(105,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
  TYPE(End)


* Zmìny NEÚÈETNÍ
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny neúèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(31,53)  PRE( tabSelect)

    TYPE(DBrowse) FILE(ZMAJNZ) INDEXORD(1);
                  FIELDS(dDatZmeny   ,;
                         cPopisZme::15   ,;
                         cNazPolZme::20  ,;
                         cOldHodn::30    ,;
                         cNewHodn::30    );
                  SIZE(105,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)

  TYPE(End)

* Popis majetku
  TYPE(TabPage) TTYPE(4) CAPTION(Popis majetku) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(46,38)  PRE( tabSelect)
    TYPE(MLE) NAME('MAJZ->mPopis') FPOS( 1, 0.2) SIZE( 103, 9) RESIZE(yx) READONLY(y)
  TYPE(End)

* Archiv daò.stavù
  TYPE(TabPage) TTYPE(4) CAPTION(Archiv daòový) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(61,23) PRE( tabSelect)

    TYPE(DBrowse) FILE(DMAJZ) INDEXORD(2);
                  FIELDS(nRokOdpisu   ,;
                         cOdpiSk      ,;
                         nTypDOdpi    ,;
                         nProcDanOd   ,;
                         nDanOdpRok   );
                  SIZE(105,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)

  TYPE(End)

* Archiv úèet.stavù
  TYPE(TabPage) TTYPE(4) CAPTION(Archiv úèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(76,8) PRE( tabSelect)

    TYPE(DBrowse) FILE(UMAJZ) INDEXORD(2);
                  FIELDS(nRokOdpisu   ,;
                         cOdpiSk      ,;
                         nTypUOdpi    ,;
                         nProcUctOd   ,;
                         nUctOdpRok   );
                  SIZE(105,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)

  TYPE(End)