TYPE(drgForm) DTYPE(10) TITLE(Zpravovat podklay pro uzávìrku roku ...) SIZE(75,15) ;
                                                                       GUILOOK(IconBar:n,Menu:n,Action:n)


  TYPE(TEXT)     CAPTION(Bìžná úèetní uzávìrka bez (ROPO))                  CPOS(1,4) CLEN(50)
  TYPE(CHECKBOX) NAME(M->ROPO )                                             FPOS(51,4) FLEN( 4) VALUES(F:NE,T:ANO)

  TYPE(TEXT)     CAPTION(Vnitropodnikové zaúètování bez 8 a 9 ( jen 5 a 6)) CPOS(1,5) CLEN(50)
  TYPE(CHECKBOX) NAME(M->BEZ89)                                             FPOS(51,5) FLEN( 4)  VALUES(F:NE,T:ANO)
*
  TYPE(STATIC) FPOS(0.1,6.3) SIZE(75,.3) STYPE(12) CTYPE(2)
  TYPE(End)
TYPE(End)

