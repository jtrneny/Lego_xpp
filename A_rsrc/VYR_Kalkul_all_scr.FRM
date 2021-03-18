TYPE(drgForm) DTYPE(10) TITLE(Pøehled všech KALKULACÍ) SIZE(120, 25) FILE(KALKUL);
               GUILOOK(Action:y,Message:n,IconBar:y:drgStdBrowseIconBar, Menu:n)

TYPE(Action) CAPTION(info ~Kalkulace)   EVENT(VYR_KALKUL_INFO) TIPTEXT(Informaèní karta Kalkulace )
TYPE(Action) ATYPE( 5)
TYPE(Action) CAPTION(info ~Zakázky)     EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta Výrobní zakázky )
TYPE(Action) CAPTION(info ~Vyr.pol.)    EVENT(VYR_VYRPOL_INFO) TIPTEXT(Informaèní karta Vyrábìné položky )

* KALKULACE - seznam všech kalkulací
  TYPE(DBrowse) FILE(KALKUL) INDEXORD(4);
                FIELDS(VYR_StavKALK():A:2.7::2 ,;
                       cCisZakaz  ,;
                       cVyrPol    ,;
                       nVarCis    ,;
                       cTypKalk:Typ kalk.  ,;
                       cVypKalk   ,;
                       nRokVyp    ,;
                       nObdMes    ,;
                       dDatAktual ,;
                       nPorKalDen:Poø.kalk. ,;
                       nCenKalkP  ,;
                       nCenKalkS  ,;
                       nCenProdP  ,;
                       cZkratMeny:Mìna ,;
                       cDruhCeny:Druh ceny  ,;
                       nMnozDavky ,;
                       nCisFirmy  ,;
                       cNazFirmy  );
                FPOS( 0, 0) SIZE(120, 24.8) CURSORMODE(3) PP(7) Resize(ny) SCROLL(yy) POPUPMENU(Y);
                ITEMMARKED( ItemMarked)
