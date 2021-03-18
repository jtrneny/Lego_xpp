TYPE(drgForm) DTYPE(10) TITLE(Návrh na realizaci personálních akcí ...) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()                                    ;
              BORDER(2) POST(postValidate)


TYPE(Action) CAPTION(~plán_perAkcí) EVENT(PER_pershead_IN)   TIPTEXT(Návrh plánu personálních akcí ...)


 TYPE(STATIC) STYPE(2) FPOS(1,-0.25) SIZE(82.05,1.25) RESIZE(yn)
    TYPE(TEXT) CAPTION(Datum návrhu OD : )        CPOS(  9, .5) CLEN(16)  FONT(1) 
    TYPE(GET) NAME(M->ddatNAV_od)                 FPOS( 26, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION( __ do __ )                CPOS( 41, .5) CLEN( 7)  FONT(1) 
    TYPE(GET) NAME(M->ddatNAV_do)                 FPOS( 51, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE) 
  TYPE(END)


TYPE(TabPage) CAPTION( v Rozsahu zadání) FPOS(0, 1.5) SIZE(110,23) RESIZE(yx) TTYPE(3) OFFSET(1,81) PRE(tabSelect)
  TYPE(DBrowse) FPOS(0,0) SIZE(110,21.5) FILE(PERSITEMw)   ;
                                         FIELDS( ctypAkce:typAkce                         , ; 
                                                 dDatPREDko:datKonání:10                  , ;
                                                 cZkratka                                 , ;
                                                 nperioOpak:perOpak                       , ;
                                                 czkratJedn:za                            , ;
                                                 cPracovnik::30                           , ;
                                                 czkratk_LS:zkr_LékŠk                     , ;
                                                 dDatUskuKo                               , ;
                                                 dDatUkonce                                 ) ;
                                          CURSORMODE(3) INDEXORD(1) PP(7) POPUPMENU(y) 
* ITEMMARKED(itemMarked)
TYPE(END)



TYPE(TabPage) CAPTION( dle persAkcí) FPOS(0, 1.5) SIZE(110,23) RESIZE(yx) TTYPE(3) OFFSET(19,63) PRE(tabSelect)
  TYPE(DBrowse) FPOS(0,0) SIZE(110,9.5) FILE(c_persAKCw)   ;
                                        FIELDS( ctypAkce:typAkce:12  , ;
                                                czkratka:zkrAkce:15  , ;
                                                cnazev:název akce:65 , ;
                                                ndelka:poèPrac:10      ) ;
                                        CURSORMODE(3) INDEXORD(1) PP(7) ITEMMARKED(itemMarked)

* spodek
  TYPE(DBrowse) FPOS(0,10) SIZE(110,11.5) FILE(PERSITEMw)   ;
                                          FIELDS( ctypAkce:typAkce                         , ; 
                                                 dDatPREDko:datKonání:10                  , ;
                                                 cZkratka                                 , ;
                                                 nperioOpak:perOpak                       , ;
                                                 czkratJedn:za                            , ;
                                                 cPracovnik::30                           , ;
                                                 czkratk_LS:zkr_LékŠk                     , ;
                                                 dDatUskuKo                               , ;
                                                 dDatUkonce                                 ) ;
                                          CURSORMODE(3) INDEXORD(1) PP(7) 

TYPE(END)


* TYPE(STATIC) STYPE(12) CAPTION(Údaje o návrhu plánu personální akce) FPOS(1,17.5)  SIZE(98,7.2) RESIZE(YX) CTYPE(2)
*    TYPE(TEXT) CAPTION(Ukonèení . . .)          CPOS( 3, 2)      CLEN(11)
*     TYPE(TEXT) NAME(PersItem ->cZkratkaUk)     CPOS(17, 2)      CLEN( 8)  BGND(13) PP(2)
*    TYPE(TEXT) CAPTION(. . . Provedl . . .)     CPOS(43, 2)
*
*    TYPE(TEXT) CAPTION(Délka . . .)             CPOS( 3, 3.05)   CLEN( 8)
*     TYPE(TEXT) NAME(PersItem ->nDelka)         CPOS(17, 3.05)   CLEN( 5)  BGND(13) PP(2)
*     TYPE(TEXT) NAME(PersItem ->cZkrat)         CPOS(23, 3.05)   CLEN(10)  BGND(13) PP(2)
*     TYPE(TEXT) NAME(PersItem ->cNazev)         CPOS(34, 3.05)   CLEN(35)  BGND(13) PP(2)
*
*    TYPE(TEXT) CAPTION(Èíslo faktur . . .)      CPOS( 3, 4.15)   CLEN(14)
*     TYPE(TEXT) NAME(PersItem ->nCisFak)        CPOS(17, 4.15)   CLEN(10)  BGND(13) PP(2)
*     TYPE(TEXT) NAME(PersItem ->cUlice)         CPOS(28, 4.15)   CLEN(25)  BGND(13) PP(2)
*
*     TYPE(TEXT) NAME(PersItem ->cPSC)           CPOS(28, 5.20)   CLEN( 6)  BGND(13) PP(2)
*     TYPE(TEXT) NAME(PersItem ->cMisto)         CPOS(35, 5.20)   CLEN(25)  BGND(13) PP(2)
*
*    TYPE(TEXT) CAPTION(Poznámka . . .)          CPOS( 3, 6.25)   CLEN(11)
*     TYPE(TEXT) NAME(PersItem ->mPoznamka)      CPOS(17, 6.25)   CLEN(10)  BGND(13) PP(2)
*
*    TYPE(TEXT) CAPTION(Odpovìdná osoba . . .)   CPOS(45, 7.30)   CLEN(17)
*     TYPE(TEXT) NAME(PersItem ->cProvedlOs)     CPOS(63, 7.30)   CLEN(30)  BGND(13) PP(2)
* TYPE(END)