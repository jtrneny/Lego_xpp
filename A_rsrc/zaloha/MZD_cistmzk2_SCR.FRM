TYPE(drgForm) DTYPE(10) TITLE(Èisté mzdy - Sumarizované èisté mzdy) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


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

TYPE(Browse) FPOS(0.50,1.60) SIZE(25,23.15) FILE(MzPod_Ob) INDEXORD(1)   ;
             FIELDS( nRok, nObdobi  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(STATIC) STYPE( 13) FPOS(26,1.60) SIZE(73.25,23.15) RESIZE(YX)
    TYPE(TEXT) CAPTION(Hrubá  mzda . . .)         CPOS( 3, 1)
     TYPE(TEXT) NAME(MzPod_Ob ->nHrubaMzda)       CPOS(20, 1)      CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Základ.mzd . . .)          CPOS(38, 1)
     TYPE(TEXT) NAME(MzPod_Ob ->nMzdZaklad)       CPOS(55, 1)      CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nemocenská . . .)          CPOS( 3, 2.05)
     TYPE(TEXT) NAME(MzPod_Ob ->nNemocCelk)       CPOS(20, 2.05)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Pøípla.mzd . . .)          CPOS(38, 2.05)
     TYPE(TEXT) NAME(MzPod_Ob ->nMzdPripl)        CPOS(55, 2.05)   CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Prémie.mzd . . .)          CPOS(38, 3.10)
     TYPE(TEXT) NAME(MzPod_Ob ->nMzdOdmeny)       CPOS(55, 3.10)   CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Náhrad.mzd . . .)          CPOS(38, 4.15)
     TYPE(TEXT) NAME(MzPod_Ob ->nMzdNahrad)       CPOS(55, 4.15)   CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(K výplatì . . .)           CPOS( 3, 5.20)
     TYPE(TEXT) NAME(MzPod_Ob ->nCastKVypl)       CPOS(20, 5.20)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Ostatn.mzd . . .)          CPOS(38, 5.20)
     TYPE(TEXT) NAME(MzPod_Ob ->nMzdOstatn)       CPOS(55, 5.20)   CLEN(11)  BGND(13) PP(2)


    TYPE(TEXT) CAPTION(Odv.soc.pojištìní . . .)   CPOS( 3, 7.25)   CLEN(17)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoSocPC)       CPOS(20, 7.25)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(O . . .)                   CPOS(34, 7.25)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoSocPO)       CPOS(38, 7.25)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Z . . .)                   CPOS(51, 7.25)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoSocPZ)       CPOS(55, 7.25)   CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Odv.zdr.pojištìní . . .)   CPOS( 3, 8.30)   CLEN(17)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoZdrPC)       CPOS(20, 8.30)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(O . . .)                   CPOS(34, 8.30)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoZdrPO)       CPOS(38, 8.30)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Z . . .)                   CPOS(51, 8.30)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nOdvoZdrPZ)       CPOS(55, 8.30)   CLEN(11)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Odv.danì . . .)            CPOS( 3, 9.35)   CLEN(11)
     TYPE(TEXT) NAME(MzPod_Ob ->nDanCelkem)       CPOS(20, 9.35)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Z . . .)                   CPOS(34, 9.35)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nZalohoDan)       CPOS(38, 9.35)   CLEN(11)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(S . . .)                   CPOS(51, 9.35)   CLEN( 4)
     TYPE(TEXT) NAME(MzPod_Ob ->nSrazkoDan)       CPOS(55, 9.35)   CLEN(11)  BGND(13) PP(2)


    TYPE(TEXT) CAPTION(Dny-FondP . . .)           CPOS( 3,11.40)   CLEN(12)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnyFondPD)       CPOS(16,11.40)   CLEN(10)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Odpr . . .)                CPOS(29,11.40)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnyOdprPD)       CPOS(37,11.40)   CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Svát . . .)                CPOS(49,11.40)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnySvatPD)       CPOS(57,11.40)   CLEN( 8)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nemoc . . .)               CPOS( 3,12.45)   CLEN( 8)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnyNemoKD)       CPOS(16,12.45)   CLEN(10)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Náhr . . .)                CPOS(29,12.45)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnyNahrPD)       CPOS(37,12.45)   CLEN( 8)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Neod . . .)                CPOS(49,12.45)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nDnyNeodPD)       CPOS(57,12.45)   CLEN( 8)  BGND(13) PP(2)


    TYPE(TEXT) CAPTION(Hod-FondP . . .)           CPOS( 3,14.50)   CLEN(12)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodFondPD)       CPOS(16,14.50)   CLEN( 9)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Odpr . . .)                CPOS(29,14.50)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodOdprac)       CPOS(37,14.50)   CLEN( 9)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Svát . . .)                CPOS(49,14.50)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodSvatky)       CPOS(57,14.50)   CLEN( 9)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nemoc . . .)               CPOS( 3,15.55)   CLEN( 8)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodNemoc)        CPOS(16,15.55)   CLEN( 9)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Náhr . . .)                CPOS(29,15.55)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodNahrad)       CPOS(37,15.55)   CLEN( 9)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(Neod . . .)                CPOS(49,15.55)   CLEN( 7)
     TYPE(TEXT) NAME(MzPod_Ob ->nHodNeodpr)       CPOS(57,15.55)   CLEN( 9)  BGND(13) PP(2)


  TYPE(TEXT) CAPTION( . . . . . Evidenèní stav pracovníkù . . . . . )   CPOS( 3,17.5)   CLEN(35) FONT(2)

    TYPE(TEXT) CAPTION(MSF_VObdo . . .)           CPOS( 3,19)      CLEN(12)
     TYPE(TEXT) NAME(MzPod_Ob ->nFyzStavOb)       CPOS(17,19)      CLEN( 6)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(MSF_prùmìr . . .)          CPOS(26,19)      CLEN(13)
     TYPE(TEXT) NAME(MzPod_Ob ->nPrEvPZaFy)       CPOS(40,19)      CLEN( 4)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(ÈSF_nápo . . .)            CPOS(49,19)      CLEN(10)
     TYPE(TEXT) NAME(MzPod_Ob ->nTmEvPZaPr)       CPOS(60,19)      CLEN( 9)  BGND(13) PP(2)


    TYPE(TEXT) CAPTION(MSF_KonOb . . .)           CPOS( 3,20.05)   CLEN(12)
     TYPE(TEXT) NAME(MzPod_Ob ->nFyzStavKo)       CPOS(17,20.05)   CLEN( 6)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(MSF_pøepoè . . .)          CPOS(26,20.05)   CLEN(13)
     TYPE(TEXT) NAME(MzPod_Ob ->nPrEvPZaPr)       CPOS(40,20.05)   CLEN( 7)  BGND(13) PP(2)







TYPE(End)