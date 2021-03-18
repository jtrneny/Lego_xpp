TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù operací) SIZE(60,15) FILE(C_TYPOP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect) 
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPOP) FIELDS(cTypOper,cPopisOper,cKodOper);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect) 
  TYPE(GET) NAME(cTypOper)    FPOS(15,1) FLEN( 3) FCAPTION(Typ operace)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisOper)  FPOS(15,2) FLEN(30) FCAPTION(Název typu operace) CPOS(1,2)
  TYPE(GET) NAME(cKodOper)    FPOS(15,3) FLEN( 3) FCAPTION(Kód typu)           CPOS(1,3) POST( postLastField_2)
TYPE(End)

