TYPE(drgForm) DTYPE(2) TITLE(Èíselník názvù zboží) SIZE(60,15) FILE(C_NAZZBO) ;
                       GUILOOK(Action:n);
                       PRE( PREVALIDATE)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE(tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_NAZZBO) FIELDS(NZBOZIKAT,CNAZEVNAZ,NKLICNAZ);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE(tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)


    TYPE(GET)  NAME(CNAZEVNAZ) FPOS(15,1) FLEN(30) FCAPTION(Název zboží) CPOS(1,1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET)  NAME(NZBOZIKAT) FPOS(15,2) FLEN( 7) FCAPTION(Kat. zboží)  CPOS(1,2)
    TYPE(Text) NAME(C_KatZBO->cNazevKat)  CPOS(23,2) CLEN(23) BGND(13) PP(3)
    TYPE(GET)  NAME(NKLICNAZ)  FPOS(15,3) FLEN( 7) FCAPTION(Klíè názvu)  CPOS(1,3)       POST( postLastField_2)
  TYPE(End)
TYPE(End)