TYPE(drgForm) SIZE(100,25) DTYPE(10) TITLE(Seznam osob ve výrobì ...) ISREADONLY(y);
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar) ;
              CARGO(OSB_osoby_CRD) 

TYPE(Action) CAPTION(~MzdovýTarif) EVENT(OSB_msTarind_in)   TIPTEXT(Založení/oprava mzdových tarifù ...)


TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(100,14) RESIZE(YN)
  TYPE(DBrowse) FPOS(0.5,1.05) SIZE(99,13) FILE(OSOBY) ;
                                           FIELDS(M->is_isEXT:ext:2.6::2             , ;
                                                  M->is_inMsPrc_mo:zam:2.6::2        , ;
                                                  ncisOsoby:èíslOsoby                , ;
                                                  nosCisPrac:èisloPrac               , ;
                                                  cjmenoRozl:Pøíjmení_jméno a rozlišení osoby:35, ;
                                                  cUlicCiPop:Ulice a èp:10              , ;
                                                  CMISTO:Mìsto:25                    , ;
                                                  CZKRATSTAT:Stát                    , ;
                                                  cosoba:Osoba                       , ;  
                                                  nosCisPrac:èísloPrac               , ;
                                                  CTELEFON:Telefon:15                , ;
                                                  CEMAIL:Email:30                      ) ;
                                           CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(yx) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)


*** QUICK FILTR ***
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yx)
    TYPE(TEXT) NAME( osoby->cJmenoRozl)            CPOS( 1.5, 0.6) FONT(5)  CLEN(30) 
    TYPE(TEXT) CAPTION([ )                         CPOS(31.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( osoby->ncisOsoby)             CPOS(33  , 0.6)          PICTURE(9999999) 
    TYPE(TEXT) CAPTION(/)                          CPOS(39.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( osoby->nosCisPrac)            CPOS(40  , 0.6)          PICTURE(99999) 
    TYPE(TEXT) CAPTION(] )                         CPOS(45.5, 0.6)          CLEN( 2)

     TYPE(STATIC) STYPE(2) FPOS(60.5, .09) SIZE(38.2,1.0) RESIZE(nx)
       TYPE(PushButton) POS(.1,.1)   SIZE(260,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
     TYPE(END) 
  TYPE(END)
TYPE(END)


* 1 - základní údaje OSOBY
TYPE(TabPage) CAPTION(Info) OFFSET(1,88) TABHEIGHT( .9) FPOS(1,14.5) SIZE(98,9.2) PRE(tabSelect) RESIZE(yy)
  TYPE(Text) CAPTION(Adresa)              CPOS( 1, 1.1)  CLEN( 9) FONT(5)
   TYPE(Text) CAPTION(ulice)               CPOS( 2, 2.2)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->cUlicCiPop)      CPOS( 9, 2.2)  CLEN(35) BGND(13) PP(2)
   TYPE(Text) CAPTION(mìsto)               CPOS( 2, 3.3)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->CMISTO)          CPOS( 9, 3.3)  CLEN(35) BGND(13) PP(2)
   TYPE(Text) CAPTION(psè)                 CPOS( 2, 4.4)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->CPSC)            CPOS( 9, 4.4)  CLEN( 6) BGND(13) PP(2)
   TYPE(Text) NAME(C_PSC->CMISTO)          CPOS(16, 4.4)  CLEN(28) BGND(13)
   TYPE(Text) CAPTION(stát)                CPOS( 2, 5.5)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->CZKRATSTAT)      CPOS( 9, 5.5)  CLEN( 6) BGND(13) PP(2)
   TYPE(Text) NAME(C_STATY->cNAZEVSTAT)    CPOS(16, 5.5)  CLEN(28) BGND(13)

  TYPE(Text) CAPTION(Pracovní zaøazení)   CPOS(46, 1)  CLEN(20) FONT(5)
   TYPE(Text) CAPTION(zaøazení)            CPOS(47, 2)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->cpracZar)        CPOS(57, 2)  FLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(c_pracZa->cnazPRACza)   CPOS(68, 2)  CLEN(27) BGND(13) PP(3)
  
   TYPE(TEXT) CAPTION(funkce)              CPOS(47, 3)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->cfunPra)         CPOS(57, 3)  CLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(c_funcPr->cnazFUNCpr)   CPOS(68, 3)  CLEN(27) BGND(13) PP(3)

   TYPE(TEXT) CAPTION(orgÚsek)             CPOS(47, 4)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->corgUsek)        CPOS(57, 4)  CLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(c_orgUsek->cnazev)      CPOS(68, 4)  CLEN(27) BGND(13) PP(3)

   TYPE(TEXT) CAPTION(kmenStø)             CPOS(47, 5)  CLEN( 7)
   TYPE(Text) NAME(OSOBY->ckmenSTRpr)      CPOS(57, 5)  CLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(cnazPol1->cnazev)       CPOS(68, 5)  CLEN(27) BGND(13) PP(3)

   TYPE(TEXT) CAPTION(pracovištì)          CPOS(47, 6)  CLEN( 9)
   TYPE(Text) NAME(OSOBY->cnazPol4)        CPOS(57, 6)  CLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(cnazPol4->cnazev)       CPOS(68, 6)  CLEN(27) BGND(13) PP(3)

   TYPE(TEXT) CAPTION(náklStøed)           CPOS(47, 7)  CLEN( 8)
   TYPE(Text) NAME(OSOBY->cnazPol1)        CPOS(57, 7)  CLEN( 8) BGND(13) PP(2)
   TYPE(TEXT) NAME(M->naklStred)           CPOS(68, 7)  CLEN(27) BGND(13) PP(3)
 
  TYPE(STATIC) STYPE(2) FPOS(45, .3) SIZE(52.2, 7.3) RESIZE(nx)
  TYPE(END) 

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 2 - spojení  --> SPOJENI -> VAZSPOJE 
TYPE(TabPage) CAPTION(Spojení)  OFFSET(12,77) TABHEIGHT(.9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(72.2,8.2) FILE(VazSPOJE)                                 ;
                              FIELDS( VazSpoje->nItem:Poøadí:4                            , ;
                                      vazSpoje_spojeni('ncisSpoj'):Èíslo:7                , ;
                                      vazSpoje_spojeni('cZkrSpoj'):Zkratka spojení:10     , ;
                                      vazSpoje_spojeni('cNazSpoj'):Název spojení:25       , ;
                                      vazSpoje_spojeni('cAdrElSpoj'):Elektronická adresa:40 ) ;
                              CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)

  TYPE(MLE) NAME(M->adrPoSpoj) FPOS(73.0,1.1) FCAPTION(Poštovní adresa) CPOS(73.0,0.1) SIZE(24,6.0) SCROLL(nn) PP(2) READONLY(y) RESIZE(nx)
TYPE(End)


* 3 firmy      --> FIRMY -> VAZFIRMY
TYPE(TabPage) CAPTION(Firmy)    OFFSET(23,66) TABHEIGHT(.9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(97.1,8.2) FILE(VazFIRMY)                     ;
                              FIELDS( VazFIRMY->nItem:Poøadí:4                , ;
                                      vazFirmy_firmy('ncisFirmy'):Èíslo:6     , ;
                                      vazFirmy_firmy('cNazev'):Název firmy:40 , ;
                                      VazFIRMY->cFunPra::11                   , ;
                                      C_FUNCPR->cNazFuncPr                      ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy)  RESIZE(yx)
TYPE(End)


* 4 úkoly      --> UKOLY -> VAZUKOLY
TYPE(TabPage) CAPTION(Úkoly) OFFSET(34,55) TABHEIGHT(.9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(97.1,8.2) FILE(VAZUKOLY)                       ;
                              FIELDS( nItem:Poø                                 , ;
                                      vazUkoly_ukoly('ncisUkolu'):Èíslo úkolu   , ;
                                      vazUkoly_ukoly('cZkrUkolu'):Zkratka:7     , ;
                                      vazUkoly_ukoly('cnazUkolu'):Název úkolu:40, ;
                                      vazUkoly_ukoly('dzacUkolu'):zaèDne        , ;
                                      vazUkoly_ukoly('dkonUkolu'):ukonDne       , ;
                                      vazUkoly_ukoly('dplzacUkol'):plánZaè      , ;
                                      vazUkoly_ukoly('dplkonUkol'):plánKon        )  ;  
                            CURSORMODE(3) PP(7) SCROLL(yy)  RESIZE(yx)
TYPE(End)


* 5 dokumenty  --> DOKUMENT -> VAZDOKUM
TYPE(TabPage) CAPTION(Dokumenty) OFFSET(45,44) TABHEIGHT(.9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(DBrowse) FPOS(0.5,0.1) SIZE(97.1,8.2) FILE(VAZDOKUM)                                              ;
                                             FIELDS( nItem:Poø:4                                       , ;
                                                     vazDokum_dokument('ncisDokum'):ÈísDok:7           , ;
                                                     vazDokum_dokument('cZkrDokum'):Zkratka            , ;
                                                     vazDokum_dokument('cNazDokum'):Název dokumentu:30 , ;
                                                     vazDokum_dokument('cSoubor'):Název souboru:25     , ;
                                                     vazDokum_dokument('mAdresar'):Adresáø:25            ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy)  RESIZE(yx)
TYPE(End)


* 6 skupiny osob  --> OSOBYSK
TYPE(TabPage) CAPTION(Skupiny) OFFSET(56,33) TABHEIGHT( .9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(Static) STYPE(12) SIZE(49, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)
   TYPE(TEXT)     CAPTION(Aktivní skupiny) CPOS(4.1,.1) CLEN(40.9) FONT(5) CTYPE(1) BGND(12) GROUPS(TEXT-5) 
     TYPE(DBrowse) FPOS(.4,1.1) SIZE(48,6.4) FILE(osobySK)                           ;
                                            FIELDS(M->setSkup:_:2.6::2            , ;
                                                   czkr_skup:skup:4               , ;
                                                   M->cnaz_Skup:název skupiny:40.2  ) ;
                                            CURSORMODE(3) PP(7) SCROLL(nn)   RESIZE(yx)
  TYPE(END)

  TYPE(Static) STYPE(12) SIZE(48, 7.8) FPOS( 49.5, 0.1) RESIZE(nx)
   TYPE(TEXT) CAPTION(informace o zaøazení/vyøazení ze skupiny) CPOS( 4.1, .1) CLEN(40.9) FONT(5)  CTYPE(1) BGND(12) GROUPS(TEXT-6) 
   TYPE(MLE)  NAME(osobySk->mPOZNAMKA) FPOS(0.4,1.1) SIZE(47,6.4) FONT(5) SCROLL(nn) PP(3) READONLY(y) RESIZE(xx)
  TYPE(END)
TYPE(END)


TYPE(TabPage) CAPTION(Poznámka) OFFSET(67,22) TABHEIGHT(.9) FPOS(1,14.5) SIZE(98,9.2)  PRE(tabSelect) RESIZE(yy)

  TYPE(MLE) NAME(OSOBY->mPOZNAMKA) FPOS(.5,0.15) SIZE(97,7.8) FONT(5) SCROLL(nn) PP(3) READONLY(y)  RESIZE(yx)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


