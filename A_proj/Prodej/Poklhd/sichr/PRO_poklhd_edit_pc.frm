TYPE(drgForm) DTYPE(10) TITLE(Registraèní pokladna ...) SIZE(88,3) ;
                                                        FILE(poklitW) POST(postValidate) GUILOOK(Action:n,IconBar:n,Menu:n,Message:n)


TYPE(Static) FPOS(1,0) SIZE(86,2.2) RESIZE(yn) CTYPE(2)

* PC
   TYPE(Text) CAPTION(Ceny v)              CPOS(  1, 1 ) CLEN( 6)
   TYPE(Text) NAME(poklhdW->czkratMeny)    CPOS(  8, 1 ) CLEN( 4) FONT(5)

   TYPE(Text) CAPTION(cenaZákladní)        CPOS( 17, 0 ) CLEN(10)
   TYPE(Get)  NAME(poklitW->ncejPrZBZ      FPOS( 15, 1 ) FLEN(13) PICTURE(@N 9999999.99)
 
   TYPE(Text) CAPTION(slevaZákladní)       CPOS( 35, 0 ) CLEN(11)
   TYPE(Get)  NAME(poklitW->nhodnSlev)     FPOS( 33, 1 ) FLEN(13) PICTURE(@N 99999999.9999)

   TYPE(Text) CAPTION(procentoSlev)        CPOS( 52, 0 ) CLEN(11)
   TYPE(Get)  NAME(poklitW->nprocSlev)     FPOS( 52, 1 ) FLEN( 9) PICTURE(@N 999.9999)

   TYPE(Text) CAPTION(prodejníCena s DPH)  CPOS( 66, 0 ) CLEN(15)
   TYPE(Text) NAME(poklitW->ncejPrKDZ)     CPOS( 66, 1 ) CLEN(14) BGND(14) FONT(5) 

   TYPE(STATIC) FPOS(0.4,7.4) SIZE(108.6,.1) STYPE(12)
   TYPE(End)

TYPE(End)


   TYPE(TEXT) CAPTION(% danì)       CPOS( 3,4.3) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(rv_dph)       CPOS(13,4.3) CLEN( 6)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(CENA)         CPOS(22,4.3) CLEN( 5)                                         GROUPS(FAK) FONT(5) 
    TYPE(TEXT) CAPTION(základní)     CPOS(33,4.2) CLEN( 6)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(sleva)        CPOS(50,4.2) CLEN( 5)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(% slevy)      CPOS(65,4.2) CLEN( 7)                                         GROUPS(FAK)
    TYPE(TEXT) CAPTION(se slevou)    CPOS(81,4.2) CLEN( 8)                                         GROUPS(FAK) 
    TYPE(TEXT) CAPTION(celkem)       CPOS(97,4.2) CLEN( 6)                                         GROUPS(FAK)
  
    TYPE(Text) CAPTION(za MJ   )     CPOS(22,5.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)   
    TYPE(Text) CAPTION(za POL  )     CPOS(22,6.3)                                                  GROUPS(FAK,SETFONT,8.Arial CE)

    TYPE(TEXT) NAME(FAKVYSITw->ncenzakcel) CPOS(29,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKVYSITw->nsazdan)    CPOS(77,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)
    TYPE(TEXT) NAME(FAKVYSITw->ncenzakced) CPOS(93,7.3) CTYPE(2) CLEN(14)                          GROUPS(FAK,SETFONT,8.Cambria,GRA_CLR_RED)  PICTURE(@N 9999999999.99)

    TYPE(STATIC) STYPE(12) FPOS( 1,4.8) SIZE(107, 3) CTYPE(2)                                      GROUPS(FAK)
* 1
      TYPE(Get)   NAME(FAKVYSITw->NPROCDPH)      FPOS( 1,0.5) FLEN( 7)                             GROUPS(FAK) PP(2)
      TYPE(Get)   NAME(FAKVYSITw->NRADVYKDPH)    FPOS(12,0.5) FLEN( 6)                             GROUPS(FAK) PUSH(fin_vykdph_rv_sel) 

      TYPE(Get)   NAME(FAKVYSITw->NCEJPRZBZ)  FPOS(28,0.5) FLEN(13)   PP(2)                        GROUPS(FAK) PUSH(FIN_CMDPH)
      TYPE(Get)   NAME(FAKVYSITw->NHODNSLEV)  FPOS(44,0.5) FLEN(13)                                GROUPS(FAK) 
      TYPE(Get)   NAME(FAKVYSITw->NPROCSLEV)  FPOS(60,0.5) FLEN(13)                                GROUPS(FAK)
      TYPE(Text)  NAME(FAKVYSITw->ncejprkbz)  CPOS(76,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
      TYPE(Text)  NAME(FAKVYSITw->ncejprkdz)  CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)            GROUPS(FAK)
* 2
      TYPE(Text)  NAME(FAKVYSITw->ncecprzbz)  CPOS(28,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKVYSITw->ncelkslev)  CPOS(44,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) 
      TYPE(Text)  NAME(FAKVYSITw->ncecprkbz)  CPOS(76,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
      TYPE(Text)  NAME(FAKVYSITw->ncecprkdz)  CPOS(92,1.5) CLEN(14)  BGND(13) CTYPE(2)             GROUPS(FAK) PICTURE(@N 9999999999.99)
    TYPE(End)



