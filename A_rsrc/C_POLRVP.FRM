TYPE(drgForm) DTYPE(2) TITLE(Èíselník nápoètù do øádkù a sloupcù výpl.pásky) SIZE(60,15) FILE(C_POLRVP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_POLRVP) FIELDS(cRz_Vp,nField_VP,nTypNap,nDruhMzdy,cDruhMzdy) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cRz_Vp)     FPOS(15,1)  FLEN(4)   FCAPTION(Pozice v souboru <Vypl>)  CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(nField_VP)  FPOS(15,2)  FLEN( 4)  FCAPTION(Pole pozice <Vypl>)       CPOS(1,2)
  TYPE(GET) NAME(nTypNap)    FPOS(15,3)  FLEN( 2)  FCAPTION(Typ nápoètu)              CPOS(1,3)
  TYPE(GET) NAME(nDruhMzdy)  FPOS(15,4)  FLEN( 4)  FCAPTION(Druh mzdy)                CPOS(1,4)
  TYPE(GET) NAME(cDruhMzdy)  FPOS(15,5)  FLEN(20)  FCAPTION(Název druhu mzdy)         CPOS(1,5)
TYPE(End)
