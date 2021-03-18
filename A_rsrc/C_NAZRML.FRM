TYPE(drgForm) DTYPE(2) TITLE(Èíselník názvù øádkù mzdového listu) SIZE(60,15) FILE(C_NAZRML);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_NAZRML) FIELDS(nRadMzdLis,cNazRadMzL,nTypRadMzL,cTypValueR,cKmenValue,Ml_RAD,Name_RAD);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nRadMzdLis)  FPOS(15,1) FLEN( 5)  FCAPTION(Øádek mzdového listu)   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazRadMzL)  FPOS(15,2) FLEN(30)  FCAPTION(Typ øádku Èíslo firmy)  CPOS(1,2)
  TYPE(GET) NAME(nTypRadMzL)  FPOS(15,3) FLEN( 4)  FCAPTION(Èíslo firmy)            CPOS(1,3)
  TYPE(GET) NAME(cTypValueR)  FPOS(15,4) FLEN( 1)  FCAPTION(Èíslo firmy)            CPOS(1,4)
  TYPE(GET) NAME(cKmenValue)  FPOS(15,5) FLEN(30)  FCAPTION(Èíslo firmy)            CPOS(1,5)
  TYPE(GET) NAME(Name_RAD)    FPOS(15,6) FLEN( 3)  FCAPTION(Název øádku mzd.listu)  CPOS(1,6)
  TYPE(GET) NAME(Ml_RAD)      FPOS(15,7) FLEN(23)  FCAPTION(Øádek mzdového listu)   CPOS(1,7)
TYPE(End)
