TYPE(drgForm) DTYPE(2) TITLE(Typy výkresù) SIZE(60,15) FILE(C_TYPVYKR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(55,14) FILE(C_TYPVYKR) FIELDS( cTypVyk, cTypVykNaz);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70)  RESIZE(yn) PRE( tabSelect)
  TYPE(GET) NAME(cTypVyk)     FPOS(15,1) FLEN( 4) FCAPTION(Typ výkresu)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cTypVykNaz)  FPOS(15,2) FLEN(30) FCAPTION(Název typu výkresu) CPOS(1,2) POST( postLastField_2)
TYPE(End)
