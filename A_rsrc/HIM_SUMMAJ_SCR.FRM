TYPE(drgForm) DTYPE(10) TITLE(Stavy za období) SIZE(100,25);
               GUILOOK(Message:Y,Action:y,IconBar:y:drgStdBrowseIconBar);
               OBDOBI(HIM)

TYPE(Action) CAPTION(info ~Majetku)   EVENT(HIM_MAJ_INFO)  TIPTEXT(Informaèní karta HIM )
TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(vypocetKUMUL)  TIPTEXT(Pøepoèet stavù celého majetkového souboru)

  TYPE(DBrowse) FPOS( 0,0.2) SIZE(80,17.8) FILE(MAJ) INDEXORD(1) ;
               FIELDS( NTYPMAJ:Typ ,;
                       NINVCIS     ,;
                       CNAZEV      ,;
                       CODPISK     ,;
                       nTypDOdpi   ,;
                       nTypUOdpi   ,;
                       nRokyOdpiU  ,;
                       nCenaVstU  ,;
                       nOprUCT    ,;
                       nCenaVstD  ,;
                       nOprDAN    );
               CURSORMODE(3) RESIZE(x) PP(7) SCROLL(ny) RESIZE(xy);
               ITEMMARKED(ItemMarked) POPUPMENU(y)

  TYPE(DBrowse) FPOS( 80.5, 0.2 ) SIZE( 20,17.8) FILE(SUMMAJw) INDEXORD(2) ;
                FIELDS( nROK:Úè. rok  ,;
                        nObdobi:Úè. období) ;
                CURSORMODE(3) RESIZE(x) PP(7) SCROLL(ny) RESIZE(xy)

  TYPE(Static) STYPE(13) SIZE(99, 6.7) FPOS(0.5,18.1) RESIZE(y)
   TYPE(Text) CAPTION(VSTUPNÍ CENA úèetní   )    CPOS(  2,1.5)   CLEN( 20)
   TYPE(Text) CAPTION(OPRÁVKY úèetní        )    CPOS(  2,2.5)   CLEN( 20)
   TYPE(Text) CAPTION(ZÙSTATKOVÁ CENA úèetní)    CPOS(  2,3.5)   CLEN( 20)
   TYPE(Text) CAPTION(Mìsíèní ODPIS)             CPOS(  2,5.2)   CLEN( 20)
   TYPE(Text) CAPTION(Na poèátku období)         CPOS( 24,0.5)   CLEN( 15)
   TYPE(Text) CAPTION(Zmìna ceny +  )            CPOS( 44,0.5)   CLEN( 12)
   TYPE(Text) CAPTION(Zmìna ceny -  )            CPOS( 61,0.5)   CLEN( 12)
   TYPE(Text) CAPTION(Na konci období)           CPOS( 77,0.5)   CLEN( 15)

*  Vstupní cena úèetní
   TYPE(Text) NAME(SUMMAJw->nVsCenUPS)         CPOS( 23,1.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nZmVstCKla)        CPOS( 40,1.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nZmVstCMin)        CPOS( 57,1.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nVsCenUKS)         CPOS( 74,1.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
*  Oprávky úèetní
   TYPE(Text) NAME(SUMMAJw->nOprUctPS)         CPOS( 23,2.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nZmOprKla)         CPOS( 40,2.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nZmOprMin)         CPOS( 57,2.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nOprUctKS)         CPOS( 74,2.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
*  Zùstatková cena úèetní
   TYPE(Text) NAME(SUMMAJw->nZuCenUPS)         CPOS( 23,3.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
*   TYPE(Text) NAME(SUMMAJw->nZmZcMin)         CPOS( 57,3.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(SUMMAJw->nZuCenUKS)         CPOS( 74,3.5)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)

   TYPE(Static) STYPE(16) SIZE(96, 0.3) FPOS(1,4.7) RESIZE(y)
   TYPE(Text) NAME(SUMMAJw->nUctOdpMes)        CPOS( 23, 5.2)   CLEN( 15) BGND(13) PP(2) CTYPE(2) FONT(7) GROUPS(clrINFO)

  TYPE(End)