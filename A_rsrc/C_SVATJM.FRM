TYPE(drgForm) DTYPE(2) TITLE(Èíselník jmen-svátkù) SIZE(60,15) FILE(C_SVATJM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_SVATJM) FIELDS(cSvatJmeno,nDen,nMesic) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)  
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cSvatJmeno)  FPOS(15,1)  FLEN(30) FCAPTION(Jméno)                        CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(nMesic)      FPOS(15,2)  FLEN(2)  FCAPTION(MìsícSvát)                    CPOS(1,2)
  TYPE(GET) NAME(nDen)        FPOS(15,3)  FLEN(2)  FCAPTION(DenSvát)                      CPOS(1,3)
TYPE(End)
