TYPE(drgForm) DTYPE(10) TITLE(Nastaven� individu�ln�ho tarifu ...) SIZE(103,10) FILE(OSOBY) ;
              GUILOOK(All:n) BORDER(4) PRE(preValidate) POST(postValidate)


  TYPE(Static) STYPE(13) SIZE(101,15) FPOS(1,0.2) RESIZE(yn)

    TYPE(TEXT) CAPTION(Pracovn� kalen��. .)       CPOS( 1.0, 0.25)   CLEN(15)
     TYPE(GET) NAME(OSOBY->cTypPraKal)        FPOS(16.0, 0.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACKA->cNazPraKal)        CPOS(37.5, 0.20)   CLEN(58) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Pracovn� doba. . . .)      CPOS( 1.0, 1.30)   CLEN(15)
     TYPE(GET) NAME(OSOBY->cDelkPrDob)         FPOS(16.0, 1.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACDO->cNazDelPrD)         CPOS(37.5, 1.20)   CLEN(58) BGND(13) PP(3)

    TYPE(EBrowse) FPOS( -1, 3) SIZE(102,6) FILE(MSTARIND)  RESIZE(yx) ;
                   CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1) GUILOOK(sizecols:n,headmove:n)

      TYPE(COMBOBOX) NAME(mstarind->ctyptarpou)   FLEN(18) CAPTION(typTarifu)  ;
            VALUES(NEPOUZIV:Tarify se nepou��vaj�,           ;
                   INDIVIDU:Individu�ln� tarif,              ;
                   HROMADNY:Hromadn� tarif        )
      TYPE(COMBOBOX) NAME(mstarind->ctyptarMzd)   FLEN(21)  CAPTION(typMzdy)   ;
            VALUES(CASOVA:jen hodinov� sazba,                ;
                   MESICNI:m�s��n� sazba se sv�tky,          ;
                   MESICNIb:m�s��n� bez sv�tk�,              ;
                   SMISENA:hodinov� i m�s��n�,               ; 
                   UKOLOVA:�kolov� mzda,                     ;
                   DOHODA:mzda dohodou,                      ;  
                   SMLUVNI:mzda stanovena smlouvou           )

      TYPE(GET)  NAME(mstarind->dplattarod) FLEN(12)  FCAPTION(platnost_Od)
      TYPE(GET)  NAME(mstarind->ctariftrid) FLEN( 5)  FCAPTION(tarT��da)
      TYPE(GET)  NAME(mstarind->ctarifstup) FLEN( 5)  FCAPTION(tarStupn)
      TYPE(GET)  NAME(mstarind->cdelkprdob) FLEN(18)  FCAPTION(pracDoba)
      TYPE(GET)  NAME(mstarind->ntarsazhod) FLEN( 7)  FCAPTION(hodSazba)   
      TYPE(GET)  NAME(mstarind->ntarsazmes) FLEN( 9)  FCAPTION(m�sSazba) 
    TYPE(END)

TYPE(END)
