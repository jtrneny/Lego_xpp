TYPE(drgForm) DTYPE(2) TITLE(Èíselník zdravotních stavù ...) SIZE(85,15) FILE(C_ZDRSTA) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) RESIZE(yy) PRE( tabSelect) 
  TYPE(DBrowse) SIZE(84,14) FILE(C_ZDRSTA) FIELDS(cZkrZdrSta,cNazZdrSta::40,lEvidovZP,lEvidovZZN,lPrukazZPS,cPrukazZPS::20);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(DetailA)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cZkrZdrSta)       FPOS(25,1) FLEN(15)  FCAPTION(Zkratka zdr.stavu)              CPOS(1,1)
  TYPE(GET)      NAME(cNazZdrSta)       FPOS(25,2) FLEN(40)  FCAPTION(Název zdravotního stavu)        CPOS(1,2)
  TYPE(COMBOBOX) NAME(lEvidovZP)        FPOS(25,3) FLEN(10)  FCAPTION(Zdravotnì postižený)            CPOS(1,3) REF(LYESNO) 
  TYPE(COMBOBOX) NAME(lEvidovZZN)       FPOS(25,4) FLEN(10)  FCAPTION(Zdravotnì znevýhodnìný)         CPOS(1,4) REF(LYESNO) 
  TYPE(COMBOBOX) NAME(cPrukazZPS)       FPOS(25,5) FLEN(40)  FCAPTION(Prùkaz zdr.postiženého)         CPOS(1,5) REF(cPRUKAZZPS) 
  TYPE(COMBOBOX) NAME(lPrukazZPS)       FPOS(25,6) FLEN(10)  FCAPTION(Držitel prùkazu zdr.post.)      CPOS(1,6) REF(LYESNO) 
TYPE(End)

