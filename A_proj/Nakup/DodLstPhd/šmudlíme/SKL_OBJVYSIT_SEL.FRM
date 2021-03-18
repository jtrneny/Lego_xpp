TYPE(drgForm) DTYPE(10) TITLE(Objednávky vystavené - VÝBÌR) SIZE(100,25);
               GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

* FIRMA - dodavatel
  TYPE(Static) STYPE(1) SIZE(98,2.8) FPOS(1,0.2) RESIZE(yn)
    TYPE(Text) CAPTION(Firma)              CPOS( 1, 0.0) CLEN(  6) FONT(2)
    TYPE(Text) NAME(OBJVYSIT->nCisFirmy)   CPOS( 1, 1.2) CLEN(  8) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název dodavatele)   CPOS(10, 0.0) CLEN( 25) FONT(2)
    TYPE(Text) NAME(FIRMY->cNazev)         CPOS(10, 1.2) CLEN( 26) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(IÈO)                CPOS(38, 0.0) CLEN(  8) FONT(2)
    TYPE(Text) NAME(FIRMY->nIco)           CPOS(38, 1.2) CLEN( 11) CTYPE(2) BGND( 13) FONT(5)
    TYPE(Text) CAPTION(Sídlo firmy)        CPOS(50, 0.0) CLEN( 25) FONT(2)
    TYPE(Text) NAME(FIRMY->CULICE)         CPOS(50, 1.2) CLEN( 20) BGND(13) FONT(5)
    TYPE(Text) NAME(FIRMY->cPSC)           CPOS(71, 1.2) CLEN(  7) BGND(13) FONT(5)
    TYPE(Text) NAME(FIRMY->cSIDLO)         CPOS(79, 1.2) CLEN( 19) BGND(13) FONT(5)
  TYPE(End)

* Objednávky vystavené k dodavateli
  TYPE(DBrowse) FILE(OBJVYSIT) INDEXORD(2) ;
                FIELDS( M->stav_objvysit::2.6::2 ,;
                        cCisObj:Èís.obj.interní  ,;
                        nIntCount:Poø.  ,;
                        CSKLPOL:Skl. položka,;
                        CNAZZBO:Název zboží:30 ,;
                        nMnozObDod:Mn.objednáno DOD,;
                        nMnozPlDod:Mn.plnìní DOD    ,;
                        nCenNaODOD:Nakupní cena DOD,;
                        nZboziKat:Kat.zboží ,;
                        nDoklad   ,;
                        cCisZakaz ,;
                        cCisZakazI ) ;
                FPOS( 0, 4) SIZE(100,16.5) CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)  ITEMSELECTED( RecordSelected)

* Filtr nad objednávkami
  TYPE(Static) STYPE(13) SIZE( 99.6,1.2) FPOS( 0.2, 3.1)  RESIZE(yn)
    TYPE(Text)     CAPTION( Objednávky) CPOS( 1, 0.1) CLEN( 10)
    TYPE(Static) STYPE(1) SIZE( 18,1.2) FPOS( 12, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 18) VALUES(1:Všechny           ,;
                                                                       2:Nevykryté všechny ,;
                                                                       3:Nevykryté zcela   ,;
                                                                       4:Vykryté èásteènì  ,;
                                                                       5:Vykryté zcela     );
                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)

* OBJVYSIT - INFO
  TYPE(Static) STYPE(1) SIZE(98, 5) FPOS(1,20.7) RESIZE(xy)
*   1.ø.
    TYPE(Text) CAPTION(Èís.obj. interní)   CPOS(  1, 0.1) CLEN( 15)
    TYPE(Text) NAME(OBJVYSIT->cCisObj)     CPOS(  1, 1.1) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Položka)            CPOS( 22, 0.1) CLEN(  7)
    TYPE(Text) NAME(OBJVYSIT->nIntCount)   CPOS( 22, 1.2) CLEN(  6) CTYPE(2) BGND( 13) GROUPS(clrGREY)
*   2.ø.
    TYPE(Text) CAPTION(Èís.obj. dodavatele)   CPOS(  1, 2.1) CLEN( 15)
    TYPE(Text) NAME(OBJVYSHD->cZakObjInt)     CPOS(  1, 3.1) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)

  TYPE(End)