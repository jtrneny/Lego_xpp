TYPE(drgForm) SIZE(50,20) DTYPE(10) TITLE(Seznam uživatelù - VÝBÌR);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
              CARGO()

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(49,19.5) FILE( USERS)                  ;
                                            FIELDS( cOsoba:Uživatel:25  , ;
                                                    cUser               , ;
                                                    cGroup              ) ;
                                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)

