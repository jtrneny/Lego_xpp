TYPE(drgForm) DTYPE(10) TITLE( Hlášení zmìn v registru) FILE(RegHlZme);
              SIZE(100,25) GUILOOK(Message:n,Action:n,IconBar:y:myIconBar)

TYPE(DBrowse) FILE(RegHlZme) INDEXORD(1) ;
              FIELDS( nRok        ,;
                      nObdobi     ,;
                      nKusy       ,;
                      nKusyPocSt  ,;
                      nKusyKonSt  ,;
                      nKusyMinOb  ,;
                      cFarma      ,;
                      cKodHosp    ,;
                      nDrPohybP   ,;
                      cFarmaZMN   ,;
                      cZvireZem   );
              SIZE(100,25) FPOS(0, 0) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y)
