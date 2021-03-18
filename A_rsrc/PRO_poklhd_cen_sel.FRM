TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží - VÝBÌR) SIZE(110, 25)      ;
                                                   POST(postValidate) ;
                                                   GUILOOK(Action:y,Message:y,IconBar:n,Menu:n)

TYPE(Action) CAPTION(info C~eník)    EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)


TYPE(Static) STYPE(13) SIZE(110,10.8) FPOS(0,1.2) RESIZE(yy)
  TYPE(DBrowse) FPOS( -.2, -.1) FILE(CENZBOZ) INDEXORD(1)       ;
                                FIELDS(M->cenPol::2.6::2      , ;
                                       cCISSKLAD:èisSklad     , ;
                                       nZBOZIKAT:katZbo       , ;
                                       cSKLPOL:sklPoložka     , ;
                                       cNAZZBO:název zboží:25 , ;
                                       cJKPOV:jkpov           , ;
                                       M->wds_cenzboz_kDis:množKDisp:13, ;                             
                                       czkratJedn:mjSkl       , ;
                                       M->vychoziMj:mjPro     , ; 
                                       ncenaMZbo:prodCenaSdph , ;
                                       ncenaPZbo:prodCenaBdph , ;
                                       ncenaNZbo:nákCena      , ;
                                       CNAZZBO2:doplòText     ) ;
                                CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy) ITEMSELECTED(RecordSelected) POPUPMENU(yn) STABLEBLOCK(stableBlock)
TYPE(END)

*
*    
TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(CENÍK ZBOŽÍ) CPOS( 30, 0.1) CLEN( 20) FONT(5)

  TYPE(Static) STYPE(1)       SIZE(36,1.2)  FPOS( 74,0.1)  RESIZE(nx)
  TYPE(PushButton) POS(0,0)   SIZE(35,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) TIPTEXT(Volba zobrazení dat) ATYPE(2)

  TYPE(End)
TYPE(End)                                    

*
* košík
  TYPE(Static) STYPE(1) SIZE(110,13.3) FPOS(.5,12) CTYPE(2) RESIZE(yn)
    TYPE(PushButton)                              POS(103, 1.5) ;
                                                  SIZE( 6, 2.3) EVENT(smallBasket) ICON1(208) ICON2(108) ATYPE(1) ;
                                                  CAPTION(2)

    TYPE(TEXT) CAPTION(množsví)      CPOS(40, -.2) CLEN( 9)                                    
    TYPE(Text) CAPTION(mj)           CPOS(56, -.2) CLEN( 3) CTYPE(2)
    TYPE(TEXT) CAPTION(cena)         CPOS(65, -.2) CLEN( 5)                                  
    TYPE(TEXT) CAPTION(záklaníSDph)  CPOS(71, -.2) CLEN(10)                                    
    TYPE(TEXT) CAPTION(celkem)       CPOS(90, -.2) CLEN( 6)  


    TYPE(STATIC) STYPE(12) FPOS( .3,.3) SIZE(102, 2.2) CTYPE(2) 

      TYPE(STATIC) STYPE(3) FPOS( 1, .11) SIZE( 60,40 ) CAPTION(337)
                                 
      TYPE(Get)  NAME(POKLITw->nFaktMnKoe)  FPOS( 31, .7) FLEN(19) PP(2) FONT( 7)
      TYPE(Get)  NAME(POKLITw->czkrJednD)   FPOS( 54, .7) FLEN( 6) PP(2) PUSH(poklhd_c_prepmj_sel) 
      TYPE(Get)  NAME(POKLITw->ncejprkdz)   FPOS( 64, .7) FLEN(16) PP(2) FONT(7) PUSH(edit_pc)
      TYPE(Text) NAME(POKLITw->ncecprkdz)   CPOS( 85, .7) CLEN(14) FONT(7) BGND(13) CTYPE(2)                     
    TYPE(End)

    TYPE(DBrowse) FPOS(-.7,2.8) SIZE(109,9.8) FILE(POKLITw)                    ;
                                              FIELDS(nintcount:polDokl       , ;
                                                     csklpol:sklPoložka      , ;
                                                     cnazzbo:název zboží:34  , ;
                                                     nfaktmnoz:množství      , ;
                                                     czkratjedn:mj           , ;     
                                                     ncejprkdz:cena/mj:13,     ;
                                                     ncecprkdz:cenaCelkem      );
                                              CURSORMODE(3) PP(9) RESIZE(yy) SCROLL(ny) POPUPMENU(nn) FOOTER(y)
  TYPE(End)

* neviditelné pomocné položky
 TYPE(TEXT)     NAME(poklitw->ccisSklad)  FPOS(0,0) CLEN(0)
 TYPE(TEXT)     NAME(poklitw->csklPol)    FPOS(0,0) CLEN(0)

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
 TYPE(Text)     NAME(POKLITw->nFaktMnoz)  FPOS(0,0) CLEN(0)
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







                        

                      
