TYPE(drgForm) DTYPE(10) TITLE(Vnitropodniková fakturace dle položek ...) SIZE(100,25)                    ; 
                                                             CARGO(FIN_FAKVNPHD_IN)                      ;
                                                             PRINTFILES(fakvnpit:ncisfak=ncisfak,        ;
                                                                        fakvnphd:ncisfak=ncisfak,        ;
                                                                        ucetpol:cdenik=cdenik+ndoklad=ncisfak) 
 

  TYPE(DBrowse) FPOS(0,0) SIZE(100,10) FILE(FAKVNPIT);  
                                       FIELDS(ncisFak:èísloFak      , ;
                                              cSKLPOL:sklPoložka    , ;
                                              cNAZZBO:název zboží:36, ;
                                              nFAKTMNOZ:faktMnož    , ;
                                              nCENAZAKL:cenaZaJedn  , ;
                                              nCENZAKCEL:celkem       );
                                       CURSORMODE(3) PP(7) INDEXORD(3) SCROLL(ny) RESIZE(yx) ITEMMARKED(itemMarked) POPUPMENU(y)

* ns-fakvnpit
    TYPE(Static) STYPE(8) SIZE(99,2.5) FPOS(.5,10.2) RESIZE(y)
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

      TYPE(Static) STYPE(12) SIZE(96,.2) FPOS(1,.4)
      TYPE(End)
    TYPE(End)


  TYPE(Static) FPOS(.1,13) SIZE(100,3.8) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Vnitropodniková faktura vystavená hlavièka) CPOS(1,.01) CLEN(105) FONT(5) CTYPE(1)

    TYPE(DBrowse) FPOS(-.7,1.5) SIZE(100,2.5) FILE(FAKVNPHD)                      ; 
                                              FIELDS( M->oinf|tisk:T:2.6::2     , ;
                                                      M->oinf|likvidace:L:2.6::2, ;
                                                      M->oinf|ucuzav:U:2.6::2   , ;
                                                      nCISFAK:èísloFak          , ;
                                                      cVARSYM:varSymbol         , ;
                                                      cNAZPOL1:doddavatel       , ;
                                                      cNAZPOL1O:odbìratel       , ;
                                                      cTEXTFAKT:text faktury:32 , ;
                                                      nCENZAKCEL:celkem           ) ;
                                              CURSORMODE(3) PP(7) SCROLL(nn) RESIZE(yy) 
  TYPE(END)

  TYPE(Static) FPOS(.1,17) SIZE(100,8) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Likvidace vnitroPodnikové faktury) CPOS(1,.01) CLEN(105) FONT(5) CTYPE(1)

    TYPE(DBrowse) FPOS(-.7,1.3) SIZE(100,7) FILE(UCETPOL);  
                                            FIELDS(NDOKLAD:doklad       , ;
                                                   COBDOBI:OBD_úè       , ;
                                                   CTEXT:Text dokladu:40, ;
                                                   CUCETMD:SuAu_Ø       , ;
                                                   NKCMD                , ;
                                                   NKCDAL               , ;
                                                   CUCETDAL:SuAu_S        ) ;
                                            CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(4) SCROLL(ny)
  TYPE(END)


