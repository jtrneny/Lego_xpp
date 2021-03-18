TYPE(drgForm) DTYPE(10) TITLE(Typy úètování) SIZE(100,25) ;
              GUILOOK(Action:n,IconBar:y) CARGO() POST( PostValidate)


TYPE(DBrowse) FPOS(0.50,0.2) SIZE(98.75,17.0) FILE(UcetPrSy) INDEXORD(1)          ;
                                              FIELDS( cTypUct                    ,;
                                                      cNazTypUct                 ,;
                                                      cMainFile                  ,;
                                                      dPlatnyOd)                  ;
                                              CURSORMODE(3) PP(7) POPUPMENU(y)

TYPE(MLE) NAME('UcetPrSy->mUctuj_MD') FPOS(0.50,18.4) SIZE(49.40,6.15) ;
           READONLY(Y) FCAPTION(Strana MD) CPOS(1.5, 17.8) CLEN(20)

TYPE(MLE) NAME('UcetPrSy->mUctuj_DAL') FPOS(50.35,18.4) SIZE(49.40,6.15) ;
           READONLY(Y) FCAPTION(Strana DAL) CPOS(51.35, 17.8) CLEN(20) 


