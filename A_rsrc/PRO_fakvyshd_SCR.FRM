TYPE(drgForm) DTYPE(10) TITLE(Faktury vystavené (prodej) ...) SIZE(100,25) ; 
                                                              CARGO(FIN_fakvyshd_IN) OBDOBI(FIN)   ;
                                                              PRINTFILES(fakvyshd:ncisfak=ncisfak, ;
                                                                         fakvysit:ncisfak=ncisfak, ;
                                                                         ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
  TYPE(Action) CAPTION(~DodacíList) EVENT(fin_dodlsthd)     TIPTEXT(Pøipojený dodací list)
  TYPE(Action) CAPTION(~Výdejka)    EVENT(fin_pvphead)      TIPTEXT(Pøipojené výdejky)
*
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(d~Oplòující      ) EVENT(createContext) TIPTEXT(možnost zmìny základních údajù dokladu)  ICON1(338) ATYPE(33)

  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(úhr~Pokladnou)     EVENT(fakVyshd_to_pokladhd_in ) TIPTEXT(možnost úhrady faktury pokladním dokladem) 



  TYPE(DBrowse) SIZE(100,10.5) FILE(FAKVYSHD)                            ;
                               FIELDS(M->oinf|extDoklad:C:2.6::2       , ;
                                      M->oinf|hrazeno_scrFAKV:H:2.6::2 , ;
                                      M->oinf|tisk:T:2.6::2            , ;
                                      M->oinf|danuzav:D:2.6::2         , ;
                                      M->oinf|likvidace:L:2.6::2       , ;
                                      M->oinf|ucuzav:U:2.6::2          , ;
                                      nCISFIRMY:firma                  , ; 
                                      nCISFAK:èísloFak                 , ;
                                      cVARSYM:varSymb                  , ;
                                      cNAZEV::25                       , ;
                                      nCISFIRDOA:dodadr                , ;
                                      cNAZEVDOA:dodací adresa:25       , ;
                                      nCENzahCEL:celkFak               , ;
                                      cZKRATmenz                         ) ;
                               CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y)


* info
  TYPE(Static) FPOS(1,10.8) SIZE(98,4) STYPE(13) RESIZE(y)
* 1
    TYPE(Text) CAPTION(Datum uskuteènìní ZP ...) CPOS(  1, .5)
    TYPE(Text) NAME(FAKVYSHD->dPOVINFAK)         CPOS( 25, .5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) CAPTION(Datum úhrady      ...)    CPOS( 57, .5) 
    TYPE(Text) NAME(FAKVYSHD->dPOSUHRFAK)        CPOS( 80, .5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 2
    TYPE(Text) CAPTION(Datum vystavení ...)      CPOS(  1,1.5)
    TYPE(Text) NAME(FAKVYSHD->dVYSTFAK)          CPOS( 25,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Celkem uhrazeno ... )     CPOS( 57,1.5)
    TYPE(Text) NAME(FAKVYSHD->nUHRcelFAK)        CPOS( 80,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
* 3
    TYPE(Text) CAPTION(Datum splatnosti ... )    CPOS(  1,2.5) 
    TYPE(Text) NAME(FAKVYSHD->dSPLATFAK)         CPOS( 25,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
  TYPE(End)


* položky
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(FAKVYSIT)                 ;
                                           FIELDS(nCISFAK:èísFak        , ;
                                                  cNAZZBO:název zboží:35, ;
                                                  M->cenPol:c:2.6::2    , ;
                                                  cCISSKLAD:sklad       , ;   
                                                  cSKLPOL:sklPol        , ;
                                                  nFAKTMNOZ:množFak     , ;
                                                  nCeJPrZBZ:cenaJedZákl , ;
                                                  nHodnSlev:sleva       , ;
                                                  nCeJPrKBZ:cenaJedKonc , ;
                                                  nCeCPrKBZ:cenaCelkBdph, ;
                                                  nCeCPrKDZ:cenaCelkSdph, ;
                                                  nProcSlev:sleva %     , ;
                                                  cCISZAKAZI:výrZakázka , ; 
                                                  cUCETSKUP:ÚèSk        , ; 
                                                  nRADVYKDPH:rvDph        ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(x) 
  TYPE(End)

* úhrady
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(úhrady) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Úhrady pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(FAKVYSHDuw);  
                                           FIELDS(NDOKLAD:doklad         , ;
                                                  DSPLATFAK:splDne       , ;
                                                  DDATUHRADY:uhrDne      , ;
                                                  CBANK_UCT:bankÚèet     , ;
                                                  NPOKLADNA:èísPokl      , ;
                                                  CBANK_NAZ:uhrazeno_z:21, ;   
                                                  NCENZAKCEL:úhrCelkem   , ;
                                                  M->typObratu:typ:2.7::2  ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy)
  TYPE(End)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(UCETPOL);  
                                           FIELDS(NDOKLAD:doklad       , ;
                                                  COBDOBI:OBD_úè       , ;
                                                  CTEXT:Text dokladu:40, ;
                                                  CUCETMD:SuAu_Ø       , ;
                                                  NKCMD                , ;
                                                  NKCDAL               , ;
                                                  CUCETDAL:SuAu_S        ) ;
                                          CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)
  TYPE(End)
