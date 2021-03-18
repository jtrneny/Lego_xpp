TYPE(drgForm) DTYPE(10) TITLE(Interní požadavky na nákup) SIZE(115,26.5)                ;
                                                          CARGO(NAK_intpozad_std_IN)    ;
                                                          PRINTFILES(intpozad:ndoklad=ndoklad) 


TYPE(Action) CAPTION(gen ~objVyst)  EVENT(nak_intPozad_to_objVys) TIPTEXT( Generuj objednávku vystavenou ...)


  TYPE(DBrowse) FPOS(-0.3,1.6) SIZE(114.0,17.2) FILE(intpozad)                         ; 
                                                FIELDS( M->bmp_stavDokl:st:2.7::2    , ;
                                                        czkrintPoz:typPož            , ;
                                                        M->typSklPol:typ položky:20  , ;
                                                        csklPol:sklPoložka           , ;
                                                        cnazZbo:popis požadavku      , ;
                                                        ncisFirmy:firma              , ;
                                                        M->nazev_Firmy:název firmy:23, ;
                                                        ddatObDod:datObj             , ; 
                                                        dtermDod:datDodání           , ;
                                                        czkrOs_Pro:zkrOsoby          , ;
                                                        cosoba_Pro:urèeno pro        , ;
                                                        nmnozObSkl:mn_objednáno      , ;
                                                        czkratJedn:mj                , ;
                                                        ncennaoDod:nák_Cena          , ;
                                                        ccisZakazI:èíslo_Zakázky       ) ;
                                                CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(x) POPUPMENU(y) ATSTART(LAST)


* quick
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114.00,1.25) RESIZE(yn)
    TYPE(STATIC) STYPE(2) FPOS(83,.1) SIZE(30,1) RESIZE(nx)
      TYPE(PushButton) POS(0,.4) SIZE(30,1.1) CAPTION(~Kompletní seznam)     EVENT(createContext) TIPTEXT(Volba zobrazení dat) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 
  TYPE(END) 

* info položky požadavku
  TYPE(Static) STYPE(2)  FPOS(0.5,18.7) SIZE(113.5,7) CTYPE(1) RESIZE(yx)

     TYPE(TEXT) CAPTION(zpracoval ...  [ ) CPOS(   .5, .7) CLEN( 0)
     TYPE(TEXT) NAME(intPozad->ncisOsoZpr) CPOS( 11.5, .7) CLEN( 0) PICTURE(99999) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( _ )               CPOS( 16.5, .7) CLEN( 0)
     TYPE(TEXT) NAME(intPozad->cNazOsoZpr) CPOS( 19.5, .7) CLEN( 0)                GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( ] )               CPOS( 50.5, .7) CLEN( 0)

     TYPE(TEXT) CAPTION(urèeno pro  ... [ ) CPOS( 56.5, .7) CLEN(12)
     TYPE(TEXT) NAME(intPozad->ncisOs_Pro) CPOS( 67.5, .7) CLEN( 5) PICTURE(99999) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( _ )               CPOS( 72.5, .7) CLEN( 3)
     TYPE(TEXT) NAME(intPozad->cosoba_Pro) CPOS( 75.5, .7) CLEN(30)                GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( ] )               CPOS(106.5, .7) CLEN(2)

     TYPE(TEXT) CAPTION(vyøizuje  ...  [ ) CPOS(   .5, .7) CLEN(12)
     TYPE(TEXT) NAME(intPozad->ncisOsoVyr) CPOS( 11.5, .7) CLEN( 5) PICTURE(99999) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( _ )               CPOS( 16.5, .7) CLEN( 3)
     TYPE(TEXT) NAME(intPozad->cNazOsoVyr) CPOS( 19.5, .7) CLEN(30)                GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
     TYPE(TEXT) CAPTION( ] )               CPOS( 50.5, .7) CLEN( 2)

*     TYPE(Static) STYPE(2)  FPOS(0,1.4) SIZE(113.5,.1) CTYPE(1) RESIZE(yx)
*     TYPE(END)

     TYPE(Static) STYPE(2) FPOS(0,1.5) SIZE(113.5,5.5) RESIZE(yx)
       TYPE(MLE) NAME('intpozad->mpoznobj')  FPOS(0.5,1.1) SIZE(56,4.5) RESIZE(xx) ;
                 READONLY(N) FCAPTION(poznámka k objednávce) CPOS(0.5, .2) CLEN(30) FONT(5) GROUPS(INFO)

       TYPE(MLE) NAME('intpozad->mpoznamka') FPOS(56.5,1.1) SIZE(56,4.5) RESIZE(yx) ;
                 READONLY(N) FCAPTION(popis interního požadavku) CPOS(56.5, .2) CLEN(30) FONT(5) GROUPS(INFO)
     TYPE(END)
  TYPE(END)


* QUICK

* neviditelné pomocné položky
TYPE(TEXT) NAME(intpozad->ccisSklad)  FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(intpozad->ncisOs_pro) FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(intpozad->ccisZakaz)  FPOS(0,0) CLEN(0) GROUPS(ITw)



*x	 ctypSklPol - combo - REF TYPSKLPOL
*x	 ccisZakazI - ...   - sel vyrzakit - QUICK -
*x	 czkrOs_pro - ...   - sel osoby
*x	 dDatObDOD
*x	 dTERMDOD
*x	 ctavDokl   - combo - REF CSTAVDOKL
*x	 cnazev     - txt   - název firmy

* info do spodní èásti
* pøi ins - plníme ncisIntPoz SID
*                  ndoklad    ???  