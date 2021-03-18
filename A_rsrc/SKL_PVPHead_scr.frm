TYPE(drgForm) DTYPE(10) TITLE(Pohybové doklady - dle dokladù - wx);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              CARGO(SKL_pvphead_IN) OBDOBI(SKL)   ;
              PRINTFILES(pvphead:ndoklad=ndoklad, ;
                         pvpitem:ndoklad=ndoklad, ;
                         ucetpol:cdenik=cdenik+ndoklad=ncisfak)

TYPE(Action) CAPTION(~Párov. VS-pøíj.) EVENT(PARUJ_VS_PRIJEM) TIPTEXT(Párování pøíjemek dle V-symbolu)
TYPE(Action) CAPTION(~Párov. VS-výdej) EVENT(PARUJ_VS_VYDEJ)  TIPTEXT(Párování výdejek dle V-symbolu)


TYPE(Static) STYPE(13) SIZE( 110.6,13.3) FPOS( 0, 0)  RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE( 109.8,1.2) FPOS( 0.1, 0)  RESIZE(yn)
    TYPE(Text)     CAPTION(Seznam dokladù) CPOS( 45, 0.1) CLEN( 20) FONT(5)
*    TYPE(Text)     CAPTION(Seznam dokladù) CPOS( 0.1, 0 ) CLEN( 109.8) FONT(5) CTYPE(3) GROUPS(clrGREY)
  TYPE(End)

* Seznam Dokladù
  TYPE(DBrowse) FILE(PVPHEAD) INDEXORD(15);
                FIELDS( M->pvphead_mainTask::3.3::2     , ;   
                        isucUzav('pvpHead'):U:3::2      , ;
                        IsUctovano( 1; 'PVPHEAD'):L:3::2, ;
                        M->pvphead_existVn:Vn:3.3::2    , ;
                        NDOKLAD    ,;
                        COBDPOH    ,;
                        CCISSKLAD  ,;
                        CTYPPOHYBU:Pohyb ,;
                        C_TypPOH->cNazTypPoh:Název pohybu:25,;
                        nKarta:typPoh ,;
                        nCenaDokl  ,;
                        nCenaPol   ,;
                        dDatPVP    ,;
                        NCISFIRMY  ,;
                        CNAZFIRMY  ,;
                        CCISLOBINT ,;
                        NCISLODL   ,;
                        NCISFAK    ,;
                        CVARSYM    );
                FPOS( 0, 1.2) SIZE(110,12.2) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(y);
                ITEMMARKED( HEADMarked) ATSTART(LAST)

* COLORED(-29,-34)


TYPE(End)

* Položky dokladu
TYPE(TabPage) CAPTION(Položky dokladu) FPOS(0.3, 13.4) SIZE(109.4,11.4) RESIZE(yx) OFFSET(1,82) SUBTABS(A1, A2, A3)

  TYPE(TabPage) CAPTION(Seznam položek) TTYPE(3) FPOS(0.5,1.2) SIZE(108.6, 10) Resize(yx) OFFSET(2,81) TABHEIGHT( 1) SUB(A1) PRE(TABSELECT)
    TYPE(DBrowse) FILE(PVPITEM) INDEXORD(2);
                  FIELDS( M->pvpitem_isOk::2.6::2        , ;
                          M->is_evidvyrCis:vè:2.6::2     , ;
                          IsUctovano( 1; 'PVPITEM'):L:3::2,;
                          cSklPol      ,;
                          cNazZbo::30  ,;
                          nDoklad      ,;
                          nOrdItem     ,;
                          nMnozPrDOD   ,;
                          nCenNapDod   ,;
                          nCenaCelk    ,;
                          cZkratMeny   ,;
                          nCenCelkZM   ,;
                          cZahrMena    ,;
                          cUcetSkup    ,;
                          cCisZakaz    ,;
                          cCisZakazI   ,;
                          nKLikvid     ,;
                          nZlikvid     ,;
                          M->pvpitem_datPoh:datumPohybu:20, ;
                          M->pvpitem_lastVyd:posledníVýdej:30 );
                  SIZE(107.6, 9) FPOS(0.4 ,0) CURSORMODE(3) RESIZE(yx) SCROLL(yy) ITEMMARKED( ITEMmarked)
  TYPE(End)

  TYPE(TabPage) CAPTION(Detail položky) TTYPE(3) FPOS(0.5,1.2) SIZE(108.6, 10) RESIZE(yx) OFFSET(18,66) TABHEIGHT( 1) SUB(A2) PRE(TABSELECT)

    TYPE(Static) STYPE(12) SIZE(108.2, 8.9) FPOS(0.2,0.0) RESIZE(yy) CTYPE(2)
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*     1.øádek
      TYPE(Text) CAPTION(Poø.)              CPOS(  3, 0.2)   CLEN(  5)
      TYPE(Text) NAME(PVPITEM->nOrdItem)    CPOS(  3, 1.2)   CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Sklad)             CPOS( 10, 0.2)   CLEN(  8)
      TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS( 10, 1.2)   CLEN( 10) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Sklad. položka)    CPOS( 22, 0.2)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 22, 1.2)   CLEN( 20) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(Název zboží)       CPOS( 44, 0.2)   CLEN( 30)
      TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 44, 1.2)   CLEN( 55) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
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
      TYPE(Text) NAME(C_DPH->nProcDph)       CPOS( 65, 3.5)   CLEN(  6) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(PC s Dph)           CPOS( 73, 2.5)   CLEN( 12)
      TYPE(Text) NAME(PVPITEM->nCenaPDZBO)   CPOS( 73, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
*     3.øádek
      TYPE(Text) CAPTION(Faktura)           CPOS(  3, 4.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->nCisFak)     CPOS(  3, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Dodací list)       CPOS( 15, 4.5)   CLEN( 10)
      TYPE(Text) NAME(PVPITEM->nCisloDL)    CPOS( 15, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Obj_vystavená)     CPOS( 27, 4.5)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cCisObj)     CPOS( 27, 5.5)   CLEN( 18) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) NAME(pvpitem->nintCount)   CPOS( 45, 5.5)   CLEN(  4) BGND( 13)       GROUPS(clrGREY) PICTURE(9999)

      TYPE(Text) CAPTION(Obj_pøijatá)       CPOS( 51, 4.5)   CLEN( 15)
      TYPE(Text) NAME(PVPITEM->cCislObInt)  CPOS( 51, 5.5)   CLEN( 30) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) NAME(pvpitem->ncislPolOb)  CPOS( 81, 5.5)   CLEN(  4) BGND( 13)       GROUPS(clrGREY) PICTURE(9999)

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

    TYPE(End)
  TYPE(End)

  TYPE(TabPage) CAPTION(Likvidace položky) TTYPE(3) FPOS(0.5, 1.2) SIZE( 108.6,10) OFFSET(34,50) RESIZE(yx) TABHEIGHT( 1) SUB(A3) PRE(TABSELECT)
*     1.øádek
    TYPE(Text) CAPTION(poøPol)            CPOS(  1, 0.2)   CLEN(  6)
    TYPE(Text) NAME(PVPITEM->nOrdItem)    CPOS(  1, 1.2)   CLEN(  7) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad)             CPOS( 10, 0.2)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS( 10, 1.2)   CLEN( 10) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Sklad. položka)    CPOS( 22, 0.2)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 22, 1.2)   CLEN( 20) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Název zboží)       CPOS( 44, 0.2)   CLEN( 30)
    TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 44, 1.2)   CLEN( 55) BGND( 13) PP(2) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Úè.sk.)            CPOS(101, 0.2)   CLEN(  6)
    TYPE(Text) NAME(PVPITEM->nUcetSkup)   CPOS(101, 1.2)   CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)

    TYPE(Static) STYPE(13) SIZE(107.6,9.3) FPOS( .1, .1)  RESIZE(yx)

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
                  SIZE(107.6, 6.3) FPOS(-.2 ,2.6)  RESIZE(yx) CURSORMODE(3) SCROLL(yy) PP(7)
    TYPE(End)
  TYPE(End
TYPE(End)


TYPE(TabPage) CAPTION(Likvidace dokladu) FPOS(0,13.4) SIZE( 110,11.6) OFFSET(18,66) RESIZE(yx) PRE(TABSELECT)
  TYPE(Static) STYPE(13) SIZE(110,10) FPOS( .1, .1)  RESIZE(yx)

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
                  FPOS( -.2, .2 ) RESIZE(yx) CURSORMODE(3) SCROLL(yy) PP(7) 
  TYPE(End)
TYPE(End)


TYPE(TabPage) CAPTION(pøevodPol_kam) FPOS(0,13.4) SIZE( 110,11.6) OFFSET(35,50) RESIZE(yx) PRE(TABSELECT)
  TYPE(Static) STYPE(13) SIZE(110,10) FPOS( .1, .1)  RESIZE(yx)
    TYPE(DBrowse) FILE(PVPITEM_40) INDEXORD(2)             ;
                  FIELDS( M->pvpitem_isOk::2.6::2        , ;
                          M->is_evidvyrCis:vè:2.6::2     , ;
                          IsUctovano( 1; 'PVPITEM_40'):L:3::2,;
                          ccisSklad:sklad, ; 
                          cSklPol      ,;
                          cNazZbo::30  ,;
                          nDoklad      ,;
                          nOrdItem     ,;
                          nMnozPrDOD   ,;
                          nCenNapDod   ,;
                          nCenaCelk    ,;
                          cZkratMeny   ,;
                          nCenCelkZM   ,;
                          cZahrMena    ,;
                          cUcetSkup    ,;
                          cCisZakaz    ,;
                          cCisZakazI   ,;
                          nKLikvid     ,;
                          nZlikvid     ,;
                          M->pvpitem_datPoh:datumPohybu:20, ;
                          M->pvpitem_lastVyd:posledníVýdej:30 );
                  FPOS(-.2 ,.2) CURSORMODE(3) RESIZE(yx) SCROLL(yy) PP(9)
  TYPE(End)
 TYPE(End)