TYPE(drgForm) DTYPE(10) TITLE(Školení a kurzy ...) SIZE(100,15) FILE(SKOLENIw) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:myIconBar,Menu:n)           ;
              POST(postValidate)

*  TYPE(Static) STYPE(12) SIZE(98.5,2) FPOS(0.75,0.25) RESIZE(y)
*    TYPE(TEXT) CAPTION(Pracovník . . .)           CPOS( 3, 0.5) CLEN(12)
*     TYPE(TEXT) NAME(Skoleni->cPracovnik)         CPOS(16, 0.5) CLEN(43)  BGND(13) PP(3) FONT(5)
*    TYPE(TEXT) CAPTION(Poøadí . . .)              CPOS(80, 0.5) CLEN( 9)
*     TYPE(TEXT) NAME(Skoleni->nPoradi)            CPOS(90, 0.5) CLEN( 3) BGND(13)  PP(3) FONT(5)
*  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(98,14.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2)
    TYPE(TEXT) CAPTION(Typ školení    ...)        CPOS( 2, 1) CLEN(18)
     TYPE(GET) NAME(SkoleniW->cZkratka)           FPOS(23, 1) FLEN(10)
     TYPE(TEXT) NAME(C_Skolen->cNazev)            CPOS(38, 1) CLEN(30) BGND(13) PP(3)


   TYPE(Static) STYPE( 2) CAPTION(Školení)  SIZE(93, 5.30) FPOS( 3, 2.5) RESIZE(y)
    TYPE(TEXT) CAPTION(Délka . . .)               CPOS( 3, 1) CLEN( 8)
     TYPE(GET) NAME(SkoleniW->nDelkaSkol)         FPOS(22, 1) FLEN( 5) PP(2)
     TYPE(GET) NAME(SkoleniW->cZkratJED2)         FPOS(28, 1) FLEN( 5)

    TYPE(TEXT) CAPTION(Termín poslední . . .)     CPOS(37, 1) CLEN(17)
     TYPE(GET) NAME(SkoleniW->dPoslSkole)         FPOS(57, 1) FLEN(11) PP(2) PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Splòující normy)           CPOS(77, 1) CLEN(14)

    TYPE(TEXT) CAPTION(Perioda opakování . . .)   CPOS( 3, 2.05) CLEN(19)
     TYPE(GET) NAME(SkoleniW->nPerioOpak)         FPOS(22, 2.05) FLEN( 5) PP(2)
     TYPE(GET) NAME(SkoleniW->cZkratJEDN)         FPOS(28.5, 2.05) FLEN( 3) PP(2)
    TYPE(TEXT) CAPTION(Termín následující . . .)  CPOS(37, 2.05) CLEN(20)
     TYPE(GET) NAME(SkoleniW->dDalsSkole)         FPOS(57, 2.05) FLEN(11) PP(2) PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(1.)                        CPOS(72, 2.05) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma1)            FPOS(75, 2.05) FLEN(15) PP(2)

    TYPE(TEXT) CAPTION(Zpùsob ukonèení . . .)     CPOS( 3, 3.10) CLEN(17)
     TYPE(GET) NAME(SkoleniW->cZkratkaUk)         FPOS(22, 3.10) FLEN(10)
     TYPE(TEXT) NAME(c_SkolUk->cNazev)            CPOS(33.5, 3.10) CLEN(30) PP(3) BGND(13)
    TYPE(TEXT) CAPTION(2.)                        CPOS(72, 3.10) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma2)            FPOS(75, 3.10) FLEN(15) PP(2)

    TYPE(TEXT) CAPTION(Èíslo prùkazu . . .)       CPOS( 3, 4.15) CLEN(15)
     TYPE(GET) NAME(SkoleniW->cCisPrukaz)         FPOS(22, 4.15) FLEN(20) PP(2)
    TYPE(TEXT) CAPTION(3.)                        CPOS(72, 4.15) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma3)            FPOS(75, 4.15) FLEN(15) PP(2)

   TYPE(End)

   TYPE(Static) STYPE( 2)  SIZE(93, 6) FPOS( 3, 7.85) RESIZE(y)

    TYPE(TEXT) CAPTION(Školitel . . .)          CPOS( 3, 1) CLEN(11)
     TYPE(GET) NAME(SkoleniW->cZkratSkol)       FPOS(14, 1) FLEN(10)
     TYPE(GET) NAME(SkoleniW->nCisFirmy)        FPOS(25.5, 1) FLEN( 7)
     TYPE(GET) NAME(SkoleniW->cNazevSkol)       FPOS(34, 1) FLEN(35) PP(2)

    TYPE(TEXT) CAPTION(Ulice . . .)             CPOS( 5, 2.05) CLEN( 8)
     TYPE(GET) NAME(SkoleniW->cUlice)           FPOS(14, 2.05) FLEN(25) PP(2)
    TYPE(TEXT) CAPTION(. . . Lektor . . .)      CPOS(69, 2.05) CLEN( 12)

    TYPE(TEXT) CAPTION(Místo . . .)             CPOS( 5, 3.10) CLEN( 8)
     TYPE(GET) NAME(SkoleniW->cMisto)           FPOS(14, 3.10) FLEN(25) PP(2)
     TYPE(GET) NAME(SkoleniW->cLektor)          FPOS(59, 3.10) FLEN(30) PP(2)

    TYPE(TEXT) CAPTION(PSÈ . . .)               CPOS( 5, 4.15)
     TYPE(GET) NAME(SkoleniW->cPSC)             FPOS(14, 4.15) FLEN( 8)
     TYPE(TEXT) NAME(c_Psc->cMisto)             CPOS(23.5, 4.15) CLEN(30) PP(3) BGND(13)

    TYPE(TEXT) CAPTION(Stát . . .)              CPOS( 5, 5.20) CLEN( 7)
     TYPE(GET) NAME(SkoleniW->cZkratStat)       FPOS(14, 5.20) FLEN( 5)
     TYPE(TEXT) NAME(C_Staty->cNazevStat)       CPOS(20.5, 5.20) CLEN(25) PP(3) BGND(13)
   TYPE(End)
  TYPE(End)