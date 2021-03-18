TYPE(drgForm) DTYPE(2) TITLE(Èíselník automatických bankovních operací - ABO) SIZE(60,15) FILE(C_TYPABO) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(dBrowse) SIZE(75,14) FILE(C_TYPABO) FIELDS(cTypABO,cPopisABO,nKodBanky) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypABO)     FPOS(15,1) FLEN(6)  FCAPTION(Kód typu ABO)    CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cPopisABO)   FPOS(15,2) FLEN(30) FCAPTION(Název typu ABO)  CPOS(1,2)
  TYPE(GET) NAME(nKodBanky)   FPOS(15,3) FLEN(4)  FCAPTION(Kód banky)       CPOS(1,3)
TYPE(End)
