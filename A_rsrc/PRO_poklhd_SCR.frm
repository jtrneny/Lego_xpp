TYPE(drgForm) DTYPE(10) TITLE(Doklady registraèní pokladny ...) SIZE(100,25) FILE(POKLHD)  ;                                               
                                                                CARGO(PRO_poklhd_IN) OBDOBI(FIN)  ;
                                                                PRINTFILES(poklhd:ndoklad=ndoklad,    ;
                                                                                  poklit:ndoklad=ndoklad,    ;
                                                                                  ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
  TYPE(Action) CAPTION(~Výdejka)    EVENT(fin_pvphead)      TIPTEXT(Pøipojené výdejky)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(d~Oplòující      ) EVENT(createContext) TIPTEXT(možnost zmìny základních údajù dokladu)  ICON1(338) ATYPE(33)




 TYPE(DBrowse) SIZE(100,10.5) FILE(POKLHD)                         ;
                              FIELDS(M->oinf|stavEet:e:2.6::2    , ;
                                     M->oinf|tisk:T:2.6::2       , ;
                                     M->oinf|danuzav:D:2.6::2    , ;
                                     M->oinf|likvidace:L:2.6::2  , ;
                                     M->oinf|ucuzav:U:2.6::2     , ;
                                     cOBDOBI:obd:6               , ;
                                     nCISFIRMY:firma             , ; 
                                     nCISFAK:èísloFak            , ;
                                     cVARSYM:varSymb:15          , ;
                                     cNAZEV::29                  , ;
                                     dvystFak:datVyst:10         , ;
                                     nCENzahCEL:celkFak:13:::1   , ;
                                     nzaplaceno:zaplaceno:10:::1 , ;
                                     cZKRATmenz:mìna             , ;
                                     nosvoddan:osvobozeno::::1   , ; 
                                     nzakldan_1:základ(sd)::::1  , ;
                                     nsazdan_1:sazba(sd)::::1    , ;
                                     nzakldan_2:základ(zd)::::1  , ;
                                     nsazdan_2:sazba(zd)::::1    ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(x) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y) FOOTER(yy)

* info
  TYPE(Static) FPOS(1,10.8) SIZE(98,4) STYPE(13) RESIZE(y)
* 1
    TYPE(Text) CAPTION(Datum uskuteènìní ZP ...) CPOS(  1, .5)
    TYPE(Text) NAME(POKLHD->dPOVINFAK)           CPOS( 25, .5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) CAPTION(Datum úhrady      ...)    CPOS( 57, .5) 
    TYPE(Text) NAME(POKLHD->dPOSUHRFAK)          CPOS( 80, .5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 2
    TYPE(Text) CAPTION(Datum vystavení ...)      CPOS(  1,1.5)
    TYPE(Text) NAME(POKLHD->dVYSTFAK)            CPOS( 25,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Celkem uhrazeno ... )     CPOS( 57,1.5)
    TYPE(Text) NAME(POKLHD->nUHRcelFAK)          CPOS( 80,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
* 3
    TYPE(Text) CAPTION(Datum splatnosti ... )    CPOS(  1,2.5) 
    TYPE(Text) NAME(POKLHD->dSPLATFAK)           CPOS( 25,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
  TYPE(End)


* položky
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky pokladního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(POKLIT)                     ;
                                           FIELDS(ncisfak:èísloDokl       , ; 
                                                  ccisSklad:sklad         , ; 
                                                  csklpol:sklPoložka      , ;
                                                  cnazzbo:název zboží:30  , ;
                                                  nfaktmnkoe:prodMnož     , ;
                                                  czkrjednd:prodMJ        , ;
                                                  nfaktmnoz:sklMnož       , ;
                                                  czkratjedn:sklMJ        , ;     
                                                  ncejprkdz:cena/mj       , ;
                                                  ncecprkdz:cenaCelk        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)
  TYPE(End)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Likvidace poklaního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
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

* øádky výkazu dph
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(25,62) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(VYKDPH_I)                                 ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:44, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(1) SCROLL(ny)

  TYPE(End)


