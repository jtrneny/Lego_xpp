TYPE(drgForm) DTYPE(2) TITLE(Èíselník vazeb stáj-farma) SIZE(60,15) FILE(C_FARMYV);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14)  FILE(C_FARMYV) FIELDS(cNazPol4, nFarma, nObec, nFarmaPuv);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)  NAME( cNazPol4)    FPOS(20,1)  FLEN(12) FCAPTION( Oznaèení stáje)    CPOS(1,1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET)  NAME( nFarma)      FPOS(20,2)  FLEN(12) FCAPTION( Èíslo farmy)       CPOS(1,2)
    TYPE(GET)  NAME( nObec)       FPOS(20,3)  FLEN(12) FCAPTION( Èíslo obce)        CPOS(1,3)
    TYPE(GET)  NAME( nFarmaPuv)   FPOS(20,4)  FLEN(12) FCAPTION( Èís.pùvodní farmy) CPOS(1,4) POST( postLastField_2)
  TYPE(End)
TYPE(End)