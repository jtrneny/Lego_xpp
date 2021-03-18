TYPE(drgForm) DTYPE(10) TITLE(Èíselník typù pohybù) SIZE(100,22) FILE(C_TYPPOH);
              GUILOOK(Message:n,Action:y,IconBar:y);
              CARGO(C_TYPPOH_CRD)
*
  TYPE(DBrowse) FILE(C_TYPPOH) INDEXORD(1) ;
                FIELDS( cTask:Úloha                       ,;
                        cUloha                            ,;
                        cPodUloha:Podúloha                ,;
                        cTypDoklad:Typ dokl.              ,;
                        cTypPohybu:Typ pohybu             ,;
                        cNazTypPoh:Název typu pohybu      ,;
                        cRadDph151:Øád.výkazu DPH od 2015 ,;
                        cTypKurzu:Typ kurzu               ,;
                        lNaklStr:NS                       ,;
                        dPlatnyOD:Platnost od             ,;
                        dPlatnyDO:Platnost do               );
                SIZE(100,14.3) FPOS( 0, 1) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y)

* pøepnutí na úlohu
  TYPE(Static) STYPE(13) SIZE(99.6, 1.2) FPOS( 0.2, 0) RESIZE(yn)
    TYPE(COMBOBOX) NAME(M->nTaskFlt)  FPOS( .3, .1) FLEN( 30) VALUES( a, a, a, a, a );
                                      COMBOINIT( comboBoxInit) ITEMSELECTED(comboItemSelected)

    TYPE(Text) CAPTION(TYPY POHYBÙ) CPOS(31, 0) CLEN( 74) CTYPE(3) FONT(5)
  TYPE(End)

* Popis Operace
  TYPE(TabPage) CAPTION( Popis typu pohybu) FPOS(0, 15.5) SIZE(100,6.5) RESIZE(yx) OFFSET(1,82)
    TYPE(MLE) NAME('C_TYPPOH->mPOPITYPPO') FPOS( 1, 0.3) SIZE( 98, 5) RESIZE(yx) READONLY(y)
  TYPE(End)

* Popis Operace
  TYPE(TabPage) CAPTION( Poznámka) FPOS(0, 15.5) SIZE(100,6.5) RESIZE(yx) OFFSET(18,66)
    TYPE(MLE) NAME('C_TYPPOH->mPoznamka') FPOS( 1, 0.3) SIZE( 98, 5) RESIZE(yx) READONLY(y)
  TYPE(End)
