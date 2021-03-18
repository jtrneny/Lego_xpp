TYPE(drgForm) DTYPE(2) TITLE(Èíselník zamìstnaneckých vztahù) SIZE(60,15) FILE(C_ZAMEVZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ZAMEVZ) FIELDS(nTypZamVzt,cNazZamVzt:název_zamVztahu:47) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nTypZamVzt) FPOS(15,1) FLEN(2)   FCAPTION(Klíè)                  CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazZamVzt) FPOS(15,2) FLEN(30)  FCAPTION(Název zamìstn.vztahu)  CPOS(1,2)
TYPE(End)
