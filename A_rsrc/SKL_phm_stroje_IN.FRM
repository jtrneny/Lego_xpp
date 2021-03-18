TYPE(drgForm) SIZE(100,15.5) DTYPE(10) TITLE(Dopravní prostøedky - pro sledování PHM ...) ;
              GUILOOK(Message:Y,Action:N,IconBar:Y:MyIconBar,Menu:y:myMenuBar)            ;
              FILE(STROJEw)                                                               ;
              PRE(preValidate) POST(postValidate) 


TYPE(Static) FPOS(1,.5) SIZE(98,16) STYPE(13) RESIZE(y) 
  TYPE(Text) CAPTION(STROJE)                                  CPOS(60,4.2) CLEN(10) FONT(4) SIZE(30,1.0) CTYPE(3)
  TYPE(Text) CAPTION(Dopravní prostøedky - pro sledování PHM) CPOS(60,5.5) CLEN(20) FONT(5) SIZE(35,1.0) CTYPE(3)

  TYPE(GET)  NAME(ntypStroje)           FPOS(15, .5) FLEN(10) FCAPTION(Typ stroje) CPOS(1, .5) PP(2) NOREVISION() 
  TYPE(Text) NAME(c_stroje->cnazevTypu) CPOS(27, .5) CLEN(31) Font(5) PP(3) BGND(9)

  TYPE(GET)  NAME(cStroj)               FPOS(15,1.6) FLEN(10) FCAPTION(Èíslo stroje) CPOS( 1, 1.6) PP(2) NOREVISION() 
  TYPE(GET)  NAME(cnazStroj)            FPOS(27,1.6) FLEN(30) 
  TYPE(GET)  NAME(cspzStroj)            FPOS(75,1.6) FLEN(15) FCAPTION(SPZ stroje)   CPOS(63, 1.6) PP(2) 

  TYPE(GET)  NAME(ninvCis)              FPOS(15,2.7) FLEN(10) FCAPTION(invÈíslo_maj) CPOS( 1, 2.7) PP(2) 
  TYPE(TEXT) NAME(M->nazevMaj)          CPOS(27,2.7) CLEN(31) BGND(9)
 
  TYPE(GET)  NAME(ncisFirmy)            FPOS(15,3.8) FLEN(10) FCAPTION(Èíslo_firmy)  CPOS( 1, 3.8) PP(2) PUSH(fir_firmy_sel)
  TYPE(TEXT) NAME(cnazFirmy)            CPOS(27,3.8) CLEN(31) BGND(9)
*
  TYPE(GET)  NAME(nnorma_100)            FPOS(15,5.2) FLEN(10) FCAPTION(norma l/100km) CPOS( 1, 5.2) PP(2) 
  TYPE(GET)  NAME(nnorma_hod)            FPOS(37,5.2) FLEN(10) FCAPTION(norma l/hod)   CPOS(27, 5.2) CLEN(10) PP(2) 



  TYPE(Static) STYPE(12) SIZE(96,4.5) FPOS(1,7) RESIZE(y) GROUPS(OLE)
    TYPE(TEXT) CAPTION(Sledovat spotøebu oleje) CPOS( 1, .1) CLEN(18) PP(3)
    TYPE(TEXT) CAPTION(sklad)                   CPOS(27, .1) CLEN( 5) PP(3)
    TYPE(TEXT) CAPTION(sklPoložka)              CPOS(40, .1) CLEN( 8) PP(3)
    TYPE(TEXT) CAPTION(název sklPoložky)        CPOS(60, .1) CLEN(13) PP(3)   

    TYPE(TEXT) CAPTION(motorový    ->) CPOS( 1, 1.2) CLEN(25)
    TYPE(Get)  NAME(cskladMOo)         FPOS(27, 1.2) FLEN(10) 
    TYPE(Get)  NAME(csklPolMOo)        FPOS(40, 1.2) FLEN(17) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(cnazZboMOo)        FPOS(60, 1.2) FLEN(30) 

    TYPE(TEXT) CAPTION(pøevodový   ->) CPOS( 1, 2.2) CLEN(25)
    TYPE(Get)  NAME(cskladPRo)         FPOS(27, 2.2) FLEN(10)
    TYPE(Get)  NAME(csklPolPRo)        FPOS(40, 2.2) FLEN(17) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(cnazZboPRo)        FPOS(60, 2.2) FLEN(30) 

    TYPE(TEXT) CAPTION(hydraulický ->) CPOS( 1, 3.2) CLEN(25)
    TYPE(Get)  NAME(cskladHYo)         FPOS(27, 3.2) FLEN(10) 
    TYPE(Get)  NAME(csklPolHYo)        FPOS(40, 3.2) FLEN(17) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(cnazZboHYo)        FPOS(60, 3.2) FLEN(30) 

    TYPE(Static) STYPE(8) SIZE(96, .12) FPOS(.2,.6)
    TYPE(End)
  TYPE(End)


* ns-stroje
    TYPE(Static) STYPE(8) SIZE(117,2.5) FPOS(.5,12) RESIZE(y)
      TYPE(Text) CAPTION(støStroje)       CPOS( 3, .1) CLEN( 9) PP(3) BGND( 1) FONT(5) 
      TYPE(GET) NAME(cNAZPOL1)    FPOS( 3,1.2) FLEN(13) PP(2) BGND(13) 

      TYPE(Text) FCAPTION(Výrobek)        CPOS(19, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(GET) NAME(cNAZPOL2)            FPOS(19,1.2) FLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Zakázka)        CPOS(35, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(GET) NAME(cNAZPOL3)            FPOS(35,1.2) FLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrMísto)       CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
      TYPE(GET) NAME(cNAZPOL4)            FPOS(51,1.2) FLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Stroj)          CPOS(67, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
      TYPE(GET) NAME(cNAZPOL5)            FPOS(67,1.2) FLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrOperace)     CPOS(83, .1) CLEN(11) PP(3) BGND( 1) FONT(5)
      TYPE(GET) NAME(cNAZPOL6)            FPOS(83,1.2) FLEN(13)       BGND(13) PP(2)

      TYPE(Static) STYPE(8) SIZE(96,.12) FPOS(1,.6)
      TYPE(End)
    TYPE(End)

TYPE(End)




