TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Mzdové doklady) SIZE(100,25) ;
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

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(M_DAV) INDEXORD(1)      ;
             FIELDS( cObdobi, nDoklad, nDruhMzdy, DRUHYMZD->cNazevDMz, nSazbaDokl, nDnyDoklad ;
                   , nHodDoklad, nMnPDoklad, nHrubaMZD )                ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)