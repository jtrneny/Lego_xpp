TYPE(drgForm) DTYPE(2) TITLE(Èíselník opacimetrù) SIZE(68,15) FILE(C_OPACIM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(68,14) FILE(C_OPACIM) FIELDS(cCisEmiSta,dDatZkOpac,cTypOpacim);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cCisEmiSta)  FPOS(15,1) FLEN( 12) FCAPTION(Èís.emisní stanice)   CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(dDatZkOpac)  FPOS(15,2) FLEN( 12) FCAPTION(Datum zkoušky)        CPOS(1,2) PUSH(CLICKDATE)
  TYPE(GET) NAME(cTypOpacim)  FPOS(15,3) FLEN( 40) FCAPTION(Typ opacimetru)       CPOS(1,3) POST( postLastField_2)
TYPE(End)

