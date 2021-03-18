TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava pøíkazu k úhradì ...) SIZE(100,20) FILE (PRIKUHHDw)   ;
                                                                                 GUILOOK(Action:n,IconBar:y) ;
                                                                                 POST(postValidate)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(99.2,4) STYPE(13) CTYPE(2)
* 1
    TYPE(Get)  NAME(PRIKUHHDw->dPRIKUHR)   FPOS( 7, .5) FLEN(12) PP(2) FCAPTION(Dne)     CPOS( 2, .5) CLEN(5) FONT(5) PUSH(CLICKDATE) 
    TYPE(GET)  NAME(PRIKUHHDw->cBANK_UCT)  FPOS(33, .5) FLEN(25) PP(2) FCAPTION(z  úètu) CPOS(22, .5) CLEN(7) FONT(5) PUSH(FIN_C_BANKUC_SEL) 
    TYPE(TEXT) CAPTION(se stavem)          CPOS(65, .5) CLEN(10) FONT(5) 
    TYPE(TEXT) NAME(C_BANKUC->nPOSZUST)    CPOS(79, .5) CLEN(13) CTYPE(2) BGND(13) 
    TYPE(TEXT) NAME(C_BANKUC->cZKRATMENY)  CPOS(93, .5) CLEN( 5) FONT(5)
* 2
    TYPE(TEXT) CAPTION(u)                  CPOS(26,1.5) CLEN( 2) FONT(5)  
    TYPE(TEXT) NAME(PRIKUHHDw->cBANK_NAZ)  CPOS(33,1.5) CLEN(26) BGND(13)  
    TYPE(TEXT) CAPTION(pøíkazem)           CPOS(65,1.5) CLEN(10) FONT(5)  
    TYPE(TEXT) NAME(PRIKUHHDw->nDOKLAD)    CPOS(79,1.5) CLEN(13) CTYPE(2) BGND(13)
* 3
    TYPE(TEXT) CAPTION(uhradit celkem)     CPOS(65,2.5) CLEN(14) FONT(5)
    TYPE(TEXT) NAME(PRIKUHHDw->nCENZAKCEL) CPOS(79,2.5) CLEN(13) CTYPE(2) BGND(13)
    TYPE(TEXT) NAME(C_BANKUC->cZKRATMENY)  CPOS(93,2.5) CLEN( 5) FONT(5)

**    TYPE(PUSHBUTTON) CAPTION(Návrh položek pøíkazu) POS( 2,2.5) SIZE(25,.8) EVENT(FIN_prikuhit_fp_SEL)
  TYPE(End)

* IT
  TYPE(TEXT) CAPTION(typPøíkazu)    CPOS( 1  ,4.5) CLEN( 9)
  TYPE(TEXT) CAPTION(èísloFaktury)  CPOS(11.6,4.5) CLEN(10)
  TYPE(TEXT) CAPTION(textPoložky)   CPOS(25.5,4.5)
  TYPE(TEXT) CAPTION(dne)           CPOS(52.5,4.5) CLEN( 4)
  TYPE(TEXT) CAPTION(ve prospìch)   CPOS(66  ,4.5)

  TYPE(STATIC) FPOS(0.4,5) SIZE(99.2,16.4) STYPE(12)  CTYPE(1)
    TYPE(CHECKBOX) NAME(M->UHR_zavazku) FPOS(1, .5) FLEN(10) VALUES(T:závazek,F:obecný) 
  
    TYPE(GET)  NAME(PRIKUHITw->nCISFAK)    FPOS(11.5, .5) FLEN(12)       PUSH(FIN_prikuhit_fp_SEL)
    TYPE(GET)  NAME(PRIKUHITw->cNAZEV)     FPOS(25.5, .5) FLEN(25) 
    TYPE(GET)  NAME(PRIKUHITw->dUHRBANDNE) FPOS(52.5, .5) FLEN(11) PP(2) PUSH(CLICKDATE)
    TYPE(GET)  NAME(PRIKUHITw->cUCET)      FPOS(66  , .5) FLEN(25) PP(2)

* SYMBOLY
    TYPE(GET) NAME(PRIKUHITw->cVARSYM)     FPOS( 2,2.5) FLEN(15) PP(2) FCAPTION(V_Sym) CPOS( 2,1.5) CLEN(6)
    TYPE(GET) NAME(PRIKUHITw->nKONSTSYMB)  FPOS(21,2.5) FLEN( 7)       FCAPTION(K_Sym) CPOS(21,1.5) CLEN(6)
    TYPE(GET) NAME(PRIKUHITw->cSPECSYMB)   FPOS(32,2.5) FLEN(25)       FCAPTION(S_Sym) CPOS(32,1.5) CLEN(6)
    TYPE(TEXT) CAPTION(v èástce)           CPOS(65,2.5) CLEN(14)       FONT(5)
    TYPE(TEXT) NAME(PRIKUHITw->nCENZAKCEL) CPOS(79,2.5) CLEN(13) CTYPE(2) BGND(13)

    TYPE(STATIC) FPOS(0.4,2) SIZE(98.6,.1) STYPE(13)
    TYPE(End)

    TYPE(GET)  NAME(PRIKUHITw->nPRIUHRCEL) FPOS(79,3.5)  FLEN(12) PP(2) FONT(5) FCAPTION(uhradit -) CPOS(65,3.5)

    TYPE(TEXT) CAPTION(zbývá uhradit)   CPOS(65,4.5)  CLEN(14) FONT(5)
    TYPE(Text) NAME(M->prikuhit_fp_zby) CPOS(79,4.5)  CLEN(13) CTYPE(2) BGND(13) 
*    TYPE(TEXT) NAME(PRIKUHITw->nPRIUHRCEL) CPOS(79,4.5)  CLEN(13) CTYPE(2) BGND(13) 

    TYPE(DBrowse) FPOS(.2,6) SIZE(98.8,9) FILE(PRIKUHITw)                       ;
                                         FIELDS( FIN_PRIKUHHD_BC(31)::2.6::2  , ;
                                                 nCISFAK:èíslo Faktury        , ;
                                                 cVARSYM:varSymbol            , ; 
                                                 cNAZEV:dodavatel-odbìratel:32, ;
                                                 dSPLATFAK:datSplatn:10       , ; 
                                                 nPRIUHRCEL:èástka Úhrady     , ;
                                                 duhrbandne:datÚhrady:10        ) ;
                                         CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemMarked) POPUPMENU(n)
  TYPE(END) 

* neviditelné omocné položky
TYPE(TEXT) NAME(prikuhitw->ncisfak_or) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->cobdobi)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->nrok)       FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->nobdobi)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->cdenik)     FPOS(0,0) CLEN(0)

