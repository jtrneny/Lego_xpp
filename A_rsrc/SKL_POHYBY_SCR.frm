TYPE(drgForm) DTYPE(10) TITLE(Pohybové doklady - dle dokladù);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              CARGO( SKL_POHYBY_CRD) OBDOBI(SKL)  ;
              PRINTFILES(pvphead:ndoklad=ndoklad, ;
                         pvpitem:ndoklad=ndoklad, ;
                         ucetpol:cdenik=cdenik+ndoklad=ncisfak)

TYPE(Action) CAPTION(~Tvorba dokladù) EVENT(VYBER_POHYB) TIPTEXT(Poøizování pohybových dokladù )

* Seznam Dokladù
  TYPE(DBrowse) FILE(PVPHEAD) INDEXORD(1);
                FIELDS( NDOKLAD    ,;
                        COBDPOH    ,;
                        CCISSKLAD  ,;
                        NCISLPOH   ,;
                        C_DRPOHY->cNazevPoh,;
                        nCenaDokl  ,;
                        dDatPVP    ,;
                        NCISFIRMY  ,;
                        CNAZFIRMY  ,;
                        CCISLOBINT ,;
                        NCISLODL   );
                FPOS( 0, 1.4) SIZE(110,13) CURSORMODE(3) PP(7) POPUPMENU(y);
                ITEMMARKED( ItemMarked)
*                COLORED(-29,-34);

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Seznam dokladù) CPOS( 45, 0.1) CLEN( 20) FONT(5)
  TYPE(End)

* Seznam položek
TYPE(TabPage) CAPTION(Seznam položek) FPOS(0, 14.2) SIZE(110,10.8) Resize(yx) OFFSET(1,82)

  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(2);
                FIELDS( cSklPol      ,;
                        cNazZbo::30  ,;
                        nDoklad      ,;
                        nOrdItem     ,;
                        nMnozPrDOD   ,;
                        nCenNapDod   ,;
                        nCenaCelk    ,;
                        cUcetSkup    ,;
                        cCisZakaz    ,;
                        cCisZakazI   ,;
                        nKLikvid     ,;
                        nZlikvid     );
                SIZE(110, 9.7) CURSORMODE(3) PP(7) Resize(yx) SCROLL(yy)
TYPE(End)

* Detail položky
TYPE(TabPage) CAPTION(Detail položky) FPOS(0,14.2) SIZE( 110,10.8) OFFSET(18,66) Resize(yx)
*  TYPE(Static) STYPE(13) SIZE( 109, 9.3) FPOS( 0.5,0.2) RESIZE(yx)
*   INFO
*   1.øádek
    TYPE(Text) CAPTION(Sklad)             CPOS(  3, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS(  3, 1.5)   CLEN( 10) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad. položka)    CPOS( 15, 0.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 15, 1.5)   CLEN( 20) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název zboží)       CPOS( 37, 0.5)   CLEN( 30)
    TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 37, 1.5)   CLEN( 30) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Úè.skup.)          CPOS( 69, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->nUcetSkup)   CPOS( 69, 1.5)   CLEN(  5) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 77, 0.5)   CLEN(  8)
    TYPE(Text) NAME(C_DRPOHY->cNazevPoh)  CPOS( 77, 1.5)   CLEN( 25) BGND( 13) PP(2) GROUPS(clrGREY)
*   2.øádek
    TYPE(Text) CAPTION(Mn. na dokl.)       CPOS(  3, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nMnozPrDod)   CPOS(  3, 3.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(MJ)                 CPOS( 16, 2.5)   CLEN(  5)
    TYPE(Text) NAME(PVPITEM->cZkratJedn)   CPOS( 16, 3.5)   CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Cena na dokl.)      CPOS( 23, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenNapDod)   CPOS( 23, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Cena CELKEM)        CPOS( 37, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaCelk)    CPOS( 37, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(PC bez Dph)         CPOS( 51, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPZBO)    CPOS( 51, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(% Dph)              CPOS( 65, 2.5)   CLEN(  6)
    TYPE(Text) NAME(C_DPH->nProcDph)       CPOS( 65, 3.5)   CLEN(  6) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(PC s Dph)           CPOS( 73, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPDZBO)   CPOS( 73, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
*   3.øádek
    TYPE(Text) CAPTION(Faktura)           CPOS(  3, 4.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisFak)     CPOS(  3, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Dodací list)       CPOS( 15, 4.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisloDL)    CPOS( 15, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Obj. vystavená)    CPOS( 27, 4.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCisObj)     CPOS( 27, 5.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Obj. pøijatá)      CPOS( 44, 4.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCislObInt)  CPOS( 44, 5.5)   CLEN( 15) BGND( 13) PP(2)

*   Nákladová struktura
*    TYPE(Static) STYPE(17) CTYPE(5) SIZE( 108, 6 )
    TYPE(Text) CAPTION( Stredisko)             CPOS(  3, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol1)         CPOS(  3, 8)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výkon)                 CPOS( 20, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol2)         CPOS( 20, 8)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Zakázka)               CPOS( 37, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol3)         CPOS( 37, 8)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. místo)            CPOS( 54, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol4)         CPOS( 54, 8)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Stroj)                 CPOS( 71, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol5)         CPOS( 71, 8)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. operace)          CPOS( 88, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol6)         CPOS( 88, 8)   CLEN( 15) BGND( 13) PP(2)

*  TYPE(End)
TYPE(End)