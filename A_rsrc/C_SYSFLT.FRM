TYPE(drgForm) DTYPE(2) TITLE(Èíselník systémových filtrù) SIZE(70,15) FILE(C_SYSFLT);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_SYSFLT) FIELDS(NSYSFLT,CNAZSYSFLT,DPLATNYOD,DPLATNYDO);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(NSYSFLT)       FPOS(15,1) FLEN(10) FCAPTION(Typy systémových filtrù)               CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZSYSFLT)    FPOS(15,2) FLEN(30) FCAPTION(Název filtru)                          CPOS(1,2)
  TYPE(GET) NAME(DPLATNYOD)     FPOS(15,3) FLEN(11) FCAPTION(Platnost OD)                           CPOS(1,3) PUSH(CLICKDATE)
  TYPE(GET) NAME(DPLATNYDO)     FPOS(15,4) FLEN(11) FCAPTION(Platnost DO)                           CPOS(1,4) PUSH(CLICKDATE)

  TYPE(MLE) NAME(MBLOCK)       FPOS(15,5.3) SIZE(50,4)  FCAPTION(Externí blok)                    CPOS(1,5.2)
  TYPE(MLE) NAME(MPOZNAMKA)    FPOS(15,9.7) SIZE(50,4)  FCAPTION(Poznámka)                      CPOS(1,9.6)
TYPE(End)