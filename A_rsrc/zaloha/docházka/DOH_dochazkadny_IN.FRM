TYPE(drgForm) DTYPE(10) TITLE(Docházka za období) SIZE(107,27)                                ;
              GUILOOK(Action:y,IconBar:y) OBDOBI(DOH) PRE(preValidGet) POST(posValidGet)                                        ;
              PRINTFILES(msprc_mo:nrok=nrok+nobdobi=nobdobi+noscisprac=noscisprac+nporpravzt=nporpravzt, ;
                         dspohyby:noscisprac=noscisprac+cobdobi=cobdobi)


*TYPE(Action) CAPTION(~Doklady )  EVENT(mzd_doklhrmzdo_scr)  TIPTEXT(Poøizení dokladù o mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM)  EVENT(PorDokl_NEMOCENKA)   TIPTEXT(Poøízení nemocenských dávek)



 TYPE(STATIC) STYPE( 10) FPOS(1.5,0.2) SIZE(104,1) RESIZE(YN)
   TYPE(TEXT) NAME(osoby->cjmenorozl)  CPOS( 2.5, 0.1) CLEN(40) FONT(6) 
   TYPE(TEXT) CAPTION( ÈísOsoby)       CPOS(51.0, 0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->ncisosoby)   CPOS(59.0, 0.1) CLEN(7) FONT(6) 
   TYPE(TEXT) CAPTION( OsÈísPrac)      CPOS(68.0, 0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->noscisprac)  CPOS(76.0, 0.1) CLEN(8) FONT(6) 
   TYPE(TEXT) CAPTION( ÈísKarty)       CPOS(86.5, 0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->cidoskarty)  CPOS(94.0, 0.1) CLEN(15) FONT(6) 
 TYPE(End) 

 TYPE(STATIC) STYPE( 2) FPOS(0.5,2.2) SIZE(55,10) RESIZE(YN)
     
   TYPE(TEXT) NAME(kalendar->cnazmes)  CPOS(  2.5, 0.8) FONT(6)  CLEN(12)    
*   TYPE(TEXT) NAME(kalendar->nrok)     FPOS( 12.5, 0.1) FONT(6)  CLEN(12)    

   TYPE(STATIC) STYPE( 12) FPOS(15.6,0.6) SIZE(37,1.2) RESIZE(YN)
     TYPE(TEXT) CAPTION( Po)     CPOS( 2.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Út)     CPOS( 7.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( St)     CPOS(12.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Èt)     CPOS(17.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Pá)     CPOS(22.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( So)     CPOS(27.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Ne)     CPOS(32.5, 0.1) FONT(6)  CLEN(5) 
   TYPE(End)  


***** 1 týden
 
   TYPE(GET) NAME(m->tyd1)      FPOS( 1.5,2.2) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd11)  FPOS( 17.5,2.2) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd12)  FPOS( 22.5,2.2) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd13)  FPOS( 27.5,2.2) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd14)  FPOS( 32.5,2.2) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd15)  FPOS( 37.5,2.2) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd16)  FPOS( 42.5,2.2) FLEN( 3) PP(2) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd17)  FPOS( 47.5,2.2) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 


***** 2 týden *****
   TYPE(GET) NAME(m->tyd2)      FPOS( 1.5,3.5) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd21)  FPOS( 17.5,3.5) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd22)  FPOS( 22.5,3.5) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd23)  FPOS( 27.5,3.5) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd24)  FPOS( 32.5,3.5) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd25)  FPOS( 37.5,3.5) FLEN( 3) PP(1) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd26)  FPOS( 42.5,3.5) FLEN( 3) PP(2) FONT(5)  CTYPE(2)  
   TYPE(GET) NAME(mesicw->cd27)  FPOS( 47.5,3.5) FLEN( 3) PP(2) FONT(5)  CTYPE(2)  


***** 3 týden ******
   TYPE(GET) NAME(m->tyd3)      FPOS( 1.5,4.8) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd31)  FPOS( 17.5,4.8) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd32)  FPOS( 22.5,4.8) FLEN( 3) PP(1) FONT(5)  CTYPE(2)
   TYPE(GET) NAME(mesicw->cd33)  FPOS( 27.5,4.8) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd34)  FPOS( 32.5,4.8) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd35)  FPOS( 37.5,4.8) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd36)  FPOS( 42.5,4.8) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd37)  FPOS( 47.5,4.8) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 

***** 4 týden ******
   TYPE(GET) NAME(m->tyd4)      FPOS( 1.5,6.1) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd41)  FPOS( 17.5,6.1) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd42)  FPOS( 22.5,6.1) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd43)  FPOS( 27.5,6.1) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd44)  FPOS( 32.5,6.1) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd45)  FPOS( 37.5,6.1) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd46)  FPOS( 42.5,6.1) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd47)  FPOS( 47.5,6.1) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 


***** 5 týden *******
   TYPE(GET) NAME(m->tyd5)      FPOS( 1.5,7.4) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd51)  FPOS( 17.5,7.4) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd52)  FPOS( 22.5,7.4) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd53)  FPOS( 27.5,7.4) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd54)  FPOS( 32.5,7.4) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd55)  FPOS( 37.5,7.4) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd56)  FPOS( 42.5,7.4) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd57)  FPOS( 47.5,7.4) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 


***** 6 týden *******
   TYPE(GET) NAME(m->tyd6)      FPOS( 1.5,8.7) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(GET) NAME(mesicw->cd61)  FPOS( 17.5,8.7) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd62)  FPOS( 22.5,8.7) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd63)  FPOS( 27.5,8.7) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd64)  FPOS( 32.5,8.7) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd65)  FPOS( 37.5,8.7) FLEN( 3) PP(1) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd66)  FPOS( 42.5,8.7) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 
   TYPE(GET) NAME(mesicw->cd67)  FPOS( 47.5,8.7) FLEN( 3) PP(2) FONT(5)  CTYPE(2) 

 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS(0.5,13.0) SIZE(55,5.5) RESIZE(YN)
*   TYPE(STATIC) STYPE( 12) FPOS(1.5,0.3) SIZE(52,1.2) RESIZE(YN)
     TYPE(TEXT) CAPTION( Docházka za den)     CPOS( 12.5, 0.01) FONT(6)  CLEN(45)
*   TYPE(End)  

   TYPE(EBrowse) FPOS(0.5,1.00) SIZE(54.0,4.50) FILE(DSPOHYBYw)       ;
                  RESIZE(yx)                                           ;
                   CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3)          ;
                    GUILOOK(sizecols:n,headmove:n)
       TYPE(GET)  NAME(dspohybyw->cKodPrer)  CAPTION(KódPøích)
       TYPE(GET)  NAME(dspohybyw->cCasBeg)   CAPTION(ÈasPøíchod) 
       TYPE(GET)  NAME(dspohybyw->cKodPrerE) CAPTION(KódOdch)
       TYPE(GET)  NAME(dspohybyw->cCasEnd)   CAPTION(ÈasOdchod)
       TYPE(GET)  NAME(dspohybyw->cCasCel)   CAPTION(ÈasCelkem) 
       TYPE(GET)  NAME(dspohybyw->nCasCel)   CAPTION(HodCelkem) 

   TYPE(End)  

 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS(0.5,19.0) SIZE(55,7.8) RESIZE(YN)
   TYPE(DBrowse) FPOS(0.5,1.00) SIZE(54.0,7.00) FILE(LISTIT) INDEXORD(9) RESIZE(yx)                      ;
                  CURSORMODE(3) PP(4)     ;
                   FIELDS( cTypListku:Typ:4,  ; 
                            ndruhmzdy:DMz:4,   ;
                            cciszakazi:Zakázka:15,  ;
                            nporcislis:PoøML:10,  ;
                            nnhnaopesk:VykHod:12 )  


 TYPE(End)  



 TYPE(STATIC) STYPE( 13) FPOS(56.5,2.5) SIZE(50,20) RESIZE(YY)
   TYPE(TEXT) CAPTION(Kontrolka - sumace za docházku)    CPOS(12.5, 0.01) FONT(6)  CLEN(48)  
* BGND(12)

    TYPE(DBrowse) FPOS( 0.3,1.00) SIZE(48.0,20.65) FILE(TMInfSUMw) INDEXORD(1) RESIZE(yx)                      ;
                CURSORMODE(3) PP(4)     ;
                    FIELDS( cNazSumRad:Sumaèní øádek:15,    ;
                            nHOD_den:HoDen,    ;
                            nDNY_tyden:DnTýd,  ;
                            nHOD_tyden:HoTýd,  ; 
                            nDNY_mesic:DnMìs,  ;
                            nHOD_mesic:HoMìs )  


*   TYPE(STATIC) STYPE(10) FPOS(1.0,2.2) SIZE(41,12) RESIZE(YN)


*   TYPE(End)  
   
 TYPE(End)  



*TYPE(End)  

