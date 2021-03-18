TYPE(drgForm) DTYPE(10) TITLE(Podklad pro pøílohu k žádosti o nemocenskou dávku) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) POST(postValidate)


* TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


* 1_TAB základní
TYPE(TabPage) TTYPE(5) CAPTION(Strana) OFFSET(1,82) 
  TYPE(Static) CTYPE(2) SIZE(109,1.2) FPOS(0.4,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(Typ akce)                              CPOS( 2,0.5) CLEN( 8)
     TYPE(COMBOBOX) NAME(tmhlassow->ntypakce)                  FPOS( 10,0.5) FLEN( 40) ;
                    VALUES( 1:Nástup,                                 ;
                            2:Skonèení,                               ;
                            3:Zmìna,                                  ;
                            5:Oprava,                                 ;
                            6:Pøevod,                                 ;
                            7:Skonèení z dùvodu pøerušení,            ;
                            8:Návrat po pøerušení,                    ;
                            9:Vznik pøíslušnosti k èeským pøedpisùm,  ;
                           10:Skonèení pøíslušnosti k èeským pøedpisùm                                  )  
    TYPE(TEXT) FCAPTION(Datum platnosti akce (opravy) ke dni )  CPOS( 64,0.5) CLEN( 30)
     TYPE(GET) NAME(tmhlassow->dPlatAkce)                       FPOS( 94,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,1.2) FPOS(0.4,1.4) RESIZE(y)
    TYPE(TEXT) FCAPTION(Kód OSSZ)                              CPOS(  2,0.5) CLEN(  8)
     TYPE(GET) NAME(tmhlassow->nKodOkrSoc)                     FPOS( 10,0.5) FLEN(  6)  
    TYPE(TEXT) FCAPTION(Místnì pøíslušná OSSZ)                 CPOS( 19,0.5) CLEN( 16)
     TYPE(GET) NAME(tmhlassow->cNazMisSoc)                     FPOS( 36,0.5) FLEN( 60)  

  TYPE(End)

  TYPE(Static) CTYPE(3) SIZE(109,1.2) FPOS(0.4,2.8) RESIZE(y)
    TYPE(TEXT) FCAPTION(Datum nástupu:)                        CPOS( 15,0.5) CLEN(15) FONT(5)
     TYPE(GET) NAME(tmhlassow->dDatNast)                       FPOS( 32,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
    TYPE(TEXT) FCAPTION(Datum výstupu:)                        CPOS( 65,0.5) CLEN(15) FONT(5)
     TYPE(GET) NAME(tmhlassow->dDatVyst)                       FPOS( 82,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,2.3) FPOS(0.4,4.1) RESIZE(y)
    TYPE(TEXT) FCAPTION(Pøíjmení:)                             CPOS(  2,0.5) CLEN( 8)
     TYPE(GET) NAME(tmhlassow->cPrijOsob)                      FPOS(  2,1.5) FLEN(30) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Jméno:)                                CPOS( 34,0.5) CLEN( 8)
     TYPE(GET) NAME(tmhlassow->cJmenoOsob)                     FPOS( 34,1.5) FLEN(25) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Titul:)                                CPOS( 61,0.5) CLEN( 8)
     TYPE(GET) NAME(tmhlassow->cTitul)                         FPOS( 61,1.5) FLEN(15) PP(2) 
    TYPE(TEXT) FCAPTION(Datum narození:)                       CPOS( 80,0.5) CLEN(15)
     TYPE(GET) NAME(tmhlassow->dDatNaroz)                      FPOS( 80,1.5) FLEN(12) PUSH(CLICKDATE)
    TYPE(TEXT) FCAPTION(Rodné èíslo)                           CPOS( 95,0.5) CLEN(10)
     TYPE(GET) NAME(tmhlassow->cRodCisPra)                     FPOS( 95,1.5) FLEN(12) PP(2) FONT(5)
*    TYPE(TEXT) FCAPTION(Je u nás zamìstnán/a od:)              CPOS(  2,2.5) CLEN(25)
*     TYPE(GET) NAME(tmhlassow->dDatNast)                       FPOS( 28,2.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
*    TYPE(TEXT) FCAPTION(do:)                                   CPOS( 75,2.5) CLEN(10)
*     TYPE(GET) NAME(tmhlassow->dDatVyst)                       FPOS( 91,2.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
*     TYPE(GET) NAME(tmhlassow->cNazDruCin)                     FPOS( 28,3.5) FLEN(40) PP(2) FONT(5)  
       
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,5.2) FPOS(0.4,6.6) RESIZE(y)
    TYPE(TEXT) FCAPTION(Ulice:)                             CPOS(  2,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cUlice)                      FPOS( 11,0.5) FLEN(43)   
    TYPE(TEXT) FCAPTION(è.p.)                               CPOS( 56,0.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cCisPopis)                   FPOS( 60,0.5) FLEN(19) 
    TYPE(TEXT) FCAPTION(Pohlaví:)                           CPOS( 81,0.5) CLEN( 7)
     TYPE(COMBOBOX) NAME(tmhlassow->npohlavi)               FPOS( 88,0.5) FLEN(12) ;
                    VALUES( 0:nezjištìno,                             ;
                            1:muž,                                    ;
                            2:žena    )   
    TYPE(TEXT) FCAPTION(Obec:)                              CPOS(  2,1.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cMisto)                      FPOS( 11,1.5) FLEN(30) 
    TYPE(TEXT) FCAPTION(pošta:)                             CPOS( 43,1.5) CLEN( 6)
     TYPE(GET) NAME(tmhlassow->cPosta)                      FPOS( 49,1.5) FLEN( 5)   
    TYPE(TEXT) FCAPTION(psè:)                               CPOS( 56,1.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cPsc)                        FPOS( 60,1.5) FLEN( 8)   
    TYPE(TEXT) FCAPTION(Stát:)                              CPOS( 70,1.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cZkratStat)                  FPOS( 75,1.5) FLEN( 4)
    TYPE(TEXT) FCAPTION(RodJm:)                             CPOS( 81,1.5) CLEN( 7)
     TYPE(GET) NAME(tmhlassow->cJmenoRod)                   FPOS( 88,1.5) FLEN(19)
    TYPE(TEXT) FCAPTION(Kont.ulice:)                        CPOS(  2,2.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cUliceK)                     FPOS( 11,2.5) FLEN(43) 
    TYPE(TEXT) FCAPTION(è.p.)                               CPOS( 56,2.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cCisPopisK)                  FPOS( 60,2.5) FLEN(19) 
    TYPE(TEXT) FCAPTION(MísNar:)                            CPOS( 81,2.5) CLEN( 7)
     TYPE(GET) NAME(tmhlassow->cMistoNar)                   FPOS( 88,2.5) FLEN(19)
    TYPE(TEXT) FCAPTION(Kont.obec:)                         CPOS(  2,3.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cMistoK)                     FPOS( 11,3.5) FLEN(30)  
    TYPE(TEXT) FCAPTION(pošta:)                             CPOS( 43,3.5) CLEN( 6)
     TYPE(GET) NAME(tmhlassow->cPostaK)                     FPOS( 49,3.5) FLEN( 5) 
    TYPE(TEXT) FCAPTION(psè:)                               CPOS( 56,3.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cPscK)                       FPOS( 60,3.5) FLEN( 8)  
    TYPE(TEXT) FCAPTION(Stát:)                              CPOS( 70,3.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cZkratStaK)                  FPOS( 75,3.5) FLEN( 4)

    TYPE(TEXT) FCAPTION(St.pøís.:)                          CPOS( 81,3.5) CLEN( 7)
     TYPE(GET) NAME(tmhlassow->cZkratStaK)                  FPOS( 88,3.5) FLEN( 5)

    TYPE(TEXT) FCAPTION(Další pøíjm.:)                      CPOS(  2,4.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cPrijDalsi)                  FPOS( 11,4.5) FLEN(96)       
 
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,2.2) FPOS(0.4,11.9) RESIZE(y)
    TYPE(TEXT) FCAPTION(UliceMiZ:)                          CPOS(  2,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cUliceC)                     FPOS( 11,0.5) FLEN(35)   
    TYPE(TEXT) FCAPTION(è.p.:)                              CPOS( 48,0.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cCisPopisC)                  FPOS( 53,0.5) FLEN(15)   
    TYPE(TEXT) FCAPTION(ObecMiZ:)                           CPOS(  2,1.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cMistoC)                     FPOS( 11,1.5) FLEN(30)   
    TYPE(TEXT) FCAPTION(pošta:)                             CPOS( 43,1.5) CLEN( 6)
     TYPE(GET) NAME(tmhlassow->cPostaC)                     FPOS( 49,1.5) FLEN( 5)   
    TYPE(TEXT) FCAPTION(psè:)                               CPOS( 56,1.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cPscC)                       FPOS( 60,1.5) FLEN( 8)   
  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,3.2) FPOS(0.4,14.3) RESIZE(y)
    TYPE(TEXT) FCAPTION(NázevZam:)                          CPOS(  2,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cNazevZame)                  FPOS( 11,0.5) FLEN(50)   
    TYPE(TEXT) FCAPTION(Ièo:)                               CPOS( 63,0.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cIco)                        FPOS( 70,0.5) FLEN(10)   
    TYPE(TEXT) FCAPTION(Var.symbol:)                        CPOS( 82,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cVarSymSoc)                  FPOS( 92,0.5) FLEN(15)
    TYPE(TEXT) FCAPTION(Druh èin.:)                         CPOS(  2,1.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cTypPPVReg)                  FPOS( 11,1.5) FLEN( 6)
    TYPE(TEXT) NAME(tmhlassow->cNazDruCin)                  CPOS( 20,1.5) CLEN(30)
    TYPE(TEXT) FCAPTION(Stát výk.èin.:)                     CPOS( 63,1.5) CLEN(11)
     TYPE(GET) NAME(tmhlassow->cZkratStaV)                  FPOS( 74,1.5) FLEN( 6)
    TYPE(TEXT) FCAPTION(Zam.mal.rozsahu:)                   CPOS( 82,1.5) CLEN(15)
     TYPE(COMBOBOX) NAME(tmhlassow->lZamMalRoz)             FPOS(100,1.5) FLEN( 8)  REF( LYESNO) 
    TYPE(TEXT) FCAPTION(DruhDùch:)                          CPOS(  2,2.6) CLEN( 9)
     TYPE(COMBOBOX) NAME(tmhlassow->cTypDucReg)             FPOS( 11,2.6) FLEN(51)  REF( cTypDucReg)
    TYPE(TEXT) FCAPTION(Dùchod Od:)                         CPOS( 63,2.5) CLEN(11)
     TYPE(GET) NAME(tmhlassow->dDuchodOd)                   FPOS( 74,2.5) FLEN(12)  PUSH(CLICKDATE)
  TYPE(End)


  TYPE(Static) CTYPE(2) SIZE(109,3.2) FPOS(0.4,17.7) RESIZE(y)
    TYPE(TEXT) FCAPTION(Náz.ciz.poj.:)                      CPOS(  2,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cNazevCizo)                  FPOS( 11,0.5) FLEN(62) 
    TYPE(TEXT) FCAPTION(Specifik.poj.:)                     CPOS( 75,0.5) CLEN(12)
     TYPE(COMBOBOX) NAME(tmhlassow->cSpeciCizo)             FPOS( 87,0.5) FLEN(21) ;
                    VALUES(  :neexistuje,                         ;
                            P:poslední,                           ;
                            S:souèasný,                           ;
                            N:není )
    TYPE(TEXT) FCAPTION(Ciz.ulice:)                         CPOS(  2,1.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cUliceZ)                     FPOS( 11,1.5) FLEN(35) 
    TYPE(TEXT) FCAPTION(è.p.:)                              CPOS( 48,1.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cCisPopisZ)                  FPOS( 53,1.5) FLEN(20) 
    TYPE(TEXT) FCAPTION(Ciz.obec:)                          CPOS(  2,2.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cMistoZ)                     FPOS( 11,2.5) FLEN(35)  
    TYPE(TEXT) FCAPTION(psè:)                               CPOS( 48,2.5) CLEN( 4)
     TYPE(GET) NAME(tmhlassow->cPscZ)                       FPOS( 53,2.5) FLEN( 8)  
    TYPE(TEXT) FCAPTION(Stát:)                              CPOS( 63,2.5) CLEN( 5)
     TYPE(GET) NAME(tmhlassow->cZkratStaZ)                  FPOS( 68,2.5) FLEN( 5)
    TYPE(TEXT) FCAPTION(Èíslo cizoz.poj.:)                  CPOS( 75,2.5) CLEN(12)
     TYPE(GET) NAME(tmhlassow->cCisloCizo)                  FPOS( 87,2.5) FLEN(20)

  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,1.2) FPOS(0.4,21.1) RESIZE(y)
    TYPE(TEXT) FCAPTION(Kód zdr.p.:)                        CPOS(  2,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->nZdrPojis)                   FPOS( 11,0.5) FLEN( 5) 
    TYPE(TEXT) FCAPTION(Pøedch.org.:)                       CPOS( 18,0.5) CLEN(10)
     TYPE(GET) NAME(tmhlassow->cNazOrgPre)                  FPOS( 28,0.5) FLEN(35) 
    TYPE(TEXT) FCAPTION(Souè.org.:)                         CPOS( 65,0.5) CLEN( 9)
     TYPE(GET) NAME(tmhlassow->cNazOrgSou)                  FPOS( 74,0.5) FLEN(33) 

  TYPE(End)

  TYPE(TEXT) FCAPTION(Datum vystavení:)                     CPOS( 4,22.8) CLEN(15)
     TYPE(GET) NAME(tmhlassow->dDatZprac)                   FPOS(22,22.8) FLEN(12)  PUSH(CLICKDATE)

  
TYPE(End)



*     TYPE(COMBOBOX) NAME(DruhyMZDw->cID)                       FPOS(86,1.55) FLEN(20) ;
*                    VALUES( DIST:distribuèní,                                 ;
*                            USER:uživatelský                                  )  

