TYPE(drgForm) DTYPE(2) TITLE(Èíselník SKP) SIZE(60,15) FILE(C_SKUMIS) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_SKUMIS)                          ;
                            FIELDS( M->is_vydejNar:vn:3.6::2      , ;
                                    cklicSkMis:SKUP_místo:8       , ;
                                    cnazSkMis:název SKUP_místa:42 ) ; 
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CKLICSKMIS) FPOS(15,1) FLEN( 8) FCAPTION(KlíèOdpMísta)  CPOS(1,1)
  TYPE(GET) NAME(CNAZSKMIS)  FPOS(15,2) FLEN(25) FCAPTION(NázevOdpMísta) CPOS(1,2)

  TYPE(COMBOBOX) NAME(lvydejNar) FPOS(15,4) FLEN( 8) FCAPTION(Výdejna náøadí) CPOS(1,4) REF( LYESNO)
TYPE(End)

