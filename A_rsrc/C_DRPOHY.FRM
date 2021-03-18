TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhù pohybù) SIZE(60,15) FILE(C_DRPOHY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_DRPOHY) FIELDS(NCISLPOH,CNAZEVPOH,NKARTA,CTYPDOKL);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)  NAME(NCISLPOH)  FPOS(18,1)  FLEN( 7) FCAPTION(Pohyb) CPOS(1,1) PP(2);
               POST( drgPostUniqueKey)
    TYPE(GET)  NAME(CNAZEVPOH) FPOS(18,2) FLEN(32) FCAPTION(Název druhu pohybu) CPOS(1,2)
    TYPE(GET)  NAME(NKARTA)    FPOS(18,3) FLEN( 7) FCAPTION(Karta) CPOS(1,3) PP(2)
    TYPE(Text) NAME(C_TYPKAR->cPopisKar)  CPOS(26,3) CLEN(25) BGND(13) PP(3)
    TYPE(GET)  NAME(CTYPDOKL)  FPOS(18,4) FLEN( 7) FCAPTION(Typ dokladu) CPOS(1,4) POST( postLastField_2)
  TYPE(End)
TYPE(End)