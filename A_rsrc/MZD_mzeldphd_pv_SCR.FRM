TYPE(drgForm) DTYPE(10) TITLE(Eviden�n� listy d�chodov�ho poji�t�n� - dle pracovn�ch vztah�) SIZE(110,28) ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_mzeldphd_CRD) OBDOBI(MZD)


*  TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Po�izen� doklad� o mzd�)
*  TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypo�ten� �ist� mzda)


  TYPE(DBrowse) FPOS(0.75,1.40) SIZE(110,9) FILE(MSPRC_MO)    ;
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
                 CURSORMODE(3) PP(7) ITEMMARKED(itemMarked)

  TYPE(DBrowse) FPOS(-.2,10.4) SIZE(112,4.1) FILE(mzEldpHd)                  ;
                INDEXORD(6) RESIZE(yy)                                       ;
                FIELDS( M->is_odesELSSZ::2.4::2                            , ;
                        M->is_datTisk::2.4::2                              , ;
                        M->obdobi_ELDP:obd:6                               , ;
                        nOsCisPrac                                         , ;
                        nPorPraVzt                                         , ;
                        cJmenoRozl:P��jmen�_jm�no a rozli�en� pracovn�ka:32, ;
                        cRodCisPra                                         , ;
                        nTypPraVzt                                         , ;
                        nTypZamVzt                                         , ;
                        dDatNast                                           , ;
                        dDatVyst                                             ) ;
                 CURSORMODE(3) PP(9) SCROLL(n,n)


****
TYPE(Static) SIZE(110,15) FPOS( 0,14 ) RESIZE(y)

  TYPE(Static) CTYPE(13) SIZE(109,2.3) FPOS(.4,.1) RESIZE(y)
    TYPE(TEXT) FCAPTION(Za rok)                                CPOS(  2,0.5) CLEN( 8)
     TYPE(GET) NAME(mzeldphd->nrok)                           FPOS( 10,0.5) FLEN( 5) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Typ ELDP)                              CPOS( 22,0.5) CLEN( 8)
     TYPE(COMBOBOX) NAME(mzeldphd->ctypeldp)                  FPOS( 30,0.5) FLEN( 35) ;
                    VALUES(01:01 zam�stn�n� trv�,                          ;
                           02:02 zam�stn�n� ukon�eno,                      ;
                           03:03 zam�stn�n� ukon�eno smrt�,                ;
                           51:51 opravn�-zam�stn�n� trv�,                  ;
                           52:52 opravn�-zam�stn�n� ukon�eno,              ;
                           53:53 opravn�-zam�stn�n� ukon�eno smrt�,        ;
                           91:91 rekonstruovan�-zam�stn�n� trv�,           ;
                           92:92 rekonstruovan�-zam�stn�n� ukon�eno,       ;
                           93:93 rekonstruovan�-zam�stn�n� ukon�eno smrt�  )  
    TYPE(TEXT) FCAPTION(Oprava ELDP ze dne )                   CPOS( 68,0.5) CLEN( 15)
     TYPE(GET) NAME(mzeldphd->dOprELDP)                       FPOS( 85,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
    TYPE(TEXT) FCAPTION(K�d OSSZ)                              CPOS(  2,1.5) CLEN(  8)
     TYPE(GET) NAME(mzeldphd->nKodOkrSoc)                     FPOS( 10,1.5) FLEN(  6)  
    TYPE(TEXT) FCAPTION(M�stn� p��slu�n� OSSZ)                 CPOS( 19,1.5) CLEN( 16)
     TYPE(GET) NAME(mzeldphd->cNazMisSoc)                     FPOS( 36,1.5) FLEN( 60)  

  TYPE(End)

*  TYPE(Static) CTYPE(3) SIZE(109,1.2) FPOS(.4,2.6) RESIZE(y)
*    TYPE(TEXT) FCAPTION(Datum n�stupu:)                        CPOS( 15,0.5) CLEN(15) FONT(5)
*     TYPE(GET) NAME(mzeldphd->dDatNast)                       FPOS( 32,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
*    TYPE(TEXT) FCAPTION(Datum v�stupu:)                        CPOS( 65,0.5) CLEN(15) FONT(5)
*     TYPE(GET) NAME(mzeldphd->dDatVyst)                       FPOS( 82,0.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
*  TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,6.2) FPOS(.4,2.6) RESIZE(y)
    TYPE(TEXT) FCAPTION(P��jmen�)                              CPOS(  1,0.5) CLEN( 8)
     TYPE(GET) NAME(mzeldphd->cPrijOsob)                      FPOS(  1,1.5) FLEN(25) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Jm�no)                                 CPOS( 28,0.5) CLEN( 8)
     TYPE(GET) NAME(mzeldphd->cJmenoOsob)                     FPOS( 28,1.5) FLEN(25) PP(2) FONT(5)
    TYPE(TEXT) FCAPTION(Titul)                                 CPOS( 55,0.5) CLEN( 8)
     TYPE(GET) NAME(mzeldphd->cTitulPrac)                     FPOS( 55,1.5) FLEN(14) PP(2) 
    TYPE(TEXT) FCAPTION(Datum narozen�)                        CPOS( 71,0.5) CLEN(14)
     TYPE(GET) NAME(mzeldphd->dDatNaroz)                      FPOS( 71,1.5) FLEN(12) PUSH(CLICKDATE)
    TYPE(TEXT) FCAPTION(Rodn� ��slo)                           CPOS( 85,0.5) CLEN(10)
     TYPE(GET) NAME(mzeldphd->cRodCisPra)                     FPOS( 85,1.5) FLEN(12) PP(2) FONT(5)    
    TYPE(TEXT) FCAPTION(Ulice)                                 CPOS(  1,2.5) CLEN( 9)
     TYPE(GET) NAME(mzeldphd->cUlice)                         FPOS(  1,3.5) FLEN(52)   
    TYPE(TEXT) FCAPTION(��slo domu)                            CPOS( 55,2.5) CLEN(10)
     TYPE(GET) NAME(mzeldphd->cCisPopis)                      FPOS( 55,3.5) FLEN(14) 
    TYPE(TEXT) FCAPTION(Rodn� p��jmen�)                        CPOS( 71,2.5) CLEN(15)
     TYPE(GET) NAME(mzeldphd->cJmenoRod)                      FPOS( 71,3.5) FLEN(25)
    TYPE(TEXT) FCAPTION(Obec:)                                 CPOS(  1,4.5) CLEN( 9)
     TYPE(GET) NAME(mzeldphd->cMisto)                         FPOS(  1,5.5) FLEN(42) 
    TYPE(TEXT) FCAPTION(po�ta:)                                CPOS( 45,4.5) CLEN( 7)
     TYPE(GET) NAME(mzeldphd->cPosta)                         FPOS( 45,5.5) FLEN( 8)   
    TYPE(TEXT) FCAPTION(ps�:)                                  CPOS( 55,4.5) CLEN( 4)
     TYPE(GET) NAME(mzeldphd->cPsc)                           FPOS( 55,5.5) FLEN( 8)   
    TYPE(TEXT) FCAPTION(St�t:)                                 CPOS( 65,4.5) CLEN( 5)
     TYPE(GET) NAME(mzeldphd->cZkratStat)                     FPOS( 65,5.5) FLEN( 4)
    TYPE(TEXT) FCAPTION(M�sto narozen�)                        CPOS( 71,4.5) CLEN(15)
     TYPE(GET) NAME(mzeldphd->cMistoNar)                      FPOS( 71,5.5) FLEN(25)
   TYPE(End)

  TYPE(Static) CTYPE(2) SIZE(109,4.2) FPOS(.4,9) RESIZE(y)
    TYPE(TEXT) FCAPTION(K�d)                              CPOS(  1,0.5) CLEN( 5)
    TYPE(TEXT) FCAPTION(MR)                               CPOS(  9,0.5) CLEN( 4)
    TYPE(TEXT) FCAPTION(Od)                               CPOS( 17,0.5) CLEN( 5)
    TYPE(TEXT) FCAPTION(Do)                               CPOS( 24,0.5) CLEN( 5)
    TYPE(TEXT) FCAPTION(Dny)                              CPOS( 31,0.5) CLEN( 5)
    TYPE(TEXT) FCAPTION(1)                                CPOS( 38,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(2)                                CPOS( 41,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(3)                                CPOS( 44,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(4)                                CPOS( 47,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(5)                                CPOS( 50,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(6)                                CPOS( 53,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(7)                                CPOS( 56,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(8)                                CPOS( 59,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(9)                                CPOS( 62,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(10)                               CPOS( 65,0.5) CLEN( 3)
    TYPE(TEXT) FCAPTION(11)                               CPOS( 68,0.5) CLEN( 3)
    TYPE(TEXT) FCAPTION(12)                               CPOS( 71,0.5) CLEN( 3)
    TYPE(TEXT) FCAPTION(R)                                CPOS( 74,0.5) CLEN( 2)
    TYPE(TEXT) FCAPTION(VylDob)                           CPOS( 77,0.5) CLEN( 6)
    TYPE(TEXT) FCAPTION(Vym��Z�kl)                        CPOS( 84,0.5) CLEN( 8)
    TYPE(TEXT) FCAPTION(Ode)                              CPOS( 94,0.5) CLEN( 4)

     TYPE(GET)      NAME(mzeldphd->cR1_Kod)                  FPOS(  1,1.5) FLEN( 4)
     TYPE(COMBOBOX) NAME(mzeldphd->lR1_MR)                   FPOS(  7,1.6) FLEN( 7)  REF( LYESNO) 
     TYPE(GET)      NAME(mzeldphd->cR1_Od)                   FPOS( 16,1.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->cR1_Do)                   FPOS( 23,1.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->nR1_Dny)                  FPOS( 31,1.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd01)                FPOS( 38,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd02)                FPOS( 41,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd03)                FPOS( 44,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd04)                FPOS( 47,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd05)                FPOS( 50,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd06)                FPOS( 53,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd07)                FPOS( 56,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd08)                FPOS( 59,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd09)                FPOS( 62,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd10)                FPOS( 65,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd11)                FPOS( 68,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Obd12)                FPOS( 71,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR1_Rok)                  FPOS( 74,1.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->nR1_VylDob)               FPOS( 78,1.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->nR1_VymZak)               FPOS( 83,1.5) FLEN( 9)
     TYPE(GET)      NAME(mzeldphd->nR1_DobOde)               FPOS( 94,1.5) FLEN( 3)

     TYPE(GET)      NAME(mzeldphd->cR2_Kod)                  FPOS(  1,2.5) FLEN( 4)
     TYPE(COMBOBOX) NAME(mzeldphd->lR2_MR)                   FPOS(  7,2.6) FLEN( 7)  REF( LYESNO) 
     TYPE(GET)      NAME(mzeldphd->cR2_Od)                   FPOS( 16,2.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->cR2_Do)                   FPOS( 23,2.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->nR2_Dny)                  FPOS( 31,2.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd01)                FPOS( 38,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd02)                FPOS( 41,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd03)                FPOS( 44,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd04)                FPOS( 47,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd05)                FPOS( 50,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd06)                FPOS( 53,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd07)                FPOS( 56,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd08)                FPOS( 59,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd09)                FPOS( 62,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd10)                FPOS( 65,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd11)                FPOS( 68,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Obd12)                FPOS( 71,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR2_Rok)                  FPOS( 74,2.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->nR2_VylDob)               FPOS( 78,2.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->nR2_VymZak)               FPOS( 83,2.5) FLEN( 9)
     TYPE(GET)      NAME(mzeldphd->nR2_DobOde)               FPOS( 94,2.5) FLEN( 3)

     TYPE(GET)      NAME(mzeldphd->cR3_Kod)                  FPOS(  1,3.5) FLEN( 4)
     TYPE(COMBOBOX) NAME(mzeldphd->lR3_MR)                   FPOS(  7,3.6) FLEN( 7)  REF( LYESNO) 
     TYPE(GET)      NAME(mzeldphd->cR3_Od)                   FPOS( 16,3.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->cR3_Do)                   FPOS( 23,3.5) FLEN( 5)
     TYPE(GET)      NAME(mzeldphd->nR3_Dny)                  FPOS( 31,3.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd01)                FPOS( 38,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd02)                FPOS( 41,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd03)                FPOS( 44,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd04)                FPOS( 47,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd05)                FPOS( 50,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd06)                FPOS( 53,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd07)                FPOS( 56,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd08)                FPOS( 59,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd09)                FPOS( 62,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd10)                FPOS( 65,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd11)                FPOS( 68,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Obd12)                FPOS( 71,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->cR3_Rok)                  FPOS( 74,3.5) FLEN( 1)
     TYPE(GET)      NAME(mzeldphd->nR3_VylDob)               FPOS( 78,3.5) FLEN( 3)
     TYPE(GET)      NAME(mzeldphd->nR3_VymZak)               FPOS( 83,3.5) FLEN( 9)
     TYPE(GET)      NAME(mzeldphd->nR3_DobOde)               FPOS( 94,3.5) FLEN( 3)

  TYPE(End)
TYPE(End)
****



*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.2,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Kmenov� �daje zam�stnanc�)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)

