TYPE(drgForm) DTYPE(10) TITLE(KALKULACE položky) SIZE(110,25) FILE(KALKULw);
              GUILOOK(Message:Y,Action:y,IconBar:y:MyIconBar,Menu:n);
              POST(postValidate) CBSAVE(OnSave)

TYPE(Action) CAPTION(info ~Položky)    EVENT(VYR_VYRPOL_INFO) TIPTEXT(Informaèní karta vyrábìné položky)
TYPE(Action) CAPTION(~Výpoèet kalkul.) EVENT(PrimeNAKL)       TIPTEXT(Pøepoèet kalkulace vyrábìné položky)
TYPE(Action) CAPTION(~Režie kalkulace) EVENT(VYR_FIXNAKL_DET) TIPTEXT(Detail režií kalkulace)
TYPE(Action) CAPTION(~Jiná mìna)       EVENT(DETAIL_1)        TIPTEXT(Pøepoèet kalkulace do jiné mìny)
TYPE(Action) CAPTION(~Fakturace)       EVENT(Fakturace_Zak)   TIPTEXT(Stav fakturace na zakázku)

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(109,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)          CPOS(  2, 0.1) CLEN(  8) FONT(2)                    GROUPS( 1)
    TYPE(Text) NAME(VyrPOL->cCisZakaz)   CPOS(  2, 1.3) CLEN( 40) BGND(13) FONT(5) PP(2)     GROUPS( 1, clrGREY)
    TYPE(Text) CAPTION(Vyrábìná položka) CPOS( 43, 0.1) CLEN( 16) FONT(2)                    GROUPS( 1)
    TYPE(Text) NAME(VyrPOL->cVyrPOL)     CPOS( 43, 1.3) CLEN( 20) BGND(13) FONT(5) PP(2)     GROUPS( 1, clrGREY)
    TYPE(Text) CAPTION(Název položky)    CPOS( 64, 0.1) CLEN( 25) FONT(2)                    GROUPS( 1)
    TYPE(Text) NAME(VyrPOL->cNazev)      CPOS( 64, 1.3) CLEN( 38) BGND(13) FONT(5) PP(2)     GROUPS( 1, clrGREY)
    TYPE(Text) CAPTION(Var.)             CPOS(103, 0.1) CLEN(  5) FONT(2)                    GROUPS( 1)
    TYPE(Text) NAME(VyrPOL->nVarCis)     CPOS(103, 1.3) CLEN(  5) BGND(13) FONT(5) CTYPE(2)  GROUPS( 1, clrGREY)
*
    TYPE(Text) CAPTION(Vyrábìná položka) CPOS(  2, 0.1) CLEN( 16) FONT(2)                    GROUPS( 2)
    TYPE(Text) NAME(VyrPOL->cVyrPOL)     CPOS(  2, 1.3) CLEN( 40) BGND(13) FONT(5) PP(2)     GROUPS( 2, clrGREY)
    TYPE(Text) CAPTION(Název položky)    CPOS( 44, 0.1) CLEN( 25) FONT(2)                    GROUPS( 2)
    TYPE(Text) NAME(VyrPOL->cNazev)      CPOS( 44, 1.3) CLEN( 57) BGND(13) FONT(5) PP(2)     GROUPS( 2, clrGREY)
    TYPE(Text) CAPTION(Var.)             CPOS(103, 0.1) CLEN(  5) FONT(2)                    GROUPS( 2)
    TYPE(Text) NAME(VyrPOL->nVarCis)     CPOS(103, 1.3) CLEN(  5) BGND(13) FONT(5) CTYPE(2)  GROUPS( 2, clrGREY)
  TYPE(End)

* HLAVIÈKA KALKULACE
  TYPE(Static) STYPE(13) SIZE(109,5) FPOS(0.5, 3) RESIZE(yn)
    TYPE(COMBOBOX) NAME(nTypRezie)         FPOS(17, 0.2) FLEN( 13) FCAPTION(Typ režie)           CPOS( 1, 0.2) PP(2)
    TYPE(GET)      NAME(M->nMnKalk)        FPOS(17, 1.2) FLEN( 12) FCAPTION(Kalkulaèní množství) CPOS( 1, 1.2) PP(2) PICTURE(@N 99,999,999.99)
    TYPE(GET)      NAME(nMnozDavky)        FPOS(17, 2.2) FLEN( 12) FCAPTION(Množství v dávce)    CPOS( 1, 2.2) PP(2)

    TYPE(COMBOBOX) NAME(cDruhCeny)         FPOS(50, 0.2) FLEN( 16) FCAPTION(Druh ceny materiálu) CPOS(32, 0.2) PP(2)
    TYPE(GET)      NAME(cZkratMENY)        FPOS(50, 1.2) FLEN( 15) FCAPTION(Mìna kalkulace)      CPOS(32, 1.2) PP(2)
    TYPE(COMBOBOX) NAME(cTypKalk)          FPOS(50, 2.2) FLEN( 16) FCAPTION(Typ kalkulace)       CPOS(32, 2.2) PP(2) GROUPS( 1)
    TYPE(COMBOBOX) NAME(cTypKalk)          FPOS(50, 2.2) FLEN( 16) FCAPTION(Typ kalkulace)       CPOS(32, 2.2) PP(2) VALUES(VPO:Za výrobek,:) GROUPS( 2)
*    TYPE(Text)     CAPTION(Typ kalkulace)  CPOS(32, 2.2) CLEN( 16)                                                   GROUPS( 2)
*    TYPE(Text)     CAPTION(Za vvýrobek)    CPOS(50, 2.2) CLEN( 16) FONT(2)                                           GROUPS( 2, clrGREY)
    TYPE(GET)      NAME(nRokVyp)           FPOS(80, 0.2) FLEN( 12) FCAPTION(Rok výpoètu)         CPOS(68, 0.2) PP(2)
    TYPE(GET)      NAME(nObdMes)           FPOS(80, 1.2) FLEN( 12) FCAPTION(Období)              CPOS(68, 1.2) PP(2)
    TYPE(GET)      NAME(dDatAktual)        FPOS(80, 2.2) FLEN( 12) FCAPTION(Den - datum)         CPOS(68, 2.2) PP(2) PUSH(CLICKDATE)
    TYPE(GET)      NAME(nPorKalDen)        FPOS(80, 3.2) FLEN( 12) FCAPTION(Poøadí ve dnu)       CPOS(68, 3.2) PP(2)

*    TYPE(TEXT)     CAPTION(Tady bude informace pøi opravì - pokud bylo pøecenìní) CPOS(1,3.6) FONT(5) GROUPS(KALKUL_isOK)
  TYPE(End)

*
  TYPE(Static) STYPE(12) SIZE(109,1.1) FPOS(0.1, 7.9) RESIZE(yn)
    TYPE(Text) CAPTION(KALKULACE )     CPOS( 5, 0.01) CLEN( 16) FONT(5)
    TYPE(Text) CAPTION(Plánová:  )     CPOS(26, 0.01) CLEN( 10) FONT(5)
    TYPE(Text) CAPTION(MJ )            CPOS(37, 0.01) CLEN(  3)
    TYPE(Text) CAPTION(Kalkulaèní mn.) CPOS(48, 0.01) CLEN( 12)
    TYPE(Text) CAPTION(Skuteèná: )     CPOS(65, 0.01) CLEN( 10) FONT(5)
    TYPE(Text) CAPTION(MJ )            CPOS(76, 0.01) CLEN(  3)
    TYPE(Text) CAPTION(Kalkulaèní mn.) CPOS(87, 0.01) CLEN( 12)
    TYPE(Text) CAPTION( % z PC)        CPOS(100, 0.01) CLEN( 8)
  TYPE(End)

**
  TYPE(Static) STYPE(13) SIZE(109,15.9) FPOS(0.5, 8.9) RESIZE(yn)
* Pøímý materiál - zahr.mena - PLAN
    TYPE(GET)      NAME(nCenMatZMP)         FPOS(26, 0.2) FLEN( 13) FCAPTION(Pøímý materiál - zahr.mena) CPOS( 1, 0.2) PP(2)
    TYPE(PUSHBUTTON) POS(40.2, 0.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMatZMP)
    TYPE(TEXT)     NAME(M->nCenMatZMP)      CPOS(44, 0.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Pøímý materiál - CZK - PLAN
    TYPE(GET)      NAME(nCenMatMJP)         FPOS(26, 1.2) FLEN( 13) FCAPTION(Pøímý materiál - CZK) CPOS( 1, 1.2) PP(2)
    TYPE(PUSHBUTTON) POS(40.2, 1.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMatMJP)
    TYPE(TEXT)     NAME(M->nCenMatMJP)      CPOS(44, 1.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Pøímé mzdy VD - PLAN
    TYPE(GET)      NAME(nCenMzdVDP)         FPOS(26, 2.2) FLEN( 13) FCAPTION(Pøímé mzdy VD) CPOS( 1, 2.2) PP(2)
    TYPE(PUSHBUTTON) POS(40.2, 2.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMzdVDP)
    TYPE(TEXT)     NAME(M->nCenMzdVDP)      CPOS(44, 2.2) CLEN( 14)  BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Pjistné - PLAN
    TYPE(TEXT)     CAPTION(Pojistné)        CPOS( 1, 3.2) PP(2)
    TYPE(TEXT)     NAME(nCenOstatP)         CPOS(26, 3.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)     NAME(M->nCenOstatP)      CPOS(44, 3.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Ostatní pøímé mzdy - PLAN
    TYPE(GET)      NAME(nCenSluzbP)         FPOS(26, 4.2) FLEN( 13) FCAPTION(Ostatní pøímé mzdy) CPOS( 1, 4.2) PP(2)
    TYPE(TEXT)     NAME(M->nCenSluzbP)      CPOS(44, 4.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kooperace 1 - PLAN
    TYPE(GET)        NAME(nCenEnergP)       FPOS(26, 5.2) FLEN( 13) FCAPTION(Kooperace 1) CPOS( 1, 5.2) PP(2)
    TYPE(PUSHBUTTON) POS(40.2, 5.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenEnergP)
    TYPE(TEXT)       NAME(M->nCenEnergP)    CPOS(44, 5.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kooperace 2 - PLAN
    TYPE(GET)        NAME(nCenMajetP)       FPOS(26, 6.2) FLEN( 13) FCAPTION(Kooperace 2) CPOS( 1, 6.2) PP(2)
    TYPE(PUSHBUTTON) POS(40.2, 6.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMajetP)
    TYPE(TEXT)       NAME(M->nCenMajetP)    CPOS(44, 6.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Odbytová režie - PLAN
    TYPE(TEXT)       NAME(M->cNazRezie1)    CPOS( 1, 7.2) CLEN( 18)
    TYPE(GET)        NAME(nAlgOdbyt)        FPOS(19, 7.2) FLEN(  5) PP(2) PUSH( VYR_ALGREZ_SEL)
    TYPE(TEXT)       NAME(nRezOdbytP)       CPOS(26, 7.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezOdbytP)    CPOS(44, 7.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Výrobní režie - PLAN
    TYPE(TEXT)       NAME(M->cNazRezie2)    CPOS( 1, 8.2) CLEN( 18)
    TYPE(GET)        NAME(nAlgVyrob )       FPOS(19, 8.2) FLEN(  5) PP(2) PUSH( VYR_ALGREZ_SEL)
    TYPE(TEXT)       NAME(nRezVyrobP)       CPOS(26, 8.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezVyrobP)    CPOS(44, 8.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Zásobovací režie - PLAN
    TYPE(TEXT)       NAME(M->cNazRezie3)    CPOS( 1, 9.2) CLEN( 18)
    TYPE(GET)        NAME(nAlgZasob )       FPOS(19, 9.2) FLEN(  5) PP(2) PUSH( VYR_ALGREZ_SEL)
    TYPE(TEXT)       NAME(nRezZasobP)       CPOS(26, 9.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezZasobP)    CPOS(44, 9.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Správní režie - PLAN
    TYPE(TEXT)       NAME(M->cNazRezie4)    CPOS( 1,10.2) CLEN( 18)
    TYPE(GET)        NAME(nAlgSprav )       FPOS(19,10.2) FLEN(  5) PP(2) PUSH( VYR_ALGREZ_SEL)
    TYPE(TEXT)       NAME(nRezSpravP)       CPOS(26,10.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezSpravP)    CPOS(44,10.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kalkulaèní cena - PLAN
    TYPE(TEXT)       CAPTION(Kalkulaèní cena) CPOS( 1, 12) PP(2)
    TYPE(TEXT)       NAME(nCenKalkP)       CPOS(26,12) CLEN( 14) BGND(13) CTYPE( 2)         PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nCenKalkP)    CPOS(44,12) CLEN( 14) BGND(13) CTYPE( 2) FONT(5) PICTURE(@N 99,999,999.9999) GROUPS( 1, 2, clrGREEN)
* Kalkulaèní zisk - PLAN
    TYPE(TEXT)       CAPTION(Kalkulaèní zisk) CPOS( 1, 13)
    TYPE(GET)        NAME(nZiskProcP)      FPOS(16,13) FLEN(  6) PP(2)
    TYPE(Text)       CAPTION(%)            CPOS(23,13) CLEN(  3)
    TYPE(TEXT)       NAME(nZiskP)          CPOS(26,13) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 9,999,999.9999)
    TYPE(TEXT)       NAME(M->nZiskP)       CPOS(44,13) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 9,999,999.9999)
* Prodejní cena - PLAN
    TYPE(TEXT)       CAPTION(Prodejní cena) CPOS( 1, 14) PP(2)
    TYPE(TEXT)       NAME(nCenProdP)        CPOS(26,14) CLEN( 14) BGND(13) CTYPE( 2)         PICTURE(@N 9,999,999.9999)
    TYPE(TEXT)       NAME(M->nCenProdP)     CPOS(44,14) CLEN( 14) BGND(13) CTYPE( 2) FONT(5) PICTURE(@N 9,999,999.9999) GROUPS( 1, 2, clrGREEN)

* Pøímý materiál - zahr.mena - SKUT
    TYPE(GET)        NAME(nCenMatZMS)         FPOS(65, 0.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 0.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMatZMS)
    TYPE(TEXT)       NAME(M->nCenMatZMS)      CPOS(83, 0.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Pøímý materiál - CZK - SKUT
    TYPE(GET)        NAME(nCenMatMJS)         FPOS(65, 1.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 1.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMatMJS)
    TYPE(TEXT)       NAME(M->nCenMatMJS)      CPOS(83, 1.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nProcMatS)       CPOS(99, 1.2) CLEN(  6) BGND(13) CTYPE( 2) PICTURE(@N 999.99)
* Pøímé mzdy VD - SKUT
    TYPE(GET)        NAME(nCenMzdVDS)         FPOS(65, 2.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 2.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMzdVDS)
    TYPE(TEXT)       NAME(M->nCenMzdVDS)      CPOS(83, 2.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nProcMzdS)       CPOS(99, 2.2) CLEN(  6) BGND(13) CTYPE( 2) PICTURE(@N 999.99)
* Pjistné - SKUT
    TYPE(TEXT)       NAME(nCenOstatS)         CPOS(65, 3.2) CLEN( 14) BGND(13) CTYPE( 2)
    TYPE(TEXT)       NAME(M->nCenOstatS)      CPOS(83, 3.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Ostatní pøímé mzdy - SKUT
    TYPE(GET)        NAME(nCenSluzbS)         FPOS(65, 4.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 4.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenSluzbS)
    TYPE(TEXT)       NAME(M->nCenSluzbS)      CPOS(83, 4.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kooperace 1 - SKUT
    TYPE(GET)        NAME(nCenEnergS)         FPOS(65, 5.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 5.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenEnergS)
    TYPE(TEXT)       NAME(M->nCenEnergS)      CPOS(83, 5.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kooperace 2 - SKUT
    TYPE(GET)        NAME(nCenMajetS)         FPOS(65, 6.2) FLEN( 13) PP(2)
    TYPE(PUSHBUTTON) POS(79.2, 6.1) SIZE(3, 0.9) CAPTION(...) EVENT( KALK_CenMajetS)
    TYPE(TEXT)       NAME(M->nCenMajetS)      CPOS(83, 6.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Odbytová režie - SKUT
    TYPE(TEXT)       NAME(nRezOdbytS)       CPOS(65, 7.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezOdbytS)    CPOS(83, 7.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Výrobní režie - SKUT
    TYPE(TEXT)       NAME(nRezVyrobS)       CPOS(65, 8.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezVyrobS)    CPOS(83, 8.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Zásobovací režie - SKUT
    TYPE(TEXT)       NAME(nRezZasobS)       CPOS(65, 9.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezZasobS)    CPOS(83, 9.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Správní režie - SKUT
    TYPE(TEXT)       NAME(nRezSpravS)       CPOS(65,10.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nRezSpravS)    CPOS(83,10.2) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 99,999,999.9999)
* Kalkulaèní cena - SKUT
    TYPE(TEXT)       NAME(nCenKalkS)       CPOS(65,12) CLEN( 14) BGND(13) CTYPE( 2)         PICTURE(@N 99,999,999.9999)
    TYPE(TEXT)       NAME(M->nCenKalkS)    CPOS(83,12) CLEN( 14) BGND(13) CTYPE( 2) FONT(5) PICTURE(@N 99,999,999.9999) GROUPS( 1, 2, clrGREEN)
* Kalkulaèní zisk - SKUT
    TYPE(TEXT)       NAME(nZiskS)          CPOS(65,13) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 999,999,999.9999)
    TYPE(TEXT)       NAME(M->nZiskS)       CPOS(83,13) CLEN( 14) BGND(13) CTYPE( 2) PICTURE(@N 999,999,999.9999)
    TYPE(TEXT)       NAME(M->nProcZiskS)   CPOS(99,13) CLEN(  6) BGND(13) CTYPE( 2) PICTURE(@N 999.99)
* Prodejní cena - SKUT
    TYPE(TEXT)       NAME(nCenProdS)       CPOS(65,14) CLEN( 14) BGND(13) CTYPE( 2)         PICTURE(@N 999,999,999.9999)
    TYPE(TEXT)       NAME(M->nCenProdS)    CPOS(83,14) CLEN( 14) BGND(13) CTYPE( 2) FONT(5) PICTURE(@N 999,999,999.9999) GROUPS( 1, 2, clrGREEN)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)