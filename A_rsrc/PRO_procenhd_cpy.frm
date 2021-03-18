TYPE(drgForm) DTYPE(10) TITLE(Hromadná oprava/kopírování prodejního ceníku ...) SIZE(120,25) POST(postValidate)


* cenprodc
TYPE(TabPage) FPOS(0,5) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(cenotvorba) TABHEIGHT(.01) PRE(tabSelect) EXT()
   TYPE(DBrowse) FPOS(0,0) SIZE(120,19.8) FILE(CENPRODC) INDEXORD(3) ;
                 FIELDS( ccisSklad:èísSklad    , ;
                         csklPol:sklPoložka    , ;
                         cnazZbo:název zboží:45, ;
                         ncenCNZbo:nákCena     , ;
                         ncenaPZbo:prodCena    , ;
                         nprocMarz:% marže     , ;
                         ncenaMZbo:cenaSMarží    ) ;
                 CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(y)
TYPE(END)


* procenit
TYPE(TabPage) FPOS(0,5) SIZE(120,24.8) TTYPE(3) OFFSET(10.5,79) CAPTION(prodejníCeník) TABHEIGHT(.01) PRE(tabSelect) EXT()
  TYPE(DBrowse) FPOS(0,0) SIZE(120,19.8) FILE(PROCENIT) INDEXORD(3) ;
                FIELDS( ccisSklad:èísSklad    , ;
                        csklPol:sklPoložka    , ;
                        cnazZbo:název zboží   , ;
                        M->cenCNZbo:nákCena   , ;
                        M->cenaPZbo:prodCena  , ;
                        M->ho_procento:% marže, ;
                        M->hodnota:cenaSMarží   ) ;
                CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(y)
TYPE(END)


TYPE(STATIC) STYPE(12) SIZE(120,5) FPOS(0, 0) RESIZE(yn) CTYPE(2)
  TYPE(PushButton) POS(2,83)       SIZE(835,22) CAPTION( VSTUPNÍ  CENÍK -> ) ICON1(119) ICON2(0) ATYPE(3) EVENT(in_createContext)
  TYPE(PushButton) POS(107.5,2.75) SIZE(12,2.7) CAPTION( ~Zpracuj )          ICON1(118) ICON2(0) ATYPE(3)
  TYPE(PushButton) POS(2,2)        SIZE(835,22) CAPTION( VÝSTUPNÍ CENÍK -> ) ICON1(142) ICON2(0) ATYPE(3) EVENT(out_createContext)

  TYPE(STATIC) STYPE(12) SIZE(105,2.25) FPOS(1,1.25) CTYPE(2)
    TYPE(TEXT) NAME(cenprodc->cnazZbo) CPOS( 1,0.1) 
    TYPE(TEXT) NAME(procenit->cnazZbo) CPOS( 1,1.1) 
  TYPE(END)
TYPE(END)

