TYPE(drgForm) DTYPE(2) TITLE(Èíselník pracovního zaøazení) SIZE(60,15) FILE(C_PRACZA);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRACZA) FIELDS(cPracZar,cNazPracZa:název pracZaøazení:39,nKlasZam) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cPracZar)   FPOS(15,1) FLEN(8)  FCAPTION(Zkrataka)                   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazPracZa) FPOS(15,2) FLEN(30) FCAPTION(Název pracovního zaøazení)  CPOS(1,2)
  TYPE(GET) NAME(nKlasZam)   FPOS(15,3) FLEN(5)  FCAPTION(Klasifikace zamìstn.)       CPOS(1,3)
TYPE(End)
