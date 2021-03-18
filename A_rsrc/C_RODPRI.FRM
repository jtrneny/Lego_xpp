TYPE(drgForm) DTYPE(2) TITLE(Èíselník rodinných pøíslušníkù) SIZE(60,15) FILE(C_RODPRI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_RODPRI) FIELDS(cTypRodPr,cNazRodPr);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypRodPr) FPOS(15,1) FLEN(4)  FCAPTION(Typ)                              CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazRodPr) FPOS(15,2) FLEN(30) FCAPTION(Název typu rodinného pøíslušníka) CPOS(1,2)
TYPE(End)
