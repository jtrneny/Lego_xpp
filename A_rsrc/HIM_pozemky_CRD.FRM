TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava pozemku ...) SIZE(111,20) FILE (POZEMKY)                                                ; 
                                                                              GUILOOK(Action:y,Message:y,IconBar:Y:MyIconBar,Menu:n)  ;                                                                                          
                                                                              PRE(preValidate) POST(postValidate)



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(110,7.8) STYPE(13) CTYPE(2) 

*i      TYPE(TEXT) CAPTION(inv_Èíslo)              CPOS( 2, 1.3) CLEN(12)               
*i      TYPE(GET)  NAME(pozemkyW->ninvCis)         FPOS(14, 1.3) FLEN(10)       BGND(12) FONT(5) 
*i      TYPE(TEXT) NAME(M->nazevMaj)               CPOS(27, 1.3) CLEN(30)      
*
      TYPE(TEXT) CAPTION(èíslo Katastu)          CPOS( 2,  .5) CLEN(12)               
      TYPE(GET)  NAME(pozemkyW->cku_kod)         FPOS(14,  .5) FLEN(10)       NOREVISION() BGND(12) FONT(5) 
      TYPE(TEXT) NAME(c_katast->cku_Nazev)       CPOS(27,  .5) CLEN(20)      
*
      TYPE(TEXT) CAPTION(list_Vlast)             CPOS( 2, 1.6) CELN( 9)
      TYPE(GET)  NAME(pozemkyW->nlistVlast)      FPOS(14, 1.6) FLEN(15)       NOREVISION()  
      TYPE(TEXT) NAME(c_listvl->cnazevlv)        CPOS(31, 1.6) CLEN(27)       
*
      TYPE(TEXT) CAPTION(èíslo Parcely)          CPOS( 2, 2.7) CLEN(10)
      TYPE(GET)  NAME(pozemkyW->cparcCis)        FPOS(14, 2.7) FLEN(15)       NOREVISION()
      TYPE(TEXT) CAPTION(pùv_èíslo)              CPOS(31, 2.7) CLEN( 8)
      TYPE(GET)  NAME(pozemkyW->cparcCisP)       FPOS(39, 2.7) FLEN(15)       NOREVISION()
*
      TYPE(TEXT) CAPTION(druh Pozemku)           CPOS( 2, 3.8) CLEN(11)  
      TYPE(GET)  NAME(pozemkyW->nDruhPozem)      FPOS(14, 3.8) FLEN(15)       NOREVISION()
      TYPE(TEXT) NAME(c_pozem->cNazDruPoz)       CPOS(31, 3.8) CLEN(27)
*
      TYPE(TEXT) CAPTION(inv_Èíslo)              CPOS( 2, 4.9) CLEN(12)               
      TYPE(GET)  NAME(pozemkyW->ninvCis)         FPOS(14, 4.9) FLEN(10)       NOREVISION() BGND(12) FONT(5) 
      TYPE(TEXT) NAME(M->nazevMaj)               CPOS(27, 4.9) CLEN(30)      

*      TYPE(TEXT) CAPTION(celkem)                 CPOS( 2, 5) CLEN(10) CTYPE(1)          SIZE(10,1.8) GROUPS(SETFONT,14.Arial CE) 
      TYPE(TEXT) NAME(pozemkyW->cpodil)          CPOS(14, 6) CLEN(18) CTYPE(2) BGND(12) SIZE(16,1.4) CTYPE(2) GROUPS(SETFONT,16.Arial CE)
      TYPE(TEXT) CAPTION( celkové výmìry)        CPOS(30, 6) CLEN(20) CTYPE(2)          SIZE(20,1.8) GROUPS(SETFONT,14.Cambria) 
*
*
      TYPE(STATIC) FPOS(58.6, .1) SIZE(50.9, 6.5) STYPE(12)  RESIZE(yx) CTYPE(2) GROUPS(POZ)
* L
        TYPE(TEXT) CAPTION(pozemek)               CPOS(  11,  .3) CLEN(10) CTYPE(1)  FONT(2)

        TYPE(TEXT) CAPTION(výmìra )               CPOS(  -1, 1.5) CLEN(10) CTYPE(1)      
        TYPE(GET)  NAME(pozemkyW->nvymera_M2)     FPOS(   9, 1.5) FLEN(13) FONT(5)  NOREVISION()
        TYPE(TEXT) CAPTION(m2)                    CPOS(  23, 1.5) CLEN( 3) CTYPE(1)    
* P    
        TYPE(TEXT) NAME(pozemkyW->nprocVym)       CPOS( 29, .3) CLEN( 7) PICTURE(999.99) GROUPS(SETFONT,11.Lucida,GRA_CLR_RED) CTYPE(1)
        TYPE(TEXT) CAPTION(%  ve vlastnictví)     CPOS( 35, .3) CLEN(15) CTYPE(1) FONT(2)  
 
        TYPE(GET)  NAME(pozemkyW->npodVym_M2)     FPOS( 32, 1.5) FLEN(13) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 1.8) SIZE(11,11) CAPTION(461) 
        TYPE(TEXT) CAPTION(m2)                    CPOS( 46, 1.5) CLEN( 3) CTYPE(1) 

        TYPE(TEXT) CAPTION(cenaPozemku)           CPOS( 13, 2.7) CLEN(13) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 3.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ncenaPoz)       FPOS( 32, 2.7) FLEN(13) FONT(5)

        TYPE(TEXT) CAPTION(daòZNabytí)            CPOS( 13, 3.7) CLEN(11) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 4.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ndanNabPoz)     FPOS( 32, 3.7) FLEN(13) FONT(5)

        TYPE(TEXT) CAPTION(cenaSDaní)             CPOS( 13, 4.7) CLEN(11) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 5.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ncenaSDaNa)     FPOS( 32, 4.7) FLEN(13) FONT(5)  
      TYPE(END)
  TYPE(END)


* AKCIE
*
  TYPE(STATIC) FPOS( .4,8.5) SIZE(110,11) STYPE(12)  CTYPE(2)

    TYPE(EBrowse) FPOS(-.1, .2) SIZE(109.9,11) FILE(POZEMKITw) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) ;
                                                                                              FOOTER(y)  ;   
                                                                                              GUILOOK(sizecols:n,headmove:y)
*      
      TYPE(GET)  NAME( POZEMKITw->ninvCis)                   CLEN( 10)  CAPTION(invÈíslo) 
*h      TYPE(GET)  NAME( POZEMKITw->cku_Kod)                   CLEN(  9)  CAPTION(KU) 
*h      TYPE(GET)  NAME( POZEMKITw->nListVlast)                CLEN( 11)  CAPTION(LV)
*h      TYPE(GET)  NAME( POZEMKITw->cParcCis)                  CLEN( 15)  CAPTION(èísloParcely) 
*h      TYPE(GET)  NAME( POZEMKITw->cParcCisP)                 CLEN( 15)  CAPTION(èísloParcely_pùvodní) 

      TYPE(GET)  NAME( POZEMKITw->cPodil)                    CLEN(  7)  CAPTION(podíl)             

*h      TYPE(GET)  NAME( POZEMKITw->nVymera_m2)                CLEN( 10)  CAPTION(výmPoz_m2)  

      TYPE(GET)  NAME( POZEMKITw->npodVym_m2)                CLEN( 10)  CAPTION(podVým_m2)  
*h      TYPE(GET)  NAME( POZEMKITw->nDruhPozem)                CLEN( 10)  CAPTION(druh pozemku)
      TYPE(TEXT) NAME( POZEMKITw->cNazPozem)                 CLEN( 25)  CAPTION(název pozemku) 
      TYPE(GET)  NAME( POZEMKITw->nCenaPoz)                  CLEN( 11)  CAPTION(cena) 
      TYPE(GET)  NAME( POZEMKITw->nDanNabPoz)                CLEN( 11)  CAPTION(daò) 
      TYPE(GET)  NAME( POZEMKITw->nCenaSDaNa)                CLEN( 11)  CAPTION(cenaS_daní )
      TYPE(GET)  NAME( POZEMKITw->csmlouva)                  CLEN( 11)  CAPTION(èísSmluvy )
      TYPE(GET)  NAME( POZEMKITw->ncisFak)                   CLEN( 11)  CAPTION(èísFatury )

*      TYPE(GET)  NAME( POZEMKITw->cBPEJ)                     CLEN(  6)  CAPTION(bonita) 

      TYPE(MLE)  NAME( POZEMKITw->mPOZNAMKA)                 FLEN( 30)  FCAPTION(pùvodní vlastník)
    TYPE(END)
  TYPE(End)



*                                                         

