TYPE(drgForm) DTYPE(10) TITLE(Zmìna formy úhrady dokladu ...) SIZE(70,8)         ;
                                                              FILE(fakvyshd)     ;
                                                              POST(POSTVALIDATE) ;
                                                              GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_typUhrFak)  TIPTEXT(uložit novou formu úhrady)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)       TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... faktura èíslo)         CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(ncisFak)                                        CPOS(30, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(na)                         CPOS(42, .1) FONT(2) CLEN(3)
    TYPE(TEXT) NAME(ncenzakcel)                                     CPOS(45, .1) FONT(5)
    TYPE(Text) NAME(czkratmeny)                                     CPOS(59, .1) FONT(2) CLEN(5)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN(5)
  TYPE(END) 

  TYPE(TEXT)  NAME(ncisFirmy)                                       CPOS(  2,2) FONT(8) CLEN(15) 
  TYPE(TEXT)  NAME(cnazev)                                          CPOS( 17,2) FONT(8) CLEN(60) 

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(69.2,3.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                      CAPTION( forma úhrady doklad ->) CPOS(3, .8 ) FONT(2) CLEN(22) 
    TYPE(PushButton)                CAPTION( Platba v hotovosti ) ;
                                    POS( 25, .75)                 ;
                                    SIZE(39, 1.2) EVENT(dokl_typUhr) ICON1(427) ICON2(428) ATYPE(3)

    TYPE(TEXT)                      CAPTION( forma úhrady zmìna ->) CPOS(3, 2.1) FONT(2) 
    TYPE(PushButton)                POS(25,2.1) SIZE(39,1.2) CAPTION() EVENT(createContext) ICON1(338) ATYPE(33)


*    TYPE(ComboBox) NAME(czkrTypUhr) FPOS(25, 2.1) FLEN(39) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2)
  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




