TYPE(drgForm) DTYPE(10) TITLE(Dodavatelsk� ��r.k�dy z termin�lu ) FILE(DodTERM);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_MListDAV_crd)

TYPE(Action) CAPTION(~Aktualizuj) EVENT(DodZboz_AKT) TIPTEXT(Aktualizace ��r.k�d� z termin�lu )
TYPE(Action) CAPTION(~Dodavatel ) EVENT(DodZboz_inf) TIPTEXT()

* Dodterm ... Dodavatelsk� ��r.k�dy z termin�lu
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


