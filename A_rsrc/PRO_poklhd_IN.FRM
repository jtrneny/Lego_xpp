TYPE(drgForm) DTYPE(10) TITLE(Registraèní pokladna ...) SIZE(110,27)  ;
                                                        FILE(POKLHDw) POST(postValidate) GUILOOK(Action:n,IconBar:n,Menu:n,Message:y)


* horní lišta èÚètenky, pokladna, pokladní, datum, èas
  TYPE(Static) FPOS(0,0) SIZE(110,3.3) STYPE(12) RESIZE(yn)

   TYPE(Static) FPOS(0,0) SIZE(110,1.1) STYPE(12) RESIZE(yn)
     TYPE(Text) CAPTION(Pokladna ->)      CPOS( 2, .1)
     TYPE(Text) NAME(poklhdw->npokladna)  CPOS(15, .1) CTYPE(2) GROUPS(SETFONT,9.Arial CE)   
     TYPE(Text) NAME(poklhdw->cnazPoklad) CPOS(21, .1) CTYPE(2) GROUPS(SETFONT,9.Arial CE)   
   TYPE(End)


   TYPE(Text) CAPTION(Èíslo paragonu)   CPOS( 2, 1.1) CLEN(13)
   TYPE(Text) CAPTION([)                CPOS(15, 1.1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)   
   TYPE(Get)  NAME(poklhdw->ncisfak)    FPOS(17, 1.1) FLEN(10) NOREVISION()
   TYPE(Text) CAPTION(])                CPOS(28, 1.1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
   TYPE(Text) NAME(poklhdw ->cjmenovys) CPOS(45, 1.1) CLEN(30) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
 
****
   TYPE(Text) CAPTION([)                CPOS( 78, 1.1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
     TYPE(Text) NAME(M->nazevDne)       CPOS( 80, 1.1) CLEN( 8)  
     TYPE(Text) NAME(M->datumDne)       CPOS( 88, 1.1) CLEN(10) 
     TYPE(Text) NAME(M->casDne)         CPOS(101, 1.1) CLEN( 8)   
   TYPE(Text) CAPTION(])                CPOS(108, 1.1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 

   TYPE(Get)  NAME(poklhdW->ncisFirmy)  FPOS( 17,2.1) FLEN(10) FCAPTION(Odbìratel )   CPOS( 2, 2.1)  FONT(5) CLEN(11) PUSH(fin_firmy_sel) NOREVISION()
   TYPE(Text) NAME(poklhdW->cnazev)     CPOS( 30,2.1) CLEN(25)
  
*  TYPE(Text) CAPTION(procento slevy)   CPOS(19  , 2.7) CLEN(15) FONT(5)
   TYPE(Text) NAME(poklhdw->nprocSLHOT) CPOS(60  , 2.1) CLEN( 8) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION(%)                CPOS(67.5, 2.1) CLEN( 3) FONT(5)


   TYPE(PushButton)                     POS(94.5,2.1)       ;
                                        CAPTION()           ;
                                        EVENT(obdobi_Fin)   ;                                         
                                        SIZE(15,1)  ICON1(0) ATYPE(3) TIPTEXT(Aktuální období úlohy ...)
  TYPE(End)


  TYPE(DBrowse) FPOS(0,3.5) SIZE(110,15.3) FILE(POKLITw)                    ;
                                           FIELDS(nintcount:polDokl       , ;
                                                  csklpol:sklPoložka      , ;
                                                  cnazzbo:název zboží:34  , ;
                                                  nfaktmnkoe:prodMnož     , ;
                                                  czkrjednd:prodMJ        , ;  
                                                  nfaktmnoz:množství      , ;
                                                  czkratjedn:mj           , ;     
                                                  ncejprkdz:cena/mj:13,     ;
                                                  ncecprkdz:cenaCelkem      );
                                           CURSORMODE(3) PP(6) RESIZE(yy) SCROLL(ny) POPUPMENU(nn)



  TYPE(STATIC) FPOS(.5, 18.6) STYPE(11)  SIZE(109,7.9) CTYPE(3) PP(3) RESIZE(yx)

  TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 8,-0.1) CLEN(11) CTYPE(1)                          
    TYPE(Text)  CAPTION([)                 CPOS(.7,0.6) CLEN( 2) CTYPE(2)                        GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(POKLITw->ccissklad)   CPOS( 2,0.75) CLEN(20) CTYPE(3)                       GROUPS(SETFONT,8.Arial CE Bold,GRA_CLR_YELLOW) 
    TYPE(Text)  CAPTION(])                 CPOS(22,0.6) CLEN( 2) CTYPE(2)                        GROUPS(SETFONT,7.Arial CE) 

  TYPE(Text)  CAPTION(množství)            CPOS(33,-0,1) CLEN( 7) CTYPE(2)                         
  TYPE(Text)  CAPTION(mj)                  CPOS(49,-0.1) CLEN( 3) CTYPE(2) 

    TYPE(Text)  CAPTION([)                  CPOS(25  , .6 ) CLEN( 2) CTYPE(2)                     GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(POKLITw->nFaktMnoz)    CPOS(26.5, .75) CLEN(20) CTYPE(3)                     GROUPS(SETFONT,8.Arial CE Bold,GRA_CLR_YELLOW) 
    TYPE(Text)  NAME(POKLITw->czkratJedn)   CPOS(47  , .75) CLEN( 4) CTYPE(3)                     GROUPS(SETFONT,8.Arial CE Bold,GRA_CLR_YELLOW) 
    TYPE(Text)  CAPTION(])                  CPOS(52  , .6 ) CLEN( 2) CTYPE(2)                     GROUPS(SETFONT,7.Arial CE) 
                       

*  TYPE(STATIC) FPOS(.5, 19.2) STYPE(9)  SIZE(109,7.7) CTYPE(3) PP(2) RESIZE(yy)
    TYPE(Get)  NAME(POKLITw->CSKLPOL)    FPOS( 1,1.6) FLEN(22) PP(2) PUSH(fakturovat_z_sel) FONT(7)
* 2 5 6 7
*    TYPE(Get)  NAME(POKLITw->NFAKTMNOZ)  FPOS(25.5,1.6) FLEN(19) PP(2) FONT( 7)
*    TYPE(Text) NAME(POKLITw->CZKRATJEDN) CPOS(47  ,1.2) CLEN( 6) PP(2) BGND(13)

    TYPE(Get)  NAME(POKLITw->nFaktMnKoe)  FPOS(25.5,1.6) FLEN(19) PP(2) FONT( 7)
    TYPE(Get)  NAME(POKLITw->czkrJednD)   FPOS(47  ,1.6) FLEN( 6) PP(2) PUSH(poklhd_c_prepmj_sel)                       

    TYPE(Text) NAME(POKLITw->CNAZZBO)    CPOS( 1,2.8) CLEN(52) PP(2) BGND(13) FONT(7)                   

    TYPE(TEXT) CAPTION(cena)         CPOS( 2,4.4) CLEN( 5)                                    
    TYPE(TEXT) CAPTION(záklaníSDph)  CPOS(25,4.4) CLEN(10)                                    
    TYPE(TEXT) CAPTION(celkem)       CPOS(44,4.4) CLEN( 6)                                    

    TYPE(STATIC) STYPE(13) FPOS( 1,5.0) SIZE(52, 2)  RESIZE(xx)                                    
      TYPE(Get)   NAME(POKLITw->ncejprkdz) FPOS(17,0.5) FLEN(16)   PP(2) FONT(7) PUSH(edit_pc)
      TYPE(Text)  NAME(POKLITw->ncecprkdz) CPOS(35,0.5) CLEN(14)   BGND(13) CTYPE(2)
    TYPE(End)

    TYPE(Text)  NAME(POKLITw->nsazDan)  CPOS(53  ,5.5) CLEN(12) CTYPE(2) GROUPS(SETFONT,9.Arial CE Bold,GRA_CLR_BLACK) 

    TYPE(PushButton) POS(101.0,.2) SIZE(3,1) EVENT(edit_ns)  ICON1(420) ICON2(421) ATYPE(1) TIPTEXT(Oprava nákladové strukrury ...)
    TYPE(PushButton) POS(105.0,.2) SIZE(3,1) EVENT(openKase) ICON1(114) ICON2(214) ATYPE(1) TIPTEXT(Otevøení pokladny ...)

    TYPE(STATIC) STYPE(15) FPOS(67.3,2) SIZE(41,5.2) CTYPE(2) RESIZE(xx)                                    
      TYPE(STATIC) STYPE(14) FPOS(0,0) SIZE(41,1.65) CTYPE(2) RESIZE(xx)                                    
        TYPE(Text) CAPTION(k platbì)   CPOS( 2,.3) CLEN(20) FONT(7) SIZE(20,1.3) CTYPE(3)         
        TYPE(Text) NAME(M->infoVal_13) CPOS(21,.4) CLEN(12) GROUPS(SETFONT,9.Arial CE Bold,GRA_CLR_BLACK)
        TYPE(Text) NAME(M->infoVal_12) CPOS(31,.4) CLEN(10) GROUPS(SETFONT,9.Arial CE Bold,GRA_CLR_BLACK)
      TYPE(End)      

      TYPE(Text) NAME(poklhdw->ncenzahcel) CPOS(2,2) CLEN(38) CTYPE(2) BGND(13) SIZE(38,2.8) CTYPE(3) GROUPS(SETFONT,32.Arial CE)
    TYPE(End)   

  TYPE(End)

* neviditelné pomocné položky
 TYPE(TEXT)     NAME(poklitw->cfile_iv)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->nrecs_iv)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->nnapocet)   FPOS(0,0) CLEN(0)
*
 TYPE(Text)     NAME(POKLHDw->CVARSYM)    FPOS(0,0) CLEN(0) 
 TYPE(ComboBox) NAME(POKLHDw->cTYPPOHYBU) FPOS(0,0) FLEN(0) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()
 TYPE(Text)     NAME(POKLHDw->CZKRTYPUHR) FPOS(0,0) CLEN(0) 

 TYPE(Text)     NAME(POKLITw->NCISLODL)   FPOS(0,0) CLEN(0) 
 TYPE(Text)     NAME(POKLITw->CCISLOBINT) FPOS(0,0) CLEN(0) 
 TYPE(Text)     NAME(POKLITw->CCISZAKAZI) FPOS(0,0) CLEN(0) 
 TYPE(Text)     NAME(POKLITw->NCISZALFAK) FPOS(0,0) CLEN(0) 
*
 TYPE(Text)     NAME(POKLITw->NPROCDPH)   FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->NRADVYKDPH) FPOS(0,0) CLEN(0)
*
 TYPE(Text)     NAME(POKLITw->NKOEFMN)    FPOS(0,0) CLEN(0)
*
 TYPE(Text)     NAME(POKLITw->NCEJPRZBZ)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->NHODNSLEV)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->NPROCSLEV)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->ncejprkbz)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->ncejPrZDZ)  FPOS(0,0) CLEN(0)
*
 TYPE(TEXT)     NAME(poklitW->nzboziKat)  FPOS(0,0) CLEN(0)
*
 TYPE(Text)     NAME(POKLITw->ncecprzbz)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->ncelkslev)  FPOS(0,0) CLEN(0)
 TYPE(Text)     NAME(POKLITw->ncecprkbz)  FPOS(0,0) CLEN(0)
*
 TYPE(TEXT)     NAME(poklitw->nvypsazdan) FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->njeddan)    FPOS(0,0) CLEN(0)
*
 TYPE(TEXT)     NAME(poklitw->cNAZPOL1)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->cNAZPOL2)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->cNAZPOL3)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->cNAZPOL4)   FPOS(0,0) CLEN(0) 
 TYPE(TEXT)     NAME(poklitw->cNAZPOL5)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->cNAZPOL6)   FPOS(0,0) CLEN(0)







