TYPE(drgForm) DTYPE(2) TITLE(Èíselník podporovaných terminálù ...) SIZE(85,15) FILE(C_TYPTER) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) RESIZE(yy) PRE( tabSelect) 
  TYPE(DBrowse) SIZE(84,14) FILE(C_TYPTER) FIELDS(cTask,cZkrTerm,cNazevTerm::30,cModelTerm);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(DetailA)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cTask)            FPOS(25,1) FLEN(15)  FCAPTION(Úloha)                          CPOS(1,1)
  TYPE(GET)      NAME(cZkrTerm)         FPOS(25,2) FLEN(10)  FCAPTION(Zkratka terminálu)              CPOS(1,2)
  TYPE(GET)      NAME(cNazevTerm)       FPOS(25,3) FLEN(50)  FCAPTION(Název terminálu)                CPOS(1,3)
  TYPE(GET)      NAME(cModelTerm)       FPOS(25,4) FLEN(20)  FCAPTION(Model terminálu)                CPOS(1,4)
TYPE(End)
