TYPE(drgForm) DTYPE(10) TITLE(Oprava externího pohybu ...) SIZE(100,14) FILE (pvpTerm)   ;
                                                                              GUILOOK(Action:y,Message:y,IconBar:y:MyIconBar,Menu:n) ;
                                                                              BORDER(4)  ; 
                                                                              POST(postValidate)

  TYPE(Text)     NAME(M->c_nazTypPoh)       CPOS(24, -.5) CLEN(30) SIZE(120, 50) GROUPS(SETFONT,11.Segoe Print Bold) 
  TYPE(ComboBox) NAME(pvpTerm->ctypPohybu)  FPOS(60, .5) FLEN(38) VALUES(a,a,a,a,a,a,a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2)


* info.cenZboz a karta.pvpTerm
  TYPE(Static) STYPE(1) SIZE(99,15) FPOS(.4,1.9) CTYPE(2) RESIZE(yn)

    TYPE(TEXT) CAPTION(èísSkladu)    CPOS( 5, -.2) CLEN( 8) 
    TYPE(TEXT) CAPTION(sklPoložka)   CPOS(19, -.2) CLEN( 9)  
    TYPE(TEXT) CAPTION(název zboží)  CPOS(41, -.2) CLEN(10) 

    TYPE(STATIC) STYPE(12) FPOS( .3,.3) SIZE(98, 12.0) CTYPE(2) 

      TYPE(Text) NAME(cenZboz->ccisSklad)    CPOS(  4, .7) CLEN(12) BGND(13) GROUPS(SETFONT,9.Arial Black) 
      TYPE(Text) NAME(cenZboz->csklPol)      CPOS( 18, .7) CLEN(20) BGND(13) GROUPS(SETFONT,9.Arial Black)
*      TYPE(Text) NAME(cenZboz->cnazZbo)      CPOS( 46, .7) CLEN(50) BGND(13) GROUPS(SETFONT,9.Segoe Print Bold) 
      TYPE(Text) NAME(cenZboz->cnazZbo)      CPOS( 40, .3) CLEN(50) SIZE(460, 50) GROUPS(SETFONT,11.Segoe Print Bold) 

      TYPE(Text) CAPTION(množstvíDokl)       CPOS(17,2.4) CLEN(11)
      TYPE(Text) CAPTION(množstvíPlnìní)     CPOS(33,2.4) CLEN(12)   

      TYPE(STATIC) FPOS(1,2.9) SIZE(96,6.2) STYPE(9) CTYPE(3)  

        TYPE(Text) CAPTION(Množství v )       CPOS( 1,0.5) CLEN( 9) 
        TYPE(Text) NAME(pvpTerm->cmjDOKL1)    CPOS(10,0.5) CLEN( 4) CTYPE(1) FONT(5)

        TYPE(Get) NAME(pvpTerm->nmnozDOKL1)   FPOS(15,0.5) FLEN(13) PP(2)
        TYPE(Get) NAME(pvpTerm->nmnoz_PLN)    FPOS(31,0.5) FLEN(13) PP(2)

* ceny
        TYPE(Text) CAPTION(Ceny v )           CPOS( 1,2.5) CLEN( 7) 
*      TYPE(Text) NAME(pvpTerm->czkratmeny) CPOS(10,2.5) CLEN( 4) CTYPE(1) FONT(5)

        TYPE(Text) CAPTION(cenaNaDokladu)     CPOS(15,1.5) CLEN(13)
        TYPE(Get)  NAME(pvpTerm->ncenaDOKL1)  FPOS(15,2.5) FLEN(13)   

        TYPE(Text) CAPTION(cenaProdejní)      CPOS(31,1.5) CLEN(11)
        TYPE(Get)  NAME(pvpTerm->ncenaPZbo)   FPOS(31,2.5) FLEN(13)   
 
        TYPE(Text) CAPTION(cenaSMaží)         CPOS(47,1.5) CLEN(11)
        TYPE(Get)  NAME(pvpTerm->ncenaMZbo)   FPOS(47,2.5) FLEN(13)   

        TYPE(Text) CAPTION(cenaSkladová)      CPOS(63,1.5) CLEN(11)
        TYPE(Get)  NAME(pvpTerm->ncenaSZbo)   FPOS(63,2.5) FLEN(13)

* NS
        TYPE(GET) NAME(pvpTerm->cStredisko) FPOS(  3, 4.7) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3, 3.7) CLEN(10)
        TYPE(GET) NAME(pvpTerm->cVyrobek)   FPOS( 19, 4.7) FLEN(10) FCAPTION(Výrobek)      CPOS(19, 3.7) CLEN( 8)
        TYPE(GET) NAME(pvpTerm->cZakazka)   FPOS( 35, 4.7) FLEN(10) FCAPTION(Zakázka)      CPOS(35, 3.7) CLEN( 8)
        TYPE(GET) NAME(pvpTerm->cVyrMisto)  FPOS( 51, 4.7) FLEN(10) FCAPTION(VýrMísto)     CPOS(51, 3.7) CLEN( 8)
        TYPE(GET) NAME(pvpTerm->cStroj)     FPOS( 67, 4.7) FLEN(10) FCAPTION(Stroj)        CPOS(67, 3.7) CLEN( 8)
        TYPE(GET) NAME(pvpTerm->cOperace)   FPOS( 83, 4.7) FLEN(10) FCAPTION(VýrOperace)   CPOS(83, 3.7) CLEN(10) 

        TYPE(STATIC) FPOS(0.4,4) SIZE(98.6,.2) STYPE(12)
        TYPE(End)

      TYPE(End)

* èárové kódy položky
    TYPE(Text) CAPTION(èárovýKód[N])        CPOS( 2,10) CLEN(11)
    TYPE(Text) NAME(pvpTerm->ncarkKod)      CPOS(15,10) CLEN(13) BGND(13) 

    TYPE(Text) CAPTION(èárovýKód[C])        CPOS(29,10) CLEN(11)
    TYPE(Text) NAME(pvpTerm->ccarkKod)      CPOS(31,10) CLEN(65) BGND(13) 

  TYPE(End)

TYPE(End)

