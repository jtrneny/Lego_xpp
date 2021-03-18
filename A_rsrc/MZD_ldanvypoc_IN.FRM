TYPE(drgForm) DTYPE(10) TITLE(Zmìna roèního zúètování danì ...) SIZE(70,8)         ;
                                                                FILE(msprc_mo)     ;
                                                                POST(POSTVALIDATE) ;
                                                                BORDER(4)          ;
                                                                GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_zuctDane)  TIPTEXT(Uložit nové roèní zúètování danì)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)      TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... pracovník èíslo)       CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(noscisPrac)                                     CPOS(20, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(_)                          CPOS(27, .1) FONT(2) CLEN( 3)
    TYPE(TEXT) NAME(cjmenoRozl)                                     CPOS(32, .1) FONT(5) CLEN(30)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN( 5)
  TYPE(END) 

  TYPE(TEXT)                   CAPTION(roèní zúèování danì)         CPOS( 25,2) FONT(8) CLEN(68)

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(69.2,3.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( roèní zúèování danì    )    CPOS(12, .8 ) FONT(2)    
    TYPE(TEXT) NAME(M->org_ldanVypoc)                                CPOS(40, .6 ) CLEN(8) FONT(8)

    TYPE(TEXT)                  CAPTION( roèní zúèování danì zmìna ) CPOS(12, 2.1) FONT(2) 
    TYPE(COMBOBOX) NAME(ldanVypoc)                                   FPOS(40, 2.1) FLEN(8)  REF( LYESNO) 
  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




