TYPE(drgForm) DTYPE(10) TITLE(Doch�zka osob - hromadn� generov�n� doch�zky) SIZE(80,9)        ;
              GUILOOK(Action:n,IconBar:y:myIconBar,Menu:n) OBDOBI(DOH) POST(postValidate)     ;
              PRINTFILES(osoby:ncisosoby=ncisosoby,                                           ;
                         dspohyby:ncisosoby=ncisosoby+cobdobi=cobdobi)


 TYPE(STATIC) STYPE( 1) FPOS(1.5, .2) SIZE(77,2.5) CTYPE(2) RESIZE(YN)
   TYPE(TEXT) CAPTION(Generovat doklady doch�zky pro ... ) CPOS( 1,  .1) CLEN(76) PP(2) 
   TYPE(TEXT) NAME(m->infozpr)                             CPOS( 1, 1.1) CLEN(76) PP(2) FONT(7) CTYPE(1)       
 TYPE(End) 


 TYPE(Static) STYPE(12) SIZE(78, 7) FPOS( 1, .1) RESIZE(xy) CTYPE(2) GROUPS(SKL_PRE)

   TYPE(TEXT) CAPTION( Datum zpracov�n� OD : )       CPOS(  7, 2.9) CLEN(18)  FONT(1) 
   TYPE(GET) NAME(dspohybyw->ddatum_od)              FPOS( 26, 2.9) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)
   TYPE(TEXT) CAPTION( __ do __ )                    CPOS( 41, 2.9) CLEN( 7)  FONT(1) 
   TYPE(GET) NAME(dspohybyw->ddatum_do)              FPOS( 51, 2.9) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)


   TYPE(Text) CAPTION(p��chod _ )                    CPOS( 19, 4.5) CLEN(  9)  FONT(5)
   TYPE(Text) CAPTION( k�d )                         CPOS( 28, 4.5) CLEN(  4)
   TYPE(GET)  NAME(dspohybyw->cKodPrer)              FPOS( 32, 4.5) FLEN(  7)  
   TYPE(Text) CAPTION( �as )                         CPOS( 41, 4.5) CLEN(  4)
   TYPE(GET)  NAME(dspohybyw->cCasBeg)               FPOS( 45, 4.5) FLEN( 10)  PICTURE(99:99)

   TYPE(Text) CAPTION(odchod _ )                     CPOS( 19, 5.6) CLEN(  9)  FONT(5)
   TYPE(Text) CAPTION( k�d )                         CPOS( 28, 5.6) CLEN(  4)
   TYPE(GET)  NAME(dspohybyw->cKodPrerE)             FPOS( 32, 5.6) FLEN(  7)
   TYPE(Text) CAPTION( �as )                         CPOS( 41, 5.6) CLEN(  4)
   TYPE(GET)  NAME(dspohybyw->cCasEnd)               FPOS( 45, 5.6) FLEN( 10)  PICTURE(99:99)

 TYPE(End)

 TYPE(PushButton) POS( 7, 8) SIZE(300, 26) CAPTION(~Generuj doklady pro doch�zku) EVENT(generuj_doklady) ATYPE(3) ;
                   TIPTEXT( Generuje doklady pro doch�zku dle po�adavku ....)


 