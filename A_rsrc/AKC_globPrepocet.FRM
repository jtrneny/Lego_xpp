TYPE(drgForm) DTYPE(10) TITLE(Kontrolní pøepoèet akcií a hlasù ...) SIZE(80,7) GUILOOK(IconBar:n,Menu:n)

  TYPE(ACTION) CAPTION(     ~Zpracovat) EVENT(zpracuj_podklady) ICON1(107) ICON2(207) ATYPE(3)
  TYPE(ACTION) CAPTION(  ~Storno)       EVENT(140000002)        ICON1(110) ICON2(210) ATYPE(3)


  TYPE(STATIC) FPOS(0.5,0.5) SIZE(79,1.55) STYPE(14) CTYPE(2)
    TYPE(TEXT)      CAPTION(Zpracovat kontrolní pøepoèet k _ ) CPOS(19,0.1) CLEN(25) 
    TYPE(TEXT)      NAME(M->datZprac)  CPOS(45,0.1) CLEN(15) PP(2) FONT(7)
  TYPE(END)


  TYPE(TEXT) CAPTION(Akcionáøi ...)      CPOS( 2,4) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->stavZprac)          CPOS(22,4.8) CLEN( 0) FONT(2) BGND(13) PICTURE(999) GROUPS('AKCIONAR_G:AKCIONAR01::::') 

*  TYPE(TEXT) CAPTION(%)                  CPOS(29,3.5) CLEN( 3) 
    TYPE(STATIC) FPOS(17,3.5) SIZE(62,2) STYPE(13) CTYPE(1)                     GROUPS('AKCIONAR_G') 
    TYPE(END) 

 TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)


