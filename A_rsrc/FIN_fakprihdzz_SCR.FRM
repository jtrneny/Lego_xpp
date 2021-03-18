TYPE(drgForm) DTYPE(10) TITLE(Faktury pøijaté - zálohové ...) SIZE(105,25) ;
                                                              CARGO(FIN_UCETDOHDZZ_IN) ;
                                                              OBDOBI(FIN) ;
                                                              PRINTFILES(fakprihd:ndoklad=ndoklad, ;
                                                                         ucetdohd:ncisfak=ndoklad, ;
                                                                         ucetdoit:ndoklad=ndoklad, ; 
                                                                         ucetpol:cdenik=cdenik+ndoklad=ndoklad)


*  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)

  TYPE(DBrowse) FPOS(.2,.2) SIZE(104.7,7.7) FILE(FAKPRIHD)                          ;
                                           FIELDS(M->oinf|hrazeno:H:2.6::2       , ;
                                                  M->oinf|prikazy:P:2.6::2       , ;
                                                  M->oinf|danuzav:D:2.6::2       , ;
                                                  M->oinf|likvidace:L:2.6::2     , ;
                                                  M->oinf|ucuzav:U:2.6::2        , ;
                                                  nCISFAK                        , ;
                                                  cVARSYM:VarSymbol              , ;
                                                  cNAZEV:Název dodavatele:21     , ;
                                                  CTEXTFAKT:Text faktury:20      , ;
                                                  nCENZAKCEL                     , ;
                                                  CUCET_UCT:SuAu_Ø                 ) ;
                                           CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked) PRE(InFocus) ATSTART(LAST) POPUPMENU(y)

  TYPE(Static) STYPE(13) SIZE(104.2,16.5) FPOS(.5,8.0) CTYPE(2) RESIZE(yx)
    TYPE(Static) STYPE(14) SIZE(103.6,10) FPOS(.4,.06) CTYPE(2) RESIZE(yx)
* L
      TYPE(TEXT) CAPTION(OBD_úèetní)        CPOS( 3, .5)
      TYPE(TEXT) NAME(UCETDOHD->cOBDOBI)    CPOS(18,0.5) CLEN(5)           BGND(13)
      TYPE(TEXT) CAPTION(Datum poøízení)    CPOS( 3,1.5)
      TYPE(TEXT) NAME(UCETDOHD->dPORIZDOK)  CPOS(18,1.5) CLEN(11)          BGND(13)
      TYPE(TEXT) CAPTION(Doklad)            CPOS( 3,2.5)
      TYPE(TEXT) NAME(UCETDOHD->nDOKLAD)    CPOS(18,2.5) CLEN(11) CTYPE(2) BGND(13)
      TYPE(TEXT) CAPTION(SuAu_Ø)            CPOS( 3,3.5) CLEN(10)
      TYPE(TEXT) NAME(UCETDOHD->cUCET_UCT)  CPOS(18,3.5) CLEN(11)          BGND(13)
      TYPE(TEXT) CAPTION(Text dokladu)      CPOS( 3,4.5)
      TYPE(TEXT) NAME(UCETDOHD->cTEXTDOK)   CPOS(18,4.5) CLEN(40)          BGND(13)
* S
      TYPE(TEXT) CAPTION(OBD_daòové)        CPOS(30,0.5)
      TYPE(TEXT) NAME(UCETDOHD->cOBDOBIDAN) CPOS(43,0.5) CLEN( 5)          BGND(13)
* P
      TYPE(TEXT) CAPTION(Doklad úhrady)     CPOS(62,1.5)
      TYPE(TEXT) NAME(UCETDOHD->cKEYS_PZ)   CPOS(75,1.5) CLEN(25)          BGND(13)
      TYPE(TEXT) CAPTION(Èíslo faktury)     CPOS(62,2.5)
      TYPE(TEXT) NAME(UCETDOHD->nCISFAK)    CPOS(75,2.5) CLEN(15) CTYPE(2) BGND(13)
      TYPE(TEXT) CAPTION(VarSymbol)         CPOS(62,3.5)
      TYPE(TEXT) NAME(UCETDOHD->cVARSYM)    CPOS(75,3.5) CLEN(15)          BGND(13)
      TYPE(TEXT) CAPTION(Celkem/TYP)        CPOS(62,4.5)
      TYPE(TEXT) NAME(UCETDOHD->nCENZAKCEL) CPOS(75,4.5) CLEN(15) CTYPE(2) BGND(13)
      TYPE(TEXT) NAME(UCETDOHD->cTYPOBRATU) CPOS(91,4.5) CLEN( 8)          BGND(13)
* DPH
      TYPE(TEXT) CAPTION(daò z pøidané hodnoty) CPOS( 3,5.4) CLEN(20) FONT(2)
      TYPE(TEXT) CAPTION(Datum uzp      ___)    CPOS( 3,6.6) CLEN(15)
      TYPE(TEXT) NAME(UCETDOHD->DVYSTDOK)       CPOS(18,6.7) CLEN(13)          BGND(13)
      TYPE(TEXT) CAPTION(Bez danì        ___)   CPOS( 3,8.6) CLEN(15)
      TYPE(TEXT) NAME(UCETDOHD->NOSVODDAN)      CPOS(18,8.6) CLEN(13) CTYPE(2) BGND(13)
 
      TYPE(TEXT) CAPTION(Sazba danì    ____)    CPOS(38,6.6) CLEN(15)
      TYPE(TEXT) CAPTION(Základ danì   ____)    CPOS(38,7.6) CLEN(15)
      TYPE(TEXT) CAPTION(Odvod danì   ____)     CPOS(38,8.6) CLEN(15)

      TYPE(TEXT) NAME(UCETDOHD->nPROCDAN_3)     CPOS(57,6.5) CLEN( 8) CTYPE(2) BGND(12) FONT(5)
      TYPE(TEXT) CAPTION(%)                     CPOS(65,6.6) CLEN( 3)
      TYPE(TEXT) NAME(UCETDOHD->NZAKLDAN_3)     CPOS(55,7.6) CLEN(13) CTYPE(2) BGND(13)
      TYPE(TEXT) NAME(UCETDOHD->NSAZDAN_3)      CPOS(55,8.6) CLEN(13) CTYPE(2) BGND(13)

      TYPE(TEXT) NAME(UCETDOHD->nPROCDAN_1)     CPOS(72,6.5) CLEN( 8) CTYPE(2) BGND(12) FONT(5)
      TYPE(TEXT) CAPTION(%)                     CPOS(80,6.6) CLEN( 3)
      TYPE(TEXT) NAME(UCETDOHD->NZAKLDAN_1)     CPOS(70,7.6) CLEN(13) CTYPE(2) BGND(13)
      TYPE(TEXT) NAME(UCETDOHD->NSAZDAN_1)      CPOS(70,8.6) CLEN(13) CTYPE(2) BGND(13)

      TYPE(TEXT) NAME(UCETDOHD->nPROCDAN_2)     CPOS(87,6.5) CLEN( 8) CTYPE(2) BGND(12) FONT(5)
      TYPE(TEXT) CAPTION(%)                     CPOS(95,6.6) CLEN( 3)
      TYPE(TEXT) NAME(UCETDOHD->NZAKLDAN_2)     CPOS(85,7.6) CLEN(13) CTYPE(2) BGND(13)
      TYPE(TEXT) NAME(UCETDOHD->NSAZDAN_2)      CPOS(85,8.6) CLEN(13) CTYPE(2) BGND(13)

      TYPE(STATIC) FPOS(0.4,5.9) SIZE(102.6,.2) STYPE(13) RESIZE(yx)
      TYPE(End)
    TYPE(End)

    TYPE(DBrowse) FPOS(.5,10.3) SIZE(103.4,6) FILE(UCETDOHD)                         ;
                                              FIELDS(M->is_danDokUsed::2::2        , ;
                                                     M->oinf_ucd|tisk:T:2.6::2     , ;
                                                     M->oinf_ucd|danuzav:D:2.6::2  , ;
                                                     M->oinf_ucd|likvidace:L:2.6::2, ;
                                                     M->oinf_ucd|ucuzav:U:2.6::2   , ;
                                                     nDOKLAD:èísloDokl             , ;
                                                     cTEXTDOK:textDokladu:33       , ;
                                                     cVARSYM:varSymb               , ;
                                                     nCENzakCEL:celkDokl           , ;
                                                     cUCET_UCT:SuAu_Ø              , ;
                                                     cKEYS_PZ:dokladÚhrady:15        ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yn) INDEXORD(7)
  TYPE(End)
