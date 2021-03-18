TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava valné hromady ...) SIZE(120,27) FILE (AVALHRHD )                                        ; 
                                                                              GUILOOK(Action:y,Message:y,IconBar:Y:MyIconBar,Menu:n)  ;                                                                                          
                                                                              PRE(preValidate) POST(postValidate)



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(119.2,7.5) STYPE(13) CTYPE(2) 
  
      TYPE(TEXT)     CAPTION(èísloVh)               CPOS( 7, 0.1) CLEN(10)                FONT(2)       
      TYPE(GET)      NAME(avalhrhdW->nporVAlhro)    FPOS( 7, 1.3) FLEN( 6)       BGND(12) FONT(5)  

      TYPE(TEXT)     CAPTION(typ_valnéHromady)      CPOS(17, 0.1) CLEN(17)                FONT(2)       
      TYPE(COMBOBOX) NAME(avalhrhdW->ctypVALhro)    FPOS(17, 1.3) FLEN(32)                VALUES(Øádná    : øádá valna hromada    , ; 
                                                                                                 Náhradní : náhradní valná hromada, ;    
                                                                                                 Mimoøádná: mimoøádná valná hromada )

      TYPE(TEXT) CAPTION(datumKonání)               CPOS( 6, 3.0) CLEN(10)                
      TYPE(GET)  NAME(avalhrhdW->ddatKonani)        FPOS(17, 3.0) FLEN(11)                PUSH(CLICKDATE) 
      TYPE(TEXT) CAPTION(èasKonání)                 CPOS(31, 3.0) CLEN( 8)                
      TYPE(GET)  NAME(avalhrhdW->ccasKonani)        FPOS(40, 3.0) FLEN( 8)                PICTURE(@99:99)

      TYPE(TEXT) CAPTION(jednatel)                  CPOS( 6, 4.0) CLEN( 9)        
      TYPE(GET)  NAME(avalhrhdW->cjmenoJedn)        FPOS(17, 4.0) FLEN(31)                FONT(5) 


*    TYPE(TEXT) CAPTION(poèetAkcionáøù)              CPOS( 2, 5.3) CLEN(12)
    TYPE(TEXT) CAPTION(poèetAkcií)                  CPOS(20, 5.3) CLEN(10)
    TYPE(TEXT) CAPTION(poèetHlasù)                  CPOS(33, 5.3) CLEN(10)

    TYPE(STATIC) FPOS( 6,5.8) SIZE(43, 1.5) STYPE(9) RESIZE(nx) CTYPE(5)       
      TYPE(TEXT) NAME(avalhrhdW->npocetAkci)       CPOS(20, .5) CLEN(10)
      TYPE(TEXT) NAME(avalhrhdW->npocetHlas)       CPOS(33, .5) CLEN(10) 
    TYPE(End)

    TYPE(STATIC) FPOS(58, .1) SIZE(59.9, 7.2) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(Adresa )                CPOS( 3,0.5) CLEN(11)                 FONT(2) 
        TYPE(GET)  NAME(avalhrhdW->culice)       FPOS(14,0.5) FLEN(35)       BGND(13)
        TYPE(GET)  NAME(avalhrhdW->cmisto)       FPOS(14,1.5) FLEN(35)       BGND(13)
        TYPE(GET)  NAME(avalhrhdW->cpsc)         FPOS(14,2.5) FLEN( 8)       BGND(13) 
        TYPE(TEXT) NAME(c_psc->cmisto)           CPOS(24,2.5) CLEN(30)      

      TYPE(TEXT) CAPTION(Telefon)                CPOS( 3,3.6) CLEN(11)                 FONT(2) 
        TYPE(GET)  NAME(avalhrhdW->ctelMobil)    FPOS(14,3.6) FLEN(15)       BGND(13)
        TYPE(GET)  NAME(avalhrhdW->ctelefon)     FPOS(34,3.6) FLEN(15)       BGND(13)

      TYPE(TEXT) CAPTION(E-mail)                 CPOS( 3,4.6) CLEN(11)                 FONT(2) 
        TYPE(GET)  NAME(avalhrhdW->cEmail)       FPOS(14,4.6) FLEN(35)       BGND(13)

      TYPE(PushButton) POS(45.4,5.8) SIZE(5,1) EVENT(rtfEdit) ICON1(459) ICON2(214) ATYPE(1) CAPTION(avalhrhdW->mporadHro,1)
    TYPE(End)  
  TYPE(END)

*
* AKCIONAR
*
  TYPE(STATIC) FPOS( .4,8.5) SIZE(54,18) STYPE(12)  CTYPE(2)
    TYPE(DBrowse) FILE(AKCIONARsw)                        ;
                  FIELDS( cjmenoAkci:jméno akcionáøe:30 , ;
                          cRodCisAkc:rodnéÈíslo         , ;
                          culice:ulice:30               , ;
                          cmisto:místo:30               , ;
                          cpsc:psè                      , ;
                          npocetAkci:poètAkcií          , ;
                          nhodnotaAk:hodnota            , ;
                          npocetHlas:poèHlasù             ) ;
                   FPOS(-.3,.1) SIZE(54,17.5) CURSORMODE(3) PP(7) POPUPMENU(y)

  TYPE(End)


* AVALHRIT - valné hromady IT - akcionari
*
  TYPE(STATIC) FPOS(65.6,8.5) SIZE(54,18) STYPE(12)  CTYPE(2)
    TYPE(DBrowse) FILE(AVALHRITw) INDEXORD(1)              ;
                  FIELDS( M->deBrowse_indicateRow::2.7::2, ;
                          cjmenoAkci:jméno akcionáøe:30  , ;
                          cRodCisAkc:rodnéÈíslo          , ;
                          npocetAkci:poètAkcií           , ;
                          nhodnotaAk:hodnota             , ;
                          npocetHlas:poèHlasù              ) ;
                 FPOS(-.3,.1) SIZE(54,17.5) RESIZE(yx) CURSORMODE(3) PP(9) SCROLL(yy) POPUPMENU(y) FOOTER(Y)
  TYPE(End)

                 
  TYPE(PushButton) POS(55,12) SIZE(10,1) ICON1(424) ATYPE(1) EVENT(LeftACTION) 
  TYPE(PushButton) POS(55,17) SIZE(10,1) ICON1(423) ATYPE(1) EVENT(RightACTION)                                        

