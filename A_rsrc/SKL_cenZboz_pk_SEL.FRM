TYPE(drgForm) DTYPE(10) TITLE(Skladové položky - VÝBÌR) SIZE(96, 20);
               GUILOOK(Action:y,Message:y,IconBar:y:drgStdBrowseIconBar,Menu:n)


TYPE(Action) CAPTION(info_C~eník)       EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

* TYPE(Action) CAPTION(~Aktualizace dat)  EVENT( RefreshDATA)      TIPTEXT(Aktualizace-refreš dat)
* TYPE(Action) CAPTION(založit K~artu)    EVENT( skl_cenZboz_pk_Nova) TIPTEXT(Založit kartu skladové položky)
* TYPE(Action) CAPTION(Pøevzít do ~Dokl.) EVENT( TermToPVP)        TIPTEXT(Pøenos oznaèených záznamù do dokladu)

  TYPE(Static) STYPE(12) SIZE(96,5.8) FPOS( .1, .1) RESIZE(xy) CTYPE(2) GROUPS(SKL_PRE)
    TYPE(Text) CAPTION(... skladová položka na cílovém skladu neexistuje ... ) CLEN(90) CPOS(1,0) CTYPE(1) FONT(7)    GROUPS(SKL_PRE_MAIN)

    TYPE(Text) CAPTION(pøevod ze skladu ->)  CPOS(  2, 1.5) CLEN(18)          FONT(5)                                 GROUPS(SKL_PRE)
    TYPE(Text) NAME(pvpheadW->ccisSklad)     CPOS( 20, 1.5) CLEN( 8) BGND( 9) FONT(5) CTYPE(1) PP(2)                  
    TYPE(Text) NAME(M->nazSklad)             CPOS( 29, 1.5) CLEN(12) 
    TYPE(Text) CAPTION(sklPoložku ->)        CPOS( 42, 1.5) CLEN(13)          FONT(5)                                 GROUPS(SKL_PRE)
    TYPE(Text) NAME(M->sklPol)               CPOS( 55, 1.5) CLEN(15) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Text) NAME(M->nazZbo)               CPOS( 71, 1.5) CLEN(25) 
                                      
    TYPE(Text) CAPTION(na sklad   ->)        CPOS(  8, 2.5) CLEN(12)          FONT(5)                                 GROUPS(SKL_PRE)                              
*    TYPE(Text) NAME(M->skladKAM)             CPOS( 20, 2.5) CLEN( 8) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Get)  NAME(M->skladKAM)             FPOS( 20, 2.5) FLEN( 7)                            PP(2)                 PUSH(sklad_sel) POST(skladKAM_vld)

    TYPE(Text) NAME(M->nazSkladKAM)          CPOS( 29, 2.5) CLEN(12) 
    TYPE(Text) CAPTION(sklPoložku ->)        CPOS( 42, 2.5) CLEN(13)          FONT(5)                                 GROUPS(SKL_PRE)
    TYPE(Text) NAME(M->sklPolKAM)            CPOS( 55, 2.5) CLEN(15) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Text) NAME(M->nazZboKAM)            CPOS( 71, 2.5) CLEN(25) 

     TYPE(PushButton) POS( 64, 4.2) SIZE(15, 1.2) CAPTION(     ~založitKartu)  EVENT(skl_cenZboz_pk_autoNew) ICON1(119) ICON2(0) ATYPE(3) TIPTEXT(Automaticky založit novou kartu skladové položky)
     TYPE(PushButton) POS( 80, 4.2) SIZE(15, 1.2) CAPTION(    ~poøídit_Kartu)  EVENT(skl_cenZboz_pk_editNew) ICON1(119) ICON2(0) ATYPE(3) TIPTEXT(Poøídit novou kartu skladové položky)
  TYPE(End)


  TYPE(DBrowse)  FILE(CENZBOZ_pk) INDEXORD(1) ;
                 FIELDS( M->isAktivni:akt:2.6::2         , ;
                         M->cenPol:cp:2.6::2             , ;  
                         CSKLPOL:sklPoložka              , ;
                         CNAZZBO:název zboží:30          , ;
                         nZboziKat:katZboží              , ;
                         nMnozSZBO:množSkl               , ;
                         cZkratJedn:mj                   , ;
                         nCenaSZBO:sklCena                 ) ;
                 FPOS( 0, 6) SIZE(96,13.5) CURSORMODE(3) RESIZE(yx) PP(7) SCROLL(ny) ;
                 ITEMMARKED(itemMarked) ITEMSELECTED(dBro_itemSelected) POPUPMENU(yn)



*
*  TYPE(Static) STYPE(1) SIZE( 20,1.2) FPOS( 89, 2)  RESIZE(nn)
*    TYPE(PushButton) POS(0,0)   SIZE(20,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*  TYPE(End)


