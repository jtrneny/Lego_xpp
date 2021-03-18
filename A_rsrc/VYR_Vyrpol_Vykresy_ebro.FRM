TYPE(drgForm) DTYPE(10) TITLE( Editace èísel výkresù) SIZE( 120, 20);
              GUILOOK( Menu:y,Action:y)

*TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

  TYPE(EBrowse) FILE(VYRPOL)  INDEXORD(6);
                FPOS(0,0) SIZE( 120, 20) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y)

    TYPE(TEXT) NAME( vyrpol->ccissklad) FPOS( 1,0) CLEN( 7)   CAPTION( Sklad )
    TYPE(TEXT) NAME( vyrpol->cvyrpol)   FPOS( 2,0) CLEN( 15)  CAPTION( Vyrábìná pol.)
    TYPE(TEXT) NAME( vyrpol->cNazev)    FPOS( 3,0) CLEN( 23)  CAPTION( Název vyr.položky )
    TYPE(GET)  NAME( vyrpol->ccisvyk)   FPOS( 4,0) FLEN( 26)  CAPTION( Èíslo výkresu)
    TYPE(GET)  NAME( vyrpol->cnazvyk)   FPOS( 5,0) FLEN( 45)  CAPTION( Název výkresu)

TYPE(END)