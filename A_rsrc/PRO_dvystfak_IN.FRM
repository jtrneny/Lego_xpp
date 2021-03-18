TYPE(drgForm) DTYPE(10) TITLE(Zmìna data vystavení dokladu ...) SIZE(70,8)         ;
                                                                FILE(poklhd)       ;
                                                                POST(POSTVALIDATE) ;
                                                                GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_dvystFak)  TIPTEXT(uložit nové datum vystavení a období dokladu)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)      TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... doklad èíslo)          CPOS( 9, .1) FONT(2)
    TYPE(TEXT) NAME(ndoklad)                                        CPOS(27, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(na)                         CPOS(39, .1) FONT(2) CLEN(3)
    TYPE(TEXT) NAME(ncenzakcel)                                     CPOS(40, .1) FONT(5) CTYPE(2)
    TYPE(Text) NAME(czkratmeny)                                     CPOS(54, .1) FONT(2) CLEN(5)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(58.5, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT)  NAME(ncisFirmy)                                       CPOS( 10,2) FONT(8) CLEN(15) 
  TYPE(TEXT)  NAME(cnazev)                                          CPOS( 30,2) FONT(8) CLEN(68) 

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(69.2,3.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( datum vystavení doklad) CPOS( 6, .8 ) FONT( 2)    
    TYPE(GET)  NAME(M->dok_dvystFak)                             FPOS(30, .8 ) FLEN(12) FONT(2)
    TYPE(TEXT)                  CAPTION( období)                 CPOS(44, .8 ) FONT( 2) 
    TYPE(GET)  NAME(M->dok_cobdobi)                              FPOS(53, .8 ) FLEN( 8) FONT(2) BGND(13)      


    TYPE(TEXT)                  CAPTION( datum vystavení zmìna ) CPOS( 6, 2.1) FONT(2) 
    TYPE(GET)  NAME(dvystFak)                                    FPOS(30, 2.1) FLEN(12) FONT(2) PUSH(clickdate)  
    TYPE(TEXT)                  CAPTION( období)                 CPOS(44, 2.1) FONT(2)       
    TYPE(Get)  NAME(M->new_cobdobi)                              FPOS(53, 2.1) FLEN( 8) FONT(2) BGND(13)      
  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




