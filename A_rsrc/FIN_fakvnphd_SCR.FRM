TYPE(drgForm) DTYPE(10) TITLE(Vnitropodniková fakturace ...) SIZE(100,25)                               ; 
                                                            CARGO(FIN_FAKVNPHD_IN) OBDOBI(FIN)          ;
                                                            PRINTFILES(fakvnphd:ncisfak=ncisfak,        ;
                                                                       fakvnpit:ncisfak=ncisfak,        ;
                                                                       ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

 
  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_FAKVNPHD_LIK_IN) TIPTEXT(Likvidace vnitro_Podnikové faktury ...)


  TYPE(DBrowse) FPOS(.1,.1) SIZE(99.6,9.5) FILE(FAKVNPHD)                      ; 
                                           FIELDS( M->oinf|tisk:T:2.6::2     , ;
                                                   M->oinf|likvidace:L:2.6::2, ;
                                                   M->oinf|ucuzav:U:2.6::2   , ;
                                                   nCISFAK:èísloFak          , ;
                                                   cVARSYM:varSymbol         , ;
                                                   cNAZPOL1:doddavatel       , ;
                                                   cNAZPOL1O:odbìratel       , ;
                                                   cTEXTFAKT:text faktury:33 , ;
                                                   nCENZAKCEL:celkem           ) ;
                                           CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(Static) STYPE(13) FPOS(1,9.9) SIZE(98,2) RESIZE(y) CTYPE(3)
* L
    TYPE(Text) CAPTION(Dodavatel ->)     CPOS(  1, .5) CLEN(12) FONT(5) 
    TYPE(Text) NAME(FAKVNPHD->cNAZPOL1)  CPOS( 13, .5) CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(M->DODAVATEL_ns)     CPOS( 23, .5) CLEN(25) BGND(13) PP(2) CTYPE(1)
* P 
    TYPE(Text) CAPTION(Odbìratel ->)     CPOS( 49, .5) CLEN(12) FONT(5)
    TYPE(Text) NAME(FAKVNPHD->cNAZPOL1O) CPOS( 61, .5) CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(M->ODBERATEL_ns)     CPOS( 71, .5) CLEN(25) BGND(13) PP(2) CTYPE(1)
  TYPE(End)



* položky
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.8) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky vnitroPodnikové faktury) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1) SIZE(99,7.8) FILE(FAKVNPIT);  
                                         FIELDS(cSKLPOL:sklPoložka    , ;
                                                cNAZZBO:název zboží:37, ;
                                                nFAKTMNOZ:faktMnož    , ;
                                                nCENAZAKL:cenaZaJedn  , ;
                                                nCENZAKCEL:celkem       );
                                         CURSORMODE(3) PP(7) INDEXORD(3) SCROLL(ny) RESIZE(yx)


* ns-fakvnpit
    TYPE(Static) STYPE(9) SIZE(98.2,2.5) FPOS(.5,8.9) RESIZE(y)
      TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, .1) CLEN(12) PP(3) BGND( 1) FONT(5) 
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL1)  CPOS( 3,1.2) CLEN(13) PP(2) BGND(13) 

      TYPE(Text) FCAPTION(Výrobek)         CPOS(19, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL2)  CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Zakázka)         CPOS(35, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL3)  CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrMísto)        CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL4)  CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Stroj)           CPOS(67, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL5)  CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrOperace)      CPOS(83, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(FAKVNPIT->cNAZPOL6)  CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Static) STYPE(12) SIZE(96,.1) FPOS(1,.4)
      TYPE(End)
    TYPE(End)
  TYPE(END)


* likvidace
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.8) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Likvidace vnitroPodnikové faktury) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1) SIZE(99.6,10.5) FILE(UCETPOL);  
                                            FIELDS(NDOKLAD:doklad       , ;
                                                   COBDOBI:OBD_úè       , ;
                                                   CTEXT:Text dokladu:40, ;
                                                   CUCETMD:SuAu_Ø       , ;
                                                   NKCMD                , ;
                                                   NKCDAL               , ;
                                                   CUCETDAL:SuAu_S        ) ;
                                            CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(4) SCROLL(ny)
  TYPE(End)
