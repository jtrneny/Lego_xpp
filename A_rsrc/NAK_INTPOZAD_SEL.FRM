TYPE(drgForm) DTYPE(10) TITLE(Interní požadavky - VÝBÌR) SIZE(100,15);
              GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

* FIRMA - potenciální dodavatel
  TYPE(Static) STYPE(1) SIZE(98,2.8) FPOS(1,0.2) RESIZE(xy)
    TYPE(Text) CAPTION(Firma)              CPOS( 1, 0.2) CLEN(  6) FONT(5)
    TYPE(Text) NAME(intPozad->nCisFirmy)   CPOS( 1, 1.2) CLEN(  7) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Název dodavatele)   CPOS( 8, 0.2) CLEN( 25) FONT(5)
    TYPE(Text) NAME(FIRMY->cNazev)         CPOS( 8, 1.2) CLEN( 28) BGND( 13) PP(2)
    TYPE(Text) CAPTION(IÈO)                CPOS(36, 0.2) CLEN(  8) FONT(5)
    TYPE(Text) NAME(FIRMY->nIco)           CPOS(36, 1.2) CLEN( 10) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Sídlo firmy)        CPOS(48, 0.2) CLEN( 25) FONT(5)
    TYPE(Text) NAME(FIRMY->CULICE)         CPOS(48, 1.2) CLEN( 20) BGND(13) PP(2)
    TYPE(Text) NAME(FIRMY->cPSC)           CPOS(70, 1.2) CLEN(  6) BGND(13) PP(2)
    TYPE(Text) NAME(FIRMY->cSIDLO)         CPOS(77, 1.2) CLEN( 20) BGND(13) PP(2)
  TYPE(End)

* interní požadavky vystavené k dodavateli ??
  TYPE(DBrowse) FILE(intPozad) INDEXORD(1) ;
                FIELDS(ncisIntPoz:intPož          , ; 
                       ccisSklad:èísSklad         , ;                       
                       csklPol:sklPoložka         , ;
                       CNAZZBO:název zboží:25     , ;
                       nZboziKat:katZbo           , ;
                       nCenNaODOD:Nakupní cena DOD, ;
                       nMnozObDod:Mn.objednáno DOD, ;
                       nMnozPlDod:Mn.plnìní DOD   , ;
                       cCisZakaz:zakázka:15       , ;
                       cCisZakazI:výrÈíslo:15        ) ;
                FPOS( 0, 3) SIZE(100,11.5) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy) POPUPMENU(y);
                ITEMSELECTED( RecordSelected)


* INTPOZAD - INFO
*  TYPE(Static) STYPE(1) SIZE(98, 5) FPOS(1,13.7) RESIZE(xy)
*   1.ø.
*    TYPE(Text) CAPTION(Èíslo objednávky)   CPOS(  1, 0.2) CLEN( 15) FONT(5)
*    TYPE(Text) NAME(OBJVYSIT->cCisObj)     CPOS(  1, 1.2) CLEN( 20) BGND( 13) PP(2)
*    TYPE(Text) CAPTION(Položka)            CPOS( 22, 0.2) CLEN(  7)
*    TYPE(Text) NAME(OBJVYSIT->nIntCount)   CPOS( 22, 1.2) CLEN(  6) CTYPE(2) BGND( 13) PP(2)
*   2.ø.
*  TYPE(End)