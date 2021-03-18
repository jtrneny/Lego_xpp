TYPE(drgForm) DTYPE(10) TITLE(Faktury vystavené ...) SIZE(100,25) ; 
                                                     CARGO(FIN_fakvyshd_IN) OBDOBI(FIN)   ;
                                                     PRINTFILES(fakvyshd:ncisfak=ncisfak, ;
                                                                fakvysit:ncisfak=ncisfak, ;
                                                                ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

  TYPE(Action) CAPTION(~Likvidace)   EVENT(FIN_LIKVIDACE_IN)   TIPTEXT(Likvidace faktury vystavené)
  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

  TYPE(Action) CAPTION(~DodacíList)  EVENT(fin_dodlsthd)       TIPTEXT(Pøipojený dodací list)
  TYPE(Action) CAPTION(~Výdejka)     EVENT(fin_pvphead)        TIPTEXT(Pøipojené výdejky)

  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(d~Obropis)    EVENT(fin_dobropis)       TIPTEXT(možnost vytvoøit dobropis k základnímu dokladu)

  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(d~Oplòující      ) EVENT(createContext) TIPTEXT(možnost zmìny základních údajù dokladu)  ICON1(338) ATYPE(33)

  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(úhr~Pokladnou)     EVENT(fakVyshd_to_pokladhd_in ) TIPTEXT(možnost úhrady faktury pokladním dokladem) 


*                         
  TYPE(DBrowse) SIZE(100,10.5) FILE(FAKVYSHD)                             ;
                              FIELDS(M->oinf|extDoklad:C:2.6::2         , ;
                                     M->oinf|hrazeno_scrFAKV:H:2.6::2   , ;
                                     M->oinf|tisk:T:2.6::2              , ;
                                     M->oinf|danuzav:D:2.6::2           , ;
                                     M->oinf|likvidace:L:2.6::2         , ;
                                     M->oinf|ucuzav:U:2.6::2            , ;
                                     cOBDOBI:obdÚè:5                    , ;
                                     nCISFIRMY:firma                    , ; 
                                     nCISFAK:èísloFak                   , ;
                                     cVARSYM:varSymb:15                 , ;
                                     cNAZEV::25                         , ;
                                     nCENzakCEL:fakturováno v CZK:12:::1, ;
                                     nuhrCelFak:uhrazeno v CZK::::1     , ;
                                     M->kuhrade_vzm:k úhradì v CZK::::1 , ;
                                     czkratMeny:mìnaZákl                , ;
                                     ncenZahCel:fakurováno v zm::::1    , ;
                                     nuhrcelfaz:uhrazeno v zm::::1      , ;
                                     M->kuhrade_vcm:k úhradì v zm::::1  , ;
                                     cZkratMenZ:mìnaZahr                , ;
                                     czkrtypuhr:zkrÚhrady               , ;
                                     nosvoddan:osvobozeno::::1          , ; 
                                     nzakldan_1:základ(sd)              , ;
                                     nsazdan_1:sazba(sd)                , ;
                                     nzakldan_2:základ(zd)              , ;
                                     nsazdan_2:sazba(zd)                , ; 
                                     nCISFIRDOA:dodadr                  , ;
                                     cNAZEVDOA:dodací adresa:25         , ;
                                     nKLICOBL:region                    , ;  
                                     ncenfakcel:celkfakcena             , ;
                                     dsplatfak:datSplat                 , ;
                                     ncisloDL::10                       , ;
                                     ncisloPvp::10                        ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)  FOOTER(yy)

* info
  TYPE(Static) FPOS(1,10.8) SIZE(98,4) STYPE(13) RESIZE(yx)
* 1
    TYPE(Text) CAPTION(Datum uskuteènìní ZP ...) CPOS(  1, .5)
    TYPE(Text) NAME(FAKVYSHD->dPOVINFAK)         CPOS( 25, .5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) CAPTION(Datum úhrady      ...)    CPOS( 57, .5) 
    TYPE(Text) NAME(FAKVYSHD->dPOSUHRFAK)        CPOS( 78, .5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(FAKVYSHD->czkrtypuhr)        CPOS( 92, .5) CLEN( 6)
* 2
    TYPE(Text) CAPTION(Datum vystavení ...)      CPOS(  1,1.5)
    TYPE(Text) NAME(FAKVYSHD->dVYSTFAK)          CPOS( 25,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Celkem uhrazeno ... )     CPOS( 57,1.5)
    TYPE(Text) NAME(FAKVYSHD->nUHRcelFAK)        CPOS( 78,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) NAME(FAKVYSHD->cZKRATmeny)        CPOS( 92,1.5) CLEN( 5) FONT(5)
    TYPE(Text) NAME(FAKVYSHD->nUHRcelFAZ)        CPOS( 78,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(FAKVYSHD->cZKRATmenz)        CPOS( 92,2.5) CLEN( 5) FONT(5)
* 3
    TYPE(Text) CAPTION(Datum splatnosti ... )    CPOS(  1,2.5) 
    TYPE(Text) NAME(FAKVYSHD->dSPLATFAK)         CPOS( 25,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
  TYPE(End)


* položky
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
*                                     7.6
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(FAKVYSIT)                 ;
                                           FIELDS(nCISFAK:èísFak:10     , ;
                                                  cNAZZBO:název zboží:35, ;
                                                  M->cenPol:c:2.6::2    , ; 
                                                  cSKLPOL:sklPol        , ;
                                                  nCeJPrKBZ:cenaJedKonc , ;
                                                  nFAKTMNOZ:množFak:13  , ;
                                                  cZKRATJEDN:jed:3      , ;
                                                  nCeCPrKBZ:cenaCelk    , ;
                                                  nCeCPrKDZ:cenaCelksDPH, ;
                                                  nProcSlev:sleva %     , ;
                                                  nHodnSlev:sleva       , ;
                                                  nRADVYKDPH:rvDph      , ;
                                                  nKODPLNENI:sh         , ; 
                                                  cCISZAKAZI:výrZakázka , ; 
                                                  cUCETSKUP:UèSk          ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(yx) 
  TYPE(End)

* úhrady
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(úhrady) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Úhrady pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(FAKVYSHDuw);  
                                           FIELDS(NDOKLAD:doklad         , ;
                                                  DSPLATFAK:splDne       , ;
                                                  DDATUHRADY:uhrDne      , ;
                                                  CBANK_UCT:bankÚèet     , ;
                                                  NPOKLADNA:èísPokl      , ;
                                                  CBANK_NAZ:uhrazeno_z:21, ;   
                                                  NCENZAKCEL:úhrCelkem   , ;
                                                  M->typObratu:typ:2.7::2  ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
  TYPE(End)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(UCETPOL);  
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
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(37,50) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(VYKDPH_I)                                 ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:44, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(1) SCROLL(ny)
  TYPE(END)