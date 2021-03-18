TYPE(drgForm) DTYPE(2) TITLE(Èíselník svátkù) SIZE(60,15) FILE(C_TYPTRP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect) 
  TYPE(DBrowse) SIZE(75,14) FILE(C_TYPTRP) FIELDS(cZkrTrvPla,cNazTypTrP,cZkrRozlTP);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect) 
  TYPE(GET) NAME(cZkrTrvPla)  FPOS(15,1)  FLEN(5)  FCAPTION(Zkratka typu trvalé platby)     CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTypTrP)  FPOS(15,2)  FLEN(30)  FCAPTION(Název typu trvalé platby)      CPOS(1,2)
  TYPE(GET) NAME(cZkrRozlTP)  FPOS(15,3)  FLEN(2)   FCAPTION(Zkr.pro rozlišení trv.platby)  CPOS(1,3)
TYPE(End)
