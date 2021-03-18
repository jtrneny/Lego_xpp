TYPE(drgForm) DTYPE(10) TITLE(Parametr zakázky) SIZE(70,15) FILE( ParZAKw);
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n) ;
              POST(postValidate) CBSAVE( OnSave)

  TYPE(Static) STYPE(12) SIZE(68,2.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Ozn. parametru)   CPOS(  1, 0.2) CLEN( 15) FONT(2)
    TYPE(GET)  NAME( cAtrib)             FPOS(  1, 1.2) FLEN( 20) FONT(5) NOREVISION()
    TYPE(Text) CAPTION(Název parametru)  CPOS( 23, 0.2) CLEN( 15) FONT(2)
    TYPE(GET)  NAME( cAtribNaz)          FPOS( 23, 1.2) FLEN( 30) FONT(5)

  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(68,5.7) FPOS(1, 2.7) RESIZE(yn)
*    TYPE(GET)  NAME( cHodnAtrC)         FPOS(16, 0.4) FLEN( 40) FCAPTION(Hodnota znaková)   CPOS( 1, 0.4) PP(2)
*    TYPE(GET)  NAME( nHodnAtrN)         FPOS(16, 1.4) FLEN( 40) FCAPTION(Hodnota èíselná)   CPOS( 1, 1.4) PP(2)
  TYPE(End)

  TYPE(MLE) NAME(mPoznamka) FPOS(0.5, 9.6) SIZE(69,5.4) ;
                            FCAPTION(Popis parametru) CPOS( 1, 8.5) CLEN(20) RESIZE(yy)