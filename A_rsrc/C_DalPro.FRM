TYPE(drgForm) DTYPE(2) TITLE(Èíselník dalších prohlídek) SIZE(60,15) FILE(C_DALPRO);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_DALPRO) FIELDS(nDalMerMes,cDalsiProh);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nDalMerMes)  FPOS(15,1) FLEN(  2) FCAPTION(Další mìøení)     CPOS(1,1)
  TYPE(GET) NAME(cDalsiProh)  FPOS(15,2) FLEN( 10) FCAPTION(Další prohlídka)  CPOS(1,2) POST( postLastField_2)
TYPE(End)

