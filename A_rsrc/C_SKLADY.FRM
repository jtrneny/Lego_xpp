TYPE(drgForm) DTYPE(2) TITLE(Èíselník skladù) SIZE(60,15) FILE(C_SKLADY);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE(tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_SKLADY) FIELDS(CCISSKLAD:sklad        , ;
                                                  CNAZSKLAD:název skladu , ;
                                                  CZKRATMENY:zkrMìny     , ;
                                                  CVNBAN_UCT             , ;
                                                  NPRIRAZKA                ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE(tabSelect)
  TYPE(GET)      NAME(CCISSKLAD)  FPOS(16,1) FLEN( 8) FCAPTION(Èíslo skladu)        CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(CNAZSKLAD)  FPOS(16,2) FLEN(25) FCAPTION(Název skladu)        CPOS(1,2)
  TYPE(ComboBox) NAME(CZKRATMENY) FPOS(16,3) FLEN(26) FCAPTION(Základní mìna ... )  CPOS(1,3) PP(2) ;
                   VALUES(C_MENY->CZKRATMENY:CNAZMENY) NOREVISION()

  TYPE(GET)      NAME(CVNBAN_UCT) FPOS(16,4) FLEN(25) FCAPTION(Úèet u vnitrobanky)  CPOS(1,4)
  TYPE(GET)      NAME(NPRIRAZKA)  FPOS(16,5) FLEN( 6) FCAPTION(Pøirážka)            CPOS(1,5)
  TYPE(COMBOBOX) NAME(lRangePVP)  FPOS(16,6) FLEN( 7) FCAPTION(Rozlišovat èís.øady) CPOS(1,6) REF( lYESNO)

  TYPE(TEXT)     CAPTION(Èíselné øady skladových dokladù) CLEN(30)                  CPOS(1,7.5) FONT(5)

  TYPE(GET)      NAME(nPrijemOd)     FPOS( 16,  8.5) FLEN(12) FCAPTION(- Pøíjemky)      CPOS( 5,  8.5)
  TYPE(TEXT)     CAPTION(-)          CPOS( 30,  8.5) CLEN( 2)
  TYPE(GET)      NAME(nPrijemDo)     FPOS( 32,  8.5) FLEN(12) 

  TYPE(GET)      NAME(nVydejOd)      FPOS( 16,  9.5) FLEN(12) FCAPTION(- Výdejky)       CPOS( 5,  9.5)
  TYPE(TEXT)     CAPTION(-)          CPOS( 30,  9.5) CLEN( 2)
  TYPE(GET)      NAME(nVydejDo)      FPOS( 32,  9.5) FLEN(12) 

  TYPE(GET)      NAME(nPrevodOd)     FPOS( 16, 10.5) FLEN(12) FCAPTION(- Pøevodky)      CPOS( 5, 10.5)
  TYPE(TEXT)     CAPTION(-)          CPOS( 30, 10.5) CLEN( 2)
  TYPE(GET)      NAME(nPrevodDo)     FPOS( 32, 10.5) FLEN(12) POST( postLastField_2)

TYPE(End)