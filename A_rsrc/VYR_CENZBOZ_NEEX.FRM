TYPE(drgForm) DTYPE(0) TITLE(Materiály neexistující v ceníku) SIZE(60, 20);
              GUILOOK(Action:y,Message:n,IconBar:y:drgStdBrowseIconBar,Menu:n)

  TYPE(DBrowse) FILE(CENZBOZw) INDEXORD(1) ;
                FIELDS( CCISSKLAD         ,;
                        CSKLPOL           ,;
                        CNAZZBO           );
                FPOS( 0, 0) SIZE(60,20) CURSORMODE(3) RESIZE(yx) PP(7) SCROLL(ny)