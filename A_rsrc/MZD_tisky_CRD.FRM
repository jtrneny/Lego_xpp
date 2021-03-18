TYPE(drgForm) DTYPE(10) TITLE(Tisky sestav) SIZE(50,17);
              GUILOOK(Action:n)

*  TYPE(TEXT) CAPTION(K nastavení ) FONT(5)    CPOS( 2, 0.10)   CLEN(15)
*  TYPE(TEXT) CAPTION(Nastavené )   FONT(5)    CPOS(60, 0.10)   CLEN(15)

*  TYPE(Browse) FPOS( 0.5,1.15) SIZE(42.0,15.70) FIELDS(nPorOdpPol::4,cTypOdpPol::5,nDanUlObd::7,nDanUlObd::8) CURSORMODE(3) PP(1) SCROLL(ny) FILE(C_ODPOCw)
*  TYPE(Browse) FPOS(58.0,1.15) SIZE(41.5, 9.00) FIELDS(nPorOdpPol:Poø:4,cTypOdpPol::5,nDanUlObd:7,nDanUlRok::8) CURSORMODE(3) PP(1) SCROLL(ny) FILE(MSODPPOLw)

 TYPE(PushButton) POS(15,4)  SIZE(10,1) CAPTION(Nový formuláø) EVENT(newfrm)
 TYPE(PushButton) POS(15,6)  SIZE(10,1) CAPTION(Oprava formuláøe) EVENT(editfrm)
 TYPE(PushButton) POS(15,10) SIZE(10,1) CAPTION(Tisk) EVENT(starttisk)


* TYPE(PushButton) POS(45,8)  SIZE(10,1) CAPTION(<<)
* TYPE(PushButton) POS(45,10) SIZE(10,1) CAPTION(všechny <<)
* EVENT(Vyber_SKLAD) TIPTEXT(Výbìr aktuálního skladu )


