TYPE(drgForm) DTYPE(2) TITLE(Èíselník pøíplatkù) SIZE(60,15) FILE(C_PRIPL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect) 
  TYPE(DBrowse) SIZE(60,14) FILE(C_PRIPL) FIELDS(cKodPripl,nHodPripl,cNazPripl,nDruhMzdy) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect) 
  TYPE(GET) NAME(cKodPripl)  FPOS(15,1) FLEN( 2) FCAPTION(Kód pøíplatku)    CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(nHodPripl)  FPOS(15,2) FLEN( 6) FCAPTION(Èástka pøíplatku) CPOS(1,2)
  TYPE(GET) NAME(cNazPripl)  FPOS(15,3) FLEN(30) FCAPTION(Název pøíplatku)  CPOS(1,3)
  TYPE(GET) NAME(nDruhMzdy)  FPOS(15,4) FLEN( 4) FCAPTION(Druh mzdy)        CPOS(1,4) POST( postLastField_2)
TYPE(End)

