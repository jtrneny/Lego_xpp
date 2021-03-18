TYPE(drgForm) DTYPE(10) TITLE(Èerpané obìdy za období) SIZE(100,25) OBDOBI(MZD)  ;
              GUILOOK(Action:y,IconBar:y) CARGO() COMMFILES( msprc_mo:,          ; 
                                                             mzpobedo: )    

TYPE(Action) CAPTION(import~Obìdy ) EVENT(mzd_import_OBEDY)   TIPTEXT(Vytvoøí srážkové doklady za obìdy)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)

TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)

  TYPE(TEXT) CAPTION(Èerpané obìdy za období) CPOS(13,0.10) CLEN(25) FONT(2)

TYPE(END)

  TYPE(EBrowse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(MzPObedO) INDEXORD(1)      ;
                                                                 CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)

    TYPE(TEXT)   NAME(       M->is_genDoklad)               CLEN( 2) CAPTION() BITMAP()
    TYPE(TEXT)   NAME(MzPObedO->nCisOsoby   )   FPOS( 1,0)  FLEN( 5) FCAPTION(ÈísOsoby)
    TYPE(TEXT)   NAME(MzPObedO->nOsCisPrac  )   FPOS( 2,0)  FLEN( 5) FCAPTION(OsÈísPrac)
    TYPE(TEXT)   NAME(MzPObedO->nPorPraVzt  )   FPOS( 3,0)  FLEN( 5) FCAPTION(PoøPraVzt)
    TYPE(TEXT)   NAME(MzPObedO->cJmenoRozl  )   FPOS( 4,0)  FLEN(30) FCAPTION(Jméno)
    TYPE(TEXT)   NAME(MzPObedO->nPocObedy   )   FPOS( 5,0)  FLEN(10) FCAPTION(Obìdy v období)
    TYPE(GET)    NAME(MzPObedO->nPocObedUp  )   FPOS( 6,0)  FLEN(10) FCAPTION(Obìdy-upravené)
    TYPE(GET)    NAME(MzPObedO->nCenaObedy  )   FPOS( 7,0)  FLEN(10) FCAPTION(CenaZaObìdy)
    
  TYPE( End)