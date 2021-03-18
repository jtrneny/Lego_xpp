TYPE(drgForm) DTYPE(2) TITLE(Èíselník sumací do kontrolky) SIZE(60,15) FILE(C_INFSUM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_INFSUM) FIELDS(cKodSumRad,cNazSumRad,nPoradi,lActive,lSumHod,lSumDny,cKodPrer,mcKODprer,nKodPrer,mnKODprer);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cKodSumRad) FPOS(15,1)  FLEN(15) FCAPTION(Kód sumace)            CPOS(1,1);
                   POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazSumRad) FPOS(15,2)  FLEN(30) FCAPTION(Název sumace)          CPOS(1,2)
  TYPE(GET)      NAME(nPoradi)    FPOS(15,3)  FLEN(30) FCAPTION(Poøadí sumace)         CPOS(1,3)
  TYPE(COMBOBOX) NAME(lActive)    FPOS(15,4)  FLEN( 6) FCAPTION(Aktivní sumace)        CPOS(1,4) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lSumHod)    FPOS(15,5)  FLEN( 6) FCAPTION(Sumace hodin)          CPOS(1,5) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lSumDny)    FPOS(15,6)  FLEN( 6) FCAPTION(Sumace dnù)            CPOS(1,6) REF( LYESNO) 
  TYPE(GET)      NAME(cKodPrer)   FPOS(15,7)  FLEN(10) FCAPTION(Kód pøerušení-text)    CPOS(1,7)
  TYPE(GET)      NAME(mcKodPrer)  FPOS(15,8)  FLEN(30) FCAPTION(Obsah)                 CPOS(1,8)
  TYPE(GET)      NAME(nKodPrer)   FPOS(15,9)  FLEN(10) FCAPTION(Kód pøerušení-num.)    CPOS(1,9)
  TYPE(GET)      NAME(mnKodPrer)  FPOS(15,10) FLEN(30) FCAPTION(Obsah)                 CPOS(1,10)
TYPE(End)
