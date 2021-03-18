TYPE(drgForm) DTYPE(10) TITLE(Kmenové údaje investièního majetku) SIZE(110,25) FILE(MAJ);
              CARGO( HIM_MAJ_CRD) OBDOBI(HIM);
              PRINTFILES(zmaju:ntypmaj=ntypmaj+ninvcis=ninvcis)

TYPE(Action) CAPTION(~Pohyby)    EVENT(HIM_POHYBY)   TIPTEXT(Pohyby investièního majetku)
*   TYPE(Action) CAPTION(~pOzemek)   EVENT(HIM_POZEMEK)  TIPTEXT(Pozemek zaøazený k inventárnímu èíslu)
*   TYPE(Action) CAPTION(~Stroj)     EVENT(HIM_STROJ)    TIPTEXT(Stroj zaøazený k inventárnímu èíslu)
*   TYPE(Action) CAPTION(~Data akt.) EVENT(Data_aktual) TIPTEXT( Aktualizace dat)
*
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(p~Ozemky    ) EVENT(poz_createContext) TIPTEXT(Pohled dle pozemkù/dle pohybù na pozemcích ...)  ICON1(338) ATYPE(33)





  TYPE(DBrowse) FILE(MAJ) INDEXORD(1) ;
                FIELDS( HIM_isHmotny('MAJ'):Hm.:3 ,;
                        HIM_ZnAkt('MAJ';'U'):sU:2.6::2,;
                        HIM_ZnAkt('MAJ';'D'):sD:2.6::2,;
                        cobdZar:obdZaø                ,;
                        cobdPosOdp:obdOdp             ,;
                        NTYPMAJ:Typ,;
                        NINVCIS:invÈíslo:10           ,;
                        CNAZEV::25 ,;
                        NCENAVSTU  ,;
                        NOPRUCT    ,;
                        NCENAVSTD  ,;
                        NOPRDAN    ,;
                        nCenaPorU  ,;
                        nDotaceUct ,;
                        nCenaPorD  ,;
                        nDotaceDan ,;
                        cVykres    );
                SIZE(110,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Základní údaje
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0, 14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(1,86) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(109.5 ,9.4) FPOS(0.2, 0.1) RESIZE(yx)
*   1.SL.
    TYPE(Text) CAPTION(Typ majetku )      CPOS(  1, 0.5) CLEN( 14)
    TYPE(Text) NAME(nTypMaj)              CPOS( 16, 0.5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(C_TypMAJ->cNazTypu)   CPOS( 25, 0.5) CLEN( 30) BGND(13)                   GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Tøída - obor)      CPOS(  1, 1.5) CLEN( 14)
    TYPE(Text) NAME(nTrObor)              CPOS( 16, 1.5) CLEN(  8) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Umístìní majetku)  CPOS(  1, 2.5) CLEN( 14)
    TYPE(Text) NAME(cUmisteni)            CPOS( 16, 2.5) CLEN( 30) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
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
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny úèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(14,73) PRE( tabSelect)

    TYPE(DBrowse) FILE(ZMAJU) INDEXORD(8);
                  FIELDS( cTypPohybu:Pohyb,;
                          C_TYPPOH->cNazTypPoh:Název pohybu:20,;
                          nDoklad,;
                          nOrdItem,;
                          dDatZmeny,;
                          cObdobi:Období   ,;
                          nUctOdpMes ,;
                          nCenaVstU  ,;
                          nZmenVstCU ,;
                          nZmenVstCD ,;
                          nOprUct    ,;
                          nZmenOprU  ,;
                          nZmenOprD  );
                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
*     nDrPohyb,;
*     C_DrPohI->cNazevPoh,;
  TYPE(End)

* Zmìny NEÚÈETNÍ
  TYPE(TabPage) TTYPE(4) CAPTION(Zmìny neúèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(27,59)  PRE( tabSelect)

    TYPE(DBrowse) FILE(ZMAJN) INDEXORD(1);
                  FIELDS(dDatZmeny       ,;
                         cPopisZme::15   ,;
                         cNazPolZme::20  ,;
                         cOldHodn::30    ,;
                         cNewHodn::30    );
                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* Popis majetku
  TYPE(TabPage) TTYPE(4) CAPTION(Popis majetku) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(41,46)  PRE( tabSelect)
    TYPE(MLE) NAME('MAJ->mPopis') FPOS( 1, 0.2) SIZE( 108, 9) RESIZE(yx) READONLY(y)
  TYPE(End)

* Archiv daò.stavù
  TYPE(TabPage) TTYPE(4) CAPTION(Archiv daòový) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(54,33) PRE( tabSelect)

    TYPE(DBrowse) FILE(DMAJ) INDEXORD(2);
                  FIELDS(nRokOdpisu   ,;
                         cOdpiSk      ,;
                         nTypDOdpi    ,;
                         nProcDanOd   ,;
                         nDanOdpRok   );
                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* Archiv úèet.stavù
  TYPE(TabPage) TTYPE(4) CAPTION(Archiv úèetní) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(67,20) PRE( tabSelect)

    TYPE(DBrowse) FILE(UMAJ) INDEXORD(2);
                  FIELDS(nRokOdpisu   ,;
                         cOdpiSk      ,;
                         nTypUOdpi    ,;
                         nProcUctOd   ,;
                         nUctOdpRok   );
                  SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* pozemky
  TYPE(TabPage) TTYPE(4) CAPTION(Pozemky) FPOS(0,14.1) SIZE(110,10.7) RESIZE(yx) OFFSET(86, 1) PRE( tabSelect)
    TYPE(DBrowse) FILE(POZEMKY) INDEXORD(2)           ;
                  FIELDS(cku_Kod:KU:7               , ;
                         nlistVlast:LV:10           , ;
                         cparcCis:èísloParc:15      , ; 
                         cparcCisP:èísloParc_pùv:15 , ;
                         cpodil:podíl:7             , ;
                         nVymera_m2:výmìra_m2:10    , ;
                         npodVym_m2:podVým_m2:10    , ;
                         ndruhPozem:druhPoz:10      , ;
                         ncenaPoz:cena:11           , ;
                         ndanNabPoz:daò:11          , ;
                         ncenaSDaNa:cenaS_daní:11   , ;
                         cBPEJ:bonita:6             , ;
                         mpoznamka:pùvVlast:15        ) ;
                   SIZE(110,9.7) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)                       
  TYPE(End)