TYPE(drgForm) DTYPE(2) TITLE(Èíselník definice mzd.položek v poøízení dokladu) SIZE(60,15) FILE(C_MZDPOL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_MZDPOL) FIELDS(nPoradi,cNazevPole,cZkratPole,lVyberpole,cNazevProm,cPicture);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nPoradi)     FPOS(15, 1)  FLEN( 3)  FCAPTION(Druh mzdy)                       CPOS(1, 1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazevPole)  FPOS(15, 2)  FLEN(30)  FCAPTION(Název pole pro poøízení)         CPOS(1, 2)
  TYPE(GET) NAME(cZkratPole)  FPOS(15, 3)  FLEN(30)  FCAPTION(Zkratka názvu pole)              CPOS(1, 3)
  TYPE(GET) NAME(lVyberPole)  FPOS(15, 4)  FLEN(30)  FCAPTION(Potvrzení výbìru pole)           CPOS(1, 4)
  TYPE(GET) NAME(cNazevProm)  FPOS(15, 5)  FLEN(12)  FCAPTION(Název promìnné v souboru M_Dav)  CPOS(1, 5)
  TYPE(GET) NAME(cPicture)    FPOS(15, 6)  FLEN(12)  FCAPTION(Picture - vzor pro poøízení)     CPOS(1, 6)

TYPE(End)
