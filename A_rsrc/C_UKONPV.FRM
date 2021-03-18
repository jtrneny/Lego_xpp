TYPE(drgForm) DTYPE(2) TITLE(Èíselník ukonèení pracovního vztahu) SIZE(60,15) FILE(C_UKONPV);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_UKONPV)                         ;
                            FIELDS(nTypUkoPrV                    , ;
                                   cNazUkoPrV                    , ;
                                   PER_c_ukoncpv_BC():ods:2.7::2 ) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nTypUkoPrV) FPOS(18,1) FLEN( 2) FCAPTION(Typ ukonèení PPV)                   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazUkoPrV) FPOS(18,2) FLEN(40) FCAPTION(Název ukonèení PPV)            CPOS(1,2)
  TYPE(COMBOBOX) NAME(lOdstupne)  FPOS(18,3) FLEN(21) FCAPTION(Vyplácet odstupné)             CPOS(1,3) REF( LYESNO) 
TYPE(End)

* POST( postLastField_2)
