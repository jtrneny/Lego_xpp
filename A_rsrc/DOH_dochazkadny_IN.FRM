TYPE(drgForm) DTYPE(10) TITLE(Docházka za období - w) SIZE(120,27)                                       ;
              GUILOOK(Action:y,IconBar:y) OBDOBI(DOH) PRE(preValidGet) POST(posValidGet)                 ;
              PRINTFILES(msprc_mo:nrok=nrok+nobdobi=nobdobi+noscisprac=noscisprac+nporpravzt=nporpravzt, ;
                         dspohyby:noscisprac=noscisprac+cobdobi=cobdobi)


*TYPE(Action) CAPTION(~Doklady )  EVENT(mzd_doklhrmzdo_scr)  TIPTEXT(Poøizení dokladù o mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM)  EVENT(PorDokl_NEMOCENKA)   TIPTEXT(Poøízení nemocenských dávek)



 TYPE(STATIC) STYPE( 10) FPOS(1, .2) SIZE(118, .8) RESIZE(YN)
   TYPE(TEXT) NAME(osoby->cjmenorozl)  CPOS( 2.5, -0.1) CLEN(40) FONT(6) 
   TYPE(TEXT) CAPTION( ÈísOsoby)       CPOS(45.0, -0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->ncisosoby)   CPOS(54.0, -0.1) CLEN(10) FONT(6) 
   TYPE(TEXT) CAPTION( OsÈísPrac)      CPOS(68.0, -0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->noscisprac)  CPOS(76.0, -0.1) CLEN(8)  FONT(6) 
   TYPE(TEXT) CAPTION( ÈísKarty)       CPOS(86.5, -0.1) CLEN(8)  FONT(1) 
   TYPE(TEXT) NAME(osoby->cidoskarty)  CPOS(94.0, -0.1) CLEN(15) FONT(6) 
 TYPE(End) 

 TYPE(STATIC) STYPE( 9) FPOS(1, 1.2) SIZE(118,1.1) RESIZE(YN)
   TYPE(Text) CAPTION( Aktivní kontrola docházky -> ) CPOS( 21, .1)  CLEN(22)
   TYPE(PushButton) POS( 44, .1)   SIZE(37, 1.1) CAPTION(~Kontroly vypnuty) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
 TYPE(End) 


 TYPE(STATIC) STYPE(12) FPOS(0.5,2.2) SIZE(57,8) RESIZE(XN) GROUPS(DAYS)
     
   TYPE(TEXT) NAME(kalendar->cnazmes)  CPOS(  2.5,  .6) FONT(6)  CLEN(12)    

   TYPE(STATIC) STYPE( 12) FPOS(15.6,0.6) SIZE(41,1 ) RESIZE(XX)
     TYPE(TEXT) CAPTION( Po)     CPOS( 1.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( Út)     CPOS( 7.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( St)     CPOS(13.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( Èt)     CPOS(19.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( Pá)     CPOS(25.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( So)     CPOS(31.0, 0.1) FONT(6)  CLEN(3)
     TYPE(TEXT) CAPTION( Ne)     CPOS(37.0, 0.1) FONT(6)  CLEN(3) 
   TYPE(End)  

*   TYPE(STATIC) STYPE(3) FPOS(41,2.1) SIZE(10,10) CAPTION(171)
***** 1 týden
   TYPE(GET) NAME(m->tyd1)      FPOS( 1.2,2.0) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION() 

   TYPE(PUSHBUTTON) POS( 16,1.8) SIZE( 4, .8) CAPTION(11) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,1.8) SIZE( 4, .8) CAPTION(12) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,1.8) SIZE( 4, .8) CAPTION(13) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,1.8) SIZE( 4, .8) CAPTION(14) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,1.8) SIZE( 4, .8) CAPTION(15) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,1.8) SIZE( 4, .8) CAPTION(16) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,1.8) SIZE( 4, .8) CAPTION(17) TIPTEXT(DAY)


***** 2 týden *****
   TYPE(GET) NAME(m->tyd2)      FPOS( 1.2,2.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(PUSHBUTTON) POS( 16,2.8) SIZE( 4, .8) CAPTION(21) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,2.8) SIZE( 4, .8) CAPTION(22) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,2.8) SIZE( 4, .8) CAPTION(23) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,2.8) SIZE( 4, .8) CAPTION(24) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,2.8) SIZE( 4, .8) CAPTION(25) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,2.8) SIZE( 4, .8) CAPTION(26) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,2.8) SIZE( 4, .8) CAPTION(27) TIPTEXT(DAY)


***** 3 týden ******
   TYPE(GET) NAME(m->tyd3)      FPOS( 1.2,3.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(PUSHBUTTON) POS( 16,3.8) SIZE( 4, .8) CAPTION(31) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,3.8) SIZE( 4, .8) CAPTION(32) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,3.8) SIZE( 4, .8) CAPTION(33) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,3.8) SIZE( 4, .8) CAPTION(34) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,3.8) SIZE( 4, .8) CAPTION(35) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,3.8) SIZE( 4, .8) CAPTION(36) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,3.8) SIZE( 4, .8) CAPTION(37) TIPTEXT(DAY)


***** 4 týden ******
   TYPE(GET) NAME(m->tyd4)      FPOS( 1.2,4.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(PUSHBUTTON) POS( 16,4.8) SIZE( 4, .8) CAPTION(41) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,4.8) SIZE( 4, .8) CAPTION(42) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,4.8) SIZE( 4, .8) CAPTION(43) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,4.8) SIZE( 4, .8) CAPTION(44) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,4.8) SIZE( 4, .8) CAPTION(45) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,4.8) SIZE( 4, .8) CAPTION(46) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,4.8) SIZE( 4, .8) CAPTION(47) TIPTEXT(DAY)


***** 5 týden *******
   TYPE(GET) NAME(m->tyd5)      FPOS( 1.2,5.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(PUSHBUTTON) POS( 16,5.8) SIZE( 4, .8) CAPTION(51) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,5.8) SIZE( 4, .8) CAPTION(52) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,5.8) SIZE( 4, .8) CAPTION(53) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,5.8) SIZE( 4, .8) CAPTION(54) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,5.8) SIZE( 4, .8) CAPTION(55) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,5.8) SIZE( 4, .8) CAPTION(56) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,5.8) SIZE( 4, .8) CAPTION(57) TIPTEXT(DAY)



***** 6 týden *******
   TYPE(GET) NAME(m->tyd6)      FPOS( 1.2,6.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

   TYPE(PUSHBUTTON) POS( 16,6.8) SIZE( 4, .8) CAPTION(61) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 22,6.8) SIZE( 4, .8) CAPTION(62) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 28,6.8) SIZE( 4, .8) CAPTION(63) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 34,6.8) SIZE( 4, .8) CAPTION(64) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 40,6.8) SIZE( 4, .8) CAPTION(65) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 46,6.8) SIZE( 4, .8) CAPTION(66) TIPTEXT(DAY)
   TYPE(PUSHBUTTON) POS( 52,6.8) SIZE( 4, .8) CAPTION(67) TIPTEXT(DAY)

 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS( .4,11) SIZE(57,8) RESIZE(XN)
  TYPE(TEXT) NAME(M->doch_ZaDen)   CPOS( 15, .01) FONT(6)  CLEN(56)
*  TYPE(TEXT) CAPTION( Docházka za den)     CPOS( 20, .01) FONT(6)  CLEN(45)

   TYPE(EBrowse) FPOS(-.3,1.1) SIZE(57, 7.5) FILE(DSPOHYBYA)       ;
                  RESIZE(xn)                                       ;
                  CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(ID)      ;
                  GUILOOK(ins:yn,sizecols:n,headmove:n)

       TYPE(GET)  NAME(dspohybyA->cKodPrer)    CAPTION(Kód_Pøích) 
       TYPE(GET)  NAME(dspohybyA->cCasBeg)     CAPTION(Èas_Pøích)
       TYPE(GET)  NAME(dspohybyA->cKodPrerE)   CAPTION(Kód_Odch)
       TYPE(GET)  NAME(dspohybyA->cCasEnd)     CAPTION(Èas_Odch)
       TYPE(GET)  NAME(dspohybyA->cCasCel)     CAPTION(ÈasCelk)  FLEN(10)
       TYPE(GET)  NAME(dspohybyA->nCasCel)     CAPTION(HodCelk) 
       TYPE(TEXT) NAME(dspohybyA->nCasCelCPD)  CAPTION(HodÈist) 
   TYPE(End)  

 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS(0.4,19.0) SIZE(57,7.8) RESIZE(XY)
   TYPE(STATIC) STYPE( 1 ) FPOS(1.6,0.1) SIZE(56, .8) RESIZE(XN)
     TYPE(TEXT) CAPTION( Výroba za den)     CPOS(20, -.1) FONT(6)  CLEN(55)
   TYPE(End)  

   TYPE(DBrowse) FPOS(-.3,1) SIZE(57,7) FILE(LISTIT) INDEXORD(9) RESIZE(XY)   ;
                  CURSORMODE(3) PP(4)               ;
                   FIELDS( cTypListku:Typ:4,        ; 
                            ndruhmzdy:DMz:4,        ;
                            cciszakazi:Zakázka:15,  ;
                            nporcislis:PoøML:10,    ;
                            nnhnaopesk:VykHod:11,   ; 
                            dvyhotskut:VyhDat       )  

 TYPE(End)  


* pravá strana
 TYPE(STATIC) STYPE( 13) FPOS(58, 2.5) SIZE(61,16.5) RESIZE(YY)
   TYPE(STATIC) STYPE( 1 ) FPOS(1.6,0.1) SIZE(40,0.9) RESIZE(XN)
     TYPE(TEXT) CAPTION(Kontrolka - sumace za docházku)    CPOS(15.5,.01) FONT(6)  CLEN(48)  
   TYPE(End)  

    TYPE(DBrowse) FPOS( -.3, 1) SIZE(60 ,15.65) FILE(TMInfSUMw) INDEXORD(1) RESIZE(yy)   ;
                CURSORMODE(3) PP(7) ITEMMARKED(itemMarked)  ;
                    FIELDS( cNazSumRad:Sumaèní øádek:22,    ;
                            nHOD_den:HoDen,    ;
                            nDNY_tyden:DnTýd,  ;
                            nHOD_tyden:HoTýd,  ; 
                            nDNY_mesic:DnMìs,  ;
                            nHOD_mesic:HoMìs   )  


   
 TYPE(End)  

* pravá strana dolní záložky
 TYPE(TabPage) TTYPE(4) CAPTION(Hodiny) OFFSET(2,79) FPOS(58,19.3) SIZE(60,7.5)  RESIZE(yy) 
   TYPE(STATIC) STYPE(14) FPOS(1.0,0.3) SIZE(47.5,1.0) RESIZE(XX)
     TYPE(TEXT) CAPTION( Celkem za)     CPOS( 1.0, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Den )          CPOS(17.0, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Týden )        CPOS(28.5, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Mìsíc )        CPOS(41.0, 0.1)  CLEN(10)  
   TYPE(End)

   TYPE(TEXT) CAPTION(Fond___PD  :)     CPOS(1.0, 1.7) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->nhoddenK)     CPOS( 16.6, 1.7) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodtydenK)   CPOS( 29.0, 1.7) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodmesicK)   CPOS( 40.0, 1.7) CLEN(10) FONT(1) 

   TYPE(TEXT) CAPTION(Z docházky  :)    CPOS(1.0, 2.6) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->nhoddenD)     CPOS( 16.6, 2.6) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodtydenD)   CPOS( 29.0, 2.6) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodmesicD)   CPOS( 40.0, 2.6) CLEN(10) FONT(1) 

   TYPE(TEXT) CAPTION(Z výroby__  :)    CPOS(1.0, 3.5) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->nhoddenV)     CPOS( 16.6, 3.5) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodtydenV)   CPOS( 29.0, 3.5) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->nhodmesicV)   CPOS( 40.0, 3.5) CLEN(10) FONT(1) 

   TYPE(STATIC) STYPE(15) FPOS(1.0,5.1) SIZE(47.5, .8) RESIZE(XX)
    TYPE(TEXT) CAPTION(Rozdíl        :)      CPOS(  1.0, -.1) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->nhoddenR)     CPOS( 15.8, -.1) CLEN(10) FONT(6) 
    TYPE(TEXT) NAME(tmcelsumw->nhodtydenR)   CPOS( 28.5, -.1) CLEN(10) FONT(6) 
    TYPE(TEXT) NAME(tmcelsumw->nhodmesicR)   CPOS( 39.7, -.1) CLEN(10) FONT(6) 
   TYPE(End)

   TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)  

 TYPE(TabPage) TTYPE(4) CAPTION(Dny) OFFSET(21,59) FPOS(58,19.3) SIZE(60,7.5)  RESIZE(yy) 
   TYPE(STATIC) STYPE(14) FPOS(1.0,0.3) SIZE(47.5,1.0) RESIZE(XX)
     TYPE(TEXT) CAPTION( Celkem za)     CPOS( 1.0, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Den )          CPOS(17.0, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Týden )        CPOS(28.5, 0.1)  CLEN(10)  
     TYPE(TEXT) CAPTION( Mìsíc )        CPOS(41.0, 0.1)  CLEN(10)  
   TYPE(End)

   TYPE(TEXT) CAPTION(Fond___PD  :)     CPOS(1.0, 1.7) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->ndnydenK)     CPOS( 16.6, 1.7) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnytydenK)   CPOS( 30.0, 1.7) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnymesicK)   CPOS( 41.2, 1.7) CLEN(10) FONT(1) 

   TYPE(TEXT) CAPTION(Z docházky  :)    CPOS(1.0, 2.6) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->ndnydenD)     CPOS( 15.8, 2.6) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnytydenD)   CPOS( 29.0, 2.6) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnymesicD)   CPOS( 41.2, 2.6) CLEN(10) FONT(1) 

   TYPE(TEXT) CAPTION(Z výroby__  :)    CPOS(1.0, 3.5) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->ndnydenV)     CPOS( 15.8, 3.5) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnytydenV)   CPOS( 30.0, 3.5) CLEN(10) FONT(1) 
    TYPE(TEXT) NAME(tmcelsumw->ndnymesicV)   CPOS( 41.2, 3.5) CLEN(10) FONT(1) 

   TYPE(STATIC) STYPE(15) FPOS(1.0,5.1) SIZE(47.5, .8) RESIZE(XX)
    TYPE(TEXT) CAPTION(Rozdíl        :)      CPOS(  1.0, -.1) FONT(1)  CLEN(12)  
    TYPE(TEXT) NAME(tmcelsumw->ndnydenR)     CPOS( 15.5, -.1) CLEN(10) FONT(6) 
    TYPE(TEXT) NAME(tmcelsumw->ndnytydenR)   CPOS( 29.0, -.1) CLEN(10) FONT(6) 
    TYPE(TEXT) NAME(tmcelsumw->ndnymesicR)   CPOS( 40.2, -.1) CLEN(10) FONT(6) 
   TYPE(End)

   TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)  

*
* neviditelné pomocné položky
   TYPE(TEXT) NAME(dspohybyA->nKodPrer)    FPOS(0,0) CLEN(0) 
   TYPE(TEXT) NAME(dspohybyA->nKodPrerE)   FPOS(0,0) CLEN(0) 
   TYPE(TEXT) NAME(dspohybyA->nCasBeg)     FPOS(0,0) CLEN(0) 
   TYPE(TEXT) NAME(dspohybyA->nCasEnd)     FPOS(0,0) CLEN(0) 
   TYPE(TEXT) NAME(dspohybyA->nCasBegPD)   FPOS(0,0) CLEN(0) 
   TYPE(TEXT) NAME(dspohybyA->nCasEndPD)   FPOS(0,0) CLEN(0) 



*TYPE(End)  

