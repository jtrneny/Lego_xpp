TYPE(drgForm) DTYPE(10) TITLE(Faktury pøijaté ...) SIZE(115,25)                                        ;
                                                   GUILOOK(Message:y,Action:n,IconBar:y:drgStdBrowseIconBar,Menu:y:myMenuBar);
                                                   OBDOBI(FIN)               ;
                                                   PRINTFILES(fakprihd:ncisfak=ncisfak,                ;
                                                              ucetpol:cdenik=cdenik+ndoklad=ncisfak) 


*  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
*  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
*
*  TYPE(Action) ATYPE(5)
*  TYPE(Action) ATYPE(5)
*  TYPE(Action) CAPTION(d~Oplòující      ) EVENT(createContext) TIPTEXT(možnost zmìny základních údajù dokladu)  ICON1(338) ATYPE(33)


  TYPE(DBrowse) FPOS(.5,.1) SIZE(114.5,15) FILE(FAKPRIHD)                              ;
                                           FIELDS( M->oinf|hrazeno:H:2.6::2          , ;
                                                   M->oinf|prikazy:P:2.6::2          , ;
                                                   cvarSym:varSymbol                 , ;
                                                   nCISFAK:èísloFaktury:10           , ;
                                                   nCISFIRMY:firma                   , ;
                                                   cNAZEV:názevFirmy:43              , ;
                                                   nICO:ièo                          , ;
                                                   dvystFak:datVyst                  , ;
                                                   dsplatFak:datSplat                , ; 
                                                   M->fakPrihd_dny_poSpl:poSpl:7     , ;
                                                   ncenZakCel:fakturováno v CZK::::1 , ;
                                                   nuhrCelFak:uhrazeno v CZK::::1    , ;
                                                   M->kuhrade_vzm:k úhradì v CZK::::1, ;
                                                   czkratMeny:mìnaZákl               , ;
                                                   ncenZahCel:fakurováno v zm::::1   , ;
                                                   nuhrcelfaz:uhrazeno v zm::::1     , ;
                                                   M->kuhrade_vcm:k úhradì v zm::::1 , ;
                                                   cZkratMenZ:mìnaZahr                 ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y) FOOTER(yy)


* info
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(114.5,9) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
* 1
      TYPE(Text) CAPTION(Úèetní období   ...) CPOS(  1, .5)   
      TYPE(Text) NAME(FAKPRIHD->NOBDOBI)      CPOS( 22, .5) CLEN( 5) BGND(13) PP(2)
      TYPE(Text) CAPTION(/)                   CPOS( 27, .5) CLEN( 2)  
      TYPE(Text) NAME(FAKPRIHD->NROK)         CPOS( 29, .5) CLEN( 6) BGND(13) PP(2)
      TYPE(Text) CAPTION(Daòové období ...)   CPOS( 70, .5) CLEN(14)
      TYPE(Text) NAME(FAKPRIHD->COBDOBIDAN)   CPOS( 84, .5) CLEN(10) BGND(13) PP(2) CTYPE(1)
      TYPE(Static) STYPE(17) SIZE(113,1) FPOS(.5, 1)
* 2
        TYPE(Text) CAPTION(FAKTURA   ... )    CPOS(  1,2.1)
        TYPE(Text) NAME(FAKPRIHD->nCENzakCEL) CPOS( 22,2.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,2.1) CLEN( 5) FONT(5)
        TYPE(Text) NAME(FAKPRIHD->nCENzahCEL) CPOS( 40,2.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,2.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(splatno)           CPOS( 70,2.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dSPLATfak)  CPOS( 84,2.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRtypUHR) CPOS( 96,2.1) CLEN( 5) BGND(13) PP(2)
* 4
        TYPE(Text) CAPTION(PØÍKAZY ... )      CPOS(  1,3.1) 
        TYPE(Text) NAME(FAKPRIHD->nPRIuhrCEL) CPOS( 22,3.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,3.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(dne)               CPOS( 70,3.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dDATpriUHR) CPOS( 84,3.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
* 5
        TYPE(Text) CAPTION(UHRAZENO ... )     CPOS(  1,4.1) 
        TYPE(Text) NAME(FAKPRIHD->nUHRcelFAK) CPOS( 22,4.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,4.1) CLEN( 5) FONT(5) 
        TYPE(Text) NAME(FAKPRIHD->nUHRcelFAZ) CPOS( 40,4.1) CLEN(13) BGND(13) PP(2) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,4.1) CLEN( 5) FONT(5)
        TYPE(Text) CAPTION(dne)               CPOS( 70,4.1) CLEN(10) 
        TYPE(Text) NAME(FAKPRIHD->dPOSuhrFAK) CPOS( 84,4.1) CLEN(10) BGND(13) PP(2) CTYPE(2)
* 6
        TYPE(Text) CAPTION(K ÚHRADÌ ... )     CPOS(  1,5.2) 
        TYPE(Text) NAME(M->KUHRADE_vzm)       CPOS( 22,5.2) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmeny) CPOS( 35,5.2) CLEN( 5) FONT(5)
        TYPE(Text) NAME(M->KUHRADE_vcm)       CPOS( 40,5.2) CLEN(13) BGND(13) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
        TYPE(Text) NAME(FAKPRIHD->cZKRATmenz) CPOS( 53,5.2) CLEN( 5) FONT(5)
        TYPE(Static) STYPE(17) SIZE(113,1) FPOS(.5, 5.6) 
* 7
          TYPE(Text) CAPTION(VE PROSPÌCH ÚÈTU ... ) CPOS(  1,6.7)
          TYPE(Text) NAME(FAKPRIHD->cUCET)          CPOS( 22,6.7) CLEN(25) BGND(13) PP(2)
* 8
          TYPE(Text) CAPTION(NA VRUB ÚÈTU ... ) CPOS( 70,6.7) CLEN(14)
          TYPE(Text) NAME(FAKPRIHD->cBANK_UCT)  CPOS( 84,6.7) CLEN(25) BGND(13) PP(2)

* tabPage se nemá kam potavit na focus - !
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* úhrady
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(114.5,9) TTYPE(3) OFFSET(13,74) CAPTION(úhrady) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Úhrady závazku) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(114.8,6.8) FILE(FAKPRIHDuw);  
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

