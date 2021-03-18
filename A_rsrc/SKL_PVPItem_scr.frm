TYPE(drgForm) DTYPE(10) TITLE(  Pohybové doklady - dle položek) ;
                        SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
                        CARGO( SKL_POHYBYHD) OBDOBI(SKL)


TYPE(Static) STYPE(13) SIZE( 110,14.3) FPOS( 0, 0)  RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE( 109.8,1.2) FPOS( 0.1, 0)  RESIZE(yn)
    TYPE(Text)     CAPTION(Seznam položek dokladù) CPOS( 45, 0.1) CLEN( 25) FONT(5)
*    TYPE(Text)     CAPTION(Seznam položek dokladù) CPOS( 0, 0 ) CLEN( 109.8) FONT(5) CTYPE(3) GROUPS(clrGREEN)
  TYPE(End)

* Seznam položek dokladù
  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(5);
                FIELDS( M->pvpitem_isOk::2.6::2        , ;
                        IsUctovano( 1; 'PVPITEM'):L:3::2,;
                        nDoklad      ,;
                        nOrdItem     ,;
                        cCisSklad    ,;
                        cSklPol      ,;
                        cNazZbo::35  ,;
                        cTypPohybu:Pohyb ,;
                        dDatPVP      ,;
                        nMnozPrDOD   ,;
                        nCenNapDod   ,;
                        nCenaCelk    ,;
                        cUcetSkup    ,;
                        cCisZakaz    ,;
                        cCisZakazI   ,;
                        nKLikvid     ,;
                        nZlikvid     );
                FPOS( 0, 1.2) SIZE(110,13.2) CURSORMODE(3) PP(7) POPUPMENU(y) Resize(yx);
                ITEMMARKED( ItemMarked) ATSTART(LAST)

TYPE(End)

TYPE(Static) STYPE(13) SIZE(110,11.5) FPOS(0,14.4) RESIZE(yy)

* Položka dokladu
  TYPE(TabPage) CAPTION(Detail položky) FPOS(0.3, 0.1) SIZE(109.4,10.4) RESIZE(yx) OFFSET(1,82) PRE(TABSELECT)
*     1.øádek
      TYPE(Text) CAPTION(Poø.)              CPOS(  3, 0.2)   CLEN(  5)
      TYPE(Text) NAME(PVPITEM->nOrdItem)    CPOS(  3, 1.2)   CLEN(  8) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Sklad)             CPOS( 13, 0.2)   CLEN(  8)
      TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS( 13, 1.2)   CLEN( 12) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Sklad. položka)    CPOS( 27, 0.2)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 27, 1.2)   CLEN( 20) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Název zboží)       CPOS( 49, 0.2)   CLEN( 30)
      TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 49, 1.2)   CLEN( 50) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Úè.sk.)            CPOS(101, 0.2)   CLEN(  6)
      TYPE(Text) NAME(PVPITEM->nUcetSkup)   CPOS(101, 1.2)   CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrYELLOW)
*     2.øádek
      TYPE(Text) CAPTION(Mn. na dokl.)       CPOS(  3, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nMnozPrDod)   CPOS(  3, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(MJ)                 CPOS( 16, 2.5)   CLEN(  5)
      TYPE(Text) NAME(PVPITEM->cZkratJedn)   CPOS( 16, 3.5)   CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Cena na dokl.)      CPOS( 23, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nCenNapDod)   CPOS( 23, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Cena CELKEM)        CPOS( 37, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nCenaCelk)    CPOS( 37, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(PC bez Dph)         CPOS( 51, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nCenaPZBO)    CPOS( 51, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(% Dph)              CPOS( 65, 2.5)   CLEN(  6)
      TYPE(Text) NAME(C_DPH->nProcDph)       CPOS( 65, 3.5)   CLEN(  9) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(PC s Dph)           CPOS( 76, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nCenaPDZBO)   CPOS( 76, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
*     3.øádek
      TYPE(Text) CAPTION(Faktura)           CPOS(  3, 4.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->nCisFak)     CPOS(  3, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Dodací list)       CPOS( 15, 4.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->nCisloDL)    CPOS( 15, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Obj. vystavená)    CPOS( 27, 4.5)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cCisObj)     CPOS( 27, 5.5)   CLEN( 20) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Obj. pøijatá)      CPOS( 49, 4.5)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cCislObInt)  CPOS( 49, 5.5)   CLEN( 20) BGND( 13) PP(2) GROUPS(clrGREY)

*      Nákladová struktura
      TYPE(Text) CAPTION( Stredisko)             CPOS(  3, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol1)         CPOS(  3, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Výkon)                 CPOS( 20, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol2)         CPOS( 20, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Zakázka)               CPOS( 37, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol3)         CPOS( 37, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Výr. místo)            CPOS( 54, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol4)         CPOS( 54, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Stroj)                 CPOS( 71, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol5)         CPOS( 71, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Výr. operace)          CPOS( 88, 6.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazPol6)         CPOS( 88, 7.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) CAPTION(Likvidace položky) FPOS(0.3,0.1) SIZE(109.4,10.4) RESIZE(yx) OFFSET(18,65) PRE(TABSELECT)
    TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                  FIELDS( cUcetMD,;
                          cUcetDAL,;
                          nKcMD,;
                          nKcDAL,;
                          cText,;
                          nDoklad,;
                          cObdobi,;
                          cDenik,;
                          cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) ;
                  SIZE(107.6, 9) FPOS(0.4 ,0)  RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y)
  TYPE(End)

* Hlavièka dokladu
  TYPE(TabPage) CAPTION(Hlavièka dokladu) FPOS(0.3, 0.1) SIZE(109.4,10.4) RESIZE(yx) OFFSET(35,48) PRE(TABSELECT)

*     1.øádek
      TYPE(Text) CAPTION(Doklad)            CPOS(  3, 0.2)   CLEN(  6)
      TYPE(Text) NAME(PVPHEAD->nDoklad)     CPOS(  3, 1.2)   CLEN( 12) BGND( 13) FONT(5) CTYPE(2) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Typ dokladu)       CPOS( 17, 0.2)   CLEN( 10)
      TYPE(Text) NAME(PVPHEAD->cTypDoklad)  CPOS( 17, 1.2)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Dat.pohybu)        CPOS( 31, 0.2)   CLEN( 10)
      TYPE(Text) NAME(PVPHEAD->dDatPVP)     CPOS( 31, 1.2)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Období)            CPOS( 45, 0.2)   CLEN(  6)
      TYPE(Text) NAME(PVPHEAD->cObdobi)     CPOS( 45, 1.2)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Pohyb)             CPOS( 60, 0.2)   CLEN( 10)
      TYPE(Text) NAME(PVPHEAD->cTypPohybu)  CPOS( 60, 1.2)   CLEN( 12) BGND( 13) FONT(5) GROUPS(clrGREEN)
      TYPE(Text) NAME(C_TypPoh->cNazTypPoh) CPOS( 73, 1.2)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREEN)
*     2.øádek
      TYPE(Text) CAPTION(È.firmy)           CPOS(  3, 2.5)   CLEN(  8)
      TYPE(Text) NAME(PVPHEAD->nCisFirmy)   CPOS(  3, 3.5)   CLEN(  8) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Název firmy)       CPOS( 13, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->cNazFirmy)   CPOS( 13, 3.5)   CLEN( 40) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Dodací list)       CPOS( 55, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->nCisloDL)    CPOS( 55, 3.5)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Faktura)           CPOS( 69, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->nCisFak)     CPOS( 69, 3.5)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(V-symbol)          CPOS( 83, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->cVarSym)     CPOS( 83, 3.5)   CLEN( 16) BGND( 13) CTYPE(2) GROUPS(clrGREY)
*     3.øádek
      TYPE(Text) CAPTION(Cena na dokl.)     CPOS(  3, 4.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->nCenaDokl)   CPOS(  3, 5.5)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Nutné VN)          CPOS( 17, 4.5)   CLEN( 10)
      TYPE(Text) NAME(PVPHEAD->nNutneVN)    CPOS( 17, 5.5)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Rozdíl pøi pøíj.)  CPOS( 31, 4.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->nRozPrij)    CPOS( 31, 5.5)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Èís.objednávky)    CPOS( 45, 4.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->cCislObInt)  CPOS( 45, 5.5)   CLEN( 30) BGND( 13) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Èís.zakázky)       CPOS( 77, 4.5)   CLEN( 12)
      TYPE(Text) NAME(PVPHEAD->cCisZakaz)   CPOS( 77, 5.5)   CLEN( 30) BGND( 13) CTYPE(2) GROUPS(clrGREY)

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) CAPTION(Likvidace dokladu) FPOS(0.3,0.1) SIZE(109.4,10.4) RESIZE(yx) OFFSET(52,31) PRE(TABSELECT)
    TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                  FIELDS( cUcetMD,;
                          cUcetDAL,;
                          nKcMD,;
                          nKcDAL,;
                          cText,;
                          nDoklad,;
                          cObdobi,;
                          cDenik,;
                          cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) ;
                  SIZE(107.6, 9) FPOS(0.4 ,0)  RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y)
  TYPE(End)