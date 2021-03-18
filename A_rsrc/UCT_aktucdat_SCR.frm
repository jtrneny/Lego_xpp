TYPE(drgForm) SIZE(100,20) DTYPE(10) TITLE(Aktualizace úèetních knih ...)  ;
                                     GUILOOK(Action:n)                     ;
                                     OBDOBI(UCT)                           ;    
                                     BORDER(2)                             ;
                                     POST(postValidate)


**OUŠKA**
TYPE(TabPage) SIZE(100,19.9) CAPTION(Aktualizace) OFFSET( 1,82) PRE(tabSelect) TABHEIGHT(1.1)

**BROWSE**
  TYPE(Static) FPOS(.5,.3) SIZE(99,13.7) STYPE(12) CTYPE(2) RESIZE(yy)
    TYPE(DBrowse) FPOS(-.9, .05) SIZE(100,13.7) FILE(UCETSYS)                              ;
                                              FIELDS(UCT_aktucdat_BC(0):_:2.7::2       , ;
                                                     UCT_aktucdat_BC(1):e:2.7::2       , ;
                                                     UCT_aktucdat_BC(2):a:2.7::2       , ;
                                                     UCT_aktucdat_BC(3):k:2.7::2       , ;
                                                     cOBDOBI                           , ;
                                                     UCT_ucetsys_BC(2):ROK/OBD:7       , ;
                                                     UCT_ucetsys_BC(4):ÚÈTOVAL:24      , ;
                                                     UCT_ucetsys_BC(5):AKTUALIZOVAL:24 , ;
                                                     UCT_ucetsys_BC(6):UZAVØEL:24.8      ) ;
                                              CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3)
  TYPE(END)

      
**INFO**
  TYPE(Static) FPOS(.5,14) SIZE(99,1.3) STYPE(12) CTYPE(2) GROUPS(PROGRESS) 
    TYPE(Text) CAPTION(Zpracování dat)  CPOS( 1, .1) CLEN(89) PP(3) BGND( 1) CTYPE(1) FONT(5)
  TYPE(END)

*
**RUN**
  TYPE(Static) STYPE(12) SIZE(99,3) FPOS(.5,15.5) CTYPE(2) RESIZE(y) GROUPS(OK)
    TYPE(PushButton) POS(  .4,1.9) SIZE(33,2.8) CAPTION(~Naètení dat pro centrál)        EVENT(pushButtonClick) ICON1(119) ICON2(0) ATYPE(3)
    TYPE(PushButton) POS(33.5,1.9) SIZE(33,2.8) CAPTION(~Kontrola základních souborù)    EVENT(pushButtonClick) ICON1(118) ICON2(0) ATYPE(3)
    TYPE(PushButton) POS(66.6,1.9) SIZE(32,2.8) CAPTION(~Aktualizace úèetních knih)      EVENT(pushButtonClick) ICON1(142) ICON2(0) ATYPE(3)
  TYPE(END)

*
**ERRS**
  TYPE(Static) STYPE(12) SIZE(99,3) FPOS(.5,15.5) CTYPE(2) RESIZE(y) GROUPS(ERR)
    TYPE(PushButton) POS(  .4,1.9) SIZE(39.9,2.8) CAPTION(~Zobrazení chyb v aktualizaci) EVENT(errsButtonClick) ICON1(119) ICON2(  0) ATYPE(3)
    TYPE(PushButton) POS(40.4,1.9) SIZE(18.6,2.8) CAPTION()                              EVENT()                ICON1(170) ICON2(170) ATYPE(1) 
    TYPE(PushButton) POS(59.1,1.9) SIZE(39.9,2.8) CAPTION(~Zrušení chyb v aktualizaci)   EVENT(errsButtonClick) ICON1(110) ICON2(  0) ATYPE(3)
  TYPE(END)
TYPE(END)


TYPE(TabPage) SIZE(100,19.9) CAPTION(Uzávìrka období)    OFFSET(16,67) PRE(tabSelect) TABHEIGHT(1.1)

**INFO**
  TYPE(Static) FPOS(.5,.3) SIZE(99,1.3) STYPE(12) CTYPE(2)
    TYPE(Text) CAPTION(Uzavøení/otevøení úètujících úloh)  CPOS( 1, .1) CLEN(89) PP(3) BGND( 1) CTYPE(1) FONT(5)
  TYPE(END)

** BROWSE **
  TYPE(Static) FPOS(.5,1.6) SIZE(99,13.7) STYPE(12) CTYPE(2)
    TYPE(DBrowse) FPOS(-.9,.05) SIZE(45,13.8) FILE(UCETSYS)                               ;
                                           FIELDS(UCT_aktucdat_BC(0):_:2.7::2           , ;
                                                  UCT_aktucdat_BC(1):e:2.7::2           , ;
                                                  UCT_aktucdat_BC(2):a:2.7::2           , ;
                                                  UCT_aktucdat_BC(3):k:2.7::2           , ;
                                                  cOBDOBI                               , ;
                                                  M->zavrel_kdoSy:uzavøel / otevøel:23  ) ;
                                           CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3) ITEMMARKED(itemMarked_W)


    TYPE(DBrowse) FPOS(44,.05) SIZE(54,13.8) FILE(ucetsys_w)                            ;
                                            FIELDS(M->zavren_W:e:2.7::2               , ;
                                                   M->akuc_ksW:a:2.7::2               , ;
                                                   M->zavrel_kdoW:uzavøel / otevøel:24, ;
                                                   M->nazUlohy_W:úloha:23               ) ;
                                            CURSORMODE(3) PP(9) SCROLL(ny) INDEXORD(3)
  TYPE(END)

  TYPE(Static) STYPE(12) SIZE(99,3) FPOS(.5,15.5) CTYPE(2) RESIZE(y) 
    TYPE(PushButton) POS( 58.8,1.9) SIZE(39.9,2.8) CAPTION(   ~Otevøení /uzavøení úlohy) EVENT(pushClose_or_OpenTask)  ICON1(119) ICON2(0) ATYPE(3)
  TYPE(END)
TYPE(END) 


TYPE(TabPage) SIZE(100,19.9) CAPTION(Uzávìrka roèní)    OFFSET(32,50) PRE(tabSelect) TABHEIGHT(1.1)

**INFO**
  TYPE(Static) FPOS(.5,.3) SIZE(99,1.3) STYPE(12) CTYPE(2)
    TYPE(Text) CAPTION(Uzavøení/otevøení úètujících úloh)  CPOS( 1, .1) CLEN(89) PP(3) BGND( 1) CTYPE(1) FONT(5)
  TYPE(END)

  TYPE(Static) STYPE(12) SIZE(40,10) FPOS(.5,2.5) CTYPE(2) RESIZE(y)
    TYPE(COMBOBOX) NAME(UCETUZV->nTypUZV)   FPOS( 4, 1  ) FLEN(30) REF(ru_TYPUZV)
    TYPE(COMBOBOX) NAME(UCETUZV->nDoplnPS)  FPOS( 4, 2.5) FLEN(30) REF(ru_DOPLPS)
    TYPE(COMBOBOX) NAME(UCETUZV->nVytPSNV)  FPOS( 4, 4  ) FLEN(30) REF(ru_VYTPSNV)
    TYPE(COMBOBOX) NAME(UCETUZV->nTypVNPU)  FPOS( 4, 5.5) FLEN(30) REF(ru_TYPVNPU)
    TYPE(COMBOBOX) NAME(UCETUZV->nTypUZVR)  FPOS( 4, 7  ) FLEN(30) REF(ru_TYPUZVR)
  TYPE(END)

* 1 - pøeúètování výnosù a nákladù
  TYPE(TEXT)     CAPTION(Úèet pro pøeúètování výnosù a nákladù ...)                CPOS(43,2  ) CLEN(40) 
*  TYPE(GET)      NAME(UCETUZV->cucet_DVU)  FPOS(43,3) FLEN( 8) 
*  TYPE(TEXT)     NAME(rz_uctDVU->cnaz_Uct) CPOS(52,3) CLEN(18) GROUPS(SETFONT,7.Arial CE)

  TYPE(GET)      NAME(UCETUZV->cucet_MVU)  FPOS(43,3) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctMVU->cnaz_Uct) CPOS(52,3) CLEN(18) GROUPS(SETFONT,7.Arial CE)

* 2 - NV nedokonèená výroba
  TYPE(TEXT)     CAPTION(Úèet pro pøevod poèáteèních stavù nedokonèené výroby ...) CPOS(43,4.5) CLEN(50) 
  TYPE(GET)      NAME(UCETUZV->cucet_MNV)  FPOS(43,5.5) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctMNV->cnaz_Uct) CPOS(52,5.5) CLEN(18) GROUPS(SETFONT,7.Arial CE)

  TYPE(GET)      NAME(UCETUZV->cucet_DNV)  FPOS(70,5.5) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctDNV->cnaz_Uct) CPOS(79,5.5) CLEN(18) GROUPS(SETFONT,7.Arial CE)

* 3 - pøeúètování poèáteèních stavù
  TYPE(TEXT)     CAPTION(Úèty pro pøeúètování poèáteèních stavù ...)                CPOS(43, 7) CLEN(40) 
  TYPE(GET)      NAME(UCETUZV->cucet_DPS)  FPOS(43,8) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctDPS->cnaz_Uct) CPOS(52,8) CLEN(18) GROUPS(SETFONT,7.Arial CE)

  TYPE(GET)      NAME(UCETUZV->cucet_MPS)  FPOS(70,8) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctMPS->cnaz_Uct) CPOS(79,8) CLEN(18) GROUPS(SETFONT,7.Arial CE)

* 4 - UK uzavøení úèetních knih 
  TYPE(TEXT)     CAPTION(Úèet pro uzavøení úèetních knih ...)                      CPOS(43, 10) CLEN(40) 
  TYPE(GET)      NAME(UCETUZV->cucet_MUK)  FPOS(43,11) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctMUK->cnaz_Uct) CPOS(52,11) CLEN(18) GROUPS(SETFONT,7.Arial CE)

  TYPE(GET)      NAME(UCETUZV->cucet_DUK)  FPOS(70,11) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctDUK->cnaz_Uct) CPOS(79,11) CLEN(18) GROUPS(SETFONT,7.Arial CE)

* 5 - OK otevøení úèetnich knih
  TYPE(TEXT)     CAPTION(Úèet pro otevøení úèetních knih ...)                      CPOS(43, 12.5) CLEN(40) 
  TYPE(GET)      NAME(UCETUZV->cucet_DOK)  FPOS(43,13.5) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctDOK->cnaz_Uct) CPOS(52,13.5) CLEN(18) GROUPS(SETFONT,7.Arial CE)

  TYPE(GET)      NAME(UCETUZV->cucet_MOK)  FPOS(70,13.5) FLEN( 8) 
  TYPE(TEXT)     NAME(rz_uctMOK->cnaz_Uct) CPOS(79,13.5) CLEN(18) GROUPS(SETFONT,7.Arial CE)

**
  TYPE(TEXT)     CAPTION(Uzavøeno dne ...)                   CPOS( 1, 13.2) CLEN(20)   
  TYPE(TEXT)     NAME(M->tUzavreni)  CPOS( 20,13.2) CLEN(20) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)

  TYPE(TEXT)     CAPTION(Uzávìrka zrušena dne ...)           CPOS( 1, 14.0) CLEN(20)   
  TYPE(TEXT)     NAME(M->tZruseni)   CPOS( 20,14.0) CLEN(20) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)  


  TYPE(Static) STYPE(12) SIZE(99,3) FPOS(.5,15.5) CTYPE(2) RESIZE(y) 
    TYPE(PushButton) POS(   .4,1.9) SIZE(39.9,2.8) CAPTION(   ~Zrušení roèní uzávìrky) EVENT(pushOpenUzavRok) ICON1(119) ICON2(0) ATYPE(3)
    TYPE(PushButton) POS( 58.8,1.9) SIZE(39.9,2.8) CAPTION(    ~Roèní uzávìrka       ) EVENT(pushUctoUzavRok) ICON1(142) ICON2(0) ATYPE(3)
  TYPE(END)
TYPE(END)

* TYPE(ComboBox) NAME(UCT_aktucdat_scr:NROK) FPOS(84.5,0.02) FLEN(15)  VALUES(a,a,a) ;
*                                                            COMBOINIT(comboBoxInit) TEMSELECTED(comboItemSelected)
TYPE(END)

