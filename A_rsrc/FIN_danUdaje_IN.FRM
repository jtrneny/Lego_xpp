TYPE(drgForm) DTYPE(10) TITLE(Zmìna daòových údajù dokladu ...) SIZE(75,8)         ;
                                                                FILE(fakvyshd)     ;
                                                                POST(POSTVALIDATE) ;
                                                                GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_danUdaje)  TIPTEXT(uložit nové daònové údaje do dokladu)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)      TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(74.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... faktura èíslo)         CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(ncisFak)                                        CPOS(30, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(na)                         CPOS(42, .1) FONT(2) CLEN(3)
    TYPE(TEXT) NAME(ncenzakcel)                                     CPOS(45, .1) FONT(5)
    TYPE(Text) NAME(czkratmeny)                                     CPOS(59, .1) FONT(2) CLEN(5)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT)  NAME(ncisFirmy)                                       CPOS( 10,2) FONT(8) CLEN(15) 
  TYPE(TEXT)  NAME(cnazev)                                          CPOS( 30,2) FONT(8) CLEN(68) 

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(74.2,4) STYPE(13) CTYPE(2)
    TYPE(TEXT) CAPTION( Ièo             doklad)              CPOS( 1, .5 ) CLEN(18) FONT(2)  
    TYPE(GET)  NAME(M->dok_nIco)                             FPOS(19, .5 ) FLEN(12) FONT(5) 
    TYPE(TEXT) CAPTION( - zmìna -> )                         CPOS(41, .5 ) CLEN(11) FONT(2)
    TYPE(GET)  NAME(nIco)                                    FPOS(52, .5 ) FLEN( 8)    

    TYPE(TEXT) CAPTION( Diè             doklad)              CPOS( 1,1.6 ) CLEN(18) FONT(2)
    TYPE(GET)  NAME(M->dok_cdic)                             FPOS(19,1.6 ) FLEN(16) FONT(5)
    TYPE(TEXT) CAPTION( - zmìna -> )                         CPOS(41,1.6 ) CLEN(11) FONT(2)   
    TYPE(GET)  NAME(cDic)                                    FPOS(52,1.6 ) FLEN(16) 

    TYPE(TEXT) CAPTION( Daò_doklad doklad)                   CPOS( 1,2.6 ) CLEN(18) FONT(2)
    TYPE(GET)  NAME(M->dok_cdanDoklad)                       FPOS(19,2.6 ) FLEN(20) FONT(5)
    TYPE(TEXT) CAPTION( - zmìna -> )                         CPOS(41,2.6 ) CLEN(11) FONT(2)   
    TYPE(GET)  NAME(cdanDoklad)                              FPOS(52,2.6 ) FLEN(20) 
  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




