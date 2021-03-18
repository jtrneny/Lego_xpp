TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù vyrábìných položek) SIZE(60,15) FILE(C_TYPPOL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_TYPPOL) FIELDS( cTypPol    ,;
                                    cNazTypPol ,;
                                    cKodPrg    ,;
                                    lFinal     );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cTypPol)    FPOS(15,1) FLEN( 3) FCAPTION(Typ položky)     CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazTypPol) FPOS(15,2) FLEN(20) FCAPTION(Název typu)      CPOS(1,2)
  TYPE(GET)      NAME(cKodPrg)    FPOS(15,3) FLEN( 2) FCAPTION(Kód pro program) CPOS(1,3)
  TYPE(COMBOBOX) NAME(lFinal)     FPOS(15,4) FLEN(21) FCAPTION(Finální položka) CPOS(1,4) REF( LYESNO) POST( postLastField_2)
TYPE(End)

