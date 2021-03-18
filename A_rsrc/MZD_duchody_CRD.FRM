TYPE(drgForm) DTYPE(10) TITLE(Nastavení dùchodù) SIZE(84,10) FILE(DUCHODYw) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n)        ;  
              BORDER(2) PRE(preValidate) POST(postValidate)

 TYPE(EBrowse) FPOS( 0, 1.7) SIZE(83,8) FILE( duchodyW )                                        ;
                              ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                              GUILOOK(sizecols:n,headmove:n)                                 

     TYPE(CHECKBOX) NAME(duchodyW->laktiv)       CLEN( 3)  CAPTION(akt)              REF(LYESNO)
     TYPE(TEXT)     NAME(duchodyW->nporDuchod)   CLEN( 5)  CAPTION(poø)
     TYPE(GET)      NAME(duchodyW->ntypDuchod)   FLEN(10)  FCAPTION(typ)
     TYPE(TEXT)     NAME(duchodyW->cnazDuchod)   CLEN(30)  CAPTION(název dùchodu)
     TYPE(GET)      NAME(duchodyW->dpriznDuOd)   FLEN(12)  FCAPTION(datOd)
     TYPE(GET)      NAME(duchodyW->dpriznDuDo)   FLEN(12)  FCAPTION(datDo)
  TYPE(END)


  TYPE(STATIC) STYPE(2) FPOS(1,-0.25) SIZE(82.05,1.25) RESIZE(yn)
    TYPE(TEXT) FCAPTION(Typ dùchodu ...)                CPOS(1.5, 0.6) CLEN(30) FONT(5)

** JT **    TYPE(PUSHBUTTON) CAPTION(  Pøevzít položku do dokladu)                      ;
*                     POS(56.5,.6) SIZE(25,1.1) ATYPE(3) ICON1(429) ICON2(430)   ;
*                     EVENT(save_marked) TIPTEXT( Pøevzít položku do dokladu ...(CTRL_W))

    TYPE(PushButton) POS(78.5,0.6) SIZE(3,1) ATYPE(1) ICON1(102) ICON2(202) EVENT(140000002) TIPTEXT(Ukonèi dialog)
  TYPE(END)
TYPE(END)



