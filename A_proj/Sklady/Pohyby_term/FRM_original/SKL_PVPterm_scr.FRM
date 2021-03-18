TYPE(drgForm) DTYPE(10) TITLE(Zásobník externích pohybù) FILE(PVPterm);
              SIZE(110,25) GUILOOK(Message:y,Action:y,IconBar:y)

*TYPE(Action) CAPTION(~Import TT->PC)  EVENT( IMPORT_toPVPterm) TIPTEXT(Import nasnímaných dat na PC)
TYPE(Action) CAPTION(~Aktualizace dat) EVENT( RefreshDATA)      TIPTEXT(Aktualizace-refreš dat)
TYPE(Action) CAPTION(info C~eník)      EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) CAPTION(založit K~artu)   EVENT( TERM_CENZBOZ_CRD) TIPTEXT(Založit kartu skladové položky)


TYPE(DBrowse) FILE(PVPterm) INDEXORD(1) ;
              FIELDS( PVPterm_TypImportu():TI:2.6::2,;
                      PVPterm_inCenZboz():Ce:2.6::2,;
                      PVPterm_Errors():Err:2.6::2,;
                      PVPterm_TypPVP():Pohyb:6,;
                      cTypPohybu:TyPo:5,;
                      cCisSklad   ,;
                      cSklPol     ,;
                      cNazZbo     ,;
                      nMnozDokl1  ,;
                      cMjDokl1    ,;
                      nMnoz_PLN   ,;
                      PVPterm_Stav_PLN():Stav plnìní:15,;
                      nStav_PLN   ,;
                      nCenaDokl1  ,;
                      nCenaPZbo   ,;
                      nCenaMZbo   ,;
                      nCenaSZbo   ,;
                      cPolCen     ,;
                      nCarkKod    ,;
                      cCarKod     ,; 
                      cStredisko  ,; 
                      cVyrobek    ,; 
                      cZakazka    ,; 
                      cVyrMisto   ,; 
                      cStroj      ,; 
                      cOperace    );
              SIZE(110,20.7) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Zásobník externích pohybù) CPOS( 45, 0.1) CLEN( 25) FONT(5)
    TYPE(Static) STYPE(1) SIZE( 21,1.2) FPOS( 88, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->nDataFilter)  FPOS( 0, 0) FLEN( 21) VALUES(0:Všechny pohyby  ,;
                                                                        1:Pøíjmové pohyby ,;
                                                                        2:Výdejové pohyby ,;
                                                                        3:Pøevodové pohyby );
        ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(109,2.5) FPOS(0.5,22.2) RESIZE(y)
*    TYPE(PushButton) POS(85,0.9) SIZE(18,1.2) CAPTION(~Zobrazit dokument) EVENT(ViewDokum) ICON1(119) ICON2(219) ATYPE(3)
    TYPE(Text) CAPTION(Typ èár.kódu)        CPOS(  1, 0.2) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cZkrCarKod)    CPOS(  1, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èárový kód)          CPOS( 22, 0.2) CLEN( 10)
    TYPE(Text) NAME(CENZBOZ->cCarKod)       CPOS( 22, 1.2) CLEN( 85) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(End)

TYPE(End)