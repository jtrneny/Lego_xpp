TYPE(drgForm) DTYPE(10) TITLE(Mzdové údaje zamìstnancù (perosnalistika)) SIZE(100,25) FILE(msprc_mo)  ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_kmenmsMo_CRD) OBDOBI(MZD)                         ;
              PRINTFILES(msprc_mo:noscisprac=noscisprac,                                              ;
                         msodppol:noscisprac=noscisprac+nrok=nrok,                                    ;
                         mzddavit:noscisprac=noscisprac+nporpravzt=nporpravzt+cobdobi=cobdobi,        ; 
                         vykazw:cgrpkey=ccpppv)


* TYPE(Action) CAPTION(~Osoba)      EVENT(mzd_osobakmen_crd)     TIPTEXT(Poøízení a oprava údajù o osobì)
* TYPE(Action) CAPTION(~Rodpøísl)   EVENT(mzd_rodprisl_in)       TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(d~Uchody)    EVENT(mzd_duchody_in)        TIPTEXT(Evidované dùchody)
* TYPE(Action) CAPTION(prac~Kal)    EVENT(mzd_prackalendar_in)   TIPTEXT(Pracovní kalendáø-odpracovaná doba)
* TYPE(Action) CAPTION(doc~Házka)   EVENT(mzd_dochazkadny_in)    TIPTEXT(Docházka do zamìstnání)
* TYPE(Action) CAPTION(~Prùmìry)    EVENT(mzd_prumerykmen_crd)   TIPTEXT(Prùmìry pro náhrady a nemoc)
* TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøizení dokladù o mzdì)
* TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)



*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
TYPE(DBrowse) FPOS(0.75,1.40) SIZE(98.5,10.65) FILE(MSPRC_MO)    ;
              POPUPMENU(y) INDEXORD(9) RESIZE(yy)                ;
               FIELDS( M->ind_staVypCM::2.4::2, ;
                       M->is_Stavem::2.4::2   , ;
                       cDruPraVzt,              ;
                       nOsCisPrac,              ;
                       nPorPraVzt,              ;
                       cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,  ;
                       cRodCisPra,              ; 
                       nTypPraVzt,              ;
                       nTypZamVzt,              ;
                       cKmenStrPr,              ;
                       dDatNast,                ;
                       dDatPredVy,              ;
                       dDatVyst,                ;
                       nTypUkoPrv,              ;
                       ncisOsoby,               ;   
                       nROK,                    ;                         
                       nOBDOBI  )               ;
                CURSORMODE(3) PP(7) STABLEBLOCK(stableBlock)  

* 1
TYPE(TabPage) TTYPE(4) CAPTION(Info_Zamìst) OFFSET(1,85) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(1,12) SIZE(98.2,11.2) RESIZE(YX)

    TYPE(TEXT) CAPTION(Zpùsob vzniku PP     ...)   CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cVznPraVzt)         CPOS(20, 0.30)            BGND(13) PP(2) 

    TYPE(TEXT) CAPTION(Pracovní vztah         ...) CPOS( 2, 1.45)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypPraVzt)         CPOS(20, 1.35)   CLEN( 4) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_PRACVZ->cNazPraVzt)         CPOS(24.5, 1.35) CLEN(28) BGND( 9)         

    TYPE(TEXT) CAPTION(Ukonèení prac.vzt    ...)   CPOS( 2, 2.50)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypUkoPrV)         CPOS(20, 2.40)   CLEN( 4) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_UKONPV->cNazUkoPrV)         CPOS(24.5, 2.40) CLEN(28) BGND( 9)         

    TYPE(TEXT) CAPTION(Zamìstnanecký vzt  ...)     CPOS( 2, 3.55)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypZamVzt)         CPOS(20, 3.45)   CLEN(4)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_ZAMEVZ->cNazZamVzt)         CPOS(24.5, 3.45) CLEN(28) BGND( 9)

    TYPE(TEXT) CAPTION(Typ evidenè.stavu    ...)   CPOS( 2, 4.60)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nMimoPrVzt)         CPOS(20, 4.50)   CLEN(4)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_MIMPRV->cNazMimPrV)         CPOS(24.5, 4.50) CLEN(28) BGND( 9)

    TYPE(TEXT) CAPTION(Mzdová kategorie    ...)    CPOS( 2, 5.65)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cMzdKatPra)         CPOS(20, 5.55)   CLEN(8)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pracovní zaøazení    ...)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cPracZar)           CPOS(20, 6.60)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_PRACZA->cNazPracZa)         CPOS(28.5, 6.60) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Funkce pracovníka  ...)     CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cFunPra)            CPOS(20, 7.65)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_FUNCPR->cNazFuncPr)         CPOS(28.5, 7.65) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Typ dùchodu           ...)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypDuchod)         CPOS(20, 8.70)   CLEN( 4) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_DUCHOD->cNazDuchod)         CPOS(28.5, 8.70) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Zdrav.pojišovna    ...)    CPOS( 2, 9.85)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nZdrPojis)          CPOS(20, 9.75)   CLEN( 6) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_ZDRPOJ->cNazZdrPoj)         CPOS(28.5, 9.75) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Dat_vzn_PrVz   ...)         CPOS(54, 0.40)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->dDatVznPrV)         CPOS(70, 0.30)   CLEN(10) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pracovištì        ...)      CPOS(54, 1.45)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->cNazPol4)           CPOS(70, 1.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(CNAZPOL4->cNazev)             CPOS(78.5, 1.40) CLEN(19) 

    TYPE(TEXT) CAPTION(Výplatní místo   ... )      CPOS(54, 2.50)   CLEN(16)
     TYPE(TEXT) NAME(MSPRC_MO->cVyplMist)          CPOS(70, 2.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_VYPLMI->cNazVyplMi)         CPOS(78.5, 2.40) CLEN(19) BGND( 9)

    TYPE(TEXT) CAPTION(Daò prohlášení  ...)        CPOS(54, 3.55)   CLEN(15)

    TYPE(TEXT) CAPTION(Výpoèet èisté mzdy ...)     CPOS(54, 5.65)   CLEN(15)
    TYPE(TEXT) CAPTION(Výpoèet hrubé mzdy ...)     CPOS(54, 6.70)   CLEN(15)
    TYPE(TEXT) CAPTION(Dovol.zùst.B/M     ...)     CPOS(54, 7.80)   CLEN(15)

    TYPE(TEXT) CAPTION(Odpoèit.položky   ...)      CPOS(54, 8.85)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nOdpocObd  )        CPOS(70, 8.75)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nOdpocRok  )        CPOS(82, 8.75)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Daòová úleva      ...)      CPOS(54, 9.90)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nDanUlObd  )        CPOS(70, 9.80)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nDanUlRok  )        CPOS(82, 9.80)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*    TYPE(End)
TYPE(End)



* 2
TYPE(TabPage) TTYPE(4) CAPTION(PracVztahy) OFFSET(14.9,72) FPOS(0.75,12.5) SIZE(98.5,12.25)  RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(PRSMLDOH) INDEXORD(2)           ;
                  RESIZE(yx)                            ;
                  FIELDS( cDruPraVzt,                   ;
                          nOsCisPrac,                   ;
                          nPorPraVzt,                   ;
                          nTypPraVzt,                   ;
                          M->nazPraVzt:název pracVztahu , ;
                          nTypZamVzt,                   ;
                          dDatNast,                     ;
                          dDatPredVy,                   ;
                          dDatVyst,                     ;
                          nTypUkoPrv)                   ;
                  CURSORMODE(3) PP(1)
    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
TYPE(End)



* 3
TYPE(TabPage) TTYPE(4) CAPTION(StáléSrážky) OFFSET(27.8,59) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(MSSRZ_MO) INDEXORD(1)           ;
                  RESIZE(yx)                      ;
                  FIELDS( nPoradi,                ;
                          nPorUplSrz,             ;
                          cZkrSrazky,             ;
                          nSplatka,               ;
                          dDatOdSpl,              ;
                          dDatDoSpl,              ;
                          cUcet)                  ;
                  CURSORMODE(3) PP(1)
    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
TYPE(End)


* 4
TYPE(TabPage) TTYPE(4) CAPTION(OsobníÚdaje) OFFSET(40.7,46) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

    TYPE(TEXT) CAPTION(Rodné èíslo. . . .)         CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(osoby->crodCisOsb)            CPOS(20, 0.30)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodné jméno. . . .)         CPOS( 2, 1.45)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cjmenoRod)             CPOS(20, 1.35)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Datum narození. . . .)      CPOS( 2, 2.50)   CLEN(17)
     TYPE(TEXT) NAME(osoby->ddatNaroz)             CPOS(20, 2.40)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Místo narození. . .)        CPOS( 2, 3.55)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cmistoNar)             CPOS(20, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Stát narození. . . .)       CPOS( 2, 4.60)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStatNa)            CPOS(20, 4.50)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Národnost . . . . .)        CPOS( 2, 5.65)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkratNar)             CPOS(20, 5.55)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Státní pøíslušnost . . .)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStaPri)            CPOS(20, 6.60)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodinný stav . . .)         CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrRodStv)            CPOS(20, 7.65)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrVzdel)             CPOS(20, 8.70)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Bydlištì ulice-è.p. . )     CPOS(48, 0.40)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cUlice)                CPOS(64, 0.30)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Psè-místo . .)              CPOS(54, 1.45)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cPsc)                  CPOS(64, 1.40)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cMisto)                CPOS(70, 1.40)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(stát . . )                  CPOS(54, 2.50)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkratStat)            CPOS(64, 2.40)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pøe.bydl ulice-è.p. . )     CPOS(48, 3.55)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cpreUlice)             CPOS(64, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Psè-místo . .)              CPOS(54, 4.60)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cprePsc)               CPOS(64, 4.50)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cpreMisto)             CPOS(70, 4.50)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(stát . . )                  CPOS(54, 5.65)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkrStatPr)            CPOS(64, 5.55)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Telefon1/Telefon2 . .)      CPOS(48, 6.70)   CLEN(15)
     TYPE(TEXT) NAME(osoby->ctelPriv)              CPOS(64, 6.60)   CLEN(25) BGND(13) PP(2)

  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)



* 5 - rodinní pøíslušníci  --> OSOBY -> VAZOSOBY 
TYPE(TabPage) TTYPE(4) CAPTION(RodPøíslušníci) OFFSET(53.7,33) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(vazOsoby)                                   ;
                                          RESIZE(yx)                            ;
                                FIELDS( vazOsoby_osoby_Rp('ncisOsoby'):èíslOsoby                , ;
                                        vazOsoby_osoby_Rp('cjmenoRozl'):Pøímení a jméno osoby:30, ;
                                        vazOsoby->ctypRodPri:typVztahu                          , ;
                                        vazOsoby_osoby_Rp('cjmenoRod'):rozen(á)                , ;
                                        vazOsoby_osoby_Rp('crodCisOsb'):rodÈíslo                , ;
                                        vazOsoby_osoby_Rp('ddatNaroz'):datNaroz                 , ;   
                                        vazOsoby_osoby_Rp('CMISTO'):Mìsto:25                    , ;
                                        vazOsoby_osoby_Rp('CZKRATSTAT'):Stát                      ) ;
                                        CURSORMODE(3) PP(7) SCROLL(yy)

  TYPE(End)
TYPE(End)



* 6 dùchody      --> DUCHODY
TYPE(TabPage) TTYPE(4) CAPTION(Dùchody)        OFFSET(66.7,20) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(duchody)         ;
                                          RESIZE(yx)                            ;
                                FIELDS( M->is_Aktiv:ad:2.6::2        , ;
                                        nporDuchod:poøadí            , ;
                                        ntypDuchod:typ dùchodu       , ;
                                        cnazDuchod:název typu dùchodu, ;
                                        dpriznDuOd:pøiznán OD        , ; 
                                        dpriznDuDo:pøiznán DO        , ;
                                        cnazev:dùchod vyplácí:31       ) ;
                                CURSORMODE(3) PP(7) SCROLL(yy)

  TYPE(End)
TYPE(End)


*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(74.50,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)
