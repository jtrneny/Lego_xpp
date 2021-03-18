TYPE(drgForm) DTYPE(10) TITLE(Pøepoèty mìrných jednotek - výbìr) SIZE(70,10) FILE(C_JEDNOT);
              GUILOOK(Message:n,Action:n,Menu:n,IconBar:n)

  TYPE(DBrowse) SIZE(70,10) FILE(C_JEDNOT) ;
                FIELDS(czkratJedn:mj                     , ;
                       cnazJednot:název mìrné jednotky:32, ;
                       M->cinfo_prepmj:pøepoèet:30         ) ;                              
                CURSORMODE(3) PP(7) POPUPMENU(yn) SCROLL(nn)
TYPE(End)

