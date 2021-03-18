TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - dle pracovníkù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_doklhrmz_CRD) OBDOBI(MZD) PRINTFILES(mzddavhd:croobcpppv=croobcpppv, ;                                     
                                                                                         mzddavit:croobcpppv+ndoklad=croobcpppv+ndoklad, ;                                                                                                                                       mzdyit:croobcpppv=croobcpppv, ;                                     
                                                                                         tmprinemw  )                  ;  
                                                                              COMMFILES( tmprinemw )  

TYPE(Action) CAPTION(~Imp_MZLI)   EVENT(mzd_importdokl_ml)    TIPTEXT(Import mzdových lístkù z výroby)
TYPE(Action) CAPTION(ImpD~OCH)    EVENT(mzd_importdokl_doch)  TIPTEXT(Import docházky do mezd)
TYPE(Action) CAPTION(Imp_~VypDan) EVENT(mzd_import_vypDan)    TIPTEXT(Import vypoètené roèní danì)
TYPE(Action) CAPTION(GenDok~Mask) EVENT(mzd_genDoklZMasky)    TIPTEXT(Generování dokladù z pøeddefinovaných šablon-masek)


TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(100,10) RESIZE(YN)

  TYPE(DBrowse) FPOS(0.3,1.5) SIZE(98.6,8) FILE(MSPRC_MO)                    ;
                INDEXORD(9)                                                  ;
                FIELDS( M->ind_staVypCM::2.4::2                            , ;
                        M->is_Stavem::2.4::2                               , ;
                        M->in_msMzdyhd::2.4::2                             , ;
                        cDruPraVzt                                         , ;
                        nOsCisPrac                                         , ;
                        nPorPraVzt                                         , ;
                        cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30, ;
                        nTypPraVzt                                         , ;
                        nTypZamVzt                                         , ;
                        cKmenStrPr                                         , ;
                        dDatNast                                           , ;
                        dDatPredVy                                         , ;
                        dDatVyst                                           , ;
                        nTypUkoPrv                                         , ;
                        ncisOsoby                                          , ;   
                        nROK                                               , ;                         
                        nOBDOBI                                              ) ;
                 CURSORMODE(3) PP(7) ITEMMARKED(itemmarked) POPUPMENU(y) RESIZE(yx)

*** QUICK FILTR ***
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yx)
    TYPE(TEXT) NAME( msPrc_mo->cJmenoRozl)            CPOS( 1.5, 0.6) FONT(5)  CLEN(30) 
    TYPE(TEXT) CAPTION([ )                            CPOS(31.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( msPrc_mo->nosCisPrac)            CPOS(33  , 0.6)          PICTURE(999999) 
    TYPE(TEXT) CAPTION(/)                             CPOS(38.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( msPrc_mo->nporPraVzt)            CPOS(40  , 0.6)          PICTURE(999) 
    TYPE(TEXT) CAPTION(] )                            CPOS(42.5, 0.6)          CLEN( 2)

*    TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)

     TYPE(STATIC) STYPE(2) FPOS(74.50,0.09) SIZE(23.2,1.0) RESIZE(nx)
       TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
     TYPE(END) 
  TYPE(END)
TYPE(END)


TYPE(STATIC) STYPE( 13) FPOS(0.3,10.1) SIZE(99.5,15) RESIZE(YY)

TYPE(DBrowse) FPOS(0.1,0.1) SIZE(99,7) FILE(MZDDAVHD) INDEXORD(1)  ;
              FIELDS(M->typDokladu:T:2.6::2                        , ;
                     M->autoGen_From::1                            , ; 
                     cObdobi:Obd                                   , ;
                     nDoklad::10                                   , ;
                     dDatPoriz                                     , ; 
                     cKmenStrPr:Støed:6                            , ; 
                     nOsCisPrac:OsÈís                              , ;
                     nPorPraVzt:PoøPV:3                            , ;   
                     cPracovnik                                    , ;    
                     dDatumOd                                      , ;    
                     dDatumDo                                      , ;    
                     nMzda                                         , ;
                     nHrubaMZD                                     , ;
                     nTypPraVzt                                    , ;  
                     nTypZamVzt                                    , ;  
                     nClenSpol                                     , ;  
                     cMzdKatPra                                    , ;  
                     cPracZar                                      , ;  
                     nTypZamVzt                                      ) ;  
                CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) ITEMMARKED(itemMarked)
*                                                         STABLEBLOCK(stableBlock)


TYPE(DBrowse) FPOS(0.1,7.1) SIZE(99,8) FILE(MZDDAVIT) INDEXORD(7)  ;
              FIELDS(nOrdItem:Pol:4                                , ;
                     nDruhMzdy:DrMz:5                              , ;
                     M->nazevDruhu_Mzdy::15                        , ;
                     dDatumOd                                      , ;    
                     dDatumDo                                      , ;    
                     nSazbaDokl::10                                , ;
                     nDnyDoklad                                    , ; 
                     nHodDoklad                                    , ;
                     nMnPDoklad                                    , ;
                     nMzda                                         , ;
                     nHrubaMZD                                     , ;
                     nUcetMzdy                                     , ;
                     cnazpol1                                      , ; 
                     cnazpol2                                      , ; 
                     cnazpol3                                      , ; 
                     cnazpol4                                      , ; 
                     cnazpol5                                      , ; 
                     cnazpol6                                        ) ;
              CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) POPUPMENU(n)

TYPE(END)

