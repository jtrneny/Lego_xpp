TYPE(drgForm) DTYPE(10) TITLE(Vyúètování danì ze závislé èinnosti) SIZE(100,25) ;
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

TYPE(Browse) FPOS(0.50,1.60) SIZE(98.75,10.0) FILE(MSPRC_MO) INDEXORD(1)                    ;
             FIELDS( nOsCisPrac, cPracovnik::30       ;
                   , dDatNast, dDatVyst, cKmenStrPr  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(Browse) FPOS(0.50,11.60) SIZE(98.75,4.0) FILE(VYUCDANE) INDEXORD(1)                    ;
             FIELDS( nRok, cPrepNedop, nPrepNedop, nDZD_Celk       ;
                   , nNEZ_Celk, nZaklDane, nVypocDan, nUSZ_Celk  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(Browse) FPOS(0.50,15.60) SIZE(98.75,9.15) FILE(VYUCDANI) INDEXORD(1)                    ;
             FIELDS( nObdobi, nUZD_Zames, nPOJ_Zames, nDZD_Zames, nNEZ_Prac              ;
                   , nNEZ_Deti, nNEZ_CasIn, nNEZ_PlnIn, nNEZ_ZTP, nNEZ_Stud       ;
                   , nNEZ_Uver, nNEZ_Celk, nZDA_Mzda, nUSZ_Zames )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)