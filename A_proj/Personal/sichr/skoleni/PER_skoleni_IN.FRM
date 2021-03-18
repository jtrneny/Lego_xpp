TYPE(drgForm) DTYPE(10) TITLE(Školení a kurzy ...) SIZE(100,23) FILE(SKOLENIw) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:myIconBar,Menu:n)           ;
              POST(postValidate)


  TYPE(Static) STYPE(13) SIZE(98,7.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2)
    TYPE(TEXT) CAPTION(Typ školení    ...)        CPOS( 4, .5) CLEN(18)
     TYPE(GET) NAME(SkoleniW->cZkratka)           FPOS(25, .5) FLEN(10)
     TYPE(TEXT) NAME(C_Skolen->cNazev)            CPOS(38, .5) CLEN(34) BGND(12) PP(3)


   TYPE(Static) STYPE( 2) CAPTION(Školení)  SIZE(93, 5) FPOS( 3, 1.8) RESIZE(y)
     TYPE(TEXT) CAPTION(Délka . . .)              CPOS( 3, 1) CLEN( 8)
     TYPE(GET) NAME(SkoleniW->nDelkaSkol)         FPOS(22, 1) FLEN( 5) PP(2)
     TYPE(GET) NAME(SkoleniW->cZkratJED2)         FPOS(29, 1) FLEN( 5)

     TYPE(TEXT) CAPTION(Termín poslední ...)      CPOS(37, 1) CLEN(17)
     TYPE(GET) NAME(SkoleniW->dPoslSkole)         FPOS(57, 1) FLEN(11) PP(2) PUSH(CLICKDATE)

     TYPE(TEXT) CAPTION(Splòující normy)          CPOS(77, -.2) CLEN(14) FONT(5)

     TYPE(TEXT) CAPTION(Perioda opakování ...)    CPOS( 3, 2) CLEN(19)
     TYPE(GET) NAME(SkoleniW->nPerioOpak)         FPOS(22, 2) FLEN( 5) PP(2)
     TYPE(GET) NAME(SkoleniW->cZkratJEDN)         FPOS(29, 2) FLEN( 5) PP(2)

     TYPE(TEXT) CAPTION(Termín následující ...)   CPOS(37, 2) CLEN(20)
     TYPE(GET) NAME(SkoleniW->dDalsSkole)         FPOS(57, 2) FLEN(11) PP(2) PUSH(CLICKDATE)

     TYPE(TEXT) CAPTION(1.)                       CPOS(72, 1) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma1)            FPOS(75, 1) FLEN(15) PP(2)

     TYPE(TEXT) CAPTION(Zpùsob ukonèení ...)      CPOS( 3, 3) CLEN(17)
     TYPE(GET) NAME(SkoleniW->cZkratkaUk)         FPOS(22, 3) FLEN(10)
     TYPE(TEXT) NAME(c_SkolUk->cNazev)            CPOS(35, 3) CLEN(34) PP(3) BGND(12)

     TYPE(TEXT) CAPTION(2.)                       CPOS(72, 2) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma2)            FPOS(75, 2) FLEN(15) PP(2)

     TYPE(TEXT) CAPTION(Èíslo prùkazu ...)        CPOS( 3, 4) CLEN(15)
     TYPE(GET) NAME(SkoleniW->cCisPrukaz)         FPOS(22, 4) FLEN(20) PP(2)

     TYPE(TEXT) CAPTION(3.)                       CPOS(72, 3) CLEN( 3)
     TYPE(GET) NAME(SkoleniW->cNorma3)            FPOS(75, 3) FLEN(15) PP(2)
   TYPE(End)
TYPE(End)


   TYPE(TabPage) FPOS(.5,8) SIZE(99,14.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT()
     TYPE(Static) STYPE( 2) SIZE(97, 6.2) FPOS( 1, .5) RESIZE(y)
       TYPE(TEXT) CAPTION(Školitel ...)           CPOS( 3,  .8) CLEN(11)
       TYPE(GET) NAME(SkoleniW->cZkratSkol)       FPOS(14,  .8) FLEN(10)
       TYPE(GET) NAME(SkoleniW->nCisFirmy)        FPOS(26,  .8) FLEN( 7)
       TYPE(GET) NAME(SkoleniW->cNazevSkol)       FPOS(35,  .8) FLEN(35) PP(2)

       TYPE(TEXT) CAPTION(Ulice ...)              CPOS( 5, 1.8) CLEN( 8)
       TYPE(GET) NAME(SkoleniW->cUlice)           FPOS(14, 1.8) FLEN(25) PP(2)
       TYPE(TEXT) CAPTION(. . . Lektor . . .)     CPOS(69, 3.8) CLEN( 12) FONT(5)

       TYPE(TEXT) CAPTION(Místo ...)              CPOS( 5, 2.8) CLEN( 8)
       TYPE(GET) NAME(SkoleniW->cMisto)           FPOS(14, 2.8) FLEN(25) PP(2)

       TYPE(GET) NAME(SkoleniW->cLektor)          FPOS(59, 4.9) FLEN(30) PP(2)
 
       TYPE(TEXT) CAPTION(PSÈ ...)                CPOS( 5, 3.8)
       TYPE(GET) NAME(SkoleniW->cPSC)             FPOS(14, 3.8) FLEN( 8)
       TYPE(TEXT) NAME(c_Psc->cMisto)             CPOS(24, 3.8) CLEN(30) PP(3) BGND(12)

       TYPE(TEXT) CAPTION(Stát ...)               CPOS( 5, 4.9) CLEN( 8)
       TYPE(GET) NAME(SkoleniW->cZkratStat)       FPOS(14, 4.9) FLEN( 8)
       TYPE(TEXT) NAME(C_Staty->cNazevStat)       CPOS(24, 4.9) CLEN(30) PP(3) BGND(12)
     TYPE(End)

     TYPE(MLE) NAME('SkoleniW->mpoznamka')        FPOS(.5,7.5) SIZE(98,5.5) RESIZE(yx) SCROLL(ny)

  TYPE(End)


  TYPE(TabPage) FPOS(.5,8) SIZE(99,14.5) TTYPE(3) OFFSET( 10.5,79) CAPTION(položky) PRE(tabSelect) EXT()

    TYPE(Static) FPOS(0,0) SIZE(99,13.6) STYPE(9) CTYPE(3) RESIZE(y)

      TYPE(DBrowse) FPOS(-1,4.8) SIZE(100,9) FILE(vazOsobyW)                             ;
                                 FIELDS( vazOsobyW->ncisOsoby:èíslOsoby                , ;
                                         vazOsobyW->cjmenoRozl:Pøímení a jméno osoby:30, ;
                                         vazOsobyW->ctypRodPri:typVztahu               , ;
                                         vazOsobyW->cjmenoOsob:rozen(á)                , ;
                                         vazOsobyW->crodCisOsb:rodÈíslo                , ;
                                         vazOsobyW->ddatNaroz:datNaroz                 , ;   
                                         vazOsobyW->CMISTO:Mìsto:25                    , ;
                                         vazOsobyW->CZKRATSTAT:Stát                      ) ;
                                 CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(6) RESIZE(yy)


    TYPE(Static) STYPE(13) SIZE(97,4.2) FPOS(1,0.2) RESIZE(yn)

      TYPE(TEXT) CAPTION(Èíslo osoby )          CPOS( 1,  .5) CLEN(10)
      TYPE(GET)  NAME(osoby->ncisOsoby)         FPOS(12,  .5) FLEN( 9) PUSH(per_osoby_sel) NOREVISION()
      TYPE(TEXT) NAME(M->tit_a_jmenoRozl)       CPOS(23,  .5) CLEN(30) FONT(5) BGND(12)
      TYPE(TEXT) CAPTION(datum narození)        CPOS(55,  .5) CLEN(12)
      TYPE(TEXT) NAME(osoby->ddatNaroz)         CPOS(68,  .5) CLEN(10) FONT(5) BGND(12) 
      TYPE(TEXT) CAPTION(rè)                    CPOS(78.2,  .5) CLEN( 3)
      TYPE(TEXT) NAME(osoby->crodCisOsb)        CPOS(81,  .5) CLEN(15) FONT(5) BGND(12)

      TYPE(TEXT) NAME(M->nazKlasZa)             CPOS(23, 1.5) CLEN(30) FONT(5) BGND(12)
      TYPE(TEXT) NAME(M->nazVzdela)             CPOS(68, 1.5) CLEN(28) FONT(5) BGND(12)

      TYPE(TEXT) CAPTION(Termín školení od ...) CPOS( 1, 3  ) CLEN(20)
      TYPE(GET)  NAME(osoby->ddatNaroz)         FPOS(23, 3  ) FLEN(12) FONT(5) BGND(12) PUSH(CLICKDATE)
      TYPE(TEXT) CAPTION(do)                    CPOS(36.5, 3  ) CLEN( 3)
      TYPE(GET)  NAME(osoby->ddatNaroz)         FPOS(40, 3  ) FLEN(12) FONT(5) BGND(12) PUSH(CLICKDATE)     

    TYPE(End)

  TYPE(END)