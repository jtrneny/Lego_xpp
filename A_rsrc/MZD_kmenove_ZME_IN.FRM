TYPE(drgForm) DTYPE(10) TITLE(Zmìny kmenových údajù v uzavøeném období ...) SIZE(70,8)         ;
                                                                            FILE(msprc_mo)     ;
                                                                            POST(POSTVALIDATE) ;
                                                                            BORDER(4)          ;
                                                                            GUILOOK(IconBar:n,Menu:n)

  TYPE(Action) CAPTION(~Ok)      EVENT(save_Zmeny)  TIPTEXT(Uložit zmìny do matrièního souboru)  
  TYPE(Action) CAPTION(~Storno)  EVENT(140000002)   TIPTEXT(Návrat) 



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(69.2,1.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( ... pracovník èíslo)       CPOS( 2, .1) FONT(2)
    TYPE(TEXT) NAME(noscisPrac)                                     CPOS(20, .1) FONT(5)
    TYPE(TEXT)                  CAPTION(_)                          CPOS(27, .1) FONT(2) CLEN( 3)
    TYPE(TEXT) NAME(cjmenoRozl)                                     CPOS(32, .1) FONT(5) CLEN(30)
    TYPE(TEXT)                  CAPTION(...)                        CPOS(63, .1) FONT(2) CLEN( 5)
  TYPE(END) 

  TYPE(TEXT)                   CAPTION(zmìny v uzavøeném období úlohy)         CPOS( 18,2) FONT(8) CLEN(68)

  TYPE(STATIC) FPOS(0.4,3.8) SIZE(69.2,3.45) STYPE(13) CTYPE(2)
    TYPE(TEXT)                  CAPTION( generovat ELDP    ->)  CPOS( 6, .8 ) FONT(2)    
    TYPE(TEXT) NAME(M->org_lgenerELDP)                          CPOS(30, .8 ) CLEN(8) FONT(5)
    TYPE(TEXT)                  CAPTION( zmìna ->)              CPOS(40, .8 ) FONT(2) CLEN(10)
    TYPE(COMBOBOX) NAME(lgenerELDP)                             FPOS(50, .8 ) FLEN(10)  REF( LYESNO) 

    TYPE(TEXT)                  CAPTION( tisk mdového listu ->) CPOS( 6, 1.8 ) FONT(2)    
    TYPE(TEXT) NAME(M->org_ltiskMzdLi)                          CPOS(30, 1.8 ) CLEN(8) FONT(5)
    TYPE(TEXT)                  CAPTION( zmìna ->)              CPOS(40, 1.8 ) FONT(2) CLEN(10)
    TYPE(COMBOBOX) NAME(ltiskMzdLi)                             FPOS(50, 1.8 ) FLEN(10)  REF( LYESNO) 


  TYPE(END) 
                  
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)




