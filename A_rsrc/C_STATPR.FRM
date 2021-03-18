TYPE(drgForm) DTYPE(2) TITLE(Èíselník státní pøíslušnosti) SIZE(65,15) FILE(C_STATPR);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(64,14) FILE(C_STATPR) FIELDS(cZkrStaPri:zkr:10,CNAZSTAPRI::43,cZkratStat:stát) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrStaPri)     FPOS(20,1) FLEN(10)  FCAPTION(Zkratka státní pøíslušnosti)        CPOS(1,1)
  TYPE(GET) NAME(CNAZSTAPRI)     FPOS(20,2) FLEN(30)  FCAPTION(Název státní pøíslušnosti)          CPOS(1,2)
  TYPE(GET) NAME(cZkratStat)     FPOS(20,3) FLEN( 6)  FCAPTION(Zkratka státu)                      CPOS(1,3)
    TYPE(TEXT) NAME(c_staty->cnazevStat) CPOS(28,3)
TYPE(End)

