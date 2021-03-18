TYPE(drgForm) DTYPE(10) TITLE(Zmìna data splatnosti dokladu ...) SIZE(70,8)         ;
                                                                 FILE(fakvyshd)     ;
                                                                 POST(POSTVALIDATE) ;
                                                                 GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_splatFak)  TIPTEXT(uložit nové datum splatnosti dokladu)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)      TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... faktura èíslo)         CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(ncisFak)                                        CPOS(30, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(na)                         CPOS(42, .1) FONT(2) CLEN(3)
    TYPE(TEXT) NAME(ncenzakcel)                                     CPOS(45, .1) FONT(5)
    TYPE(Text) NAME(czkratmeny)                                     CPOS(59, .1) FONT(2) CLEN(5)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT)  NAME(ncisFirmy)                                       CPOS( 10,2) FONT(8) CLEN(15) 
  TYPE(TEXT)  NAME(cnazev)                                          CPOS( 30,2) FONT(8) CLEN(68) 

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(69.2,3.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( datum splatnosti doklad) CPOS(12, .8 ) FONT(2)    
    TYPE(TEXT) NAME(M->dok_dsplatFak)                             CPOS(40, .8 ) CLEN(13) FONT(2) BGND(13)   

    TYPE(TEXT)                  CAPTION( datum splatnosti zmìna ) CPOS(12, 2.1) FONT(2) 
    TYPE(GET)  NAME(dsplatFak)                                    FPOS(40, 2.1) FLEN(12) FONT(2) PUSH(clickdate)  
  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




