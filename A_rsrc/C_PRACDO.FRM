TYPE(drgForm) DTYPE(2) TITLE(Èíselník pracovní doby) SIZE(60,15) FILE(C_PRACDO);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRACDO) FIELDS(cDelkPrDob,cNazDelPrD,nDnyTyden,nHodTyden,nHodDen);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cDelkPrDob)  FPOS(15,1) FLEN(20)   FCAPTION(Klíè délky prac.doby)       CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazDelPrD)  FPOS(15,3) FLEN(30)   FCAPTION(Název délky pracovní doby)  CPOS(1,3)
  TYPE(GET) NAME(nDnyTyden)   FPOS(15,4) FLEN(5)  FCAPTION(Dnù za týden)               CPOS(1,4)
  TYPE(GET) NAME(nHodTyden)   FPOS(15,5) FLEN(6)  FCAPTION(Hodin za týden)             CPOS(1,5)
  TYPE(GET) NAME(nHodDen)     FPOS(15,6) FLEN(5)  FCAPTION(Hodin za den)               CPOS(1,6)
TYPE(End)
