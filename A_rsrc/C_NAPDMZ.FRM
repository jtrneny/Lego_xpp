TYPE(drgForm) DTYPE(2) TITLE(Èíselník nápoètù do øádkù a sloupcù výpl.pásky) SIZE(60,15) FILE(C_NAPDMZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_NAPDMZ) FIELDS(nDruhMzdy,Dny,Hodiny,Hruba_Mzda,S_532A,S_532C,S_532E,S_532A,S_532B,S_532C ;
                                  ,P_KCSNEMOC,P_KCSPRACP,P_KCSPOHSL,P_KCSHOPRP,P_KCSPRESC,P_HODPRPRA         ;
                                  ,P_DNYODPDN) 
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nDruhMzdy)  FPOS(15, 1)  FLEN( 5)  FCAPTION(Druh mzdy)                CPOS(1, 1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(Dny)         FPOS(15, 2)  FLEN(30)  FCAPTION(Pole pozice <Vypl>)       CPOS(1, 2)
  TYPE(GET) NAME(Hodiny)      FPOS(15, 3)  FLEN(30)  FCAPTION(Typ nápoètu)              CPOS(1, 3)
  TYPE(GET) NAME(Hruba_Mzda)  FPOS(15, 4)  FLEN(30)  FCAPTION(Druh mzdy)                CPOS(1, 4)
  TYPE(GET) NAME(S_532A)      FPOS(15, 5)  FLEN(12)  FCAPTION(Sestava_532A)             CPOS(1, 5)
  TYPE(GET) NAME(S_532C)      FPOS(15, 6)  FLEN(12)  FCAPTION(Sestava_532C)             CPOS(1, 6)
  TYPE(GET) NAME(S_532E)      FPOS(15, 7)  FLEN(12)  FCAPTION(Sestava_532E)             CPOS(1, 7)
  TYPE(GET) NAME(S_537A)      FPOS(15, 8)  FLEN(10)  FCAPTION(Sestava_537A)             CPOS(1, 8)
  TYPE(GET) NAME(S_537B)      FPOS(15, 9)  FLEN(10)  FCAPTION(Sestava_537B)             CPOS(1, 9)
  TYPE(GET) NAME(S_537C)      FPOS(15,10)  FLEN(10)  FCAPTION(Sestava_537C)             CPOS(1,10)
  TYPE(GET) NAME(P_KCSNEMOC)  FPOS(15,11)  FLEN(10)  FCAPTION(Nápoèet do prùm.nemoc)    CPOS(1,11)
  TYPE(GET) NAME(P_KCSPRACP)  FPOS(15,12)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,12)
  TYPE(GET) NAME(P_KCSPOHSL)  FPOS(15,13)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,13)
  TYPE(GET) NAME(P_KCSHOPRP)  FPOS(15,14)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,14)
  TYPE(GET) NAME(P_KCSPRESC)  FPOS(15,15)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,15)
  TYPE(GET) NAME(P_HODPRPRA)  FPOS(15,16)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,16)
  TYPE(GET) NAME(P_DNYODPDN)  FPOS(15,17)  FLEN(10)  FCAPTION(Nápoèet do prùm.PP)       CPOS(1,17)


TYPE(End)
