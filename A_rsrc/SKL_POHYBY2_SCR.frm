TYPE(drgForm) DTYPE(10) TITLE(  Pohybové doklady - dle položek) ;
                        SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
                        OBDOBI(SKL)

TYPE(Action) CAPTION(~Tvorba dokladù) EVENT(Vyber_POHYB) TIPTEXT(Poøizování pohybových dokladù )

  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(5);
                FIELDS( cCisSklad  ,;
                        nDoklad    ,;
                        nOrdItem   ,;
                        cSklPol    ,;
                        cNazZbo    ,;
                        nCislPOH   ,;
                        dDatPVP    ,;
                        nMnozPrDOD ,;
                        cUcetSkup  );
                SIZE(100,14) CURSORMODE(3) PP(7) POPUPMENU(yy) Resize(x)

*               ITEMMARKED(ItemMarked) PRE( GetFocusIT2)
*   INFO
*   1.øádek
    TYPE(Text) CAPTION(Sklad)                 CPOS(  3,14.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->cCisSklad)       CPOS(  3,15.5)   CLEN(  8) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Sklad. položka)        CPOS( 13,14.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cSklPol)         CPOS( 13,15.5)   CLEN( 15) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Název zboží)           CPOS( 30,14.5)   CLEN( 30)
    TYPE(Text) NAME(PVPITEM->cNazZbo)         CPOS( 30,15.5)   CLEN( 30) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Úè.skup.)              CPOS( 62,14.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->nUcetSkup)       CPOS( 62,15.5)   CLEN(  5) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Pohyb)                 CPOS( 70,14.5)   CLEN(  8)
    TYPE(Text) NAME(C_DRPOHY->cNazevPoh)      CPOS( 70,15.5)   CLEN( 25) BGND( 13) PP(2)
*   2.øádek
    TYPE(Text) CAPTION(Mn. na dokl.)          CPOS(  3,16.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nMnozPrDod)      CPOS(  3,17.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(MJ)                    CPOS( 16,16.5)   CLEN(  5)
    TYPE(Text) NAME(PVPITEM->cZkratJedn)      CPOS( 16,17.5)   CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Cena na dokl.)         CPOS( 23,16.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenNapDod)      CPOS( 23,17.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Cena CELKEM)           CPOS( 37,16.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaCelk)       CPOS( 37,17.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(PC bez Dph)            CPOS( 51,16.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPZBO)       CPOS( 51,17.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(% Dph)                 CPOS( 65,16.5)   CLEN(  6)
    TYPE(Text) NAME(C_DPH->nProcDph)          CPOS( 65,17.5)   CLEN(  6) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(PC s Dph)              CPOS( 73,16.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPDZBO)      CPOS( 73,17.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2)
*   3.øádek
    TYPE(Text) CAPTION(Faktura)               CPOS(  3,18.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisFak)         CPOS(  3,19.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Dodací list)           CPOS( 15,18.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisloDL)        CPOS( 15,19.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Obj. vystavená)        CPOS( 27,18.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCisObj)         CPOS( 27,19.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Obj. pøijatá)          CPOS( 44,18.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCislObInt)      CPOS( 44,19.5)   CLEN( 15) BGND( 13) PP(2)

*   Nákladová struktura
    TYPE(Text) CAPTION( Stredisko)             CPOS(  3, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol1)         CPOS(  3, 22.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výkon)                 CPOS( 19, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol2)         CPOS( 19, 22.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Zakázka)               CPOS( 35, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol3)         CPOS( 35, 22.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. místo)            CPOS( 51, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol4)         CPOS( 51, 22.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Stroj)                 CPOS( 67, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol5)         CPOS( 67, 22.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. operace)          CPOS( 83, 21.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol6)         CPOS( 83, 22.5)   CLEN( 15) BGND( 13) PP(2)
