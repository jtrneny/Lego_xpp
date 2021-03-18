TYPE(drgForm) DTYPE(10) TITLE(Pøenos souborù z úlohy ...PALEÈEK...) SIZE(80,8) GUILOOK(IconBar:n,Menu:n)

  TYPE(ACTION) CAPTION(     ~Zpracovat) EVENT(zpracuj_Palecka_inTrans)  ICON1(107) ICON2(207) ATYPE(3)
  TYPE(ACTION) CAPTION(  ~Storno)       EVENT(140000002)                ICON1(110) ICON2(210) ATYPE(3)


  TYPE(STATIC) FPOS(0.5,0.5) SIZE(79,2.55) STYPE(14) CTYPE(2)
    TYPE(TEXT)      CAPTION(Datum pøenosu )   CPOS(5,0.1) CLEN(18) FONT(7) 
    TYPE(GET)       NAME(M->datZprac)  FPOS(23,0.1) FLEN(11) PP(2)  PUSH(CLICKDATE)

    TYPE(TEXT)      CAPTION(Vstupní adresáø ) CPOS(5,1.1) CLEN(18) FONT(7) 
    TYPE(GET)       NAME(M->workDir)  FPOS(23,1.1) FLEN(50) PP(2)  PUSH(sel_workDir)
  TYPE(END)


  TYPE(TEXT) CAPTION(Naètení dat ...)    CPOS( 2,4.5) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->stavZprac)          CPOS(22,5.8) CLEN( 0) FONT(2) BGND(13) PICTURE(999) GROUPS('FAKPRIHD:FPRIHD18::::') 

*  TYPE(TEXT) CAPTION(%)                  CPOS(29,4.5) CLEN( 3) 
    TYPE(STATIC) FPOS(17,4.5) SIZE(62,1) STYPE(13) CTYPE(1)                     GROUPS('FAKPRIHD') 
    TYPE(END) 
  
  TYPE(TEXT) CAPTION(Zápis dat    ...)    CPOS( 2,5.8) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->stavZprac)          CPOS(22,4.5) CLEN( 0) FONT(2) BGND(13) PICTURE(999) GROUPS('FAKVYSHD:FODBHD21::::')

*  TYPE(TEXT) CAPTION(%)                  CPOS(29,4.8) CLEN( 3) 
    TYPE(STATIC) FPOS(17,5.8) SIZE(62,1) STYPE(13) CTYPE(1)                     GROUPS('FAKVYSHD')  
    TYPE(END) 

 TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)


