TYPE(drgForm) DTYPE(10) TITLE(Vnitropodnikové sazby mzdových úètù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

*TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)

  TYPE(TEXT) CAPTION(Upøesòující  nabídka : ) CPOS(13,0.10) CLEN(25) FONT(2)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.10) FLEN(22) ;
                VALUES(a,a,a,a,a,a,a,a,a);
                COMBOINIT(comboBoxInit);
                ITEMSELECTED(comboItemSelected)

  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.10) FLEN(20);
                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                ITEMSELECTED(comboItemSelected)
TYPE(END)

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(C_VNMZUC) INDEXORD(1)      ;
             FIELDS( nUcetMzdy, cUcetNak1, cUcetVyn1, nSazbaVnU1, nTypVypoc1 ;
                   , nTypNulov1, cUcetNak2, cUcetVyn2, nSazbaVnU2, nTypVypoc2, nTypNulov2  )                ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)