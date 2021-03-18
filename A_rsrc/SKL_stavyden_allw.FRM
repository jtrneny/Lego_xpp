TYPE(drgForm) SIZE(100,15.2) DTYPE(10) TITLE(Stav skladových karet ke dni ...) FILE(KALENDAR) ;
                                                                                  GUILOOK(IconBar:n,Menu:n)

TYPE(Action) CAPTION(zpracuj~Podklad)   EVENT(zpracuj_podklady)   TIPTEXT( Zpracuj podklady ...)


* Browser definition
  TYPE(DBrowse) FPOS(0, 1.5) SIZE(99.8, 13.3) FILE(kalendar)    ;
                                              FIELDS( nden                                 , ;
                                                      cnazmes                              , ;
                                                      ddatum                               , ;
                                                      cnazdne                              , ; 
                                                      csvatjmeno                           ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(Static) STYPE(12) SIZE(99.6,1.3) FPOS(0.1,0.1) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(Výbìr datumu pro zpracování ...) CPOS(  1, .15)   

    TYPE(ComboBox) NAME(UCT_ucetsys:NROK) FPOS(84,.15) FLEN(15)  VALUES(a,a,a) ;
                                                                 COMBOINIT(comboBoxInit) TEMSELECTED(comboItemSelected)
  TYPE(End) 


