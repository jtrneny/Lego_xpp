TYPE(drgForm) DTYPE(10) TITLE(PØEHLED nedokonèené výroby ...) SIZE(100,25);
                        GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar) OBDOBI(VYR) 

  TYPE(Action) CAPTION(info ~Zakázka)   EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta vyrobní zakázky )
  TYPE(Action) CAPTION(kontr ~SKLnákl)  EVENT(VYR_ROZPRAC_CTRL_SK_SCR) TIPTEXT(Kontrola materiálových nákladù )
  TYPE(Action) CAPTION(kontr ~MZDnákl)  EVENT(VYR_ROZPRAC_CTRL_MZ_SCR) TIPTEXT(Kontrola mzdových nákladù )

  TYPE(DBrowse) SIZE(100,24.9) FILE(ROZPRAC) INDEXORD(1) ;
               FIELDS( nROK,;
                       nObdobi,;
                       cCisZakaZ,;
                       nSkPrMatZ,;
                       nSkPrMzdZ,;
                       nSkPrKooZ,;
                       nSkRezieZ) ;
               CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) SCROLL(ny) POPUPMENU(yy)

