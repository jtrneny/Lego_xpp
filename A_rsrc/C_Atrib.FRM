TYPE(drgForm) DTYPE(2) TITLE(Èíselník atributù operací) SIZE(60,15) FILE(C_ATRIB);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_ATRIB) FIELDS( cAtribOper,cPopisAtr,cZkratJedn,cKodAtr);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cAtribOper)  FPOS(15,1) FLEN( 4) FCAPTION(Atribut operace)        CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisAtr)   FPOS(15,2) FLEN(30) FCAPTION(Popis atributu operace) CPOS(1,2)
  TYPE(GET) NAME(cZkratJedn)  FPOS(15,3) FLEN( 3) FCAPTION(Mìrná jednotka)         CPOS(1,3)
  TYPE(GET) NAME(cKodAtr)     FPOS(15,4) FLEN( 2) FCAPTION(Kód atributu)           CPOS(1,4) POST( postLastField_2)
TYPE(End)

