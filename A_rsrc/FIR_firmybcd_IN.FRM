TYPE(drgForm) DTYPE(10) TITLE(Pøidìlìné identifikace èárového kódu k firmì ...) SIZE(93,14) FILE(FIRMYBCD) ;
              GUILOOK(All:n) BORDER(4) POST(postValidate)

  TYPE(EBROWSE) FPOS(.1,.1) SIZE(92.9,9.8) FILE(FIRMYBCD)                                      ;
                            INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                            GUILOOK(headmove:n)

     TYPE(GET)  NAME(firmybcd->cZkrCarKod) FLEN(12)    CAPTION(typKódu)
     TYPE(TEXT) NAME(       M->nazCarKod) CLEN(36)    CAPTION(název Èárového kódu)
     TYPE(GET)  NAME(firmybcd->cCarKod)    FLEN(25)    CAPTION(èárový Kód) 
  TYPE(END)


TYPE(Static) STYPE(12) SIZE(92.9,4) FPOS(.1,10) RESIZE(ny) CTYPE(2)
* P
  TYPE(Text) CAPTION(Èíslo firmy)   CPOS( 5,  .1)   
  TYPE(Text) NAME(FIRMY->NCISFIRMY) CPOS( 5, 1.1) CLEN(10) BGND(13) PP(2)
  TYPE(Text) CAPTION(Název firmy)   CPOS(18,  .1) 
  TYPE(Text) NAME(FIRMY->CNAZEV)    CPOS(18, 1.1) CLEN(25) BGND(13) PP(2)     
  TYPE(Text) CAPTION([)             CPOS( 5, 2.1) CLEN( 2) 
  TYPE(Text) NAME(FIRMY->CZASTUPCE) CPOS( 7, 2.1) CLEN(35) FONT(5) CTYPE(1)
  TYPE(Text) CAPTION(])             CPOS(43, 2.1) CLEN( 2) 

* L
  TYPE(Text) CAPTION(Sídlo firmy)   CPOS(50,  .1)   
  TYPE(Text) NAME(FIRMY->CULICE)    CPOS(50, 1.1) CLEN(38) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->cPSC)      CPOS(50, 2.1) CLEN(10) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->cSIDLO)    CPOS(63, 2.1) CLEN(25) BGND(13) PP(2)      
*  TYPE(Static) STYPE(16) SIZE(108,1) FPOS(0,2.5) RESIZE(y)
TYPE(END)

