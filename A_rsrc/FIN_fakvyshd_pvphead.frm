TYPE(drgForm) DTYPE(10) TITLE(Pohybové doklady - dle dokladù);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              OBDOBI(SKL)  ; 
              PRINTFILES(pvphead:ndoklad=ndoklad, ;
                         pvpitem:ndoklad=ndoklad, ;  
                         ucetpol:cdenik=cdenik+ndoklad=ncisfak) ISREADONLY(Y)


* Seznam Dokladù
  TYPE(DBrowse) FILE(PVPHEAD)                          ;
                FIELDS(M->likvidaceHD:L:2.6::2       , ;
                       NDOKLAD                       , ;
                       COBDPOH                       , ;
                       CCISSKLAD                     , ;
                       NCISLPOH                      , ; 
                       C_DRPOHY->cNazevPoh           , ;
                       nCenaDokl                     , ;
                       dDatPVP                       , ;
                       NCISFIRMY                     , ; 
                       CCISLOBINT                    , ;
                       NCISLODL                      , ;
                       nKLikvid                      , ;
                       nZlikvid                        ) ;
                SIZE(100,14) RESIZE(yn) CURSORMODE(3) PP(7) INDEXORD(1) ITEMMARKED( ItemMarked) POPUPMENU(y)

* Seznam položek
TYPE(TabPage) CAPTION(Seznam položek) FPOS(0, 14.2) SIZE(100,10.5) Resize(yx) OFFSET(1,82)

  TYPE(DBrowse) FILE(PVPITEM)                    ;
                FIELDS(M->likvidaceIT:L:2.6::2 , ;
                       cSklPol                 , ;
                       cNazZbo::30             , ;
                       nDoklad                 , ;
                       nOrdItem                , ;
                       nMnozPrDOD              , ;
                       nCenNapDod              , ;
                       nCenaCelk               , ;
                       cUcetSkup               , ;
                       nKLikvid                , ;
                       nZlikvid                  ) ;
                INDEXORD(2) SIZE(100, 9) CURSORMODE(3) PP(7) Resize(yx)  POPUPMENU(yn)
TYPE(End)

* Detail položky
TYPE(TabPage) CAPTION(Detail položky) FPOS(0,14.2) SIZE( 100,10.4) OFFSET(18,66) Resize(yx) 
  TYPE(Static) STYPE(13) SIZE( 99, 9.3) FPOS( 0.5,0.2) RESIZE(yn)
*   INFO
*   1.øádek
    TYPE(Text) CAPTION(Sklad)             CPOS(  3, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS(  3, 1.5)   CLEN(  8) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Sklad. položka)    CPOS( 13, 0.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 13, 1.5)   CLEN( 15) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Název zboží)       CPOS( 30, 0.5)   CLEN( 30)
    TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 30, 1.5)   CLEN( 30) BGND( 13) PP(2) FONT(5)
    TYPE(Text) CAPTION(Úè.skup.)          CPOS( 62, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->nUcetSkup)   CPOS( 62, 1.5)   CLEN(  5) BGND( 13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 70, 0.5)   CLEN(  8)
    TYPE(Text) NAME(C_DRPOHY->cNazevPoh)  CPOS( 70, 1.5)   CLEN( 25) BGND( 13) PP(2)
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
    TYPE(Static) STYPE(17) CTYPE(5) SIZE( 98, 6 )
*    TYPE(Static) STYPE( 7) CTYPE(1) FPOS( 1, 21) SIZE( 98,0.2 )
*    TYPE(Text) CAPTION( Nákladová struktura :) CPOS(  3, 7)   CLEN( 22) FONT(7)
    TYPE(Text) CAPTION( Stredisko)             CPOS( 25, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol1)         CPOS( 25, 8)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výkon)                 CPOS( 37, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol2)         CPOS( 37, 8)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Zakázka)               CPOS( 49, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol3)         CPOS( 49, 8)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. místo)            CPOS( 61, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol4)         CPOS( 61, 8)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Stroj)                 CPOS( 73, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol5)         CPOS( 73, 8)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION( Výr. operace)          CPOS( 85, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol6)         CPOS( 85, 8)   CLEN( 10) BGND( 13) PP(2)

  TYPE(End)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

* likvidace
  TYPE(TABPAGE) FPOS(0,14.2) SIZE( 100,10.4) OFFSET(34,49) CAPTION(Likvidace dokladu) 
*    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,.1) SIZE(99.6,9.6) FILE(UCETPOL)          ;  
                                            FIELDS(NDOKLAD:doklad, ;
                                            COBDOBI:OBD_úè       , ;
                                            CTEXT:Text dokladu:40, ;
                                            CUCETMD:SuAu_Ø       , ;
                                            NKCMD                , ;
                                            NKCDAL               , ;
                                            CUCETDAL:SuAu_S        ) ;
                                            CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)
  TYPE(End)
