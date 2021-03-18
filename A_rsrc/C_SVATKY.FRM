TYPE(drgForm) DTYPE(2) TITLE(Èíselník svátkù) SIZE(60,15) FILE(C_SVATKY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_SVATKY) FIELDS(dDatum,cNazev,nRok,nMesic,nDen,lSvatek,lVolDen) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)  
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(dDatum)      FPOS(15,1)  FLEN(10)  FCAPTION(Datum svátku-vol.dne)     CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazev)      FPOS(15,2)  FLEN(30)  FCAPTION(Název svátku-vol.dne)     CPOS(1,2)
  TYPE(GET) NAME(nRok)        FPOS(15,3)  FLEN(4) FCAPTION(Rok)                      CPOS(1,3)
  TYPE(GET) NAME(nMesic)      FPOS(15,4)  FLEN(2)  FCAPTION(Mìsíc)                    CPOS(1,4)
  TYPE(GET) NAME(nDen)        FPOS(15,5)  FLEN(2)  FCAPTION(Den)                      CPOS(1,5)
  TYPE(GET) NAME(lSvatek)     FPOS(15,6)  FLEN(3)  FCAPTION(Den je svátek)            CPOS(1,6)
  TYPE(GET) NAME(lVolDen)     FPOS(15,7)  FLEN(3)  FCAPTION(Den je volný den)         CPOS(1,7)
TYPE(End)
