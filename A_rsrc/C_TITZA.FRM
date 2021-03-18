TYPE(drgForm) DTYPE(2) TITLE(Èíselník titulù za jménem) SIZE(60,15) FILE(C_TITZA);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TITZA) FIELDS(cTitulZa,cNazTitZa) CURSORMODE(3) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTitulZa)  FPOS(15,1) FLEN(20)  FCAPTION(Zkratky titulù) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTitZa) FPOS(15,2) FLEN(35) FCAPTION(Názvy titulù) CPOS(1,2)
TYPE(End)
