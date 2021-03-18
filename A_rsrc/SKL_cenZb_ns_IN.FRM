TYPE(drgForm) DTYPE(10) TITLE(Pøednastavení úètu a nákladové struktury ...) SIZE(120, 27) ;
                                                   POST(postValidate)                     ;
                                                   GUILOOK(Action:y,Message:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(info C~eník)    EVENT(SKL_CENZBOZ_INFO)   TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) CAPTION(založit K~artu) EVENT(SKL_CENZBOZ_crdNew) TIPTEXT(Založit kartu skladové položky)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(info N~astavení) EVENT(ns_showHelp)        TIPTEXT(Informaèní karta nastavení ùètu a náklStruktury)



TYPE(Static) STYPE(13) SIZE(120,8.8) FPOS(0,1.5) RESIZE(yy)
  TYPE(DBrowse) FPOS( -.2, -.1) FILE(CENZBOZ) INDEXORD(1)           ;
                                FIELDS(M->is_in_cenZb_ns:in:3.3::2, ;
                                       cCISSKLAD:èisSklad         , ;
                                       nZBOZIKAT:katZbo           , ;
                                       cSKLPOL:sklPoložka         , ;
                                       cNAZZBO:název zboží:25     , ;
                                       nmnozDZbo:množKDisp:10     , ;
                                       czkratJedn:mjSkl           , ;
                                       ncenaMZbo:prodCenaSdph     , ;
                                       ncenaPZbo:prodCenaBdph     , ;
                                       ncenaNZbo:nákCena            ) ;
                                CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy) ITEMSELECTED(RecordSelected) POPUPMENU(yy) STABLEBLOCK(stableBlock)
TYPE(END)

*    
TYPE(Static) STYPE(13) SIZE( 119.6,1.5) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(Pøednastavení úètu a nákladové struktury pro typPohybu ->) CPOS( 3, 0.2) CLEN(55) FONT(5)

  TYPE(Static) STYPE(1)       SIZE(50,1.2)  FPOS( 72.3,0.1)  RESIZE(nx)
    TYPE(PushButton) POS(0,0)   SIZE(331,24) CAPTION(~Kompletní seznam nastavení) EVENT(createContext) TIPTEXT(Volba zobrazení dat)  ICON1(338) ATYPE(33)
  TYPE(End)
TYPE(End)                                    
*

* info.cenZboz a karta.cenZb_ns
  TYPE(Static) STYPE(1) SIZE(120,17.3) FPOS(.5,10.3) CTYPE(2) RESIZE(yx)

    TYPE(TEXT) CAPTION(èísSkladu)    CPOS( 5, -.2) CLEN( 8) 
    TYPE(TEXT) CAPTION(sklPoložka)   CPOS(19, -.2) CLEN( 9)  
    TYPE(TEXT) CAPTION(název zboží)  CPOS(47, -.2) CLEN(10) 


    TYPE(STATIC) STYPE(12) FPOS( .3,.3) SIZE(118, 4.2) CTYPE(2) RESIZE(yx)

       TYPE(STATIC) STYPE(3) FPOS( -.3, .11) SIZE( 23,35 ) CAPTION(337)
*
**    OFF / ON - možnost zapnutí položek poøízení v cyklu
      TYPE(PushButton)                            POS(111.8, 3.1) ;
                                                  SIZE( 6, 2.1) EVENT(smallBasket) ICON1(208) ICON2(108) ATYPE(1) ;
                                                  CAPTION(2)

      TYPE(Get)  NAME(M->cZns_cisSklad)    FPOS(  4, .7) FLEN(12) BGND(13) GROUPS(SETFONT,9.Arial)                            
      TYPE(Get)  NAME(M->cZns_sklPol)      FPOS( 18, .7) FLEN(20) BGND(13) GROUPS(SETFONT,9.Arial)
      TYPE(Get)  NAME(M->cZns_nazZbo)      FPOS( 46, .7) FLEN(50) BGND(13) GROUPS(SETFONT,9.Arial)

*      TYPE(Get)  NAME(cenZboz->ccisSklad)    FPOS(  4, .7) FLEN(12) BGND(13) GROUPS(SETFONT,9.Arial) 
*      TYPE(Get)  NAME(cenZboz->csklPol)      FPOS( 18, .7) FLEN(20) BGND(13) GROUPS(SETFONT,9.Arial)
*      TYPE(Get)  NAME(cenZboz->cnazZbo)      FPOS( 46, .7) FLEN(50) BGND(13) GROUPS(SETFONT,9.Arial)
      
      TYPE(Text) CAPTION(úèet)               CPOS( 3, 1.72) CLEN( 4) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Get)  NAME(cenZb_ns->cucet)       FPOS(  1, 2.7) FLEN( 9) GROUPS(SETFONT,9.Arial CE Bold) 

      TYPE(Text) CAPTION(VýrStøedisko)       CPOS(23, 1.72) CLEN( 9) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Get)  NAME(cenZb_ns->cnazPol1)    FPOS( 23, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold) 

      TYPE(Text) CAPTION(Výrobek)            CPOS(37, 1.72) CLEN( 6) GROUPS(SETFONT,7.Arial CE)
      TYPE(Get)  NAME(cenZb_ns->cnazPol2)    FPOS( 37, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(Zakázka)            CPOS(51, 1.72) CLEN( 6) GROUPS(SETFONT,7.Arial CE)
      TYPE(Get)  NAME(cenZb_ns->cnazPol3)    FPOS( 51, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(VýrMísto)           CPOS(65, 1.72) CLEN( 7) GROUPS(SETFONT,7.Arial CE)
      TYPE(Get)  NAME(cenZb_ns->cnazPol4)    FPOS( 65, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(Stroj)              CPOS(79, 1.72) CLEN( 4) GROUPS(SETFONT,7.Arial CE)
      TYPE(Get)  NAME(cenZb_ns->cnazPol5)    FPOS( 79, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(VýrOperace)         CPOS(93, 1.72) CLEN( 8) GROUPS(SETFONT,7.Arial CE)
      TYPE(Get) NAME(cenZb_ns->cnazPol6)     FPOS( 93, 2.7) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(STATIC) FPOS(0.4,2.1) SIZE(110.6,.15) STYPE(8) CTYPE(2) RESIZE(yx)
      TYPE(End)

    TYPE(End)


    TYPE(DBrowse) FPOS(-.2,4.9) SIZE(120,11.6) FILE(cenZb_ns)                     ;
                                              FIELDS(ctypPohybu:typPohybu:10    , ;
                                                     ccisSklad:èisSklad:8       , ;                                                
                                                     csklpol:sklPoložka:15      , ;
                                                     M->ns_nazZbo:název zboží:27, ;
                                                     cucet:úèetTržeb:6          , ;
                                                     cNazPol1:VýrStøedisko:8    , ;
                                                     cNazPol2:Výrobek:8         , ;
                                                     cNazPol3:Zakázka:8         , ;
                                                     cNazPol4:VýrMísto:8        , ;
                                                     cNazPol5:Stroj:8           , ;
                                                     cNazPol6:VýrOperace:8        ) ;
                                              CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(yn) STABLEBLOCK(stableBlock)




