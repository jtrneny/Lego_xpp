TYPE(drgForm) DTYPE(10) TITLE( Editace odbìratelù zboží) SIZE( 110, 20);
              GUILOOK( Menu:y,Action:y)

*TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

  TYPE(EBrowse) FILE(ODBZBOZ)  INDEXORD(6);
                FPOS(0,0) SIZE( 110, 20) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y)

    TYPE(TEXT) NAME( ODBZBOZ->nCisFirmy)   FPOS( 1,0) CLEN(  8)  CAPTION( È.firmy )
    TYPE(TEXT) NAME( ODBZBOZ->cNazev)      FPOS( 2,0) CLEN( 25)  CAPTION( Název odbìratele )
    TYPE(GET)  NAME( ODBZBOZ->cCisSklad)   FPOS( 3,0) CLEN(  8)  CAPTION( Sklad )
    TYPE(GET)  NAME( ODBZBOZ->cSklPol)     FPOS( 4,0) CLEN( 15)  CAPTION( Skl.položka )
    TYPE(TEXT) NAME( ODBZBOZ->cNazZbo)     FPOS( 5,0) CLEN( 25)  CAPTION( Název položky )
    TYPE(GET ) NAME( ODBZBOZ->cNazDod1)    FPOS( 6,0) CLEN( 25)  CAPTION( Název položky u odbìratele)
    TYPE(GET)  NAME( ODBZBOZ->cZkrCarKod)  FPOS( 7,0) FLEN( 15)  CAPTION( Typ èár.kódu)
    TYPE(GET)  NAME( ODBZBOZ->cCarKod)     FPOS( 8,0) FLEN( 90)  CAPTION( Èárový kód )

TYPE(END)