TYPE(drgForm) DTYPE(10) TITLE(Pøednastavení recyklaèního poplatku ke skladové položce ...) SIZE(120, 27) ;
                                                   POST(postValidate)                     ;
                                                   FILE(cenZb_ns)                         ;
                                                   GUILOOK(Message:y,Action:y,IconBar:y:drgStdIconBar)

*                                                   GUILOOK(Action:y,Message:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(info C~eník)     EVENT(SKL_CENZBOZ_INFO)    TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) CAPTION(založit K~artu)  EVENT(SKL_CENZBOZ_crdNew)  TIPTEXT(Založit kartu skladové položky)
TYPE(Action) CAPTION(ak~Tualizace RP) EVENT(set_rp_fromOldFiles) TIPTEXT(Aktializace cenZb_rp ze stávajícícj dat uživatele)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(info N~astavení) EVENT(rp_showHelp)        TIPTEXT(Informaèní karta nastavení recyklaèního polatku ...)

* M->is_in_cenZb_ns:in:3.3::2, ;

TYPE(Static) STYPE(13) SIZE(120,8.8) FPOS(0,1.5) RESIZE(yy)
  TYPE(DBrowse) FPOS( -.2, -.1) FILE(CENZBOZ) INDEXORD(1)              ;
                                FIELDS(CenZBOZ_isAktivni():akt:2.6::2, ;
                                       M->is_in_cenZb_rp:in:3.3::2   , ;
                                       cCISSKLAD:èisSklad            , ;                                       
                                       cSKLPOL:sklPoložka            , ;                                       
                                       cNAZZBO:název zboží:29        , ;
                                       nZBOZIKAT:katZbo              , ;
                                       nmnozDZbo:množKDisp:11        , ;
                                       czkratJedn:mjSkl              , ;
                                       ncenaMZbo:prodCena:10         , ;
                                       ncenaPZbo:prodCenaBdph:10     , ;
                                       ncenaNZbo:nákCena:10            ) ;
                                CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(ny) ITEMSELECTED(RecordSelected) POPUPMENU(yy) STABLEBLOCK(stableBlock)
TYPE(END)

*    
TYPE(Static) STYPE(13) SIZE( 119.6,1.5) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(Pøednastavení recyklaèního poplatku ke skladové položce ->) CPOS( 3, 0.2) CLEN(55) FONT(5)
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
**      TYPE(PushButton)                            POS(111.8, 3.1) ;
**                                                  SIZE( 6, 2.1) EVENT(smallBasket) ICON1(208) ICON2(108) ATYPE(1) ;
**                                                  CAPTION(2)

      TYPE(TEXT)  NAME(M->cZrp_cisSklad)    CPOS(  4, .7) CLEN(12) BGND(12) GROUPS(SETFONT,9.Arial)                            
      TYPE(TEXT)  NAME(M->cZrp_sklPol)      CPOS( 18, .7) CLEN(20) BGND(12) GROUPS(SETFONT,9.Arial)
      TYPE(TEXT)  NAME(M->cZrp_nazZbo)      CPOS( 46, .7) CLEN(50) BGND(12) GROUPS(SETFONT,9.Arial)
     
      TYPE(Text) CAPTION(recPolpatek)                 CPOS( 3, 1.72) CLEN( 8) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Get)  NAME(cenZboz->crecPopl)              FPOS( 1, 2.7 ) FLEN(12) GROUPS(SETFONT,9.Arial CE Bold) 

      TYPE(Text) CAPTION(název recyklaèního polatku)  CPOS(23, 1.72) CLEN(18) GROUPS(SETFONT,7.Arial CE) 
      TYPE(Text) NAME(c_recPop->cnazRECpop)           CPOS(23, 2.7 ) CLEN(50) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(mjPop)                       CPOS(73, 1.72) CLEN( 5) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(c_recPop->czkratJedn)           CPOS(73, 2.7 ) CLEN( 4) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(Text) CAPTION(cenaPopl)                    CPOS(82, 1.72) CLEN( 7) GROUPS(SETFONT,7.Arial CE)
      TYPE(Text) NAME(c_recPop->nrecPopl)             CPOS(81, 2.7 ) CLEN(12) GROUPS(SETFONT,9.Arial CE Bold)
      TYPE(Text) NAME(c_recPop->czkratMeny)           CPOS(92, 2.7 ) CLEN(12) GROUPS(SETFONT,9.Arial CE Bold)

      TYPE(STATIC) FPOS(0.4,2.1) SIZE(117.2,.25) STYPE(8) CTYPE(2) RESIZE(yx)
      TYPE(End)
    TYPE(End)


 TYPE(EBrowse) FPOS(-.2,4.9) SIZE(120,11.6) FILE(cenZb_rp)                                                  ;
                                            INDEXORD(2) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(yn)

    TYPE(TEXT)     NAME(cenZb_rp->ccissklad)             CLEN( 6)  CAPTION(sklad)       
    TYPE(GET)      NAME(cenZb_rp->csklpol)    FLEN(15)             CAPTION(sklPoložka) PUSH(cenZb_rp_SEL)
    TYPE(TEXT)     NAME(cenZb_rp->cnazZbo)    FLEN( 5)   CLEN(35)  CAPTION(názec položky)

    TYPE(TEXT)     NAME(M->cZrp_zboziKat)     CLEN( 5)             CAPTION(katZboz)      CTYPE(2)
    TYPE(TEXT)     NAME(M->cZrp_zkratJedn)    CLEN( 5)             CAPTION(mjSkl)        CTYPE(2)
    TYPE(TEXT)     NAME(M->cZrp_cenaMZbo)     CLEN(13)             CAPTION(prodCena)     CTYPE(2)
    TYPE(TEXT)     NAME(M->cZrp_cenaPZbo)     CLEN(13)             CAPTION(prodCenaBdph) CTYPE(2) 
    TYPE(TEXT)     NAME(M->cZrp_cenaNZbo)     CLEN(13)             CAPTION(nákCena)      CTYPE(2) 
  TYPE(END) 






