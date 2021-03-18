TYPE(drgForm) DTYPE(10) TITLE(Katalog typov�ch operac�) FILE(OPERACE);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_Operace_crd)

*TYPE(Action) CAPTION(~Vstup operac�) EVENT(Edit_Operace) TIPTEXT(Po�izov�n� typov�ch operac� )

* OPERACE ... katalog typov�ch operac�
  TYPE(DBrowse) FILE(OPERACE) INDEXORD(1);
               FIELDS( cOznOper  ,;
                       cTypOper  ,;
                       cNazOper  ,;
                       cNazPol6  ,;
                       cStred    ,;
                       cOznPrac  ,;
                       cPracZar  ,;
                       nDruhMzdy) ;
               SIZE(100,14) CURSORMODE(3) PP(7) Resize(ny) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)

*TYPE(Static) STYPE(13) SIZE(100, 10.5) FPOS(0, 14.2) RESIZE(ny)

* Z�kladn� �daje
  TYPE(TabPage) CAPTION( Z�kladn� �daje) FPOS(0, 14.2) SIZE(100,10.5) OFFSET(1,82) RESIZE(yx) PRE(tabSelect)
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
      TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
*       1.SL
        TYPE(Text)  CAPTION(Typ operace)       CPOS( 1, 0.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTypOper)             CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TypOp->cPopisOper)  CPOS(31, 0.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(V�r. st�edisko)    CPOS( 1, 1.5) CLEN( 12)
        TYPE(TEXT)  NAME(cStred)               CPOS(15, 1.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_Stred->cNazStr)     CPOS(31, 1.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Pracovi�t�)        CPOS( 1, 2.5) CLEN( 12)
        TYPE(TEXT)  NAME(cOznPrac)             CPOS(15, 2.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_Pracov->cNazevPrac) CPOS(31, 2.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Pracovn� za�azen�) CPOS( 1, 3.5) CLEN( 13)
        TYPE(TEXT)  NAME(cPracZar)             CPOS(15, 3.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_PracZa->cNazPracZa) CPOS(31, 3.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Druh mzdy)         CPOS( 1, 4.5) CLEN( 12)
        TYPE(TEXT)  NAME(nDruhMzdy)            CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  NAME(DruhyMzd->cNazevDmz)  CPOS(31, 4.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Tarifn� stupnice)  CPOS( 1, 5.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTarifStup)           CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TarStu->cNazTarStu) CPOS(31, 5.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Tarifn� t��da)     CPOS( 1, 6.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTarifTrid)           CPOS(15, 6.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TarTri->cNazTarTri) CPOS(31, 6.5) CLEN( 30) BGND(13)
*       2.SL
        TYPE(Text)  CAPTION(Kusov� �as)           CPOS(63, 0.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKusovCas)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(P��pravn� �as)        CPOS(63, 1.5) CLEN( 18)
        TYPE(TEXT)  NAME(nPriprCas)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Vykazovat mzd.l�stky) CPOS(63, 2.5) CLEN( 18)
*        TYPE(TEXT)  NAME(lVykazML)               CPOS(82, 2.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  CAPTION(Koef. sm�nov�ho �asu) CPOS(63, 3.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKoefSmCas)              CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Koef.v�cestroj. obsluhy) CPOS(63, 4.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKoefViSt)                  CPOS(82, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Koef.v�ceobsl. stroje)   CPOS(63, 5.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKoefViOb)                  CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(End)

  TYPE(End)

* Popis Operace
  TYPE(TabPage) CAPTION( Popis operace) FPOS(0, 14.2) SIZE(100,10.5) OFFSET(18,66) RESIZE(yx) PRE(tabSelect)

    TYPE(MLE) NAME('Operace->mTextOper') FPOS( 1, 0.2) SIZE( 98, 9) RESIZE(yx) READONLY(y)

  TYPE(End)

* Atributy operace
  TYPE(TabPage) CAPTION( Atributy operace) FPOS(0, 14.2) SIZE(100,10.5) OFFSET(34,50) RESIZE(yx) PRE(tabSelect)

    TYPE(DBrowse) FILE(HodAtrib) INDEXORD(1);
                 FIELDS( cOznOper  ,;
                         cAtribOper  ,;
                         cHodnAtrC   ,;
                         nHodnAtrN   );
                 SIZE(100, 9.6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* Pracovn� postupy k operac�m
  TYPE(TabPage) CAPTION( Pracovn� postupy) FPOS(0, 14.2) SIZE(100,10.5) OFFSET(50,34) RESIZE(yx) PRE(tabSelect)

    TYPE(DBrowse) FILE(PPOper) INDEXORD(1);
                 FIELDS( cOznOper   ,;
                         cOznPrPo    ,;
                         PracPost->cTypPrPo    ,;
                         PracPost->cNazPrPo    ,;
                         PracPost->cStred      ,;
                         PracPost->cOznPrac    ,;
                         PracPost->cStavPrPo  ) ;
                 SIZE(100, 9.6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* Operace u polo�ek
  TYPE(TabPage) CAPTION( Operace u polo�ek) FPOS(0, 14.2) SIZE(100,10.5) OFFSET(66,18) RESIZE(yx) PRE(tabSelect)

    TYPE(DBrowse) FILE(PolOper) INDEXORD(2);
                 FIELDS( cCisZakaz          ,;
                         cVyrPol            ,;
                         NazVyrPol():N�zev polo�ky:30 ,;
                         VyrPol->cTypPol:Typ.pol.     ,;
                         nCisOper           ,;
                         nUkonOper          ,;
                         nVarOper           ,;
                         nKoefKusCa         ,;
                         nCelkKusCa         ) ;
                 SIZE(100, 9.6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

TYPE(End)