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

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,15) FILE(TrvalZAV) INDEXORD(1)   ;
             FIELDS( cUloha, cZkrTypZAV, cNazevZAV       ;
                   , cZkrTypUhr, cBank_UCT  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


TYPE(STATIC) STYPE( 2) FPOS(0.50,16.85) CAPTION(Popis trvalé platby - závazku) SIZE(98.75,7.45) RESIZE(YX)
    TYPE(TEXT) CAPTION(Na Úèet . . .)           CPOS( 3, 2)
     TYPE(TEXT) NAME(TrvalZAV ->cUcet)          CPOS(20, 2)      CLEN(25)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Var.symbol . . .)        CPOS( 3, 3.05)
     TYPE(TEXT) NAME(TrvalZAV ->cVarSym)        CPOS(20, 3.05)   CLEN(15)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Konst.symbol . . .)      CPOS( 3, 4.15)   CLEN(15)
     TYPE(TEXT) NAME(TrvalZAV ->nKonstSymb)     CPOS(20, 4.15)   CLEN( 5)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Spec.symbol . . .)       CPOS( 3, 5.20)
     TYPE(TEXT) NAME(TrvalZAV ->cSpecSymb)      CPOS(20, 5.20)   CLEN(20)  BGND(13) PP(2)
TYPE(END)