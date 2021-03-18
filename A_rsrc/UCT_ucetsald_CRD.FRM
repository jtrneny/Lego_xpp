TYPE(drgForm) DTYPE(10) TITLE(Oprava/Založení a rušení salda ...) SIZE(115,25) ;
              GUILOOK(Action:n) ;
              OBDOBI(UCT)       ;
              PRE(preValidate) POST(postValidate)  


* Browser definition
  TYPE(DBrowse) FPOS( 0,1.2) SIZE(115, 9.5) FILE(UCETSALK)                         ;  
                                          FIELDS(M->isClose_Salk:z:2.7::2        , ;
                                                 M->inUcetpol_Salk:l:2.7::2      , ;                                              
                                                 cUCETMD:SuAu_Ø                  , ;
                                                 M->nazUct_Salk:název úètu:31    , ;
                                                 cSYMBOL:varSymbol:15            , ;
                                                 cTEXT:text dokladu:25           , ;
                                                 nKCMD:Kè_md                     , ; 
                                                 nKCDAL:Kè_dal                     ) ;
                                           ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) 

 TYPE(DBrowse) FPOS(0,15.4) SIZE(115, 9.5) FILE(UCETSALD)                          ;
                                           FIELDS(M->inUcetpol_Sald:l:2.7::2     , ; 
                                                  M->obd_Sald:období:8           , ;   
                                                  cDENIK:deník                   , ;
                                                  nDOKLAD:èísloDokladu           , ;
                                                  cSYMBOL:varSymbol:19           , ;
                                                  cTEXT:text dokladu:38          , ;
                                                  nKCMD:Kè_md                    , ; 
                                                  nKCDAL:Kè_dal                    )  ;
                                           ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(9) SCROLL(ny) PP(7) RESIZE(yx)

 TYPE(Static) STYPE(13) SIZE(114.5,1.2) FPOS(.2,.01) RESIZE(y)
*   TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(65,.1) FLEN(22) ;
*                  VALUES(a,a,a,a,a,a,a,a,a);
*                  COMBOINIT(comboBoxInit);
*                  ITEMSELECTED(comboItemSelected) 

   TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(93.9,.1) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
 TYPE(END)

* CARDS *
  TYPE(Static) STYPE(13) SIZE(114.2,4) FPOS(.4,10.9) RESIZE(y)
* 1
    TYPE(TEXT) CAPTION(SuAu_Ø____)        CPOS( 1,  .5) CLEN(12) PP(3) BGND( 1) FONT(5) 
    TYPE(GET)  NAME(UCETSALD->cUCETMD)    FPOS(13,  .5) FLEN(10) PP(2)                   GROUPS(FT)

    TYPE(TEXT) NAME(C_UCTOSN->cNAZ_UCT)   CPOS(25,  .5) CLEN(25) 
    TYPE(TEXT) CAPTION(Kè_md)             CPOS(82,  .5) CLEN(10) PP(3) BGND( 1) FONT(5)
    TYPE(TEXT) CAPTION(Kè_dal)            CPOS(97,  .5) CLEN(10) PP(3) BGND( 1) FONT(5)
* 2
    TYPE(TEXT) CAPTION(varSymbol__)       CPOS( 1, 1.5) CLEN(12) PP(3) BGND( 1) FONT(5) 
    TYPE(GET)  NAME(UCETSALD->cSYMBOL)    FPOS(13, 1.5) FLEN(10) PP(2)      

    TYPE(GET)  NAME(UCETSALD->nKCMD)      FPOS(80, 1.5) FLEN(14)       BGND(13)          GROUPS(FT)
    TYPE(GET)  NAME(UCETSALD->nKCDAL)     FPOS(98, 1.5) FLEN(14)       BGND(13)          GROUPS(FT)
* 3
    TYPE(TEXT) CAPTION(Doklad_____)        CPOS( 1, 2.5) CLEN(12) PP(3) BGND( 1) FONT(5) 

    TYPE(GET)  NAME(UCETSALD->nDOKLAD)    FPOS(13, 2.5) FLEN(10)       BGND(13)          GROUPS(FT)
    TYPE(COMBOBOX) NAME(UCETSALD->cDENIK) FPOS(25, 2.5) FLEN(28) PP(2) ;
                   VALUES(a,a,a,a,a,a,a,a,a,a,a) ;
                   COMBOINIT(comboBoxInit);
                   ITEMSELECTED(comboItemSelected)                                       GROUPS(FT)

    TYPE(TEXT) CAPTION(Text dokladu)      CPOS(67, 2.5) CLEN(13) PP(3) BGND( 1) FONT(5)
    TYPE(GET)  NAME(UCETSALD->cTEXT)      FPOS(80, 2.5) FLEN(32)       BGND( 1) FONT(5)
  TYPE(End)