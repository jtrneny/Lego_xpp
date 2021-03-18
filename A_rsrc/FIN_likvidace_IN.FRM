TYPE(drgForm) DTYPE(10) TITLE(Likvidace ) SIZE(100,24) FILE (UCETPOLw)   ;
                                          POST(postValidate)             ;
                                          GUILOOK(Action:n)


  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,7) STYPE(13) CTYPE(2) 
    TYPE(TEXT) CAPTION(celkem_Dokl)   CPOS( 2,0.8) CLEN(10)
    TYPE(TEXT) NAME(M->nCENZAKCEL)    CPOS(14,0.8) CLEN(13) BGND(13) CTYPE(2)
    TYPE(GET)  NAME(M->cUCET_UCT)     FPOS(28,0.8) FLEN(10) PICTURE(@N XXXXXX) PUSH(lik_c_uctosn_hd)
    TYPE(Text) NAME(M->cnaz_uct_hd)   CPOS(40,0.8) CLEN(24) FONT(5)

    TYPE(TEXT) CAPTION(dph)    CPOS( 2,2.2) CLEN(4)
    TYPE(TEXT) CAPTION(základ) CPOS(14,2.2) CLEN(6)
    TYPE(TEXT) CAPTION(daò)    CPOS(28,2.2) CLEN(4)
*    TYPE(TEXT) CAPTION(úèet)   CPOS(42,2.2) CLEN(4)

    TYPE(STATIC) STYPE(2) FPOS(1,2.3) SIZE(45,3.9) CTYPE(2) 
      TYPE(TEXT) CAPTION(nulové)    CPOS( 1,1)
      TYPE(TEXT) NAME(M->nOSVODDAN) CPOS(13,1) CLEN(13) BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(snížené)  CPOS(1,2)
      TYPE(TEXT) NAME(M->nZAKLDAN_1) CPOS(13,2) CLEN(13) BGND(13) CTYPE(2)
      TYPE(TEXT) NAME(M->nSAZDAN_1)  CPOS(27,2) CLEN(15) BGND(13) CTYPE(2)
*      TYPE(TEXT) NAME(M->cUCETDAN_1) CPOS(41,2) CLEN( 8) BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(základní) CPOS(1,3)
      TYPE(TEXT) NAME(M->nZAKLDAN_2) CPOS(13,3) CLEN(13) BGND(13) CTYPE(2)
      TYPE(TEXT) NAME(M->nSAZDAN_2)  CPOS(27,3) CLEN(15) BGND(13) CTYPE(2)
*      TYPE(TEXT) NAME(M->cUCETDAN_2) CPOS(41,3) CLEN( 8) BGND(13) CTYPE(2)
    TYPE(END)

* P
    TYPE(COMBOBOX) NAME(M->obdLikv)   FPOS(80,0.8) FLEN(12) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(68,0.8) PP(2)
    TYPE(TEXT)     CAPTION(èíslo_Dokl) CPOS(68,2.5) 
    TYPE(TEXT)     NAME(M->nDOKLAD)    CPOS(80,2.5) CLEN(17) BGND(13) CTYPE(2) FONT(5)

    TYPE(TEXT)     CAPTION(var_Symbol) CPOS(68,3.5) 
    TYPE(GET)      NAME(M->CVARSYM)    FPOS(80,3.5) FLEN(16) FONT(5)
*-    TYPE(TEXT)     NAME(M->cVARSYM)    CPOS(80,3.5) CLEN(17) BGND(13) FONT(5)

    TYPE(TEXT)     CAPTION(dat_Vyst)   CPOS(68,4.5) 
    TYPE(TEXT)     NAME(M->dVYSTDOK)   CPOS(80,4.5) CLEN(17) BGND(13) FONT(5)

    TYPE(TEXT)     CAPTION(dat_Splatn) CPOS(68,5.5) 
    TYPE(TEXT)     NAME(M->dSPLATDOK)  CPOS(80,5.5) CLEN(17) BGND(13) FONT(5)
  TYPE(End)

  TYPE(STATIC) FPOS(0.4,7.5) SIZE(99.2,16) STYPE(12) CTYPE(2)
    TYPE(STATIC) STYPE(12) SIZE(99.2,4.1) FPOS(0,0) CTYPE(2)

    TYPE(GET) NAME(UCETPOLw->cUCETMD)   FPOS(15,0.5) FLEN( 8) FCAPTION(SuAu_S)       CPOS( 1,0.5) PP(2) GROUPS(1)
    TYPE(Text) NAME(M->cnaz_uct_it)     CPOS(25,0.5) CLEN(24) 
    TYPE(GET) NAME(UCETPOLw->cSYMBOL)   FPOS(15,1.5) FLEN(15) FCAPTION(pár_Symbol)   CPOS( 1,1.5)
    TYPE(GET) NAME(UCETPOLw->cTEXT)     FPOS(15,2.5) FLEN(35) FCAPTION(text_Položky) CPOS( 1,2.5)

      TYPE(GET)  NAME(M->nkcmdd)           FPOS(76,0.5) FLEN(13) FCAPTION(celkem_Pol)   CPOS(58,0.5) PICTURE(@N 999999999999.99)
      TYPE(TEXT) NAME(M->cZAKLMENA)        CPOS(91,0.5) CLEN( 6) BGND(13)      

      TYPE(GET)  NAME(UCETPOLw->nMNOZNAT)   FPOS(76,1.5) FLEN(13) FCAPTION(možsví_Pol)   CPOS(58,1.5)
      TYPE(GET)  NAME(UCETPOLw->cZKRATJEDN) FPOS(91,1.5) FLEN( 5) 

      TYPE(GET)  NAME(UCETPOLw->nMNOZNAT2)  FPOS(76,2.5) FLEN(13) FCAPTION(možsví_Pol_2) CPOS(58,2.5)
      TYPE(GET)  NAME(UCETPOLw->cZKRATJED2) FPOS(91,2.5) FLEN( 5)
    TYPE(End)

* NS
    TYPE(GET) NAME(UCETPOLw->cNAZPOL1) FPOS(  3,5.4) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.4) CLEN(10)
    TYPE(GET) NAME(UCETPOLw->cNAZPOL2) FPOS( 19,5.4) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.4) CLEN( 8)
    TYPE(GET) NAME(UCETPOLw->cNAZPOL3) FPOS( 35,5.4) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.4) CLEN( 8)
    TYPE(GET) NAME(UCETPOLw->cNAZPOL4) FPOS( 51,5.4) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.4) CLEN( 8)
    TYPE(GET) NAME(UCETPOLw->cNAZPOL5) FPOS( 67,5.4) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.4) CLEN( 8)
    TYPE(GET) NAME(UCETPOLw->cNAZPOL6) FPOS( 83,5.4) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.4) CLEN(10)  

    TYPE(STATIC) FPOS(0.4,5) SIZE(98.6,.1) STYPE(12)
    TYPE(End)

    TYPE(DBrowse) FPOS(.4,7) SIZE(98.4,8.8) FILE(UCETPOLw) INDEXORD(2) ;
                                            FIELDS(M->stavPol::2.7::2              , ;
                                                   nORDITEM:úèPol                  , ;
                                                   M->subUcto::5::2                , ;
                                                   cTEXT:text Položky:26           , ;
                                                   nMNOZNAT:množstvíPol            , ; 
                                                   nMNOZNAT2:množstvíPol2          , ; 
                                                   cUCETDAL:SuAu_ø                 , ; 
                                                   cUCETMD:SuAu_s                  , ;
                                                   FIN_likvidace_BC(8):celkemPol:13, ;
                                                   cTYP_R:typ                        ) ;
                                            CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy) STABLEBLOCK(stableBlock)
  TYPE(End)
