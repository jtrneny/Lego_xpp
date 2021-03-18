TYPE(drgForm) DTYPE(10) TITLE(Faktury vystavené ...) SIZE(100,25) ; 
                                                     PRINTFILES(trvpohhd:ncisfak=ncisfak, ;
                                                                trvpohit:ncisfak=ncisfak, ;
                                                                ucetpol:cdenik=cdenik+ndoklad=ncisfak) 

  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
  TYPE(Action) CAPTION(~DodacíList) EVENT(fin_dodlsthd)     TIPTEXT(Pøipojený dodací list)
  TYPE(Action) CAPTION(~Výdejka)    EVENT(fin_pvphead)      TIPTEXT(Pøipojené výdejky)
*                         
  TYPE(DBrowse) SIZE(100,10.5) FILE(TRVPOHHD)                    ;
                              FIELDS(cZKRTYPPOH                , ;  
                                     nCISFIRMY:firma           , ; 
                                     nCISFAK:èísloFak          , ;
                                     cVARSYM:varSymb:15        , ;
                                     cNAZEV::25                , ;
                                     nCENzahCEL:celkFak:13:::1 , ;
                                     cZKRATmenz:mìna           , ;
                                     czkrtypuhr:zkrÚhrady      , ;
                                     nosvoddan:osvobozeno::::1 , ; 
                                     nzakldan_1:základ(sd)     , ;
                                     nsazdan_1:sazba(sd)       , ;
                                     nzakldan_2:základ(zd)     , ;
                                     nsazdan_2:sazba(zd)       , ; 
                                     nCISFIRDOA:dodadr         , ;
                                     cNAZEVDOA:dodací adresa:25, ;
                                     nKLICOBL:region           , ;  
                                     ncenfakcel:celkfakcena    ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)  FOOTER(yy)

* info
  TYPE(Static) FPOS(1,10.8) SIZE(98,4) STYPE(13) RESIZE(yx)
* 1
    TYPE(Text) CAPTION(Datum uskuteènìní ZP ...) CPOS(  1, .5)
    TYPE(Text) NAME(TRVPOHHD->dPOVINFAK)         CPOS( 25, .5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) CAPTION(Datum úhrady      ...)    CPOS( 57, .5) 
    TYPE(Text) NAME(TRVPOHHD->dPOSUHRFAK)        CPOS( 78, .5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 2
    TYPE(Text) CAPTION(Datum vystavení ...)      CPOS(  1,1.5)
    TYPE(Text) NAME(TRVPOHHD->dVYSTFAK)          CPOS( 25,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Celkem uhrazeno ... )     CPOS( 57,1.5)
    TYPE(Text) NAME(TRVPOHHD->nUHRcelFAK)        CPOS( 78,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) NAME(TRVPOHHD->cZKRATmeny)        CPOS( 92,1.5) CLEN( 5) FONT(5)
    TYPE(Text) NAME(TRVPOHHD->nUHRcelFAZ)        CPOS( 78,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(TRVPOHHD->cZKRATmenz)        CPOS( 92,2.5) CLEN( 5) FONT(5)
* 3
    TYPE(Text) CAPTION(Datum splatnosti ... )    CPOS(  1,2.5) 
    TYPE(Text) NAME(TRVPOHHD->dSPLATFAK)         CPOS( 25,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
  TYPE(End)


* položky
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
*                                     7.6
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(TRVPOHIT)                 ;
                                           FIELDS(nCISFAK:èísFak:10     , ;
                                                  cNAZZBO:název zboží:35, ;
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
  TYPE(TABPAGE) FPOS(.5,15.1) SIZE(99.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(genPohl) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Generované pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,7.6) FILE(FAKVYSHD);  
                              FIELDS(cOBDOBI::5                , ;  
                                     nCISFIRMY:firma           , ; 
                                     nCISFAK:èísloFak          , ;
                                     cVARSYM:varSymb:15        , ;
                                     cNAZEV::25                , ;
                                     nCENzahCEL:celkFak:13:::1 , ;
                                     cZKRATmenz:mìna           , ;
                                     czkrtypuhr:zkrÚhrady      , ;
                                     nosvoddan:osvobozeno::::1 , ; 
                                     nzakldan_1:základ(sd)     , ;
                                     nsazdan_1:sazba(sd)       , ;
                                     nzakldan_2:základ(zd)     , ;
                                     nsazdan_2:sazba(zd)       , ; 
                                     nCISFIRDOA:dodadr         , ;
                                     cNAZEVDOA:dodací adresa:25, ;
                                     nKLICOBL:region           , ;  
                                     ncenfakcel:celkfakcena    ) ;
                                     CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
  TYPE(End)

