TYPE(drgForm) DTYPE(10) TITLE(Nastavení individuálního tarifu ...) SIZE(103,10) FILE(OSOBY) ;
              GUILOOK(All:n) BORDER(4) PRE(preValidate) POST(postValidate)


  TYPE(Static) STYPE(13) SIZE(101,15) FPOS(1,0.2) RESIZE(yn)

    TYPE(TEXT) CAPTION(Pracovní kalenáø. .)       CPOS( 1.0, 0.25)   CLEN(15)
     TYPE(GET) NAME(OSOBY->cTypPraKal)        FPOS(16.0, 0.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACKA->cNazPraKal)        CPOS(37.5, 0.20)   CLEN(58) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Pracovní doba. . . .)      CPOS( 1.0, 1.30)   CLEN(15)
     TYPE(GET) NAME(OSOBY->cDelkPrDob)         FPOS(16.0, 1.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACDO->cNazDelPrD)         CPOS(37.5, 1.20)   CLEN(58) BGND(13) PP(3)

    TYPE(EBrowse) FPOS( -1, 3) SIZE(102,6) FILE(MSTARIND)  RESIZE(yx) ;
                   CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1) GUILOOK(sizecols:n,headmove:n)

      TYPE(COMBOBOX) NAME(mstarind->ctyptarpou)   FLEN(18) CAPTION(typTarifu)  ;
            VALUES(NEPOUZIV:Tarify se nepoužívají,           ;
                   INDIVIDU:Individuální tarif,              ;
                   HROMADNY:Hromadný tarif        )
      TYPE(COMBOBOX) NAME(mstarind->ctyptarMzd)   FLEN(21)  CAPTION(typMzdy)   ;
            VALUES(CASOVA:jen hodinová sazba,                ;
                   MESICNI:mìsíèní sazba se svátky,          ;
                   MESICNIb:mìsíèní bez svátkù,              ;
                   SMISENA:hodinová i mìsíèní,               ; 
                   UKOLOVA:úkolová mzda,                     ;
                   DOHODA:mzda dohodou,                      ;  
                   SMLUVNI:mzda stanovena smlouvou           )

      TYPE(GET)  NAME(mstarind->dplattarod) FLEN(12)  FCAPTION(platnost_Od)
      TYPE(GET)  NAME(mstarind->ctariftrid) FLEN( 5)  FCAPTION(tarTøída)
      TYPE(GET)  NAME(mstarind->ctarifstup) FLEN( 5)  FCAPTION(tarStupn)
      TYPE(GET)  NAME(mstarind->cdelkprdob) FLEN(18)  FCAPTION(pracDoba)
      TYPE(GET)  NAME(mstarind->ntarsazhod) FLEN( 7)  FCAPTION(hodSazba)   
      TYPE(GET)  NAME(mstarind->ntarsazmes) FLEN( 9)  FCAPTION(mìsSazba) 
    TYPE(END)

TYPE(END)
