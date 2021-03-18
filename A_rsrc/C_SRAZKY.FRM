TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù srážek) SIZE(60,15) FILE(C_SRAZKY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_SRAZKY) FIELDS(cZkrSrazky,cNazSrazky,lPrednPohl,cTypSrz,nTypSrz,nDruhMzdy,nDruhMzdy2 ;
                               ,nDruhMzdy3) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrSrazky)  FPOS(15,1) FLEN(4)  FCAPTION(Zkratka mzdové srážky)   CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazSrazky)  FPOS(15,2) FLEN(30) FCAPTION(Název mzdové srážky)     CPOS(1,2)
  TYPE(GET) NAME(lPrednPohl)  FPOS(15,3) FLEN(3)  FCAPTION(Pøednostní pohledávka)   CPOS(1,3)
  TYPE(GET) NAME(cTypSrz)     FPOS(15,4) FLEN(4)  FCAPTION(Zkratka typu srážky)     CPOS(1,4)
  TYPE(GET) NAME(nTypSrz)     FPOS(15,5) FLEN(2)  FCAPTION(Typ srážky)              CPOS(1,5)
  TYPE(GET) NAME(nDruhMzdy)   FPOS(15,6) FLEN(4)  FCAPTION(Druh mzdy)               CPOS(1,6)
  TYPE(GET) NAME(nDruhMzdy2)  FPOS(15,7) FLEN(4)  FCAPTION(Druh mzdy 2)             CPOS(1,7)
  TYPE(GET) NAME(nDruhMzdy3)  FPOS(15,8) FLEN(4)  FCAPTION(Druh mzdy 3)             CPOS(1,8)
TYPE(End)
