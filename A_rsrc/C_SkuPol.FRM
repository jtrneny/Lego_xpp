TYPE(drgForm) DTYPE(2) TITLE(Èíselník skupin vyrábìných položek) SIZE(60,15) FILE(C_SKUPOL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_SKUPOL) FIELDS(cSkuPol,cNazSkuPol,cKodPrg);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cSkuPol)    FPOS(15,1) FLEN(12) FCAPTION(Skupina položek)   CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazSkuPol) FPOS(15,2) FLEN(20) FCAPTION(Název skupiny)     CPOS(1,2)
  TYPE(GET) NAME(cKodPrg)    FPOS(15,3) FLEN( 2) FCAPTION(Kód pro program)   CPOS(1,3) POST( postLastField_2)
TYPE(End)

