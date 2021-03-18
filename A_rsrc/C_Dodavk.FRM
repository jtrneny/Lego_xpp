TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù dodávek) SIZE(60,15) FILE(C_Dodavk);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_Dodavk) FIELDS( cTypDodavk, cNazDodavk, mPoznamka);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect) 
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)  NAME(cTypDodavk)  FPOS(18,1)  FLEN( 7) FCAPTION(Typ dodávky) CPOS(1,1) PP(2);
               POST( drgPostUniqueKey)
    TYPE(GET)  NAME(cNazDodavk) FPOS(18,2) FLEN(32) FCAPTION(Název dodávky) CPOS(1,2)
    TYPE(MLE)  NAME(mPoznamka ) FPOS(0.5, 7.5) SIZE( 58,6) FCAPTION( Popis dodávky) CPOS(1, 6.5)  RESIZE(yx) SCROLL(ny)
  TYPE(End)
TYPE(End)