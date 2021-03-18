TYPE(drgForm) DTYPE(10) TITLE(Registraèní pokladna ...) SIZE(110,27) ;
                                                        FILE(POKLHDw) POST(postValidate) GUILOOK(Action:n,IconBar:n,Menu:n,Message:y)


* horní lišta èÚètenky, pokladna, pokladní, datum, èas
  TYPE(Static) FPOS(0,0) SIZE(110,2.3) STYPE(12) RESIZE(yn)
   TYPE(Text) CAPTION(Èíslo paragonu)   CPOS( 2, .1) CLEN(13)
   TYPE(Text) CAPTION([)                CPOS(15, .1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)   
   TYPE(Get)  NAME(poklhdw->ncisfak)    FPOS(17, .1) FLEN(10) NOREVISION()
   TYPE(Text) CAPTION(])                CPOS(28, .1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
   TYPE(Text) NAME(poklhdw ->cjmenovys) CPOS(45, .1) CLEN(30) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
 
****
   TYPE(Text) CAPTION([)                CPOS( 78, .1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
     TYPE(Text) NAME(M->nazevDne)       CPOS( 80, .1) CLEN( 8)  
     TYPE(Text) NAME(M->datumDne)       CPOS( 88, .1) CLEN(10) 
     TYPE(Text) NAME(M->casDne)         CPOS(101, .1) CLEN( 8)   
   TYPE(Text) CAPTION(])                CPOS(108, .1) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 

   TYPE(Get)  NAME(poklhdW->ncisFirmy)  FPOS( 17,1.1) FLEN(10) FCAPTION(Odbìratel )   CPOS( 2, 1.1)  FONT(5) CLEN(11) PUSH(fin_firmy_sel) NOREVISION()
   TYPE(Text) NAME(poklhdW->cnazev)     CPOS( 30,1.1) CLEN(30)

*   TYPE(Get)  NAME(FAKVYSHDw->NICO)              FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
*   TYPE(Get)  NAME(FAKVYSHDw->CDIC)              FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
  TYPE(End)


  TYPE(DBrowse) FPOS(0,2.5) SIZE(110,16.3) FILE(POKLITw)                    ;
                                           FIELDS(nintcount:polDokl       , ;
                                                  csklpol:sklPoložka      , ;
                                                  cnazzbo:název zboží:34  , ;
                                                  nfaktmnkoe:prodMnož     , ;
                                                  czkrjednd:prodMJ        , ;  
                                                  nfaktmnoz:množství      , ;
                                                  czkratjedn:mj           , ;     
                                                  ncejprkdz:cena/mj:13,     ;
                                                  ncecprkdz:cenaCelkem      );
                                           CURSORMODE(3) PP(9) RESIZE(yy) SCROLL(ny) POPUPMENU(nn)



  TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 8,18.7) CLEN(11) CTYPE(1)                          
    TYPE(Text)  CAPTION([)                 CPOS(.8,19.3) CLEN( 2) CTYPE(2)                        GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(POKLITw->ccissklad)   CPOS( 2,19.45) CLEN(20) CTYPE(3)                       GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  CAPTION(])                 CPOS(23,19.3) CLEN( 2) CTYPE(2)                        GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(množství)            CPOS(33,18.7) CLEN( 7) CTYPE(2)                         
  TYPE(Text)  CAPTION(mj)                  CPOS(49,18.7) CLEN( 3) CTYPE(2) 

   TYPE(Text)  CAPTION([)                  CPOS(25.5,19.3 ) CLEN( 2) CTYPE(2)                     GROUPS(SETFONT,7.Arial CE) 
   TYPE(Text)  NAME(POKLITw->nFaktMnoz)    CPOS(26.5,19.45) CLEN(20) CTYPE(3)                     GROUPS(SETFONT,7.Arial CE) 
   TYPE(Text)  NAME(POKLITw->czkratJedn)   CPOS(47  ,19.45) CLEN( 4) CTYPE(3)                     GROUPS(SETFONT,7.Arial CE) 
   TYPE(Text)  CAPTION(])                  CPOS(52  ,19.3 ) CLEN( 2) CTYPE(2)                     GROUPS(SETFONT,7.Arial CE) 
                       

  TYPE(STATIC) FPOS(.5, 19.2) STYPE(9)  SIZE(109,7.7) CTYPE(3) PP(2) RESIZE(yy)
    TYPE(Get)  NAME(POKLITw->CSKLPOL)    FPOS( 1,1.2) FLEN(22) PP(2) PUSH(fakturovat_z_sel) FONT(7)
* 2 5 6 7
*    TYPE(Get)  NAME(POKLITw->NFAKTMNOZ)  FPOS(25.5,1.2) FLEN(19) PP(2) FONT( 7)
*    TYPE(Text) NAME(POKLITw->CZKRATJEDN) CPOS(47  ,1.2) CLEN( 6) PP(2) BGND(13)

    TYPE(Get)  NAME(POKLITw->nFaktMnKoe)  FPOS(25.5,1.2) FLEN(19) PP(2) FONT( 7)
    TYPE(Get)  NAME(POKLITw->czkrJednD)   FPOS(47  ,1.2) FLEN( 6) PP(2) PUSH(poklhd_c_prepmj_sel)                       

    TYPE(Text) NAME(POKLITw->CNAZZBO)    CPOS( 1,2.2) CLEN(52) PP(2) BGND(13) FONT(7)                   

    TYPE(TEXT) CAPTION(cena)         CPOS( 2,4.3) CLEN( 5)                                    
    TYPE(TEXT) CAPTION(záklaníSDph)  CPOS(25,4.2) CLEN(10)                                    
    TYPE(TEXT) CAPTION(celkem)       CPOS(44,4.2) CLEN( 6)                                    

    TYPE(STATIC) STYPE(13) FPOS( 1,4.8) SIZE(52, 2)                                     
      TYPE(Get)   NAME(POKLITw->ncejprkdz) FPOS(17,0.5) FLEN(16)   PP(2) FONT(7) PUSH(edit_pc)
      TYPE(Text)  NAME(POKLITw->ncecprkdz) CPOS(35,0.5) CLEN(14)   BGND(13) CTYPE(2)    
    TYPE(End)

    TYPE(PushButton) POS(101.0,.2) SIZE(3,1) EVENT(edit_ns)  ICON1(420) ICON2(421) ATYPE(1) TIPTEXT(Oprava nákladové strukrury ...)
    TYPE(PushButton) POS(105.0,.2) SIZE(3,1) EVENT(openKase) ICON1(114) ICON2(214) ATYPE(1) TIPTEXT(Otevøení pokladny ...)

    TYPE(STATIC) STYPE(12) FPOS(67.3,3) SIZE(41,4.2) CTYPE(2) 
      TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(41,1.65) CTYPE(2) 
        TYPE(Text) CAPTION(k platbì) CPOS(2,.1) CLEN(35) FONT(7) SIZE(35,1.1) CTYPE(3)
      TYPE(End)      

      TYPE(Text) NAME(poklhdw->ncenzahcel) CPOS(2,2) CLEN(38) CTYPE(2) BGND(13) SIZE(38,1.8) CTYPE(3) GROUPS(SETFONT,24.Arial CE)
    TYPE(End)   

  TYPE(End)

* neviditelné pomocné položky
 TYPE(TEXT)     NAME(poklitw->cfile_iv)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->nrecs_iv)   FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->nnapocet)   FPOS(0,0) CLEN(0)
*
 TYPE(ComboBox) NAME(POKLHDw->cTYPPOHYBU) FPOS(0,0) FLEN(0) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()
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







