TYPE(drgForm) DTYPE(10) TITLE(Pøevod pozemku na list vlastnictví ...) SIZE(111,12) FILE (POZEMKY)                                                ; 
                                                                      GUILOOK(Action:n,Message:y,IconBar:Y:MyIconBar,Menu:n)  ;                                                                                          
                                                                      PRE(preValidate) POST(postValidate)



  TYPE(STATIC) FPOS(0.4,0.2) SIZE(110,7.8) STYPE(13) CTYPE(2) 
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
 
        TYPE(GET)  NAME(pozemkyW->npodVym_M2)     FPOS( 32, 1.5) FLEN(13) FONT(5)   NOREVISION()
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 1.8) SIZE(11,11) CAPTION(461) 
        TYPE(TEXT) CAPTION(m2)                    CPOS( 46, 1.5) CLEN( 3) CTYPE(1) 

        TYPE(TEXT) CAPTION(cenaPozemku)           CPOS( 13, 2.7) CLEN(13) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 3.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ncenaPoz)       FPOS( 32, 2.7) FLEN(13) FONT(5)   NOREVISION()

        TYPE(TEXT) CAPTION(daòZNabytí)            CPOS( 13, 3.7) CLEN(11) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 4.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ndanNabPoz)     FPOS( 32, 3.7) FLEN(13) FONT(5)   NOREVISION()

        TYPE(TEXT) CAPTION(cenaSDaní)             CPOS( 13, 4.7) CLEN(11) FONT(5)
        TYPE(STATIC) STYPE(3)                     FPOS( 30, 5.0) SIZE(11,11) CAPTION(461) 
        TYPE(GET)  NAME(pozemkyW->ncenaSDaNa)     FPOS( 32, 4.7) FLEN(13) FONT(5)   NOREVISION()
      TYPE(END)
   TYPE(END)
 
*
**RUN**
  TYPE(Static) STYPE(12) SIZE(109.2,3) FPOS(.5,8.5) CTYPE(2) RESIZE(y) GROUPS(OK)
    TYPE(PushButton) POS(  .4,1.9) SIZE(36,2.8) CAPTION(~Storno)                  EVENT(140000002)    ICON1(102) ICON2(202) ATYPE(3)    

    TYPE(Static) STYPE(12) SIZE(36,2.8) FPOS(36.5,.1) CTYPE(2) RESIZE(y) GROUPS(OK)
      TYPE(TEXT) CAPTION(pøevod na listVlastnictví)  CPOS( 1,  .1) CLEN(30) FONT(5)  GROUPS(SETFONT,11.Arial CE)
      TYPE(GET)  NAME(pozemkyW->nnewLv)              FPOS( 1, 1.2) FLEN(11) BGND(12) FONT(5)
      TYPE(TEXT) NAME(c_newLv->cnazevlv)             CPOS(13, 1.2) CLEN(27)         
    TYPE(End) 

*    TYPE(PushButton) POS(  .4,1.9) SIZE(36,2.8) CAPTION(~Storno)                 EVENT(140000002)    ICON1(102) ICON2(202) ATYPE(3)       
    TYPE(PushButton) POS(72.6,1.9) SIZE(36,2.8) CAPTION(  ~Uložit pøevod pozemku) EVENT(save_prevPoz) ICON1(101) ICON2(0)   ATYPE(3)
  TYPE(END)

TYPE(END)


*                                                         

