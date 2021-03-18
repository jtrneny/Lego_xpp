TYPE(drgForm) DTYPE(10) TITLE(Prùmìry PP a NP) SIZE(100,25)                  ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_prumery_CRD) OBDOBI(MZD) 

TYPE(Action) CAPTION(~Výpoèet)  EVENT(mzd_prumery_cmp)     TIPTEXT(Výpoèet prùmìrù pro aktuální období)
TYPE(Action) CAPTION(~HromVýp)  EVENT(mzd_prumery_cmp_hv)  TIPTEXT(Hromadný výpoèet prùmìrù pro aktuální období)
TYPE(Action) CAPTION(~Podklady) EVENT(mzd_podklady_scr)    TIPTEXT(Položky mzdy vstupující do výpoètu prùmìrù)
TYPE(Action) CAPTION(h~RomZruš) EVENT(mzd_prumery_del)     TIPTEXT(Zruší všechny vypoètené prùmìry)

TYPE(DBrowse) FPOS(0.75,1.60) SIZE(98.5,10.65) FILE(MSPRC_MO)    ;
              POPUPMENU(y) INDEXORD(1) RESIZE(yy)                ;
               FIELDS( M->typ_zpracPrumH::2.9::2, ;
                       M->pravdPodPrH::2.9::2,    ;
                       cDruPraVzt,              ;
                       nPorPraVzt,           ;
                       nOsCisPrac,           ;
                       cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,       ;
                       nTypPraVzt,           ;
                       nTypZamVzt,           ;
                       cKmenStrPr,           ;
                       dDatNast,             ;
                       dDatPredVy,           ;
                       dDatVyst,             ;
                       nTypUkoPrv,           ;
                       M->is_pravdPodHL::2.9::2, ; 
                       M->is_Stavem::2.9::2, ;
                       nROK,                 ;
                       nOBDOBI  )            ;
                CURSORMODE(3) PP(7) STABLEBLOCK(stableBlock)  

TYPE(TabPage) FPOS(1,12.5) SIZE(98.75,12) OFFSET( 0.8,70) CAPTION(Info prùmìr k období) PRE(tabSelect) EXT() RESIZE(yx)

  TYPE(Static) STYPE(2) CAPTION(PRÙMÌR NA NÁHRADY A DOVOLENOU) SIZE(98,4) FPOS( 0,1) RESIZE(y)
    TYPE(TEXT) CAPTION(KC_celkem)                           CPOS(24,1) CLEN(10)
    TYPE(TEXT) CAPTION(Odmeny)                              CPOS(38,1) CLEN( 7)
    TYPE(TEXT) CAPTION(Dny/Hod)                             CPOS(53,1) CLEN( 7)

    TYPE(TEXT) CAPTION(Prùmìr na HOD . . .)                 CPOS( 2,2) CLEN(19)
    TYPE(TEXT) CAPTION([)                                   CPOS(22,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,2) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(+)                                   CPOS(35.5,2) CLEN( 2)    
    TYPE(TEXT) NAME(msvPrum->nKC_ODMcis)                    CPOS(38  ,2) CLEN(10) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(])                                   CPOS(49  ,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) CAPTION(/)                                   CPOS(51  ,2) CLEN( 2)
    TYPE(TEXT) NAME(msvPrum->nHOD_PPSUM)                    CPOS(53  ,2) CLEN( 9) PP(2) FONT(5)
    TYPE(TEXT) CAPTION(=)                                   CPOS(61.5,2) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nHodPrumPP)                    CPOS(65  ,2) CLEN( 8) PP(2) FONT(5)

    TYPE(TEXT) CAPTION(Prùmìr na DEN . . .)                 CPOS( 2  ,3) CLEN(18)

    TYPE(TEXT) CAPTION([)                                   CPOS(22  ,3) CLEN( 2)       FONT(6)
    TYPE(TEXT) NAME(msvPrum->nKC_PPSUM)                     CPOS(24  ,3) CLEN(10) PP(2) FONT(5)
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
  TYPE(END)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


TYPE(TabPage) FPOS(1,12.5) SIZE(98.75,12) OFFSET(29.7,38)  CAPTION(Prùmìry za období) PRE(tabSelect) EXT() RESIZE(yx)
  TYPE(DBrowse) FPOS(0,0) SIZE(98.75,11.3) FILE(MSVPRUM) INDEXORD(10) RESIZE(yx)                   ;
                FIELDS( M->typ_zpracPrumP::3.9::2, ;
                        M->pravdPodPrP::2.9::2,    ;
                        nRok:rok                 , ; 
                        nObdobi:obd            , ;
                        nCtvrtleti:Q           , ;
                        nHodPrumPP:hodPrumPP   , ;
                        nDenPrumPP:denPrumPP   , ;       
                        nDenVZhruN:nemNahDVZ   , ;
                        nDenVZcisN:nemNahZAOK  , ;
                        nDenVZciKN:nemNahKRAC  , ;
                        nSazDenNiN:nemNahDO3d  , ;        
                        nSazDenVKN:nemNahDO14d , ;
                        nSazDenVyN:nemNahNAD3d   )      ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
TYPE(END)


TYPE(STATIC) STYPE(2) FPOS(0.50,0.01) SIZE(98.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
 TYPE(STATIC) STYPE(2) FPOS(74.5,0.1) SIZE(23.75,1.00) RESIZE(nx)
   TYPE(PushButton) POS(0.0,0.4)   SIZE(23.75,1.10) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*   TYPE(PushButton) POS(74.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
 TYPE(END) 
TYPE(END)
