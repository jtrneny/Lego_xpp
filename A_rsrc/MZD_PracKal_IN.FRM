TYPE(drgForm) DTYPE(10) TITLE(Pracovní kalendáø - za pracovníka) SIZE(88,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(Action) CAPTION(~Dokl_HM ) EVENT()   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


 TYPE(STATIC) STYPE(2) FPOS(0.20,-0.25) SIZE(87.5,1.15) RESIZE(yn)
   TYPE(TEXT) NAME(MSPRC_MOa->nPorPraVzt) CPOS(1.5, 0.51) FLEN(5)   FONT(5)  
   TYPE(TEXT) NAME(MSPRC_MOa->nOsCisPrac) CPOS(6.5, 0.51) FLEN(10)  FONT(5)
   TYPE(TEXT) NAME(MSPRC_MOa->cPracovnik) CPOS(18.5, 0.51) FLEN(30) FONT(5)
 TYPE(End)


  TYPE(EBrowse) FPOS(0.2,1.5) SIZE(86.5,16.8) FILE(MZPRKAHD) INDEXORD(1)  ;
                                CURSORMODE(3) PP(7)  STABLEBLOCK(stableBlock) 
*ITEMMARKED(EdItemMarked) POSTVALIDATE(postValidate) POPUPMENU(n)

    TYPE(TEXT)  NAME(MzPrKaHd->dDatum)       FPOS( 1,0) FLEN(10) FCAPTION(Datum)
    TYPE(TEXT)  NAME(MzPrKaHd->CZKRNAZDNE)   FPOS( 2,0) FLEN( 6) FCAPTION(ZkrDne)
    TYPE(TEXT)  NAME(MzPrKaHd->cTypDne)      FPOS( 3,0) FLEN( 6) FCAPTION(TypDne)
    TYPE(GET)   NAME(MzPrKaHd->cTypSmeny)    FPOS( 4,0) FLEN(15) FCAPTION(Smìna)
    TYPE(TEXT)  NAME(MzPrKaHd->nFondKDDn)    FPOS( 5,0) FLEN( 6) FCAPTION(FondKdDn)
    TYPE(TEXT)  NAME(MzPrKaHd->nFondPDDn)    FPOS( 6,0) FLEN( 6) FCAPTION(FondPdDn)
    TYPE(TEXT)  NAME(MzPrKaHd->nFondKDHo)    FPOS( 7,0) FLEN( 6) FCAPTION(FondKdHo)
    TYPE(TEXT)  NAME(MzPrKaHd->nFondPDHo)    FPOS( 8,0) FLEN( 6) FCAPTION(FondPdHo)
    TYPE(GET)   NAME(MzPrKaHd->nDnyFondKD)   FPOS( 9,0) FLEN( 6) FCAPTION(OdprKaDn)
    TYPE(GET)   NAME(MzPrKaHd->nDnyFondPD)   FPOS(10,0) FLEN( 6) FCAPTION(OdprPrDn)
    TYPE(GET)   NAME(MzPrKaHd->nHodFondKD)   FPOS(11,0) FLEN( 6) FCAPTION(OdprKaHo)
    TYPE(GET)   NAME(MzPrKaHd->nHodFondPD)   FPOS(12,0) FLEN( 6) FCAPTION(OdprPrHo)
    TYPE(GET)   NAME(MzPrKaHd->nPorMenu1)    FPOS(13,0) FLEN( 3) FCAPTION(Obìd1)
    TYPE(GET)   NAME(MzPrKaHd->nPorMenu2)    FPOS(14,0) FLEN( 3) FCAPTION(Obìd2)
    TYPE(GET)   NAME(MzPrKaHd->nPorMenu3)    FPOS(15,0) FLEN( 3) FCAPTION(Obìd3)
  TYPE(END)


  TYPE(EBrowse) FPOS(0.2,19.5) SIZE(86.5,5.8) FILE(MZPRKAIT) INDEXORD(1)  ;
                                CURSORMODE(3) PP(7)   
*ITEMMARKED(EdItemMarked) POSTVALIDATE(postValidate) POPUPMENU(n)

    TYPE(GET)  NAME(MzPrKaIt->cTypSmeny)    FPOS( 1,0) FLEN(15) FCAPTION(TypSmeny)
    TYPE(GET)  NAME(MzPrKaIt->cZacatek)     FPOS( 2,0) FLEN( 6) FCAPTION(Zaèátek)
    TYPE(GET)  NAME(MzPrKaIt->cKonec)       FPOS( 3,0) FLEN( 6) FCAPTION(Konec)
    TYPE(GET)  NAME(MzPrKaIt->cDelka)       FPOS( 4,0) FLEN( 6) FCAPTION(Délka)
    TYPE(GET)  NAME(MzPrKaIt->nFondKDDn)    FPOS( 5,0) FLEN( 6) FCAPTION(FondKdDn)
    TYPE(GET)  NAME(MzPrKaIt->nFondPDDn)    FPOS( 6,0) FLEN( 6) FCAPTION(FondPdDn)
    TYPE(GET)  NAME(MzPrKaIt->nFondKDHo)    FPOS( 7,0) FLEN( 6) FCAPTION(FondKdHo)
    TYPE(GET)  NAME(MzPrKaIt->nFondPDHo)    FPOS( 8,0) FLEN( 6) FCAPTION(FondPdHo)
    TYPE(GET)  NAME(MzPrKaIt->nDnyFondKD)   FPOS( 9,0) FLEN( 6) FCAPTION(OdprKaDn)
    TYPE(GET)  NAME(MzPrKaIt->nDnyFondPD)   FPOS(10,0) FLEN( 6) FCAPTION(OdprPrDn)
    TYPE(GET)  NAME(MzPrKaIt->nHodFondKD)   FPOS(11,0) FLEN( 6) FCAPTION(OdprKaHo)
    TYPE(GET)  NAME(MzPrKaIt->nHodFondPD)   FPOS(12,0) FLEN( 6) FCAPTION(OdprPrHo)
  TYPE(END)

TYPE(END)
