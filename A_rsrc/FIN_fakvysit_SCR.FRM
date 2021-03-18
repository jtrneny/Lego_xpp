TYPE(drgForm) DTYPE(10) TITLE(Faktury vystavené dle položek ...) SIZE(100,25) ; 
                                                     OBDOBI(FIN)              ;
                                                     PRINTFILES(fakvysit:ncisfak=ncisfak, ;
                                                                ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

*  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
*  TYPE(Action) CAPTION(~DodacíList) EVENT(fin_dodlsthd)     TIPTEXT(Pøipojený dodací list)
*  TYPE(Action) CAPTION(~Výdejka)    EVENT(fin_pvphead)      TIPTEXT(Pøipojené výdejky)


  TYPE(DBrowse) FPOS(0,0) SIZE(100,10.6) FILE(FAKVYSIT)                ;
                                        FIELDS(nCISFAK:èísFak:10     , ;
                                               cNAZZBO:název zboží:35, ;
                                               cSKLPOL:sklPol        , ;
                                               nFAKTMNOZ:množFak:13  , ;
                                               cZKRATJEDN:jed:3      , ;
                                               nCeCPrKDZ:cenaCelk    , ;
                                               nRADVYKDPH:rvDph      , ;
                                               cCISZAKAZI:výrZakázka , ;
                                               cUCETSKUP:UèSk          ) ;
                                        CURSORMODE(3) PP(7) INDEXORD(4) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y)
*
**
  TYPE(Static) FPOS(.1,10.8) SIZE(100,1.2) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(faktura vystavená hlavièka) CPOS(1,.01) CLEN(105) FONT(5) CTYPE(1)
  TYPE(END) 

  TYPE(DBrowse) FPOS(0,12) SIZE(100,3.3) FILE(FAKVYSHD)                    ;
                                      FIELDS(M->oinf|hrazeno:H:2.6::2  , ;
                                             M->oinf|tisk:T:2.6::2     , ;
                                             M->oinf|danuzav:D:2.6::2  , ;
                                             M->oinf|likvidace:L:2.6::2, ;
                                             M->oinf|ucuzav:U:2.6::2   , ;
                                             cOBDOBI:obd:5             , ;
                                             nCISFIRMY:firma           , ; 
                                             nCISFAK:èísloFak          , ;
                                             cVARSYM:varSymb:15        , ;
                                             cNAZEV::29                , ;
                                             nCENzahCEL:celkFak:13     , ;
                                             cZKRATmenz:mìna           , ;
                                             nosvoddan:osvobozeno      , ; 
                                             nzakldan_1:základ(sd)     , ;
                                             nsazdan_1:sazba(sd)       , ;
                                             nzakldan_2:základ(zd)     , ;
                                             nsazdan_2:sazba(zd)         ) ;
                                      CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yn) RESIZE(yx)


* info
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Základní informace o dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
* 1
    TYPE(Text) CAPTION(Datum uskuteènìní ZP ...) CPOS(  1,2.5)
    TYPE(Text) NAME(FAKVYSHD->dPOVINFAK)         CPOS( 25,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) CAPTION(Datum úhrady      ...)    CPOS( 57,2.5) 
    TYPE(Text) NAME(FAKVYSHD->dPOSUHRFAK)        CPOS( 78,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 2
    TYPE(Text) CAPTION(Datum vystavení ...)      CPOS(  1,3.5)
    TYPE(Text) NAME(FAKVYSHD->dVYSTFAK)          CPOS( 25,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Celkem uhrazeno ... )     CPOS( 57,3.5)
    TYPE(Text) NAME(FAKVYSHD->nUHRcelFAK)        CPOS( 78,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) NAME(FAKVYSHD->cZKRATmeny)        CPOS( 92,3.5) CLEN( 5) FONT(5)
    TYPE(Text) NAME(FAKVYSHD->nUHRcelFAZ)        CPOS( 78,4.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(FAKVYSHD->cZKRATmenz)        CPOS( 92,4.5) CLEN( 5) FONT(5)
* 3
    TYPE(Text) CAPTION(Datum splatnosti ... )    CPOS(  1,4.5) 
    TYPE(Text) NAME(FAKVYSHD->dSPLATFAK)         CPOS( 25,4.5) CLEN(13) BGND(13) PP(2) CTYPE(2)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* úhrady
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(13,74) CAPTION(úhrady) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Úhrady pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.2) FILE(FAKVYSHDuw);  
                                           FIELDS(NDOKLAD:doklad         , ;
                                                  DSPLATFAK:splDne       , ;
                                                  DDATUHRADY:uhrDne      , ;
                                                  CBANK_UCT:bankÚèet     , ;
                                                  NPOKLADNA:èísPokl      , ;
                                                  CBANK_NAZ:uhrazeno_z:21, ;   
                                                  NCENZAKCEL:úhrCelkem     ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny)
  TYPE(End)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.2) FILE(UCETPOL);  
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
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(37,50) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.2) FILE(VYKDPH_I)                                 ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:44, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(1) SCROLL(ny)
  TYPE(END)