TYPE(drgForm) DTYPE(10) TITLE(Bilance pohledávek a závazkù ...) SIZE(80,8) GUILOOK(IconBar:n,Menu:n)

  TYPE(ACTION) CAPTION(     ~Zpracovat) EVENT(zpracuj_podklady) ICON1(107) ICON2(207) ATYPE(3)
  TYPE(ACTION) CAPTION(  ~Storno)       EVENT(140000002)        ICON1(110) ICON2(210) ATYPE(3)


  TYPE(STATIC) FPOS(0.5,0.5) SIZE(79,1.55) STYPE(14) CTYPE(2)
    TYPE(TEXT)      CAPTION(Zpracovat podklady k  _ ) CPOS(19,0.1) CLEN(24) FONT(7) 
    TYPE(GET)       NAME(M->datZprac)  FPOS(44,0.1) FLEN(11) PP(2)  PUSH(CLICKDATE)
    TYPE(CHECKBOX)  NAME(M->lsetZprac) FPOS(60,0.1) FLEN(16) VALUES(T:neuhrazené,F:kompletní)

  TYPE(END)


  TYPE(TEXT) CAPTION(Závazky ...)     CPOS( 2,3.5) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->stavZprac)          CPOS(22,4.8) CLEN( 0) FONT(2) BGND(13) PICTURE(999) GROUPS('FAKPRIHD:FPRIHD18::::') 

*  TYPE(TEXT) CAPTION(%)                  CPOS(29,3.5) CLEN( 3) 
    TYPE(STATIC) FPOS(17,3.5) SIZE(62,1) STYPE(13) CTYPE(1)                     GROUPS('FAKPRIHD') 
    TYPE(END) 
  
  TYPE(TEXT) CAPTION(Pohledávky ...)     CPOS( 2,4.8) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->stavZprac)          CPOS(22,3.5) CLEN( 0) FONT(2) BGND(13) PICTURE(999) GROUPS('FAKVYSHD:FODBHD21::::')

*  TYPE(TEXT) CAPTION(%)                  CPOS(29,4.8) CLEN( 3) 
    TYPE(STATIC) FPOS(17,4.8) SIZE(62,1) STYPE(13) CTYPE(1)                     GROUPS('FAKVYSHD')  
    TYPE(END) 

 TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)


