TYPE(drgForm) DTYPE(2) TITLE(Èíselník titulù pøed jménem) SIZE(60,15) FILE(C_TITPR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TITPR) FIELDS(cTitulPred,cNazTitPr) CURSORMODE(3) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTitulPred)  FPOS(15,1) FLEN(20)  FCAPTION(Zkratky titulù) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTitPr) FPOS(15,2) FLEN(35) FCAPTION(Názvy titulù) CPOS(1,2)
TYPE(End)
