TYPE(drgForm) DTYPE(10) TITLE( SERVIS - editace ceníku zboží) SIZE( 105, 20);
              GUILOOK( Action:y, Menu:y)

  TYPE(Action) CAPTION(~AktDat)      EVENT( aktdat_agrikol)  TIPTEXT(Aktualizace poøadí pro fakturaci)


  TYPE(EBrowse) FILE(CENZBOZ)  INDEXORD(3);
                FPOS(0,0) SIZE( 105, 20) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y)

    TYPE(TEXT)  NAME(CENZBOZ->cCisSklad)    CLEN(  8)  CAPTION( Sklad )
    TYPE(TEXT)  NAME(CENZBOZ->cSklPol)      CLEN( 15)  CAPTION( Skl.položka )
    TYPE(TEXT)  NAME(CENZBOZ->cNazZbo)      CLEN( 30)  CAPTION( Název zboží )
    TYPE(TEXT)  NAME(CENZBOZ->cRozlAtr)     CLEN( 15)  CAPTION( Uplat.rozlišení)
    TYPE(TEXT)  NAME(M->PorVkat)            CLEN( 15)  CAPTION( Rozl.poø.u kateg.)
    TYPE(GET)   NAME(CENZBOZ->cRozPoradi)   FLEN( 15)  CAPTION( Rozl.poø.o skl.pol.)
    TYPE(GET)   NAME(CENZBOZ->nMnozSZbo)    FLEN( 13)  CAPTION( Skl.množství)
    TYPE(TEXT)  NAME(CENZBOZ->cZkratJedn)   CLEN(  5)  CAPTION( MJ )
    TYPE(GET)   NAME(CENZBOZ->nCenaSZbo)    FLEN( 13)  CAPTION( Cena/MJ)
    TYPE(GET)   NAME(CENZBOZ->nCenaCZbo)    FLEN( 13)  CAPTION( Cena celkem )

TYPE(END)
