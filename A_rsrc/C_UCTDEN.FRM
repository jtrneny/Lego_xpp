TYPE(drgForm) DTYPE(2) TITLE(Èíselník úèetních deníkù) SIZE(60,15) FILE(C_UCTDEN);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_UCTDEN) FIELDS(CDENIK,CNAZDENIK,CTASK,CITEM) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CDENIK)    FPOS(20,1) FLEN(2)   FCAPTION(Zkratka úèetního deníku)        CPOS(1,1)
  TYPE(GET) NAME(CNAZDENIK) FPOS(20,2) FLEN(25)  FCAPTION(Název deníku)                   CPOS(1,2)
  TYPE(GET) NAME(CTASK)     FPOS(20,3) FLEN(3)   FCAPTION(Zkratka úlohy)                  CPOS(1,3)
  TYPE(GET) NAME(CULOHA)    FPOS(20,4) FLEN(1)   FCAPTION(Zkratka úlohy na 1)             CPOS(1,4)
  TYPE(GET) NAME(CITEM)     FPOS(20,5) FLEN(10)  FCAPTION(Položka-parametr)               CPOS(1,5)
  TYPE(GET) NAME(LUCTUJ)    FPOS(20,6) FLEN(1)   FCAPTION(Úloha úètuje)                   CPOS(1,6)
TYPE(End)

