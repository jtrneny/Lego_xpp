TYPE(drgForm) DTYPE(2) TITLE(Èíselník mincí) SIZE(80,15) FILE(C_MINCE);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_MINCE) FIELDS( cZKRATmeny:zkrMìny,    ;
                                                  cNazMince:název mince:20, ;
                                                  nHodMince:typ mince,   ;
                                                  cZkrMince:zkrMince,    ;
                                                  nValMince:hodnota,     ; 
                                                  lTaskFIN:úlohaFIN,     ;   
                                                  lTaskMZD:úlohaMZD     );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cZKRATmeny) FPOS(20,1) FLEN( 8)  FCAPTION(Zkratka mìny)              CPOS(1,1) 
  TYPE(GET)      NAME(cNazMince)  FPOS(20,2) FLEN(30) FCAPTION(Název mince)                CPOS(1,2)
  TYPE(GET)      NAME(nHodMince)  FPOS(20,3) FLEN( 8) FCAPTION(Hodnota mince)              CPOS(1,3)
  TYPE(GET)      NAME(cZkrMince)  FPOS(20,4) FLEN( 8) FCAPTION(Zkratka mince)              CPOS(1,4)
  TYPE(GET)      NAME(nValMince)  FPOS(20,5) FLEN( 8) FCAPTION(Hodnota mince-VAL)          CPOS(1,5)
  TYPE(COMBOBOX) NAME(lTaskFIN)   FPOS(20,6) FLEN( 8) FCAPTION(Výèetka pro FIN)            CPOS(1,6) REF( LYESNO)
  TYPE(COMBOBOX) NAME(lTaskMZD)   FPOS(20,7) FLEN( 8) FCAPTION(Výèetka pro MZD)            CPOS(1,7) REF( LYESNO)
TYPE(End)
