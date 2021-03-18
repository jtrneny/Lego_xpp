TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhù èinností pro ÈSSZ) SIZE(60,15) FILE(C_PRVZDC);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRVZDC) FIELDS(cTypPPVReg,cNazDruCin) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypPPVReg)   FPOS(15,1) FLEN(8)  FCAPTION(Zkratka druhu)                   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazDruCin)   FPOS(15,2) FLEN(30) FCAPTION(Název druhu výdìleèné èinnosti)  CPOS(1,2)
TYPE(End)
