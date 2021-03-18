TYPE(drgForm) DTYPE(2) TITLE(Èíselník koeficientù pèepoètu MJ) SIZE(60,15) FILE(C_KOEF);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84)  PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_KOEF) FIELDS(cPopisKoef,nKoefPrep);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cPopisKoef)  FPOS(15,1) FLEN( 30)   FCAPTION(Popis koeficientu)    CPOS(1,1) 
  TYPE(GET) NAME(nKoefPrep)   FPOS(15,2) FLEN( 12)   FCAPTION(Koeficient pøepoètu)  CPOS(1,2) POST( postLastField_2)
TYPE(End)

