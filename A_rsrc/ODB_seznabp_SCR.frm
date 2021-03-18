TYPE(drgForm) DTYPE(10) TITLE(Nabídky pøijaté) SIZE(100,25) GUILOOK(Action:n,IconBar:y) CARGO(ODB_seznabp_CRD)

* TYPE(Action) CAPTION(vstup ~Dat) EVENT(firmy_DLG) TIPTEXT(Poøízení/Oprava nabídky pøijaté)

  TYPE(Browse) SIZE(28,23) FILE(SEZNABP) FIELDS(nCISFIRMY,nCISNAB,dDATNAB) ;
               FPOS(.5,.5) CURSORMODE(3) PP(1) ITEMMARKED(itemMarked) SCROLL(ny)

  TYPE(Browse) SIZE(70,15) FILE(POLNABP) INDEXORD(1) FIELDS(cNAZEVNAZ::29,nZBOZIKAT,nCENANAB,nCENAZNAB) ;
               FPOS(29,.5) CURSORMODE(3) PP(1) RESIZE(yy) SCROLL(ny)

  TYPE(Static) STTYPE(12) SIZE(70,7) FPOS(29,16)
    TYPE(Text) CAPTION(Katalogové èíslo ... )  CPOS(  1,1.5)
    TYPE(Text) NAME(POLNABP->CKATCNAB)     CPOS( 22,1.5) CLEN(13) BGND(13)

    TYPE(Text) CAPTION(Nabízené množství ...)  CPOS(  1,2.5) 
    TYPE(Text) NAME(POLNABP->NMNOZNAB)     CPOS( 22,2.5) CLEN(13) BGND(13) CTYPE(2)

    TYPE(Text) CAPTION(Cena zboží)         CPOS( 12,4  ) 
    TYPE(Text) CAPTION(Prodejní cena)      CPOS( 27,4  ) 
    TYPE(Text) CAPTION(Pøepoètená cena)    CPOS( 42,4  ) 
    TYPE(Text) NAME(POLNABP->NCENANAB)     CPOS( 12,5  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(POLNABP->NCENAKNAB)    CPOS( 27,5  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(POLNABP->NCENAKNAB)    CPOS( 42,5  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Static) STYPE(12) SIZE(69,.1) FPOS(.2,4.5) RESIZE(y)
    TYPE(End) 
  TYPE(End)

