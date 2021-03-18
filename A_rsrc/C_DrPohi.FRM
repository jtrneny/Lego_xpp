TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhu pohybù majetku) SIZE(60,15) FILE(C_DRPOHI);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_DRPOHI) FIELDS(NDRPOHYB,cNazevPOH,NKARTA,nTypPohyb);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nDrPohyb)    FPOS(15,1) FLEN( 4) FCAPTION(Druh pohybu)            CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazevPoh)   FPOS(15,2) FLEN(30) FCAPTION(Název pohybu)           CPOS(1,2)
  TYPE(GET) NAME(nKarta)      FPOS(15,3) FLEN( 3) FCAPTION(Typ editaèní karty)     CPOS(1,3)
  TYPE(GET) NAME(nTypPohyb)   FPOS(15,4) FLEN( 2) FCAPTION(Typ pohybu)             CPOS(1,4) POST( postLastField_2)
TYPE(End)

