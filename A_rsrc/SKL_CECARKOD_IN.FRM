TYPE(drgForm) DTYPE(10) TITLE( Editace èárových kódù ke skladovým kartám ) SIZE( 110, 20) ;
              POST(postValidate)                                                          ;
              GUILOOK( Menu:y,Action:n)

  TYPE(Static) FPOS(1,0.2) SIZE(108,2.5) STYPE(10) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Sklad)            CPOS(5  ,  .1) CLEN( 8)
    TYPE(Text) NAME(cenzboz->ccissklad)  CPOS(4.5, 1.1) CLEN( 8) CTYPE(3) FONT(5) 

    TYPE(TEXT) CAPTION(Skladová položka) CPOS(15,  .1) CLEN(15)
    TYPE(Text) NAME(cenzboz->csklpol)    CPOS(14, 1.1) CLEN(15) CTYPE(3) FONT(5)

    TYPE(TEXT) CAPTION(Název položky)    CPOS(35, .1) CLEN(15)
    TYPE(Text) NAME(cenzboz->cnazzbo)    CPOS(31,1.1) CLEN(50) CTYPE(3) FONT(5)
  TYPE(END)

*TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

  TYPE(EBrowse) FILE(CECARKOD)  INDEXORD(1);
                FPOS(0,3) SIZE( 110, 16) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(ny)

    TYPE(GET)  NAME( CECARKOD->cZkrCarKod)  FPOS( 1,0) FLEN( 15)  CAPTION( typkódu)
    TYPE(GET)  NAME( CECARKOD->cCarKod)     FPOS( 2,0) FLEN( 50)  CAPTION( èárový kód )
    TYPE(GET)  NAME( CECARKOD->nCisFirmy)   FPOS( 6,0) CLEN(  9)  CAPTION( firma )       PUSH(fir_firmy_sel)   
    TYPE(TEXT) NAME( CECARKOD->cNazev)      FPOS( 7,0) CLEN( 31)  CAPTION( název firmy )

  TYPE(END)