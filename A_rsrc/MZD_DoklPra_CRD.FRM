TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Mzdové doklady) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

*TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)

TYPE(STATIC) STYPE(2) FPOS(0.50,0.00) SIZE(98.75,2.05)

  TYPE(TEXT) FCAPTION(Jméno pracovníka:) CPOS(0.5,0.4) CLEN(35)
   TYPE(TEXT) NAME(M_DAV->cPracovnik) CPOS( 0.5,1.34) CLEN(35) PP(2) FONT(5)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
*                VALUES(a,a,a,a,a,a,a,a,a);
*                COMBOINIT(comboBoxInit);
*                ITEMSELECTED(comboItemSelected)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
*                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
*                ITEMSELECTED(comboItemSelected)
TYPE(END)



TYPE(TabPage) TTYPE(4) CAPTION(HrubáMzda) OFFSET(1,82) FPOS(0.75,2.7) SIZE(98.5,22.05)
  TYPE(Browse) FPOS(0.50,0.20) SIZE(15.2,7.0) FILE(M_DAV) INDEXORD(1)            ;
               FIELDS( nDoklad:Èíslo dokladu:11)                                                ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) SCROLL(ny)

  TYPE(STATIC) STYPE(12) FPOS(15.9,0.20) SIZE(28.00,7.0)
    TYPE(TEXT) FCAPTION(È.dokladu:) CPOS(0.5,0.4) CLEN(10)
     TYPE(GET) NAME(M_DAV->nDoklad) FPOS( 10.5,0.4) FLEN(10) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(DatPoøízení:) CPOS(0.5,1.4) CLEN(10)
     TYPE(GET) NAME(M_DAV->dDatPoriz) FPOS( 10.5,1.4) FLEN(10) PP(2) FONT(5)
  TYPE(END)

  TYPE(STATIC) STYPE(13) FPOS(46.0,0.20) SIZE(52.00,7.0)

  TYPE(END)


  TYPE(EBrowse) FPOS(0.50,7.6) SIZE(97.5,13.25) FILE(M_DAV) INDEXORD(1)       ;
                  FIELDS( cNazPol1:VýrStøed:7                                 ;
                         ,cNazPol2:Výkon:7                                    ;
                         ,cNazPol3:Zakázka:7                                  ;
                         ,cNazPol4:VýrMísto:7                                 ;
                         ,cNazPol5:Stroj:7                                    ;
                         ,cNazPol6:Operace:7                                  ;
                         ,nDnyDoklad:Dny:5                                    ;
                         ,nDruhMzdy:DrMzd:5                                   ;
*                     ,DRUHYMZD->cNazevDMz                                    ;
                         ,nSazbaDokl:Sazba                                    ;
                         ,nHodDoklad:Hodiny                                   ;
                         ,nMnPDoklad                                          ;
                         ,nHrubaMZD )                                         ;
                    CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

*TYPE(EBrowse) FPOS(0.50,13.6) SIZE(98.75,11.15) FILE(M_DAV) INDEXORD(1)      ;
*             FIELDS( cObdobi                     ;
*                     ,nDoklad                    ;
*                     ,nDruhMzdy                  ;
*                     ,DRUHYMZD->cNazevDMz        ;
*                     ,nSazbaDokl:::::GET         ;
*                     ,nDnyDoklad:::::GET         ;
*                     ,nHodDoklad:::::GET         ;
*                     ,nMnPDoklad:::::GET         ;
*                     ,nHrubaMZD:::::GET )        ;
*             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(END)

TYPE(TabPage) TTYPE(4) CAPTION(Srážky) OFFSET(18,65) FPOS(0.75,2.7) SIZE(98.5,22.05)

TYPE(END)

TYPE(TabPage) TTYPE(4) CAPTION(Nemocenky) OFFSET(35,48) FPOS(0.75,2.7) SIZE(98.5,22.05)

TYPE(END)