TYPE(drgForm) DTYPE(10) TITLE(Výdejové doklady - VÝBÌR) SIZE(100,19) FILE(PVPITEM);
               GUILOOK(Action:n,Message:n,IconBar:n,Menu:n)

  TYPE(DBrowse) FILE(PVPHEAD) INDEXORD(1) ;
                FIELDS(nDoklad:Výdejový doklad,;
                       cTypPohybu:Pohyb,;
                       C_TypPoh->cNazTypPoh:Název pohybu:30  ,;
                       dDatPVP   ,;
                       nRok      ,;
                       nObdobi   ,;
                       nCenaDokl ,;
                       nTypPoh   );
                FPOS( 0, 0) SIZE(100,19) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy) LFREEZE(1) POPUPMENU(y);
                ITEMSELECTED( RecordSelected)