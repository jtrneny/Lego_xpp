TYPE(drgForm) DTYPE(2) TITLE(Èíselník rozvozových tras) SIZE(80,12) FILE(C_TRASY)  GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) FPOS(.5,0.2) OFFSET(0,84) SIZE(79,11.5) PRE( tabSelect)
  TYPE(DBrowse) FPOS(0.2,0.2) SIZE(78.5,10) FILE(C_TRASY) FIELDS(ccistrasy:èíslo trasy     , ;
                                                   cnaztrasy:název trasy:63  ) ;
                                            CURSORMODE(3) PP(7) LFREEZE(1) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) FPOS(.5,0.2) OFFSET(14,70) SIZE(79,11.5)  PRE( tabSelect)
  TYPE(GET) NAME(ccistrasy)    FPOS(25, 1) FLEN(10) FCAPTION(èíslo trasy)  CPOS( 1, 1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cnaztrasy)    FPOS(25, 2) FLEN(30) FCAPTION(název trasy)  CPOS( 1, 2)
TYPE(End)
