TYPE(drgForm) DTYPE(10) TITLE(Trvalé závazky - mzdy ...) SIZE(105,25)                                      ;
                                                         OBDOBI(MZD)                                       ;
                                                         CARGO(MZD_trvZavhd_IN)                            ;
                                                         PRINTFILES(trvzavhd:ncisfak=ncisfak,              ;
                                                                    ucetpol:cdenik=cdenik+ndoklad=ncisfak) 


*                                                   CARGO(FIN_trvzavhd_IT_IN) OBDOBI(FIN)               ;

*  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
*  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)
*
*-  TYPE(Action) CAPTION(~Maximize)   EVENT(W_maximize)       TIPTEXT(Maximalizuji okno)


  TYPE(DBrowse) FPOS(.5,.1) SIZE(104.5,15) FILE(trvzavhd)                         ;
                                          FIELDS(cTypPohybu:typZávazku          , ; 
                                                 nCISFAK::10                    , ;
                                                 cVARSYM::15                    , ;
                                                 cNAZEV::24                     , ;
                                                 cTEXTFAKT::22                  , ;
                                                 nCENzakCEL::12:::1             , ;
                                                 nCENzahCEL::12:::1             , ;
                                                 nosvoddan:osvobozeno           , ; 
                                                 nzakldan_1:základ(sd)          , ;
                                                 nsazdan_1:sazba(sd)            , ;
                                                 nzakldan_2:základ(zd)          , ;
                                                 nsazdan_2:sazba(zd)            , ;
                                                 ncenfakcel:celkfakcena         , ;
                                                 cZkratMenZ:mìnaZahr            , ;
                                                 cZkratMeny:mìnaZákl            , ;
                                                 nparZalFak                     , ;
                                                 nparZahFak                       ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y) FOOTER(yy)


* info
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
* L
    TYPE(STATIC) STYPE(2) FPOS(0,0) SIZE(52,6)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(5,-.15) CLEN(10)

      TYPE(TEXT) CAPTION(Úèet ...  )         CPOS( 1,1)  
        TYPE(TEXT) NAME(trvZavhd->cucet)     CPOS(12,1) CLEN(28) BGND(13)
        TYPE(TEXT) CAPTION([)                CPOS(42,1) CLEN( 2)
        TYPE(TEXT) NAME(trvZavHd->ncisFirmy) CPOS(43,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
        TYPE(TEXT) CAPTION(])                CPOS(49,1) CLEN( 2)

     TYPE(TEXT) CAPTION(IÈO/DIèo ...  )      CPOS( 1,2) CLEN(10)
       TYPE(TEXT) NAME(trvZavhd->nico)       CPOS(12,2) CLEN( 8) BGND(13)
       TYPE(TEXT) NAME(trvZavhd->cdic)       CPOS(22,2) CLEN(28) BGND(13)

     TYPE(TEXT) CAPTION(Název ...  )         CPOS( 1,3)
       TYPE(TEXT) NAME(trvZavhd->cnazev)     CPOS(12,3) CLEN(38) BGND(13)
       TYPE(TEXT) NAME(trvZavhd->vnazev2)    CPOS(12,2) CLEN(38) BGND(13)

     TYPE(TEXT) CAPTION(Ulice ...  )         CPOS( 1,4)
       TYPE(TEXT) NAME(trvZavhd->culice)     CPOS(12,4) CLEN(38) BGND(13)

     TYPE(TEXT) CAPTION(Místo ...  )         CPOS( 1,5)
       TYPE(TEXT) NAME(trvZavhd->cpsc)       CPOS(12,5) CLEN( 8) BGND(13)
       TYPE(TEXT) NAME(trvZavhd->csidlo)     CPOS(22,5) CLEN(28) BGND(13)
    TYPE(END)

* P
    TYPE(STATIC) STYPE(2) FPOS(53,0) SIZE(51,6)
      TYPE(TEXT) CAPTION(Zpùsob gen ... )       CPOS( 1,1) CLEN(12)
        TYPE(TEXT) NAME(trvZavhd->czpusSraz)    CPOS(13,1) CLEN(11) BGND(13)
        TYPE(TEXT) NAME(c_zpuSrz->cpopisZPsr)   CPOS(25,1) 

      TYPE(TEXT) CAPTION(Perioda gen ...)       CPOS( 1,2) CLEN(12)  
        TYPE(TEXT) NAME(trvZavhd->cPerioda)     CPOS(13,2) CLEN(11) BGND(13)
        TYPE(TEXT) NAME(c_period->cnazPeriod)   CPOS(25,2)

      TYPE(TEXT) CAPTION(Generovat od - do ...) CPOS( 1,3) CLEN(12) 
        TYPE(TEXT) NAME(trvZavhd->dgenerovat)   CPOS(13,3) CLEN(11) BGND(13)
        TYPE(TEXT) NAME(trvZavhd->dgenerLast)   CPOS(26,3) CLEN(11) BGND(13)

      TYPE(TEXT) CAPTION(Uhradit celkem  ...)   CPOS( 1,5)
        TYPE(TEXT) NAME(trvZavhd->ncenZahCel)   CPOS(26,5) CLEN(17) BGND(13)
    TYPE(END)

* 7
    TYPE(Text) CAPTION(VE PROSPÌCH ÚÈTU ... ) CPOS(  1,6.7)
    TYPE(Text) NAME(trvZavhd->cUCET)          CPOS( 22,6.7) CLEN(25) BGND(13) PP(2)
* 8
    TYPE(Text) CAPTION(NA VRUB ÚÈTU ... ) CPOS( 53,6.7) 
    TYPE(Text) NAME(trvZavhd->cBANK_UCT)  CPOS( 73,6.7) CLEN(25) BGND(13) PP(2)

* tabPage se nemá kam potavit na focus - !
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* generované závazky mzdZavhd
  TYPE(TABPAGE) FPOS(.5,15.8) SIZE(104.5,9) TTYPE(3) OFFSET(13,74) CAPTION(genZávazky) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Generované mzdové závazky) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(104.8,6.8) FILE(mzdZavhd)                        ;  
                                          FIELDS(cOBDOBI:Obd:5                  , ;  
                                                 nCISFAK:doklad:10              , ;
                                                 cVARSYM::15                    , ;
                                                 cNAZEV::24                     , ;
                                                 cTEXTFAKT:text dokladu:22      , ;
                                                 nCENzakCEL::12:::1             , ;
                                                 nCENzahCEL::12:::1             , ;
                                                 nosvoddan:osvobozeno           , ; 
                                                 nzakldan_1:základ(sd)          , ;
                                                 nsazdan_1:sazba(sd)            , ;
                                                 nzakldan_2:základ(zd)          , ;
                                                 nsazdan_2:sazba(zd)            , ;
                                                 ncenfakcel:celkfakcena         , ;
                                                 cZkratMenZ:mìnaZahr            , ;
                                                 cZkratMeny:mìnaZákl              ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)

  TYPE(END)

