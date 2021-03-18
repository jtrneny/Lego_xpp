TYPE(drgForm) DTYPE(10) TITLE(Èíselník zamìstnacù a záloh na pokladnì ...) SIZE(100,17) ;
              GUILOOK(Action:n) ;
              PRE(preValidate) POST(postValidate)  


* Browser definition
  TYPE(DBrowse) FPOS( .2,.2) SIZE(99.6, 7) FILE(C_ZAMEST)                             ;  
                                           FIELDS(FIN_c_zamest_BC(1):zál:2.7::2      , ;
                                                nOSCISPRAC:èísloPrac               , ;
                                                cPRACOVNIK:Jméno a pøíjmení:30     , ;
                                                cNAZPOL1:støPrac                   , ;
                                                CNAZPOL1->cNAZEV:názevStøediska:47 ) ;
                                          ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7)


 TYPE(DBrowse) FPOS(0,9.4) SIZE(100, 7.5) FILE(POKZA_ZA)                                 ;
                                          FIELDS(nPOKLADNA:pokladna                   , ;
                                                 FIN_c_zamest_BC(22):název pokladny:37, ;
                                                 nPRIJ_ZAL:pøijatá Záloha             , ;
                                                 FIN_c_zamest_BC(24): :2.7::2         , ;
                                                 nVRAC_ZAL:vrácená Záloha             , ;
                                                 FIN_c_zamest_BC(26): :2.7::2         , ;  
                                                 FIN_c_zamest_BC(27):vrácená Záloha:13, ;    
                                                 POKLADMS->cZKRATMENY:mìna              )  CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7)

* CARDS *
  TYPE(Static) STYPE(13) SIZE(99.2,2) FPOS(.4,7.2) RESIZE(y)
    TYPE(TEXT) CAPTION(Pracovník/Støedisko ...)  CPOS( 1,  .5) CLEN(20) PP(3) BGND( 1) FONT(5) 
    TYPE(GET)  NAME(C_ZAMEST->nOSCISPRAC)        FPOS(21,  .5) FLEN( 8)       BGND(13)                                                POST(drgPostUniqueKey)
    TYPE(TEXT) CAPTION(/)                        CPOS(31,  .5) CLEN( 2)
    TYPE(GET)  NAME(C_ZAMEST->cNAZPOL1)          FPOS(33,  .5) FLEN(10)
    TYPE(GET)  NAME(C_ZAMEST->cPRACOVNIK)        FPOS(47,  .5) FLEN(35)                         
    TYPE(CHECKBOX) NAME(C_ZAMEST->lPRI_ZAL)      FPOS(96,  .5) FLEN( 3)  VALUES(T: ,F: ) FCAPTION(pøijZáloha ...) CPOS(84, .5) FONT(5) POST(postLastField)
  TYPE(End)