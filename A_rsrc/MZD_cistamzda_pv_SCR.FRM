TYPE(drgForm) DTYPE(10) TITLE(Èisté mzdy dle pracovních vztahù - Vypoètené èisté mzdy) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD)


  TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøizení dokladù o mzdì)
  TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)


  TYPE(DBrowse) FPOS(0.75,1.40) SIZE(110,8.7) FILE(MSPRC_MO)    ;
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
                 CURSORMODE(3) PP(7) ITEMMARKED(itemMarked)

* mzdyhd - hlavièky vzpoètených èistých mezd
*  TYPE(TEXT) CAPTION(Vypoètené èisté mzdy zamìstnancù) CPOS(.28.8) FONT(5) PP(3) BGND(11) CTYPE(1)
  TYPE(dBrowse) FPOS(0,10) SIZE(109.6,5.7) FILE(MzdyHD) INDEXORD(1) RESIZE(yx)    ;
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
  TYPE(dBrowse) FPOS(-0.3,15.8) SIZE(109.6,9.1) FILE(MzdyIT) INDEXORD(23)           ;
                    FIELDS( cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            DRUHYMZD->cNazevDMz::35,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 

*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.2,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)

