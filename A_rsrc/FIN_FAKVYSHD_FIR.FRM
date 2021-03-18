TYPE(drgForm) SIZE(50,17) DTYPE(10) TITLE(Výbìr firmy dokladu ...) CARGO(FIR_FIRMY_CRD) ;
                          GUILOOK(Action:n)


  TYPE(Browse) SIZE(50,12) FILE(FIRMY) FIELDS(cNAZEV::30,nCISFIRMY,nICO) ;
               CURSORMODE(3) SCROLL(ny) PP(7)

 TYPE(Static) STYPE(13) SIZE(48,4) FPOS(1,12.5) RESIZE(y) CTYPE(2)

* 1
    TYPE(Text) CAPTION(Sídlo firmy ...) CPOS(  1, .5) CLEN(11)
    TYPE(Text) NAME(FIRMY->cULICE)      CPOS( 12, .5) CLEN(34) BGND(13) PP(2) 
* 2
    TYPE(Text) NAME(FIRMY->cPSC)        CPOS( 12,1.5) CLEN( 8) BGND(13) PP(2)
    TYPE(Text) NAME(FIRMY->cSIDLO)      CPOS( 21,1.5) CLEN(25) BGND(13) PP(2)
* 3
    TYPE(Text) CAPTION(REG_dph   > )    CPOS(  1,2.7) 
    TYPE(Text) NAME(FIRMY->dREGDPH_OD)  CPOS( 21,2.7) CLEN(10) BGND(13) PP(2)
    TYPE(Text) CAPTION(/)               CPOS( 33,2.7)  CLEN(3)
    TYPE(Text) NAME(FIRMY->dREGDPH_DO)  CPOS( 36,2.7) CLEN(10) BGND(13) PP(2)
  TYPE(End)


