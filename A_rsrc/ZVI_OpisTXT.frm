TYPE(drgForm) DTYPE(10) TITLE(Kontrolní opis exportovaného souboru) FILE(OpisTXT);
              SIZE(110,25) GUILOOK(Message:n,Action:n,IconBar:y:myIconBar)

TYPE(DBrowse) FILE(OpisTXT) INDEXORD(1) ;
              FIELDS( nRadek      ,;
                      cText       );
              SIZE(110,25) FPOS(0, 0) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y)

