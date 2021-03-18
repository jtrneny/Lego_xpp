TYPE(drgForm) DTYPE(10) TITLE(Pøehled odvodu na sociální pojištìní) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) POST(postValidate)


* TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


* 1_TAB základní
TYPE(TabPage) TTYPE(5) CAPTION(Strana) OFFSET(1,82) 
  TYPE(Static) CTYPE(2) SIZE(25,3.2) FPOS(1.5,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(Typ pøehledu)                           CPOS( 2,0.5) CLEN( 15)
     TYPE(COMBOBOX) NAME(tmprposow->ntypakce)                  FPOS(  2,1.6) FLEN( 20) ;
                    VALUES( 0:Øádný,                                 ;
                            2:Opravný,                               ;
                            3:Storno                                  )  
*    TYPE(TEXT) FCAPTION(Datum platnosti akce (opravy) ke dni )  CPOS( 64,0.5) CLEN( 30)
*     TYPE(GET) NAME(tmprposow->dPlatAkce)                       FPOS( 94,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(81,3.8) FPOS(28.0,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(Za obdobi)                             CPOS( 25,0.7) CLEN( 10)
     TYPE(GET) NAME(tmprposow->nObdobi)                        FPOS( 35,0.7) FLEN(  3)  
     TYPE(TEXT) FCAPTION(/)                                    CPOS( 40,0.7) CLEN(  2)
     TYPE(GET) NAME(tmprposow->nRok)                           FPOS( 43,0.7) FLEN(  6)  
    TYPE(TEXT) FCAPTION(Kód OSSZ)                              CPOS(  2,1.9) CLEN(  8)
     TYPE(GET) NAME(tmprposow->nKodOkrSoc)                     FPOS(  2,2.9) FLEN(  6)  
    TYPE(TEXT) FCAPTION(Místnì pøíslušná OSSZ)                 CPOS( 13,1.9) CLEN( 25)
     TYPE(GET) NAME(tmprposow->cNazMisSoc)                     FPOS( 12,2.9) FLEN( 66)  

  TYPE(End)

*  TYPE(Static) CTYPE(3) SIZE(109,1.2) FPOS(0.4,2.4) RESIZE(y)
*  TYPE(End)

*  TYPE(Static) CTYPE(2) SIZE(109,2.3) FPOS(0.4,4.1) RESIZE(y)
*    TYPE(TEXT) FCAPTION(Pøíjmení:)                             CPOS(  2,0.5) CLEN( 8)
*     TYPE(GET) NAME(tmprposow->cPrijOsob)                      FPOS(  2,1.5) FLEN(30) PP(2) FONT(5) 
*    TYPE(TEXT) FCAPTION(Jméno:)                                CPOS( 34,0.5) CLEN( 8)
*     TYPE(GET) NAME(tmprposow->cJmenoOsob)                     FPOS( 34,1.5) FLEN(25) PP(2) FONT(5)
*  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,4.6) FPOS(0.4,4.1) RESIZE(y)
    TYPE(TEXT) FCAPTION(Název:)                             CPOS(  2,0.5) CLEN( 8)
     TYPE(GET) NAME(tmprposow->cnazevzame)                  FPOS( 10,0.5) FLEN(44)   
    TYPE(TEXT) FCAPTION(Iè)                                 CPOS( 57,0.5) CLEN( 5)
     TYPE(GET) NAME(tmprposow->cIco)                        FPOS( 64,0.5) FLEN(12)   
    TYPE(TEXT) FCAPTION(Var.symbol:)                        CPOS( 80,0.5) CLEN(10)
     TYPE(GET) NAME(tmprposow->cVarSymSoc)                  FPOS( 92,0.5) FLEN(15)

    TYPE(TEXT) FCAPTION(Ulice:)                             CPOS(  2,1.5) CLEN( 8)
     TYPE(GET) NAME(tmprposow->cUlice)                      FPOS( 10,1.5) FLEN(44)   
    TYPE(TEXT) FCAPTION(è.p.:)                              CPOS( 57,1.5) CLEN( 5)
     TYPE(GET) NAME(tmprposow->cCisPopis)                   FPOS( 64,1.5) FLEN(12) 

    TYPE(TEXT) FCAPTION(Obec:)                              CPOS(  2,2.5) CLEN( 8)
     TYPE(GET) NAME(tmprposow->cMisto)                      FPOS( 10,2.5) FLEN(30) 
    TYPE(TEXT) FCAPTION(Psè:)                               CPOS(  42,2.5) CLEN( 4)
     TYPE(GET) NAME(tmprposow->cPsc)                         FPOS( 46,2.5) FLEN( 8)   
    TYPE(TEXT) FCAPTION(Stát:)                              CPOS( 57,2.5) CLEN( 5)
     TYPE(GET) NAME(tmprposow->cZkratStat)                   FPOS( 64,2.5) FLEN( 5)

    TYPE(TEXT) FCAPTION(Sazba:)                             CPOS( 2,3.8) CLEN( 8)
     TYPE(COMBOBOX) NAME(tmprposow->nTypSazby)               FPOS( 10,3.8) FLEN( 98)                ;
                    VALUES( 1:Kód  1  - zamìstnavatel se základní procentní sazbou pojistného 25%,  ;
                            2:Kód  2  - zamìstnavatel se zvýšenou procentní sazbou pojistného 26%    )   
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,6.5) FPOS(0.4,9.3) RESIZE(y)
    TYPE(TEXT) FCAPTION(1. Úhrn vymìøovacích základù všech zamìstnancù:)         CPOS(  2,0.5) CLEN( 50)
     TYPE(GET) NAME(tmprposow->nVymZaklZa)                                       FPOS(95,0.5) FLEN(12) 
*    TYPE(TEXT) FCAPTION(Vym.základ:)                                              CPOS(58,0.5) CLEN(10)
*     TYPE(GET) NAME(tmprposow->nVymZaklZa)                                       FPOS( 69,0.5) FLEN(12)   
*    TYPE(TEXT) FCAPTION(Pojistné:)                                                CPOS(86,0.5) CLEN( 9)
*     TYPE(GET) NAME(tmprposow->nUhrnPojZa)                                       FPOS(95,0.5) FLEN(12) 

    TYPE(TEXT) FCAPTION(2. Pojistné za zamìstnance:)                             CPOS(  2,1.5) CLEN( 55)
     TYPE(GET) NAME(tmprposow->nUhrnPojZa)                                       FPOS(95,1.5) FLEN(12) 


*    TYPE(TEXT) FCAPTION(Vym.základ:)                                              CPOS(58,1.5) CLEN(10)
*     TYPE(GET) NAME(tmprposow->nVymZaklDS)                                       FPOS( 69,1.5) FLEN(12)   
*    TYPE(TEXT) FCAPTION(Pojistné:)                                                CPOS(86,1.5) CLEN( 9)
*     TYPE(GET) NAME(tmprposow->nUhrnPojDS)                                       FPOS(95,1.5) FLEN(12) 

    TYPE(TEXT) FCAPTION(3. Uplatòuji snížení vymìøovacího základu zamìstnavatele:)  CPOS(  2,2.5) CLEN( 50)
     TYPE(COMBOBOX) NAME(tmprposow->nSnizVymZa)                                     FPOS(  95,2.5) FLEN( 13) ;
                    VALUES( 0:Ne,                                 ;
                            1:Ano)  

    TYPE(TEXT) FCAPTION(4. Snížený vymìøovací základ zamìstnavatele:)            CPOS(  2,3.5) CLEN( 50)
     TYPE(GET) NAME(tmprposow->nVymZakl)                                         FPOS(95,3.5) FLEN(12) 


    TYPE(TEXT) FCAPTION(5. Pojistné za zamìstnavatele:)                          CPOS(  2,4.5) CLEN( 50)
     TYPE(GET) NAME(tmprposow->nUhrnPoj)                                         FPOS(95,4.5) FLEN(12) 
*    TYPE(TEXT) FCAPTION(Vym.základ:)                                              CPOS(58,2.5) CLEN(10)
*     TYPE(GET) NAME(tmprposow->nVymZakl)                                         FPOS( 69,2.5) FLEN(12)   
*    TYPE(TEXT) FCAPTION(Pojistné:)                                                CPOS(86,2.5) CLEN( 9)
*     TYPE(GET) NAME(tmprposow->nUhrnPoj)                                         FPOS(95,2.5) FLEN(12) 

    TYPE(TEXT) FCAPTION(6. Pojistné celkem (ø.2 + ø.5):)                          CPOS(  2,5.5) CLEN( 50) FONT(5)
     TYPE(GET) NAME(tmprposow->nPojistne)                                        FPOS(95,5.5) FLEN(12) FONT(5)  
  TYPE(End)

*  TYPE(Static) CTYPE(2) SIZE(109,1.3) FPOS(0.4,14.9) RESIZE(y)
*    TYPE(TEXT) FCAPTION(6. Rozdíl mezi pojistným celkem a úhrnem odeèítaných èástek náhrad mzdy (ø.4-ø.5) :)  CPOS(  2,0.5) CLEN( 55)
*     TYPE(GET) NAME(tmprposow->nRoPoNaMzd)                                       FPOS(95,0.5) FLEN(12) FONT(5)
*  TYPE(End)


  TYPE(Static) CTYPE(2) SIZE(109,1.3) FPOS(0.4,16.5) RESIZE(y)
    TYPE(TEXT) FCAPTION(Bankovní spojení:)                                      CPOS(  2,0.5) CLEN( 18)
     TYPE(GET) NAME(tmprposow->cUcet)                                            FPOS(20,0.5) FLEN(87)
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,3.3) FPOS(0.4,18.1) RESIZE(y)
    TYPE(TEXT) FCAPTION(Kontaktní pracovník)                                      CPOS(  2,0.5) CLEN( 18)
    TYPE(TEXT) FCAPTION(Jméno:)                                                   CPOS(  2,1.5) CLEN( 7)
     TYPE(GET) NAME(tmprposow->cJmenoOsob)                                         FPOS( 9,1.5) FLEN(35)
    TYPE(TEXT) FCAPTION(Pøíjmení:)                                                CPOS( 47,1.5) CLEN( 8)
     TYPE(GET) NAME(tmprposow->cPrijOsob)                                          FPOS(55,1.5) FLEN(30)
    TYPE(TEXT) FCAPTION(Telefon:)                                                 CPOS( 87,1.5) CLEN( 8)
     TYPE(GET) NAME(tmprposow->cTelefon)                                           FPOS(95,1.5) FLEN(12)
    TYPE(TEXT) FCAPTION(Email:)                                                   CPOS(  2,2.5) CLEN( 7)
     TYPE(GET) NAME(tmprposow->cEmail)                                             FPOS( 9,2.5) FLEN(35)

  TYPE(End)

  TYPE(TEXT) FCAPTION(Datum vystavení:)                     CPOS( 4,22.8) CLEN(15)
     TYPE(GET) NAME(tmprposow->dDatZprac)                   FPOS(22,22.8) FLEN(12)  PUSH(CLICKDATE)

  
TYPE(End)



