TYPE(drgForm) DTYPE(10) TITLE(Personální údaje osob a zamìstnancù ...) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) POST(postValidate)


TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
*TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)



TYPE(TabPage) TTYPE(4) CAPTION(Osobní) OFFSET( 1,82)

  TYPE(Static) STYPE(13) SIZE(98,4.1) FPOS(1,.1) RESIZE(y)

    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, .1) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, .1) CLEN(15)
    TYPE(TEXT) CAPTION(rozlOsoby)           CPOS(45, .1) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, .1) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, .1) CLEN(15) 

    TYPE(GET)  NAME(personalW->cprijOsob)    FPOS( 1,1.1) FLEN(25)
    TYPE(GET)  NAME(personalW->cjmenoOsob)   FPOS(28,1.1) FLEN(15)
    TYPE(GET)  NAME(personalW->crozlJmena)   FPOS(45,1.1) FLEN(15)
    TYPE(GET)  NAME(personalW->ctitulPred)   FPOS(62,1.1) FLEN(15)
    TYPE(GET)  NAME(personalW->ctitulZa)     FPOS(82,1.1) FLEN(15)

    TYPE(TEXT) FCAPTION(rodné Èíslo)         CPOS(62,2.1) CLEN(15)
    TYPE(GET)  NAME(personalW->crodCisPra)   FPOS(62,3.1) FLEN(15) FONT(5)
  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(98,20) FPOS(1,4.4) RESIZE(y)

* LEFT
    TYPE(TEXT) CAPTION(Rodné jméno         ...)      CPOS( 1, 0.40)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cJmenoRod)            FPOS(19, 0.30)    FLEN(29) 

    TYPE(TEXT) CAPTION(Datum narození     ...)       CPOS( 1, 1.45)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->dDatNaroz)            FPOS(19, 1.35)    FLEN(10)

    TYPE(TEXT) CAPTION(Místo narození       ...)     CPOS( 1, 2.50)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cMistoNar)            FPOS(19, 2.40)    FLEN(29)

    TYPE(TEXT) CAPTION(Stát narození         ...)    CPOS( 1, 3.55)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cZkrStatNa)           FPOS(19, 3.45)    FLEN( 5)
     TYPE(TEXT) NAME(c_statyNar->cnazevStat)         CPOS(25.5,3.45)   CLEN(23.6) 
  
    TYPE(TEXT) CAPTION(Národnost              ...)   CPOS( 1, 4.60)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cZkratNar)            FPOS(19, 4.50)    FLEN(29)

    TYPE(TEXT) CAPTION(Státní pøíslušnost   ...)     CPOS( 1, 5.65)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cZkrStaPri)           FPOS(19, 5.55)    FLEN(29)

    TYPE(TEXT) CAPTION(Rodinný stav         ...)     CPOS( 1, 6.70)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cZkrRodStv)           FPOS(19, 6.60)    FLEN(11)
     TYPE(TEXT) NAME(C_RODSTA->cNazRodStv)           CPOS(31.5,6.60)   CLEN(17.6)

    TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)    CPOS( 1, 7.75)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->cZkrVzdel)            FPOS(19, 7.65)    FLEN(11)
     TYPE(TEXT) NAME(C_VZDEL->cNazVzdela)            CPOS(31.5,7.65)   CLEN(17.6) 

    TYPE(TEXT) CAPTION(Klasifikace zamìstnání ...)   CPOS( 1, 8.80)    CLEN(17)
     TYPE(GET) NAME(PERSONALw->nKlasZam)             FPOS(19, 8.70)    FLEN(8)
     TYPE(TEXT) NAME(C_KLAZAM->cNazKlasZa)           CPOS(28.5,8.70)  CLEN(20.6) 

    TYPE(TEXT) CAPTION(IdentÈís os_karty    ...)     CPOS( 1, 10.90)   CLEN(17)
     TYPE(GET) NAME(PERSONALw->cIdOsKarty)           FPOS(19,10.80)    FLEN(25)

    TYPE(TEXT) CAPTION(Celkem roky praxe   ...)      CPOS( 1, 11.95)  CLEN(17)
     TYPE(GET) NAME(PERSONALw->nPocLPraxe)           FPOS(19,11.85)   FLEN(5)

   TYPE(CHECKBOX) NAME(personalW->levidDim)         FPOS(19,13.90)   FLEN(25) ;
       VALUES(T:evidovat DIM u pracovníka,F:evidovat DIM u pracovníka)     

   TYPE(CHECKBOX) NAME(personalW->lvedPrac)         FPOS(19,14.95)   FLEN(25) ;
       VALUES(T:vedoucí pracovník,F:vedoucí pracovník)   

* RIGHT
    TYPE(TEXT) CAPTION(Bydlištì ulice         ... )  CPOS(50, 0.40)    CLEN(15)
     TYPE(GET) NAME(PERSONALw->cUlice)               FPOS(66, 0.30)    FLEN(30)

    TYPE(TEXT) CAPTION(Èíslo popisné  ...)           CPOS(53, 1.45)    CLEN(12)
     TYPE(GET) NAME(PERSONALw->cCisPopis)            FPOS(66, 1.35)    FLEN(10)

    TYPE(TEXT) CAPTION(Psè                ...)       CPOS(53, 2.50)    CLEN(12)
     TYPE(GET) NAME(PERSONALw->cPsc)                 FPOS(66, 2.40)    FLEN(8)
     TYPE(TEXT) NAME(c_psc->cmisto)                  CPOS(75.5,2.40)   CLEN(21.5) 

    TYPE(TEXT) CAPTION(Místo             ... )       CPOS(53, 3.55)    CLEN(12)
     TYPE(GET) NAME(PERSONALw->cMisto)               FPOS(66, 3.45)    FLEN(30)

    TYPE(TEXT) CAPTION(Stát               ... )      CPOS(53, 4.60)    CLEN(12)
     TYPE(GET) NAME(PERSONALw->cZkratStat)           FPOS(66.0, 4.50)  FLEN( 5)
     TYPE(TEXT) NAME(c_staty->cnazevStat)            CPOS(72.5,4.50)   CLEN(24.5) 

    TYPE(TEXT) CAPTION(Pøech bydl. ulice     ... )   CPOS(50, 6.70)   CLEN(15)
     TYPE(GET) NAME(PERSONALw->cPreUlice)            FPOS(66, 6.60)   FLEN(30)

    TYPE(TEXT) CAPTION(Èíslo popisné  ...)           CPOS(53, 7.75)   CLEN(12)
     TYPE(GET) NAME(PERSONALw->cPreCisPop)           FPOS(66, 7.65)   FLEN(10)

    TYPE(TEXT) CAPTION(Psè                ...)       CPOS(53, 8.80)   CLEN(12)
     TYPE(GET) NAME(PERSONALw->cPrePsc)              FPOS(66, 8.70)   FLEN( 8)
     TYPE(TEXT) NAME(c_pscPre->cmisto)               CPOS(75.5,8.70)  CLEN(21.5) 

    TYPE(TEXT) CAPTION(Místo             ...)        CPOS(53, 9.85)   CLEN(12)
     TYPE(GET) NAME(PERSONALw->cPreMisto)            FPOS(66, 9.75)   FLEN(30)

    TYPE(TEXT) CAPTION(Stát               ... )      CPOS(53,10.90)   CLEN(12)
     TYPE(GET) NAME(PERSONALw->cZkrStatPr)           FPOS(66,10.80)   FLEN( 5)
     TYPE(TEXT) NAME(c_statyPre->cnazevStat)         CPOS(72.5,10.80) CLEN(24.5) 

    TYPE(TEXT) CAPTION(Telefon privát       ...)     CPOS(50,13.00)   CLEN(15)
     TYPE(GET) NAME(PERSONALw->cTelPriv)             FPOS(66,12.90)   FLEN(25)

    TYPE(TEXT) CAPTION(Telefon zamìstnání  ...)      CPOS(50,14.05)   CLEN(15)
     TYPE(GET) NAME(PERSONALw->cTelZames)            FPOS(66,13.95)   FLEN(25)

    TYPE(TEXT) CAPTION(Telefon mobil       ...)      CPOS(50,15.10)   CLEN(15)
     TYPE(GET) NAME(PERSONALw->cTelMobil)            FPOS(66,15.00)   FLEN(25)

    TYPE(TEXT) CAPTION(E-mailová adresa  ...)        CPOS(50,16.15)   CLEN(15)
     TYPE(GET) NAME(PERSONALw->cEmail)               FPOS(66,16.05)   FLEN(25)

    TYPE(STATIC) STYPE(16) FPOS( 1, 9.35) SIZE(48,1)
    TYPE(STATIC) STYPE(16) FPOS(50, 5.15) SIZE(47,1)
    TYPE(STATIC) STYPE(16) FPOS(50,11.35) SIZE(47,1)
  TYPE(End)
TYPE(End)


* 2_TAB rodPrisl
TYPE(TabPage) TTYPE(4) CAPTION(RodPøíslušníci) OFFSET(17,68) 
  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(y)

*    TYPE(DBrowse) FPOS(0.75,0.25) SIZE(42,19.4) FILE(rodPrislW) INDEXORD(1)   ;
*                  FIELDS( nrodPrisl:poø        , ;
*                          ncisOsobRP:èísloOsoby, ;
*                          ctypRodPri:typRop      ) ;
*                CURSORMODE(3) PP(1) GROUPS(3)
*
*  TYPE(END)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0) 
TYPE(End)


* 3_TAB duchody
TYPE(TabPage) TTYPE(4) CAPTION(Duchody) OFFSET(31,53) 

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0) 
TYPE(END)