TYPE(drgForm) DTYPE(10) TITLE(Výbìr ze systémového nastavení pro definice výkazù) SIZE(100,25) ;
              GUILOOK(Action:n,IconBar:y) CARGO() POST( PostValidate)

*TYPE(Action) CAPTION(~Typy úètování) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(DBrowse) FPOS(0.50,0.2) SIZE(98.75,15.0) FILE(DEFVYKSY) INDEXORD(1)                                                                                              FIELDS(ctask:Úloha                              , ; 
                                                    ctypnapvyk:Typ nápoètu                   , ;
                                                    cnaznapvyk:Název nápoètu                 , ;
                                                    cmainfile:Øídící soubor                  ) ;
                                              CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) ITEMSELECTED(ItemSelected)

*                TYPE(GET)            NAME(defvyksy->cmainfield)      
*                TYPE(GET)            NAME(defvyksy->cmainvyber)      
*                TYPE(GET)            NAME(defvyksy->cgrpvyber)      
*                TYPE(COMBOBOX) NAME(defvyksy->ctyppounap)   FLEN(15)                         ; 
*                                                              VALUES( I:položky            , ;
*                                                                      H:hlavièky )

TYPE(MLE) NAME('DEFVYKSY->mBlock') FPOS(0.50,16.3) SIZE(49.40,8.5) ;
           READONLY(N) FCAPTION(Nápoèet) CPOS(1.5, 15.4) CLEN(20) FONT(5)

TYPE(MLE) NAME('DEFVYKSY->mPodminka') FPOS(50.35,16.3) SIZE(49.40,8.5) ;
           READONLY(N) FCAPTION(Podmínka) CPOS(51.35, 15.4) CLEN(20) FONT(5)


