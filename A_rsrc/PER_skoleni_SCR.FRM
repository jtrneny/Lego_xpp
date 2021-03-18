TYPE(drgForm) DTYPE(10) TITLE(Školení a kurzy (personalistika) ) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_osoby_CRD)


* CARGO(PER_skoleni_IN)
* CARGO(PER_skoleni_CRD)


TYPE(DBrowse) FPOS(0,0) SIZE(99,10.2) FILE(OSOBY) ;
                                          FIELDS(M->is_inPersonal:per:2.6::2                   , ;
                                                 M->is_inMsPrc_mo:zam:2.6::2                   , ;
                                                 ncisOsoby:èíslOsoby                           , ;
                                                 cjmenoRozl:Pøíjmení_jméno a rozlišení osoby:35, ;
                                                 cUlicCiPop:Ulice a èp:10                      , ;
                                                 CMISTO:Mìsto:25                               , ;
                                                 CZKRATSTAT:Stát                               , ;
                                                 cosoba:Osoba                                  , ;  
                                                 nosCisPrac:èísloPrac                          , ;
                                                 CTELEFON:Telefon:15                           , ;
                                                 CEMAIL:Email:30                                 ) ;
                                          CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(yy) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)



TYPE(DBrowse) FPOS(0,10.5) SIZE(99,7) FILE(Skoleni) INDEXORD(1)                     ;
                                      FIELDS( nPoradi:poøŠk                       , ;
                                              cZkratka:typŠk                      , ;
                                              M->nazSkolen:název školení/ kurzu:40, ; 
                                              nperioOpak:perOpakŠk                , ;
                                              czkratJedn:za                       , ;
                                              clektor:školení/ kurz vedl          , ;
                                              dposlSkole:dne                      , ;
                                              ddalsSkole:dalšíŠk                    ) ;
                                       CURSORMODE(3) PP(7) 


* TYPE(DBrowse) FPOS(0,10.5) SIZE(99,7) FILE(vazSkol)                                                ;
*                                      FIELDS(M->is_inMsPrc_mo:zam:2.6::2                         , ;
*                                             vazSkol_osoby('ncisOsoby'):èíslOsoby                , ;
*                                             vazSkol_osoby('nosCisPrac'):èísloPrac               , ;
*                                             vazSkol_osoby('cjmenoRozl'):Pøímení a jméno osoby:35, ;
*                                             vazSkol_osoby('CMISTO'):Mìsto:25                    , ;
*                                             vazSkol_osoby('CZKRATSTAT'):Stát                    , ;
*                                             vazSkol_osoby('CTELEFON'):Telefon:15                , ;
*                                             vazSkol_osoby('CEMAIL'):Email:30                      ) ;
*                                      CURSORMODE(3) INDEXORD(9) PP(7) RESIZE(x) SCROLL(yy) PRE(SetFocus)


TYPE(STATIC) STYPE( 2) CAPTION(Údaje o školení/ kurzech pracovníka) FPOS(1,17.5)  SIZE(98,7.2) RESIZE(YX)
    TYPE(TEXT) CAPTION(Ukonèení        ...)     CPOS( 3, 1.5)   CLEN(15)
     TYPE(TEXT) NAME(Skoleni ->cZkratkaUk)      CPOS(18, 1.5)   CLEN( 8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_SkolUk ->cNazev)         CPOS(27, 1.5)   CLEN(35)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Délka školení  ...)      CPOS( 3, 2.6)   CLEN(15)
     TYPE(TEXT) NAME(Skoleni ->nDelkaSkol)      CPOS(18, 2.6)   CLEN( 8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Skoleni ->cZkratJED2)      CPOS(27, 2.6)   CLEN( 4)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Skoleni ->cZkratSkol)      CPOS(32, 2.6)   CLEN(10)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(. . . Školitel . . .)    CPOS(69, 2.6)   CLEN(13)  FONT(5)

    TYPE(TEXT) CAPTION(Èíslo prùkazu  ...)      CPOS( 3, 3.7)   CLEN(15)
     TYPE(TEXT) NAME(Skoleni ->cCisPrukaz)      CPOS(18, 3.7)   CLEN(20)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Skoleni ->cNazevSkol)      CPOS(60, 3.7)   CLEN(35)  BGND(13) PP(2)

     TYPE(TEXT) NAME(Skoleni ->cUlice)          CPOS(60, 5.15)   CLEN(25)  BGND(13) PP(2)


    TYPE(TEXT) CAPTION(Lektor            ...)   CPOS( 3, 6.20)   CLEN(15)
     TYPE(TEXT) NAME(Skoleni ->cLektor)         CPOS(18, 6.20)   CLEN(30)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Skoleni ->cPSC)            CPOS(60, 6.20)   CLEN( 6)  BGND(13) PP(2)
     TYPE(TEXT) NAME(Skoleni ->cMisto)          CPOS(66.5,6.20)  CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Poznámka . . .)          CPOS( 3, 7.25)   CLEN(11)
*     TYPE(TEXT) NAME(Skoleni ->mPoznamka)       CPOS(18, 7.25)   CLEN(10)  BGND(13) PP(2)
TYPE(END)