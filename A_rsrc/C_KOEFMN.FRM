TYPE(drgForm) DTYPE(2) TITLE(Koeficienty množství) SIZE(55,15) FILE(C_KOEFMN);
                       GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(55,14) FILE(C_KOEFMN) FIELDS(NKOEFMN, cZkratJedn, cPopisKoef );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET) NAME(NKOEFMN)    FPOS(15,1) FLEN(15) FCAPTION(Koef. množství)    CPOS(1,1) PP(2) POST( drgPostUniqueKey)
    TYPE(GET) NAME(cZkratJedn) FPOS(15,2) FLEN(10) FCAPTION(MJ koeficientu)    CPOS(1,2) 
    TYPE(GET) NAME(cPopisKoef) FPOS(15,3) FLEN(30) FCAPTION(Popis koeficientu) CPOS(1,3) 
  TYPE(End)
TYPE(End)
