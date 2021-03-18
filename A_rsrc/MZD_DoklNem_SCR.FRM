TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Nemocenské dávky) SIZE(100,25) ;
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

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,10.0) FILE(MSPRC_MO) INDEXORD(1)         ;
             FIELDS( cDruPraVzt, nPorPraVzt, nOsCisPrac, cPracovnik::30       ;
                   , dDatNast, dDatVyst, cKmenStrPr  )                         ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(Browse) FPOS(0.50,11.6) SIZE(98.75,7.0) FILE(m_Nemoc) INDEXORD(1)      ;
             FIELDS( nPoradi, dDatPoriz, cMzdKatPra, dDatumOD       ;
                   , dDatumDO, nNemocCelk, nDenVzHruN                     ;
                   , nDenVzCiKN, nDenVzCisN  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(Browse) FPOS(0.50,18.6) SIZE(98.75,6.15) FILE(m_Nem) INDEXORD(1)                    ;
             FIELDS( cObdobi, nDoklad, dVykazN_OD, dVykazN_DO       ;
                   , nNemocCelk, nProplNsKD, nSazDenNiN                     ;
                   , nProplVKKD, nSazDenVKN, nProplVsKD, nSazDenVyN  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)