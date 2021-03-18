TYPE(drgForm) DTYPE(2) TITLE(Èíselník farem) SIZE(60,15) FILE(C_FARMY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_FARMY) FIELDS(NFARMA,CNAZEVFAR,CKODHOSP);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)  NAME(NFARMA)    FPOS(18,1)  FLEN( 7) FCAPTION(Èíslo farmy)      CPOS(1,1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET)  NAME(CNAZEVFAR) FPOS(18,2)  FLEN(32) FCAPTION(Název farmy)      CPOS(1,2)
    TYPE(GET)  NAME(CKODHOSP)  FPOS(18,3)  FLEN( 7) FCAPTION(Kód hospodáøství) CPOS(1,3) POST( postLastField_2)
  TYPE(End)
TYPE(End)