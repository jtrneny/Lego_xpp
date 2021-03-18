TYPE(drgForm) DTYPE(10) TITLE(Dokument) SIZE(80,15) FILE(UKOLYW) ;
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n)       ;
              POST(postValidate)

  TYPE(Static) STYPE(13) SIZE(78,14.5) FPOS(1,0.1) RESIZE(yn)

    TYPE(TEXT) CAPTION(Èíslo úkolu)     CPOS( 1, 0.3)
    TYPE(TEXT) NAME(ncisUkolu)          CPOS(18, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

*    TYPE(GET)  NAME(coznUkolu)          FPOS(18, 1.3) FLEN( 12) FCAPTION(Oznaèení úkolu)     CPOS( 1, 1.3)

    TYPE(GET)  NAME(czkrUkolu)          FPOS(18, 1.3) FLEN( 12) FCAPTION(Zkratka úkolu)      CPOS( 1, 1.3)
    TYPE(TEXT) NAME(c_ukoly->cnazUkolu) CPOS(32, 1.3) 

    TYPE(GET)  NAME(cnazUkolu)          FPOS(18, 2.3) FLEN( 50) FCAPTION(Název úkolu)        CPOS( 1, 2.3)

    TYPE(GET)  NAME(czkrStaRes)         FPOS(18, 3.3) FLEN( 12) FCAPTION(Stav øešení)        CPOS( 1, 3.3)

    TYPE(GET)  NAME(dplzacUkol)         FPOS(18, 4.3) FLEN( 12) FCAPTION(Plán zaèátku)       CPOS( 1, 4.3) PUSH(clickdate)
    TYPE(GET)  NAME(dplkonUkol)         FPOS(52, 4.3) FLEN( 12) FCAPTION(plán ukonèení)      CPOS(35, 4.3) PUSH(clickdate)

    TYPE(GET)  NAME(dzacUkolu)          FPOS(18, 5.3) FLEN( 12) FCAPTION(Datum zaèátku)      CPOS( 1, 5.3) PUSH(clickdate)
    TYPE(GET)  NAME(dkonUkolu)          FPOS(52, 5.3) FLEN( 12) FCAPTION(ukonèen dne)        CPOS(35, 5.3) PUSH(clickdate)

*
    TYPE(Static) STYPE(14) SIZE(76,1.9) FPOS(1,6.8) RESIZE(yn)
      TYPE(GET)  NAME(dPripoUkol)          FPOS(18, 0.4) FLEN( 12) FCAPTION(Dat.pøipomenutí)    CPOS( 1, 0.4) PUSH(clickdate)
      TYPE(GET)  NAME(cPripoUkol)          FPOS(52, 0.4) FLEN( 10) FCAPTION(Èas pøipomenutí)    CPOS(35, 0.4) 
    TYPE(End)      
*
    TYPE(MLE) NAME('ukolyW->mpopisUkol') FPOS( .5,9.7) SIZE(76,4.5) RESIZE(yx) SCROLL(ny)
  TYPE(End)