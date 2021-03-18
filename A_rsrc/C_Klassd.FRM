TYPE(drgForm) DTYPE(2) TITLE(Èíselník klasifikace pro stavební díla) SIZE(60,15) FILE(C_KLASSD);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_KLASSD) FIELDS(CKODKLAS,CNAZEVKLAS) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CKODKLAS)     FPOS(15,1) FLEN(10) FCAPTION(Kód klasifikace)      CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEVKLAS)   FPOS(15,2) FLEN(30) FCAPTION(Název kódu)           CPOS(1,2) POST( postLastField_2)
  TYPE(GET) NAME(cPolOdpSk)    FPOS(15,3) FLEN(12) FCAPTION(Položka)              CPOS(1,3)
TYPE(End)

