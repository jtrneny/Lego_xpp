TYPE(drgForm) DTYPE(10) TITLE(Poøízení jednorázových srážkových dokladù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() POST(postValidate)


TYPE(Action) CAPTION(~Dokl_SRZ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(13) FPOS(0.50,0.20) SIZE(98.75,2.15)
  TYPE(TEXT) FCAPTION(Jméno pracovníka)  CPOS(0.5,0.15)   CLEN(25)
  TYPE(TEXT) FCAPTION(OsÈíslo)           CPOS(28.5,0.15)  CLEN(8)
  TYPE(TEXT) FCAPTION(PrVz)              CPOS(36.5,0.15)  CLEN(5)
   TYPE(TEXT) NAME(MsPrc_MO->cPracovnik) CPOS(  0.5,1.00) CLEN(25) PP(2) FONT(7)
   TYPE(TEXT) NAME(MsPrc_MO->nOsCisPrac) CPOS( 28.0,1.00) CLEN(8)  PP(2) FONT(5)
   TYPE(TEXT) NAME(MsPrc_MO->nPorPraVzt) CPOS( 36.0,1.00) CLEN(4)  PP(2) FONT(5)

  TYPE(TEXT) FCAPTION(KmStø:)           CPOS(42.0,0.15)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->cKmenStrPr)   CPOS( 49.0,0.15) CLEN(7) PP(2)
  TYPE(TEXT) FCAPTION(KmPrZa:)           CPOS(42.0,1.00)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->cPracZar)     CPOS( 49.0,1.00) CLEN(7) PP(2)

  TYPE(TEXT) FCAPTION(TarStu:)            CPOS(56.0,0.15)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->cTarifStup)   CPOS( 62.5,0.15) CLEN(7) PP(2)
  TYPE(TEXT) FCAPTION(TarTøíd:)           CPOS(56.0,1.00)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->cTarifTrid)   CPOS( 62.5,1.00) CLEN(7) PP(2)

  TYPE(TEXT) FCAPTION(ZpOdm:)             CPOS(70.0,0.15)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->cTypTarMzd)   CPOS( 76.5,0.15) CLEN(10) PP(2)
  TYPE(TEXT) FCAPTION(Sazba :)            CPOS(70.0,1.00)  CLEN(7)
   TYPE(TEXT) NAME(MsPrc_MO->nTarSazHod)   CPOS( 76.5,1.00) CLEN(8) PP(2)

  TYPE(TEXT) FCAPTION(Prùmìr H/D)         CPOS(87.0,0.15)  CLEN(10)
  TYPE(TEXT) FCAPTION(/)                  CPOS(92.0,1.00)  CLEN(2)
   TYPE(TEXT) NAME(MsPrc_MO->nHodPrumPP)   CPOS( 86.5,1.00) CLEN(5.5) PICTURE(99.99) PP(2)
   TYPE(TEXT) NAME(MsPrc_MO->nDenPrumPP)   CPOS( 93.0,1.00) CLEN(5) PICTURE(9999) PP(2)

TYPE(END)


TYPE(STATIC) STYPE(13) FPOS(0.75,2.70) SIZE(98.50,22.05)
*TYPE(TabPage) TTYPE(4) CAPTION(HrubáMzda) OFFSET(1,82) FPOS(0.75,2.7) SIZE(98.5,22.05)
  TYPE(Browse) FPOS(0.50,0.20) SIZE(15.2,6.90) FILE(M_DAVHD) INDEXORD(1)            ;
               FIELDS( nDoklad:Èíslo dokladu:11)                                                ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) ITEMSELECTED(ItemSelected) SCROLL(ny)

  TYPE(STATIC) STYPE(12) FPOS(15.9,0.20) SIZE(28.00,6.90)
    TYPE(TEXT) FCAPTION(È.dokladu:)    CPOS(0.5,0.4) CLEN(10)
     TYPE(GET) NAME(M_SRZw->nDoklad)    FPOS( 10.5,0.4) FLEN(10) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(DatPoøízení:)  CPOS(0.5,1.4) CLEN(10)
     TYPE(GET) NAME(M_SRZw->dDatPoriz)  FPOS( 10.5,1.4) FLEN(10) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(TypSrážky:)    CPOS(0.5,2.4) CLEN(10)
     TYPE(GET) NAME(M_SRZw->cTypSrz)    FPOS( 10.5,2.4) FLEN(10) PP(2) FONT(5)
  TYPE(END)

  TYPE(STATIC) STYPE(13) FPOS(45.0,0.20) SIZE(52.90,6.90)
    TYPE(TEXT) FCAPTION(PracDoba:)          CPOS( 0.5,0.15) CLEN(9)
     TYPE(TEXT) NAME(MsPrc_MO->cDelkPrDob)   CPOS( 9.0,0.15) CLEN(18) PP(2)
    TYPE(TEXT) FCAPTION(DovolZùst M/B:)     CPOS( 28.5,0.15) CLEN(12)
    TYPE(TEXT) FCAPTION(/)                  CPOS( 42.5,0.15) CLEN(2)
     TYPE(TEXT) NAME(MsPrc_MO->nDovMinZus)   CPOS( 40.0,0.15) PICTURE(999) PP(2) CLEN(3)
     TYPE(TEXT) NAME(MsPrc_MO->nDovBezZus)   CPOS( 43.0,0.15) PICTURE(999) PP(2) CLEN(3)
    TYPE(STATIC) STYPE(16) FPOS( 0.5,0.90) SIZE(51.9,0.4)
    TYPE(TEXT) FCAPTION(KDny    PDny     Hod             Kè   Prùm)  CPOS( 9.5,1.35)
    TYPE(TEXT) FCAPTION(ZaDoklad)           CPOS( 0.5,2.30)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondKD)   CPOS(  8.5,2.30)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondPD)   CPOS( 13.5,2.30)
*     TYPE(TEXT) NAME(M_DAVHDw->nHodFondPD)   CPOS( 19.5,2.30)
*     TYPE(TEXT) NAME(M_DAVHDw->nMzda)        CPOS( 24.5,2.30)
    TYPE(TEXT) FCAPTION(CelkemHM)           CPOS( 0.5,3.15) CLEN(10)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondKD)   CPOS(  8.5,3.15)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondPD)   CPOS( 13.5,3.15)
*     TYPE(TEXT) NAME(M_DAVHDw->nHodFondPD)   CPOS( 19.5,3.15)
*     TYPE(TEXT) NAME(M_DAVHDw->nMzda)        CPOS( 24.5,3.15)
    TYPE(TEXT) FCAPTION(CelkemNM)           CPOS( 0.5,4.00) CLEN(10)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondKD)   CPOS(  8.5,4.00)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondPD)   CPOS( 13.5,4.00)
*     TYPE(TEXT) NAME(M_DAVHDw->nHodFondPD)   CPOS( 19.5,4.00)
*     TYPE(TEXT) NAME(M_DAVHDw->nMzda)        CPOS( 24.5,4.00)
    TYPE(TEXT) FCAPTION(CelkemSR)           CPOS( 0.5,4.85) CLEN(10)
*     TYPE(TEXT) NAME(M_DAVHDw->nMzda)        CPOS( 24.5,4.85)

    TYPE(STATIC) STYPE(16) FPOS( 8.5,5.60) SIZE(25.5,0.4)

*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondKD)   CPOS(  8.25,5.90) FONT(5)
*     TYPE(TEXT) NAME(M_DAVHDw->nDnyFondPD)   CPOS( 13.25,5.90) FONT(5)
*     TYPE(TEXT) NAME(M_DAVHDw->nHodFondPD)   CPOS( 19.25,5.90) FONT(5)
*     TYPE(TEXT) NAME(M_DAVHDw->nMzda)        CPOS( 24.20,5.90) FONT(5)
   TYPE(END)

  TYPE(STATIC) STYPE(12) FPOS(0.5,10.00) SIZE(98.00,11.80)


  TYPE(END)

TYPE(END)

TYPE(STATIC) STYPE(12) FPOS(0.75,10.20) SIZE(40.00,5.80)


TYPE(END)

*TYPE(TabPage) TTYPE(4) CAPTION(Srážky) OFFSET(18,65) FPOS(0.75,2.7) SIZE(98.5,22.05)

*TYPE(END)

*TYPE(TabPage) TTYPE(4) CAPTION(Nemocenky) OFFSET(35,48) FPOS(0.75,2.7) SIZE(98.5,22.05)

*TYPE(END)