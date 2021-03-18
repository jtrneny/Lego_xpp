TYPE(drgForm) DTYPE(10) TITLE(Dodavatelské èár.kódy z terminálu ) FILE(DodTERM);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_MListDAV_crd)

TYPE(Action) CAPTION(~Aktualizuj) EVENT(DodZboz_AKT) TIPTEXT(Aktualizace èár.kódù z terminálu )
TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

* Dodterm ... Dodavatelské èár.kódy z terminálu
  TYPE(DBrowse) FILE(DodTERM) INDEXORD(1);
                FIELDS( nOrdItem    ,;
                        nCisFirmy   ,;
                        cCisSklad   ,;
                        cSklPol     ,;
                        cZkrCarKod  ,;
                        cCarKod     ,;
                        nUsrIdDBTe  ,;
                        lInCenZboz  ,;
                        cTypHexBCD  ,;
                        cSourceBCD  ,;
                        cTimeBCD    ,;
                        nLenBCD      );
                SIZE(100,24.9) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)


