TYPE(drgForm) DTYPE(10) TITLE(Pøehled vystavených upomínek ...) SIZE(107,25)         ;
                                                                CARGO(FIN_UPOMINHD_IN) ;
                                                                PRINTFILES( upominhd:ncisupomin=ncisupomin, ;
                                                                            upominit:ncisupomin=ncisupomin)
    

   TYPE(DBrowse) FPOS(.2,.2) SIZE(106.6,12.1) FILE(UPOMINHD)                     ;
                                            FIELDS( nCISUPOMIN:èísUpom:10      , ;
                                                    nCISFIRMY:odbìratel        , ; 
                                                    cNAZEV:název Firmy:30      , ;
                                                    cSIDLO:sídlo Firmy:28.3    , ;
                                                    dUPOMINKY:datUpom:10       , ;
                                                    nCENZAKCEL:èástkaUpom        ) ; 
                                           CURSORMODE(3) PP(7)  RESIZE(yy) ATSTART(LAST) ITEMMARKED(ItemMarked) POPUPMENU(y)  


   TYPE(DBrowse) FPOS(.2,12.5) SIZE(106.6,12.1) FILE(UPOMINIT)                       ;
                                              FIELDS( nCISFAK:èísloFak             , ;
                                                      cVARSYM:varSymbol            , ; 
                                                      cDOPLNTXT:text Upomínky:19   , ;
                                                      dVYSTFAK:datVys:10           , ;
                                                      dSPLATFAK:datSplat:10        , ;
                                                      dPOSUHRFAK:datÚhr:10         , ;
                                                      nCENZAKCEL:celkemFak         , ;      
                                                      nUHRCELFAK:celkemUhr           ) ; 
                                              CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yx)
