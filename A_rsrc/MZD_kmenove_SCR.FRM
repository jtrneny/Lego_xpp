TYPE(drgForm) DTYPE(10) TITLE(Kmenov� �daje zam�stnanc�) SIZE(100,25) FILE(msprc_mo)           ;
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



TYPE(Action) CAPTION(~Osoba)      EVENT(mzd_osobakmen_crd)     TIPTEXT(Po��zen� a oprava �daj� o osob�)
TYPE(Action) CAPTION(~Rodp��sl)   EVENT(mzd_rodprisl_in)       TIPTEXT(Rodinn� p��slu�n�ci)
TYPE(Action) CAPTION(d~Uchody)    EVENT(mzd_duchody_in)        TIPTEXT(Evidovan� d�chody)
TYPE(Action) CAPTION(prac~Kal)    EVENT(mzd_prackalendar_in)   TIPTEXT(Pracovn� kalend��-odpracovan� doba)
TYPE(Action) CAPTION(doc~H�zka)   EVENT(mzd_dochazkadny_in)    TIPTEXT(Doch�zka do zam�stn�n�)
TYPE(Action) CAPTION(~Pr�m�ry)    EVENT(mzd_prumerykmen_crd)   TIPTEXT(Pr�m�ry pro n�hrady a nemoc)
TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Po�izen� doklad� o mzd�)
TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypo�ten� �ist� mzda)
TYPE(Action) CAPTION(~Nemocenky)  EVENT(mzd_doklnemAll_scr)    TIPTEXT(P�ehled v�ech �erpan�ch nemocensk�ch d�vek)
TYPE(Action) CAPTION(mzd~List)    EVENT(mzd_mzdlisty_pv_scr)   TIPTEXT(Mzdov� list zam�stnance za PV)
TYPE(Action) CAPTION(~Eldp)       EVENT(mzd_eldphd_crd)        TIPTEXT(Eviden�n� list d�chodov�ho zabezpe�en�)
TYPE(Action) CAPTION(~V�pda�)     EVENT(mzd_vypdan_crd)        TIPTEXT(V�po�et ro�n� dan� - ro�n� z��tov�n�)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(d~Opl�uj�c�) EVENT(createContext_dop)     TIPTEXT(mo�nost zm�ny z�kladn�ch �daj� -mzdy-)  ICON1(338) ATYPE(33)
TYPE(Action) CAPTION(~SmlouvyDoh) EVENT(mzd_smldoh_in)         TIPTEXT(Pracovn� smlouvy a dohody - zm�ny)
TYPE(Action) CAPTION(~Zru�en�PV)  EVENT(mzd_delporprvzt_)      TIPTEXT(Zru�� pracovn� vztah - nepou�it�)


*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
TYPE(DBrowse) FPOS(0.75,1.40) SIZE(98.5,10.65) FILE(MSPRC_MO)    ;
              POPUPMENU(y) INDEXORD(9) RESIZE(yy)                ;
               FIELDS( M->ind_staVypCM::2.4::2, ;
                       M->is_Stavem::2.4::2   , ;
                       cDruPraVzt,              ;
                       nOsCisPrac,              ;
                       nPorPraVzt,              ;
                       cJmenoRozl:P��jmen�_jm�no a rozli�en� pracovn�ka:30,  ;
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
TYPE(TabPage) TTYPE(4) CAPTION(Info_Zam�st) OFFSET(1,87) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(1,12) SIZE(98.2,11.2) RESIZE(YX)

    TYPE(TEXT) CAPTION(Zp�sob vzniku PP     ...)   CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cVznPraVzt)         CPOS(20, 0.30)   CLEN(32.5) BGND(9) PP(2) 

    TYPE(TEXT) CAPTION(Pracovn� vztah         ...) CPOS( 2, 1.45)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypPraVzt)         CPOS(20, 1.35)   CLEN( 4) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_PRACVZ->cNazPraVzt)         CPOS(24.5, 1.35) CLEN(28) BGND( 9)         

    TYPE(TEXT) CAPTION(Ukon�en� prac.vzt    ...)   CPOS( 2, 2.50)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypUkoPrV)         CPOS(20, 2.40)   CLEN( 4) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_UKONPV->cNazUkoPrV)         CPOS(24.5, 2.40) CLEN(28) BGND( 9)         

    TYPE(TEXT) CAPTION(Zam�stnaneck� vzt  ...)     CPOS( 2, 3.55)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypZamVzt)         CPOS(20, 3.45)   CLEN(4)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_ZAMEVZ->cNazZamVzt)         CPOS(24.5, 3.45) CLEN(28) BGND( 9)

    TYPE(TEXT) CAPTION(Typ eviden�.stavu    ...)   CPOS( 2, 4.60)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nMimoPrVzt)         CPOS(20, 4.50)   CLEN(4)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_MIMPRV->cNazMimPrV)         CPOS(24.5, 4.50) CLEN(28) BGND( 9)

    TYPE(TEXT) CAPTION(Mzdov� kategorie    ...)    CPOS( 2, 5.65)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cMzdKatPra)         CPOS(20, 5.55)   CLEN(32.5)  BGND(9) PP(2)

    TYPE(TEXT) CAPTION(Pracovn� za�azen�    ...)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cPracZar)           CPOS(20, 6.60)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_PRACZA->cNazPracZa)         CPOS(28.5, 6.60) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Funkce pracovn�ka  ...)     CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->cFunPra)            CPOS(20, 7.65)   CLEN(8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_FUNCPR->cNazFuncPr)         CPOS(28.5, 7.65) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Typ d�chodu           ...)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nTypDuchod)         CPOS(20, 8.70)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_DUCHOD->cNazDuchod)         CPOS(28.5, 8.70) CLEN(24) BGND( 9)

    TYPE(TEXT) CAPTION(Zdrav.poji��ovna    ...)    CPOS( 2, 9.85)   CLEN(17)
     TYPE(TEXT) NAME(MSPRC_MO->nZdrPojis)          CPOS(20, 9.75)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_ZDRPOJ->cNazZdrPoj)         CPOS(28.5, 9.75) CLEN(24) BGND( 9)

*    TYPE(TEXT) CAPTION(D_vz-D_p�.uk_PV   ...)         CPOS(54, 0.40)   CLEN(15)
*     TYPE(TEXT) NAME(MSPRC_MO->dDatVznPrV)         CPOS(70, 0.30)   CLEN(10) BGND(13) PP(2)
*     TYPE(TEXT) NAME(MSPRC_MO->dDatPredVy)         CPOS(85, 0.30)   CLEN(10) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pracovi�t�        ...)      CPOS(54, 0.45)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->cNazPol4)           CPOS(70, 0.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(CNAZPOL4->cNazev)             CPOS(78.5, 0.40) CLEN(19) 

    TYPE(TEXT) CAPTION(V�platn� m�sto   ... )      CPOS(54, 1.50)   CLEN(16)
     TYPE(TEXT) NAME(MSPRC_MO->cVyplMist)          CPOS(70, 1.40)   CLEN( 8) BGND(13) PP(2)
     TYPE(TEXT) NAME(C_VYPLMI->cNazVyplMi)         CPOS(78.5, 1.40) CLEN(19) BGND( 9)

*    TYPE(TEXT) CAPTION(Da� prohl�en�  ...)        CPOS(54, 3.55)   CLEN(15)

*    TYPE(TEXT) CAPTION(V�po�et �ist� mzdy ...)     CPOS(54, 5.65)   CLEN(15)
*    TYPE(TEXT) CAPTION(V�po�et hrub� mzdy ...)     CPOS(54, 6.70)   CLEN(15)

    TYPE(TEXT) CAPTION(Dov.z�st.B/M dny ...)     CPOS(54, 7.80)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nDovBezZus  )       CPOS(70, 7.70)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nDovMinZus )        CPOS(82, 7.70)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Dov.z�st.B/M hod ...)     CPOS(54, 8.80)   CLEN(15)
     TYPE(TEXT) NAME(MSPRC_MO->nHDoBezZus  )       CPOS(70, 8.70)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
     TYPE(TEXT) NAME(MSPRC_MO->nHDoMinZus )        CPOS(82, 8.70)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

*    TYPE(TEXT) CAPTION(Odpo�it.polo�ky   ...)      CPOS(54, 8.85)   CLEN(15)
*     TYPE(TEXT) NAME(MSPRC_MO->nOdpocObd  )        CPOS(70, 8.75)   CLEN(10)  BGND(13) PP(2) CTYPE(2)
*     TYPE(TEXT) NAME(MSPRC_MO->nOdpocRok  )        CPOS(82, 8.75)   CLEN(12)  BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Da�ov� �leva      ...)      CPOS(54, 9.90)   CLEN(15)
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
                  FIELDS( cCisloSmDo:��slo sml-doh:10,     ;
                          cDruPraVzt:DruhPV:8,                   ;
                          nPorPraVzt:Po�:3,                ;
                          nTypPraVzt:Typ:4,             ;
                          M->nazPraVzt:N�zev typu prac.vztahu:20, ;
                          nTypZamVzt:TypZV,                ;
                          dDatNast,                     ;
                          dDatPredVy,                   ;
                          dDatVyst,                     ;
                          nTypUkoPrv:TypUkon�)                   ;
                  CURSORMODE(3) PP(1)

    TYPE(DBrowse) FPOS(60.10,0.2) SIZE(36.25,10.8) FILE(PRSMDOZM) INDEXORD(2)           ;
                  RESIZE(yx)                              ;
                  FIELDS( cTypZmSmDo:Typ zm�ny:10,           ;
                          cCisZmSmDo:��slo zm�ny:10,         ;
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
TYPE(TabPage) TTYPE(4) CAPTION(St�l�Sr�ky) OFFSET(25,63) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

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
TYPE(TabPage) TTYPE(4) CAPTION(Osobn��daje) OFFSET(37,51) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

    TYPE(TEXT) CAPTION(Rodn� ��slo. . . .)         CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(osoby->crodCisOsb)            CPOS(20, 0.30)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodn� jm�no. . . .)         CPOS( 2, 1.45)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cjmenoRod)             CPOS(20, 1.35)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Datum narozen�. . . .)      CPOS( 2, 2.50)   CLEN(17)
     TYPE(TEXT) NAME(osoby->ddatNaroz)             CPOS(20, 2.40)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(M�sto narozen�. . .)        CPOS( 2, 3.55)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cmistoNar)             CPOS(20, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(St�t narozen�. . . .)       CPOS( 2, 4.60)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStatNa)            CPOS(20, 4.50)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(N�rodnost . . . . .)        CPOS( 2, 5.65)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkratNar)             CPOS(20, 5.55)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(St�tn� p��slu�nost . . .)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStaPri)            CPOS(20, 6.60)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodinn� stav . . .)         CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrRodStv)            CPOS(20, 7.65)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nejvy�� dosa�en�.vzd�l. .)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrVzdel)             CPOS(20, 8.70)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Bydli�t� ulice-�.p. . )     CPOS(48, 0.40)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cUlicCiPop)            CPOS(64, 0.30)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Ps�-m�sto . .)              CPOS(54, 1.45)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cPsc)                  CPOS(64, 1.40)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cMisto)                CPOS(70, 1.40)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(st�t . . )                  CPOS(54, 2.50)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkratStat)            CPOS(64, 2.40)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(P�e.bydl ulice-�.p. . )     CPOS(48, 3.55)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cPreUliCPo)            CPOS(64, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Ps�-m�sto . .)              CPOS(54, 4.60)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cprePsc)               CPOS(64, 4.50)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cpreMisto)             CPOS(70, 4.50)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(st�t . . )                  CPOS(54, 5.65)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkrStatPr)            CPOS(64, 5.55)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Telefon1/Telefon2 . .)      CPOS(48, 6.70)   CLEN(15)
     TYPE(TEXT) NAME(osoby->ctelPriv)              CPOS(64, 6.60)   CLEN(25) BGND(13) PP(2)

  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)



* 5 - rodinn� p��slu�n�ci  --> OSOBY -> VAZOSOBY 
TYPE(TabPage) TTYPE(4) CAPTION(RodP��slu�n�ci) OFFSET(49,39) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(vazOsoby)                                   ;
                                          RESIZE(yx)                            ;
                                FIELDS( vazOsoby_osoby_Rp('ncisOsoby'):��slOsoby                , ;
                                        vazOsoby_osoby_Rp('cjmenoRozl'):P��men� a jm�no osoby:30, ;
                                        vazOsoby->ctypRodPri:typVztahu                          , ;
                                        vazOsoby_osoby_Rp('cjmenoRod'):rozen(�)                , ;
                                        vazOsoby_osoby_Rp('crodCisOsb'):rod��slo                , ;
                                        vazOsoby_osoby_Rp('ddatNaroz'):datNaroz                 , ;   
                                        vazOsoby_osoby_Rp('CMISTO'):M�sto:25                    , ;
                                        vazOsoby_osoby_Rp('CZKRATSTAT'):St�t                      ) ;
                                        CURSORMODE(3) PP(7) SCROLL(yy)

  TYPE(End)
TYPE(End)



* 6 d�chody      --> DUCHODY
TYPE(TabPage) TTYPE(4) CAPTION(D�chody)        OFFSET(61,27) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(duchody)         ;
                                          RESIZE(yx)                            ;
                                FIELDS( M->is_Aktiv:ad:2.6::2        , ;
                                        nporDuchod:po�ad�            , ;
                                        ntypDuchod:typ d�chodu       , ;
                                        cnazDuchod:n�zev typu d�chodu, ;
                                        dpriznDuOd:p�izn�n OD        , ; 
                                        dpriznDuDo:p�izn�n DO        , ;
                                        cnazev:d�chod vypl�c�:31       ) ;
                                CURSORMODE(3) PP(7) SCROLL(yy)

  TYPE(End)
TYPE(End)

* 7 pr�m�ry    --> MSVPRUM
TYPE(TabPage) TTYPE(4) CAPTION(Info_pr�m�ry)    OFFSET(73,15) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(Static) STYPE(2) CAPTION(PR�M�R NA N�HRADY A DOVOLENOU) SIZE(98,4) FPOS( 0,1) RESIZE(y)
    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,1) CLEN(10)
    TYPE(TEXT) CAPTION(Odmeny)                              CPOS(38,1) CLEN( 7)
    TYPE(TEXT) CAPTION(Dny/Hod)                             CPOS(53,1) CLEN( 7)

    TYPE(TEXT) CAPTION(Pr�m�r na HOD . . .)                 CPOS( 2  ,2) CLEN(19)
    TYPE(TEXT) CAPTION([)                                   CPOS(22  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,2) CLEN(12) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(+)                                   CPOS(35.5,2) CLEN( 2)    
    TYPE(TEXT) NAME(msvPrum->nKC_ODMcis)                    CPOS(38  ,2) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(49  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(/)                                   CPOS(51  ,2) CLEN( 2)
    TYPE(TEXT) NAME(msvPrum->nHOD_PPSUM)                    CPOS(53  ,2) CLEN( 9) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(=)                                   CPOS(61.5,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nHodPrumPP)                    CPOS(65  ,2) CLEN( 8) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(Pr�m�r na DEN . . .)                 CPOS( 2  ,3) CLEN(18)

    TYPE(TEXT) CAPTION([)                                   CPOS(22  ,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,3) CLEN(12) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(*)                                   CPOS(35.5,3) CLEN( 2)    
    TYPE(TEXT) NAME(msvPrum->nKC_ODMcis)                    CPOS(38  ,3) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(49  ,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(=)                                   CPOS(61.5,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nDenPrumPP)                    CPOS(65  ,3) FLEN( 8) PP(2) FONT(5)
  TYPE(END)


  TYPE(Static) STYPE(2) CAPTION(PR�M�R NA NEMOCENSK� D�VKY)    SIZE(98,4) FPOS( 0,6) RESIZE(y)
    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,1) CLEN( 9)
    TYPE(TEXT) CAPTION(Kd)                                  CPOS(39,1) CLEN( 3)
    TYPE(TEXT) CAPTION(Kd_AN)                               CPOS(48,1) CLEN( 6)

    TYPE(TEXT) CAPTION(D�l�.vym.z�k. . . .)                 CPOS( 2  ,2) CLEN(19)
    TYPE(TEXT) NAME(msvPrum->nKC_NMSUM)                     CPOS(21  ,2) CLEN(11) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(/)                                   CPOS(35.5,2) CLEN( 2)     
    TYPE(TEXT) CAPTION([)                                   CPOS(37  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKD_NMSUM)                     CPOS(38  ,2) CLEN( 8) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(+)                                   CPOS(45.5,2) CLEN( 2)
    TYPE(TEXT) NAME(msvPrum->nKDO_NMSUM)                    CPOS(47  ,2) CLEN( 8) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(55  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(=)                                   CPOS(56  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nDenVZhruN)                    CPOS(60  ,2) CLEN(10) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(�ist/kr�c_90% . . .)                 CPOS( 2  ,3) CLEN(19)
    TYPE(TEXT) NAME(msvPrum->nDenVZcisN)                    CPOS(23  ,3) CLEN(11)       FONT(5)
    TYPE(TEXT) NAME(msvPrum->nDenVZciKN)                    CPOS(32  ,3) CLEN( 9) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(Den_25/69k/69_% . . .)               CPOS(50  ,3) CLEN(21)
    TYPE(TEXT) NAME(msvPrum->nSazDenNiN)                    CPOS(72  ,3) CLEN( 6) PP(2) FONT(5)
    TYPE(TEXT) NAME(msvPrum->nSazDenVKN)                    CPOS(79  ,3) CLEN( 6) PP(2) FONT(5)
    TYPE(TEXT) NAME(msvPrum->nSazDenVyN)                    CPOS(86  ,3) CLEN( 6) PP(1) FONT(5)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(END)
TYPE(End)

* 8 �ist� mzda    --> MZDYHD / MZDYIT
* mzdyhd - hlavi�ky vypo�ten�ch �ist�ch mezd
TYPE(TabPage) TTYPE(4) CAPTION(�it� mzda)    OFFSET(85,3) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)
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

* mzdyit - polo�ky vzpo�ten�ch �ist�ch mezd
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
  TYPE(TEXT) CAPTION(Kmenov� �daje zam�stnanc�)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(74.50,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)
