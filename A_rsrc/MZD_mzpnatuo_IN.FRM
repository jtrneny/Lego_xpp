TYPE(drgForm) DTYPE(10) TITLE(Èerpané naturálie za období) SIZE(100,25) OBDOBI(MZD)  ;
              GUILOOK(Action:y,IconBar:y) CARGO() COMMFILES( msprc_mo:,          ; 
                                                             mzpnatuo: )    

TYPE(Action) CAPTION(import~Podklady  ) EVENT(mzd_podklady_NATURALIE) TIPTEXT(Vytvoøí podklady z matrièního souboru pracovníkù)
TYPE(Action) CAPTION(export~Naturálie ) EVENT(mzd_import_NATURALIE)   TIPTEXT(Vytvoøí srážkové doklady za naturálie)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)

TYPE(STATIC) STYPE(14) FPOS(0.50,0.25) SIZE(98.75,1.20)

  TYPE(TEXT) CAPTION(Èerpané naturálie za období) CPOS(13,0.10) CLEN(25) FONT(2)

TYPE(END)

  TYPE(EBrowse) FPOS(0.50,1.60) SIZE(98.75,23.15) FILE(MzPNatuO) INDEXORD(1)      ;
                                                                 CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)

    TYPE(TEXT)   NAME(       M->is_genDoklad)               CLEN( 2) CAPTION() BITMAP()
    TYPE(TEXT)   NAME(MzPNatuO->nCisOsoby   )   FPOS( 1,0)  FLEN( 5) FCAPTION(ÈísOsoby)
    TYPE(TEXT)   NAME(MzPNatuO->nOsCisPrac  )   FPOS( 2,0)  FLEN( 5) FCAPTION(OsÈísPrac)
    TYPE(TEXT)   NAME(MzPNatuO->nPorPraVzt  )   FPOS( 3,0)  FLEN( 5) FCAPTION(PoøPraVzt)
    TYPE(TEXT)   NAME(MzPNatuO->cJmenoRozl  )   FPOS( 4,0)  FLEN(30) FCAPTION(Jméno)
    TYPE(TEXT)   NAME(MzPNatuO->nCenaJedn   )   FPOS( 5,0)  FLEN(10) FCAPTION(Cena za jedn.)
    TYPE(TEXT)   NAME(MzPNatuO->nMnozst     )   FPOS( 6,0)  FLEN(10) FCAPTION(Natur.nárok)
    TYPE(GET)    NAME(MzPNatuO->cZkratJedn  )   FPOS( 7,0)  FLEN(10) FCAPTION(Jednotka)
    TYPE(GET)    NAME(MzPNatuO->nMnozstUp   )   FPOS( 7,0)  FLEN(10) FCAPTION(Natur.upravené)
    TYPE(GET)    NAME(MzPNatuO->nCenaCelk   )   FPOS( 8,0)  FLEN(10) FCAPTION(Cena celkem)
    
  TYPE( End)