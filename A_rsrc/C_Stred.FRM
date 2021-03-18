TYPE(drgForm) DTYPE(2) TITLE(Èíselník støedisek) SIZE(60,15) FILE(C_STRED);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_STRED) FIELDS(cStred,cNazStr,cTypStr,cNazPol1) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cStred)    FPOS(15,1) FLEN( 5) FCAPTION(Støedisko)       CPOS(1,1)     POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazStr)   FPOS(15,2) FLEN(30) FCAPTION(Název støediska) CPOS(1,2)
  TYPE(GET) NAME(cTypStr)   FPOS(15,3) FLEN(10) FCAPTION(Typ støediska)   CPOS(1,3)
  TYPE(GET) NAME(cNazPol1)  FPOS(15,4) FLEN( 8) FCAPTION(Nákladové stø.)  CPOS(1,4) POST( postLastField_2)
TYPE(End)

