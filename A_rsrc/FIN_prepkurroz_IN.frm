TYPE(drgForm) DTYPE(10) TITLE(P�epo�et kurzovn�ch rozd�l� u neuhrazen�ch faktur ...) SIZE(58,7)          ;
                                                                                     POST(postValidate)  ;
                                                                                     BORDER(4)           ;
                                                                                     GUILOOK(IconBar:n,Menu:n)


TYPE(Action) CAPTION(~P�epo�et)     EVENT( prepocet)          TIPTEXT(P�epo�et neuhrazen�ch faktur)
TYPE(Action) CAPTION(~Storno)       EVENT(140000002)          TIPTEXT(N�vrat) 

             
*
** INPUT definition
  TYPE(Static) STYPE(13) SIZE(57, 5.5) FPOS(0.5,0.5) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Rok)             CPOS( 1, .8) CLEN(12) FONT(5)
    TYPE(GET)  NAME(M->rok)              FPOS(14,.8) FLEN( 15) 

    TYPE(TEXT) CAPTION(M�na)            CPOS( 1,2) CLEN(12) FONT(5)    
    TYPE(GET)  NAME(M->mena)             FPOS(14,2) FLEN( 15) PUSH(c_meny)
 
    TYPE(TEXT) CAPTION(Kurz)            CPOS( 1,3.2) CLEN(12) FONT(5)    
    TYPE(GET)  NAME(M->kurz)             FPOS(14,3.2) FLEN( 15) PICTURE(@N 9999.9999)
  TYPE(End)






