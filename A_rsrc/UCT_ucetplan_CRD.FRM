TYPE(drgForm) DTYPE(10) TITLE(Pøehled plánu úètù ...) SIZE(100,23) ;
              GUILOOK(Action:n) ;
              POST(postValidate)  

*              CARGO(DIM_MSDIM_CRD) FILE(MSDIM) ;
*              CBSAVE(onSave)


* Browser definition
  TYPE(DBrowse) FPOS( 0,1) SIZE(100, 8.5) FILE(UCETPLAH)                           ;  
                                          FIELDS(nROK:Rok                        , ;
                                                 cUCETMD:SuAu_Ø:10               , ;
                                                 C_UCTOSN->cNAZ_UCT:Název úètu:45, ;
                                                 nPLANROK:Plán_ROK               , ;
                                                 cUSERABB:ZkrUživ:10             , ;
                                                 dDATZMENY:DatZmìny:12                ) ;
                                           ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(yy)


 TYPE(DBrowse) FPOS(0,15.4) SIZE(100, 7) FILE(UCETPLAN)                           ;
                                         FIELDS(cOBDOBI:ÚèObd                   , ;
                                                cUCETMD:SuAu_Ø                  , ;  
                                                C_UCTOSN->cNAZ_UCT:Název úètu:41, ;
                                                nPLANROK:Plán-ROK               , ;  
                                                nPLANZAOBD:Plán za-OBD          , ;
                                                nPLANKOBD:Plán k-OBD              ) CURSORMODE(3) SCROLL(ny) PP(5) RESIZE(yx)

 TYPE(Static) STYPE(12) SIZE(99.9,1.1) FPOS(0,0)
   TYPE(ComboBox) NAME(UCT_ucetplan_CRD:NROK) FPOS(84.7,.1) FLEN(15);
                  VALUES(a,a,a);
                  COMBOINIT(comboBoxInit);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)


* CARDS *
  TYPE(Static) STYPE(13) SIZE(99.2,5) FPOS(.4,9.9) GROUPS(1) RESIZE(yx)
* 1
    TYPE(Text) CAPTION(SuAu_Ø)            CPOS( 1,  .5) CLEN(10) PP(3) BGND( 1) FONT(5)
    TYPE(Get)  NAME(UCETPLAH->cUCETMD)    FPOS(13,  .5) FLEN(10) PP(2) BGND(13)         GROUPS(1)
    TYPE(Text) NAME(C_UCTOSN->cNAZ_UCT)   CPOS(25,  .5) CLEN(25) 

    TYPE(Text) CAPTION(Plán_ROK)          CPOS(50,  .5) CLEN(10) PP(3) BGND( 1) FONT(5)
    TYPE(Get)  NAME(UCETPLAH->nPLANROK)   FPOS(60,  .5) FLEN(12) PP(2) BGND(13)         GROUPS(1)  
    TYPE(Text) CAPTION(/)                 CPOS(74,  .5) CLEN( 2) 
    TYPE(Get)  NAME(UCETPLAH->nPOCOBD_PL) FPOS(76,  .5) FLEN( 4) PP(2) BGND(13)         GROUPS(1)  
    TYPE(Text) CAPTION(=)                 CPOS(82,  .5) CLEN( 2) 
    TYPE(Text) NAME(UCETPLAH->nPLANZAOBD) CPOS(85,  .5) CLEN(13) PP(3) BGND(13) CTYPE(2)

* 2
    TYPE(Static) STYPE(14) SIZE(21,.2) FPOS(60, 1.9) CTYPE(2) GROUPS(2) 
    TYPE(End)

    TYPE(Text) CAPTION(Plán_OBD)          CPOS(50, 1.5) CLEN(10) PP(3) BGND( 1) FONT(5)
    TYPE(Get)  NAME(UCETPLAN->nPLANZAOBD) FPOS(85, 1.6) FLEN(12) PP(2) BGND(13)         GROUPS(2) POST(postLastField)

    TYPE(Text) CAPTION(VýrStøedisko)      CPOS( 2, 2.6)          PP(3) BGND( 1) 
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL1)   FPOS( 2, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1) 
    TYPE(Text) FCAPTION(Výrobek)          CPOS(18, 2.6)          PP(3) BGND( 1) 
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL2)   FPOS(18, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1) 
    TYPE(Text) FCAPTION(Zakázka)          CPOS(34, 2.6)          PP(3) BGND( 1) 
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL3)   FPOS(34, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1)   
    TYPE(Text) FCAPTION(VýrMísto)         CPOS(50, 2.6)          PP(3) BGND( 1) 
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL4)   FPOS(50, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1)  
    TYPE(Text) FCAPTION(Stroj)            CPOS(66, 2.6)          PP(3) BGND( 1)
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL5)   FPOS(66, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1) 
    TYPE(Text) FCAPTION(VýrOperace)       CPOS(82, 2.6)          PP(3) BGND( 1) 
    TYPE(Get)  NAME(UCETPLAH->cNAZPOL6)   FPOS(82, 3.6) FLEN(13) PP(1) BGND(13)         GROUPS(1) POST(postLastField)

    TYPE(Static) STYPE(17) SIZE(98.8,.3) FPOS(.2,2.98) CTYPE(2)
    TYPE(End)
  TYPE(End)