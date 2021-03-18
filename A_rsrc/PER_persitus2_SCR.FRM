TYPE(drgForm) DTYPE(10) TITLE(Uskuteènìné školení, vzdìlávání a lékaøské prohlídky) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)


  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
                VALUES(a,a,a,a,a,a,a,a,a);
                COMBOINIT(comboBoxInit);
                ITEMSELECTED(comboItemSelected)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                ITEMSELECTED(comboItemSelected)
TYPE(END)

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,13.25) FILE(PersItem) INDEXORD(1)   ;
             FIELDS( dDatPredKo, nOrdItem, cOblastTyp       ;
                   , cZkratka, nPoradi, cPracovnik::30, dDatUskuKo, dDatUkonce  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


TYPE(STATIC) STYPE( 2) FPOS(0.50,15.10) CAPTION(Údaje o plánu) SIZE(98.75,9.15) RESIZE(YX)
    TYPE(TEXT) CAPTION(Ukonèení . . .)          CPOS( 3, 2)      CLEN(11)
     TYPE(TEXT) NAME(PersItem ->cZkratkaUk)     CPOS(17, 2)      CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(. . . Provedl . . .)     CPOS(43, 2)

    TYPE(TEXT) CAPTION(Délka . . .)             CPOS( 3, 3.05)   CLEN( 8)
     TYPE(TEXT) NAME(PersItem ->nDelka)         CPOS(17, 3.05)   CLEN( 5)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cZkrat)         CPOS(23, 3.05)   CLEN(10)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cNazev)         CPOS(34, 3.05)   CLEN(35)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Èíslo faktur . . .)      CPOS( 3, 4.15)   CLEN(14)
     TYPE(TEXT) NAME(PersItem ->nCisFak)        CPOS(17, 4.15)   CLEN(10)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cUlice)         CPOS(28, 4.15)   CLEN(25)  BGND(13) PP(2)

     TYPE(TEXT) NAME(PersItem ->cPSC)           CPOS(28, 5.20)   CLEN( 6)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cMisto)         CPOS(35, 5.20)   CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Poznámka . . .)          CPOS( 3, 6.25)   CLEN(11)
*     TYPE(TEXT) NAME(PersItem ->mPoznamka)      CPOS(17, 6.25)   CLEN(10)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Odpovìdná osoba . . .)   CPOS(45, 7.30)   CLEN(17)
     TYPE(TEXT) NAME(PersItem ->cProvedlOs)     CPOS(63, 7.30)   CLEN(30)  BGND(13) PP(2)

TYPE(END)