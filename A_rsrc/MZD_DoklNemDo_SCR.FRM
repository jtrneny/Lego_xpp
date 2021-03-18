TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Nemocenské dávky) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_doklnem_CRD)

TYPE(Action) CAPTION(~Kmen_PRA ) EVENT(Pohyby_DOKLADY)    TIPTEXT(Kmenové údaje pracovníka)

  TYPE(DBrowse) FPOS(0.50,0.60) SIZE(98.75,12.00) FILE(MZDNEMHD) INDEXORD(1)      ;
                FIELDS( cObdobi,   ;
                      nDoklad,     ;
                      dDatPoriz,   ; 
                      nOsCisPrac,  ;
                      nPorPraVzt,  ;   
                      nTypPraVzt,  ;  
                      nTypZamVzt,  ;  
                      cMzdKatPra,  ;  
                      cPracZar,    ;  
                      dDatumOD,    ;  
                      dDatumDO,    ;  
                      nNemocCelk,  ;
                      nMzda)                ;
                CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(DBrowse) FPOS(0.50,13.20) SIZE(98.75,10.00) FILE(MZDNEMIT) INDEXORD(1)      ;
                FIELDS(nOrdItem,             ;
                       nDruhMzdy,            ;
                       DRUHYMZD->cNazevDMz,  ;
                       nSazbaDokl,           ;
                       nDnyDoklad,           ; 
                       nHodDoklad,           ;
                       nMnPDoklad,           ;
                       nMzda,                ;
                       nHrubaMZD)                ;
                CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) ITEMMARKED(itemMarked) POPUPMENU(y)
TYPE(End)              