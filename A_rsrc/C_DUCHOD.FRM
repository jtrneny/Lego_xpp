TYPE(drgForm) DTYPE(2) TITLE(Èíselník dùchodù) SIZE(60,15) FILE(C_DUCHOD);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_DUCHOD) FIELDS(nTypDuchod,cNazDuchod::38,cTypDucReg);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nTypDuchod)        FPOS( 20,1) FLEN( 2)                    FCAPTION(Typ dùchodu)      CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazDuchod)        FPOS( 20,2) FLEN(35)                    FCAPTION(Název dùchodu)    CPOS(1,2)
  TYPE(COMBOBOX) NAME(cTypDucReg)   FPOS( 20,4) FLEN(36)  REF( CTYPDUCREG)  FCAPTION(Typ dùchodu ÈSSZ) CPOS(1,4) 
TYPE(End)
