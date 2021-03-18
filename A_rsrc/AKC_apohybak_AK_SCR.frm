TYPE(drgForm) DTYPE(10) TITLE(Pøehled pohybù akcií dle akcií ...) FILE(AKCIE)            ;
                                                                  SIZE(107,25)           ;
                                                                  GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)


* TYPE(Action) CAPTION(~Nový_Akc )    EVENT(akc_akcionar_novy)   TIPTEXT(Založení nového akcionáøe do seznamu ...)
* TYPE(Action) CAPTION(~Oprava_Akc )  EVENT(akc_akcionar_oprava) TIPTEXT(Oprava údajù akcionáøe ...)


* AKCIE
  TYPE(DBrowse) FILE(AKCIEsw) INDEXORD(1)                ;
                FIELDS( npocAkci:pocAkci:5             , ; 
                        cZkrTypAkc:zkrTypu:8           , ;
                        M->nazevAkc:název typu akcie:42, ;
                        cserCisAkc:sériovéÈíslo:30     , ;
                        nhodnotaAk:hodnota               ) ;
                FPOS( .5,1.4) SIZE(107, 12) RESIZE(yx) CURSORMODE(3) PP(7) ITEMMARKED(itemMarked) SCROLL(yy) POPUPMENU(yy)



* APOHYBAK - pohyby / zmìny akcií
  TYPE(TabPage) CAPTION(pohybAkcie) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(1,81)

    TYPE(DBrowse) FILE(APOHYBAK) INDEXORD(1)            ;
                  FIELDS(ndoklad:doklad               , ;
                         czkrTYPpoh:typPohybu         , ;
                         dzmenaZazn:datZmìny:10       , ;
                         czkrTYPakc:zkrTypu           , ;
                         crodCISnew:rodnéÈíslo        , ;
                         cjmenoNew:jméno akcionáøe:37 , ;
                         nhodnotaAk:hodnota             ) ;
                 FPOS(.1, .01) SIZE(107,9.5) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) 
 
  TYPE(End)


* AKCIONARI - akcionáøi vlastnící AKCII
  TYPE(TabPage) CAPTION( akcionáøi) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(18,63)

    TYPE(DBrowse) FILE(AKCIONAR) INDEXORD(1);
                  FIELDS( czkrTypAr:typAkc              , ;
                          czkrOblast:oblast             , ;  
                          cjmenoAkci:jméno akcionáøe:35 , ;
                          cRodCisAkc:rodnéÈíslo         , ;
                          culice:ulice:30               , ;
                          cmisto:místo:30               , ;
                          cpsc:psè                      , ;
                          M->zpusNab_AR:zpusNab:6       , ;  
                          M->hodnotaAk:èástAkcie:13     , ;
                          npocetAkci:poètAkcií          , ;
                          nhodnotaAk:hodnota            , ;
                          npocetHlas:poèHlasù             ) ;
                  SIZE(107,9.5) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy)
  TYPE(End)


* AKCIONAR - údaje o akcionáøi
  TYPE(TabPage) CAPTION( info Akcionáøe) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(36,44)
    TYPE(STATIC) FPOS(0.01,0.1) SIZE(50,8  ) STYPE(12)  RESIZE(yx) CTYPE(2)   
   
      TYPE(TEXT) CAPTION(Akcionáø)               CPOS( 1, -0.1) CLEN(10)                FONT(2) 
      TYPE(TEXT) NAME(akcionar->cjmenoAkci)      CPOS( 3, 1  )  CLEN(45)       BGND(12) FONT(5)

      TYPE(TEXT) CAPTION(rodnéÈíslo)             CPOS( 3, 2.5) CLEN( 9) 
      TYPE(TEXT) NAME(akcionar->crodCisAkc)      CPOS(12, 2.5) CLEN(15)
*
      TYPE(TEXT) CAPTION(typAkcion)              CPOS( 3, 3.5) CLEN( 9)
      TYPE(TEXT) NAME(akcionar->czkrTypAr)       CPOS(12, 3.5) CLEN( 5)   
      TYPE(TEXT) NAME(c_typar->cNazevAr)         CPOS(19, 3.5) CLEN(25) 
*
      TYPE(TEXT) CAPTION(oblast)                 CPOS( 3, 4.5) CLEN( 9)
      TYPE(TEXT) NAME(akcionar->czkrOblast)      CPOS(12, 4.5) CLEN(15)  
      TYPE(TEXT) NAME(c_oblasa->cnazevObl)       CPOS(19, 4.5) CLEN(25) 
*
      TYPE(TEXT) CAPTION(stavAkcion)             CPOS( 3, 5.5) CLEN( 9)
      TYPE(TEXT) NAME(akcionar->nstavAkc)        CPOS(12, 5.5) CLEN( 4)  
    TYPE(End)

    TYPE(STATIC) FPOS(50.1,0.1) SIZE(56.9,8) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(Adresa )                 CPOS( 5,0.5) CLEN(11)                 FONT(2) 
        TYPE(TEXT) NAME(akcionar->culice)         CPOS(18,0.5) CLEN(30)       BGND(13)
        TYPE(TEXT) NAME(akcionar->cmisto)         CPOS(18,1.5) CLEN(30)       BGND(13)
        TYPE(TEXT) NAME(akcionar->cpsc)           CPOS(18,2.5) CLEN( 6)       BGND(13) 
        TYPE(TEXT) NAME(c_psc->cmisto)            CPOS(25,2.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(Telefon)                 CPOS( 5,3.5) CLEN(11)                 FONT(2) 
        TYPE(TEXT) NAME(akcionar->cdomTel)        CPOS(18,3.5) CLEN(15)       BGND(13)
        TYPE(TEXT) NAME(akcionar->ctelefon)       CPOS(38,3.5) CLEN(15)       BGND(13)
*
*
      TYPE(TEXT) CAPTION(výmìraHa)                CPOS(  8, 4.9)  
      TYPE(TEXT) CAPTION(poèetAkcí)               CPOS( 19, 4.9)
      TYPE(TEXT) CAPTION(hodnotaAkcí)             CPOS( 34, 4.9) CLEN(10)
      TYPE(TEXT) CAPTION(poèetHlasù)              CPOS( 45, 4.9) CLEN( 9)

      TYPE(STATIC) FPOS( 5, 5.4) SIZE(51, 1.7) STYPE(9) RESIZE(nx) CTYPE(5)
        TYPE(TEXT) NAME(akcionar->nvymeraHa)      CPOS(  1, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->npocetAkci)     CPOS( 15, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->nhodnotaAk)     CPOS( 27, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->npocetHlas)     CPOS( 42, .5) CLEN(13) FONT(5)
      TYPE(END)

    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(106.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Akcionáøi)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(70, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 23) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)
