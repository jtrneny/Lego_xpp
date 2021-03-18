*TYPE(drgForm) DTYPE(10) TITLE( Editace odbìratelù zboží) SIZE( 110, 20);
*              GUILOOK( Menu:y,Action:y)

*TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

*  TYPE(EBrowse) FILE(ODBZBOZ)  ;
*                FPOS(0,0) SIZE( 110, 20) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y)



TYPE(drgForm) DTYPE(10) TITLE(Editace odbìratelù zboží) FILE(ODBZBOZ) ;
              CARGO()                                                                  ;
              POST(postValidate)                                                       ;
              SIZE(115,20) GUILOOK(Action:n,IconBar:y)

  TYPE(EBROWSE) SIZE(115,19.5) FILE(ODBZBOZ)                                                      ;
                               ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(9) SCROLL(yy) ;
                               POPUPMENU(y)                                                      ;
                               LFREEZE(1)                                                        ;
                               GUILOOK(ins:y,del:n) 

    TYPE(GET)  NAME( ODBZBOZ->cSklPol)       FPOS( 1,0) CLEN( 15)  CAPTION( Skl.položka )  PUSH(skl_cenzboz_sel)
    TYPE(TEXT) NAME( ODBZBOZ->cCisSklad)     FPOS( 2,0) CLEN(  8)  CAPTION( Sklad) 
    TYPE(TEXT) NAME( ODBZBOZ->cNazZbo)       FPOS( 5,0) CLEN( 25)  CAPTION( Název položky)
    TYPE(GET)  NAME( ODBZBOZ->cNazOdb1)      FPOS( 6,0) CLEN( 25)  CAPTION( Název položky pro odbìratele)
    TYPE(GET)  NAME( ODBZBOZ->dDatumOD)      FPOS( 7,0) FLEN( 15)  CAPTION( Platnost OD)
    TYPE(GET)  NAME( ODBZBOZ->dDatumDO)      FPOS( 8,0) FLEN( 15)  CAPTION( Platnost DO)
    TYPE(GET)  NAME( ODBZBOZ->nMinObMnoz)    FPOS( 9,0) FLEN( 12)  CAPTION( Minim.objednací množ.)
    TYPE(GET)  NAME( ODBZBOZ->nMinExMnoz)    FPOS(10,0) FLEN( 12)  CAPTION( Minim.expedièní množ.)
    TYPE(GET)  NAME( ODBZBOZ->cZkratJEDN)    FPOS(11,0) FLEN(  8)  CAPTION( Zkratka jednotky)
    TYPE(GET)  NAME( ODBZBOZ->nDodLhuta)     FPOS(12,0) FLEN(  5)  CAPTION( Dodací lhùta ve dnech)   
    TYPE(GET)  NAME( ODBZBOZ->nCenaPzbo)     FPOS(13,0) FLEN( 12)  CAPTION( Prodejní cena bez danì)
    TYPE(GET)  NAME( ODBZBOZ->nCenaMzbo)     FPOS(14,0) FLEN( 12)  CAPTION( Prodejní cena s daní)
    TYPE(GET)  NAME( ODBZBOZ->cZkratMENY)    FPOS(15,0) FLEN(  8)  CAPTION( Zkratka mìny)
    TYPE(GET)  NAME( ODBZBOZ->cZkrCarKod)    FPOS(16,0) FLEN( 15)  CAPTION( Typ èár.kódu)
    TYPE(GET)  NAME( ODBZBOZ->cCarKod)       FPOS(17,0) FLEN( 90)  CAPTION( Èárový kód )
    TYPE(TEXT) NAME( ODBZBOZ->cKatcZbo)      FPOS(18,0) CLEN( 15)  CAPTION( Kategorie zboží)
    TYPE(TEXT) NAME( ODBZBOZ->dDatPPro)      FPOS(19,0) CLEN( 15)  CAPTION( Datum posl.prodeje)
    TYPE(TEXT) NAME( ODBZBOZ->nCisFirmy)     FPOS(20,0) CLEN(  8)  CAPTION( È.firmy)  //   PUSH(fir_firmy_sp_sel)
    TYPE(TEXT) NAME( ODBZBOZ->cNazFirmy)     FPOS(21,0) CLEN( 25)  CAPTION( Název dodavatele )
  TYPE(END)

  TYPE(Text) NAME(ODBZBOZ->nCENZBOZ)  CPOS( 0,0)   CLEN( 0) CTYPE(2) BGND( 13) PP(1)

TYPE(END)