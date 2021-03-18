TYPE(drgForm) DTYPE(10) TITLE(Nastavení odpoèitatelných položek a daòových úlev) SIZE(110,20) FILE(C_ODPOCw);
              GUILOOK(Action:n)

  TYPE(TEXT) CAPTION(K nastavení x) FONT(5)    CPOS( 2, 0.10)   CLEN(15)
  TYPE(TEXT) CAPTION(Nastavené )   FONT(5)    CPOS(60, 0.10)   CLEN(15)

  TYPE(Browse) FPOS( 0.5,1.15) SIZE(42.0,17.70) FIELDS(nPorOdpPol::4,cTypOdpPol::5,nDanUlObd::7,nDanUlObd::8) CURSORMODE(3) PP(1) SCROLL(ny) FILE(C_ODPOCw)
  TYPE(Browse) FPOS(58.0,1.15) SIZE(41.5, 8.00) FIELDS(nPorOdpPol:Poø:4,cTypOdpPol::5,nDanUlObd:7,nDanUlRok::8) CURSORMODE(3) PP(1) SCROLL(ny) FILE(MSODPPOLw)

  TYPE(PushButton) POS(45,4)  SIZE(10,1) CAPTION(>>)
* TYPE(PushButton) POS(45,6)  SIZE(10,1) CAPTION(všechny >>)
 TYPE(PushButton) POS(45,8)  SIZE(10,1) CAPTION(<<)
* TYPE(PushButton) POS(45,10) SIZE(10,1) CAPTION(všechny <<)
* EVENT(Vyber_SKLAD) TIPTEXT(Výbìr aktuálního skladu )


  TYPE(Static) STYPE(13) FPOS(58,10.3) SIZE(41.5,6.4) RESIZE(y)
    TYPE(TEXT) FCAPTION(Daò úleva)                            CPOS( 1,0.25) CLEN(9)
     TYPE(TEXT) NAME(MSODPPOLw->cNazOdpPol)                  CPOS( 10,0.15) CLEN( 31) BGND(13) PP(3) FONT(5)
    TYPE(TEXT) FCAPTION(Rodn.è.RP)                          CPOS( 1,1.30) CLEN(9)
     TYPE(TEXT) NAME(MSODPPOLw->cRodCisRP)                   CPOS( 10,1.20) CLEN(15) BGND(13) PP(3)
    TYPE(TEXT) FCAPTION(Platnost_DATUM)                     CPOS(  1, 2.95) CLEN(13)
    TYPE(TEXT) FCAPTION(OD)                                 CPOS( 14, 2.95) CLEN(3)
    TYPE(TEXT) FCAPTION(DO)                                 CPOS( 28, 2.95) CLEN(3)
     TYPE(GET) NAME(MSODPPOLw->dPlatnOD)                     FPOS( 18, 2.85) FLEN(8) PP(2) FONT(5)
     TYPE(GET) NAME(MSODPPOLw->dPlatnDO)                     FPOS( 32, 2.85) FLEN(8) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Platnost_OBDOBÍ)                    CPOS(  1, 4.05) CLEN(13)
    TYPE(TEXT) FCAPTION(OD)                                 CPOS( 14, 4.05) CLEN(3)
    TYPE(TEXT) FCAPTION(DO)                                 CPOS( 28, 4.05) CLEN(3)
     TYPE(GET) NAME(MSODPPOLw->cObdOD)                       FPOS( 18, 3.95) FLEN(8) PP(2) FONT(5)
     TYPE(GET) NAME(MSODPPOLw->cObdDO)                       FPOS( 32, 3.95) FLEN(8) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Hodnota úlevy)                         CPOS( 1, 5.10) CLEN(13)
    TYPE(TEXT) FCAPTION(OBD)                                CPOS( 14, 5.10) CLEN(4)
    TYPE(TEXT) FCAPTION(ROK)                                CPOS( 28, 5.10) CLEN(4)
     TYPE(GET) NAME(MSODPPOLw->nDanUlOBD)                    FPOS( 18, 5.00) FLEN(8) PP(2) FONT(5)
     TYPE(GET) NAME(MSODPPOLw->nDanUlROK)                    FPOS( 32, 5.00) FLEN(8) PP(2) FONT(5)
  TYPE(End)


*TYPE(TabPage) CAPTION(Detail)OFFSET(14,70)
*  TYPE(GET) NAME(cTypOdpPol) FPOS(15,1) FLEN(5) FCAPTION(Karta) CPOS(1,1);
*            POST( drgPostUniqueKey)
*TYPE(End)