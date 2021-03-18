TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava pøíkazu k úhradì ...) SIZE(105,26) FILE (PRIKUHHDw)            ;
                                                                                 GUILOOK(Action:n,IconBar:y) ;
                                                                                 POST(postValidate)

  TYPE(STATIC) FPOS(0.4,0.2) SIZE(104.0,6) STYPE(13) CTYPE(2) RESIZE( y,x) 

* 1
    TYPE(ComboBox) NAME(PRIKUHHDw->cTYPPOHYBU) FPOS( 2,0.4) FLEN(38) VALUES(a,a,a) ITEMSELECTED(comboItemSelected) ;
                                                                                   ITEMMARKED(comboItemSelected)   ;
                                                                                   NOREVISION()      
    TYPE(TEXT)     NAME(M->obdobi_fin_mzd)     CLEN(9) CPOS( 43,0.4)                                             
    TYPE(COMBOBOX) NAME(PRIKUHHDw->COBDOBI)    FPOS(53,0.4) FLEN(10) VALUES(a,a,a,a) 

                                     
    TYPE(STATIC) FPOS(2,2.6) SIZE(38,2.5) CTYPE(2) RESIZE(x,n)
      TYPE(TEXT) NAME(PRIKUHHDw->cBANK_NAZ)  CPOS( 0.3,0.3) CLEN(18) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_DARKBLUE) 
      TYPE(TEXT) NAME(PRIKUHHDw->cBANK_ULI)  CPOS( 0.3,1.1) CLEN(18) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_DARKBLUE) 
      TYPE(TEXT) NAME(PRIKUHHDw->cBANK_SID)  CPOS( 0.3,1.9) CLEN(18) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_DARKBLUE) 
         
      TYPE(TEXT) CAPTION(IBAN:)              CPOS( 18.5,0.3) CLEN( 5) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_BLACK) 
      TYPE(TEXT) NAME(PRIKUHHDw->cIBAN)      CPOS( 18.5,1.1) CLEN(26) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_BLACK) 
      TYPE(TEXT) CAPTION(SWIFT/BIC:)         CPOS( 18.5,1.9) CLEN( 9) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_BLACK) 
      TYPE(TEXT) NAME(PRIKUHHDw->cBIC)       CPOS( 27.5,1.9) CLEN(10) GROUPS(BAU,SETFONT,7.Arial CE,GRA_CLR_BLACK) 
    TYPE(END)

* 2
    TYPE(GET)  NAME(PRIKUHHDw->cBANK_UCT)  FPOS(  9,1.7) FLEN(30) PP(2) FCAPTION(z úètu) PP(1) CPOS(2,1.7) CLEN(6) FONT(5) PUSH(FIN_C_BANKUC_SEL) NOREVISION()
    TYPE(TEXT) CAPTION(Doklad è.)          CPOS( 43,1.7) CLEN(10) 
    TYPE(TEXT) NAME(PRIKUHHDw->nDOKLAD)    CPOS( 53,1.7) CLEN(18) CTYPE(2) BGND(13) 
    TYPE(TEXT) CAPTION(Stav úètu)          CPOS( 74,1.7) CLEN(10) FONT(5)
    TYPE(TEXT) NAME(C_BANKUC->nPOSZUST)    CPOS( 84,1.7) CLEN(13) CTYPE(2) BGND(13)
    TYPE(TEXT) NAME(C_BANKUC->cZKRATMENY)  CPOS( 99,1.7) CLEN( 5) FONT(5)

* 3
    TYPE(Get)  NAME(PRIKUHHDw->dPRIKUHR)   FPOS( 53,2.8) FLEN(17) PP(2) FCAPTION(Uhradit dne)  CPOS(43,2.8) CLEN(10) PP(1) PUSH(CLICKDATE) 

* 4
    TYPE(ComboBox) NAME(PRIKUHHDw->CZKRATMENU)  FPOS(53,3.8) FLEN(18) FCAPTION(Mìna úhrady) CPOS(43,3.8) CLEN(10) PP(1) ;
                                                VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate) NOREVISION()
    TYPE(TEXT) CAPTION(Uhradit)            CPOS(74,3.8) CLEN(10) FONT(5)
    TYPE(TEXT) NAME(PRIKUHHDw->nCENZAKCEL) CPOS(84,3.8) CLEN(13) CTYPE(2) BGND(13)
    TYPE(TEXT) NAME(PRIKUHHDw->cZkratMenU) CPOS(99,3.8) CLEN( 5) FONT(5)

* 5
    TYPE(Get)  NAME(PRIKUHHDw->nKurZahMen) FPOS( 53,4.8) FLEN(10) PP(2) FCAPTION(Kurz)  PP(1)  CPOS(43,4.8) CLEN(10) NOREVISION() 
    TYPE(Get)  NAME(PRIKUHHDw->nMnozPrep)  FPOS( 66,4.8) FLEN( 4) PP(2) FCAPTION(/)     PP(1)  CPOS(64,4.8) CLEN( 2) NOREVISION() 
  TYPE(End)

* IT
* o_ucet_info - o_nazev_info - o_bank_Naz_info
* pro tuzPøíkaz    0 - nic nekontroluje 
* pry zahPøíkaz  101 - OK 170 - Err

  TYPE(STATIC) FPOS(0.4,6.5) SIZE(104.3,8.4) STYPE(12)  CTYPE(1) 

    TYPE(TEXT) CAPTION(typPøíkazu)         CPOS( 1  ,0) CLEN( 9)
    TYPE(TEXT) NAME(M->prikuhit_fp_mz)     CPOS(11.6,0) CLEN(13)
    TYPE(TEXT) CAPTION(textPoložky)        CPOS(28.5,0)
    TYPE(TEXT) CAPTION(uhradit dne)        CPOS(55.5,0) CLEN(10)
    TYPE(TEXT) CAPTION(ve prospìch úètu)   CPOS(70  ,0) CLEN(15)

      TYPE(TEXT) CAPTION([)                 CPOS( 89, 0)  CLEN(2) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_DARKBLUE) 
      TYPE(TEXT) NAME(PRIKUHITw->ncisFirmy) CPOS( 90, 0)  CLEN(8) PICTURE(@99999) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_RED) 
      TYPE(TEXT) CAPTION(])                 CPOS( 99, 0)  CLEN(2) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_DARKBLUE) 

    TYPE(CHECKBOX) NAME(M->UHR_zavazku) FPOS(1, 1.0) FLEN(10) VALUES(T:závazek,F:obecný) 
  
    TYPE(GET)  NAME(PRIKUHITw->nCISFAK)    FPOS(11.5, 1.0) FLEN(15)  PUSH(FIN_prikuhit_fp_SEL)
    TYPE(GET)  NAME(PRIKUHITw->ctextPol)   FPOS(28.5, 1.0) FLEN(25) 
    TYPE(GET)  NAME(PRIKUHITw->dUHRBANDNE) FPOS(55.5, 1.0) FLEN(11)  PUSH(CLICKDATE)
    TYPE(GET)  NAME(PRIKUHITw->cUCET)      FPOS(70  , 1.0) FLEN(30)  PUSH(fir_firmyUc_prik_sel)
      TYPE(STATIC)                         FPOS(101.5,1) SIZE(16,16) STYPE(3) CAPTION(0) GROUPS(o_ucet_info)


* SYMBOLY
    TYPE(GET) NAME(PRIKUHITw->cVARSYM)     FPOS(11.5,3.0) FLEN(15)  FCAPTION(V_Sym) CPOS(12,2.0) CLEN(6)
    TYPE(GET) NAME(PRIKUHITw->nKONSTSYMB)  FPOS(28.5,3.0) FLEN( 9)  FCAPTION(K_Sym) CPOS(31,2.0) CLEN(6)
    TYPE(GET) NAME(PRIKUHITw->cSPECSYMB)   FPOS(42,3.0)   FLEN(25)  FCAPTION(S_Sym) CPOS(42,2.0) CLEN(6)

    TYPE(STATIC) FPOS(10.6,2.6) SIZE(57.4,.1) STYPE(13)
    TYPE(End)

    TYPE(STATIC) FPOS(70,2.6) SIZE(32,4.5) STYPE(12)
      TYPE(TEXT) CAPTION(uhradit v -)         CPOS(  .5, .2) CLEN( 9) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_RED) 
      TYPE(TEXT) CAPTION(zbývá k úhradì -)    CPOS(  .5,2.2) CLEN(15) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_RED) 

      TYPE(TEXT) NAME(PRIKUHITw->czkratMenZ)  CPOS( 10, .2)  CLEN(4) FONT(5) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_DARKBLUE) 
      TYPE(GET)  NAME(PRIKUHITw->nPRIUHRCEL)  FPOS(  3,1.2)  FLEN(12) FONT(5)
      TYPE(Text) NAME(M->prikuhit_fp_zby_fak) CPOS(  3,3.2)  CLEN(13) CTYPE(2) BGND(13) PICTURE(@N 9999999999.99)

      TYPE(TEXT) NAME(PRIKUHITw->czkratMenU)  CPOS( 25, .2)  CLEN(4) FONT(5) GROUPS(BAU,SETFONT,8.Arial CE,GRA_CLR_DARKBLUE)     
      TYPE(GET)  NAME(PRIKUHITw->nPRIUHRPRI)  FPOS( 17,1.2)  FLEN(12) 
      TYPE(Text) NAME(M->prikuhit_fp_zby)     CPOS( 17,3.2)  CLEN(13) CTYPE(2) BGND(13) PICTURE(@N 9999999999.99)
    TYPE(End)


    TYPE(STATIC) FPOS(0.5,4.5) SIZE(67.6,.1) STYPE(13)
    TYPE(End)

    TYPE(TEXT) CAPTION( Pøíjemce)           CPOS(.5,5) CLEN(10)       FONT(5)
     TYPE(GET) NAME(PRIKUHITw->cNazev)        FPOS(11.5, 5.0) FLEN(26)  PUSH(prikuhhd_in_pzo)
       TYPE(STATIC)                           FPOS(38.5,5  ) SIZE(16,16) STYPE(3) CAPTION(0) GROUPS(o_nazev_info)

    TYPE(TEXT) CAPTION( Název banky)          CPOS(.5,6.1) CLEN(11.3)      FONT(5)
     TYPE(GET) NAME(PRIKUHITw->cBank_Naz)     FPOS(11.5, 6.1) FLEN(26) PUSH(prikuhhd_in_pzo)
     TYPE(STATIC)                             FPOS(38.5,6.1) SIZE(16,16) STYPE(3) CAPTION(0) GROUPS(o_bank_Naz_info)


    TYPE(TEXT) CAPTION( Typ platby)         CPOS(42,5.0) CLEN(10)     
    TYPE(ComboBox) NAME(PRIKUHITw->cTYPplatby)       FPOS( 52.5,5.0) FLEN(15) VALUES(0:dávka,        ;
                                                                                    1:online)        
                                                     
    TYPE(TEXT) CAPTION( Priorita)           CPOS(42,6.1) CLEN(10)     
    TYPE(ComboBox) NAME(PRIKUHITw->nPrioriUHR)      FPOS( 52.5,6.1) FLEN(15) VALUES(0:standard,        ;
                                                                                    1:expres)        
        
  TYPE(END) 

    TYPE(DBrowse) FPOS(.1,15.3) SIZE(103.8,10.8) FILE(PRIKUHITw)                                 ;
                                         FIELDS( FIN_PRIKUHHD_BC(31)::2.6::2                   , ;
                                                 M->prikuhit_state_PZO::3::1                   , ;
                                                 nCISFAK:èíslo Faktury                         , ;
                                                 cVARSYM:varSymbol                             , ; 
                                                 cTextPol:text položky (dodavatel-odbìratel):35, ;
                                                 dSPLATFAK:datSplatn:10                        , ; 
                                                 nPRIUHRCEL:èástka Úhrady                      , ;
                                                 duhrbandne:datÚhrady:10                         ) ;
                                         CURSORMODE(3) PP(6) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemMarked) POPUPMENU(n)

* neviditelné omocné položky
TYPE(TEXT) NAME(prikuhitw->ncisfak_or) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->cobdobi)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->nrok)       FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->nobdobi)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(prikuhitw->cdenik)     FPOS(0,0) CLEN(0)

