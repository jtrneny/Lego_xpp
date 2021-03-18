TYPE(drgForm) SIZE(97,15) DTYPE(10) TITLE(Pøednastavení plnìní pohybù k uživateli ...) ;
              GUILOOK(Action:n,IconBar:y)  

  TYPE(EBrowse) FPOS(.5,0.2) SIZE(96,16.5) FILE(USRTYPOH)          ;                                     
                    CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1)     ;
                    GUILOOK()
    TYPE(GET)  NAME(usrtypoh->cuser)      FLEN(12)
    TYPE(GET)  NAME(usrtypoh->ctask)      FLEN( 8)
    TYPE(GET)  NAME(usrtypoh->ctyppohybu) FLEN(14)
    TYPE(GET)  NAME(usrtypoh->cnazpol1)   FLEN(12) CAPTION(Støedisko) 
    TYPE(GET)  NAME(usrtypoh->cnazpol2)   FLEN(12)
    TYPE(GET)  NAME(usrtypoh->cnazpol3)   FLEN(12)
    TYPE(GET)  NAME(usrtypoh->cnazpol4)   FLEN(12)
    TYPE(GET)  NAME(usrtypoh->cnazpol5)   FLEN(12)
    TYPE(GET)  NAME(usrtypoh->cnazpol6)   FLEN(12)
  TYPE(END)




