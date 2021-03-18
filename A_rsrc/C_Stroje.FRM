TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù strojù) SIZE(60,15) FILE(C_STROJE);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,78) PRE( tabSelect)
  TYPE(dBrowse) SIZE(60,14) FILE(C_STROJE) ;
                            FIELDS(nTypStroje:typ , ;
                                   cNazevTypu:název typu stroje:49) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(21,55) PRE( tabSelect)
  TYPE(GET)      NAME(nTypStroje)  FPOS(15,1) FLEN( 3) FCAPTION(Typ stroje)         CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazevTypu)  FPOS(15,2) FLEN(35) FCAPTION(Název typu stroje)  CPOS(1,2) 
  TYPE(COMBOBOX) NAME(cSkupStroj)  FPOS(15,3) FLEN(35) FCAPTION(Skupina strojù)     CPOS(1,3)      ;
                 VALUES(DOP_O: dopravní stroje-osobní   ,;
                        DOP_N: dopravní stroje-nákladní ,;
                        DOP_H: dopravní stroje-hromadné ,;
                        PRU: prùmyslové stroje,;
                        ZEM: zemìdìlské stroje,;
                        SPC: specielní stroje    )

*
  TYPE(Static) FPOS(2.5, 5.6) SIZE(53.5, 5.5) STYPE(12) CTYPE(2) RESIZE(yn)
    TYPE(TEXT) CAPTION(Sledování technické a diagnostické údržby )       CPOS( 1, .3) FONT(5)  

    TYPE(COMBOBOX) NAME(lsled_TDu)  FPOS(40, 1.5) FLEN( 10) FCAPTION(Sledovat technickou/diagnostickou údržbu ...) CPOS( 1, 1.5) CLEN(35) REF( LYESNO)
    TYPE(GET)      NAME(nnorm_TU)   FPOS(27, 2.9) FLEN( 10) FCAPTION(Technická    údržba po ...)                   CPOS( 3, 2.9) CLEN(20)
    TYPE(COMBOBOX) NAME(cmj_TU)     FPOS(40, 2.9) FLEN( 10) VALUES(l:litrech, km:kilometrech, hod:hodinách)    

    TYPE(GET)      NAME(nnorm_DU)   FPOS(27, 3.9) FLEN( 10) FCAPTION(Diagnosická  údržba po ...)                   CPOS( 3, 3.9) CLEN(20)
    TYPE(COMBOBOX) NAME(cmj_DU)     FPOS(40, 3.9) FLEN( 10) VALUES(l:litrech, km:kilometrech, hod:hodinách)    
  TYPE(End)



TYPE(End)


 