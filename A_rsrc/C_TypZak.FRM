TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù zakázek) SIZE(60,15) FILE(C_TYPZAK);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPZAK)          ;
                            FIELDS( cTypZak       , ;
                                    cNazev        , ;
                                    nPolZak       , ;
                                    c1_picture:ozn, ;
                                    cpicture:vzor   ) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cTypZak)    FPOS(15,1) FLEN( 3) FCAPTION(Typ zakázky)    CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazev)     FPOS(15,2) FLEN(20) FCAPTION(Název typu)     CPOS(1,2)
  TYPE(COMBOBOX) NAME(nPolZak)    FPOS(15,3) FLEN(10) FCAPTION(Položková zak.) CPOS(1,3) VALUES(1: 1:1, 2: 1:N ) POST( postLastField_2)
  TYPE(GET)      NAME(c1_picture) FPOS(15,4) FLEN( 2) FCAPTION(První znak_Zak) CPOS(1,4)
  TYPE(GET)      NAME(cpicture)   FPOS(15,5) FLEN(30) FCAPTION(Vzor èísla_Zak) CPOS(1,5)
TYPE(End)
