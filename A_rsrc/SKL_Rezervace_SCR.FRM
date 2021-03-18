TYPE(drgForm) DTYPE(10) TITLE( Rezervace ) SIZE(110,25);
              GUILOOK( Menu:n)

TYPE(Action) CAPTION(~Rezervace  >>)  EVENT(RezervaceMenu) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

* HLA objednávek pøijatých
  TYPE(Static) STYPE(12) SIZE(109.6,1.6) FPOS(0.2,0.1) RESIZE(yn)
    TYPE(Text) CAPTION( Objednávky pøijaté)   CPOS(1,0.0) CLEN( 20) SIZE(20, 1.2) FONT(7)
  TYPE(End)

  TYPE(DBrowse) FILE(ObjHead)  INDEXORD(1);
                FIELDS( cCislObInt:È.obj. interní,;
                        nCisFirmy:Odbìratel      ,;
                        cCisObj:È.obj. odbìratel ,;
                        dDatObj:Dat.objednání    ,;
                        dDatDoOdb:Dat.dodání     ,;
                        nKcsBdObj:Cena bez DPH   ,;
                        nKcsZdObj:Cena s DPH     ,;
                        cPokrObj:Po.);
                FPOS(0,1.5) SIZE(110,10.4) CURSORMODE(3) SCROLL(ny) PP(7);
                ITEMMARKED(itemMarked)

* POL objednávek pøijatých
  TYPE(DBrowse) FILE(ObjItem) INDEXORD(1);
                FIELDS( nCislPolOb:Poø.        ,;
                        cNazZbo:Název zboží    ,;
                        cSklPol:Skl.položka    ,;
                        nZboziKat:Kat.zb.      ,;
                        nMnozObDod:Mn.objednáno) ;
                FPOS(0,12.2) SIZE(110, 9.5) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) POPUPMENU(yn)

* INFO - Firma
  TYPE(Static) STYPE(13) SIZE(109, 3) FPOS( 0.5,21.8) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Firma)           CPOS( 1, 0.2) CLEN(  6) FONT(2)
    TYPE(Text) NAME(FIRMY->nCisFirmy)   CPOS( 1, 1.4) CLEN(  6) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název firmy)     CPOS( 8, 0.2) CLEN( 25) FONT(2)
    TYPE(Text) NAME(FIRMY->cNazev)      CPOS( 8, 1.4) CLEN( 37) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(IÈO)             CPOS(46, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(FIRMY->nIco)        CPOS(46, 1.4) CLEN( 10) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sídlo firmy)     CPOS(58, 0.2) CLEN( 25) FONT(2)
    TYPE(Text) NAME(FIRMY->CULICE)      CPOS(58, 1.4) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(FIRMY->cPSC)        CPOS(80, 1.4) CLEN(  7) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(FIRMY->cSIDLO)      CPOS(87, 1.4) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(End)