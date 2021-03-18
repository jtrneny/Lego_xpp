TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhu pohybù zvíøat) SIZE(95,15) FILE(C_DRPOHZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(95,14) FILE(C_DRPOHZ) FIELDS( NDRPOHYB  ,;
                                  cNazevPOH  ,;
                                  NKARTA     ,;
                                  lProdukce  ,;
                                  nTypPohyb  ,;
                                  nDrPohPL1  ,;
                                  nDrPohPL2  ,;
                                  nDrPohPLPr ,;
                                  nPodm      );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(nDrPohyb)    FPOS(20, 1) FLEN( 5) FCAPTION(Druh pohybu)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazevPoh)   FPOS(20, 2) FLEN(30) FCAPTION(Název pohybu)       CPOS(1,2)
  TYPE(GET)      NAME(nKarta)      FPOS(20, 3) FLEN( 7) FCAPTION(Typ editaèní karty) CPOS(1,3)
  TYPE(COMBOBOX) NAME(lProdukce)   FPOS(20, 4) FLEN( 8) FCAPTION(Produkce)           CPOS(1,4)
  TYPE(GET)      NAME(nTypPohyb)   FPOS(20, 5) FLEN( 2) FCAPTION(Typ pohybu)         CPOS(1,5)
  TYPE(GET)      NAME(nDrPohPL1)   FPOS(20, 6) FLEN( 2) FCAPTION(Pohyb plemen. 1)    CPOS(1,6)
  TYPE(GET)      NAME(nDrPohPL2)   FPOS(20, 7) FLEN( 2) FCAPTION(Pohyb plemen. 2)    CPOS(1,7)
  TYPE(GET)      NAME(nDrPohPLPr)  FPOS(20, 8) FLEN( 2) FCAPTION(Pohyb plem.pras.)   CPOS(1,8)
  TYPE(GET)      NAME(nPodm)       FPOS(20, 9) FLEN( 1) FCAPTION(Podmínka)           CPOS(1,9) POST( postLastField_2)
TYPE(End)

