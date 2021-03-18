TYPE(drgForm) DTYPE(10) TITLE(Skladové položky - VÝBÌR) SIZE(110, 23.5);
               GUILOOK(Action:y,Message:y,IconBar:y:drgStdBrowseIconBar,Menu:n)


TYPE(Action) CAPTION(info C~eník)       EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) CAPTION(~Aktualizace dat)  EVENT( RefreshDATA)      TIPTEXT(Aktualizace-refreš dat)
TYPE(Action) CAPTION(založit K~artu)    EVENT( TERM_CENZBOZ_CRD) TIPTEXT(Založit kartu skladové položky)
TYPE(Action) CAPTION(Pøevzít do ~Dokl.) EVENT( TermToPVP)        TIPTEXT(Pøenos oznaèených záznamù do dokladu)

* SKLAD
  TYPE(Static) STYPE(1) SIZE(108,1.8) FPOS(1,0.2) RESIZE(yn)
    TYPE(Text) CAPTION(SKLAD)              CPOS(  1, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(CenZBOZ->cCisSklad)    CPOS( 10, 0.2) CLEN( 10) BGND( 13) FONT(5) PP(2) GROUPS(clrGREEN)
    TYPE(Text) NAME(C_Sklady->cNazSklad)   CPOS( 22, 0.2) CLEN( 80) BGND( 13) FONT(5) PP(2) GROUPS(clrGREEN)
  TYPE(End)
*
  TYPE(TabPage) TTYPE(4) CAPTION(Z ceníku zboží) FPOS(0,2.1) SIZE( 109.5, 23) RESIZE(yy) OFFSET(1,80) PRE( tabSelect)

    TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(1)                 ;
                  FIELDS( CenZBOZ_isAktivni():akt:2.6::2  , ;
                          M->cenPol:cp:2.6::2             , ;  
                          CCISSKLAD:èisSklad              , ;
                          CSKLPOL:sklPoložka              , ;
                          CNAZZBO:název zboží:30          , ;
                          nZboziKat:katZboží              , ;
                          M->wds_cenzboz_kDis:množKDisp:13, ;   
                          nMnozSZBO:množSkl               , ;
                          cZkratJedn:mj                   , ;
                          ncenaCzbo:cenaCelk              , ;
                          nCenaSZBO:sklCena               , ;
                          nCenaPZBO:prodCena              , ;
                          nCenaNZBO:nákCena                 );
                  FPOS( 0, 0) SIZE(110,20) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy);
                  ITEMSELECTED( RecordSelected) POPUPMENU(yn)
  TYPE(END)

  TYPE(TabPage) TTYPE(4) CAPTION(Ze zásobníku) FPOS(0,2.1) SIZE( 109.5, 23) RESIZE(yy) OFFSET(20,63) PRE( tabSelect)

   TYPE(DBrowse) FILE(PVPTERM) INDEXORD(1) ;
                  FIELDS( PVPterm_TypImportu():im:2.6::2 , ;
                          PVPterm_inCenZboz():ce:2.6::2  , ;
                          PVPterm_Errors():Err:2.6::2    , ;
                          M->pvpTerm_ctypPvp:pohyb:6     , ;
                          CTYPPOHYBU:typPoh:5            , ; 
                          CCISSKLAD:èisSklad:5           , ;
                          CSKLPOL:sklPoložka             , ;
                          CNAZZBO:název zboží:30         , ;
                          M->wds_pvpterm_kDis:množKDisp:13, ;
                          nMnozDokl1:množNaDokl:13       , ;
                          cMJDokl1:mjDokl                , ;
                          nMnoz_PLN:množPln:13           , ;
                          nStav_PLN:stavPln:13           , ;
                          nCenaSZBO:sklCena:13           , ;
                          nCenaPZBO:prodCena:13          , ;
                          nCenaMZBO:cenaSMarží:13        , ;
                          nZboziKat:katZzboží            , ;
                          cStredisko:støedisko           , ;
                          cVyrobek:výrobek               , ;
                          cZakazka:zakázka               , ;
                          cVyrMisto:výrMísto             , ;
                          cStroj:stroj                   , ;
                          cOperace:operace               , ;
                          cCarKod:èárKód:30                ) ;
                  FPOS( 0, 0) SIZE(110,20) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy);
                  ITEMMARKED( ItemMarked ) ITEMSELECTED( RecordSelected) POPUPMENU(yy)
  TYPE(END)

  *
  TYPE(Static) STYPE(1) SIZE( 30,1.2) FPOS( 80, 2)  RESIZE(nn)
    TYPE(PushButton) POS(0,0)   SIZE(30,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)

  TYPE(Static) STYPE(1) SIZE( 31,1.2) FPOS( 78, 2)  RESIZE(nn)
    TYPE(COMBOBOX) NAME(M->cpvpTerm_filter)  FPOS( 0, 0) FLEN( 31) VALUES(a,a,a,a,a) ITEMSELECTED(comboItemSelected)
  TYPE(End)
