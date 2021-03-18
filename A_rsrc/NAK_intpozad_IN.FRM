TYPE(drgForm) DTYPE(10) TITLE(Interní požadavky na nákup) SIZE(115,26.5) GUILOOK(Action:y,IconBar:y)  ;
                                                          POST( PostValidate)                         ;
                                                          PRINTFILES(intpozad:ndoklad=ndoklad) 


TYPE(Action) CAPTION(gen ~objVyst)  EVENT(nak_intPozad_to_objVys) TIPTEXT( Generuj objednávku vystavenou ...)


*  TYPE(STATIC) STYPE(2) FPOS(0.01,1.25) SIZE(114.2,18.6) RESIZE(yn)

  TYPE(EBrowse) FPOS(-0.3,1.6) SIZE(114.0,17.2) FILE(intpozad)  RESIZE(yy) ;
                               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)

    TYPE(TEXT)     NAME(       M->bmp_stavDokl)  CLEN(  3) CAPTION(S) BITMAP()
    TYPE(GET)      NAME(intpozad->czkrintpoz)    FLEN(  8) FCAPTION(Typ)           FONT(5) 

    TYPE(COMBOBOX) NAME(intpozad->ctypSklPol)    FLEN( 20) FCAPTION(typPoložky)    REF(typSklPol) 
    TYPE(GET)      NAME(intpozad->csklPol)       FLEN( 15) FCAPTION(SkladPol)      FONT(6) PUSH(skl_cenzboz_sel)
    TYPE(GET)      NAME(intpozad->cnazZbo)       FLEN( 25) FCAPTION(Požadavek)     FONT(5) 

    TYPE(GET)      NAME(intpozad->ncisFirmy)     FLEN(  5) FCAPTION(èísloFirmy)    FONT(6) PUSH(fir_firmy_sel)
    TYPE(TEXT)     NAME(       M->nazFirmy)      CLEN( 25) CAPTION(název firmy)

    TYPE(GET)      NAME(intpozad->ddatObDod)     FLEN( 12) FCAPTION(obj_Dne)       FONT(6) PUSH(clickDate)
    TYPE(GET)      NAME(intpozad->dtermDod)      FLEN( 12) FCAPTION(dod_Dne)       FONT(6) PUSH(clickDate)
    
    TYPE(GET)      NAME(intpozad->czkrOs_Pro)    FLEN( 10) FCAPTION(zkrOs)         PUSH(pro_vyrzakit_sle_OSB_sel)
    TYPE(TEXT)     NAME(intpozad->cosoba_Pro)    CLEN( 25) CAPTION(urèeno pro)

    TYPE(GET)      NAME(intpozad->nmnozObSkl)    FLEN(  5) FCAPTION(objMnož)       FONT(6) 
    TYPE(GET)      NAME(intpozad->czkratJedn)    FLEN(  6) FCAPTION(mj)            FONT(6)
    TYPE(GET)      NAME(intpozad->ncennaodod)    FLEN( 13) FACPTION(nákCena)       FONT(6)  

    TYPE(GET)      NAME(intpozad->ccisZakazI)    FLEN( 15) FCAPTION(èíslo_Zakázky) FONT(6) PUSH(vyr_vyrzakit_sel)
    TYPE(COMBOBOX) NAME(intpozad->cstavDokl)     FLEN( 20) FCAPTION(stavPoložky)   REF(cstavDokl) 

    TYPE(MLE)      NAME(intpozad->mpoznobj)      FLEN( 20) FCAPTION(Popis)         FONT(5) 
    TYPE(MLE)      NAME(intpozad->mpoznamka)     FLEN( 20) FCAPTION(Poznámka)      FONT(5) 
  TYPE(end)

*  TYPE(end)



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