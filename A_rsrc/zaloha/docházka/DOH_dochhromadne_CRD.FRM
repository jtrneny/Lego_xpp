TYPE(drgForm) DTYPE(10) TITLE(Docházka osob - hromadné generování docházky) SIZE(70,7)        ;
              GUILOOK(Action:n,IconBar:y) OBDOBI(DOH)                                         ;
              PRINTFILES(osoby:ncisosoby=ncisosoby,                                           ;
                         dspohyby:ncisosoby=ncisosoby+cobdobi=cobdobi)


*TYPE(Action) CAPTION(~Hromadnì)  EVENT()                    TIPTEXT(Hromadné vytvoøení docházky)
*TYPE(Action) CAPTION(~Dokl_NEM)  EVENT(PorDokl_NEMOCENKA)   TIPTEXT(Poøízení nemocenských dávek)

 TYPE(STATIC) STYPE( 10) FPOS(1.5,0.2) SIZE(68,1) RESIZE(YN)
   TYPE(TEXT) NAME(osoby->cjmenorozl)  CPOS( 1.5, 0.1) CLEN(26) FONT(6) 
   TYPE(TEXT) CAPTION( ÈísOsoby)       CPOS(27.0, 0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->ncisosoby)   CPOS(35.2, 0.1) CLEN(7)  FONT(6) 
   TYPE(TEXT) CAPTION( OsÈísPrac)      CPOS(44.0, 0.1) CLEN(7)  FONT(1) 
   TYPE(TEXT) NAME(osoby->noscisprac)  CPOS(52.0, 0.1) CLEN(6) FONT(6) 
*   TYPE(TEXT) CAPTION( ÈísKarty)       CPOS(86.5, 0.1) CLEN(8)  FONT(1) 
*   TYPE(TEXT) NAME(osoby->cidoskarty)  CPOS(94.0, 0.1) CLEN(15) FONT(6) 
 TYPE(End) 



 TYPE(STATIC) STYPE( 13) FPOS(1.3,3.1) SIZE(58.7,3.5) RESIZE(YX)
   TYPE(TEXT) CAPTION( Pøíchod)          CPOS(8.0, -0.1 CLEN(8)  FONT(1) 
   TYPE(TEXT) CAPTION( Odchod)           CPOS(38.0, -0.1) CLEN(8)  FONT(1) 
   TYPE(GET)  NAME(dspohybyw->cKodPrer)  FPOS(1.5,1.1)  FLEN( 7) CAPTION(KódPøích)
   TYPE(GET)  NAME(dspohybyw->cCasBeg)   FPOS(10.5,1.1) FLEN( 10) CAPTION(ÈasPøíchod) 
   TYPE(GET)  NAME(dspohybyw->cKodPrerE) FPOS(30.5,1.1) FLEN( 7) CAPTION(KódOdch)
   TYPE(GET)  NAME(dspohybyw->cCasEnd)   FPOS(39.5,1.1) FLEN( 10) CAPTION(ÈasOdchod)
*       TYPE(GET)  NAME(dspohybyw->cCasCel)   FPOS(45.1,0.1) FLEN( 10)CAPTION(ÈasCelkem) 
 TYPE(END)

 