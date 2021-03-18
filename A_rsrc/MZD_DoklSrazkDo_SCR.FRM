TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Srážky ze mzdy) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_doklsrazk_CRD)

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

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(m_Srz) INDEXORD(1)       ;
             FIELDS( nDruhMzdy, DRUHYMZD->cNazevDMz, cZkrSrazky, nDoklad, nOsCisPrac          ;
                   , nPorPraVzt, cPracovnik::30, nSplatka  )             ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)