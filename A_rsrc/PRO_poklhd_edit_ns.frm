TYPE(drgForm) DTYPE(10) TITLE(Registra�n� pokladna ...) SIZE(100,3) ;
                                                        FILE(poklitw) POST(postValidate) GUILOOK(Action:n,IconBar:n,Menu:n,Message:n)


 TYPE(Static) FPOS(1,0) SIZE(98,2.2) RESIZE(yn)

* NS
    TYPE(GET) NAME(poklitw->cNAZPOL1) FPOS(  3, 1.3) FLEN(10) FCAPTION(V�rSt�edisko) CPOS( 5, .3) CLEN(10)
    TYPE(GET) NAME(poklitw->cNAZPOL2) FPOS( 19, 1.3) FLEN(10) FCAPTION(V�robek)      CPOS(24, .3) CLEN( 8)
    TYPE(GET) NAME(poklitw->cNAZPOL3) FPOS( 35, 1.3) FLEN(10) FCAPTION(Zak�zka)      CPOS(40, .3) CLEN( 8)
    TYPE(GET) NAME(poklitw->cNAZPOL4) FPOS( 51, 1.3) FLEN(10) FCAPTION(V�rM�sto)     CPOS(56, .3) CLEN( 8)
    TYPE(GET) NAME(poklitw->cNAZPOL5) FPOS( 67, 1.3) FLEN(10) FCAPTION(Stroj)        CPOS(74, .3) CLEN( 8)
    TYPE(GET) NAME(poklitw->cNAZPOL6) FPOS( 83, 1.3) FLEN(10) FCAPTION(V�rOperace)   CPOS(85, .3) CLEN(10) 

    TYPE(STATIC) FPOS(0.4,7.4) SIZE(108.6,.1) STYPE(12)
    TYPE(End)

  TYPE(End)


