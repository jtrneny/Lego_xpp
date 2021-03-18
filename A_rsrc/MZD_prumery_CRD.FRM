TYPE(drgForm) DTYPE(10) TITLE(Pøepoèet a oprava ètvrtletních prùmìrù) SIZE(100,25) ;
              POST(postValidate)                                                   ;
              GUILOOK(Action:y,IconBar:y)


* TYPE(Action) CAPTION(~PracKal )   EVENT(mzd_prackalendar_in)   TIPTEXT(Pracovní kalendáø-odpracovaná doba)
* TYPE(Action) CAPTION(d~Ocházka )  EVENT(mzd_prackalendar_in)   TIPTEXT(Docházka do zamìstnání)

*  TYPE(Action) CAPTION(~Pøepoèet)  EVENT(mzd_prumery_cmp)   TIPTEXT(Pøepoèet prùmìrù pro pracovníka ...)

  TYPE(Static) STYPE(12) SIZE(98,3.5) FPOS( 1,0.3) RESIZE(y)
    TYPE(TEXT) CAPTION(Zamìstnanec . .)                      CPOS( 2, 0.2)     CLEN(11)
     TYPE(TEXT) NAME(MsVPrumw->nOsCisPrac)                   CPOS( 14,0.2)     CLEN(10) FONT(5)
     TYPE(TEXT) NAME(MsVPrumw->cJmenoRozl)                   CPOS( 25,0.2)     CLEN(45) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(Kmen_støedisko ...)                   CPOS( 72,0.2)     CLEN(15)
     TYPE(TEXT) NAME(MsVPrumw->cKmenStrPr)                   CPOS( 88,0.2)     CLEN( 8) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(DatNást . .)                          CPOS( 2,1.2)  CLEN(11)
     TYPE(TEXT) NAME(MsVPrumw->dDatNast)                     CPOS(14,1.2)  CLEN(10)
    TYPE(TEXT) CAPTION(DatVýst . .)                          CPOS( 2,2.2)  CLEN(11)
     TYPE(TEXT) NAME(MsVPrumw->dDatVyst)                     CPOS(14,2.2)  CLEN(10)
    TYPE(TEXT) FCAPTION(Algoritmus nápoètu celoroèních odmìn)  CPOS(24,1.2) CLEN(35) 
     TYPE(COMBOBOX)   NAME(MsVPrumw->nalgCelOdm)             FPOS(24,2.2) FLEN(35) VALUES(0:(0) bez nápoètu,                       ;
                                                                                          1:(1) minulý rok,                        ;
                                                                                          2:(2) druhé pololetí minulého roku,      ;
                                                                                          3:(3) o rok zpìt,                        ;
                                                                                          4:(4) Q1=-10_-12 Q2_4=-10_9,             ;
                                                                                          5:(5) Q1_3=-1-12 Q4=1_12,                ;
                                                                                          6:(6) Q1=-7_-12 Q2=-10_3 Q3=1_6 Q4=4_9,  ;
                                                                                          7:(7) Q1_2=-10_-12 Q3_4=1_9,	           ;
                                                                                          8:(8) Q1_2=-07_-12 Q3_4=1_6	 )
   TYPE(TEXT) FCAPTION(Poèet mìsícù cel.odm.)                CPOS(60,1.2) CLEN(20)   
    TYPE(COMBOBOX)   NAME(MsVPrumw->npocMesPr)               FPOS(60,2.2) FLEN(20) VALUES( 1:( 1) jeden mìsíc,     ;
                                                                                           2:( 2) dva mìsíce,      ;
                                                                                           3:( 3) tøi mìsíce,      ;
                                                                                           4:( 4) ètyøi mìsíce,    ;
                                                                                           5:( 5) pìt mìsícù,      ;
                                                                                           6:( 6) šest mìsícù,     ;
                                                                                           7:( 7) sedm mìsícù,     ;
                                                                                           8:( 8) osm mìsícù,      ;
                                                                                           9:( 9) devìt mìsícù,    ;
                                                                                          10:(10) deset mìsícù,    ;
                                                                                          11:(11) jedenáct mìsícù, ;
                                                                                          12:(12) dvanáct mìsícù )

*    TYPE(TEXT) CAPTION(Ruèní výpoèet)                        CPOS( 84,1.2)    CLEN(15)   
*    TYPE(COMBOBOX) NAME(msvPrumW->lrucVypPru)                FPOS( 84,2.2)    FLEN( 8) REF( LYESNO)  
    TYPE(TEXT) CAPTION(Pravdìp.prùmìr)                        CPOS( 81,1.2)    CLEN(18)   
    TYPE(COMBOBOX) NAME(msvPrumW->nAlgPraPru)                 FPOS( 81,2.2)   FLEN(16) VALUES( 0:(0) neprovádí se,   ;
                                                                                               1:(1) z tarifu,       ;
                                                                                               2:(2) z hrubé mzdy,   ; 
                                                                                               3:(3) z minulého období )
                                                                                   
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Náhrady) OFFSET(1,82) FPOS(0.4,4.3) SIZE(99.2,10.5)  
   TYPE(Static) STYPE(13) CAPTION(PRÙMÌR PRO NÁHRADY) SIZE(97,9.0) FPOS( 1,0.2) RESIZE(y)
    TYPE(TEXT) CAPTION(Prùmìr pro náhrady)                  CPOS( 2, 0.1) FONT(5)

    TYPE(TEXT) CAPTION(OBD_1)                               CPOS(24,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_2)                               CPOS(40,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_3)                               CPOS(56,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(SUMA)                                CPOS(76,1)  CLEN( 6)

    TYPE(TEXT) CAPTION(Nápoèet Kè        . . .)             CPOS(2,2)  CLEN(16)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,2) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nKC_PP01)                      CPOS(24,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_PP02)                      CPOS(40,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_PP03)                      CPOS(56,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_PPSUM)                     CPOS(76,2)  CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Nápoèet Hod     . . .)               CPOS(2,3)  CLEN(17)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,3) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nHOD_PP01)                     CPOS(24,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_PP02)                     CPOS(40,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_PP03)                     CPOS(56,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_PPSUM)                    CPOS(76,3) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Nápoèet Dny     . . .)               CPOS(2,4) CLEN(17)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,4) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nDNY_PP01)                     CPOS(24,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_PP02)                     CPOS(40,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_PP03)                     CPOS(56,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_PPSUM)                    CPOS(76,4) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,5.5) CLEN(10)
    TYPE(TEXT) CAPTION(Odmeny)                              CPOS(38,5.5) CLEN( 7)
    TYPE(TEXT) CAPTION(Dny/Hod)                             CPOS(56,5.5) CLEN( 7)

    TYPE(TEXT) CAPTION(Prùmìr na HOD  . . .)                CPOS( 2,6.5) CLEN(19)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,6.5) CLEN( 2)    
     TYPE(TEXT) CAPTION(/)                                    CPOS(54,6.5) CLEN( 2) 
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,6.5) CLEN( 2)    

     TYPE(TEXT) CAPTION([)                                    CPOS(22,6.5)   CLEN( 2)       FONT(6)
     TYPE(GET)  NAME(MsVPrumw->nKC_PPSUM)                     FPOS(24,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(GET)  NAME(MsVPrumw->nKC_ODMcis)                    FPOS(40,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(TEXT) CAPTION(])                                    CPOS(52,6.5)   CLEN( 2)       FONT(6)
     TYPE(GET)  NAME(MsVPrumw->nHOD_PPSUM)                    FPOS(56,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(GET)  NAME(MsVPrumw->nHodPrumPP)                    FPOS(76,6.5)   FLEN(12) PP(2) FONT(5)
*    TYPE(GET)  NAME(MsVPrumw->nHodPrumNA)                    FPOS(90,6.5)   FLEN( 6) PP(2) FONT(5)
*     TYPE(TEXT) NAME(MsVPrumw->nHodPrumPP)                    CPOS(76,7)   CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Prùmìr na DEN   . . .)               CPOS(2,7.5) CLEN(18)
      TYPE(TEXT) CAPTION(+)                                    CPOS(37,7.5) CLEN( 2)    
      TYPE(TEXT) CAPTION(*)                                    CPOS(54,7.5) CLEN( 2) 
      TYPE(TEXT) CAPTION(=)                                    CPOS(71,7.5) CLEN( 2)    

     TYPE(TEXT) CAPTION([)                                    CPOS(22,7.5)   CLEN( 2)       FONT(6)
     TYPE(TEXT) NAME(M->den_KC_ppsum)                         CPOS(24,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(M->den_KC_odmcis)                        CPOS(40,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) CAPTION(])                                    CPOS(52,7.5)   CLEN( 2)       FONT(6)
     TYPE(TEXT) NAME(M->den_DNY_ppsum)                        CPOS(56,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
*     TYPE(TEXT) NAME(MsVPrumw->nDenPrumPP)                    CPOS(76,8)   CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(GET)  NAME(MsVPrumw->nDenPrumPP)                    FPOS(76,7.5)   FLEN(12) PP(2) FONT(5)
   TYPE(END) 
 TYPE(END) 

  TYPE(TabPage) TTYPE(4) CAPTION(Náhrady nemoc) OFFSET(17,68) FPOS(0.4,4.3) SIZE(99.2,10.5)  
   TYPE(Static) STYPE(13) CAPTION(PRÙMÌR PRO NÁHRADY ZA NEMOC) SIZE(97,9.0) FPOS( 1,0.2) RESIZE(y)
    TYPE(TEXT) CAPTION(Prùmìr pro náhrady za nemoc)         CPOS( 2, 0.1) FONT(5)

    TYPE(TEXT) CAPTION(OBD_1)                               CPOS(24,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_2)                               CPOS(40,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_3)                               CPOS(56,1)  CLEN( 6)
    TYPE(TEXT) CAPTION(SUMA)                                CPOS(76,1)  CLEN( 6)

    TYPE(TEXT) CAPTION(Nápoèet Kè        . . .)             CPOS(2,2)  CLEN(16)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,2) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nMzd_NA01)                      CPOS(24,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nMzd_NA02)                      CPOS(40,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nMzd_NA03)                      CPOS(56,2)  CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nMzd_NASUM)                     CPOS(76,2)  CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Nápoèet Hod     . . .)               CPOS(2,3)  CLEN(17)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,3) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nHOD_NA01)                     CPOS(24,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_NA02)                     CPOS(40,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_NA03)                     CPOS(56,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nHOD_NASUM)                    CPOS(76,3) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Nápoèet Dny     . . .)               CPOS(2,4) CLEN(17)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,4) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nDNY_NA01)                     CPOS(24,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_NA02)                     CPOS(40,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_NA03)                     CPOS(56,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDNY_NASUM)                    CPOS(76,4) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,5.5) CLEN(10)
    TYPE(TEXT) CAPTION(Odmeny)                              CPOS(38,5.5) CLEN( 7)
    TYPE(TEXT) CAPTION(Dny/Hod)                             CPOS(56,5.5) CLEN( 7)

    TYPE(TEXT) CAPTION(Prùmìr na HOD  . . .)                CPOS( 2,6.5) CLEN(19)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,6.5) CLEN( 2)    
     TYPE(TEXT) CAPTION(/)                                    CPOS(54,6.5) CLEN( 2) 
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,6.5) CLEN( 2)    

     TYPE(TEXT) CAPTION([)                                    CPOS(22,6.5)   CLEN( 2)       FONT(6)
     TYPE(GET)  NAME(MsVPrumw->nMzdNap_NA)                    FPOS(24,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(GET)  NAME(MsVPrumw->nKC_ODMcis)                    FPOS(40,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(TEXT) CAPTION(])                                    CPOS(52,6.5)   CLEN( 2)       FONT(6)
     TYPE(GET)  NAME(MsVPrumw->nHodNap_NA)                    FPOS(56,6.5)   FLEN(11) PP(2) FONT(5)
     TYPE(GET)  NAME(MsVPrumw->nHodPrumNA)                    FPOS(76,6.5)   FLEN(12) PP(2) FONT(5)

*    TYPE(TEXT) CAPTION(Prùmìr na DEN   . . .)               CPOS(2,7.5) CLEN(18)
*      TYPE(TEXT) CAPTION(+)                                    CPOS(37,7.5) CLEN( 2)    
*      TYPE(TEXT) CAPTION(*)                                    CPOS(54,7.5) CLEN( 2) 
*      TYPE(TEXT) CAPTION(=)                                    CPOS(71,7.5) CLEN( 2)    

*     TYPE(TEXT) CAPTION([)                                    CPOS(22,7.5)   CLEN( 2)       FONT(6)
*     TYPE(TEXT) NAME(M->den_KC_ppsum)                         CPOS(24,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
*     TYPE(TEXT) NAME(M->den_KC_odmcis)                        CPOS(40,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
*     TYPE(TEXT) CAPTION(])                                    CPOS(52,7.5)   CLEN( 2)       FONT(6)
*     TYPE(TEXT) NAME(M->den_DNY_ppsum)                        CPOS(56,7.5)   CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
**     TYPE(TEXT) NAME(MsVPrumw->nDenPrumPP)                    CPOS(76,8)   CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)
*     TYPE(GET)  NAME(MsVPrumw->nDenPrumPP)                    FPOS(76,7.5)   FLEN(12) PP(2) FONT(5)
  TYPE(End)
 TYPE(END) 


  TYPE(Static) STYPE(13) CAPTION(PRÙMÌR NA NEMOCENSKÉ DÁVKY - VÝPLATA PØES ÈSSZ) SIZE(98,9.6) FPOS( 1,15.2) RESIZE(y)
    TYPE(TEXT) CAPTION(Prùmìr na nemocenké dávky - výplata pøes ÈSSZ)       CPOS( 2, -.1) FONT(5)

    TYPE(TEXT) CAPTION(OBD_1)                               CPOS(24,1) CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_2)                               CPOS(40,1) CLEN( 6)
    TYPE(TEXT) CAPTION(OBD_3)                               CPOS(56,1) CLEN( 6)
    TYPE(TEXT) CAPTION(SUMA)                                CPOS(76,1) CLEN( 6)

    TYPE(TEXT) CAPTION(Nápoèet Kè       . . .)              CPOS( 2,2) CLEN(16)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,2) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,2) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nKC_NM01)                      CPOS(24,2) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_NM02)                      CPOS(40,2) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_NM03)                      CPOS(56,2) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKC_NMSUM)                     CPOS(76,2) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Nápoèet KD      . . .)               CPOS( 2,3) CLEN(16)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,3) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,3) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nKD_NM01)                      CPOS(24,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKD_NM02)                      CPOS(40,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKD_NM03)                      CPOS(56,3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKD_NMSUM)                     CPOS(76,3) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Odpoèet KD      . . .)               CPOS( 2,4) CLEN(16)
     TYPE(TEXT) CAPTION(+)                                    CPOS(37,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,4) CLEN( 2)    
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,4) CLEN( 2)    

     TYPE(TEXT) NAME(MsVPrumw->nKDO_NM01)                     CPOS(24,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKDO_NM02)                     CPOS(40,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKDO_NM03)                     CPOS(56,4) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nKDO_NMSUM)                    CPOS(76,4) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(KÈ_celkem)                           CPOS(24,5.3) CLEN( 9)
    TYPE(TEXT) CAPTION(KalDny)                              CPOS(41,5.3) CLEN( 8)
    TYPE(TEXT) CAPTION(Odpoèet KalDnù)                      CPOS(57,5.3) CLEN(12)

    TYPE(TEXT) CAPTION(Dílèí vymìøovací základ    . . .)    CPOS( 2,6.3) CLEN(22)
     TYPE(TEXT) CAPTION(/)                                    CPOS(37,6.3) CLEN( 2) 
     TYPE(TEXT) CAPTION(+)                                    CPOS(53,6.3) CLEN( 2)     
     TYPE(TEXT) CAPTION(=)                                    CPOS(71,6.3) CLEN( 2)    

     TYPE(GET)  NAME(MsVPrumw->nKC_NMSUM)                     FPOS(24,6.3) FLEN(11) PP(2) FONT(5)
     TYPE(TEXT) CAPTION([)                                    CPOS(39,6.3) CLEN( 2)       FONT(6)
     TYPE(GET)  NAME(MsVPrumw->nKD_NMSUM)                     FPOS(41,6.3) FLEN(10) PP(2) FONT(5)
     TYPE(GET)  NAME(MsVPrumw->nKDO_NMSUM)                    FPOS(57,6.3) FLEN(10) PP(2) FONT(5)
     TYPE(TEXT) CAPTION(])                                    CPOS(68,6.3) CLEN( 2)       FONT(6)
     TYPE(TEXT) NAME(MsVPrumw->nDenVZhruN)                    CPOS(76,6.3) CLEN(13) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Denní vymìøovací základ . . .)       CPOS( 2,8.3) CLEN(22)
     TYPE(TEXT) CAPTION(zaokrouhlený)                         CPOS(24,7.3) CLEN(12) 
     TYPE(TEXT) CAPTION(krácený 90%)                          CPOS(41,7.3) CLEN(12) 

     TYPE(TEXT) NAME(MsVPrumw->nDenVZcisN)                    CPOS(24,8.3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)
     TYPE(TEXT) NAME(MsVPrumw->nDenVZciKN)                    CPOS(41,8.3) CLEN(12) PP(2) FONT(5) BGND( 9) CTYPE(2)

    TYPE(TEXT) CAPTION(Denní sazba 25/69k/69_% . . .)        CPOS(53,8.3) CLEN(21)
     TYPE(TEXT) NAME(MsVPrumw->nSazDenNiN)                     CPOS(76,8.3) CLEN( 7) PP(2) FONT(5) BGND( 9) CTYPE(2) PICTURE(9999)
     TYPE(TEXT) NAME(MsVPrumw->nSazDenVKN)                     CPOS(83,8.3) CLEN( 7) PP(2) FONT(5) BGND( 9) CTYPE(2) PICTURE(9999)
     TYPE(TEXT) NAME(MsVPrumw->nSazDenVyN)                     CPOS(90,8.3) CLEN( 7) PP(2) FONT(5) BGND( 9) CTYPE(2) PICTURE(9999)
  TYPE(End)


  TYPE(Static) STYPE(12) SIZE(62,1.2) FPOS( 37,3.9) RESIZE(y)

    TYPE(TEXT) CAPTION(Typ zpracování )             CPOS( 0.3, 0.1) FONT(5)
    TYPE(COMBOBOX)   NAME(MsVPrumw->nStavZprac)     FPOS(16.0,0.1)  FLEN(45) VALUES( 0:( 0) výpoèet neprobìhl,                             ;
                                                                                     1:( 1) automatický výpoèet-založení období,           ;
                                                                                     2:( 2) automatický výpoèet-hromadnì,                  ;
                                                                                     3:( 3) automatický výpoèet-nový prac.vztah,           ;
                                                                                     4:( 4) automatický výpoèet,                           ;
                                                                                     9:( 9) ruèní výpoèet )
  TYPE(End) 

