TYPE(drgForm) DTYPE(10) TITLE(Seznam akcionáøù - VÝBÌR) FILE(AKCIONAR_s) ;
                                                        SIZE(60,24)      ;  
                                                        GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
                                                        CARGO()

TYPE(Action) CAPTION(~Nový_Akc )    EVENT(akc_akcionar_novy)   TIPTEXT(Založení nového akcionáøe do seznamu ...)
TYPE(Action) CAPTION(~Oprava_Akc )  EVENT(akc_akcionar_oprava) TIPTEXT(Oprava údajù akcionáøe ...)


  TYPE(DBrowse) FPOS(0.5,1.1) SIZE(59,14.5) FILE(AKCIONAR_s)                         ;
                                           FIELDS( cjmenoAkci:jméno akcionáøe:35 , ;
                                                   cRodCisAkc:rodnéÈíslo         , ;
                                                   culice:ulice:30               , ;
                                                   cmisto:místo:30               , ;
                                                   cpsc:psè                      , ;
                                                   npocetAkci:poètAkcií          , ;
                                                   nhodnotaAk:hodnota            , ;
                                                   npocetHlas:poèHlasù             ) ;
                                                   CURSORMODE(3) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)


  TYPE(Static) SIZE(59,7.6) FPOS(0.5,15.7) RESIZE(y) STYPE(12) CTYPE(2) 
*    TYPE(STATIC) FPOS(50.1,0.1) SIZE(56.9,8) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(Adresa )                 CPOS( 5,0.5) CLEN(11)                 FONT(2) 
        TYPE(TEXT) NAME(akcionar_S->culice)         CPOS(18,0.5) CLEN(30)       BGND(13)
        TYPE(TEXT) NAME(akcionar_S->cmisto)         CPOS(18,1.5) CLEN(30)       BGND(13)
        TYPE(TEXT) NAME(akcionar_S->cpsc)           CPOS(18,2.5) CLEN( 6)       BGND(13) 
        TYPE(TEXT) NAME(c_psc->cmisto)            CPOS(25,2.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(Telefon)                 CPOS( 5,3.5) CLEN(11)                 FONT(2) 
        TYPE(TEXT) NAME(akcionar_S->cdomTel)        CPOS(18,3.5) CLEN(15)       BGND(13)
        TYPE(TEXT) NAME(akcionar_S->ctelefon)       CPOS(38,3.5) CLEN(15)       BGND(13)
*
*
      TYPE(TEXT) CAPTION(výmìraHa)                CPOS(  8, 4.9)  
      TYPE(TEXT) CAPTION(poèetAkcí)               CPOS( 19, 4.9)
      TYPE(TEXT) CAPTION(hodnotaAkcí)             CPOS( 34, 4.9) CLEN(10)
      TYPE(TEXT) CAPTION(poèetHlasù)              CPOS( 45, 4.9) CLEN( 9)

      TYPE(STATIC) FPOS( 5, 5.4) SIZE(51, 1.7) STYPE(9) RESIZE(nx) CTYPE(5)
        TYPE(TEXT) NAME(akcionar_S->nvymeraHa)      CPOS(  1, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar_S->npocetAkci)     CPOS( 15, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar_S->nhodnotaAk)     CPOS( 27, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar_S->npocetHlas)     CPOS( 42, .5) CLEN(13) FONT(5)
      TYPE(END)
*    TYPE(End) 
  TYPE(End)

* quickFilr
  TYPE(Static) STYPE(13) SIZE( 59.7,1.1) FPOS( .2, .02) RESIZE(nn) CTYPE(2)
    TYPE(PushButton) POS(.1,.1)   SIZE(415,22) CAPTION(~Kompletní seznam akcionáøù) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
