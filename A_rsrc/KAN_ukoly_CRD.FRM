TYPE(drgForm) DTYPE(10) TITLE(Úkoly ...) SIZE(100,24) FILE(UKOLYW) ;
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n)        ;
              POST(postValidate)

  TYPE(Static) STYPE(13) SIZE(98,23.5) FPOS(1,0.1) RESIZE(yn)

    TYPE(TEXT) CAPTION(Èíslo úkolu)     CPOS( 1, 0.3) CLEN( 10)
    TYPE(TEXT) NAME(ncisUkolu)          CPOS(11, 0.3) CLEN( 10) BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Datum vzniku)    CPOS(72, 0.3)
    TYPE(TEXT) NAME(dDatPoriz)          CPOS(85, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

*    coznUkolu)          FPOS(18, 1.3) FLEN( 12) FCAPTION(Oznaèení úkolu)     CPOS( 1, 1.3)

*
    TYPE(Static) STYPE(14) SIZE(96,2.9) FPOS(1,1.8) RESIZE(yn)
      TYPE(GET)  NAME(czkrUkolu)          FPOS(1, 1.3) FLEN( 12) FCAPTION(Typ úkolu)           CPOS( 1, 0.2)
      TYPE(GET)  NAME(cnazUkolu)          FPOS(18, 1.3) FLEN( 55) FCAPTION(Název úkolu)        CPOS( 18, 0.2)
*      TYPE(TEXT) NAME(c_ukoly->cnazUkolu) CPOS(32, 0.3)
      TYPE(GET)  NAME(coznUkolu)          FPOS(80, 1.3) FLEN( 12) FCAPTION(Interní ozn.úkolu)   CPOS( 80, 0.2)
       
    TYPE(End)      
* 

    TYPE(GET)  NAME(cJmeRozlRe)         FPOS(19, 5.3) FLEN( 55) PUSH(osb_osoby_sel) FCAPTION(Øešitel)  CPOS( 1, 5.3) 
    TYPE(GET)  NAME(nCisOsoRes)         FPOS(81, 5.3) FLEN( 11)                

    TYPE(GET)  NAME(dplzacUkol)         FPOS(19, 7.3) FLEN( 11) FCAPTION(Pøedpokládaný zaèátek)       CPOS( 1, 7.3) PUSH(clickdate)
    TYPE(GET)  NAME(cplzacUkol)         FPOS(33, 7.3) FLEN(  8) FCAPTION(-)       CPOS( 31, 7.3)  CLEN( 1)
    TYPE(GET)  NAME(dplkonUkol)         FPOS(62, 7.3) FLEN( 11) FCAPTION(plán ukonèení)               CPOS(47, 7.3) PUSH(clickdate)
    TYPE(GET)  NAME(cplkonUkol)         FPOS(76, 7.3) FLEN(  8) FCAPTION(-)       CPOS( 75, 7.3)       
    TYPE(GET)  NAME(dzacUkolu)          FPOS(19, 8.3) FLEN( 11) FCAPTION(Zahájení úkolu)              CPOS( 1, 8.3) PUSH(clickdate)
    TYPE(GET)  NAME(czacUkolu)          FPOS(33, 8.3) FLEN(  8) FCAPTION(-)       CPOS( 31, 8.3)  CLEN( 1)
    TYPE(GET)  NAME(dkonUkolu)          FPOS(62, 8.3) FLEN( 11) FCAPTION(ukonèení úkolu)              CPOS(47, 8.3) PUSH(clickdate)
    TYPE(GET)  NAME(ckonUkolu)          FPOS(76, 8.3) FLEN(  8) FCAPTION(-)       CPOS( 75, 8.3)       

    TYPE(GET)  NAME(czkrStaRes)         FPOS(19, 9.8) FLEN( 11) FCAPTION(Stav øešení)        CPOS( 1,  9.8)
    TYPE(GET)  NAME(NPRIORITA)          FPOS(47, 9.8) FLEN( 10) FCAPTION(Priorita)           CPOS( 37, 9.8)
    TYPE(SpinButton) NAME(nProcPlnen)   FPOS(76, 9.8) FLEN(  8) FCAPTION(Hotovo v %) CPOS(62, 9.8) LIMITS(1,999)
*
    TYPE(Static) STYPE(14) SIZE(96,1.9) FPOS(1,11.1) RESIZE(yn)
      TYPE(GET)      NAME(dPripoUkol)       FPOS(18, 0.4) FLEN( 11) FCAPTION(Dat.a èas pøipomenutí)    CPOS( 0, 0.4) PUSH(clickdate)
      TYPE(GET)      NAME(cPripoUkol)       FPOS(32, 0.4) FLEN(  8) FCAPTION(-)              CPOS(31, 0.4) 
      TYPE(CHECKBOX) NAME(lPripomen)        FPOS(56, 0.4) FLEN(  4) FCAPTION(Pøipomenout)    CPOS(46, 0.4) CLEN(10) VALUES(T: ,F: )
      TYPE(CHECKBOX) NAME(lSyncOutlo)       FPOS(74, 0.4) FLEN(  4) FCAPTION(SynchrOutlook)  CPOS(61, 0.4) CLEN(11) VALUES(T: ,F: ) 
    TYPE(End)      
*

    TYPE(GET)  NAME(nPlanCas)          FPOS(19, 13.3) FLEN( 11) FCAPTION(Plánovaný èas)       CPOS( 1,  13.3)
    TYPE(GET)  NAME(cZkratJedn)        FPOS(33, 13.3) FLEN(  8) FCAPTION(-)                   CPOS( 31, 13.3)   CLEN( 1)    
    TYPE(GET)  NAME(nSkutCas)          FPOS(62, 13.3) FLEN( 11) FCAPTION(Skuteèný èas)        CPOS( 47, 13.3)
    TYPE(GET)  NAME(cZkratJedn)        FPOS(76, 13.3) FLEN(  8) FCAPTION(-)                   CPOS( 75, 13.3)   CLEN( 1)    

    TYPE(GET)  NAME(cKatUkolu)         FPOS(19,14.5) FLEN( 11) FCAPTION(Kategorie úkolu)      CPOS( 1,  14.5)
     TYPE(TEXT) NAME(c_katukl->CNAZKAT) CPOS(31, 14.5)


    TYPE(MLE) NAME('ukolyW->mpopisUkol') FPOS( .5,15.7) SIZE(96,7.5) RESIZE(yx) SCROLL(ny)

    TYPE(TEXT) NAME(cJmenoRozl)          CPOS(24, 0.3) CLEN( 40) BGND(13) PP(2) CTYPE(2) 
*    TYPE(TEXT) NAME(nCisOsoby)          CPOS(85, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)
*    TYPE(GET)  NAME(cJmeRozlRe)         FPOS(19, 5.3) FLEN( 55) FCAPTION(Øešitel)  CPOS( 1, 5.3) 
*    TYPE(GET)  NAME(nCisOsoRes)         FPOS(81, 5.3) FLEN( 11)                

  TYPE(End)