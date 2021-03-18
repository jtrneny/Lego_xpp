TYPE(drgForm) DTYPE(2) TITLE(Èíselník nápoètù do výkazù) SIZE(60,15) FILE(C_VYKAZM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_VYKAZM) FIELDS(nDruhMzdy,cVyk1_hod,cVyk1_dny,cVyk1_kc,cVyk2_hod,cVyk2_dny,cVyk2_kc
                                 ,cVyk3_hod,cVyk3_dny,cVyk3_kc,cVyk4_hod,cVyk4_dny,cVyk4_kc
                                 ,cVyk5_hod,cVyk5_dny,cVyk5_kc) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nDruhMzdy)  FPOS(15, 1)  FLEN( 5)  FCAPTION(Druh mzdy)          CPOS(1, 1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cVyk1_hod)  FPOS(15, 2)  FLEN(10)  FCAPTION(Výkaz_1 hodiny)     CPOS(1, 2)
  TYPE(GET) NAME(cVyk1_dny)  FPOS(15, 3)  FLEN(10)  FCAPTION(Výkaz_1 dny)        CPOS(1, 3)
  TYPE(GET) NAME(cVyk1_kc)   FPOS(15, 4)  FLEN(20)  FCAPTION(Výkaz_1 èástka)     CPOS(1, 4)
  TYPE(GET) NAME(cVyk2_hod)  FPOS(15, 5)  FLEN(10)  FCAPTION(Výkaz_1 hodiny)     CPOS(1, 5)
  TYPE(GET) NAME(cVyk2_dny)  FPOS(15, 6)  FLEN(10)  FCAPTION(Výkaz_1 dny)        CPOS(1, 6)
  TYPE(GET) NAME(cVyk2_kc)   FPOS(15, 7)  FLEN(20)  FCAPTION(Výkaz_1 èástka)     CPOS(1, 7)
  TYPE(GET) NAME(cVyk3_hod)  FPOS(15, 8)  FLEN(10)  FCAPTION(Výkaz_1 hodiny)     CPOS(1, 8)
  TYPE(GET) NAME(cVyk3_dny)  FPOS(15, 9)  FLEN(10)  FCAPTION(Výkaz_1 dny)        CPOS(1, 9)
  TYPE(GET) NAME(cVyk3_kc)   FPOS(15,10)  FLEN(20)  FCAPTION(Výkaz_1 èástka)     CPOS(1,10)
  TYPE(GET) NAME(cVyk4_hod)  FPOS(15,11)  FLEN(10)  FCAPTION(Výkaz_1 hodiny)     CPOS(1,11)
  TYPE(GET) NAME(cVyk4_dny)  FPOS(15,12)  FLEN(10)  FCAPTION(Výkaz_1 dny)        CPOS(1,12)
  TYPE(GET) NAME(cVyk4_kc)   FPOS(15,13)  FLEN(20)  FCAPTION(Výkaz_1 èástka)     CPOS(1,13)
  TYPE(GET) NAME(cVyk5_hod)  FPOS(15,14)  FLEN(10)  FCAPTION(Výkaz_1 hodiny)     CPOS(1,14)
  TYPE(GET) NAME(cVyk5_dny)  FPOS(15,15)  FLEN(10)  FCAPTION(Výkaz_1 dny)        CPOS(1,15)
  TYPE(GET) NAME(cVyk5_kc)   FPOS(15,16)  FLEN(20)  FCAPTION(Výkaz_1 èástka)     CPOS(1,16)


TYPE(End)
