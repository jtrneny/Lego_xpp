TYPE(drgForm) DTYPE(10) TITLE(Pracovní smlouvy a dohody) SIZE(100,21) ;
              GUILOOK(Action:n,IconBar:y) PRE(PreValidate) POST(postValidate)


  TYPE(Static) SIZE(98,7.6) FPOS(1,.2) RESIZE(y)
    TYPE(TEXT) CAPTION(OsÈísPrac)           CPOS( 1, 0.34) CLEN(8)
    TYPE(TEXT) CAPTION(PoøPV)               CPOS(10, 0.34) CLEN(7)
    TYPE(TEXT) CAPTION(Pøíjmení a jméno)    CPOS(20, 0.34) CLEN(40)
    TYPE(TEXT) CAPTION(Datum vzniku PV)     CPOS(62, 0.34) CLEN(10)
    TYPE(TEXT) CAPTION(Rodné èíslo)         CPOS(80, 0.34) CLEN(15) 

    TYPE(TEXT) NAME(prsmldoh->nosCisPrac)   CPOS( 1,1.4) CLEN( 8) BGND(13) PP(2) FONT(5) CTYPE(2)
    TYPE(TEXT) NAME(prsmldoh->nporPraVzt)   CPOS(10,1.0) CLEN( 7) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)
    TYPE(TEXT) NAME(prsmldoh->cjmenorozl)   CPOS(20,1.4) CLEN(40) BGND(13) FONT(5)
    TYPE(TEXT) NAME(prsmldoh->dDatVznPrV)   CPOS(62,1.4) CLEN(10) BGND(13) FONT(5)
    TYPE(TEXT) NAME(prsmldoh->crodCisPra)   CPOS(80,1.4) CLEN(15) BGND(13) PP(2) FONT(5) 

    TYPE(TEXT) CAPTION(Druh vztahu)         CPOS( 1, 2.44) CLEN(12)
    TYPE(TEXT) CAPTION(Zpùsob vzniku)       CPOS(20, 2.44) CLEN(12)
    TYPE(TEXT) CAPTION(Typ prac.vztahu)     CPOS(33, 2.44) CLEN(12)
    TYPE(TEXT) CAPTION(Typ zam.vztahu)      CPOS(62, 2.44) CLEN(10)
    TYPE(TEXT) CAPTION(Prac.zaøazení)       CPOS(80, 2.44) CLEN(15) 

    TYPE(TEXT) NAME(prsmldoh->cDruPraVzt)   CPOS( 1,3.5) CLEN(12) BGND(13) 
    TYPE(TEXT) NAME(prsmldoh->cVznPraVzt)   CPOS(20,3.5) CLEN(12) BGND(13) 
    TYPE(TEXT) NAME(prsmldoh->nTypPraVzt)   CPOS(33,3.5) CLEN( 7) BGND(13)
    TYPE(TEXT) NAME(prsmldoh->nTypZamVzt)   CPOS(62,3.5) CLEN(10) BGND(13)
    TYPE(TEXT) NAME(prsmldoh->cPracZar)     CPOS(80,3.5) CLEN(15) BGND(13)


    TYPE(TEXT) CAPTION(Èíslo smlouvy-dohody)     CPOS( 1, 5.6) CLEN(19) FONT(5) 
    TYPE(TEXT) NAME(prsmldoh->cCisloSmDo)        CPOS( 1, 6.6) CLEN(19) BGND(13) PP(2) FONT(5) 


  TYPE(END)

  TYPE(Static) STYPE(13) SIZE(98,12) FPOS(1,8.5) RESIZE(y)

    TYPE(EBrowse) FPOS(0,0.5) SIZE(97,11.8) FILE(prsmdozm)  RESIZE(yx)    ;
                    CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(2) GUILOOK(ins:yn,sizecols:n,headmove:n)
      TYPE(TEXT) NAME(prsmdozm->nPorZmeny)      CLEN( 5) FCAPTION(PoøZm)
      TYPE(GET)  NAME(prsmdozm->cTypZmSmDo)     FLEN(10)
      TYPE(GET)  NAME(prsmdozm->cPopisZmen)     FLEN(30)
      TYPE(GET)  NAME(prsmdozm->cCisZmSmDo)     FLEN(10) FCAPTION(Èíslo zmìny)
      TYPE(GET)  NAME(prsmdozm->dDatZmeny)      FLEN(10)
      TYPE(GET)  NAME(prsmdozm->dDatZmenyP)     FLEN(10) FCAPTION(Dat zm.pøed)
      TYPE(GET)  NAME(prsmdozm->dDatPodpis)     FLEN(10) FCAPTION(Dat podpisu)

    TYPE(END)

  TYPE(END)
TYPE(END)