TYPE(drgForm) DTYPE(2) TITLE(Èíselník daòových odpisových skupin) SIZE(100,15) FILE(C_DANSKP);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) FPOS(0,2) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(100,14) FILE(C_DANSKP);
                             FIELDS( CODPISKD:Daò.sk. ,;
                                     NODPISKD  ,;
                                     HIM_isHmotny( 'C_DANSKP'):Hmotný maj.,;
                                     cMJCas    ,;
                                     NROKYODPIS,;
                                     nMesOdpiD ,;
                                     nMesTZhod ,;
                                     NROPRVNI  ,;
                                     NRODALSI  ,;
                                     NROZVCENA ,;
                                     NZRPRVNI  ,;
                                     NZRDALSI  ,;
                                     NZRZVCENA ,;
                                     NROPRVNI10,;
                                     NRODALSI10,;
                                     NROZVCEN10,;
                                     NROPRVNI15,;
                                     NRODALSI15,;
                                     NROZVCEN15,;
                                     NROPRVNI20,;
                                     NRODALSI20,;
                                     NROZVCEN20 );
                            CURSORMODE(3) PP(7) LFREEZE(1) SCROLL(yy) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) FPOS(0,2) OFFSET(14,70)  PRE( tabSelect)
  TYPE(GET)      NAME(CODPISKD)     FPOS(25, 1) FLEN( 5) FCAPTION(Daòová skupina)        CPOS( 1, 1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(NODPISKD)     FPOS(25, 2) FLEN( 5) FCAPTION(Daòová skupina)        CPOS( 1, 2)
  TYPE(COMBOBOX) NAME(LHMOTNYIM)    FPOS(25, 3) FLEN( 6) FCAPTION(Hmotný majetek)        CPOS( 1, 3) REF( LYESNO)
  TYPE(COMBOBOX) NAME(CMJCAS)       FPOS(25, 4) FLEN( 8) FCAPTION(MJ daò.odpisování)     CPOS( 1, 4) VALUES(M:Mìsice,R:Roky)
  TYPE(GET)      NAME(NMESODPID)    FPOS(25, 5) FLEN( 5) FCAPTION(Mìsíce odpisu)         CPOS( 1, 5)
  TYPE(GET)      NAME(NROKYODPIS)   FPOS(25, 6) FLEN( 5) FCAPTION(Roky odpisu)           CPOS( 1, 6)
  TYPE(GET)      NAME(NROprvni)     FPOS(25, 7) FLEN( 5) FCAPTION(Rovnomìr. 1.rok)       CPOS( 1, 7)
  TYPE(GET)      NAME(NROdalsi)     FPOS(25, 8) FLEN( 5) FCAPTION(Rovnomìr. další)       CPOS( 1, 8)
  TYPE(GET)      NAME(NROzvcena)    FPOS(25, 9) FLEN( 5) FCAPTION(Rovnomìr. zv.cena)     CPOS( 1, 9)
  TYPE(GET)      NAME(NZRprvni)     FPOS(25,10) FLEN( 5) FCAPTION(Zrychl. 1.rok)         CPOS( 1,10)
  TYPE(GET)      NAME(NZRdalsi)     FPOS(25,11) FLEN( 5) FCAPTION(Zrychl. další)         CPOS( 1,11)
  TYPE(GET)      NAME(NZRzvcena)    FPOS(25,12) FLEN( 5) FCAPTION(Zrychl. zv.cena)       CPOS( 1,12)

  TYPE(GET)      NAME(NROprvni10)   FPOS(70, 1) FLEN( 5) FCAPTION(Rovnomìr. 1.rok 10%)   CPOS(45, 1)
  TYPE(GET)      NAME(NROdalsi10)   FPOS(70, 2) FLEN( 5) FCAPTION(Rovnomìr. další 10%)   CPOS(45, 2)
  TYPE(GET)      NAME(NROzvcen10)   FPOS(70, 3) FLEN( 5) FCAPTION(Rovnomìr. zv.cena 10%) CPOS(45, 3)
  TYPE(GET)      NAME(NROprvni15)   FPOS(70, 4) FLEN( 5) FCAPTION(Rovnomìr. 1.rok 15%)   CPOS(45, 4)
  TYPE(GET)      NAME(NROdalsi15)   FPOS(70, 5) FLEN( 5) FCAPTION(Rovnomìr. další 15%)   CPOS(45, 5)
  TYPE(GET)      NAME(NROzvcen15)   FPOS(70, 6) FLEN( 5) FCAPTION(Rovnomìr. zv.cena 15%) CPOS(45, 6)
  TYPE(GET)      NAME(NROprvni20)   FPOS(70, 7) FLEN( 5) FCAPTION(Rovnomìr. 1.rok 20%)   CPOS(45, 7)
  TYPE(GET)      NAME(NROdalsi20)   FPOS(70, 8) FLEN( 5) FCAPTION(Rovnomìr. další 20%)   CPOS(45, 8)
  TYPE(GET)      NAME(NROzvcen20)   FPOS(70, 9) FLEN( 5) FCAPTION(Rovnomìr. zv.cena 20%) CPOS(45, 9)
  TYPE(GET)      NAME(nMesTZhod)    FPOS(70,10) FLEN( 5) FCAPTION(Tech.zhod. pro mìs.odpis) CPOS(45, 10) POST( postLastField_2)

TYPE(End)