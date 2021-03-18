TYPE(drgForm) DTYPE(10) TITLE(Kmenové údaje zamìstnancù) SIZE(100,25) FILE(msprc_mo)           ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_kmenove_CRD) OBDOBI(MZD)                   ;
              PRINTFILES(msprc_mo:,                                                            ;
                         msosb_mo:noscisprac=noscisprac+nrok=nrok,                             ;
                         msodppol:noscisprac=noscisprac+nrok=nrok,                             ;
                         vyucdane:noscisprac=noscisprac+nrok=nrok,                             ;
                         mzddavit:noscisprac=noscisprac+nporpravzt=nporpravzt+cobdobi=cobdobi, ; 
                         vykazw:cgrpkey=croobcpppv,                                            ;
                         vazosoby:osoby=nosoby,                                                ;
                         tmhlassow)                                                            ;
              COMMFILES( msprc_mo:,                                                            ;                       
                         tmhlassow: )  



TYPE(Action) CAPTION(~Osoba)      EVENT(mzd_osobakmen_crd)     TIPTEXT(Poøízení a oprava údajù o osobì)
TYPE(Action) CAPTION(~Rodpøísl)   EVENT(mzd_rodprisl_in)       TIPTEXT(Rodinní pøíslušníci)
TYPE(Action) CAPTION(d~Uchody)    EVENT(mzd_duchody_in)        TIPTEXT(Evidované dùchody)
TYPE(Action) CAPTION(prac~Kal)    EVENT(mzd_prackalendar_in)   TIPTEXT(Pracovní kalendáø-odpracovaná doba)
TYPE(Action) CAPTION(doc~Házka)   EVENT(mzd_dochazkadny_in)    TIPTEXT(Docházka do zamìstnání)
TYPE(Action) CAPTION(~Prùmìry)    EVENT(mzd_prumerykmen_crd)   TIPTEXT(Prùmìry pro náhrady a nemoc)
TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøizení dokladù o mzdì)
TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)
TYPE(Action) CAPTION(~Nemocenky)  EVENT(mzd_doklnemAll_scr)    TIPTEXT(Pøehled všech èerpaných nemocenských dávek)
TYPE(Action) CAPTION(mzd~List)    EVENT(mzd_mzdlisty_pv_scr)   TIPTEXT(Mzdový list zamìstnance za PV)
TYPE(Action) CAPTION(~Eldp)       EVENT(mzd_eldphd_crd)        TIPTEXT(Evidenèní list dùchodového zabezpeèení)
TYPE(Action) CAPTION(~Výpdaò)     EVENT(mzd_vypdan_crd)        TIPTEXT(Výpoèet roèní danì - roèní zúètování)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(d~Oplòující) EVENT(createContext_dop)     TIPTEXT(možnost zmìny základních údajù -mzdy-)  ICON1(338) ATYPE(33)
TYPE(Action) CAPTION(~SmlouvyDoh) EVENT(mzd_smldoh_in)         TIPTEXT(Pracovní smlouvy a dohody - zmìny)
TYPE(Action) CAPTION(~ZrušeníPV)  EVENT(mzd_delporprvzt_)      TIPTEXT(Zruší pracovní vztah - nepoužitý)


*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
TYPE(DBrowse) FPOS(0.75,1.40) SIZE(98.5,10.65) FILE(MSPRC_MO)    ;
              POPUPMENU(y) INDEXORD(9) RESIZE(yy)                ;
               FIELDS( M->ind_staVypCM::2.4::2, ;
                       M->is_Stavem::2.4::2   , ;
                       cDruPraVzt,              ;
                       nOsCisPrac,              ;
                       nPorPraVzt,              ;
                       cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,  ;
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
TYPE(TabPage) TTYPE(4) CAPTION(Info_Zamìst) OFFSET(1,87) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(1,12) SIZE(98.2,11.2) RESIZE(YX)

    TYPE(TEXT) CAPTION(Zpùsob vzniku PP     ...)   CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cVznPraVzt)         CPOS(20, 0.30)   CLEN(32.5) BGND(9) PP(2) 

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
     TYPE(TEXT) NAME(MSPRC_MO->cMzdKatPra)         CPOS(20, 5.55)   CLEN(32.5)  BGND(9) PP(2)

    TYPE(TEXT) CAPTION(Pracovní zaøazení    ...)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cPracZar)           CPOS(20, 6.60)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_PRACZA->cNazPracZa)         CPOS(28.5, 6.60) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Funkce pracovníka  ...)     CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cFunPra)            CPOS(20, 7.65)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_FUNCPR->cNazFuncPr)         CPOS(28.5, 7.65) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Typ dùchodu           ...)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypDuchod)         CPOS(20, 8.70)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_DUCHOD->cNazDuchod)         CPOS(28.5, 8.70) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Zdrav.pojišovna    ...)    CPOS( 2, 9.85)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nZdrPojis)          CPOS(20, 9.75)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_ZDRPOJ->cNazZdrPoj)         CPOS(28.5, 9.75) CLEN(24) BGND( 9)

*    TYPE(TEXT) CAPTION(D_vz-D_pø.uk_PV   ...)         CPOS(54, 0.40)   CLEN(15)
*     TYPE(TEXT) NAME(MSPRC_MO->dDatVznPrV)         CPOS(70, 0.30)   CLEN(10) BGND(13) PP(2)
*     TYPE(TEXT) NAME(MSPRC_MO->dDatPredVy)         CPOS(85, 0.30)   CLEN(10) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pracovištì        ...)      CPOS(54, 0.45)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->cNazPol4)           CPOS(70, 0.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(CNAZPOL4->cNazev)             CPOS(78.5, 0.40) CLEN(19) 

    TYPE(TEXT) CAPTION(Výplatní místo   ... )      CPOS(54, 1.50)   CLEN(16)
     TYPE(TEXT) NAME(MSPRC_MO->cVyplMist)          CPOS(70, 1.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_VYPLMI->cNazVyplMi)         CPOS(78.5, 1.40) CLEN(19) BGND( 9)

*    TYPE(TEXT) CAPTION(Daò prohlášení  ...)        CPOS(54, 3.55)   CLEN(15)

*    TYPE(TEXT) CAPTION(Výpoèet èisté mzdy ...)     CPOS(54, 5.65)   CLEN(15)
*    TYPE(TEXT) CAPTION(Výpoèet hrubé mzdy ...)     CPOS(54, 6.70)   CLEN(15)

    TYPE(TEXT) CAPTION(Dov.zùst.B/M dny ...)     CPOS(54, 7.80)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nDovBezZus  )       CPOS(70, 7.70)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nDovMinZus )        CPOS(82, 7.70)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Dov.zùst.B/M hod ...)     CPOS(54, 8.80)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nHDoBezZus  )       CPOS(70, 8.70)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nHDoMinZus )        CPOS(82, 8.70)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

*    TYPE(TEXT) CAPTION(Odpoèit.položky   ...)      CPOS(54, 8.85)   CLEN(15)
*     TYPE(TEXT) NAME(MSPRC_MO->nOdpocObd  )        CPOS(70, 8.75)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
*     TYPE(TEXT) NAME(MSPRC_MO->nOdpocRok  )        CPOS(82, 8.75)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Daòová úleva      ...)      CPOS(54, 9.90)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nDanUlObd  )        CPOS(70, 9.80)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nDanUlRok  )        CPOS(82, 9.80)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*    TYPE(End)
TYPE(End)



* 2
TYPE(TabPage) TTYPE(4) CAPTION(PracVztahy) OFFSET(13,75) FPOS(0.75,12.5) SIZE(98.5,12.25)  RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(60.00,10.8) FILE(PRSMLDOH) INDEXORD(8)           ;
                  RESIZE(yx)                            ;
                  FIELDS( cCisloSmDo:Èíslo sml-doh:10,     ;
                          cDruPraVzt:DruhPV:8,                   ;
                          nPorPraVzt:Poø:3,                ;
                          nTypPraVzt:Typ:4,             ;
                          M->nazPraVzt:Název typu prac.vztahu:20, ;
                          nTypZamVzt:TypZV,                ;
                          dDatNast,                     ;
                          dDatPredVy,                   ;
                          dDatVyst,                     ;
                          nTypUkoPrv:TypUkonè)                   ;
                  CURSORMODE(3) PP(1)

    TYPE(DBrowse) FPOS(60.10,0.2) SIZE(36.25,10.8) FILE(PRSMDOZM) INDEXORD(2)           ;
                  RESIZE(yx)                              ;
                  FIELDS( cTypZmSmDo:Typ zmìny:10,           ;
                          cCisZmSmDo:Èíslo zmìny:10,         ;
                          nPorZmeny::3,                      ;
                          cPopisZmen,                     ;
                          nTypZamVzt,                     ;
                          dDatZmeny,                      ;
                          dDatZmenyP)                     ;
                  CURSORMODE(3) PP(1)


    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
TYPE(End)



* 3
TYPE(TabPage) TTYPE(4) CAPTION(StáléSrážky) OFFSET(25,63) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

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
TYPE(TabPage) TTYPE(4) CAPTION(OsobníÚdaje) OFFSET(37,51) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

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
     TYPE(TEXT) NAME(osoby->cUlicCiPop)            CPOS(64, 0.30)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Psè-místo . .)              CPOS(54, 1.45)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cPsc)                  CPOS(64, 1.40)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cMisto)                CPOS(70, 1.40)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(stát . . )                  CPOS(54, 2.50)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkratStat)            CPOS(64, 2.40)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pøe.bydl ulice-è.p. . )     CPOS(48, 3.55)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cPreUliCPo)            CPOS(64, 3.45)   CLEN(25) BGND(13) PP(2)

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
TYPE(TabPage) TTYPE(4) CAPTION(RodPøíslušníci) OFFSET(49,39) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

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
TYPE(TabPage) TTYPE(4) CAPTION(Dùchody)        OFFSET(61,27) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

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

* 7 prùmìry    --> MSVPRUM
TYPE(TabPage) TTYPE(4) CAPTION(Info_prùmìry)    OFFSET(73,15) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(Static) STYPE(2) CAPTION(PRÙMÌR NA NÁHRADY A DOVOLENOU) SIZE(98,4) FPOS( 0,1) RESIZE(y)
    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,1) CLEN(10)
    TYPE(TEXT) CAPTION(Odmeny)                              CPOS(38,1) CLEN( 7)
    TYPE(TEXT) CAPTION(Dny/Hod)                             CPOS(53,1) CLEN( 7)

    TYPE(TEXT) CAPTION(Prùmìr na HOD . . .)                 CPOS( 2  ,2) CLEN(19)
    TYPE(TEXT) CAPTION([)                                   CPOS(22  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,2) CLEN(12) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(+)                                   CPOS(35.5,2) CLEN( 2)    
    TYPE(TEXT) NAME(msvPrum->nKC_ODMcis)                    CPOS(38  ,2) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(49  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(/)                                   CPOS(51  ,2) CLEN( 2)
    TYPE(TEXT) NAME(msvPrum->nHOD_PPSUM)                    CPOS(53  ,2) CLEN( 9) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(=)                                   CPOS(61.5,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nHodPrumPP)                    CPOS(65  ,2) CLEN( 8) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(Prùmìr na DEN . . .)                 CPOS( 2  ,3) CLEN(18)

    TYPE(TEXT) CAPTION([)                                   CPOS(22  ,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,3) CLEN(12) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(*)                                   CPOS(35.5,3) CLEN( 2)    
    TYPE(TEXT) NAME(msvPrum->nKC_ODMcis)                    CPOS(38  ,3) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(49  ,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(=)                                   CPOS(61.5,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nDenPrumPP)                    CPOS(65  ,3) FLEN( 8) PP(2) FONT(5)
  TYPE(END)


  TYPE(Static) STYPE(2) CAPTION(PRÙMÌR NA NEMOCENSKÉ DÁVKY)    SIZE(98,4) FPOS( 0,6) RESIZE(y)
    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,1) CLEN( 9)
    TYPE(TEXT) CAPTION(Kd)                                  CPOS(39,1) CLEN( 3)
    TYPE(TEXT) CAPTION(Kd_AN)                               CPOS(48,1) CLEN( 6)

    TYPE(TEXT) CAPTION(Dílè.vym.zák. . . .)                 CPOS( 2  ,2) CLEN(19)
    TYPE(TEXT) NAME(msvPrum->nKC_NMSUM)                     CPOS(21  ,2) CLEN(11) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(/)                                   CPOS(35.5,2) CLEN( 2)     
    TYPE(TEXT) CAPTION([)                                   CPOS(37  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKD_NMSUM)                     CPOS(38  ,2) CLEN( 8) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(+)                                   CPOS(45.5,2) CLEN( 2)
    TYPE(TEXT) NAME(msvPrum->nKDO_NMSUM)                    CPOS(47  ,2) CLEN( 8) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(55  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(=)                                   CPOS(56  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nDenVZhruN)                    CPOS(60  ,2) CLEN(10) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(Èist/krác_90% . . .)                 CPOS( 2  ,3) CLEN(19)
    TYPE(TEXT) NAME(msvPrum->nDenVZcisN)                    CPOS(23  ,3) CLEN(11)       FONT(5)
    TYPE(TEXT) NAME(msvPrum->nDenVZciKN)                    CPOS(32  ,3) CLEN( 9) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(Den_25/69k/69_% . . .)               CPOS(50  ,3) CLEN(21)
    TYPE(TEXT) NAME(msvPrum->nSazDenNiN)                    CPOS(72  ,3) CLEN( 6) PP(2) FONT(5)
    TYPE(TEXT) NAME(msvPrum->nSazDenVKN)                    CPOS(79  ,3) CLEN( 6) PP(2) FONT(5)
    TYPE(TEXT) NAME(msvPrum->nSazDenVyN)                    CPOS(86  ,3) CLEN( 6) PP(1) FONT(5)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(END)
TYPE(End)

* 8 èistá mzda    --> MZDYHD / MZDYIT
* mzdyhd - hlavièky vypoètených èistých mezd
TYPE(TabPage) TTYPE(4) CAPTION(Èitá mzda)    OFFSET(85,3) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)

    TYPE(dBrowse) FPOS(-0.3,0.2) SIZE(97.25,5)  FILE(MzdyHD) INDEXORD(1) RESIZE(yx)    ;
                  FIELDS( nHrubaMzda,                     ; 
                          nCistPrije,                     ; 
                          nCastKVypl,                     ;
                          nDnyFondKD,                     ;
                          nDnyFondPD,                     ;
                          nHodFondPD,                     ;
                          nOdvoSocPZ,                     ;
                          nOdvoZdrPZ,                     ; 
                          nNezdCasZD,                     ;
                          nZdanMzdaP,                     ; 
                          nDanCelkem,                     ; 
                          nNemocCelk  )                   ;
                  CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

* mzdyit - položky vzpoètených èistých mezd
    TYPE(dBrowse) FPOS(-0.3,5) SIZE(97.25,6.1) FILE(MzdyIT) INDEXORD(23)           ;
                  FIELDS( cDenik:De,                  ;
                          nDoklad,                    ;
                          nDruhMzdy:Dmz,              ;
                          M->nazevDMz::35,            ;
                          nDnyDoklad,                 ;
                          nHodDoklad,                 ; 
                          nMzda,                      ;
                          nSazbaDokl,                 ; 
                          nMnPDoklad )                ;
                   CURSORMODE(3) PP(7) 
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
