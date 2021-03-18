TYPE(drgForm) DTYPE(10) TITLE(Seznam bankovních úètù ...) SIZE(80,25) FILE(PRIKUHITw) ;
              POST(PostValidate) GUILOOK(IconBar:n,Menu:n,Action:n,Message:n) 

TYPE(TabPage) CAPTION(Pøíjemce) OFFSET(0,84)

* príjemce - v INS z FAKPRIHD
  TYPE(Static) SIZE(78,6) FPOS(1,.5) RESIZE(y) CAPTION(Pøíjemce)

    TYPE(GET)    NAME(PRIKUHITw->cNazev)     FPOS(11,1) FLEN(40) PP(2) FCAPTION(Pøíjemce)   CPOS(1,1) 
    TYPE(STATIC)                             FPOS(53,1) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->cULICE)       FPOS(11,2) FLEN(40) PP(2) FCAPTION(Adresa)     CPOS(1,2)
    TYPE(STATIC)                             FPOS(53,2) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->CPSC)         FPOS(11,3) FLEN( 8) PP(2)                               
    TYPE(GET)  NAME(PRIKUHITw->CSIDLO)       FPOS(21,3) FLEN(30) PP(2)
    TYPE(STATIC)                             FPOS(53,3) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->CZKRATSTAT)   FPOS(11,4) FLEN( 8) PP(2)
    TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT)     CPOS(21,4) CLEN(31) BGND(13)
    TYPE(STATIC)                             FPOS(53,4) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->cDIC)         FPOS(11,5) FLEN(40) FCAPTION(Diè)        CPOS(1,5) CLEN(10)
  TYPE(End)

* identifikace - v INS z FAKPRIHD
  TYPE(Static) SIZE(78,3) FPOS(1,8.2) RESIZE(y) CAPTION(Ve prospìch úètu)
    TYPE(GET)  NAME(PRIKUHITw->cUCET)        FPOS(11,1) FLEN(40) PP(2) FCAPTION(Èíslo úètu) CPOS(1,1)
    TYPE(STATIC)                             FPOS(53,1) SIZE(16,16) STYPE(3) CAPTION(425)

* FIRMYUC    
    TYPE(GET)  NAME(PRIKUHITw->cIBAN)        FPOS(11,2) FLEN(40) PP(2) FCAPTION(IBAN)       CPOS(1,2)
    TYPE(STATIC)                             FPOS(53,2) SIZE(16,16) STYPE(3) CAPTION(425)

  TYPE(End)

* banka pøíjemce
  TYPE(Static) SIZE(78,6) FPOS(1,12.2) RESIZE(y) CAPTION(Banka pøíjemce)

    TYPE(GET)  NAME(PRIKUHITw->cBIC)         FPOS(11,1) FLEN(40) PP(2) FCAPTION(SWIFT /BIC)     CPOS(1,1)
    TYPE(STATIC)                             FPOS(53,1) SIZE(16,16) STYPE(3) CAPTION(425)
 
    TYPE(GET)  NAME(PRIKUHITw->cBANK_NAZ)    FPOS(11,2) FLEN(40) PP(2) FCAPTION(Název banky)    CPOS(1,2) CLEN(10)
    TYPE(STATIC)                             FPOS(53,2) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->CBANK_ULI)    FPOS(11,3) FLEN(40) PP(2) FCAPTION(Adresa)         CPOS(1,3) 
    TYPE(STATIC)                             FPOS(53,3) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(Get)  NAME(PRIKUHITw->CBANK_PSC)    FPOS(11,4) FLEN( 8) PP(2)                                   
    TYPE(Get)  NAME(PRIKUHITw->CBANK_SID)    FPOS(21,4) FLEN(30) PP(2)
    TYPE(STATIC)                             FPOS(53,4) SIZE(16,16) STYPE(3) CAPTION(425)

    TYPE(GET)  NAME(PRIKUHITw->cBANK_STA)    FPOS(11,5) FLEN( 8) PP(2) FCAPTION(Kód zemì)       CPOS(1,5) 
    TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT)     CPOS(21,5) CLEN(31) BGND(13)
    TYPE(STATIC)                             FPOS(53,5) SIZE(16,16) STYPE(3) CAPTION(425)
  TYPE(End)

* poplatky
  TYPE(Static) SIZE(78,4) FPOS(1,19.2) RESIZE(y) CAPTION(Poplatky)

    TYPE(ComboBox) NAME(PRIKUHITw->cPOPLATUHR)        FPOS(11,1) FLEN(41) FCAPTION(Zpùsob)     CPOS(1,1) ;
                   VALUES(SHA:SHA - poplatky požadované bankou plátce hradí plátce, ;
                          BEN:BEN - všechny poplatky hradí pøíjemce               , ;
                          OUR:OUR - všechny poplatky hradí plátce                   ) 
    TYPE(GET)  NAME(PRIKUHITw->cPOPLATUCT)  FPOS(11,2) FLEN(40) PP(2) FCAPTION(Úèet)       CPOS(1,2)
*   úèet a mìna poplatku czkratMenP
  TYPE(End)
TYPE(End)


TYPE(TabPage) CAPTION(Zprávy) OFFSET(14,70)

* zprávy pro plátce
  TYPE(Static) SIZE(78,5) FPOS(1,.5) RESIZE(y) CAPTION(Plátce)
    TYPE(GET)  NAME(PRIKUHITw->cPopis1Plt)       FPOS(1,1) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPopis2Plt)       FPOS(1,2) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPopis3Plt)       FPOS(1,3) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPopis4Plt)       FPOS(1,4) FLEN(74)
  TYPE(End)

* zprávy pro pøíjemce
  TYPE(Static) SIZE(78,5) FPOS(1,7.0) RESIZE(y) CAPTION(Pøíjemce)

    TYPE(GET)  NAME(PRIKUHITw->cPOPIS1uhr)       FPOS(1,1) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPOPIS2uhr)       FPOS(1,2) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPOPIS3uhr)       FPOS(1,3) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPOPIS4uhr)       FPOS(1,4) FLEN(74)
  TYPE(End)
  
* zprávy pro banku
  TYPE(Static) SIZE(78,4) FPOS(1,13.5) RESIZE(y) CAPTION(Banka)
    TYPE(GET)  NAME(PRIKUHITw->cPopis1Ban)       FPOS(1,1) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPopis2Ban)       FPOS(1,2) FLEN(74)
    TYPE(GET)  NAME(PRIKUHITw->cPopis3Ban)       FPOS(1,3) FLEN(74)
  TYPE(End)


  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


TYPE(TabPage) CAPTION(Oznámení) OFFSET(28,54)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(prikuhitw->sid) FPOS(0,0) CLEN(0)
