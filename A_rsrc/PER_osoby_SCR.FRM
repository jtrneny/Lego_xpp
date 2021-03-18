TYPE(drgForm) SIZE(110,25) DTYPE(10) TITLE(Osobní údaje zamìstnancù (personalistika) ...) ;
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar)     ;
              CARGO(PER_osoby_CRD) 

TYPE(Action) CAPTION(~návrh_perAkcí) EVENT(PER_pershead_navPL)   TIPTEXT(Návrh na realizaci personálních akcí ...)


TYPE(DBrowse) FPOS(0.5,0.1) SIZE(109,14) FILE(OSOBY) ;
                                         FIELDS(M->is_inMsPrc_mo:zam:2.6::2        , ;
                                                ncisOsoby:èíslOsoby:8              , ;
                                                nosCisPrac:èísloPrac:8              , ;
                                                cjmenoRozl:Pøíjmení_ jméno a rozlišení osoby:35, ;
                                                cUlicCiPop:Ulice a èp:25           , ;
                                                CMISTO:Mìsto:25                    , ;
                                                CZKRATSTAT:Stát                    , ;
                                                cosoba:Osoba                       , ;  
                                                cRodCisOsb:RodnéÈíslo              , ;
                                                CTELEFON:Telefon:15                , ;
                                                CEMAIL:Email:30                      ) ;
                                         CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(yy) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)


* 1 - základní údaje OSOBY
TYPE(TabPage) CAPTION(Info) OFFSET(1,86) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2) PRE(tabSelect) RESIZE(yx) TTYPE(3)
  TYPE(Text) CAPTION(Adresa)             CPOS( 1,  .1) CLEN(15) FONT(5)
  TYPE(Text) CAPTION(ulice)             CPOS( 3, 1.2)  CLEN(9)
  TYPE(Text) NAME(OSOBY->cUlicCiPop)    CPOS(13, 1.2)  CLEN(30) BGND(13) PP(2)
  TYPE(Text) CAPTION(mìsto)             CPOS( 3, 2.3)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CMISTO)        CPOS(13, 2.3)  CLEN(30) BGND(13) PP(2)
  TYPE(Text) CAPTION(psè)               CPOS( 3, 3.4)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CPSC)          CPOS(13, 3.4)  CLEN(6) BGND(13) PP(2)
  TYPE(Text) NAME(C_PSC->CMISTO)        CPOS(20, 3.4)   CLEN(23) BGND(13)
  TYPE(Text) CAPTION(stát)              CPOS( 3, 4.5)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CZKRATSTAT)    CPOS(13, 4.5)  CLEN(6) BGND(13) PP(2)
  TYPE(Text) NAME(C_STATY->cNAZEVSTAT)  CPOS(20, 4.5)   CLEN(23) BGND(13)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 2 - rodinní pøíslušníci  --> OSOBY -> VAZOSOBY 
TYPE(TabPage) CAPTION(RodPøíslušníci)  OFFSET(14,73) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(vazOsoby)                                    ;
                            FIELDS( vazOsoby->ctypRodPri:typVztahu:10                       , ;
                                    vazOsoby_osoby_Rp('ncisOsoby'):èísOsob                  , ;
                                    vazOsoby_osoby_Rp('cjmenoRozl'):Pøímení a jméno osoby:30, ;                                     
                                    vazOsoby_osoby_Rp('cjmenoOsob'):rozen(á)                , ;
                                    vazOsoby_osoby_Rp('crodCisOsb'):rodnéÈíslo:12           , ;
                                    vazOsoby_osoby_Rp('ddatNaroz'):datNaroz                 , ;   
                                    vazOsoby_osoby_Rp('CMISTO'):Mìsto:25                    , ;
                                    vazOsoby_osoby_Rp('CZKRATSTAT'):Stát                      ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)

*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 3 dùchody      --> DUCHODY
TYPE(TabPage) CAPTION(Dùchody)    OFFSET(27,60) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(duchody)             ;
                            FIELDS( M->is_Aktiv:ad:2.6::2           , ;
                                    nporDuchod:poøadí               , ;
                                    ntypDuchod:typ                  , ;
                                    cnazDuchod:název typu dùchodu:35, ;
                                    dpriznDuOd:pøiznán OD:10        , ; 
                                    dpriznDuDo:pøiznán DO:10        , ;
                                    cnazev:dùchod vyplácí:37          ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)

*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

* 4 pracovnì právní vztah --->PRSMLDOH
TYPE(TabPage) CAPTION(pracVztahy) OFFSET(40,47) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(prSmlDoh)   ;
                            FIELDS( nporPraVzt:poøPv       , ;
                                    cdruPraVzt:druhPv:15   , ;
                                    cvznPraVzt:vnznikPv:29 , ;
                                    ntypPraVzt:typPv       , ;
                                    ntypZamVzt:typZamVzt   , ;
                                    ddatVznPrv:datZalPv:12 , ;
                                    ddatNast:datNást:10    , ;
                                    ntypUkoPrv:typUkonèPv  , ;
                                    ddatVyst:datUkoèPv:10    ) ; 
                             CURSORMODE(3) PP(7) INDEXORD(PRSMLHOD08) SCROLL(yy) RESIZE(yx)

*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 5 vzdìlání      --> VZDELANI
TYPE(TabPage) CAPTION(Vzdìlání) OFFSET(53,35) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(Vzdelani)                           ;
                            FIELDS( nPoradi:poøVz                                  , ;
                                    czkrVzdel:typVz                                , ;
                                    M->nazev_Vzdelani:název dosaženého vzdìlání:32 , ;
                                    coborVzdel:obor vzdìlání:29                    , ;      
                                    npocLetStu:poèLet                              , ;
                                    dzacStudia:zaèátekSt:11                        , ; 
                                    dkonStudia:ukoneèno:11                           ) ;
                            CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yx)

*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 6 lékaøské prohlídky  --> OSOBY -> vazLekpr
TYPE(TabPage) CAPTION(LékProhlídky) OFFSET(65,22) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(LEKPROHL)                                       ;
                                           FIELDS( nporadi:poøLp                               , ;
                                                   czkratka:typLp                              , ;
                                                   M->nazev_lekPro:název lékaøské prohlídky:30 , ;
                                                   nperioOpak:perLp:8                          , ;
                                                   czkratJedn:za                               , ;
                                                   cnazevLeka:prohlídku provedl lékaø          , ; 
                                                   dposlLekPr:dne:10                           , ;
                                                   ddalsLekPr:dalšíLp:10                         )  ;
                                           CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)


*  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(VAZLEKPR)                                                   ;
*                                           FIELDS( vazLekpr_lekProhl('nporadi'):poøLp                      , ;
*                                                   vazLekpr_lekProhl('czkratka'):typLp                     , ;
*                                                   M->nazev_lekPro:název lékaøské prohlídky:30             , ;
*                                                   vazLekpr_lekProhl('nperioOpak'):perLp:8                 , ;
*                                                   vazLekpr_lekProhl('czkratJedn'):za                      , ;
*                                                   vazLekpr_lekProhl('cnazevLeka'):prohlídku provedl lékaø , ; 
*                                                   vazLekpr_lekProhl('dposlLekPr'):dne                     , ;
*                                                   vazLekpr_lekProhl('ddalsLekPr'):dalšíLp                   )  ;
*                                           CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)
*
*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(END)


* 7 školení/ kurzy  --> SKOLENI -> VAZSKOL
TYPE(TabPage) CAPTION(Školení) OFFSET(78,9) TABHEIGHT(.9) FPOS(1,14.50) SIZE(108,10.2)  PRE(tabSelect) RESIZE(yx) TTYPE(3)

  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(SKOLENI)                                      ;
                                            FIELDS( nporadi:poøŠk:5                          , ;
                                                    czkratka:typŠk                           , ;
                                                    M->nazev_Skoleni:název školení/ kurzu:30 , ;
                                                    nperioOpak:perŠk:8                       , ;
                                                    czkratJedn:za                            , ;
                                                    clektor:školení/ kurz vedl:25            , ;
                                                    dposlSkole:dne:10                        , ;
                                                    ddalsSkole:dalšíŠk:10                      )  ;
                                           CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)

*  TYPE(DBrowse) FPOS(.1,.1) SIZE(107.1,9.2) FILE(VAZSKOL)                                             ;
*                                           FIELDS( vazSkol_skoleni('nporadi'):poøŠk:5               , ;
*                                                   vazSkol_skoleni('czkratka'):typŠk                , ;
*                                                   M->nazev_Skoleni:název školení/ kurzu:30         , ;
*                                                   vazSkol_skoleni('nperioOpak'):perŠk:8            , ;
*                                                   vazSkol_skoleni('czkratJedn'):za                 , ;
*                                                   vazSkol_skoleni('clektor'):školení/ kurz vedl:25 , ;
*                                                   vazSkol_skoleni('dposlSkole'):dne                , ;
*                                                   vazSkol_skoleni('ddalsSkole'):dalšíŠk              )  ;
*                                           CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)
*
*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


*** QUICK FILTR ***
* TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
*   TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*   TYPE(PushButton) POS(74.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam osob)        ;
*                                    EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3) ;
*                                    ITEMSELECTED(comboItemSelected)
* TYPE(END)

