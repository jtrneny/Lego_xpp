TYPE(drgForm) DTYPE(10) TITLE(Èisté mzdy - Pøíkazy k úhradì) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)

  TYPE(TEXT) CAPTION(Upøesòující  nabídka : ) CPOS(13,0.4) CLEN(25) CTYPE(3) FONT(2)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
                VALUES(a,a,a,a,a,a,a,a,a);
                COMBOINIT(comboBoxInit);
                ITEMSELECTED(comboItemSelected)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                ITEMSELECTED(comboItemSelected)
TYPE(END)

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,15) FILE(C_BANKUC) INDEXORD(1)   ;
             FIELDS( CBANK_UCT, cBANK_NAZ       ;
                   , dDATPOVYP, nPosZUST, cZkratMENy, cUCET_UCT  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(STATIC) STYPE( 2) FPOS(0.50,16.85) CAPTION(Základní údaje bankovních úètù) SIZE(98.75,7.45) RESIZE(YX)
    TYPE(TEXT) CAPTION(Bankovní úèet . . .)     CPOS( 3, 2)      CLEN(15)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_UCT)      CPOS(19, 2)      CLEN(25)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_NAZ)      CPOS(44.25, 2)   CLEN(25)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_POB)      CPOS(69.50, 2)   CLEN(20)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Sídlo banky . . .)       CPOS( 3, 4)      CLEN(13)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_PSC)      CPOS(16, 4)      CLEN( 6)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_SID)      CPOS(22.25, 4)   CLEN(25)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_ULI)      CPOS(47.50, 4)   CLEN(25)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_BANKUC ->cBANKODPO)      CPOS(72.75, 4)   CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(TELEFON . . .)           CPOS( 3, 6)   CLEN(11)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_TEL)      CPOS(15, 6)   CLEN(17)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(FAX . . .)               CPOS(36, 6)   CLEN( 7)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_FAX)      CPOS(44, 6)   CLEN(17)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(MODEM . . .)             CPOS(65, 6)   CLEN(10)
     TYPE(TEXT) NAME(C_BANKUC ->cBANK_MOD)      CPOS(76, 6)   CLEN(17)  BGND(13) PP(2)

TYPE(END)