TYPE(drgForm) DTYPE(2) TITLE(Èíselník èasových period) SIZE(60,21) FILE(C_PERIOD);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,19) FILE(C_PERIOD) FIELDS(CPERIODA,CNAZPERIOD,NSEKUNDY,NMINUTY,NHODINY,NDNY,NTYDNY,NMESICE,NROKY) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CPERIODA)       FPOS(15,1)  FLEN(10)  FCAPTION(Zkr periody)        CPOS(1,1)
  TYPE(GET) NAME(CNAZPERIOD)     FPOS(15,2)  FLEN(30)  FCAPTION(Název periody)      CPOS(1,2)

  TYPE(GET) NAME(nSekundy)       FPOS(15,4)  FLEN(15)  FCAPTION(Sekundy)            CPOS(1,4)
  TYPE(GET) NAME(nMinuty)        FPOS(15,5)  FLEN(15)  FCAPTION(Minuty)             CPOS(1,5)
  TYPE(GET) NAME(nHodiny)        FPOS(15,6)  FLEN(15)  FCAPTION(Hodiny)             CPOS(1,6)
  TYPE(GET) NAME(nDny)           FPOS(15,7)  FLEN(15)  FCAPTION(Dny)                CPOS(1,7)
  TYPE(GET) NAME(nTydny)         FPOS(15,8)  FLEN(15)  FCAPTION(Týden)              CPOS(1,8)
  TYPE(GET) NAME(nMesice)        FPOS(15,9)  FLEN(15)  FCAPTION(Mìsíce)             CPOS(1,9)
  TYPE(GET) NAME(nRoky)          FPOS(15,10) FLEN(15)  FCAPTION(Roky)               CPOS(1,10)

  TYPE(COMBOBOX) NAME(nGenDen)  FPOS(15,12) FLEN(39) FCAPTION(Gener.-den)           CPOS(1,12)   ;
                 VALUES(0: 0 - generovat vždy,                     ;
                        1: 1 - generovat jen v pracovní den,       ;
                        2: 2 - negenerovat pokud není pracovní den,;
                        3: 3 - negenerovat pokud den je svátek)
*                   POST( postLastField_2)

  TYPE(GET) NAME(DPLATNYOD)  FPOS(15,14) FLEN(11) FCAPTION(Platnost OD)               CPOS(1,14) PUSH(CLICKDATE)
  TYPE(GET) NAME(DPLATNYDO)  FPOS(15,15) FLEN(11) FCAPTION(Platnost DO)               CPOS(1,15) PUSH(CLICKDATE)
  TYPE(MLE) NAME(MPOZNAMKA)  FPOS(15,16) SIZE(40,3)  FCAPTION(Poznámka)               CPOS(1,16)
TYPE(End)

