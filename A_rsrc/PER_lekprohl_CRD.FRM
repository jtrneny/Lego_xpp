TYPE(drgForm) DTYPE(10) TITLE(Lékaøské prohlídky) SIZE(80,15) FILE(LEKPROHLW) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:myIconBar,Menu:n)          ;
              POST(postValidate)


*  TYPE(Static) STYPE(12) SIZE(98.5,2) FPOS(0.75,0.25) RESIZE(y)
*    TYPE(TEXT) CAPTION(Pracovník . . .)         CPOS( 3, 0.5) CLEN(12)
*     TYPE(TEXT) NAME(LekProhl->cPracovnik)      CPOS(15, 0.5) CLEN(43) PP(3) FONT(5) BGND(13)
*    TYPE(TEXT) CAPTION(Poøadí . . .)            CPOS(80, 0.5) CLEN( 9)
*     TYPE(TEXT) NAME(LekProhl->nPoradi)         CPOS(90, 0.5) CLEN( 3) PP(3) FONT(5) BGND(13)
*  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(78,14.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2)
    TYPE(TEXT) CAPTION(Typ lékaøské prohlídky    ...)  CPOS( 2, 1) CLEN(18) 
     TYPE(GET) NAME(LekProhlW->cZkratka)               FPOS(23, 1) FLEN(11)
     TYPE(TEXT) NAME(c_LekPro->cNazev)                 CPOS(38, 1) CLEN(30) BGND(13) PP(3)

     TYPE(Static) STYPE( 2) CAPTION(Lékaøská prohlídka)  SIZE(76, 3.3) FPOS( 1, 2.5) RESIZE(y)
      TYPE(TEXT) CAPTION(Prohlídka dne           ...)    CPOS( 3, 1) CLEN(18)
       TYPE(GET) NAME(LekProhlW->dPoslLekPr)             FPOS(22, 1) FLEN(11) PP(2) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Perioda opakování   ...)        CPOS( 3, 2) CLEN(18)
       TYPE(GET) NAME(LekProhlW->nPerioOpak)             FPOS(22, 2) FLEN( 5) PP(2)
       TYPE(GET) NAME(LekProhlW->cZkratJEDN)             FPOS(28, 2) FLEN( 5)

      TYPE(TEXT) CAPTION(další lékaøská prohlídka)       CPOS(37, 2) CLEN(18)
       TYPE(GET) NAME(LekProhlW->dDalsLekPr)             FPOS(56, 2) FLEN(11) PP(2) PUSH(CLICKDATE)
     TYPE(End) 

     TYPE(Static) STYPE( 2)  SIZE(76, 8) FPOS( 1, 6) RESIZE(y)
      TYPE(TEXT) CAPTION(Ošetøující lékaø        ...)      CPOS( 3, 1) CLEN(18)
       TYPE(GET) NAME(LekProhlW->cZkratLeka)               FPOS(21, 1) FLEN(10)
       TYPE(TEXT) NAME(LekProhlW->cNazevLeka)              CPOS(32.5, 1) CLEN(30) BGND(13) PP(3)
  
      TYPE(TEXT) CAPTION(Odbornost              ...)       CPOS( 3, 2) CLEN(18)
       TYPE(GET) NAME(LekProhlW->cOdbornLek)               FPOS(21, 2.05) FLEN(30) PP(2)

      TYPE(TEXT) CAPTION(. . . Ordinace . . .)    CPOS( 3, 4) CLEN(14)

      TYPE(TEXT) CAPTION(Ulice . . .)             CPOS( 9, 5.05) CLEN( 8)
       TYPE(GET) NAME(LekProhlW->cUlice)          FPOS(18, 5.05) FLEN(25) PP(2)

      TYPE(TEXT) CAPTION(Místo . . .)             CPOS( 9, 6.10) CLEN( 8)
       TYPE(GET) NAME(LekProhlW->cMisto)          FPOS(18, 6.10) FLEN(25) PP(2)

      TYPE(TEXT) CAPTION(PSÈ   . . .)             CPOS( 9, 7.15) CLEN( 8)
       TYPE(GET) NAME(LekProhlW->cPsc)            FPOS(18, 7.15) FLEN( 8)
       TYPE(TEXT) NAME(c_Psc->cMisto)             CPOS(27.5, 7.15) CLEN(40) BGND(13) PP(3)
     TYPE(End)
  TYPE(End)