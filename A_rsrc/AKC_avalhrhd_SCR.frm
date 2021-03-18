TYPE(drgForm) DTYPE(10) TITLE(P�ehled valn�ch hromad dle kon�n� ...) FILE(AVALHRHD)         ;
                                                                     SIZE(107,25)           ;
                                                                     CARGO(AKC_avalhrhd_IN) ;
                                                                     GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

* TYPE(Action) CAPTION(~Materi�l)        EVENT(ZAK_MATERIAL) TIPTEXT(Po�adavky na materi�l)
* TYPE(Action) CAPTION(~Pl�n vs. skut.)  EVENT(ZAK_PLANSKUT) TIPTEXT(Porovn�n� pl�nu a skute�nosti)
* TYPE(Action) CAPTION(~Zru�it materi�l) EVENT(ZAK_MATERIAL_DEL) TIPTEXT(Zru�it po�adavky na materi�l)

* AVALHRHD - valn� hromady HD
  TYPE(DBrowse) FILE(AVALHRHD) INDEXORD(1)             ;
                FIELDS( nporVALhro:po�Vh             , ;
                        ctypVALhro:typVh             , ;
                        ddatKonani:datKon�n�:10      , ;
                        ccasKonani:�asKon�n�         , ;
                        cjmenoJedn:jm�no jednatele:35, ;
                        cmisto:m�sto                 , ;
                        npocetAkci:po�tAkci�         , ;
                        nhodnotaAk:hodnota           , ;
                        npocetHlas:po�Hlas�            ) ;                         
               FPOS(0.5,1.40) SIZE(107,12) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) POPUPMENU(yy);
               ITEMMARKED(itemMarked)

* AVALHRIT - valn� hromady IT - akcionari
  TYPE(TabPage) CAPTION(�akcion��i) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(1,81) PRE(tabSelect)

    TYPE(DBrowse) FILE(AVALHRIT) INDEXORD(1)              ;
                  FIELDS( czkrTypAr:typAkc              , ;
                          cjmenoAkci:jm�no akcion��e:35 , ;
                          cRodCisAkc:rodn���slo         , ;
                          npocetAkci:po�tAkci�          , ;
                          nhodnotaAk:hodnota            , ;
                          npocetHlas:po�Hlas�             ) ;
                 SIZE(107, 9.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked)
  TYPE(End)


* AKCIONAR - �daje o akcion��i
  TYPE(TabPage) CAPTION( info Akcion��e) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(18,63) PRE(tabSelect)
    TYPE(STATIC) FPOS(0.01,0.1) SIZE(50,8  ) STYPE(12)  RESIZE(yx) CTYPE(2)   
   
      TYPE(TEXT) CAPTION(Akcion��)               CPOS( 1, -0.1) CLEN(10)                FONT(2) 
      TYPE(TEXT) NAME(akcionar->cjmenoAkci)      CPOS( 3, 1  )  CLEN(45)       BGND(12) FONT(5)

      TYPE(TEXT) CAPTION(rodn���slo)             CPOS( 3, 2.5) CLEN( 9) 
      TYPE(TEXT) NAME(akcionar->crodCisAkc)      CPOS(12, 2.5) CLEN(15)

      TYPE(TEXT) CAPTION(typAkcion)              CPOS( 3, 3.5) CLEN( 9)
      TYPE(TEXT) NAME(akcionar->czkrTypAr)       CPOS(12, 3.5) CLEN( 5)   
      TYPE(TEXT) NAME(c_typar->cNazevAr)         CPOS(19, 3.5) CLEN(25) 

      TYPE(TEXT) CAPTION(oblast)                 CPOS( 3, 4.5) CLEN( 9)
      TYPE(TEXT) NAME(akcionar->czkrOblast)      CPOS(12, 4.5) CLEN(15)  
      TYPE(TEXT) NAME(c_oblasa->cnazevObl)       CPOS(19, 4.5) CLEN(25) 

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
      TYPE(TEXT) CAPTION(v�m�raHa)                CPOS(  8, 4.9)  
      TYPE(TEXT) CAPTION(po�etAkc�)               CPOS( 19, 4.9)
      TYPE(TEXT) CAPTION(hodnotaAkc�)             CPOS( 34, 4.9) CLEN(10)
      TYPE(TEXT) CAPTION(po�etHlas�)              CPOS( 45, 4.9) CLEN( 9)

      TYPE(STATIC) FPOS( 5, 5.4) SIZE(51, 1.7) STYPE(9) RESIZE(nx) CTYPE(5)
        TYPE(TEXT) NAME(akcionar->nvymeraHa)      CPOS(  1, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->npocetAkci)     CPOS( 15, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->nhodnotaAk)     CPOS( 27, .5) CLEN(13) FONT(5)
        TYPE(TEXT) NAME(akcionar->npocetHlas)     CPOS( 42, .5) CLEN(13) FONT(5)
      TYPE(END)

    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* jedn�n� a n�vrh usneseni valn� hromady
  TYPE(TabPage) CAPTION( po�ad valn�Hr) FPOS(0, 14.2) SIZE(107,10.5) RESIZE(yx) TTYPE(3) OFFSET(37,43) PRE(tabSelect)

    TYPE(MLE)  NAME(mporadHro) FPOS(.5, .5) SIZE(106,9) RESIZE(yx) SCROLL(ny) READONLY(Y) FORMAT(3)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(106.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Akcion��i)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(70, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 23) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)
