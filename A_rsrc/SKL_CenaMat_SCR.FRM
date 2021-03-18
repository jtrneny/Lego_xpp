TYPE(drgForm) DTYPE(10) TITLE( Materiálová cena položky) SIZE( 110, 20);
              GUILOOK( Menu:y,Action:n) PRE(preValidate) POST(postValidate)

  TYPE(EBrowse) FILE(c_MATPOL)  INDEXORD(1);
                FPOS(0,0) SIZE( 110, 9.5) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yy) POPUPMENU(y);
                ITEMMARKED(ItemMarked)

    TYPE(GET)  NAME( C_MATPOL->cZkrMat)   FPOS( 1,0) FLEN( 10) FCAPTION( Zkratka mat.)     NOREVISION()
    TYPE(GET)  NAME( C_MATPOL->cNazMat)   FPOS( 2,0) FLEN( 35) FCAPTION( Název materiálu)
    TYPE(GET)  NAME( C_MATPOL->cPolOdp_1) FPOS( 3,0) FLEN( 15) FCAPTION( Položka odpadu)
    TYPE(GET)  NAME( C_MATPOL->cSklOdp_1) FPOS( 4,0) FLEN(  8) FCAPTION( Sklad odpadu)
    TYPE(MLE)  NAME( C_MATPOL->mBlockNAV) FPOS( 5,0) FLEN( 15) FCAPTION( blok_NAV)
    TYPE(MLE)  NAME( C_MATPOL->mPoznamka) FPOS( 6,0) FLEN( 27) FCAPTION( Poznámka)

  TYPE(END)
*
  TYPE(Static) STYPE(13) SIZE( 89.8,1.2) FPOS( 0.1, 9.6)  RESIZE(yx)
    TYPE(Text) CAPTION(Èasová platnost cen materiálu) CPOS( 30, 0.1) CLEN( 35) FONT(5)
  TYPE(End)

  TYPE(EBrowse) FILE(CENAMAT)  INDEXORD(4);
                FPOS( 0,10.9) SIZE( 110, 9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yn) POPUPMENU(y)

    TYPE(GET)  NAME( CENAMAT->dDatum )    FPOS( 1,0) FLEN( 10) FCAPTION( Platnost ceny OD)
    TYPE(GET)  NAME( CENAMAT->cZkratMENz) FPOS( 2,0) FLEN( 12) FCAPTION( Zahr.mìna)
    TYPE(GET)  NAME( CENAMAT->nKurZahMen) FPOS( 3,0) FLEN( 12) FCAPTION( Kurz mìny)
    TYPE(GET)  NAME( CENAMAT->nMnozPrep)  FPOS( 4,0) FLEN( 12) FCAPTION( Mn.pøepoètu)
    TYPE(GET)  NAME( CENAMAT->nCenMatZM)  FPOS( 5,0) FLEN( 12) FCAPTION( Cena materiálu)
    TYPE(GET)  NAME( CENAMAT->nCenCNmat)  FPOS( 6,0) FLEN( 12) FCAPTION( Cena mat.v zákl.mìnì)
    TYPE(GET) NAME( CENAMAT->cZkratMENy)  FPOS( 7,0) FLEN( 12) FCAPTION( Zákl.mìna)
    TYPE(MLE)  NAME( CENAMAT->mPoznamka)  FPOS( 8,0) FLEN( 63) FCAPTION( Poznámka)
  TYPE(END)