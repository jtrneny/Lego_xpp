TYPE(drgForm) DTYPE(10) TITLE(Dodací podmínky) SIZE(110,26) FILE(DociPODM);
              GUILOOK(Action:y,IconBar:n,Menu:n)
*              POST( POSTVALIDATE) CBSAVE(OnSave)

*TYPE(Action) CAPTION(~Opravy a emise)  EVENT( OPRAVY_EMISE) TIPTEXT(Opravy a emise)
*TYPE(Action) CAPTION(~Položky zakáz.) EVENT( btn_VYRZAKIT) TIPTEXT(Položky výrobní zakázky)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Kopie param.)  EVENT( ZAK_CopyPRM) TIPTEXT(Kopírování parametrù z jiných zakázek)
*TYPE(Action) CAPTION(Výskyt v ~zak.) EVENT( PARAM_inZAK) TIPTEXT(Výskyt parametru v zakázkách)

TYPE(Static) STYPE(13) SIZE(109, 2.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) CAPTION(Èís.dodávky)         CPOS(  1,0.2) CLEN( 15) FONT(2)
  TYPE(GET)  NAME(DociPODM->nCisDodavk)   FPOS(  1,1.2) FLEN( 14) FONT(5) NOREVISION()
  TYPE(TEXT) CAPTION(Oznáèení dodávky)    CPOS( 17,0.2) CLEN( 20) FONT(2)
  TYPE(GET)  NAME( DociPODM->cOznDodavk)  FPOS( 17,1.2) FLEN( 30) FONT(5)
  TYPE(TEXT) CAPTION(Název dodávky)       CPOS( 49,0.2) CLEN( 20) FONT(2)
  TYPE(GET)  NAME(DociPODM->cNazDodavk)   FPOS( 49,1.2) FLEN( 58) FONT(5)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(110,23) FPOS(0,3)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(109, 21.5) FPOS( 0.5 ,0.2) RESIZE(yn)
      TYPE(TEXT) CAPTION( Pøeprava) CPOS( 2, 0.4) CLEN( 10) FONT(7)
*      TYPE(Static) STYPE(17) SIZE(105, 0.1) FPOS(  1, 1) RESIZE(yx)
      TYPE(GET)  NAME( nCisFirPrp)          FPOS( 25, 1.5) FLEN( 8) FCAPTION(Èíslo firmy)      CPOS( 9, 1.5) PUSH()
      TYPE(Text) NAME( cNazFirPrp)          CPOS( 35, 1.5) CLEN(70) BGND(13)
      TYPE(GET)  NAME( nCisOsoPrp)          FPOS( 25, 2.5) FLEN( 8) FCAPTION(Zodpovìdná osoba) CPOS( 9, 2.5)
      TYPE(GET)  NAME( cJmeOsoPrp)          FPOS( 35, 2.5) FLEN(69)
*      TYPE(Text) NAME( cJmeOsoPrp)          CPOS( 35, 2.5) CLEN(70) BGND(13)

      TYPE(TEXT) CAPTION( Nakládka) CPOS( 2, 3.4) CLEN( 10) FONT(7)
*      TYPE(Static) STYPE(17) SIZE(105, 0.1) FPOS(  1, 4) RESIZE(yx)
      TYPE(GET)  NAME( nCisFirNak)          FPOS( 25, 4.5) FLEN( 8) FCAPTION(Èíslo firmy)      CPOS( 9, 4.5) PUSH()
      TYPE(Text) NAME( cNazFirNak)          CPOS( 35, 4.5) CLEN(70) BGND(13)
      TYPE(GET)  NAME( nCisOsoNak)          FPOS( 25, 5.5) FLEN( 8) FCAPTION(Zodpovìdná osoba) CPOS( 9, 5.5)
      TYPE(GET)  NAME( cJmeOsoNak)          FPOS( 35, 5.5) FLEN(69)
      TYPE(GET)  NAME( dDatNak)             FPOS( 45, 6.5) FLEN(12) FCAPTION(Datum) CPOS( 35, 6.5)
      TYPE(GET)  NAME( cCasNak)             FPOS( 65, 6.5) FLEN(12) FCAPTION(Èas)   CPOS( 60, 6.5)

      TYPE(TEXT) CAPTION( Vykládka) CPOS( 2, 7.4) CLEN( 10) FONT(7)
*      TYPE(Static) STYPE(17) SIZE(105, 0.1) FPOS(  1, 8) RESIZE(yx)
      TYPE(GET)  NAME( nCisFirVyk)          FPOS( 25, 8.5) FLEN( 8) FCAPTION(Èíslo firmy)      CPOS( 9, 8.5) PUSH()
      TYPE(Text) NAME( cNazFirVyk)          CPOS( 35, 8.5) CLEN(70) BGND(13)
      TYPE(GET)  NAME( nCisOsoVyk)          FPOS( 25, 9.5) FLEN( 8) FCAPTION(Zodpovìdná osoba) CPOS( 9, 9.5)
      TYPE(GET)  NAME( cJmeOsoVyk)          FPOS( 35, 9.5) FLEN(69)
      TYPE(GET)  NAME( dDatVyk)             FPOS( 45,10.5) FLEN(12) FCAPTION(Datum) CPOS( 35,10.5)
      TYPE(GET)  NAME( cCasVyk)             FPOS( 65,10.5) FLEN(12) FCAPTION(Èas)   CPOS( 60,10.5)

      TYPE(Static) STYPE(13) SIZE(108.6, 9.5) FPOS( 0.2, 12. 3) RESIZE(yx)
        TYPE(GET)  NAME( cZkrZpuDop)        FPOS( 20, 1) FLEN(15) FCAPTION(Zpùsob dopravy)     CPOS( 2, 1)
        TYPE(GET)  NAME( cTypDopPro)        FPOS( 20, 2) FLEN(15) FCAPTION(Typ doprav. prostøedku)  CPOS( 2, 2)
        TYPE(GET)  NAME( cNazDopPro)        FPOS( 50, 2) FLEN(55) FCAPTION(Název prostø.)      CPOS(37, 2)
        TYPE(GET)  NAME( cZkNDopPro)        FPOS( 50, 3) FLEN(15) FCAPTION(Zkrácený název)     CPOS(37, 3)
        TYPE(GET)  NAME( cPZZDopPro)        FPOS( 77, 3) FLEN(20) FCAPTION(SPZ)                CPOS(72, 3)
        TYPE(GET)  NAME( nCisOsoDop)        FPOS( 20, 4) FLEN( 8) FCAPTION(Dopravce - øidiè) CPOS( 2, 4)
        TYPE(GET)  NAME( cJmeOsoDop)        FPOS( 30, 4) FLEN(70)

        TYPE(TEXT) CAPTION( Adresa dodání)  CPOS( 2, 6) CLEN( 15)
        TYPE(TEXT) CAPTION( Cena dopravy)   CPOS( 2, 7) CLEN( 15)
        TYPE(TEXT) CAPTION( Váha )          CPOS( 2, 8) CLEN( 15)

      TYPE(END)
    TYPE(END)

  TYPE(END)

* DALŠÍ ÚDAJE
  TYPE(TabPage) TTYPE(4) CAPTION(Další údaje)  FPOS( 1,6) OFFSET(18,65)  PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(109, 21.5) FPOS( 0.5 ,0.2) RESIZE(yn)
      TYPE(GET)  NAME( cCisTrasyP)          FPOS( 20, 0.5) FLEN( 8) FCAPTION(Èíslo trasy PLÁN)      CPOS( 2, 0.5) PUSH()
      TYPE(GET)  NAME( cCisTrasyS)          FPOS( 20, 1.5) FLEN( 8) FCAPTION(Èíslo trasy SKUT.)     CPOS( 2, 1.5) PUSH()
      TYPE(TEXT) CAPTION( Další údaje) CPOS( 50, 8) CLEN( 25)
    TYPE(END)
  TYPE(END)

* POPIS
  TYPE(TabPage) TTYPE(4) CAPTION(Popis) FPOS( 1,6) OFFSET(35,48) PRE( tabSelect)
    TYPE(MLE) NAME(mPoznamka) FPOS(2,1) SIZE(105,19)

  TYPE(End)

TYPE(End)