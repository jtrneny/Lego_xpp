TYPE(drgForm) DTYPE(10) TITLE(Registraèní pokladna ...) SIZE(86,4) ;
                                                        FILE(poklitW) POST(postValidate) GUILOOK(Action:n,IconBar:n,Menu:n,Message:n)


TYPE(Static) FPOS(0,0) SIZE(86,4) RESIZE(yn)

* PC
    TYPE(TEXT) CAPTION(CENA)         CPOS( 5,-.2) CLEN( 5)                                         GROUPS(FAK) FONT(5) 
    TYPE(TEXT) CAPTION(prodejníCena) CPOS(17,-.2) CLEN( 11)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(sleva)        CPOS(36,-.2) CLEN( 5)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(% slevy)      CPOS(54,-.2) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(se slevou)    CPOS(70,-.2) CLEN( 8)                                         GROUPS(FAK) 
  
    TYPE(Text) CAPTION(za MJ   )     CPOS( 5,1)                                                  GROUPS(FAK,SETFONT,8.Arial CE)   
    TYPE(Text) CAPTION(za POL  )     CPOS( 5,2)                                                  GROUPS(FAK,SETFONT,8.Arial CE)

    TYPE(STATIC) STYPE(12) FPOS( 1,.3) SIZE(84, 3.4) CTYPE(2)                                      GROUPS(FAK)
* 1
      TYPE(Get)   NAME(poklitW->ncejPrZDZ)  FPOS(14,0.5) FLEN(14)                                GROUPS(FAK)
      TYPE(Get)   NAME(poklitW->NHODNSLEV)  FPOS(31,0.5) FLEN(13)                                GROUPS(FAK) 
      TYPE(Get)   NAME(poklitW->NPROCSLEV)  FPOS(48,0.5) FLEN(13)                                GROUPS(FAK)  PICTURE(@N 9999.99) 
      TYPE(Text)  NAME(poklitW->ncejprkdz)  CPOS(65,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
* 2
*      TYPE(Text)  NAME(poklitW->ncecprkdz)  CPOS(14,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(poklitW->ncelkslev)  CPOS(31,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) 
      TYPE(Text)  NAME(poklitW->ncecprkdz)  CPOS(65,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
    TYPE(End)

TYPE(End)


