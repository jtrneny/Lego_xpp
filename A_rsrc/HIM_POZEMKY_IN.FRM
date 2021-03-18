TYPE(drgForm) DTYPE(10) TITLE(Editace evidence pozemkù) SIZE(105,25) FILE(POZEMKY);
              OBDOBI(HIM) PRE(preValidate) POST(POSTVALIDATE) ;
              PRINTFILES(pozemky:npozemek=npozemek)

TYPE(Action) CAPTION(~HM_Karta)   EVENT()             TIPTEXT(Karta hmotného majetku)
TYPE(Action) CAPTION(~PøepCeny)   EVENT(rozpPOZEMEK)  TIPTEXT(Pøepoèet ceny parcel)

TYPE(Static) STYPE(13) SIZE(104, 4.2)  FPOS( 0.5, 0.1) RESIZE(yn) CTYPE(2)  GROUPS(HIM)
  TYPE(GET)  NAME(maj->nTypMaj)             FPOS(  14, 0.5) FLEN( 9) FCAPTION(Typ majetku)     CPOS( 3,0.5) PP(2) NOREVISION() GROUPS(HIM)
  TYPE(TEXT) NAME(C_TypMAJ->cNazTypu)  CPOS(  24, 0.5) CLEN(22) BGND(13)                                                  GROUPS(HIM)
  TYPE(GET)  NAME(maj->cTypPohybu)          FPOS(  14, 1.5) FLEN( 9) FCAPTION(Druh nabytí)     CPOS( 3,1.5) PP(2) NOREVISION() PICTURE(@N99999) GROUPS(HIM) PUSH(C_TypPoh_sel)
  TYPE(TEXT) NAME(C_TypPoh->cNazTypPoh) CPOS(  24, 1.5) CLEN(22) BGND(13)                                                  GROUPS(HIM)
  TYPE(GET)  NAME(maj->nInvCis)             FPOS(  49, 1.5) FLEN(10) FCAPTION(Inv. èíslo)      CPOS( 49,0.5) FONT(5) PP(2) NOREVISION() GROUPS(HIM)
  TYPE(GET)  NAME(maj->cNazev)              FPOS(  61, 1.5) FLEN(40) FCAPTION(Název majetku)   CPOS( 61,0.5) FONT(5)                    GROUPS(HIM)

  TYPE(Static) STYPE(12) SIZE(102,1.1)  FPOS(1,2.9) RESIZE(yn) CTYPE(2) GROUPS(HIM)
    TYPE(GET)  NAME(maj->dDatPor)  FPOS(25,0) FLEN( 12) FCAPTION(Datum poøízení majetku)  CPOS( 6,0) PP(2)               PUSH(CLICKDATE) GROUPS(HIM)
    TYPE(GET)  NAME(maj->dDatZar)  FPOS(65,0) FLEN( 12) FCAPTION(datum a období zaøazení) CPOS(42,0)       NOREVISION()  PUSH(CLICKDATE) GROUPS(HIM)
    TYPE(TEXT) CAPTION(->)    CPOS(80,0) CLEN(  3) FONT(5)                                                                          GROUPS(HIM)
    TYPE(GET)  NAME(maj->cObdZar)  FPOS(85,0) FLEN(  5) CTYPE(3) FONT(5) PICTURE(99/99)                                                  GROUPS(HIM)
   TYPE(END)
TYPE(End)


* POZEMKY
*
  TYPE(STATIC) FPOS( .4,8.5) SIZE(104.2,16) STYPE(12)  CTYPE(2)

    TYPE(EBrowse) FILE(POZEMKY) INDEXORD(1) ;
                                SIZE(104.2,15.5) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y) ;
                                ITEMMARKED( ItemMarked)
 
      TYPE(GET)  NAME( POZEMKY->ninvCis)                   CLEN( 10)  CAPTION(invÈíslo) 
      TYPE(GET)  NAME( POZEMKY->cku_Kod)                   CLEN(  9)  CAPTION(KU) 
      TYPE(GET)  NAME( POZEMKY->nListVlast)                CLEN( 10)  CAPTION(LV)
      TYPE(GET)  NAME( POZEMKY->cParcCis)                  CLEN( 15)  CAPTION(èísloParcely) 
      TYPE(GET)  NAME( POZEMKY->cParcCisP)                 CLEN( 15)  CAPTION(èísloParcely_pùvodní) 
      TYPE(GET)  NAME( POZEMKY->cPodil)                    CLEN(  7)  CAPTION(podíl) 
      TYPE(GET)  NAME( POZEMKY->nVymera_m2)                CLEN( 10)  CAPTION(výmPoz_m2)  
      TYPE(GET)  NAME( POZEMKY->npodVym_m2)                CLEN( 10)  CAPTION(podVým_m2)  

      TYPE(GET)  NAME( POZEMKY->nDruhPozem)                CLEN( 10)  CAPTION(druh pozemku)
      TYPE(TEXT) NAME( POZEMKY->cNazPozem)                 CLEN( 15)  CAPTION(název pozemku) 
*
      TYPE(GET)  NAME( POZEMKY->nCenaPoz)                  CLEN( 11)  CAPTION(cena) 
      TYPE(GET)  NAME( POZEMKY->nDanNabPoz)                CLEN( 11)  CAPTION(daò) 
      TYPE(GET)  NAME( POZEMKY->nCenaSDaNa)                CLEN( 11)  CAPTION(cenaS_daní ) 
      TYPE(GET)  NAME( POZEMKY->cBPEJ)                     CLEN(  6)  CAPTION(bonita) 
      TYPE(MLE)  NAME( POZEMKY->mPOZNAMKA)                 FLEN( 15)  FCAPTION(pùvodní vlastník)
    TYPE(End)
  TYPE(End)

TYPE(End)
