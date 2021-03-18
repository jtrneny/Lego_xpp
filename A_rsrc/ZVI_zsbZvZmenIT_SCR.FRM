TYPE(drgForm) DTYPE(10) TITLE( ZVI - Položky dokladu ) SIZE(90,11) FILE( ZvZmenITw) ;
              GUILOOK(Action:n,IconBar:n,Menu:n,Message:n ) BORDER(4) ;
              POST( POSTVALIDATE)

* Položky dokladù
  TYPE(EBrowse) FILE( ZvZmenITw) FPOS(0,0) SIZE(90,10.6) ;
                CURSORMODE(3) SCROLL(ny) PP(7)
*                ITEMMARKED(itemMarked)
*
    TYPE(TEXT)     NAME(ZVI_zsbPohybyIT_1() )     FPOS( 1, 0) FLEN(4) FCAPTION(Poø.)
    TYPE(GET)      NAME(cZvireZem)    FPOS( 2, 0) FLEN( 8) FCAPTION(Zemì zv.)
    TYPE(GET)      NAME(nInvCis)      FPOS( 3, 0) FLEN(11) FCAPTION(Inv.èíslo zv.)
    TYPE(GET)      NAME(dNarozZvir)   FPOS( 4, 0) FLEN(13) FCAPTION(Dat.narození)  PUSH( ClickDate)
    TYPE(COMBOBOX) NAME(nPohlavi)     FPOS( 5, 0) FLEN(10) FCAPTION(Pohlavi)       VALUES(1:1-On,2:2-Ona)
    TYPE(COMBOBOX) NAME(nPorod)       FPOS( 6, 0) FLEN(14) FCAPTION(Porod zvíøete) VALUES(1:normální,2:tìžší,3:komplikovaný)
    TYPE(GET)      NAME(cPlemeno)     FPOS( 7, 0) FLEN( 7) FCAPTION(Plemeno)
    TYPE(GET)      NAME(cMatkaZem)    FPOS( 8, 0) FLEN( 8) FCAPTION(Zemì mat.)
    TYPE(GET)      NAME(nInvCisMat)   FPOS( 9, 0) FLEN(11) FCAPTION(Inv.èís.matky)
    TYPE(TEXT)     NAME(nDoklad )     FPOS(10, 0) FLEN(10) FCAPTION(Doklad)
  TYPE(END)
*