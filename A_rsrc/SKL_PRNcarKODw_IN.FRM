TYPE(drgForm) DTYPE(10) TITLE( Tisk èárových kódù ke skladovým kartám ...) SIZE( 110, 20) ;
                        PRINTFILES(prncarkodw:ccissklad=ccissklad+csklpol=csklpol, ;
                                   cenzboz:ccissklad=ccissklad+csklpol=csklpol)    ;
                        GUILOOK( Menu:n,Action:n,iconBar:y:drgStdBrowseIconBar)

 
  TYPE(EBrowse) FILE(PRNcarKODw)  INDEXORD(1)                                       ;
                FPOS(0,3) SIZE( 110, 14) CURSORMODE(3) SCROLL(ny) PP(7)POPUPMENU(y) ;
                GUILOOK(ins:n,del:n,sizecols:n,headmove:n) 

    TYPE(GET)  NAME( PRNcarKODw->npocVytisk)  FPOS( 1,0) FLEN(  4)  CAPTION(poèTiskù   )
    TYPE(TEXT) NAME( PRNcarKODw->ccisSklad)   FPOS( 2,0) CLEN(  8)  CAPTION(sklad      )
    TYPE(TEXT) NAME( PRNcarKODw->csklPol)     FPOS( 3,0) CLEN( 15)  CAPTION(sklPoložka )
    TYPE(TEXT) NAME( PRNcarKODw->cnazZbo)     FPOS( 4,0) CLEN( 25)  CAPTION(název Zboží)
    TYPE(TEXT) NAME( PRNcarKODw->ccarKod)     FPOS( 5,0) FLEN( 51)  CAPTION(èárovýKód  )
  TYPE(END)  

  TYPE(Static) FPOS(1,-.1) SIZE(108,2.5) RESIZE(y) CTYPE(2)
    TYPE(TEXT)     CAPTION(Název tiskového výstupu) CPOS( 7, .7) CLEN(20)
    TYPE(ComboBox) NAME(M->cidForms)                FPOS(27, .7) FLEN(70) VALUES(a,a,a,a)  RESIZE(nx) ;
                                                                 ITEMMARKED(comboItemMarked)          ;
                                                                 ITEMSELECTED(comboItemSelected) PP(2)

    TYPE(TEXT)     CAPTION(Název tiskárny)          CPOS( 7,1.7) CLEN(20)
    TYPE(ComboBox) NAME(M->cPrinter)                FPOS(27,1.7) FLEN(70) VALUES(a,a,a,a)  RESIZE(nx) ;
                                                                 ITEMMARKED(comboItemMarked)          ;
                                                                 ITEMSELECTED(comboItemSelected) PP(2)
  TYPE(END)

  TYPE(Static) STYPE(12) SIZE(110,2.7) FPOS(.5,17) CTYPE(2) RESIZE(y) GROUPS(OK)
    TYPE(PushButton) POS(  .2,1.5) SIZE(33,2.3) CAPTION(~Pøímý tisk èárových kódù)  EVENT(pushButtonClick) ICON1(115) ICON2(0) ATYPE(3)
  TYPE(END)
TYPE(END)