TYPE(drgForm) DTYPE(2) TITLE(Èíselník druhù pozemkù) SIZE(60,15) FILE(C_POZEM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,78) PRE( tabSelect)
  TYPE(dBrowse) SIZE(60,14) FILE(C_POZEM) ;
                            FIELDS(nDruhPozem:druh , ;
                                   cNazDruPoz:název druhu pozemku:49) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(21,55) PRE( tabSelect)
  TYPE(GET)      NAME(nDruhPozem)  FPOS(15,1) FLEN( 3) FCAPTION(Druh pozemku)         CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazDruPoz)  FPOS(15,2) FLEN(35) FCAPTION(Název druhu pozemku)  CPOS(1,2) 

*
TYPE(End)


 