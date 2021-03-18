TYPE(drgForm) DTYPE(10) TITLE(Personální údaje osob a zamìstnancù ...) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_kmenmsos_CRD)

* TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
* TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(DBrowse) FPOS(0.1,0.5) SIZE(98.75,12) FILE(PERSONAL) INDEXORD(1)         ;
              FIELDS( cprijPrac  , ;
                      cjmenoPrac , ;
                      culice     , ;
                      nosCisPrac:osÈíslo     , ;
                      nosCisPrac:cRodCisOsb  , ;
                      ddatVznPrV:datVzn_Pv   , ;
                      dDatVyst:datUkoè_Pv    , ;
                      cZkrVzdel:vzdìl        )  ;
              CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


TYPE(STATIC) STYPE( 2) FPOS(0.50,12.85) CAPTION(Personální údaje o zamìstnanci) SIZE(98.75,11.40) RESIZE(YX)
    TYPE(TEXT) CAPTION(Rozen(á) . . .)          CPOS( 3, 2)      CLEN(11)
     TYPE(TEXT) NAME(Personal ->cJmenoRod)      CPOS(20, 2)      CLEN(25)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Bydlištì . . .)          CPOS(52, 2)      CLEN(11)
     TYPE(TEXT) NAME(Personal ->cUlice)         CPOS(64, 2)      CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Datum narození . . .)    CPOS( 3, 3.05)   CLEN(16)
     TYPE(TEXT) NAME(Personal ->dDatNaroz)      CPOS(20, 3.05)   CLEN(10)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Personal ->cPSC)           CPOS(64, 3.05)   CLEN( 6)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Personal ->cMisto)         CPOS(71, 3.05)   CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Místo narození . . .)    CPOS( 3, 4.10)   CLEN(16)
     TYPE(TEXT) NAME(Personal ->cMistoNar)      CPOS(20, 4.10)   CLEN(30)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Stát . . .)              CPOS(52, 4.10)   CLEN( 7)
     TYPE(TEXT) NAME(Personal ->cZkratStat)     CPOS(64, 4.10)   CLEN( 4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Stát narození . . .)     CPOS( 3, 5.15)   CLEN(15)
     TYPE(TEXT) NAME(Personal ->cZkrStatNa)     CPOS(20, 5.15)   CLEN( 4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Národnost . . .)         CPOS( 3, 6.20)   CLEN(12)
     TYPE(TEXT) NAME(Personal ->cZkratNar)      CPOS(20, 6.20)   CLEN(15)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Stát. pøísluš. . . .)    CPOS( 3, 7.25)   CLEN(16)
     TYPE(TEXT) NAME(Personal ->cZkrStaPri)     CPOS(20, 7.25)   CLEN(25)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Telefon privát . . .)    CPOS(52, 7.25)   CLEN(16)
     TYPE(TEXT) NAME(Personal ->cTelPriv)       CPOS(68, 7.25)   CLEN(15)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Telefon zam. . . .)      CPOS(52, 8.30)   CLEN(14)
     TYPE(TEXT) NAME(Personal ->cTelZames)      CPOS(68, 8.30)   CLEN(15)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodinný stav . . .)      CPOS( 3, 9.35)   CLEN(14)
     TYPE(TEXT) NAME(Personal ->cZkrRodStv)     CPOS(20, 9.35)   CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Èíslo OP . . .)          CPOS(52, 9.35)   CLEN(10)
     TYPE(TEXT) NAME(Personal ->cCisloOP)       CPOS(68, 9.35)   CLEN(15)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Dosažené vzdì. . . .)    CPOS( 3,10.40)   CLEN(16)
     TYPE(TEXT) NAME(Personal ->cZkrVzdel)      CPOS(20,10.40)   CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Èíslo pasu . . .)        CPOS(52,10.40)   CLEN(12)
     TYPE(TEXT) NAME(Personal ->cCisloPasu)     CPOS(68,10.40)   CLEN(15)  BGND(13) PP(2)

TYPE(END)