TYPE(drgForm) DTYPE(2) TITLE(��seln�k v�robn�ch operac�) SIZE(60,15) FILE(CNAZPOL6) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(CNAZPOL6) FIELDS(CNAZPOL6,CNAZEV);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CNAZPOL6) FPOS(15,1) FLEN(8) FCAPTION(V�r.operace) CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV) FPOS(15,2) FLEN(25) FCAPTION(N�zev v�r. operace) CPOS(1,2)
TYPE(End)

