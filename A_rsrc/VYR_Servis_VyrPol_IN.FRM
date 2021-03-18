TYPE(drgForm) DTYPE(10) TITLE( SERVIS - vyrábìné položky) SIZE( 105, 20);
              GUILOOK( Menu:y)

  TYPE(Action) CAPTION(Výmaz_kusov)   EVENT(empty_Kusov) TIPTEXT(Vymaže vyrábìné položky, kusovníky a vazby)

  TYPE(EBrowse) FILE(VYRPOL)  INDEXORD(4);
                FPOS(0,0) SIZE( 105, 20) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y)

    TYPE(TEXT) NAME( VYRPOL->cCisZakaz)    FPOS( 1,0) CLEN( 30)  CAPTION( Zakázka     )
    TYPE(GET)  NAME( VYRPOL->cVyrPOL)      FPOS( 2,0) FLEN( 15)  CAPTION( Vyr.položka )
    TYPE(GET)  NAME( VYRPOL->cNazev)       FPOS( 3,0) FLEN( 30)  CAPTION( Název položky)
    TYPE(GET)  NAME( VYRPOL->cCisVyk)      FPOS( 4,0) FLEN( 27)  CAPTION( Èíslo výkresu )

TYPE(END)