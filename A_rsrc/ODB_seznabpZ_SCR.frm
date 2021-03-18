TYPE(drgForm) DTYPE(10) TITLE(Nabídky pøijaté) SIZE(100,25) GUILOOK(Action:y,IconBar:y) 

TYPE(Action) CAPTION(vstup ~Dat) EVENT(firmy_DLG) TIPTEXT(Poøízení/Oprava nabídky pøijaté)

  TYPE(Browse) SIZE(100,14) FILE(ODB_POLNABP) INDEXORD(1) FIELDS(nCISFIRMY,FIR_FIRMY->cNAZEV,cNAZEVNAZ,nZBOZIKAT,nCENANAB,nCENAZNAB) ;
               FPOS(.5,.5) CURSORMODE(3) PP(1) RESIZE(yy) SCROLL(ny)
  TYPE(Static) STYPE(11) SIZE(98,8.8) FPOS(1,14.8) 
* 1
    TYPE(Text) CAPTION(Název zboží ...)       CPOS(  1, .5)   
    TYPE(Text) NAME(ODB_POLNABP->CNAZEVNAZ)   CPOS( 22, .5) CLEN(25) BGND(13)
    TYPE(Text) CAPTION(Èíslo nabídky ...)     CPOS( 60, .5) 
    TYPE(Text) NAME(ODB_POLNABP->NCISNAB)     CPOS( 77, .5) CLEN( 7) BGND(13)
    TYPE(Text) NAME(ODB_POLNABP->DDATNAB)     CPOS( 87, .5) CLEN(10) BGND(13)  
* 2
    TYPE(Text) CAPTION(Katalogové èíslo ... )  CPOS(  1,1.5)
    TYPE(Text) NAME(ODB_POLNABP->CKATCNAB)     CPOS( 22,1.5) CLEN(13) BGND(13)
* 3
    TYPE(Text) CAPTION(Nabízené množství ...)  CPOS(  1,4  ) 
    TYPE(Text) NAME(ODB_POLNABP->NMNOZNAB)     CPOS( 22,4  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) CAPTION(Cena zboží)             CPOS( 40,2.8) 
    TYPE(Text) CAPTION(Prodejní cena)          CPOS( 60,2.8) 
    TYPE(Text) CAPTION(Pøepoètená cena)        CPOS( 80,2.8) 
    TYPE(Text) NAME(ODB_POLNABP->NCENANAB)     CPOS( 40,4  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(ODB_POLNABP->NCENAKNAB)    CPOS( 60,4  ) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(ODB_POLNABP->NCENAKNAB)    CPOS( 80,4  ) CLEN(13) BGND(13) CTYPE(2)
* 4
    TYPE(Text) CAPTION(Firma ...)              CPOS(45, 5.5) FONT(6) 
    TYPE(Text) NAME(FIR_FIRMY->NCISFIRMY)      CPOS(60, 5.5) CLEN(10) BGND(13) CTYPE(2)
    TYPE(Text) NAME(FIR_FIRMY->CNAZEV)         CPOS(72, 5.5) CLEN(25) BGND(13)     
* 5
    TYPE(Text) CAPTION(Sídlo firmy ...)        CPOS(45, 6.5) FONT(6)  
    TYPE(Text) NAME(FIR_FIRMY->cPSC)           CPOS(60, 6.5) CLEN(10) BGND(13)
    TYPE(Text) NAME(FIR_FIRMY->CULICE)         CPOS(72, 6.5) CLEN(25) BGND(13)
    TYPE(Text) NAME(FIR_FIRMY->cSIDLO)         CPOS(60, 7.5) CLEN(37) BGND(13)      

    TYPE(Static) STYPE(12) SIZE(98,.1) FPOS(0,3.2) RESIZE(y)
    TYPE(End) 
  TYPE(End)



