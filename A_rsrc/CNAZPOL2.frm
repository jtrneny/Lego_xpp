TYPE(drgForm) DTYPE(2) TITLE(��seln�k v�robk�) SIZE(75,15) FILE(CNAZPOL2) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(CNAZPOL2) FIELDS(CNAZPOL2,CNAZEV,CUCETTRZEB);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CNAZPOL2) FPOS(15,1) FLEN(8) FCAPTION(V�robek) CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV) FPOS(15,2) FLEN(25) FCAPTION(N�zev v�robku) CPOS(1,2)
  TYPE(GET) NAME(CUCETTRZEB) FPOS(15,3) FLEN(6) FCAPTION(��etTr�eb) CPOS(1,3)
TYPE(End)
