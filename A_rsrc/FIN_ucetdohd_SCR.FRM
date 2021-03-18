TYPE(drgForm) DTYPE(10) TITLE( Pøehled úèetních dokladù ...) SIZE(100,25) ;
                                                             CARGO(FIN_UCETDOHD_IN) OBDOBI(FIN) ;
                                                             PRINTFILES(ucetdohd:ndoklad=ndoklad, ;
                                                                        ucetdoit:ndoklad=ndoklad, ; 
                                                                        ucetpol:cdenik=cdenik+ndoklad=ndoklad)

  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(.2,.2) SIZE(99,11.5) FILE(UCETDOHD)                     ;
                                         FIELDS(M->oinf|tisk:T:2.6::2      , ;
                                                M->oinf|danuzav:D:2.6::2   , ;
                                                M->oinf|likvidace:L:2.6::2 , ;
                                                M->oinf|ucuzav:U:2.6::2    , ;
                                                COBDOBI:období:5           , ;
                                                NDOKLAD:èíslo dokladu      , ;
                                                CTEXTDOK:text dokladu:37   , ;
                                                CVARSYM:varSymbol          , ;
                                                NCENZAKCEL:celkem          , ;
                                                CUCET_UCT:SuAu_Ø           , ;
                                                dporizDok:datVyst          , ;
                                                dvystDok:datUzp            , ;
                                                nosvoddan:osvobozeno       , ; 
                                                nzakldan_1:základ(sd)      , ;
                                                nsazdan_1:sazba(sd)        , ;
                                                nzakldan_2:základ(zd)      , ;
                                                nsazdan_2:sazba(zd)          ) ;
                                         CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)


* položky
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.5) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky úèetního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99,7.8) FILE(UCETDOIT);
                                        FIELDS(NORDITEM:polDok            , ;
                                               COBDOBI:úèObd              , ;
                                               CTEXT:text dokladu:42      , ;
                                               CUCETMD:SuAu_Ø             , ;
                                               NKCMD:md                   , ;
                                               NKCDAL:dal                 , ;
                                               CUCETDAL:SuAu_S            , ;
                                               fin_ucetdoit_bc('h'):typ:4 ) ;
                                        CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yx)

* ns-ucetdoit
    TYPE(Static) STYPE(9) SIZE(98.2,2.5) FPOS(.5,8.9) RESIZE(y)
      TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETDOIT->cNAZPOL1)  CPOS( 3,1.2) CLEN(13) PP(2) BGND(13)
      TYPE(Text) FCAPTION(Výrobek)         CPOS(19, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETDOIT->cNAZPOL2)  CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)
      TYPE(Text) FCAPTION(Zakázka)         CPOS(35, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETDOIT->cNAZPOL3)  CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)
      TYPE(Text) FCAPTION(VýrMísto)        CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETDOIT->cNAZPOL4)  CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)
      TYPE(Text) FCAPTION(Stroj)           CPOS(67, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETDOIT->cNAZPOL5)  CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrOperace)      CPOS(83, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(UCETPOL->cNAZPOL6)   CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Static) STYPE(12) SIZE(96,.1) FPOS(1,.4)
      TYPE(End)
    TYPE(End)
  TYPE(END)

* likvidace
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.5) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Likvidace úèetního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,10.5) FILE(UCETPOL);
                                           FIELDS(NDOKLAD:doklad       , ;
                                                  COBDOBI:OBD_úè       , ;
                                                  CTEXT:Text dokladu:40, ;
                                                  CUCETMD:SuAu_Ø       , ;
                                                  NKCMD                , ;
                                                  NKCDAL               , ;
                                                  CUCETDAL:SuAu_S        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(4) SCROLL(ny)
  TYPE(End)

* øádky výkazu dph
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.5) TTYPE(3) OFFSET(25,62) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,10.5) FILE(VYKDPH_I)                                 ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:43, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(1) SCROLL(ny)
  TYPE(END)

