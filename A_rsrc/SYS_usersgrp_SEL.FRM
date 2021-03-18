TYPE(drgForm) SIZE(50,20) DTYPE(10) TITLE(Skupiny uživatelù - VÝBÌR);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
              CARGO()

*  TYPE(Action) CAPTION(~Adresáø osob)  EVENT(OSB_osoby_SCR) TIPTEXT(Založení/oprava seznamu osob ...)

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(49,19.5) FILE(USERSGRP)                 ;
                                            FIELDS(CGROUP:Zkratka skupiny  , ;
                                                   CNAMEGROUP              ) ; 
                                                   CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)


