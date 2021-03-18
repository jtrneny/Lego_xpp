TYPE(drgForm) DTYPE(20w) TITLE(Aktualizace osoby) SIZE(100,20.5) ;
              GUILOOK(Action:n,Border:y) ;
              PRE(preValidate) POST(postValidate) CBSAVE(onSave)

  TYPE(Static) STYPE(12) FPOS(0.5,0.3) SIZE(99,4.4)  RESIZE(y) CTYPE(3)
    TYPE(TEXT) CAPTION(Titul pøed)       CPOS( 1,0.6) CLEN(15)
    TYPE(TEXT) CAPTION(Jméno)            CPOS(18,0.6) CLEN(20)
    TYPE(TEXT) CAPTION(Pøíjmení)         CPOS(50,0.6) CLEN(20)
    TYPE(TEXT) CAPTION(Titul za)         CPOS(82,0.6) CLEN(15)

    TYPE(GET) NAME(OSOBYw->CTITULPRED)   FPOS( 1,2.0) FLEN(15)
    TYPE(GET) NAME(OSOBYw->CJMENOOSOB)   FPOS(18,2.0) FLEN(30)
    TYPE(GET) NAME(OSOBYw->CPRIJOSOB)    FPOS(50,2.0) FLEN(30)
    TYPE(GET) NAME(OSOBYw->CTITULZA)     FPOS(82,2.0) FLEN(15)
  TYPE(End)


* Základní údaje
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET( 1,86) CAPTION(Základní údaje)
    TYPE(Text) CAPTION(Adresa)           CPOS( 1, 0.8) CLEN(20) FONT(5)
     TYPE(GET) NAME(OSOBYw->CULICE)     FPOS(15, 2) FLEN(30) FCAPTION(Ulice/è.popisné) CPOS(2,2)
     TYPE(GET) NAME(OSOBYw->CCISPOPIS)  FPOS(48, 2) FLEN(15)
     TYPE(GET) NAME(OSOBYw->CMISTO)     FPOS(15, 3) FLEN(30) FCAPTION(Místo)         CPOS(2,3)
     TYPE(GET) NAME(OSOBYw->CPSC)       FPOS(15, 4) FLEN( 8) FCAPTION(PSÈ)           CPOS(2,4)
    TYPE(TEXT) NAME(C_PSC->CMISTO)       CPOS(25,4) CLEN(21) BGND(13)
     TYPE(GET) NAME(OSOBYw->CZKRATSTAT) FPOS(15, 5) FLEN( 8) FCAPTION(Stát)          CPOS(2,5)
    TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT) CPOS(25,5) CLEN(21) BGND(13)
  TYPE(End)

* SPOJENÍ
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET(14,72) CAPTION(Spojení)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(98.0,14) FILE(SPOJENIw)                           ;
                                FIELDS( nItem:Poø:4:999::GET                           ; 
                                       ,lHlaSpoj:Hl:1:::GET                            ;
                                       ,cZkrSpoj:Zkratka:8:::GET                       ;
                                       ,cNazSpoj:Název:25:::GET                        ;
                                       ,cAdrElSpoj:Adresa-èíslo:25:::GET               ;
                                       ,mAdrPoSpoj:Poštovní adresa:25:::GET)           ;
                           ITEMMARKED 'itemMarked' CURSORMODE(3) PP(7) SCROLL(yy)
  TYPE(End)


* FIRMY
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET(28,58) CAPTION(Firmy)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(98.0,14) FILE(VAZFIRMYw)                         ;
                            FIELDS(nItem:Poø:4:999::GET                               ;
                                  ,nCisFirmy:Èíslo firmy::::GET:PUSH(selFirma)       ;
                                  ,Firmy->cNazev:Název firmy                          ;
                                  ,cFunPra:Funkce pracocníka::::GET                   ;
                                  ,C_FUNCPR->cNazFuncPr:Název funkce)                 ;
                            CURSORMODE(3) PP(7) SCROLL(yy)
  TYPE(End)


  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET(42,44) CAPTION(Úkoly)
    TYPE(MLE) NAME(OSOBYw->mPOZNAMKA) FPOS(.5,0.15) SIZE(97,7.8) FONT(5) SCROLL(nn) PP(3)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET(56,30) CAPTION(Dokumenty)
    TYPE(EBrowse) FPOS(0.5,0.1) SIZE(98.0,14) FILE(DOKUMENTw)                         ;
                            FIELDS(nItem:Poø:4:999::GET                               ;
                                  ,nCisDokum:Èíslo dokumentu::::GET:PUSH(selFirma)       ;
                                  ,Dokument->cNazev:Název firmy                          ;
                                  ,C_FUNCPR->cNazFuncPr:Název funkce)                 ;
                            CURSORMODE(3) PP(7) SCROLL(yy)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) FPOS(0.5,4.8) SIZE(99,15.5) TTYPE(3) OFFSET(70,16) CAPTION(Poznámka)
    TYPE(MLE) NAME(OSOBYw->mPOZNAMKA) FPOS(.5,0.15) SIZE(97,7.8) FONT(5) SCROLL(nn) PP(3)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

TYPE(End)