TYPE(drgForm) DTYPE(10) TITLE(Osobní údaje zamìstnance ...(personalistika) ...) SIZE(100,24) ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) POST(postValidate)


  TYPE(Static) STYPE(13) SIZE(98,4.2) FPOS(1,0.2) RESIZE(yn)

* 1. øádek
    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, .15) CLEN(10)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, .15) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, .15) CLEN(15)

    TYPE(GET)  NAME(osobyW->cprijOsob)   FPOS( 1,1.13) FLEN(25) NOREVISION()  FONT(5) PUSH(per_osoby_toPer_sel)
    TYPE(GET)  NAME(osobyW->cjmenoOsob)  FPOS(28,1.13) FLEN(15) NOREVISION()  FONT(5)  
    TYPE(GET)  NAME(osobyW->crozlJmena)  FPOS(45,1.13) FLEN(15) NOREVISION()  FONT(5) 
    TYPE(GET)  NAME(osobyW->ctitulPred)  FPOS(62,1.13) FLEN(15)
    TYPE(GET)  NAME(osobyW->ctitulZa)    FPOS(81,1.13) FLEN(15)

* èíslo osoby
*    TYPE(Text)  CAPTION([)                  CPOS( 8,2.05)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
*    TYPE(Text)  NAME(msPrc_mo->ncisOsoby)   CPOS( 9,2.048) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
*    TYPE(Text)  CAPTION(])                  CPOS(16,2.05)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

* 2. øádek
     TYPE(TEXT) NAME(osobyW->ncisOsoby)      CPOS( 1, 2.5) CLEN( 7) BGND(13) 
     TYPE(TEXT) CAPTION(èísloPrac)           CPOS(10, 2.5) CLEN( 9)  
     TYPE(TEXT) NAME(osobyW->noscisPrac)     CPOS(19, 2.5) CLEN( 8) BGND(13) FONT(5)

    TYPE(TEXT) FCAPTION(rodné Èíslo)        CPOS(62,2.83) CLEN(15)
     TYPE(GET)  NAME(osobyW->crodCisOsb)  FPOS(78,2.83) FLEN(15) PP(2) FONT(5)
  TYPE(End)


* 1 -  osobní (E) osobyW
TYPE(TabPage) TTYPE(4) CAPTION(Osobní) OFFSET(1,85) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 
  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yy)
    TYPE(TEXT) CAPTION(Rodné jméno. . . .)           CPOS( 1, 0.40)    CLEN(17)
      TYPE(GET) NAME(osobyW->cJmenoRod)               FPOS(19, 0.30)    FLEN(29)
    TYPE(TEXT) CAPTION(Datum narození. . . .)         CPOS( 1, 1.45)    CLEN(17)
      TYPE(GET) NAME(osobyW->dDatNaroz)               FPOS(19, 1.35)    FLEN(10.7)  PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(Místo narození. . .)           CPOS( 1, 2.50)    CLEN(17)
      TYPE(GET) NAME(osobyW->cMistoNar)               FPOS(19, 2.40)    FLEN(29)
    TYPE(TEXT) CAPTION(Stát narození. . . .)          CPOS( 1, 3.55)    CLEN(17)
      TYPE(GET) NAME(osobyW->cZkrStatNa)              FPOS(19, 3.45)    FLEN( 5)
      TYPE(TEXT) NAME(c_statyNar->cnazevStat)         CPOS(25.5,3.45)   CLEN(23.6) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Národnost . . . . .)           CPOS( 1, 4.60)    CLEN(17)
      TYPE(GET) NAME(osobyW->cZkratNar)               FPOS(19, 4.50)    FLEN(29)
    TYPE(TEXT) CAPTION(Státní pøíslušnost . . .)      CPOS( 1, 5.65)    CLEN(17)
      TYPE(GET) NAME(osobyW->cZkrStaPri)              FPOS(19, 5.55)    FLEN(29)
    TYPE(TEXT) CAPTION(Rodinný stav . . .)            CPOS( 1, 6.70)    CLEN(17)
      TYPE(GET) NAME(osobyW->cZkrRodStv)              FPOS(19, 6.60)    FLEN(11)
      TYPE(TEXT) NAME(C_RODSTA->cNazRodStv)           CPOS(31.5,6.60)   CLEN(17.6) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)     CPOS( 1, 7.75)    CLEN(17)
      TYPE(GET) NAME(osobyW->cZkrVzdel)               FPOS(19, 7.65)    FLEN(11)
      TYPE(TEXT) NAME(C_VZDEL->cNazVzdela)            CPOS(31.5,7.65)   CLEN(17.6) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Individuální KZAM. .)          CPOS( 1, 8.80)    CLEN(17)
      TYPE(GET) NAME(osobyW->nKlasZam)                FPOS(19, 8.70)    FLEN(8)
      TYPE(TEXT) NAME(C_KLAZAM->cNazKlasZa)           CPOS(28.5,8.70)  CLEN(20.6) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Ident.èís.osobní karty)        CPOS( 1, 10.90)   CLEN(17)
      TYPE(GET) NAME(osobyW->cIdOsKarty)              FPOS(19,10.80)    FLEN(29)
    TYPE(TEXT) CAPTION(Celkový poèet let praxe)       CPOS( 1, 11.95)  CLEN(17)
      TYPE(GET) NAME(osobyW->nPocLPraxe)              FPOS(19,11.85)   FLEN(5)
    TYPE(TEXT) CAPTION(Evidovat DIM u pracovníka)     CPOS( 1,12.90)   CLEN(17)
      TYPE(COMBOBOX) NAME(osobyW->lEvidDIM)           FPOS(19,12.80)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 
    TYPE(TEXT) CAPTION(Vedoucí pracovník)             CPOS( 1,13.95)   CLEN(17)
      TYPE(COMBOBOX) NAME(osobyW->lVedPrac)           FPOS(19,13.85)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 

    TYPE(TEXT) CAPTION(Bydlištì ulice. . )            CPOS(50, 0.40)    CLEN(15) FONT(5)
      TYPE(GET)   NAME(osobyW->cUlice)                FPOS(66, 0.30)    FLEN(28)
    TYPE(TEXT) CAPTION(Èíslo popisné. .)              CPOS(56, 1.45)    CLEN(10)
      TYPE(GET)   NAME(osobyW->cCisPopis)             FPOS(66, 1.35)    FLEN(10)
    TYPE(TEXT) CAPTION(Psè. . . .)                    CPOS(56, 2.50)    CLEN(10)
      TYPE(GET)  NAME(osobyW->cPsc)                   FPOS(66, 2.40)    FLEN(8)
      TYPE(TEXT) NAME(c_psc->cmisto)                  CPOS(75.5,2.40)   CLEN(19.5) BGND(13)  PP(3)
    TYPE(TEXT)  CAPTION(Místo . . . . )               CPOS(56, 3.55)    CLEN(10)
      TYPE(GET)  NAME(osobyW->cMisto)                 FPOS(66, 3.45)    FLEN(28)
    TYPE(TEXT) CAPTION(Stát . . )                     CPOS(56, 4.60)    CLEN(10)
      TYPE(GET)  NAME(osobyW->cZkratStat)             FPOS(66.0, 4.50)  FLEN( 5)
      TYPE(TEXT) NAME(c_staty->cnazevStat)            CPOS(72.5,4.50)   CLEN(22.5) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Pøe.bydl ulice. . )            CPOS(50, 6.70)   CLEN(15) FOMT(5)
      TYPE(GET) NAME(osobyW->cPreUlice)               FPOS(66, 6.60)   FLEN(28)
    TYPE(TEXT) CAPTION(Èíslo popisné. .)              CPOS(56, 7.75)   CLEN(10)
      TYPE(GET) NAME(osobyW->cPreCisPop)              FPOS(66, 7.65)   FLEN(10)
    TYPE(TEXT) CAPTION(Psè . . . .)                   CPOS(56, 8.80)   CLEN(10)
      TYPE(GET) NAME(osobyW->cPrePsc)                 FPOS(66, 8.70)   FLEN( 8)
      TYPE(TEXT) NAME(c_pscPre->cmisto)               CPOS(75.5,8.70)   CLEN(19.5) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Místo . . . . )                CPOS(56, 9.85)   CLEN(10)
      TYPE(GET) NAME(osobyW->cPreMisto)               FPOS(66, 9.75)   FLEN(28)
    TYPE(TEXT) CAPTION(Stát . . )                     CPOS(56,10.90)   CLEN(10)
      TYPE(GET) NAME(osobyW->cZkrStatPr)              FPOS(66,10.80)   FLEN( 5)
      TYPE(TEXT) NAME(c_statyPre->cnazevStat)         CPOS(72.5,10.80) CLEN(22.5) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Telefon privát. . . .)         CPOS(50,13.00)   CLEN(15)
      TYPE(GET) NAME(osobyW->cTelPriv)                FPOS(66,12.90)   FLEN(28)
    TYPE(TEXT) CAPTION(Telefon zamìstnání. .)         CPOS(50,14.05)   CLEN(15)
      TYPE(GET) NAME(osobyW->cTelZames)               FPOS(66,13.95)   FLEN(28)
    TYPE(TEXT) CAPTION(Telefon mobil. . . .)          CPOS(50,15.10)   CLEN(15)
      TYPE(GET) NAME(osobyW->cTelMobil)               FPOS(66,15.00)   FLEN(28)
    TYPE(TEXT) CAPTION(E-mailová adresa. . .)         CPOS(50,16.15)   CLEN(15)
      TYPE(GET) NAME(osobyW->cEmail)                  FPOS(66,16.05)   FLEN(28)

    TYPE(STATIC) STYPE(16) FPOS( 1, 9.35) SIZE(48,1)
    TYPE(STATIC) STYPE(16) FPOS(50, 5.15) SIZE(47,1)
    TYPE(STATIC) STYPE(16) FPOS(50,11.35) SIZE(47,1)
  TYPE(End)
TYPE(End)


* 2 - rodinní pøíslušníci  --> OSOBY -> VAZOSOBY 
TYPE(TabPage) TTYPE(4) CAPTION(rodPøíslušníci) OFFSET(14,72) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

   TYPE(DBrowse) FPOS(.5,.5) SIZE(50,18) FILE(vazOsobyW)                             ;
                             FIELDS( vazOsobyW->ncisOsoby:èíslOsoby                , ;
                                     vazOsobyW->cjmenoRozl:Pøímení a jméno osoby:30, ;
                                     vazOsobyW->ctypRodPri:typVztahu               , ;
                                     vazOsobyW->cjmenoOsob:rozen(á)                , ;
                                     vazOsobyW->crodCisOsb:rodÈíslo                , ;
                                     vazOsobyW->ddatNaroz:datNaroz                 , ;   
                                     vazOsobyW->CMISTO:Mìsto:25                    , ;
                                     vazOsobyW->CZKRATSTAT:Stát                      ) ;
                             CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(2) RESIZE(yy)


   TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)
  
      TYPE(TEXT) CAPTION(Èíslo osoby )                CPOS( 1,  .5)
        TYPE(GET)  NAME(vazOsobyW->ncisOsoby)         FPOS(18,  .5) FLEN(12) PUSH(per_osoby_sel) NOREVISION()
        TYPE(PushButton)                              POS( 31,  .5) ;
                                                      SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                      CAPTION(2)

        TYPE(TEXT) NAME(osoby_Rp->cjmenoRozl)         CPOS( 2, 2  ) CTYPE(1) BGND(12) FONT(5)

      TYPE(TEXT) CAPTION(rozen(á))                    CPOS( 1, 3) CLEN( 7)
        TYPE(TEXT) NAME(osoby_Rp->cjmenoOsob)         CPOS(18, 3)          FONT(5)

      TYPE(TEXT) CAPTION(Datum narození )             CPOS( 1, 4)
        TYPE(GET) NAME(vazOsobyW->ddatNaroz)          FPOS(18 ,4) FLEN(13) PP(2) FONT(5) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Rodné èíslo)                 CPOS( 1, 5)
        TYPE(GET) NAME(vazOsobyW->crodCisOsb)         FPOS(18, 5) FLEN(15) PP(2) FONT(5)
 
      TYPE(TEXT) CAPTION(Typ vztahu)                  CPOS( 1, 6) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->ctypRodPri)    FPOS(18, 6) FLEN(25)  REF(ctypRodPri)

      TYPE(TEXT) CAPTION(Ulatnit slevu)               CPOS( 1, 7) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->lsleOdpDan)    FPOS(18, 7) FLEN( 7)  REF( LYESNO) 

* 1 - základní údaje pro rodinné pøíslušníky
      TYPE(Static) FPOS(0.5,8.5) SIZE(45.7,6.5) CAPTION(Základní údaje) RESIZE(xx)
        TYPE(Text) CAPTION(Adresa)            CPOS( 1, 0.8) CLEN(20) FONT(5)

        TYPE(TEXT)   CAPTION(Ulice/è.popisné)         CPOS( 2, 2) CLEN(12)
          TYPE(TEXT) NAME(osoby_Rp->cUlicCiPop)       CPOS(15, 2) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)                   CPOS(2,3)
          TYPE(TEXT) NAME(osoby_Rp->cmisto)           CPOS(15, 3) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                     CPOS( 2, 4) CLEN(12)
          TYPE(TEXT) NAME(osoby_Rp->cpsc)             CPOS(15, 4) CLEN( 8) BGND(13) 
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)            CPOS(25, 4) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                    CPOS( 2, 5) 
          TYPE(TEXT) NAME(osoby_Rp->czkratStat)       CPOS(15, 5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)      CPOS(25, 5) CLEN(21) BGND(13)
      TYPE(End)
    TYPE(End)
TYPE(End)


* 3 dùchody      --> DUCHODY
TYPE(TabPage) TTYPE(4) CAPTION(Dùchody)        OFFSET(27,59) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

  TYPE(DBrowse) FPOS(0.5,0.5) SIZE(50,18) FILE(duchodyW)               ;
                              FIELDS( M->is_Aktiv:ad:2.6::2          , ;
                                      nporDuchod:poøadí              , ;
                                      ntypDuchod:typ dùchodu         , ;
                                      M->nazDuchod:název typu dùchodu, ;
                                      dpriznDuOd:pøiznán             , ; 
                                      dpriznDuDo:pøiznán DO            ) ;
                              CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(3)

  TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)
 
    TYPE(TEXT)  CAPTION(Typ dùchodu ...)         CPOS( 1, 1) CLEN(12) 
     TYPE(GET)  NAME(duchodyW->ntypDuchod)       FPOS(13, 1) FLEN( 7) NOREVISION()
*     TYPE(TEXT) CAPTION(/)                       CPOS(21, 1) CLEN( 2)
*     TYPE(TEXT) NAME(duchodyW->nporDuchod)       CPOS(22, 1) CLEN( 4) PICTURE(99)
     TYPE(TEXT) NAME(c_duchod->cnazDuchod)       CPOS(21, 1)

    TYPE(TEXT)  NAME(c_duchod->cnazDuchod)       CPOS( 2, 2.5) CTYPE(1) CLEN(48) BGND(12) GROUPS(SETFONT,11.Arial,GRA_CLR_BLUE)

    TYPE(TEXT)  CAPTION(Pøiznán _ od)            CPOS( 1, 4) CLEN(12)
     TYPE(GET)  NAME(duchodyW->dpriznDuOd)       FPOS(13, 4) FLEN(11) PUSH(CLICKDATE)
     TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 4) CLEN( 5)
     TYPE(GET)  NAME(duchodyW->dpriznDuDo)       FPOS(33, 4) FLEN(11) PUSH(CLICKDATE)

    TYPE(TEXT)  CAPTION(Nárok _ od)              CPOS( 1, 5) CLEN(12)
     TYPE(GET)  NAME(duchodyW->dnarDuchOd)       FPOS(13, 5) FLEN(11) PUSH(CLICKDATE)
     TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 5) CLEN( 5)
     TYPE(GET)  NAME(duchodyW->dnarDuchDo)       FPOS(33, 5) FLEN(12) PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Aktivní dùchod)           CPOS( 1, 6) CLEN(12)
      TYPE(COMBOBOX) NAME(duchodyW->lAktiv)      FPOS(13, 6) FLEN(12) REF( LYESNO) 

* 1 - základní údaje pro pøiznané dùchody
      TYPE(Static) FPOS(0.5,8.5) SIZE(45.7,6.5) CAPTION(vyplácející OSSZ) RESIZE(xx)
        TYPE(Text)  CAPTION(Firma  ... )          CPOS( 1, 1) CLEN(12) FONT(5)        
         TYPE(GET)  NAME(duchodyW->ncisFirmy)     FPOS(13, 1) FLEN( 7) 
         TYPE(TEXT) NAME(firmy->cnazev)           CPOS(21, 1)
           
        TYPE(TEXT)   CAPTION(Ulice/è.popisné)     CPOS( 2, 2.5) CLEN(12)
         TYPE(TEXT) NAME(firmy->cUlice)           CPOS(15, 2.5) CLEN(30) BGND(13) 
         TYPE(TEXT) NAME(firmy->cSidlo)           CPOS(15, 2.5) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)               CPOS( 2, 3.5)
         TYPE(TEXT) NAME(duchodyW->cnazev)        CPOS(15, 3.5) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 4.5) CLEN(12)
          TYPE(TEXT) NAME(firmy->cpsc)            CPOS(15, 4.5) FLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_PSC_3->CMISTO)        CPOS(25, 4.5) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 5.5) 
          TYPE(TEXT) NAME(firmy->czkratStat)      CPOS(15, 5.5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_3->cNAZEVSTAT)  CPOS(25, 5.5) CLEN(21) BGND(13)
      TYPE(End)
  TYPE(End)
TYPE(End)


* 4 pracovnì právní vztah --->PRSMLDOH
TYPE(TabPage) TTYPE(4) CAPTION(pracVztahy)     OFFSET(40,46)  FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

  TYPE(DBrowse) FPOS(0.5,0.5) SIZE(50,18) FILE(prSmlDohW)      ;
                              FIELDS( nporPraVzt:poøPv       , ;
                                      cdruPraVzt:druhPv:15   , ;
                                      cvznPraVzt:vnznikPv:15 , ;
                                      ntypPraVzt:typPv       , ;
                                      ntypZamVzt:typZamVzt   , ;
                                      ddatVznPrv:datZalPv:12 , ;
                                      ddatNast:datNást       , ;
                                      ntypUkoPrv:typUkonèPv  , ;
                                      ddatVyst:datUkoèPv       ) ; 
                               CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(4)

 TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)

   TYPE(TEXT)   FCAPTION(Osobní èíslo)                CPOS( 1,1) CLEN(12)
     TYPE(GET)  NAME(prsmlDohW->nosCisPrac)           FPOS(13,1) FLEN( 8) FONT(5) CTYPE(2) 
     TYPE(TEXT) FCAPTION(poøPpv)                      CPOS(24,1) CLEN( 6)
     TYPE(TEXT) NAME(prSmlDohW->nporPraVzt)           CPOS(32,.6) CLEN(10) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)

  TYPE(TEXT)  NAME(osobyW->cjmenoRozl)                CPOS( 2, 2.5) CTYPE(2) CLEN(55) BGND(12) GROUPS(SETFONT,11.Arial,GRA_CLR_BLUE)

  TYPE(TEXT) CAPTION(Druh PV. . . .)                      CPOS( 1, 4)  CLEN(12)
    TYPE(COMBOBOX) NAME(prSmlDohW->cdruPraVzt)            FPOS(13, 4)  FLEN(32) ;
        VALUES(HLAVNI:HLAVNÍ pracovní vztah             , +
               VEDLEJSI:VEDLEJŠÍ pracovní vztah         , +
               HLAVSOUB:SOUBÌŽNÝ HLAVNÍ pracovní vztah  , +
               VEDLSOUB:SOUBÌZNÝ VEDLEJŠÍ pracovní vztah, +
               NEPRACPO:Neexistuje vazba na prac.vztah    )

    TYPE(TEXT) CAPTION(Vznik PV. . . .)                   CPOS( 1, 5)  CLEN(12)
      TYPE(COMBOBOX) NAME(prSmlDohW->cvznPraVzt)          FPOS(13, 5)   FLEN(32) ;
            VALUES(PRAC.SML.:Pracovní smlouva       , ;
                  JMENOVANIM:Jmenováním do funkce   , ;
                      VOLBOU:Volbou do funkce       , ;
                     DOHODOU:Dohodou                , ;
                  NEVYTVOREN:Nevytvoøen               )


    TYPE(TEXT) CAPTION(Typ Pv)                        CPOS( 1, 7)   CLEN(12)
      TYPE(GET) NAME(prSmlDohW->nTypPraVzt)            FPOS(13, 7)   FLEN(5)
      TYPE(TEXT) NAME(C_PRACVZ->cNazPraVzt)           CPOS(20, 7)   CLEN(27) PP(3)

    TYPE(TEXT) CAPTION(Vznik Pv dne)                  CPOS( 1, 8)  CLEN(12)
      TYPE(GET) NAME(prSmlDohW->dDatVznPrV)            FPOS(13, 8)  FLEN(11)  PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Nástup dne)                    CPOS( 1, 9)   CLEN(12)
      TYPE(GET) NAME(prSmlDohW->ddatNast)              FPOS(13, 9)   FLEN(11)  PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Zamìstnan.vztah )              CPOS( 1, 10.5)   CLEN(12)
      TYPE(GET) NAME(prSmlDohW->nTypZamVzt )           FPOS(13, 10.5)   FLEN(8) 
      TYPE(TEXT) NAME(C_ZameVZ->cNazZamVzt)           CPOS(22.5, 10.5)   CLEN(27) PP(3)

    TYPE(TEXT) CAPTION(Pracovní zaøazení)             CPOS( 1, 11.5)   CLEN(12)
      TYPE(GET) NAME(prSmlDohW->cPracZar )             FPOS(13, 11.5)   FLEN(8) 
      TYPE(TEXT) NAME(C_pracza->cNazPracZa)           CPOS(22.5, 11.5)   CLEN(27) PP(3)

    TYPE(TEXT) CAPTION(Funkce pracovníka)             CPOS( 1, 12.5)   CLEN(12)
      TYPE(GET) NAME(prSmlDohW->cFunPra )             FPOS(13, 12.5)   FLEN(8) 
      TYPE(TEXT) NAME(C_funcpr->cNazFuncPr)           CPOS(22.5, 11.5)   CLEN(27) PP(3)


    TYPE(TEXT) CAPTION(PøedpUkonè   ...)              CPOS( 1,14)  CLEN(12)
      TYPE(GET)  NAME(prSmlDohW->dDatPredVy)          FPOS(13,14)  FLEN(11)  PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Typ ukonè PV ...)              CPOS( 1,15.5)  CLEN(12)
      TYPE(GET)  NAME(prSmlDohW->nTypUkoPrV)          FPOS(13,15.5)  FLEN(5)
      TYPE(TEXT) NAME(C_UKONPV->cNazUkoPrV)           CPOS(20,15.5)  CLEN(27) PP(3)

    TYPE(TEXT) CAPTION(Výstup dne      ...)           CPOS( 1,16.5)  CLEN(12)
      TYPE(GET) NAME(prSmlDohW->dDatVyst)             FPOS(13,16.5)  FLEN(11)  PUSH(CLICKDATE)

  TYPE(End)
TYPE(End)


* 5 vzdìlání      --> VZDELANI
TYPE(TabPage) TTYPE(4) CAPTION(vzdìlání)       OFFSET(53,33)  FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

  TYPE(DBrowse) FPOS(0,0.5) SIZE(50,18) FILE(vzdelaniW)                              ;
                            FIELDS( nPoradi:poøVz                                  , ;
                                    czkrVzdel:typVz                                , ;
                                    M->nazev_Vzdelani:název dosaženého vzdìlání:30 , ;
                                    coborVzdel:obor vzdìlání:25                    , ;      
                                    npocLetStu:poèLet                              , ;
                                    dzacStudia:zaèátekSt                           , ; 
                                    dkonStudia:ukoneèno                              ) ;
                            CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(5)

  TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)

    TYPE(TEXT)   CAPTION(Typ vzdìlání)                CPOS( 1,  .5) CLEN(12)
      TYPE(GET)  NAME(vzdelaniW->czkrVzdel)           FPOS(12,  .5) FLEN(12) NOREVISION()
      TYPE(TEXT) NAME(c_vzdel->cnazVzdela)            CPOS( 1, 1.7) CTYPE(1) CLEN(44) BGND(12) FONT(5)

    TYPE(TEXT)   CAPTION(Obor vzdìlání)               CPOS( 1, 3) CLEN(12)
      TYPE(GET)  NAME(vzdelaniW->coborVzdel)          FPOS(12, 3) FLEN(32) PP(2)

*    TYPE(TEXT)   CAPTION(Délka studia ...)            CPOS( 1, 4) CLEN(12)
*      TYPE(GET)  NAME(vzdelaniW->npocLetStu)          FPOS(13, 4) FLEN( 5) 

    TYPE(TEXT)   CAPTION(Studium _od_)                CPOS( 1, 5) CLEN(12)
      TYPE(GET)  NAME(vzdelaniW->dzacStudia)          FPOS(12, 5) FLEN(11) PP(2) PUSH(CLICKDATE)
      TYPE(TEXT) CAPTION(do)                          CPOS(24, 5) CLEN( 3)
      TYPE(GET)  NAME(vzdelaniW->dkonStudia)          FPOS(27, 5) FLEN(11) PP(2) PUSH(CLICKDATE)
      TYPE(GET)  NAME(vzdelaniW->npocLetStu)          FPOS(40, 5) FLEN(2.5) PP(2)
      TYPE(TEXT) CAPTION(roky)                        CPOS(44, 5  ) CLEN( 2) 

    TYPE(TEXT)   CAPTION(zp_ukonèení ...)             CPOS( 1, 7) CLEN(12)
      TYPE(GET)  NAME(vzdelaniW->czkrUkoVzd)          FPOS(12, 7) FLEN(12) PP(2)
      TYPE(TEXT) NAME(c_vzdeuk->cnazUkoVzd)           CPOS( 1, 8.2) CTYPE(1) CLEN(44) BGND(12) FONT(5)

* 1 - základní údaje o škole
   TYPE(Static) FPOS(0.5,9.5) SIZE(45.7,6.5) CAPTION(Název školy) RESIZE(xx)

     TYPE(GET) NAME(vzdelaniW->cnazevSkol)       FPOS( 1, 1  ) FLEN(42) PP(2) 
           
    TYPE(TEXT) CAPTION(Ulice/è.popisné)          CPOS( 2, 2.5) CLEN(12)
     TYPE(GET) NAME(vzdelaniW->cUlice)           FPOS(13, 2.5) FLEN(30) PP(2) 

    TYPE(TEXT) CAPTION(Místo)                    CPOS( 2, 3.5)
     TYPE(GET) NAME(vzdelaniW->cmisto)           FPOS(13, 3.5) FLEN(30) PP(2)

    TYPE(TEXT) CAPTION(PSÈ)                      CPOS( 2, 4.5) CLEN(10)
      TYPE(GET)  NAME(vzdelaniW->cpsc)           FPOS(13, 4.5) FLEN( 8) PP(2)
      TYPE(TEXT) NAME(C_PSC_5->CMISTO)           CPOS(23, 4.5) CLEN(21) BGND(13)                     

    TYPE(TEXT) CAPTION(Stát)                     CPOS( 2, 5.5) 
      TYPE(GET)  NAME(vzdelaniW->czkratStat)     FPOS(13, 5.5) FLEN( 8) PP(2)
      TYPE(TEXT) NAME(C_STATY_5->cNAZEVSTAT)     CPOS(23, 5.5) CLEN(21) BGND(13)
    TYPE(End)
  TYPE(End)
TYPE(End)


* 6 lékaøské prohlídky  --> OSOBY -> vazLekpr
TYPE(TabPage) TTYPE(4) CAPTION(lékProhlídky)     OFFSET(66,20)  FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

   TYPE(DBrowse) FPOS(.5,.5) SIZE(50,18) FILE(lekProhlW)                                       ;
                                         FIELDS( nporadi:poøLp                               , ;
                                                 czkratka:typLp                              , ;
                                                 M->nazev_lekPro:název lékaøské prohlídky:30 , ;
                                                 nperioOpak:perOpakLp                        , ;
                                                 czkratJedn:za                               , ;
                                                 cnazevLeka:prohlídku provedl lékaø          , ; 
                                                 dposlLekPr:dne:10                           , ;
                                                 ddalsLekPr:dalšíLp:10                         )  ;
                                         CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(6)
                                          

  TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)

    TYPE(TEXT) CAPTION(Typ lékaøské prohlídky)              CPOS( 1, 1)    CLEN(18) 
      TYPE(GET) NAME(lekProhlW->cZkratka)                   FPOS(18, 1)    FLEN(12) NOREVISION()
      TYPE(PushButton)                                      POS( 31, 1)    SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                            CAPTION(6)             

      TYPE(TEXT) NAME(c_LekPro->cNazev)                     CPOS( 2, 2.2)  CLEN(47) CTYPE(1) BGND(12) FONT(5)

*
     TYPE(Static) STYPE( 2) CAPTION(Lékaøská prohlídka)  SIZE(45.7, 4.3) FPOS( 0.5, 3.5) RESIZE(xx)
       TYPE(TEXT)   CAPTION(Prohlídka dne)                  CPOS( 3, 1) CLEN(18)
         TYPE(GET)  NAME(lekProhlW->dPoslLekPr)             FPOS(22, 1) FLEN(11) PP(2) PUSH(CLICKDATE)

       TYPE(TEXT)   CAPTION(Perioda opakování)              CPOS( 3, 2) CLEN(18)
         TYPE(GET)  NAME(lekProhlW->nPerioOpak)             FPOS(22, 2) FLEN(11) PP(2)
         TYPE(GET)  NAME(lekProhlW->cZkratJEDN)             FPOS(35, 2) FLEN( 5) PP(2)

       TYPE(TEXT)   CAPTION(Další lékaøská prohlídka)       CPOS( 3, 3) CLEN(18)
         TYPE(GET)  NAME(lekProhlW->dDalsLekPr)             FPOS(22, 3) FLEN(11) PP(2) PUSH(CLICKDATE)
     TYPE(End) 

*
     TYPE(Static) STYPE( 2)  SIZE(45.7, 8) FPOS( 0.5, 8.5) CAPTION(Ošetøující lékaø) RESIZE(xx)
         TYPE(GET)  NAME(lekProhlW->cZkratLeka)             FPOS( 3, 1  ) FLEN(10) PP(2)
         TYPE(TEXT) NAME(lekProhlW->cNazevLeka)             CPOS(15, 1  ) CLEN(25)  
         TYPE(TEXT) NAME(lekProhlW->cOdbornLek)             CPOS( 1, 2.5) CLEN(44) PP(2) FONT(5) BGND(13) CTYPE(1)

       TYPE(TEXT)   CAPTION(. . . Ordinace . . .)           CPOS( 3, 4) CLEN(14)

       TYPE(TEXT)   CAPTION(Ulice . . .)                    CPOS( 6, 5.05) CLEN( 8)
         TYPE(TEXT) NAME(lekProhlW->cUlice)                 CPOS(15, 5.05) CLEN(25) PP(2) BGND(13)

       TYPE(TEXT)   CAPTION(Místo . . .)                    CPOS( 6, 6.10) CLEN( 8)
         TYPE(TEXT) NAME(lekProhlW->cMisto)                 CPOS(15, 6.10) CLEN(25) PP(2) BGND(13)

       TYPE(TEXT)   CAPTION(PSÈ   . . .)                    CPOS( 6, 7.15) CLEN( 8)
         TYPE(TEXT) NAME(lekProhlW->cPsc)                   CPOS(15, 7.15) CLEN( 8) PP(2) BGND(13)
         TYPE(TEXT) NAME(c_Psc_6->cMisto)                   CPOS(24, 7.15) CLEN(30) 
     TYPE(End)
  TYPE(End)
TYPE(End)


* 7 školení/ kurzy  --> SKOLENI -> VAZSKOL
TYPE(TabPage) TTYPE(4) CAPTION(školení)          OFFSET(79, 7)  FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) 

   TYPE(DBrowse) FPOS(.5,.5) SIZE(50,18) FILE(skoleniW)                                  ;
                                         FIELDS( nporadi:poøŠk                         , ;
                                                 czkratka:typŠk                        , ;
                                                 M->nazev_Skoleni:název školení/ kurzu , ;
                                                 nperioOpak:perOpakŠk                  , ;
                                                 czkratJedn:za                         , ;
                                                 clektor:školení/ kurz vedl            , ;
                                                 dposlSkole:dne:10                     , ;
                                                 ddalsSkole:dalšíŠk:10                   )  ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(7)


  TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,17.6) RESIZE(ny)

   TYPE(TEXT) CAPTION(Typ školení)               CPOS( 1,  .5) CLEN(18)
     TYPE(GET) NAME(skoleniW->cZkratka)          FPOS(17,  .5) FLEN(12) NOREVISION()
     TYPE(PushButton)                            POS( 30,  .5) SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                 CAPTION(7)   

     TYPE(TEXT) NAME(C_Skolen->cNazev)           CPOS( 1, 1.5) CLEN(47) CTYPE(1) BGND(12) FONT(5)


   TYPE(Static) STYPE( 2) SIZE(45.7, 5.4) FPOS( 0.5,2.5) RESIZE(xx)
    
     TYPE(TEXT)   CAPTION(Školení dne)                CPOS( 1,  .7) CLEN(11)
       TYPE(GET)  NAME(skoleniW->dPoslSkole)          FPOS(15,  .7) FLEN(11) PP(2) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(délka)                      CPOS(28,  .7) CLEN( 5)
       TYPE(GET)  NAME(skoleniW->nDelkaSkol)          FPOS(33,  .7) FLEN( 4) BGND(13) PP(2)
       TYPE(GET)  NAME(skoleniW->cZkratJED2)          FPOS(39,  .7) FLEN( 5) PP(2)

     TYPE(TEXT)   CAPTION(Perioda opakování)          CPOS( 1, 1.7) CLEN(14)
       TYPE(GET ) NAME(skoleniW->nPerioOpak)          FPOS(15, 1.7) FLEN(11) PP(2)
       TYPE(GET)  NAME(skoleniW->cZkratJEDN)          FPOS(33, 1.7) FLEN( 5) 

     TYPE(TEXT)   CAPTION(Termín následující)         CPOS( 1, 2.7) CLEN(13)
       TYPE(GET)  NAME(skoleniW->dDalsSkole)          FPOS(15, 2.7) FLEN(11) PP(2) PUSH(CLICKDATE)

     TYPE(TEXT)   CAPTION(Zpùsob ukonèení)            CPOS( 1, 3.7) CLEN(13)
       TYPE(GET)  NAME(skoleniW->cZkratkaUk)          FPOS(15, 3.7) FLEN(11) 
       TYPE(TEXT) NAME(c_SkolUk->cNazev)              CPOS(27, 3.7) CLEN(20)

     TYPE(TEXT)   CAPTION(Èíslo prùkazu)              CPOS( 1, 4.7) CLEN(13)
       TYPE(GET)  NAME(SkoleniW->cCisPrukaz)          FPOS(15, 4.7) FLEN(29) PP(2) BGND(14)
   TYPE(End)
*
   TYPE(Static) STYPE( 2)  CAPTION(Školení provedl) SIZE(45.7,8.5) FPOS( 0.5,8.5) RESIZE(xx)

     TYPE(TEXT)   CAPTION(Školitel        ...)       CPOS( 2,  .7) CLEN(16)
       TYPE(GET)  NAME(skoleniW->cZkratSkol)         FPOS(15,  .7) FLEN(10) PP(2)
       TYPE(TEXT) NAME(c_skolit->cnazevSkol)         CPOS(28,  .7) CLEN(30)
     
     TYPE(TEXT)   CAPTION(firma    ...)              CPOS( 5, 1.7) CLEN(10)
       TYPE(GET)  NAME(skoleniW->nCisFirmy)          FPOS(15, 1.7) FLEN( 7)
       TYPE(TEXT) NAME(firmy->cnazev)                CPOS(28, 1.7) CLEN(25)  

     TYPE(TEXT)   CAPTION(ulice     ...)             CPOS( 5, 2.7) CLEN( 8)
       TYPE(TEXT) NAME(skoleniW->cUlice)             CPOS(15, 2.7) CLEN(25) PP(2) BGND(13)

     TYPE(TEXT)   CAPTION(místo      ...)            CPOS( 5, 3.7) CLEN( 8)
       TYPE(TEXT) NAME(skoleniW->cMisto)             CPOS(15, 3.7) CLEN(25) PP(2) BGND(13)

     TYPE(TEXT)   CAPTION(psè       ...)             CPOS( 5, 4.7) CLEN( 8)
       TYPE(TEXT) NAME(skoleniW->cPSC)               CPOS(15, 4.7) CLEN( 8) PP(2) BGND(13)
       TYPE(TEXT) NAME(c_Psc_7->cMisto)              CPOS(31, 4.7) CLEN(30) PP(3)

     TYPE(TEXT)   CAPTION(stát         ...)          CPOS( 5, 5.7) CLEN( 8)
       TYPE(TEXT) NAME(skoleniW->cZkratStat)         CPOS(15, 5.7) CLEN( 5) PP(2) BGND(13)
       TYPE(TEXT) NAME(C_Staty_7->cNazevStat)        CPOS(31, 5.7) CLEN(25) 

     TYPE(TEXT)   CAPTION(Lektor         ...)        CPOS( 2, 7.7) CLEN(13)
       TYPE(TEXT) NAME(skoleniW->cLektor)            CPOS(15, 7.7) CLEN(30) PP(2) BGND(13) FONT(5)
   TYPE(End)

  TYPE(End)
TYPE(End)



