TYPE(drgForm) DTYPE(10) TITLE(Faktury pøijaté ...) SIZE(105,25)                                        ;
                                                   CARGO(FIN_fakprihd_IN) OBDOBI(FIN)                  ;
                                                   PRINTFILES(fakprihd:ncisfak=ncisfak,                ;
                                                              ucetpol:cdenik=cdenik+ndoklad=ncisfak) 


  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
*
*-  TYPE(Action) CAPTION(~Maximize)   EVENT(W_maximize)       TIPTEXT(Maximalizuji okno)


  TYPE(DBrowse) FPOS(.5,.1) SIZE(104.5,15) FILE(FAKPRIHD)                         ;
                                          FIELDS(M->oinf|hrazeno:H:2.6::2       , ;
                                                 M->oinf|prikazy:P:2.6::2       , ;
                                                 M->oinf|danuzav:D:2.6::2       , ;
                                                 M->oinf|likvidace:L:2.6::2     , ;
                                                 M->oinf|ucuzav:U:2.6::2        , ;
                                                 cOBDOBI:Obd:5                  , ;  
                                                 nCISFAK::10                    , ;
                                                 cVARSYM::15                    , ;
                                                 nCISFIRMY:firma                , ; 
                                                 FIRMY->cNAZEV::24              , ;
                                                 cTEXTFAKT::22                  , ;
                                                 nCENzakCEL::12:::1             , ;
                                                 nCENzahCEL::12:::1             , ;
                                                 nosvoddan:osvobozeno           , ; 
                                                 nzakldan_1:základ(sd)          , ;
                                                 nsazdan_1:sazba(sd)            , ;
                                                 nzakldan_2:základ(zd)          , ;
                                                 nsazdan_2:sazba(zd)            , ;
                                                 ncenfakcel:celkfakcena           ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y) FOOTER(yy)


* info
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
* 1
      TYPE(Text) CAPTION(Úèetní období   ...) CPOS(  1, .5)   
      TYPE(Text) NAME(FAKPRIHD->NOBDOBI)      CPOS( 22, .5) CLEN( 5) BGND(13) PP(2)
      TYPE(Text) CAPTION(/)                   CPOS( 27, .5) CLEN( 2)  
      TYPE(Text) NAME(FAKPRIHD->NROK)         CPOS( 29, .5) CLEN( 6) BGND(13) PP(2)
      TYPE(Text) CAPTION(Daòové období ...)   CPOS( 63, .5) CLEN(14)
      TYPE(Text) NAME(FAKPRIHD->COBDOBIDAN)   CPOS( 77, .5) CLEN(10) BGND(13) PP(2) CTYPE(1)
      TYPE(Static) STYPE(17) SIZE(103,1) FPOS(.5, 1)
* 2
        TYPE(Text) CAPTION(FAKTURA   ... )    CPOS(  1,2.1)
        TYPE(Text) NAME(FAKPRIHD->nCENzakCEL) CPOS( 22,2.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,2.1) CLEN( 5) FONT(5)
        TYPE(Text) NAME(FAKPRIHD->nCENzahCEL) CPOS( 40,2.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,2.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(splatno)           CPOS( 63,2.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dSPLATfak)  CPOS( 77,2.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRtypUHR) CPOS( 89,2.1) CLEN( 5) BGND(13) PP(2)
* 4
        TYPE(Text) CAPTION(PØÍKAZY ... )      CPOS(  1,3.1) 
        TYPE(Text) NAME(FAKPRIHD->nPRIuhrCEL) CPOS( 22,3.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,3.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(dne)               CPOS( 63,3.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dDATpriUHR) CPOS( 77,3.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
* 5
        TYPE(Text) CAPTION(UHRAZENO ... )     CPOS(  1,4.1) 
        TYPE(Text) NAME(FAKPRIHD->nUHRcelFAK) CPOS( 22,4.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,4.1) CLEN( 5) FONT(5) 
        TYPE(Text) NAME(FAKPRIHD->nUHRcelFAZ) CPOS( 40,4.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,4.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(dne)               CPOS( 63,4.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dPOSuhrFAK) CPOS( 77,4.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
* 6
        TYPE(Text) CAPTION(K ÚHRADÌ ... )     CPOS(  1,5.2) 
        TYPE(Text) NAME(M->KUHRADE_vzm)       CPOS( 22,5.2) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,5.2) CLEN( 5) FONT(5)
        TYPE(Text) NAME(M->KUHRADE_vcm)       CPOS( 40,5.2) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,5.2) CLEN( 5) FONT(5)
        TYPE(Static) STYPE(17) SIZE(103,1) FPOS(.5, 5.6) 
* 7
          TYPE(Text) CAPTION(VE PROSPÌCH ÚÈTU ... ) CPOS(  1,6.7)
          TYPE(Text) NAME(FAKPRIHD->cUCET)          CPOS( 22,6.7) CLEN(25) BGND(13) PP(2)
* 8
          TYPE(Text) CAPTION(NA VRUB ÚÈTU ... ) CPOS( 53,6.7) 
          TYPE(Text) NAME(FAKPRIHD->cBANK_UCT)  CPOS( 73,6.7) CLEN(25) BGND(13) PP(2)

* tabPage se nemá kam potavit na focus - !
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* úhrady
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(13,74) CAPTION(úhrady) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Úhrady závazku) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(104.8,6.8) FILE(FAKPRIHDuw);  
                                           FIELDS(NDOKLAD:doklad         , ;
                                                  DSPLATFAK:splDne       , ;
                                                  DDATUHRADY:uhrDne      , ;
                                                  CBANK_UCT:bankÚèet     , ;
                                                  NPOKLADNA:èísPokl      , ;
                                                  CBANK_NAZ:uhrazeno_z   , ;   
                                                  NCENZAKCEL:úhrCelkem   , ;
                                                  M->typObratu:typ:2.3::2  ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)

  TYPE(END)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Likvidace závazku) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(104.8,6.8) FILE(UCETPOL);  
                                           FIELDS(NDOKLAD:doklad       , ;
                                                  COBDOBI:OBD_úè       , ;
                                                  CTEXT:Text dokladu:45, ;
                                                  CUCETMD:SuAu_Ø       , ;
                                                  NKCMD                , ;
                                                  NKCDAL               , ;
                                                  CUCETDAL:SuAu_S        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(4) SCROLL(ny)
  TYPE(END)  

* øádky výkazu dph
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(37,50) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(104.8,6.8) FILE(VYKDPH_I)                                ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:48, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(1) SCROLL(ny)
  TYPE(END)

TYPE(END)