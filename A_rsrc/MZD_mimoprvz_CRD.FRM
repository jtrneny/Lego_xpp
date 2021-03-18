TYPE(drgForm) DTYPE(10) TITLE(Nastavení mimopracovního stavu) SIZE(84,10) FILE(MIMPRVZw) ;
                        GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n)           ; 
                        BORDER(2) PRE(preValidate) POST(postValidate)

  TYPE(EBrowse) FPOS( 0, 1.7) SIZE(83,8) FILE( mimprvzW )                                       ;
                              ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                              GUILOOK(sizecols:n,headmove:n)                                 

     TYPE(CHECKBOX) NAME(mimprvzW->laktiv)       CLEN( 3)  CAPTION(akt)              REF(LYESNO)
     TYPE(TEXT)     NAME(mimprvzW->nporMiPVzt)   CLEN( 5)  CAPTION(poø)
     TYPE(GET)      NAME(mimprvzW->nmimoPrVzt)   FLEN(10)  FCAPTION(typ)
     TYPE(TEXT)     NAME(mimprvzW->cnazMimPrV)   CLEN(30)  CAPTION(název Ev_Vztahu)
     TYPE(GET)      NAME(mimprvzW->dmimPrVzOd)   FLEN(12)  FCAPTION(datOd)
     TYPE(GET)      NAME(mimprvzW->dmimPrVzDo)   FLEN(12)  FCAPTION(datDo)
     TYPE(CHECKBOX) NAME(mimprvzW->lgenMzdDok)   CLEN( 3)  CAPTION(genDokl)          REF(LYESNO)
  TYPE(END)


  TYPE(STATIC) STYPE(2) FPOS(1,-0.25) SIZE(82.05,1.25) RESIZE(yn)
    TYPE(TEXT) FCAPTION(Typ evidenèního vztahu ...)                CPOS(1.5, 0.6) CLEN(30) FONT(5)

** JT **    TYPE(PUSHBUTTON) CAPTION(  ~Pøevzít položku do dokladu)                     ;
*                     POS(56.5,.6) SIZE(25,1.1) ATYPE(3) ICON1(429) ICON2(430)   ;
*                     EVENT(save_marked) TIPTEXT( Pøevzít položku do dokladu ...(CTRL_W))

    TYPE(PushButton) POS(78.5,0.6) SIZE(3,1) ATYPE(1) ICON1(102) ICON2(202) EVENT(140000002) TIPTEXT(Ukonèi dialog)
  TYPE(END)
TYPE(END)



