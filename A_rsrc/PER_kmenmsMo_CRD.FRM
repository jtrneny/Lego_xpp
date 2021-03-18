TYPE(drgForm) DTYPE(10) TITLE(Kmenové údaje zamìstnancù (personalistika) ) SIZE(100,26.5) ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) POST(postValidate)
*             CARGO(MZD_kmenove_CRD)

* TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


  TYPE(Static) STYPE(13) SIZE(98,4.2) FPOS(1,0.2) RESIZE(yn)

* 1. øádek
    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, .15) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, .15) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, .15) CLEN(15)

    TYPE(GET)  NAME(msPrc_moW->cprijOsob)   FPOS( 1,1.13) FLEN(25) NOREVISION() FONT(5) PUSH(MZD_kmenove_SEL)
    TYPE(GET)  NAME(msPrc_moW->cjmenoOsob)  FPOS(28,1.13) FLEN(15) NOREVISION() FONT(5)
    TYPE(GET)  NAME(msPrc_moW->crozlJmena)  FPOS(45,1.13) FLEN(15) NOREVISION() FONT(5) 
    TYPE(GET)  NAME(msPrc_moW->ctitulPred)  FPOS(62,1.13) FLEN(15)
    TYPE(GET)  NAME(msPrc_moW->ctitulZa)    FPOS(81,1.13) FLEN(15)

* èíslo osoby
    TYPE(Text)  CAPTION([)                  CPOS( 8,2.05) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(msPrc_moW->ncisOsoby)  CPOS( 9,2.048) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
    TYPE(Text)  CAPTION(])                  CPOS(16,2.05) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

* 2. øádek
    TYPE(TEXT) FCAPTION(OsÈís/Poø)           CPOS( 1,3.01)  CLEN( 8)
     TYPE(GET)  NAME(msPrc_moW->nosCisPrac)  FPOS( 9,3.01)   FLEN( 7) PP(2) FONT(5) CTYPE(2) NOREVISION()
     TYPE(TEXT) FCAPTION(/)                  CPOS(18,3.01)   CLEN( 2)
     TYPE(TEXT) NAME(msPrc_moW->nporPraVzt)  CPOS(18.6,2.53) CLEN(10) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)
*    TYPE(TEXT) FCAPTION(poøPpv)             CPOS(17,2.83)   CLEN( 6)
*    TYPE(TEXT) NAME(msPrc_moW->nporPraVzt)  CPOS(22,2.83)   CLEN( 8) PP(2) CTYPE(3) GROUPS(SETFONT,10.Arial Black,GRA_CLR_RED) 

    TYPE(TEXT) FCAPTION(kmenStøed)           CPOS(35,2.83) CLEN( 9)
     TYPE(GET)  NAME(msPrc_moW->ckmenStrPr)  FPOS(45,2.83) FLEN( 8) PP(2) FONT(5)
     TYPE(TEXT) NAME(cnazPol1->cnazev)       CPOS(54,2.83) CLEN(22) 

    TYPE(TEXT) FCAPTION(rodné Èíslo)         CPOS(81,2.05) CLEN(15)
     TYPE(GET)  NAME(msPrc_moW->crodCisPra)  FPOS(81,2.87) FLEN(15) PP(2) FONT(5)
  TYPE(End)


* 1_TAB kmenové (E)MSPRC_MOw*
TYPE(TabPage) TTYPE(4) CAPTION(Kmenové) OFFSET(1,82) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yn)
    TYPE(TEXT) CAPTION(Druh PV. . . .)                      CPOS( 1.0, 0.44)  CLEN(12)

     TYPE(COMBOBOX) NAME(MSPRC_MOw->cDruPraVzt)              FPOS(13.0, 0.39)  FLEN(32) ;
           VALUES(  HLAVNI:HLAVNÍ pracovní vztah, +
                  VEDLEJSI:VEDLEJŠÍ pracovní vztah, +
                  HLAVSOUB:SOUBÌŽNÝ HLAVNÍ pracovní vztah, +
                  VEDLSOUB:SOUBÌZNÝ VEDLEJŠÍ pracovní vztah, +
                    DOHODA:DOHODA, +    
                  NEPRACPO:Neexistuje vazba na prac.vztah   )

    TYPE(TEXT) CAPTION(Vznik PV. . . .)                     CPOS(51.0, 0.44)  CLEN(12)
     TYPE(COMBOBOX) NAME(MSPRC_MOw->cVznPraVzt)              FPOS(63.0, 0.39)   FLEN(32) ;
           VALUES(PRAC.SML.:Pracovní smlouva,                               ;
                 JMENOVANIM:Jmenováním do funkce,                           ;
                     VOLBOU:Volbou do funkce,                               ;
                    DOHODOU:Dohodou,                                         ;
                 NEVYTVOREN:Nevytvoøen)

    TYPE(TEXT) CAPTION(Nástup OD. .)              CPOS( 1.0, 2.25)   CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatNast)           FPOS(13.0, 2.15)   FLEN(10.7)  PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(Typ PV. . . . . .)          CPOS(26.0, 2.25)   CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nTypPraVzt)         FPOS(39.0, 2.15)   FLEN(5)
     TYPE(TEXT) NAME(C_PRACVZ->cNazPraVzt)         CPOS(45.5, 2.15)   CLEN(27) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Vznik Od . . .)            CPOS(73, 2.25)     CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatVznPrV)         FPOS(83.7, 2.15)   FLEN(10.7)  PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Výstup OD. .)              CPOS( 1.0, 3.30)   CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatVyst)           FPOS(13.0, 3.20)   FLEN(10.7)  PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(Typ ukonè.PV. .)           CPOS(26.0, 3.30)   CLEN(12)
     TYPE(GET)  NAME(MSPRC_MOw->nTypUkoPrV)        FPOS(39.0, 3.20)   FLEN(5)
     TYPE(TEXT) NAME(C_UKONPV->cNazUkoPrV)         CPOS(45.5, 3.20)   CLEN(27) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Pøed.ukonè.)               CPOS(73, 3.20)     CLEN(10)
     TYPE(GET)  NAME(MSPRC_MOw->dDatPredVy)        FPOS(83.7, 3.20)   FLEN(10.7)  PUSH(CLICKDATE)

    TYPE(STATIC) STYPE(16) FPOS(.2,1) SIZE(97,4)

    TYPE(TEXT) CAPTION(Zamìstnanecký vzt. . .)    CPOS( 1.0, 5.70)   CLEN(17)
     TYPE(GET) NAME(MSPRC_MOw->nTypZamVzt)         FPOS(19.0, 5.60)   FLEN(5)
     TYPE(TEXT) NAME(C_ZAMEVZ->cNazZamVzt)         CPOS(25.5, 5.60)   CLEN(29) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Typ evidenè.stavu.  . .)   CPOS( 1.0, 6.75)   CLEN(17)
     TYPE(GET)  NAME(MSPRC_MOw->nMimoPrVzt)        FPOS(19.0, 6.65)   FLEN(5)  PUSH(MZD_mimoprvz_CRD) CTYPE(2)
     TYPE(TEXT) NAME(C_MIMPRV->cNazMimPrV)         CPOS(25.5, 6.65)   CLEN(29) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Mzdová kategorie  . . .)   CPOS( 1.0, 7.80)   CLEN(17)
    TYPE(COMBOBOX) NAME(MSPRC_MOw->cMzdKatPra)      FPOS(19.0,7.70)  FLEN(35) ;
         VALUES(DELNIK:Dìlník,                                                ;
                   THP:Techn.hospod.pracovník,                                ;
               REZIJNI:Režijní pracovník,                                     ;
                      :Nezaøazen)
    TYPE(TEXT) CAPTION(Pracovní zaøazení . . .)   CPOS( 1.0, 8.85)   CLEN(17)
     TYPE(GET)  NAME(MSPRC_MOw->cPracZar)          FPOS(19.0, 8.75)   FLEN(10)
     TYPE(TEXT) NAME(C_PRACZA->cNazPracZa)         CPOS(30.5, 8.75)   CLEN(24) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Funkce pracovníka . . .)   CPOS( 1.0,9.90)   CLEN(17)
     TYPE(GET)  NAME(MSPRC_MOw->cFunPra)           FPOS(19.0,9.80)   FLEN(10)
     TYPE(TEXT) NAME(C_FUNCPR ->cNazFuncPr)        CPOS(30.5,9.80)   CLEN(24) BGND(13) PP(3)



    TYPE(TEXT) CAPTION(Organizaèní úsek   . . .)    CPOS( 1.0,10.95)  CLEN(15)
     TYPE(GET)  NAME(MSPRC_MOw->cOrgUsek)           FPOS(19.0,10.85)   FLEN(10)
     TYPE(TEXT) NAME(C_ORGUSEK ->cNazev)            CPOS(30.5,10.85)   CLEN(24) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Pracovištì . . . . . .)    CPOS( 1.0,12.00)  CLEN(15)
     TYPE(GET)  NAME(MSPRC_MOw->cNazPol4)          FPOS(19.0,11.90)   FLEN(10)
     TYPE(TEXT) NAME(CNAZPOL4 ->cNazev)            CPOS(30.5,11.90)   CLEN(24) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Náklad.støedisko . .)      CPOS( 1.0,13.05)   CLEN(15)
     TYPE(GET)  NAME(MSPRC_MOw->cNazPol1)          FPOS(19.0,12.95)   FLEN(10)
     TYPE(TEXT) NAME(CNAZPOL1 ->cNazev)            CPOS(30.5,12.95)   CLEN(24) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Výplatní místo . )         CPOS( 1.0,14.10)   CLEN(17)
     TYPE(GET)  NAME(MSPRC_MOw->cVyplMist)         FPOS(19.0,14.00)   FLEN(10)
     TYPE(TEXT) NAME(C_VYPLMI ->cNazVyplMi)        CPOS(30.5,14.00)   CLEN(24) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Typ dùchodu . . . . . . .) CPOS( 1.0,15.15)   CLEN(17)
     TYPE(GET)  NAME(MSPRC_MOw->nTypDuchod)        FPOS(19.0,15.05)   FLEN(5)  PUSH(MZD_duchody_CRD) CTYPE(2)
     TYPE(TEXT) NAME(C_DUCHOD->cNazDuchod)         CPOS(25.5,15.05)   CLEN(29) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Zdrav.pojišovna . . . .)  CPOS( 1.0,16.20)   CLEN(17)
     TYPE(GET) NAME(MSPRC_MOw->nZdrPojis)          FPOS(19.0,16.10)   FLEN( 5)
     TYPE(TEXT) NAME(C_ZDRPOJ->cNazZdrPoj)         CPOS(25.5,16.10)   CLEN(29) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Dopoè.zdr.poj.do min. .)   CPOS( 1.0,17.25)   CLEN(17)
     TYPE(COMBOBOX) NAME(MSPRC_MOw->nZdrPojDop)    FPOS(19.0,17.15)   FLEN(35)  ;
         VALUES(0:Neprovádí se,                                                ;
                1:Odvede jen organizace,                                       ;
                2:Odvede jen pracovník,                                        ;
                3:Odvede pracovník i organizace                                ;
                4:Odvede prac.,za org.srážka ze mzdy)
    TYPE(TEXT) CAPTION(Dopoè.zdr.poj.z NV a ABS.)   CPOS( 1.0,18.30)   CLEN(17)
     TYPE(COMBOBOX) NAME(MSPRC_MOw->nZdrPojNVA)    FPOS(19.0,18.20)   FLEN(35)  ;
         VALUES(0:Neprovádí se,                                                 ;
                1:Provádí se)

*    TYPE(TEXT) CAPTION(Slevy-odpoèty . .)         CPOS( 1.0,17.25)   CLEN(17)
*     TYPE(GET) NAME(MSPRC_MOw->nOdpocObd)          FPOS(19.0,17.15)   FLEN(10) PUSH(MZD_odpocpol_CRD) CTYPE(2)
*    TYPE(TEXT) CAPTION(období)                    CPOS( 31.0,17.25)   CLEN( 7)
*     TYPE(TEXT) NAME(MSPRC_MOw->nOdpocRok)         CPOS(38.0,17.15)   CLEN(11) BGND(13) PP(3) CTYPE(2)
*    TYPE(TEXT) CAPTION(rok)                       CPOS( 50.0,17.25)   CLEN( 5)
*    TYPE(TEXT) CAPTION(Daòová úleva. .)           CPOS( 1.0,18.30)    CLEN(17)
*     TYPE(TEXT) NAME(MSPRC_MOw->nDanUlObd)         CPOS(19.0,18.20)   CLEN(11) BGND(13) PP(3) CTYPE(2)
*    TYPE(TEXT) CAPTION(období)                    CPOS( 31.0,18.30)   CLEN( 7)
*     TYPE(TEXT) NAME(MSPRC_MOw->nDanUlRok)         CPOS(38.0,18.20)   CLEN(11) BGND(13) PP(3) CTYPE(2)
*    TYPE(TEXT) CAPTION(rok)                       CPOS( 50.0,18.30)   CLEN( 5)


    TYPE(Static) STYPE(13) SIZE(39.5,16) FPOS(55.5,5.3) RESIZE(y)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanProhl)       FPOS(1.0,0.25)    FLEN(19) ;
          VALUES(T:podepsal daò.prohl.,F:podepsal daò.prohl.)            GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanPrVzt)       FPOS(20.0,0.25)   FLEN(19) ;
          VALUES(T:danit prac.vztah,F:danit prac.vztah)                  GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanRezid)      FPOS(1.0,1.25)     FLEN(19) ;
          VALUES(T:daòový rezident,F:daòový nerezident)                  GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lVypCisMzd)      FPOS(20.0,1.25)   FLEN(19) ;
          VALUES(T:zpracovat èist.mzdu,F:zpracovat èist.mzdu)            GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoSZ400)       FPOS(1.0,2.25)   FLEN(19) ;
          VALUES(T:hlídat SZ_400,F:hlídat SZ_400)                        GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypCM)       FPOS(20.0,2.25)  FLEN(19) ;
          VALUES(T:zapnut aut.vyp.ÈM,F:zapnut aut.vyp.ÈM)                GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lZaokrNa10)       FPOS(1.0,3.25)   FLEN(19) ;
          VALUES(T:zaokrouhlovat na 10,F:zaokrouhlovat na 10)            GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypHM)       FPOS(20.0,3.25)  FLEN(19) ;
          VALUES(T:zapnut aut.vyp.HM,F:zapnut aut.vyp.HM)                GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lOdborar)         FPOS(1.0,4.25)   FLEN(19) ;
          VALUES(T:èlen odborù,F:èlen odborù)                            GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypPR)       FPOS(20.0,4.25)  FLEN(19) ;
          VALUES(T:poèítat prùmìry,F:poèítat prùmìry)                    GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lStatuZast)       FPOS(1.0,5.25)   FLEN(19) ;
          VALUES(T:statutární zástupce,F:statutární zástupcem)           GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lTiskMzdLi)       FPOS(20.0,5.25)  FLEN(19) ;
          VALUES(T:zpracovat mzd.list,F:zpracovat mzd.list)              GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lImportDoc)        FPOS(1.0,6.25)  FLEN(19) ;
          VALUES(T:import do docházky,F:importov.do docházky)            GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lGenerELDP)        FPOS(20.0,6.25) FLEN(19) ;
          VALUES(T:generovat ELDP,F:generovat ELDP)                      GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lExport)        FPOS(1.0,7.25)     FLEN(19) ;
          VALUES(T:import z výroby,F:import z výroby)                    GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lTiskKontr)        FPOS(20.0,7.25) FLEN(19) ;
          VALUES(T:tisknout kontrolku,F:tisknout kontrolku)              GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lVyradANO)        FPOS(1.0,8.25)   FLEN(19) ;
          VALUES(T:povolit hro.vyøazení,F:povolit hro.vyøazení)          GROUP(12)
      TYPE(CHECKBOX) NAME(MSPRC_MOw->lDuchSp2Pi)        FPOS(20.0,8.25) FLEN(19) ;
          VALUES(T:dùchodové spoø.2 pil.,F:dùchodové spoø.2 pil.)        GROUP(12)

      TYPE(STATIC) FPOS(1.2,10.2) SIZE(38.4, 4) CAPTION( Odpoèitatelné položky ) FONT(5) RESIZE(xx)
        TYPE(TEXT) CAPTION( období                   rok )         CPOS( 14, 1) CLEN(20) 
        TYPE(TEXT) CAPTION(Slevy a odpoèty ...)         CPOS( 1  ,2)   CLEN(13.5)
          TYPE(GET)  NAME(MSPRC_MOw->nOdpocObd)         FPOS(14.5,2)   FLEN(10) PUSH(MZD_odpocpol_CRD) CTYPE(2)
          TYPE(TEXT) NAME(MSPRC_MOw->nOdpocRok)         CPOS(27  ,2)   CLEN(10) BGND(9) PP(3) CTYPE(2)

        TYPE(TEXT) CAPTION(Daòová úleva ...)            CPOS( 1  ,3)   CLEN(13.5)
          TYPE(TEXT) NAME(MSPRC_MOw->nDanUlObd)         CPOS(14.5,3)   CLEN(11) BGND(9) PP(3) CTYPE(2)
          TYPE(TEXT) NAME(MSPRC_MOw->nDanUlRok)         CPOS(27  ,3)   CLEN(10) BGND(9) PP(3) CTYPE(2)
      TYPE(End) 

    TYPE(End)

  TYPE(End)
TYPE(End)


* 4_TAB srážky (E)MSPRC_MOw (B)MSSRZ_MOw (E)MSSRZ_MOw *
TYPE(TabPage) TTYPE(4) CAPTION(Srážky) OFFSET(17,68) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yy)
    TYPE(DBrowse) FPOS(0.75,0.25) SIZE(42.00,19.40) FILE(MSSRZ_MOw) INDEXORD(1) RESIZE(yy)  ;
                  FIELDS( nPorUplSrz,     ;
                          cZkrSrazky,     ;
                          nSplatka,       ;
                          dDatOdSpl,      ;
                          dDatDoSpl,      ;
                          cUcet)          ;
                CURSORMODE(3) PP(1) GROUPS(4)


  TYPE(Static) STYPE(2) FPOS(43.4,-0.2) SIZE(52.5,19.8)  RESIZE(nn)
    TYPE(GET) NAME(MSSRZ_MOw->cZkrSrazky)        FPOS( 13.5, 0.40)   FLEN(11) NOREVISION() FONT(5) FCAPTION(Typ srážky...) CPOS(0.5, .45) CLEN(13) 
      TYPE(TEXT) NAME(C_SRAZKY->cNazSrazky)      CPOS(26.0, 0.30)   CLEN(25.5) GROUPS(SETFONT,9.Arial,GRA_CLR_RED)

    TYPE(GET) NAME(MSSRZ_MOw->cPopSrazky)        FPOS(13.5, 1.40)   FLEN(37) FCAPTION(Popis srážky...) CPOS(0.5,1.5) CLEN(13)

    TYPE(TEXT) CAPTION(Aktivní srážka.)          CPOS(0.5, 2.85)   CLEN(12)
     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lAktivSrz)    FPOS(13.5, 2.75)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 
    TYPE(TEXT) CAPTION(Pøedn.pohl. .)            CPOS(0.5, 3.90)   CLEN(13)
     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lPrednPohl)   FPOS(13.5, 3.80)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 


    TYPE(GET) NAME(MSSRZ_MOw->dDatOdSpl)         FPOS(39.5, 2.75) FLEN(10.7) FCAPTION(Srážka_OD...)        CPOS(26.5,2.85) CLEN(13) PUSH(CLICKDATE)
    TYPE(GET) NAME(MSSRZ_MOw->dDatDoSpl)         FPOS(39.5, 3.80) FLEN(10.7) FCAPTION(Srážka_DO...)        CPOS(26.5,3.9)  CLEN(13) PUSH(CLICKDATE)


    TYPE(GET) NAME(MSSRZ_MOw->dDatDorVyk)        FPOS(13.5, 4.85) FLEN(10.7) FCAPTION(DatDoruèení...)      CPOS(0.5,4.85) CLEN(13) PUSH(CLICKDATE)

*    TYPE(GET) NAME(MSSRZ_MOw->nPorUplSrz)        FPOS(83.3, 4.85) FLEN(10.7) FCAPTION(Poøadí uplSrážky...) CPOS(70.0,4.95) CLEN(13)
    TYPE(SpinButton) NAME(MSSRZ_MOw->nPorUplSrz) FPOS(39.5, 4.85) FLEN(10.7) FCAPTION(Poøadí uplSrážky...) CPOS(26.5,4.95) CLEN(13) LIMITS(1,90)

    TYPE(COMBOBOX) NAME(MSSRZ_MOw->nTypCastka)   FPOS(0.5, 6.2)  FLEN(12.5) VALUES( 1:Srážka v Kè,2:Srážka v %)
    TYPE(GET) NAME(MSSRZ_MOw->nSplatka)          FPOS(13.5, 6.2)  FLEN(10.7) FCAPTION(Celkem srážka) CPOS(26.5,6.2)    CLEN(13)
    TYPE(GET) NAME(MSSRZ_MOw->nCelkem)           FPOS(39.5, 6.2)  FLEN(10.7)
    
    TYPE(GET) NAME(msSrz_mow->nNedoplat)         FPOS(13.5, 8.1)  FLEN(10.7) FCAPTION(nedoplatek)    CPOS(13.5,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(msSrz_mow->nSplaceno)         FPOS(26.5, 8.1)  FLEN(10.7) FCAPTION(splaceno)      CPOS(26.5,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(msSrz_mow->nZustatek)         FPOS(39.5, 8.1)  FLEN(10.7) FCAPTION(zùstává)       CPOS(39.5,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)

    TYPE(GEt) NAME(msSrz_mow->ddatZustat)        FPOS(13.5,  9)   FLEN(10.7) FCAPTION(Datum posZùst) CPOS(0.5,9) CLEN(12)  PUSH(CLICKDATE)  

    TYPE(GET) NAME(MSSRZ_MOw->cBank_Uct)         FPOS(13.5, 10.5) FLEN(23)   FCAPTION(ÚhradZÚètu.)   CPOS(0.5,10.5) CLEN(10)
      TYPE(TEXT) NAME(C_BANKUC->cBank_Naz)       CPOS(38.0, 10.5) CLEN(16.5) GROUPS(SETFONT,7.Arial CE)

    TYPE(GET) NAME(MSSRZ_MOw->cUcetI)            FPOS(13.5, 11.4) FLEN(14)   FCAPTION(Bank úèet. .)  CPOS(0.5,11.4) CLEN(10)
    TYPE(GET) NAME(MSSRZ_MOw->cKodBanky)         FPOS(27.5, 11.4) FLEN( 6)   FCAPTION(/)             CPOS(26.0,11.5) CLEN(1.5)
      TYPE(TEXT) NAME(C_BANKY->cNazBanky)        CPOS(35.0, 11.4) CLEN(16)   GROUPS(SETFONT,7.Arial CE)

    TYPE(GET) NAME(MSSRZ_MOw->cVarSym)           FPOS(13.5, 12.3) FLEN(14)   FCAPTION(VS-SS-KS)      CPOS(0.5 ,12.3) CLEN(10)
    TYPE(GET) NAME(MSSRZ_MOw->cSpecSymb)         FPOS(27.5, 12.3) FLEN(14)   FCAPTION(-)             CPOS(26.0,12.3) CLEN(1.5)
    TYPE(GET) NAME(MSSRZ_MOw->nKonstSymb)        FPOS(44.5, 12.3) FLEN( 6)   FCAPTION(-)             CPOS(43.0,12.3) CLEN(1.5)

    TYPE(GET) NAME(MSSRZ_MOw->cTypABO)           FPOS(13.5, 13.5) FLEN(10)   FCAPTION(Typ ABO.)      CPOS(0.5,13.6)   CLEN(10)
      TYPE(TEXT) NAME(C_TYPABO->cPopisABO)       CPOS(25.0, 13.5) CLEN(29)   GROUPS(SETFONT,7.Arial CE) 

    TYPE(TEXT)FCAPTION(Typ trvalého závazku     ...)           CPOS( .5, 14.5) CLEN(10)
    TYPE(ComboBox) NAME(msSrz_moW->cTypPohZav) FPOS(13.5,14.6) FLEN(38) ;
                        VALUES(a,a,a,a,a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)  

*    TYPE(GET) NAME(MSSRZ_MOw->cTypPohZav)        FPOS(13.5, 14.5) FLEN(10)   FCAPTION(Trv.závazek)    CPOS(0.5,14.5)   CLEN(10)
*      TYPE(TEXT) NAME(TRVALZAV->cNazevZav)       CPOS(25.0, 14.5) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

    TYPE(GET) NAME(MSSRZ_MOw->cZpusSraz)         FPOS(13.5, 15.4) FLEN(10)   FCAPTION(Typ srážení.)  CPOS(0.5,15.4)   CLEN(10)
      TYPE(TEXT) NAME(C_ZPUSRZ->cPopisZpSr)      CPOS(25.0, 15.5) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy)         FPOS(13.5, 16.3) FLEN(10)   FCAPTION(Gen_DMZ_1)      CPOS(0.5,16.3)  CLEN(10)
      TYPE(TEXT) NAME(M->cNazGenDMZ1)            CPOS(25.0, 16.3) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 
 
    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy2)        FPOS(13.5, 17.2) FLEN(10)   FCAPTION(Gen_DMZ_2)      CPOS(0.5,17.2)  CLEN(10)
      TYPE(TEXT) NAME(M->cNazGenDMZ2)            CPOS(25.0, 17.2) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

    TYPE(GET) NAME(MSSRZ_MOw->nDruhMzdy3)        FPOS(13.5, 18.1) FLEN(10)   FCAPTION(Gen_DMZ_3)      CPOS(0.5,18.1)  CLEN(10)
      TYPE(TEXT) NAME(M->cNazGenDMZ3)            CPOS(25.0, 18.1) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

    TYPE(GET) NAME(MSSRZ_MOw->cUcet_UCT)         FPOS(13.5, 19)   FLEN(10)   FCAPTION(Úèet_zaúèt)     CPOS(0.5,19)    CLEN(10)
      TYPE(TEXT) NAME(C_UCTOSN->cNaz_UCT)        CPOS(25.0, 19)   GROUPS(SETFONT,8.Arial CE) 

*    TYPE(STATIC) STYPE(16) FPOS( 44, 1.58) SIZE(53.5,1)
    TYPE(STATIC) STYPE(16) FPOS( 0.2, 5.1) SIZE(52.0,1)
    TYPE(STATIC) STYPE(16) FPOS( 0.2, 9.3) SIZE(52.0,1)

   TYPE(End)
  TYPE(End)
TYPE(End)


* 5_1_TAB osobní OSOBYw*
TYPE(TabPage) TTYPE(4) CAPTION(Osobní) OFFSET(31,53) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) SUBTABS(A6,A7,A8) RESIZE(yy)

  TYPE(TabPage) CAPTION(Info_osoby) OFSET(1,85) TABHEIGHT(0.8) FPOS(0.8,1.50) SIZE(97,19.8) PRE(tabSelect) SUB(A6) RESIZE(yy)

    TYPE(Static) STYPE(13) SIZE(96,18.6) FPOS(.5,.2) RESIZE(yn)
      TYPE(TEXT) CAPTION(Rodné jméno. . . .)         CPOS( 1, 0.40)    CLEN(17)
       TYPE(GET) NAME(osobyW->cjmenoRod)             FPOS(19, 0.30)    FLEN(29)

      TYPE(TEXT) CAPTION(Datum narození. . . .)      CPOS( 1, 1.45)    CLEN(17)
       TYPE(GET) NAME(osobyW->ddatNaroz)             FPOS(19, 1.35)    FLEN(10.7)  PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Místo narození. . .)        CPOS( 1, 2.50)    CLEN(17)
       TYPE(GET) NAME(osobyW->cmistoNar)             FPOS(19, 2.40)    FLEN(29)

      TYPE(TEXT) CAPTION(Stát narození. . . .)       CPOS( 1, 3.55)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrStatNa)            FPOS(19, 3.45)    FLEN( 5)
       TYPE(TEXT) NAME(c_statyNar->cnazevStat)       CPOS(25.5,3.45)   CLEN(23.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Národnost . . . . .)        CPOS( 1, 4.60)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkratNar)             FPOS(19, 4.50)    FLEN(29)

      TYPE(TEXT) CAPTION(Státní pøíslušnost . . .)   CPOS( 1, 5.65)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrStaPri)            FPOS(19, 5.55)    FLEN(29)

      TYPE(TEXT) CAPTION(Rodinný stav . . .)         CPOS( 1, 6.70)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrRodStv)            FPOS(19, 6.60)    FLEN(11)
       TYPE(TEXT) NAME(C_RODSTA->cNazRodStv)         CPOS(31.5,6.60)   CLEN(17.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)  CPOS( 1, 7.75)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrVzdel)             FPOS(19, 7.65)    FLEN(11)
       TYPE(TEXT) NAME(C_VZDEL->cNazVzdela)          CPOS(31.5,7.65)   CLEN(17.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Individuální KZAM. .)       CPOS( 1, 8.80)    CLEN(17)
       TYPE(GET) NAME(osobyW->nklasZam)              FPOS(19, 8.70)    FLEN(8)
       TYPE(TEXT) NAME(C_KLAZAM->cNazKlasZa)         CPOS(28.5,8.70)  CLEN(20.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Ident.èís.osobní karty)     CPOS( 1, 10.90)   CLEN(17)
       TYPE(GET) NAME(osobyW->cIdOsKarty)            FPOS(19,10.80)    FLEN(29)

      TYPE(TEXT) CAPTION(Celkový poèet let praxe)    CPOS( 1, 11.95)  CLEN(17)
       TYPE(GET) NAME(osobyW->npocLPraxe)            FPOS(19,11.85)   FLEN(5)

      TYPE(TEXT) CAPTION(Evidovat DIM u pracovníka)  CPOS( 1,12.90)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->levidDIM)         FPOS(19,12.80)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Vedoucí pracovník)          CPOS( 1,13.95)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->lvedPrac)         FPOS(19,13.85)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Bydlištì ulice. . )         CPOS(50, 0.40)    CLEN(15)
       TYPE(GET) NAME(osobyW->cUlice)                FPOS(65, 0.30)    FLEN(29)

      TYPE(TEXT) CAPTION(Èíslo popisné. .)           CPOS(50, 1.45)    CLEN(10)
       TYPE(GET) NAME(osobyW->ccisPopis)             FPOS(65, 1.35)    FLEN(11)

      TYPE(TEXT) CAPTION(Psè. . . .)                 CPOS(54, 2.50)    CLEN(10)
       TYPE(GET) NAME(osobyW->cPsc)                  FPOS(65, 2.40)    FLEN(8)
       TYPE(TEXT) NAME(c_psc->cmisto)                CPOS(74.5,2.40)   CLEN(20.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Místo . . . . )             CPOS(54, 3.55)    CLEN(10)
       TYPE(GET) NAME(osobyW->cMisto)                FPOS(65, 3.45)    FLEN(29)

      TYPE(TEXT) CAPTION(Stát . . )                  CPOS(54, 4.60)    CLEN(10)
       TYPE(GET) NAME(osobyW->czkratStat)            FPOS(65.0, 4.50)  FLEN( 5)
       TYPE(TEXT) NAME(c_staty->cnazevStat)          CPOS(71.5,4.50)   CLEN(23.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Pøe.bydl ulice. . )         CPOS(50, 6.70)   CLEN(15)
       TYPE(GET) NAME(osobyW->cpreUlice)             FPOS(65, 6.60)   FLEN(29)

      TYPE(TEXT) CAPTION(Èíslo popisné. .)           CPOS(54, 7.75)   CLEN(10)
       TYPE(GET) NAME(osobyW->cpreCisPop)            FPOS(65, 7.65)   FLEN(11)

      TYPE(TEXT) CAPTION(Psè . . . .)                CPOS(54, 8.80)   CLEN(10)
       TYPE(GET) NAME(osobyW->cPrePsc)               FPOS(65, 8.70)   FLEN( 8)
       TYPE(TEXT) NAME(c_pscPre->cmisto)             CPOS(74.5,8.70)   CLEN(20.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Místo . . . . )             CPOS(54, 9.85)   CLEN(10)
       TYPE(GET) NAME(osobyW->cpreMisto)             FPOS(65, 9.75)   FLEN(29)

      TYPE(TEXT) CAPTION(Stát . . )                  CPOS(54,10.90)   CLEN(10)
       TYPE(GET) NAME(osobyW->czkrStatPr)            FPOS(65,10.80)   FLEN( 5)
       TYPE(TEXT) NAME(c_statyPre->cnazevStat)       CPOS(71.5,10.80) CLEN(23.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Telefon privát. . . .)      CPOS(50,13.00)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelPriv)              FPOS(65,12.90)   FLEN(29)

      TYPE(TEXT) CAPTION(Telefon zamìstnání. .)      CPOS(50,14.05)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelZames)             FPOS(65,13.95)   FLEN(29)

      TYPE(TEXT) CAPTION(Telefon mobil. . . .)       CPOS(50,15.10)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelMobil)             FPOS(65,15.00)   FLEN(29)

      TYPE(TEXT) CAPTION(E-mailová adresa. . .)      CPOS(50,16.15)   CLEN(15)
       TYPE(GET) NAME(osobyW->cEmail)                FPOS(65,16.05)   FLEN(29)

      TYPE(STATIC) STYPE(16) FPOS( 1, 9.35) SIZE(48,1)
      TYPE(STATIC) STYPE(16) FPOS(50, 5.15) SIZE(45,1)
      TYPE(STATIC) STYPE(16) FPOS(50,11.35) SIZE(45,1)
    TYPE(End)
  TYPE(END)


*  TYPE(TabPage) CAPTION(Info_osoby) OFSET(1,85) TABHEIGHT(0.8) FPOS(0.8,1.50) SIZE(97,19.8) PRE(tabSelect) SUB(A5)
  TYPE(TabPage) CAPTION(rodPøíslušníci) OFFSET(14.9,72) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A7) RESIZE(yy)

    TYPE(DBrowse) FPOS(.1,.5) SIZE(50,18.6) FILE(vazOsobyW)                           ;
                              FIELDS( vazOsobyW->ncisOsoby:èíslOsoby                , ;
                                      vazOsobyW->cjmenoRozl:Pøímení a jméno osoby:30, ;
                                      vazOsobyW->ctypRodPri:typVztahu               , ;
                                      vazOsobyW->cjmenoOsob:rozen(á)                , ;
                                      vazOsobyW->crodCisOsb:rodÈíslo                , ;
                                      vazOsobyW->ddatNaroz:datNaroz                 , ;   
                                      vazOsobyW->CMISTO:Mìsto:25                    , ;
                                      vazOsobyW->CZKRATSTAT:Stát                      ) ;
                              CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(7)


    TYPE(Static) STYPE(12) FPOS(50.4,.5) SIZE(45.8,18)  RESIZE(nn)

      TYPE(TEXT) CAPTION(Èíslo osoby )                CPOS( 1,  .5)
        TYPE(GET)  NAME(vazOsobyW->ncisOsoby)         FPOS(18,  .5) FLEN(12) PUSH(per_osoby_sel) NOREVISION()
        TYPE(PushButton)                              POS( 31,  .5) ;
                                                      SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                      CAPTION(2)

        TYPE(TEXT) NAME(osoby_Rp->cjmenoRozl)         CPOS( 2, 2  ) CTYPE(1) BGND(12) FONT(5) CLEN(40)

      TYPE(TEXT) CAPTION(rozen(á))                    CPOS( 1, 3) CLEN( 7)
        TYPE(TEXT) NAME(osoby_Rp->cjmenoOsob)         CPOS(18, 3)          FONT(5)

      TYPE(TEXT) CAPTION(Datum narození )             CPOS( 1, 4)
        TYPE(GET) NAME(vazOsobyW->ddatNaroz)          FPOS(18 ,4) FLEN(13) PP(2) FONT(5) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Rodné èíslo)                 CPOS( 1, 5)
        TYPE(GET) NAME(vazOsobyW->crodCisOsb)         FPOS(18, 5) FLEN(15)  BGND(13) FONT(5)
 
      TYPE(TEXT) CAPTION(Typ vztahu)                  CPOS( 1, 6) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->ctypRodPri)    FPOS(18, 6) FLEN(25)  REF(ctypRodPri)

      TYPE(TEXT) CAPTION(Ulatnit slevu)               CPOS( 1, 7) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->lsleOdpDan)    FPOS(18, 7) FLEN( 7)  REF( LYESNO) 

* 1 - základní údaje pro rodinné pøíslušníky
      TYPE(Static) FPOS(0.5,8.5) SIZE(44.8,6.5) CAPTION(Základní údaje) RESIZE(xx)
        TYPE(Text) CAPTION(Adresa)            CPOS( 1, 0.8) CLEN(20) FONT(5)

        TYPE(TEXT)   CAPTION(Ulice/è.p.)              CPOS( 2, 2) CLEN(10)
          TYPE(TEXT) NAME(osoby_Rp->cUlicCiPop)       CPOS(12, 2) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)                   CPOS(2,3)
          TYPE(TEXT) NAME(osoby_Rp->cmisto)           CPOS(12, 3) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                     CPOS( 2, 4) CLEN(10)
          TYPE(TEXT) NAME(osoby_Rp->cpsc)             CPOS(12, 4) CLEN( 8) BGND(13) 
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)            CPOS(22, 4) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                    CPOS( 2, 5) 
          TYPE(TEXT) NAME(osoby_Rp->czkratStat)       CPOS(12, 5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)      CPOS(22, 5) CLEN(21) BGND(13)
      TYPE(End)
    TYPE(End) 
  TYPE(END)


  TYPE(TabPage) CAPTION(Dùchody) OFFSET(27.8,59) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A8) RESIZE(yy)

    TYPE(DBrowse) FPOS(0.1,0.5) SIZE(50,18) FILE(duchodyW)               ;
                                FIELDS( M->is_Aktiv:ad:2.6::2          , ;
                                        nporDuchod:poøadí              , ;
                                        ntypDuchod:typ dùchodu         , ;
                                        M->nazDuchod:název typu dùchodu, ; 
                                        dpriznDuOd:pøiznán OD          , ; 
                                        dpriznDuDo:pøiznán DO            ) ;
                                CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(8)

    TYPE(Static) STYPE(12) FPOS(50.4,.5) SIZE(45.8,18)  RESIZE(nn)

      TYPE(TEXT)  CAPTION(Typ dùchodu ...)         CPOS( 1, .5) CLEN(10) 
       TYPE(GET)  NAME(duchodyW->ntypDuchod)       FPOS(13, .5) FLEN( 7) NOREVISION()
*       TYPE(TEXT) CAPTION(/)                       CPOS(21, .5) CLEN( 2)
*       TYPE(TEXT) NAME(duchodyW->nporDuchod)       CPOS(22, .5) CLEN( 4) PICTURE(99)
       TYPE(TEXT) NAME(c_duchod->cnazDuchod)       CPOS(22, .5)

      TYPE(TEXT)  NAME(c_duchod->cnazDuchod)       CPOS( .1, 2  ) CTYPE(1) CLEN(45) BGND(12) GROUPS(SETFONT,11.Arial,GRA_CLR_BLUE) 

      TYPE(TEXT)  CAPTION(Pøiznán _ od)            CPOS( 1, 4) CLEN(10)
       TYPE(GET)  NAME(duchodyW->dpriznDuOd)       FPOS(13, 4) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 4) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dpriznDuDo)       FPOS(33, 4) FLEN(11) PUSH(CLICKDATE)

      TYPE(TEXT)  CAPTION(Nárok _ od)              CPOS( 1, 5) CLEN(10)
       TYPE(GET)  NAME(duchodyW->dnarDuchOd)       FPOS(13, 5) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 5) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dnarDuchDo)       FPOS(33, 5) FLEN(11) PUSH(CLICKDATE)

     TYPE(TEXT) CAPTION(Aktivní dùchod)           CPOS( 1, 6) CLEN(10)
      TYPE(COMBOBOX) NAME(duchodyW->lAktiv)       FPOS(13, 6) FLEN(12) REF(LYESNO) 
*      TYPE(CHECKBOX) NAME(duchodyW->lAktiv)      FPOS(13, 6) FLEN(16) VALUES(T:aktivní dùchod,F:aktivní dùchod)


* 1 - základní údaje pro pøiznané dùchody
      TYPE(Static) FPOS(0.5,8.5) SIZE(44.8,6.5) CAPTION(vyplácející OSSZ) RESIZE(xx)
        TYPE(Text)  CAPTION(Firma  ... )          CPOS( 1, 1) CLEN(10) FONT(5)        
         TYPE(GET)  NAME(duchodyW->ncisFirmy)     FPOS(13, 1) FLEN( 7) 
         TYPE(TEXT) NAME(firmy->cnazev)           CPOS(21, 1)
           
        TYPE(TEXT)   CAPTION(Ulice/è.p.)          CPOS( 2, 2.5) CLEN(10)
         TYPE(TEXT) NAME(firmy->cUlice)           CPOS(13, 2.5) CLEN(30) BGND(13) 
         TYPE(TEXT) NAME(firmy->cSidlo)           CPOS(13, 2.5) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)               CPOS( 2, 3.5)
         TYPE(TEXT) NAME(duchodyW->cnazev)        CPOS(13, 3.5) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 4.5) CLEN(10)
          TYPE(TEXT) NAME(firmy->cpsc)            CPOS(13, 4.5) FLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_PSC_3->CMISTO)        CPOS(23, 4.5) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 5.5) 
          TYPE(TEXT) NAME(firmy->czkratStat)      CPOS(13, 5.5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_3->cNAZEVSTAT)  CPOS(23, 5.5) CLEN(21) BGND(13)
       TYPE(End)
    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(END)
TYPE(End)

* neviditelné pomocné položky
TYPE(GET) NAME(mssrz_mow->ctypSrz)    FPOS(-1,0) FLEN(0)
