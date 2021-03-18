TYPE(drgForm) SIZE(100,15.2) DTYPE(10) TITLE(Výpis z evidence pro daòové úèely ...) FILE(UCETSYS) ;
                                                                                                    GUILOOK(IconBar:n,Menu:n)

TYPE(Action) CAPTION(zpracuj ~Podklad)   EVENT(zpracuj_podklady)   TIPTEXT( Zpracuj podklady pro hlášení ...)


* Browser definition
  TYPE(DBrowse) FPOS(0, 1.5) SIZE(99.8, 13.3) FILE(ucetsys)  ;
                                              FIELDS( M->setFor_sw::2::2                   , ;
                                                      M->aktobd_sw:ao:2::2                 , ;
                                                      M->zavrenD_sw:du:2::2                , ;
                                                      M->obdDan_sw:obdDañ:6                , ;  
                                                      M->obdUc_sw:obdÚè:7                  , ; 
                                                      M->obdOtevrel_sw:období otevøel:25   , ; 
                                                      M->obdUctoval_sw:poslední úètoval:25 , ;
                                                      M->obdZavrel_sw:období zavøel:25       ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(Static) STYPE(12) SIZE(99.6,1.3) FPOS(0.1,0.1) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(Výbìr období pro zpracování ...) CPOS(  1, .15)   

    TYPE(ComboBox) NAME(UCT_ucetsys:NROK) FPOS(84,.15) FLEN(15)  VALUES(a,a,a) ;
                                                                 COMBOINIT(comboBoxInit) TEMSELECTED(comboItemSelected)
  TYPE(End) 


