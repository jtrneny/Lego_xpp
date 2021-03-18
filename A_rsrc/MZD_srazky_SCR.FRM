TYPE(drgForm) DTYPE(10) TITLE(Trvalé srážky zamìstnancù) SIZE(100,25)                         ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_srazky_CRD) OBDOBI(MZD)                  ;
              PRINTFILES(mssrz_mo:noscisprac=noscisprac,                                      ;
                         mzddavit:noscisprac=noscisprac+nporpravzt=nporpravzt+cobdobi=cobdobi)


*TYPE(Action) CAPTION(~Dokl_HM )  EVENT(Pohyby_DOKLADY)    TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(D~okl_NEM)  EVENT(PorDokl_NEMOCENKA) TIPTEXT(Poøízení nemocenských dávek)
*TYPE(Action) CAPTION(~Cist_MZD)  EVENT(CistaMzda)         TIPTEXT(Èistá mzda)
*TYPE(Action) CAPTION(~Prùm_MZD)  EVENT(Prumery)           TIPTEXT(Výpoèet prùmìrù)


*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
TYPE(DBrowse) FPOS(0.75,1.60) SIZE(98.5,10.65) FILE(MSSRZ_MO)    ;
              POPUPMENU(y) INDEXORD(1) RESIZE(yy)                ;
               FIELDS( nOsCisPrac,           ;
                       nPorPraVzt,           ;
                       cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,  ;
                       cKmenStrPr,           ;
                       nPoradi,              ;
                       nPorUplSrz,           ;
                       cZkrSrazky,           ;
                       nSplatka,             ;
                       dDatOdSpl,            ;
                       dDatDoSpl,            ;
                       cUcet,                ;     
                       nROK,                 ;
                       nOBDOBI  )            ;
                CURSORMODE(3) PP(7)
* ITEMMARKED(ItemMarked)

* cDruPraVzt,           ;
*                       nTypZamVzt,           ;
*                       nTypPraVzt,           ;

TYPE(TabPage) TTYPE(4) CAPTION(Info_Srážka) OFFSET(1,85) FPOS(0.75,12.5) SIZE(98.5,12.25);
                       RESIZE(yx)
*  TYPE(STATIC) STYPE( 13) FPOS(1,12) SIZE(98.2,11.2) RESIZE(YX)
   TYPE(TEXT) CAPTION(Typ srážky...) CPOS(1.0, .25) CLEN(15) 
    TYPE(TEXT) NAME(MSSRZ_MO->cZkrSrazky)    CPOS(16.0, 0.20)   CLEN(11)
   TYPE(TEXT) CAPTION(Popis srážky...) CPOS(1.0,1.3) CLEN(15)
    TYPE(TEXT) NAME(MSSRZ_MO->cPopSrazky)    CPOS(16.0, 1.20)   CLEN(37) SETFONT,9.Arial



*GROUPS(SETFONT,9.Arial,GRA_CLR_RED)



*  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(y)
*    TYPE(DBrowse) FPOS(0.75,0.25) SIZE(42.00,19.40) FILE(MSSRZ_MOw) INDEXORD(1)   ;
*                  FIELDS( nPorUplSrz,     ;
*                          cZkrSrazky,     ;
*                          nSplatka,       ;
*                          dDatOdSpl,      ;
*                          dDatDoSpl,      ;
*                          cUcet)          ;
*                CURSORMODE(3) PP(1) GROUPS(3)
*
*      TYPE(TEXT) NAME(C_SRAZKY->cNazSrazky)      CPOS(69.5, 0.10)   CLEN(25.5) GROUPS(SETFONT,9.Arial,GRA_CLR_RED)
*
*
*    TYPE(TEXT) CAPTION(Aktivní srážka.)          CPOS(44.0, 2.85)   CLEN(12)
*     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lAktivSrz)    FPOS(57.0, 2.75)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 
*    TYPE(TEXT) CAPTION(Pøedn.pohl. .)            CPOS(44.0, 3.90)   CLEN(13)
*     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lPrednPohl)   FPOS(57.0, 3.80)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 
*
*    TYPE(GET) NAME(MSSRZ_MOw->dDatOdSpl)         FPOS(83.0, 2.75) FLEN(10.7) FCAPTION(Srážka_OD...)        CPOS(70.0,2.85) CLEN(13) PUSH(CLICKDATE)
*
*    TYPE(GET) NAME(MSSRZ_MOw->dDatDoSpl)         FPOS(83.0, 3.80) FLEN(10.7) FCAPTION(Srážka_DO...)        CPOS(70.0,3.9)  CLEN(13) PUSH(CLICKDATE)
*
*    TYPE(GET) NAME(MSSRZ_MOw->dDatDorVyk)        FPOS(57.0, 4.85) FLEN(10.7) FCAPTION(DatDoruèení...)      CPOS(44.0,4.85) CLEN(13) PUSH(CLICKDATE)
*
**    TYPE(GET) NAME(MSSRZ_MOw->nPorUplSrz)        FPOS(83.0, 4.85) FLEN(10.7) FCAPTION(Poøadí uplSrážky...) CPOS(70.0,4.95) CLEN(13)
*    TYPE(SpinButton) NAME(MSSRZ_MOw->nPorUplSrz) FPOS(83.0, 4.85) FLEN(10.7) FCAPTION(Poøadí uplSrážky...) CPOS(70.0,4.95) CLEN(13) LIMITS(1,90)



*    TYPE(COMBOBOX) NAME(MSSRZ_MOw->nTypCastka)   FPOS(44.0, 6.2)  FLEN(12.5) VALUES( 1:Srážka v Kè,2:Srážka v %)
*    TYPE(GET) NAME(MSSRZ_MOw->nSplatka)          FPOS(57.0, 6.2)  FLEN(10.7) FCAPTION(Celkem srážka) CPOS(70,6.2)    CLEN(13)
*    TYPE(GET) NAME(MSSRZ_MOw->nCelkem)           FPOS(83.0, 6.2)  FLEN(10.7)
    
*    TYPE(GET) NAME(msSrz_mow->nNedoplat)         FPOS(57.0, 8.1)  FLEN(10.7) FCAPTION(nedoplatek)    CPOS(57.0,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
*    TYPE(GET) NAME(msSrz_mow->nSplaceno)         FPOS(70.0, 8.1)  FLEN(10.7) FCAPTION(splaceno)      CPOS(70.0,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
*    TYPE(GET) NAME(msSrz_mow->nZustatek)         FPOS(83.0, 8.1)  FLEN(10.7) FCAPTION(zùstává)       CPOS(83.0,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
*
*    TYPE(GEt) NAME(msSrz_mow->ddatZustat)        FPOS(57.0,  9)   FLEN(10.7) FCAPTION(Datum posZùst) CPOS(44.0.,9) CLEN(12)  PUSH(CLICKDATE)  

*    TYPE(GET) NAME(MSSRZ_MOw->cBank_Uct)         FPOS(54.0, 10.5) FLEN(23)   FCAPTION(ÚhradZÚètu.)   CPOS(44.0,10.5) CLEN(10)
*      TYPE(TEXT) NAME(C_BANKUC->cBank_Naz)       CPOS(78.5, 10.5) CLEN(16.5) GROUPS(SETFONT,7.Arial CE)

*    TYPE(GET) NAME(MSSRZ_MOw->cUcetI)            FPOS(54.0, 11.4) FLEN(14)   FCAPTION(Bank úèet. .)  CPOS(44.0,11.4) CLEN(10)
*    TYPE(GET) NAME(MSSRZ_MOw->cKodBanky)         FPOS(71.0, 11.4) FLEN( 6)   FCAPTION(/)             CPOS(69.5,11.5) CLEN(1.5)
*      TYPE(TEXT) NAME(C_BANKYC->cNazBanky)       CPOS(78.5, 11.3) CLEN(16)   GROUPS(SETFONT,7.Arial CE)

*    TYPE(GET) NAME(MSSRZ_MOw->cVarSym)           FPOS(54.0, 12.3) FLEN(14)   FCAPTION(VS-SS-KS)      CPOS(44  ,12.3) CLEN(10)
*    TYPE(GET) NAME(MSSRZ_MOw->cSpecSymb)         FPOS(71.0, 12.3) FLEN(14)   FCAPTION(-)             CPOS(69.5,12.3) CLEN(1.5)
*    TYPE(GET) NAME(MSSRZ_MOw->nKonstSymb)        FPOS(88.0, 12.3) FLEN( 6)   FCAPTION(-)             CPOS(86.5,12.3) CLEN(1.5)

*    TYPE(GET) NAME(MSSRZ_MOw->cTypABO)           FPOS(54.0, 13.6) FLEN(10)   FCAPTION(Typ ABO.)      CPOS(44,13.6)   CLEN(10)
*      TYPE(TEXT) NAME(C_TYPABO->cPopisABO)       CPOS(65.5, 13.6) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(GET) NAME(MSSRZ_MOw->cZkrTypZav)        FPOS(54.0, 14.5) FLEN(10)   FCAPTION(Trv.platba)    CPOS(44,14.5)   CLEN(10)
*      TYPE(TEXT) NAME(TRVALZAV->cNazevZav)       CPOS(65.5, 14.5) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(GET) NAME(MSSRZ_MOw->cZpusSraz)         FPOS(54.0, 15.4) FLEN(10)   FCAPTION(Typ srážení.)  CPOS(44,15.4)   CLEN(10)
*      TYPE(TEXT) NAME(C_ZPUSRZ->cPopisZpSr)      CPOS(65.5, 15.4) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy)         FPOS(54.0, 16.3) FLEN(10)   FCAPTION(Gen_DMZ_1)      CPOS(44,16.3)  CLEN(10)
*      TYPE(TEXT) NAME(M->cNazGenDMZ1)            CPOS(65.5, 16.3) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 
 
*    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy2)        FPOS(54.0, 17.2) FLEN(10)   FCAPTION(Gen_DMZ_2)      CPOS(44,17.2)  CLEN(10)
*      TYPE(TEXT) NAME(M->cNazGenDMZ2)            CPOS(65.5, 17.2) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy3)        FPOS(54.0, 18.1) FLEN(10)   FCAPTION(Gen_DMZ_3)      CPOS(44,18.1)  CLEN(10)
*      TYPE(TEXT) NAME(M->cNazGenDMZ3)            CPOS(65.5, 18.1) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(GET) NAME(MSSRZ_MOw->cUcet_UCT)         FPOS(54.0, 19)   FLEN(10)   FCAPTION(Úèet_zaúèt)     CPOS(44,19)    CLEN(10)
*      TYPE(TEXT) NAME(C_UCTOSN->cNaz_UCT)        CPOS(65.5, 19)   GROUPS(SETFONT,8.Arial CE) 


    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*  TYPE(End)
TYPE(End)


*TYPE(End)


*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Trvalé srážky zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
  TYPE(PushButton) POS(74.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)

TYPE(END)


