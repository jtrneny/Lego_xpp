TYPE(drgForm) DTYPE(10) TITLE(Seznam objednávek pøijatých _ výbìr) SIZE(100,19) FILE(OBJITEM);
               GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

* FIRMA - odbìratel
  TYPE(Static) STYPE(2) SIZE(98,2.2) FPOS(1,0) RESIZE(xy) 
    TYPE(Text) CAPTION(Firma)              CPOS( 1, 0) CLEN(  6) FONT(5)
    TYPE(Text) NAME(OBJITEM->nCisFirmy)    CPOS( 1, 1) CLEN(  8) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název odbìratele)   CPOS( 9, 0) CLEN( 25) FONT(5)
    TYPE(Text) NAME(FIRMY->cNazev)         CPOS( 9, 1) CLEN( 26) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(IÈO)                CPOS(36, 0) CLEN(  8) FONT(5)
    TYPE(Text) NAME(FIRMY->nIco)           CPOS(36, 1) CLEN( 10) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Sídlo firmy)        CPOS(48, 0) CLEN( 25) FONT(5)
    TYPE(Text) NAME(FIRMY->CULICE)         CPOS(48, 1) CLEN( 20) BGND(13) PP(2)
    TYPE(Text) NAME(FIRMY->cPSC)           CPOS(70, 1) CLEN(  6) BGND(13) PP(2)
    TYPE(Text) NAME(FIRMY->cSIDLO)         CPOS(77, 1) CLEN( 20) BGND(13) PP(2)
  TYPE(End)

  TYPE(DBrowse) FILE(OBJITEM) INDEXORD(3)            ;
                FIELDS(ndoklad:èísloObj            , ;
                       cCislObInt:èísloObjed_int:25, ;
                       cCISSKLAD:èisSklad          , ; 
                       nZBOZIKAT:katZbo            , ; 
                       CSKLPOL:sklPoložka          , ;
                       CNAZZBO:název zboží:34      , ;
                       nCenaDlODB:prodCena         , ;
                       nMnozObODB:Objednáno,;
                       nMnozNeODB:Nepotvrzeno,;
                       cZkratJedn:mj:3              ) ;
                FPOS( 0, 3) SIZE(100,10.5) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy) LFREEZE(1) POPUPMENU(y);
                ITEMSELECTED( RecordSelected)

  TYPE(Static) STYPE(1) SIZE(98,5) FPOS(1,13.7) RESIZE(xy)
*   1.ø.
    TYPE(Text) CAPTION(Èíslo objednávky)   CPOS(  1, 0.2) CLEN( 15) FONT(5)
    TYPE(Text) NAME(OBJITEM->cCislObINT)   CPOS(  1, 1.2) CLEN( 20) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Položka)            CPOS( 22, 0.2) CLEN(  7)
    TYPE(Text) NAME(OBJITEM->nCislPolOb)   CPOS( 22, 1.2) CLEN(  7) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
*   2.ø.
    TYPE(Text) CAPTION(Mn. objednané)      CPOS( 35, 0.2) CLEN( 13)
    TYPE(Text) NAME(OBJITEM->nMnozObODB)   CPOS( 35, 1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. potvrzené)      CPOS( 50, 0.2) CLEN( 13)
    TYPE(Text) NAME(OBJITEM->nMnozPoODB)   CPOS( 50, 1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. nepotvrzené)    CPOS( 65, 0.2) CLEN( 13)
    TYPE(Text) NAME(OBJITEM->nMnozNeODB)   CPOS( 65, 1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. rezervované)    CPOS( 80, 0.2) CLEN( 13)
    TYPE(Text) NAME(OBJITEM->nMnozReODB)   CPOS( 80, 1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Mn. plnìní)         CPOS( 35, 2.2) CLEN( 13)
    TYPE(Text) NAME(OBJITEM->nMnozPlODB)   CPOS( 35, 3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
  TYPE(End)

  TYPE(Static) STYPE(1) SIZE( 20,1.2) FPOS( 89, 2)  RESIZE(nn)
    TYPE(PushButton) POS(0,0)   SIZE(20,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)

