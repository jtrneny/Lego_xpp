TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù elektro.spojení) SIZE(60,15) FILE(C_TYPELS);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPELS) FIELDS(CTYPELSPOJ,CNAZTYELSP,DPLATNYOD,DPLATNYDO);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CTYPELSPOJ) FPOS(15,1) FLEN(10) FCAPTION(Typ el.spojení) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZTYELSP) FPOS(15,2) FLEN(30) FCAPTION(Popis el.spojení) CPOS(1,2)
TYPE(End)

