TYPE(drgForm) DTYPE(10) TITLE(Druhy mezd) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) POST(postValidate)


* TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


* 1_TAB základní
TYPE(TabPage) TTYPE(4) CAPTION(Základní) OFFSET(1,82) 
*  TYPE(Static) STYPE(13) SIZE(98,2.6) FPOS(1,0.3) RESIZE(y)
  TYPE(Static) CTYPE(2) SIZE(109,2.6) FPOS(0.4,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(druhMzdy)                              CPOS( 2,0.5) CLEN( 8)
    TYPE(TEXT) FCAPTION(Název druhu mzdy)                      CPOS(12,0.5) CLEN(30)
    TYPE(TEXT) FCAPTION(Zkratka)                               CPOS(55,0.5) CLEN( 8)
    TYPE(TEXT) FCAPTION(Typ oprávnìní)                         CPOS(86,0.5) CLEN( 8)

     TYPE(GET) NAME(DruhyMZDw->nDruhMZDY)                      FPOS( 2,1.55) FLEN( 6) PP(2) FONT(5) 
     TYPE(GET) NAME(DruhyMZDw->cNazevDMz)                      FPOS(12,1.55) FLEN(39) PP(2) FONT(5) 
     TYPE(GET) NAME(DruhyMZDw->cZkratDMZ)                      FPOS(55,1.55) FLEN( 8) PP(2) FONT(5) 
     TYPE(COMBOBOX) NAME(DruhyMZDw->cID)                       FPOS(86,1.55) FLEN(20) ;
                    VALUES( DIST:distribuèní,                                 ;
                            USER:uživatelský                                  )  

  TYPE(End)
  
  TYPE(Static) CTYPE(2) FPOS(0.4,3.2) SIZE(109,20)  RESIZE(y)
    TYPE(TEXT) FCAPTION(Druhý název DMZ    ...)                CPOS( 1, 1) CLEN(19) FONT(2)
     TYPE(GET) NAME(DruhyMZDw->cNazev2DMz)                     FPOS(21, 1) FLEN(30) PP(2) FONT(5) 

    TYPE(TEXT)FCAPTION(Typ druhu mzdy                ...)      CPOS( 1, 2.1) CLEN(19) FONT(2)
     TYPE(GET)  NAME(DruhyMZDw->cTypDMz)                       FPOS(21, 2.1) FLEN( 8) PP(2) FONT(5) 
     TYPE(TEXT) NAME(c_typDmz->cnazTypDmz)                     CPOS(31, 2  ) CLEN(30) FONT(2)

    TYPE(TEXT)FCAPTION(Deník mzdy                ...)          CPOS( 1, 3.2) CLEN(19) FONT(2)
    TYPE(COMBOBOX) NAME(DruhyMZDw->cdenik)                     FPOS(21, 3.2) FLEN(31) ;
                   VALUES( MH:hrubá mzda,                      ;
                           MN:nemocenská,                      ;
                           MS:srážka ze mzdy,                  ;        
                           MC:èistá mzda-vypoètená             )               


    TYPE(TEXT)FCAPTION(Typ trvalého závazku     ...)           CPOS( 1, 4.3) CLEN(19) FONT(2)
      TYPE(ComboBox) NAME(DruhyMZDw->cTypPohZav) FPOS(21,4.3) FLEN(31) ;
                      VALUES(a,a,a,a,a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)  
*      TYPE(GET) NAME(DruhyMZDw->cTypPohZav)                     FPOS(21, 4.3) FLEN(24) PP(2) FONT(5) 

*     TYPE(CHECKBOX) NAME(druhyMzdw->lAutoVypHM)                  FPOS(21, 5.3)  FLEN(29) ;
*          VALUES(T:    automatický výpoèet hrubé mzdy,F:    automatický výpoèet hrubé mzdy)     


    TYPE(TEXT)     FCAPTION(Aut.výpoèet HM ...)                CPOS( 1,5.4) CLEN(20) FONT(2)
     TYPE(COMBOBOX) NAME(druhyMzdw->lAutoVypHM)                FPOS(21,5.4) FLEN(31) REF( LYESNO)


    TYPE(TEXT)     FCAPTION(Aktivní   ...)                     CPOS(55, 1) CLEN(20) FONT(2)
     TYPE(COMBOBOX) NAME(druhyMzdW->lAktivni)                  FPOS(75, 1) FLEN(31) REF( LYESNO)


    TYPE(STATIC) STYPE(16)  FPOS(.2,1.5) SIZE(108,5.4)   


    TYPE(TEXT)     FCAPTION(Dopoèet hod z dnù  ...)            CPOS( 1, 7.1) CLEN(20) FONT(2)
     TYPE(COMBOBOX) NAME(druhyMzdW->lhodZdnu)                  FPOS(21, 7.1) FLEN(31) REF( LYESNO)

    TYPE(TEXT) FCAPTION(Typ dovolené   ...)                    CPOS( 1, 8.2) CLEN(19) FONT(2)
     TYPE(COMBOBOX) NAME(DruhyMZDw->nTypDovol)                 FPOS(21, 8.2) FLEN(31) ;
                    VALUES( 0:DMZ není dovolená,                                    ;
                            1:dovolená bìžný rok,                                   ;
                            2:dovolená minulý rok,                                  ;
                            3:proplacená dovolená,                                  ;
                            4:dodatková dovol.bìžný rok,                            ;
                            5:dodatková dovol.minul.rok )  

    TYPE(TEXT)     FCAPTION(Vylouèená doba  ...)               CPOS( 1, 9.3) CLEN(20) FONT(2)
     TYPE(COMBOBOX) NAME(druhyMzdW->lVylouDoba)                  FPOS(21, 9.3) FLEN(31) REF( LYESNO)

    TYPE(TEXT)     FCAPTION(Vyl.doba-ochr.doba ...)            CPOS( 1, 10.4) CLEN(20) FONT(2)
     TYPE(COMBOBOX) NAME(druhyMzdW->lVyloDobOD)                  FPOS(21,10.4) FLEN(31) REF( LYESNO)

    TYPE(TEXT) FCAPTION(Skupina pro VypPás ...)                CPOS( 1, 11.5) CLEN(19) FONT(2)
     TYPE(GET) NAME(DruhyMZDw->cPolVyplPa)                     FPOS(21, 11.5) FLEN(30) PP(2) FONT(5) 

  TYPE(End)
TYPE(End)


* 2_TAB hrubé mz
TYPE(TabPage) TTYPE(4) CAPTION(Hrubé mzdy) OFFSET(17,68)
  TYPE(Static) CTYPE(2) SIZE(109,2.6) FPOS(0.4,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(druhMmzdy)                            CPOS( 2,0.5) CLEN(10)
    TYPE(TEXT) FCAPTION(Název druhu mzdy)                     CPOS(12,0.5) CLEN(17)

     TYPE(TEXT) NAME(DruhyMZDw->nDruhMZDY)                      CPOS( 2,1.55) CLEN( 7) BGND(12) FONT(5) 
     TYPE(TEXT) NAME(DruhyMZDw->cNazevDMz)                      CPOS(12,1.55) CLEN(50) BGND(12) FONT(5) 
  TYPE(End)

  
  TYPE(Static) CTYPE(2) FPOS(0.4,3.2) SIZE(109,20) RESIZE(y)
    TYPE(TEXT) FCAPTION(Typ výpoètu HM                  ...)   CPOS( 1, 1) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nTypVypHM)                FPOS(23, 1) FLEN(54) ;
         VALUES( 0:neprovádí se,                                      ;
                 1:hodiny * sazba,                                    ;
                 2:množství práce * sazba,                            ;
                 3:dny(PD) * sazba,                                   ;
                 4:hrubá mzda = sazba,                                ;
                 5:hrubá mzda = sazba * Koef_1,                       ; 
                 6:dny(KD) * sazba                                    ;
               )    

    TYPE(TEXT) FCAPTION(Zpùsob nulování                 ...)   CPOS( 1,2.1) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nNulVypHM)                FPOS(23,2.1) FLEN(54) ;
         VALUES( 0:nic se nenuluje,                                   ;
                 1:nuluje se sazba a hrubá mzda,                      ;
                 2:nulují se dny,                                     ;
                 3:nulují se hodiny,                                  ;
                 4:nulují se dny a hodiny,                            ;
                 5:nulují se dny; sazba a hrubá mzda,                 ;
                 6:nulují se hodiny; sazba a hrubá mzda)   
  
    TYPE(TEXT) FCAPTION(Pøevzetí sazby                   ...)  CPOS( 1,3.2) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nSazbaVyHM)               FPOS(23,3.2) FLEN(54) ;
         VALUES( 0: 0- z 'D' (D - znamená doklad),                        ;
                 1: 1- D=0 => z ØZ_1,                                     ; 
                 2: 2- ØZ_1 (ØZ_1 - znamená øídíc.zn.1),                  ;
                 3: 3- D=0 => z ØZ_1 a prém. z ØZ_2,                      ;
                 4: 4- z ØZ_1 a prém. z ØZ_2,                             ;
                 5: 5- D=0 => z ZA_1(ØZ_1*Koef_1),                        ;
                 6: 6- ZA_1(ØZ_1 * Koef_1),                               ;               
                 7: 7- (ZA_1(ØZ_1/PD)+SV) * dny,                          ;
                 8: 8- D=0 => (ZA_1(ØZ_1/PD)+SV) + ØZ_2,                  ;
                 9: 9- D=0 => (ZA_1(ØZ_1/PD)+SV),                         ;
                10:10-D=0 => (ZA_1(ØZ_1/PD))+(ZA_2(ØZ_2/PD)+ØZ_3),        ;
                11:11-ZA_2(ZA_1(ØZ_1/FHod)*hod),                          ;
                12:12-D=0 => Koef_1,                                      ; 
                13:13-Koef_1 (Koef_1 - znamená koeficient X),             ;
                14:14-D=0 => ØZ_1 a pøepoè. (sazba/PD+SV),                ;
                15:15-D=0 => ØZ_1 a pøepoè. (sazba/FHod),                 ; 
                16:16-D=0 =>,                                             ;
                17:17-D=0 =>,                                             ;
                18:18-ZA_3(ZA_2((ZA_1(ØZ_1/PD)+SV)*dny) * %prém.z ØZ_2),  ;
                19:19-D=0 => (ZA_1(ØZ_1/PD)+SV) + ØZ_2 a prém. z ØZ_2,    ;
                20:20-D=0 => (ZA_1(ØZ_1/PD)+SV) a prém. z ØZ_2,           ; 
                21:21-D=0 => (ZA_1(ØZ_1/PD))+(ZA_2(ØZ_2/PD)+ØZ_3) a prém. z ØZ_2,    ;
                22:22-ZA_2(ZA_1(ØZ_1/FHod)*hod) a prém. z ØZ_2,           ;
                23:23-HM za podmín. min. odbHV * %prém. z ØZ_1,           ; 
                24:24-ZA_2(ZA_1(ØZ_1/FHod-Sv)*hod),                       ;
                25:25-ZA_3(ZA_2(ZA_1(ØZ_1/FHod-Sv)*hod)*%prém.z ØZ_2),    ;
                27:27-D=0 => ZA_1(koef1 * ØZ_1) > koef2;  Koef2,          ;
                28:28- ((Koef_1/PD)+SV) * dny                             ;
               )
  
    TYPE(TEXT) FCAPTION(Zpùsob nápoètu HM                 ...) CPOS( 1,4.3) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nNapocHM)                 FPOS(23,4.3) FLEN(54) ;
         VALUES( 0:0- zapoèítávají se DNY HODINY KÈ,                     ;
                 1:1- zapoèítávají se KÈ,                                ; 
                 2:2- zapoèítávají se DNY,                               ;
                 3:3- zapoèítávají se HODINY,                            ;
                 4:4- zapoèítávají se DNY HODINY,                        ;
                 5:5- zapoèítávají se DNY KÈ,                            ;
                 6:6- zapoèítávají se HODINY KÈ,                         ;               
                 7:7- zapoèítávají se jen kalendáøní DNY,                ;
                 8:8- nezapoèítává se NIC)
  
    TYPE(TEXT) FCAPTION(Nápoèet do fondu prac.doby   ..)       CPOS( 1,5.4) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nNapocFPD)                FPOS(23,5.4) FLEN(54) ;
         VALUES( 0:nezapoèítává se,                                   ;
                 1:zapoèítává se do fondu pracovní doby [PD],         ;
                 2:zapoèítává se do fondu kalendáøní doby [KD],       ;  
                 3:zapoèítává se do fondu kal.a prac.doby [KD+PD])    

    TYPE(TEXT) FCAPTION(Nápoèet do hod prùmìru   ...)          CPOS( 1,6.5) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nNapocPrHM)               FPOS(23,6.5) FLEN(54) ;
         VALUES( 0:nezapoèítává se,                                   ;
                 1:zapoèítává se do prùmìru)    

    TYPE(TEXT) FCAPTION(Napoè prémií z HV              ...)    CPOS( 1,7.6) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nNapocHVPr)               FPOS(23,7.6) FLEN(54) ;
         VALUES( 0:nezapoèítává se,                                   ;
                 1:zapoèítává se do HV)    

    TYPE(TEXT)FCAPTION(Autom prémie VYP-DMZ     ...)           CPOS( 1,8.7) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->nTypVypPre)               FPOS(23,8.7) FLEN(40) ;
         VALUES( 0:výpoèet se neprovádí,                              ;
                 1:proc. z hrubé mzdy,                                ; 
                 2:proc. ze základní sazby * dny,                     ;
                 3:proc. ze základní sazby * hodiny,                  ;
                 4:proc. ze základní sazby * množství)
     TYPE(GET) NAME(DruhyMZDw->nDruhMzPRE)                     FPOS(64,8.7) FLEN(12) PP(2) FONT(5) PUSH(MZD_druhyMzd_SEL) 

    TYPE(TEXT) FCAPTION(Øídící znak_1 pro výpoèet HM ...)      CPOS( 1,9.8) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->cRZn1_VyHm)               FPOS(23,9.8) FLEN(54) ;
         VALUES(                      :nepøebírá se,                                      ;  
                 fSazTAR(fDatPor())[2]:mìsíèní sazba,                                     ;
                 fSazTAR(fDatPor())[1]:hodinová sazba,                                    ; 
                 fSazPRM("nDenPrumPP"):denní prùmìr,                                      ;
                 fSazPRM("nHodPrumPP"):hodinový prùmìr,                                   ;
                 fSazZAM("SAZOSOOHODw"):osobní ohodnocení,                                ;
                 fSazZAM("PRCPREHLCIw"):procento prémií,                                  ;
                 fSazZAM("PRCPODNAHVw"):procento prémií na HV,                            ;
                 fSazPRM("nHodPrumNA"):hodinový prùmìr nemoc.náhrady,                     ;
                 fSazPRM("nSazDenH_2"):hodinová sazba nemocenská-náhrada(60%),            ;
                 fSazPRM("nSazDenN_2"):denní sazba nemocenská-náhrada(60%),               ;
                 fSazPRM("nSazDenM_2"):denní sazba mateøská(70%),                         ;
                 fSazPRM("nDenVZcisN"):denní vymìøovací základ nemoc-èistý,               ;
                 fSazPRM("nDenVZcikN"):denní vymìøovací základ nemoc-èistý po redukci     ;
               )
    TYPE(TEXT) FCAPTION(Øídící znak_2 pro výpoèet HM ...)       CPOS( 1,10.9) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->cRZn2_VyHm)                FPOS(23,10.9) FLEN(54) ;
         VALUES(                      :nepøebírá se,                                      ;  
                 fSazTAR(fDatPor())[2]:mìsíèní sazba,                                     ;
                 fSazTAR(fDatPor())[1]:hodinová sazba,                                    ; 
                 fSazPRM("nDenPrumPP"):denní prùmìr,                                      ;
                 fSazPRM("nHodPrumPP"):hodinový prùmìr,                                   ;
                 fSazZAM("SAZOSOOHODw"):osobní ohodnocení,                                ;
                 fSazZAM("PRCPREHLCIw"):procento prémií,                                  ;
                 fSazZAM("PRCPODNAHVw"):procento prémií na HV,                            ;
                 fSazPRM("nHodPrumNA"):hodinový prùmìr nemoc.náhrady,                     ;
                 fSazPRM("nSazDenH_2"):hodinová sazba nemocenská-náhrada(60%),            ;
                 fSazPRM("nSazDenN_2"):denní sazba nemocenská(60%),                       ;
                 fSazPRM("nSazDenM_2"):denní sazba mateøská(70%),                         ;
                 fSazPRM("nDenVZcisN"):denní vymìøovací základ nemoc-èistý,               ;
                 fSazPRM("nDenVZcikN"):denní vymìøovací základ nemoc-èistý po redukci     ;
               )

    TYPE(TEXT) FCAPTION(Øídící znak_3 pro výpoèet HM ...)       CPOS( 1,12.0) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->cRZn3_VyHm)                FPOS(23,12.0) FLEN(54) ;
         VALUES(                      :nepøebírá se,                                      ;  
                 fSazTAR(fDatPor())[2]:mìsíèní sazba,                                     ;
                 fSazTAR(fDatPor())[1]:hodinová sazba,                                    ; 
                 fSazPRM("nDenPrumPP"):denní prùmìr,                                      ;
                 fSazPRM("nHodPrumPP"):hodinový prùmìr,                                   ;
                 fSazZAM("SAZOSOOHODw",fDatPor()):osobní ohodnocení,                      ;
                 fSazZAM("PRCPREHLCIw",fDatPor()):procento prémií,                        ;
                 fSazZAM("PRCPODNAHVw",fDatPor()):procento prémií na HV,                  ;
                 fSazPRM("nHodPrumNA"):hodinový prùmìr nemoc.náhrady,                     ;
                 fSazPRM("nSazDenH_2"):hodinová sazba nemocenská-náhrada(60%),            ;
                 fSazPRM("nSazDenN_2"):denní sazba nemocenská(60%),                       ;
                 fSazPRM("nSazDenM_2"):denní sazba mateøská(70%),                         ;
                 fSazPRM("nDenVZcisN"):denní vymìøovací základ nemoc-èistý,               ;
                 fSazPRM("nDenVZcikN"):denní vymìøovací základ nemoc-èistý po redukci     ;
               )

    TYPE(TEXT) FCAPTION(Øídící znak_4 pro výpoèet HM ...)      CPOS( 1,13.1) CLEN(21)
      TYPE(COMBOBOX) NAME(DruhyMZDw->cRZn4_VyHm)               FPOS(23,13.1) FLEN(54) ;
         VALUES(                      :nepøebírá se,                                      ;  
                 fSazTAR(fDatPor())[2]:mìsíèní sazba,                                     ;
                 fSazTAR(fDatPor())[1]:hodinová sazba,                                    ; 
                 fSazPRM("nDenPrumPP"):denní prùmìr,                                      ;
                 fSazPRM("nHodPrumPP"):hodinový prùmìr,                                   ;
                 fSazZAM("SAZOSOOHODw"):osobní ohodnocení,                                ;
                 fSazZAM("PRCPREHLCIw"):procento prémií,                                  ;
                 fSazZAM("PRCPODNAHVw"):procento prémií na HV,                            ;
                 fSazPRM("nHodPrumNA"):hodinový prùmìr nemoc.náhrady,                     ;
                 fSazPRM("nSazDenH_2"):hodinová sazba nemocenská-náhrada(60%),            ;
                 fSazPRM("nSazDenN_2"):denní sazba nemocenská(60%),                       ;
                 fSazPRM("nSazDenM_2"):denní sazba mateøská(70%),                         ;
                 fSazPRM("nDenVZcisN"):denní vymìøovací základ nemoc-èistý,               ;
                 fSazPRM("nDenVZcikN"):denní vymìøovací základ nemoc-èistý po redukci     ;
               )

    TYPE(TEXT)FCAPTION(Zpùsob zaokrouhlouhlení   ...)          CPOS( 1,14.2) CLEN(21)
     TYPE(GET) NAME(DruhyMZDw->nKodZaokr)                      FPOS(23,14.2) FLEN( 6) PP(2) FONT(5) 
     TYPE(TEXT) NAME(c_zaokrA->cPopisZaok)                     CPOS(31,14.2) CLEN(40)

    TYPE(TEXT)FCAPTION(Koeficinet pro pøep_HM      ...)        CPOS( 1,15.3) CLEN(21)
     TYPE(GET) NAME(DruhyMZDw->nKoefPreHM)                     FPOS(23,15.3) FLEN( 6) PP(2) FONT(5) 


    TYPE(TEXT) FCAPTION(Koeficienty pro výpoèet hrubých mezd ...) CPOS( 1, 17) CLEN(50) FONT(2) 

    TYPE(TEXT) FCAPTION(Koef_1      ...)                          CPOS( 1,18.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nKoe1_VyHm)                        FPOS(14,18.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Koef_2      ...)                          CPOS(28,18.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nKoe2_VyHm)                        FPOS(41,18.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Koef_3      ...)                          CPOS(55,18.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nKoe3_VyHm)                        FPOS(68,18.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Koef_4      ...)                          CPOS(82,18.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nKoe4_VyHm)                        FPOS(95,18.1) FLEN( 9) PP(2) FONT(5) 


    TYPE(TEXT) FCAPTION(Zaok_1      ...)                          CPOS( 1,19.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nZao1_VyHm)                        FPOS(14,19.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Zaok_2      ...)                          CPOS(28,19.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nZao2_VyHm)                        FPOS(41,19.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Zaok_3      ...)                          CPOS(55,19.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nZao3_VyHm)                        FPOS(68,19.1) FLEN( 9) PP(2) FONT(5) 
    TYPE(TEXT) FCAPTION(Zaok_4      ...)                          CPOS(82,19.1) CLEN(13)
     TYPE(GET) NAME(DruhyMZDw->nZao4_VyHm)                        FPOS(95,19.1) FLEN( 9) PP(2) FONT(5) 


  TYPE(End)
TYPE(End)


* 3_TAB èisté mz
TYPE(TabPage) TTYPE(4) CAPTION(Èisté mzdy) OFFSET(31,53)
  TYPE(Static) CTYPE(2) SIZE(109,2.6) FPOS(0.4,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(druhMmzdy)                            CPOS( 2,0.5) CLEN(10)
    TYPE(TEXT) FCAPTION(Název druhu mzdy)                     CPOS(12,0.5) CLEN(17)

     TYPE(TEXT) NAME(DruhyMZDw->nDruhMZDY)                      CPOS( 2,1.55) CLEN( 7) BGND(12) FONT(5) 
     TYPE(TEXT) NAME(DruhyMZDw->cNazevDMz)                      CPOS(12,1.55) CLEN(50) BGND(12) FONT(5) 
  TYPE(End)

  
  TYPE(Static) CTYPE(2) SIZE(109,3.0) FPOS(0.4,2.8) RESIZE(y) 

    TYPE(TEXT)FCAPTION(Zpùsob danìní   )                       CPOS( 1,0.5) CLEN(15)
     TYPE(GET)  NAME(DruhyMZDw->nTypDane)                      FPOS(17,0.5) FLEN( 6) PP(2) FONT(5) 
     TYPE(TEXT) NAME(c_typDan->cnazTypDan)                     CPOS(25,0.5) CLEN(30) FONT(2) 
** 
  TYPE(End)

  TYPE(Static) SIZE(109,17.3) FPOS(0.3,6.00) RESIZE(y) CTYPE(2)   

* LEFT - nastavené položky pro nápoèty do mzdyHd
*******
    TYPE(DBrowse) FPOS(0,2.3 ) SIZE(48,15.5) FILE(s_Fieldsw)       ;
                  FIELDS( M->c_operand::2.6::2               , ;
                          cvyraz_1u:Uživatelský název pole:30, ; 
                          M->c_fields:promìnná:11            ) ; 
                  CURSORMODE(3) PP(9) ITEMMARKED(ItemMarked) POPUPMENU(nn) SCROLL(ny)


* RIGHT - definované položky pro nastavení nápoètù
******
    TYPE(Static)  FPOS(60,0.1) SIZE(48,1.3) RESIZE(y) CTYPE(2)
      TYPE(TEXT)     CAPTION(Seznam nápoètových položek k nastavení) CPOS( 1,.5) CLEN(46) FONT(7) CTYPE(1)
    TYPE(End) 

    TYPE(DBrowse) FPOS(60,2.3) SIZE(48,15.5) FILE(d_Fieldsw)       ;
                  FIELDS( cvyraz_u:Uživatelský název pole:34, ; 
                          cfield:promìnná:11                  ) ;
                  CURSORMODE(3) PP(9) ITEMMARKED(ItemMarked) POPUPMENU(nn) SCROLL(ny)

*****
     TYPE(Static) FPOS(0.4,0.1) SIZE(48,1.3)  RESIZE(y) CTYPE(2)
       TYPE(TEXT)     CAPTION(Nastavené nápoètové položky -->) CPOS( 1,.5) CLEN(24)
       TYPE(ComboBox) NAME(M->selMzdyit) FPOS(25,.6) FLEN(22) ;
                      VALUES(a,a,a,a,a,a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)  
     TYPE(End) 

     TYPE(PushButton) POS(49, 9) SIZE(10,1) CAPTION(<<) EVENT(addTo_s_Fieldsw)   ICON1(107) ATYPE(3)  
     TYPE(PushButton) POS(49,11) SIZE(10,1) CAPTION(>>) EVENT(delFrom_s_Fieldsw) ICON1(110) ATYPE(33)
  TYPE(End)
TYPE(End)



* 4_TAB nápoèty
TYPE(TabPage) TTYPE(4) CAPTION(Nápoèty)   OFFSET(46,38) 
  TYPE(Static) CTYPE(2) SIZE(109,2.6) FPOS(0.4,0.0) RESIZE(y)
    TYPE(TEXT) FCAPTION(druhMmzdy)                            CPOS( 2,0.5) CLEN(10)
    TYPE(TEXT) FCAPTION(Název druhu mzdy)                     CPOS(12,0.5) CLEN(17)

     TYPE(TEXT) NAME(DruhyMZDw->nDruhMZDY)                      CPOS( 2,1.55) CLEN( 7) BGND(12) FONT(5) 
     TYPE(TEXT) NAME(DruhyMZDw->cNazevDMz)                      CPOS(12,1.55) CLEN(50) BGND(12) FONT(5) 
  TYPE(End)
  
  TYPE(Static) CTYPE(2) SIZE(109,11.1) FPOS(0.4,3.2) RESIZE(y) 
*    TYPE(TEXT)   FCAPTION(Roèní nápoèty ...)                   CPOS( 1,1) CLEN(19)
*      TYPE(GET)  NAME(druhyMzdW->RZ_dny)                        FPOS(25,1) FLEN( 6) PP(2) FONT(5)
*      TYPE(TEXT) FCAPTION(dny)                                 CPOS(33,1) CLEN( 4)
      
*      TYPE(GET)  NAME(druhyMzdW->RZ_hod)                        FPOS(39,1) FLEN( 6) PP(2) FONT(5)
*      TYPE(TEXT) FCAPTION(hod)                                 CPOS(47,1) CLEN( 4)

*      TYPE(GET)  NAME(druhyMzdW->RZ_kcs)                        FPOS(54,1) FLEN( 6) PP(2) FONT(5)
*      TYPE(TEXT) FCAPTION(kè)                                  CPOS(62,1) CLEN( 4)
     
*   TYPE(STATIC) STYPE(16)  SIZE(96,2)


    TYPE(TEXT) FCAPTION(Nápoèty do prùmìrù)                 CPOS( 2,0.7) CLEN(105) BGND(12) FONT(5) CTYPE( 1)

    TYPE(TEXT) FCAPTION(hodnota nápoètu)                     CPOS( 10,1.9) CLEN(20) BGND(3) CTYPE( 0) 

    TYPE(TEXT) FCAPTION(pracovnì právní)                     CPOS( 35,1.9) CLEN(20) BGND(3) CTYPE( 1) PP(2)
    TYPE(TEXT) FCAPTION(náhrady za nemoc )                   CPOS( 60,1.9) CLEN(20) BGND(3) CTYPE( 1) PP(2)
    TYPE(TEXT) FCAPTION(nemocenská)                          CPOS( 85,1.9) CLEN(20) BGND(3) CTYPE( 1) PP(2) 

    TYPE(TEXT) FCAPTION(dny)                                 CPOS( 7,3.1) CLEN(20) BGND(3) CTYPE( 1) PP(2)
    TYPE(TEXT) FCAPTION(hodiny )                             CPOS( 7,4.3) CLEN(20) BGND(3) CTYPE( 1) PP(2)
    TYPE(TEXT) FCAPTION(mzda)                                CPOS( 7,5.5) CLEN(20) BGND(3) CTYPE( 1) PP(2) 


    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapPPDn)   FPOS(37,3.1) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(dn) CPOS(52,3.1) CLEN(5) 
    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapPPHo)   FPOS(37,4.3) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(ho) CPOS(52,4.3) CLEN(5) 
    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapPPMz)   FPOS(37,5.5) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(kè) CPOS(52,5.5) CLEN(5) 

    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNADn)   FPOS(62,3.1) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(dn) CPOS(77,3.1) CLEN(5) 
    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNAHo)   FPOS(62,4.3) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(ho) CPOS(77,4.3) CLEN(5) 
    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNAMz)   FPOS(62,5.5) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(kè) CPOS(77,5.5) CLEN(5) 

    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsHOPRP)   FPOS(87,3.1) FLEN(15) VALUES(0:nezapoèítá se , 1:odèítá se) TYPE(TEXT) FCAPTION(dn) CPOS(102,3.1) CLEN(5) 
*    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNAHo)   FPOS(87,4.3) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(ho) CPOS(102,4.3) CLEN(5) 
    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsNEMOC)   FPOS(87,5.5) FLEN(15) VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se) TYPE(TEXT) FCAPTION(kè) CPOS(102,5.5) CLEN(5) 


    TYPE(TEXT) FCAPTION(Celoroèní odmìny - zpùsob nápoètu a výpoètu prùmìrù)     CPOS( 2,7.7) CLEN(105) BGND(12) FONT(5) CTYPE( 1)

   TYPE(TEXT)  FCAPTION(Zahrnout do nápoètu )                               CPOS(8,9) CLEN(20) CTYPE(1)
    TYPE(COMBOBOX)   NAME(druhyMzdW->lNapPrCelO)                               FPOS(10,10) FLEN(15) REF(LYESNO) FTYPE(1)
   TYPE(TEXT) FCAPTION(Zpùsob alg.nápoètu)                                  CPOS(35,9) CLEN(35) CTYPE(1) 
    TYPE(COMBOBOX)   NAME(druhyMzdW->nalgCelOdm)                               FPOS(35,10) FLEN(35) VALUES(0:(0)bez nápoètu,                       ;
                                                                                                           1:(1)minulý rok,                        ;
                                                                                                           2:(2)druhé pololetí minulého roku,      ;
                                                                                                           3:(3)o rok zpìt,                        ;
                                                                                                           4:(4)Q1=-10_-12 Q2_4=-10_9,             ;
                                                                                                           5:(5)Q1_3=-1-12 Q4=1_12,                ;
                                                                                                           6:(6)Q1=-7_-12 Q2=-10_3 Q3=1_6 Q4=4_9,  ;
                                                                                                           7:(7)Q1_2=-10_-12 Q3_4=1_9,	        ;
                                                                                                           8:(8)Q1_2=-07_-12 Q3_4=1_6	 )
   TYPE(TEXT) FCAPTION(Poèet mìsícù)                                        CPOS(79,9) CLEN(20)  CTYPE(1)  
    TYPE(COMBOBOX)   NAME(druhyMzdW->npocMesPr)                                FPOS(79,10) FLEN(20) VALUES( 1:(1) jeden mìsíc,     ;
                                                                                                            2:(2) dva mìsíce,      ;                                                                                                                                                3:(3) tøi mìsíce,      ;
                                                                                                            4:(4) ètyøi mìsíce,    ;
                                                                                                            5:(5) pìt mìsícù,      ;
                                                                                                            6:(6) šest mìsícù,     ;
                                                                                                            7:(7) sedm mìsícù,     ;
                                                                                                            8:(8) osm mìsícù,      ;
                                                                                                            9:(9) devìt mìsícù,    ;
                                                                                                           10:(10) deset mìsícù,    ;
                                                                                                           11:(11) jedenáct mìsícù, ;
                                                                                                           12:(12) dvanáct mìsícù )

*   TYPE(STATIC) STYPE(16)  SIZE(106,11) CTYPE(2)


*   TYPE(TEXT)  FCAPTION(napoèítávat do pùmìru pro nemocenské pojištìní   ...)            CPOS( 1,5) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_kcsNemoc)                               FPOS(42,5) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                 CPOS(59,5) CLEN( 3) FONT(2)  
.1
*   TYPE(TEXT)  FCAPTION(napoèítávat do pracovnì právního pùmìru             ...)         CPOS( 1,6) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsHopRp)                               FPOS(42,6) FLEN(15) VALUES( 0:n.ezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                 CPOS(59,6) CLEN( 3) FONT(2)  

*   TYPE(TEXT)  FCAPTION(napoèítávat do pùmìru náhrad                                ...) CPOS( 1,7) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsPohSl)                               FPOS(42,7) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                 CPOS(59,7) CLEN( 3) FONT(2)  

*   TYPE(TEXT)  FCAPTION(napoèítávat do pracovnì právního pùmìru             ...) CPOS( 1,8) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsPracP)                               FPOS(42,8) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                 CPOS(59,8) CLEN( 3) FONT(2)  

*   TYPE(TEXT)  FCAPTION(napoèítávat pøesèas do pracovnì právního pùmìru      ...) CPOS( 1,9) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_KcsPresc)                               FPOS(42,9) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                 CPOS(59,9) CLEN( 3) FONT(2)  

*   TYPE(TEXT)  FCAPTION(napoèítávat hodiny do pracovnì právního pùmìru       ...) CPOS( 1,10) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_HodPrPra)                               FPOS(42,10) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(hod)                                                 CPOS(59,10) CLEN( 4) FONT(2)  

*   TYPE(TEXT)  FCAPTION(napoèítávat dny do pracovnì právního pùmìru       ...) CPOS( 1,11) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->P_DnyOdpDN)                               FPOS(42,11) FLEN(15) VALUES( 0:nezapoèítá se , 1:pøièítá se)
*    TYPE(TEXT) FCAPTION(dny)                                                 CPOS(59,11) CLEN( 4) FONT(2)  


*   TYPE(TEXT)  FCAPTION(zahrnout do nápoètu náhrady pracovní neschopnosti     ...) CPOS( 1,15) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNAMz)                               FPOS(42,15) FLEN(15) ;
*                                                                            VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se)
*    TYPE(TEXT) FCAPTION(kè)                                                  CPOS(59,15) CLEN(10) 

*   TYPE(TEXT)  FCAPTION(zahrnout do nápoètu náhrady pracovní neschopnosti     ...) CPOS( 1,16) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNADn)                               FPOS(42,16) FLEN(15) ;
*                                                                            VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se)
*    TYPE(TEXT) FCAPTION(dny)                                                CPOS(59,16) CLEN(10) 

*  TYPE(TEXT)  FCAPTION(zahrnout do nápoètu náhrady pracovní neschopnosti     ...) CPOS( 1,17) CLEN(40)
*    TYPE(COMBOBOX) NAME(druhyMzdW->nPrNapNAHo)                               FPOS(42,17) FLEN(15) ;
*                                                                            VALUES(0:nezapoèítá se , 1:pøièítá se, 2:odèítá se)
*    TYPE(TEXT) FCAPTION(hod)                                                CPOS(59,17) CLEN(10) 


  TYPE(End)
TYPE(End)


* 5_TAB úètování
TYPE(TabPage) TTYPE(4) CAPTION(Úètování) OFFSET(61,23) 
  TYPE(Static) CTYPE(2) FPOS(0.4,0.0) SIZE(109,2.6)  RESIZE(y)
    TYPE(TEXT) FCAPTION(druhMmzdy)                            CPOS( 2,0.5) CLEN(10)
    TYPE(TEXT) FCAPTION(Název druhu mzdy)                     CPOS(12,0.5) CLEN(17)

     TYPE(TEXT) NAME(DruhyMZDw->nDruhMZDY)                      CPOS( 2,1.55) CLEN( 7) BGND(12) FONT(5) 
     TYPE(TEXT) NAME(DruhyMZDw->cNazevDMz)                      CPOS(12,1.55) CLEN(50) BGND(12) FONT(5) 
  TYPE(End)

  
  TYPE(Static) CTYPE(2) FPOS(0.4,3.2) SIZE(109,20.5)  RESIZE(y) 
    TYPE(TEXT)FCAPTION(Zpùsob úètování . . .)                CPOS( 1,1) CLEN(19)
     TYPE(GET) NAME(DruhyMZDw->lUctuj)                       FPOS(25,1) FLEN( 3) PP(2) FONT(5) 
     
   TYPE(STATIC) STYPE(16)  SIZE(96,2)
  TYPE(End)
TYPE(End)



