TYPE(drgForm) DTYPE(2) TITLE(Èíselník hodinových sazeb) SIZE(60,15) FILE(C_TARIF);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TARIF) FIELDS(cTarifStup,cTarifTrid,nHodinSaz,nHodinNav) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTarifStup)  FPOS(15,1) FLEN( 8)   FCAPTION(Tarifní stupnice)    CPOS(1,1) 
  TYPE(GET) NAME(cTarifTrid)  FPOS(15,2) FLEN( 8)   FCAPTION(Tarifní tøída)       CPOS(1,2)
  TYPE(GET) NAME(nHodinSaz)   FPOS(15,3) FLEN( 8.3) FCAPTION(Hodinová sazba)      CPOS(1,3)
  TYPE(GET) NAME(nHodinNav)   FPOS(15,4) FLEN( 8.3) FCAPTION(Navýšení hod. sazby) CPOS(1,4) POST( postLastField_2)
TYPE(End)

