TYPE(drgForm) SIZE(78,15) DTYPE(10) TITLE(Zaøazení DIMu ...) ;
              GUILOOK(Message:Y,Action:N,IconBar:Y:MyIconBar,Menu:y:myMenuBar) ;
              FILE(MSDIMw) ;
              POST(postValidate)


TYPE(Static) FPOS(1,.2) SIZE(76,14.5) STYPE(13) RESIZE(y) CTYPE(2)
  TYPE(GET)  NAME(CKLICSKMIS)            FPOS(15, .5) FLEN(13) FCAPTION(Skupinové místo) CPOS(1, .5)
  TYPE(Text) NAME(C_SKUMIS->cNazSkMis)   CPOS(30, .5) CLEN(38) BGND(13) GROUPS(clrGREY)
  TYPE(GET)  NAME(CKLICODMIS)            FPOS(15,1.5) FLEN(13) FCAPTION(Odpovìd.  místo) CPOS(1,1.5)
  TYPE(Text) NAME(C_ODPMIS->cNazOdpMis)  CPOS(30,1.5) CLEN(38) BGND(13) GROUPS(clrGREY)
  TYPE(GET)  NAME(CVYRCISDIM)            FPOS(15,2.6) FLEN(52) FCAPTION(Výrobní èíslo)  CPOS( 1,2.6)

  TYPE(Static) STYPE(12) SIZE(74,3) FPOS(1,4) RESIZE(y)
    TYPE(GET)        NAME(NINVCISDIM) FPOS(14, .5) FLEN(10) FCAPTION(Inventární èíslo) CPOS( 1, .5)
    TYPE(GET)        NAME(CNAZEVDIM)  FPOS(36, .5) FLEN(30) FCAPTION(Název)            CPOS(27, .5)
    TYPE(GET)        NAME(DDATZARDIM) FPOS(36,1.5) FLEN(11) FCAPTION(Zaøazeno)         CPOS(27,1.5) PUSH(CLICKDATE)
    TYPE(SpinButton) NAME(NZIVOTDIM)  FPOS(61,1.5) FLEN( 5) FCAPTION(Životnost)        CPOS(51,1.5) LIMITS(1,999)
    TYPE(Text)       CAPTION(let)     CPOS(68,1.5) FONT(2)
  TYPE(End)

  TYPE(GET)  NAME(NTYPDIM)               FPOS(15, 7.2) FLEN(17) FCAPTION(Typ DIMu)     CPOS( 1, 7.2)
  TYPE(Text) NAME(C_TypDim->cNazTypDim)  CPOS(34, 7.2) CLEN(35) BGND(13) GROUPS(clrGREY)
  TYPE(GET)  NAME(CTYPSKP)               FPOS(15, 8.2) FLEN(17) FCAPTION(Typ SKP)      CPOS( 1, 8.2)
  TYPE(Text) NAME(C_TypSkp->cNazTypSkp)  CPOS(34, 8.2) CLEN(35) BGND(13) GROUPS(clrGREY)
  TYPE(GET)  NAME(NPOCKUSDIM)            FPOS(15, 9.4) FLEN(11) FCAPTION(Množství)     CPOS( 1, 9.4)
  TYPE(GET)  NAME(CZKRATJEDN)            FPOS(27, 9.4) FLEN( 5)
  TYPE(GET)  NAME(NCENJEDDIM)            FPOS(15,10.4) FLEN(11) FCAPTION(Cena za MJ)   CPOS( 1,10.4)
  TYPE(GET)  NAME(NCENCELDIM)            FPOS(15,11.4) FLEN(11) FCAPTION(Cena celkem)  CPOS( 1,11.4)
  TYPE(GET)  NAME(DDATREVDIM)            FPOS(15,12.6) FLEN(11) FCAPTION(Datum revize) CPOS( 1,12.6) PUSH(CLICKDATE)
TYPE(End)