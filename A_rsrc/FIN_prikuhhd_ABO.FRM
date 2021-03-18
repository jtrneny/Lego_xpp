TYPE(drgForm) DTYPE(10) TITLE(Odeslání pøíkazu k úhradì (abo) ...) SIZE(70,8)     ;
                                                                   FILE(prikuhhd) ;
                                                                   GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Odeslat) EVENT(abo_Odeslat)  TIPTEXT(Odeslat pøíkaz do banky)  
  TYPE(Action) CAPTION(~Zrušit)  EVENT(abo_Zrusit)   TIPTEXT(Zrušit vytvoøený pøíkaz)           
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)    TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... pøíkaz k úhradì èíslo) CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(ndoklad)                                        CPOS(30, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(na)                         CPOS(42, .1) FONT(2) CLEN(3)
    TYPE(TEXT) NAME(ncenzakcel)                                     CPOS(45, .1) FONT(5)
    TYPE(Text) NAME(czkratmeny)                                     CPOS(59, .1) FONT(2) CLEN(5)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT)  NAME(M->typOdes)                                      CPOS( 1,1.6) FONT(5) CLEN(68) CTYPE(1)

  TYPE(STATIC) FPOS(0.4,2.8) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... dne) CPOS(12, .1) FONT(2)
    TYPE(TEXT) NAME(dprikuhr)                     CPOS(20, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(do)       CPOS(32, .1) FONT(2) CLEN(5)
    TYPE(TEXT) NAME(cbank_naz)                    CPOS(38, .1) FONT(2)
    TYPE(TEXT)                  CAPTION(...)      CPOS(63, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT) NAME(cfile_exp)                      CPOS( 5,5.1) FONT(5) CLEN(60) BGND(12) CTYPE(1)
  TYPE(TEXT) NAME(M->formatAbo)                   CPOS( 5,6.8)         CLEN(60)          CTYPE(1)                    

 TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)



