TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava akcionáøe ...) SIZE(103,12) FILE (AKCONARw)                                         ; 
                                                                          GUILOOK(Action:y,Message:y,IconBar:Y:MyIconBar,Menu:n)  ;                                                                                          
                                                                          PRE(preValidate) POST(postValidate)



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(102.2,7.8) STYPE(13) CTYPE(2) 

      TYPE(TEXT) CAPTION(Akcionáø)              CPOS( 2, 0.1) CLEN(10)                FONT(2) 
      TYPE(GET) NAME(akcionarW->cjmenoAkci)     FPOS( 2, 1.3)  FLEN(40)       BGND(12) FONT(5)
*
      TYPE(TEXT) CAPTION(rodnéÈíslo)            CPOS( 2, 2.5) CLEN( 9)        
      TYPE(GET)  NAME(akcionarW->crodCisAkc)    FPOS(12, 2.5) FLEN(15)        NOREVISION()
*
      TYPE(TEXT) CAPTION(typAkcion)             CPOS( 2, 3.5) CLEN( 9)
      TYPE(GET)  NAME(akcionarW->czkrTypAr)     FPOS(12, 3.5) FLEN( 6)   
      TYPE(TEXT) NAME(c_typar->cNazevAr)        CPOS(20, 3.5) CLEN(20) 
*
      TYPE(TEXT) CAPTION(oblast)                CPOS( 2, 4.5) CLEN( 9)
      TYPE(GET)  NAME(akcionarW->czkrOblast)    FPOS(12, 4.5) FLEN( 6)  
      TYPE(TEXT) NAME(c_oblasa->cnazevObl)      CPOS(20, 4.5) CLEN(20) 
*
      TYPE(TEXT) CAPTION(stavAkcion)            CPOS( 2, 5.5) CLEN( 9)
      TYPE(GET)  NAME(akcionarW->nstavAkc)      FPOS(12, 5.5) FLEN( 6)  

    TYPE(STATIC) FPOS(45, .1) SIZE(56.9, 7.5) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(Adresa )                CPOS( 3,0.5) CLEN(11)                 FONT(2) 
        TYPE(GET)  NAME(akcionarW->culice)       FPOS(14,0.5) FLEN(35)       BGND(13)
        TYPE(GET)  NAME(akcionarW->cmisto)       FPOS(14,1.5) FLEN(35)       BGND(13)
        TYPE(GET)  NAME(akcionarW->cpsc)         FPOS(14,2.5) FLEN( 8)       BGND(13) 
        TYPE(TEXT) NAME(c_psc->cmisto)           CPOS(24,2.5) CLEN(30)      

      TYPE(TEXT) CAPTION(Telefon)                CPOS( 3,3.6) CLEN(11)                 FONT(2) 
        TYPE(GET)  NAME(akcionarW->cdomTel)      FPOS(14,3.6) FLEN(15)       BGND(13)
        TYPE(GET)  NAME(akcionarW->ctelefon)     FPOS(34,3.6) FLEN(15)       BGND(13)
*
*
      TYPE(TEXT) CAPTION(výmìraHa)               CPOS(  8, 4.9)  
      TYPE(TEXT) CAPTION(poèetAkcí)              CPOS( 19, 4.9)
      TYPE(TEXT) CAPTION(hodnotaAkcí)            CPOS( 32, 4.9) CLEN(10)
      TYPE(TEXT) CAPTION(poèetHlasù)             CPOS( 44, 4.9) CLEN( 9)

      TYPE(STATIC) FPOS( 3, 5.4) SIZE(51, 1.7) STYPE(9) RESIZE(nx) CTYPE(5)
        TYPE(GET)  NAME(akcionarW->nvymeraHa)    FPOS(  1, .5) FLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionarW->npocetAkci)   CPOS( 17, .5) CLEN( 8) FONT(5)
        TYPE(TEXT) NAME(akcionarW->nhodnotaAk)   CPOS( 27, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionarW->npocetHlas)   CPOS( 43, .5) CLEN(13) FONT(5)
      TYPE(END)
    TYPE(End)
  TYPE(END)



*                                                         

