TYPE(drgForm) DTYPE(10) TITLE(Uskute�n�n� �kolen�, vzd�l�v�n� a l�ka�sk� prohl�dky) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Po�izov�n� doklad� o hrub� mzd�)
TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Po��zen� nemocensk�ch d�vek)


TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)


  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
                VALUES(a,a,a,a,a,a,a,a,a);
                COMBOINIT(comboBoxInit);
                ITEMSELECTED(comboItemSelected)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
                VALUES(0:Otev�en� polo�ky,1:Zav�en� polo�ky,2:Kompletn� saldo);
                ITEMSELECTED(comboItemSelected)
TYPE(END)

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,7) FILE(Personal) INDEXORD(1)   ;
             FIELDS( cPrijPrac, cJmenoPrac, nOsCisPrac       ;
                   , dDatVznPrV, dDatVyst  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(Browse) FPOS(0.50,8.85) SIZE(98.75,6) FILE(PersItem) INDEXORD(1)   ;
             FIELDS( dDatPredKo, nOrdItem, cOblastTyp,      ;
                   , cZkratka, nPoradi, dDatUskuKo, dDatUkonce, cCisOsvedc   )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


TYPE(STATIC) STYPE( 2) FPOS(0.50,15.10) CAPTION(Informa�n� �daje) SIZE(98.75,9.15) RESIZE(YX)
    TYPE(TEXT) CAPTION(Ukon�en� . . .)          CPOS( 3, 2)      CLEN(11)
     TYPE(TEXT) NAME(PersItem ->cZkratkaUk)     CPOS(17, 2)      CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(. . . Provedl . . .)     CPOS(43, 2)

    TYPE(TEXT) CAPTION(D�lka . . .)             CPOS( 3, 3.05)   CLEN( 8)
     TYPE(TEXT) NAME(PersItem ->nDelka)         CPOS(17, 3.05)   CLEN( 5)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cZkrat)         CPOS(23, 3.05)   CLEN(10)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cNazev)         CPOS(34, 3.05)   CLEN(35)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(��slo faktur . . .)      CPOS( 3, 4.15)   CLEN(14)
     TYPE(TEXT) NAME(PersItem ->nCisFak)        CPOS(17, 4.15)   CLEN(10)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cUlice)         CPOS(28, 4.15)   CLEN(25)  BGND(13) PP(2)

     TYPE(TEXT) NAME(PersItem ->cPSC)           CPOS(28, 5.20)   CLEN( 6)  BGND(13) PP(2)
     TYPE(TEXT) NAME(PersItem ->cMisto)         CPOS(35, 5.20)   CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pozn�mka . . .)          CPOS( 3, 6.25)   CLEN(11)
*     TYPE(TEXT) NAME(PersItem ->mPoznamka)      CPOS(17, 6.25)   CLEN(10)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Odpov�dn� osoba . . .)   CPOS(45, 7.30)   CLEN(17)
     TYPE(TEXT) NAME(PersItem ->cProvedlOs)     CPOS(63, 7.30)   CLEN(30)  BGND(13) PP(2)

TYPE(END)