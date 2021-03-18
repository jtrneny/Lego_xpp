TYPE(drgForm) DTYPE(10) TITLE(Opis úkolových lístkù ) ;
              SIZE( 75, 10) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(TabPage) TTYPE(3) CAPTION(Parametry zpracování) FPOS(0.2, 0.1) SIZE( 74.6, 8) RESIZE(yx) OFFSET(1, 72) PRE( tabSelect)
    TYPE(Text) CAPTION( Datum vyhotovení lístkù)            CPOS( 2, 1)   CLEN( 18)
    TYPE(GET)  NAME(M->dDatumOD)   FPOS(25, 1) FLEN( 12) FCAPTION( od:)      CPOS( 20, 1) PUSH( CLICKDATE)
    TYPE(GET)  NAME(M->dDatumDO)   FPOS(46, 1) FLEN( 12) FCAPTION( do:)      CPOS( 41, 1) PUSH( CLICKDATE)
    TYPE(Text) CAPTION( Vybraná støediska)                  CPOS( 2, 2)   CLEN( 18)
    TYPE(GET)  NAME(M->cListSTR)   FPOS(25, 2) FLEN( 40)
*    TYPE(PushButton) POS( 0, 0) SIZE( 0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(3) CAPTION(Popis ) FPOS(0, 0.1) SIZE( 74.6, 8) RESIZE(yx) OFFSET( 28, 46) PRE( tabSelect)
    TYPE(Text) NAME( M->cPopisRep)  FPOS( 2, 1)   CLEN( 60)
    TYPE(PushButton) POS( 0, 0) SIZE( 0,0)
  TYPE(End)

  TYPE(PushButton) POS(53, 8.5) SIZE(17,1.2) CAPTION(~Start zpracování )  EVENT(Start_ZPRAC)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)

TYPE(END)