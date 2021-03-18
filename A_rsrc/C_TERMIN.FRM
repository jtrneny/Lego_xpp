TYPE(drgForm) DTYPE(2) TITLE(Èíselník vstupních terminálù ) SIZE(60,15) FILE(C_TERMIN);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TERMIN) FIELDS(nPorTermin,cNazTermin,lAktivni,cAdrTerm,cSNTerm,mINITpopis);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cTask)      FPOS(15,1) FLEN( 5) FCAPTION(Úloha-task)            CPOS(1,1)
  TYPE(GET)      NAME(cZkrTerm)   FPOS(15,2) FLEN(10) FCAPTION(Zkratka typu term.)    CPOS(1,2)
  TYPE(GET)      NAME(nPorTermin) FPOS(15,3) FLEN( 5) FCAPTION(Poøadí terminálu)      CPOS(1,3);
                  POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazTermin) FPOS(15,4) FLEN(40) FCAPTION(Název terminálu)       CPOS(1,4)
  TYPE(COMBOBOX) NAME(lAktivni)   FPOS(15,5) FLEN( 6) FCAPTION(Aktivní)               CPOS(1,5) REF( LYESNO)
  TYPE(GET)      NAME(cAdrTerm)   FPOS(15,6) FLEN(40) FCAPTION(Adresa terminálu)      CPOS(1,6)
  TYPE(GET)      NAME(cSNTerm)    FPOS(15,7) FLEN(40) FCAPTION(Sériové èíslo term.)   CPOS(1,7)
  TYPE(GET)      NAME(mINITpopis) FPOS(15,8) FLEN(40) FCAPTION(Inicializaèní blok)    CPOS(1,8)
TYPE(End)

