TYPE(drgForm) DTYPE(10) TITLE(Seznam objednávek pøijatých) SIZE(110,26.5) CARGO(PRO_objhead_IN) ;
                                                PRINTFILES(objitem:ndoklad=ndoklad) 

  TYPE(Action) CAPTION(~Ruèní vykrytí)   EVENT(pro_objhead_vykr) TIPTEXT(Ruèní vykrytí objednávky pøijaté)
  TYPE(Action) CAPTION(~Znovu odeslat)   EVENT(pro_objhead_new_kom) TIPTEXT(Povolit znovu odeslání objednávky pøijaté)


  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(    ~Fakturace)     EVENT(objhead_to_fakvyshd_in) TIPTEXT(Nabídne poøízení faktury vystavené z položek objednávky ...) ICON1(171) ATYPE(3)
*  TYPE(Action) CAPTION(~HromadnáFak)   EVENT(objhead_to_fakvyshd_in) TIPTEXT(hromadná fakturace nevykrytých objednávek dle oblastí...) 


* FPOS(0,1.4)
  TYPE(DBrowse) FPOS(0,1.1) SIZE(110,13.2) FILE(OBJHEAD) ;
                              FIELDS(M->stav_komunik:stKom:4.2::2 , ;
                                     M->stav_objhead:stObj:4.2::2 , ;
                                     ndoklad:èísloobj             , ;
                                     ccislobint:èíslo_objGen      , ;
                                     ccisobj:èíslo_objOdb         , ;
                                     ncisfirmy:firma              , ;
                                     cnazev:název firmy:23        , ;
                                     culice:ulice firmy           , ;
                                     csidlo:místo firmy           , ;
                                     ddatobj:objDne               , ;
                                     cintpracov:objPøijal         , ;
                                     cnazpracov:kontOsoba         , ;
                                     czkrprodej:zkrProdejce       , ;
                                     nmnozobodb:mn_objednáno      , ;
                                     nmnozpoodb:mn_potvrzeno      , ;  
                                     nmnozplodb:mn_dodáno         , ;
                                     nkcsbdobj:celkBDanì          , ;
                                     nkcszdobj:celkSDaní          , ;
                                     ccisNabOd:èíslo_nabOdb      ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* položky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(-.3,1) SIZE(109.6,10.6) FILE(OBJITEM)                  ;
                                           FIELDS(M->stav_fakt:stFak:4.2::2 , ;
                                                  M->stav_Svyd:stVyd:4.2::2 , ; 
                                                  ncislpolob:pol            , ;
                                                  csklpol:sklPol            , ;              
                                                  cnazzbo:název zboží:34    , ;
                                                  nmnozobodb:mn_objednáno   , ;
                                                  nmnozpoodb:mn_potvrzeno   , ;  
                                                  nmnozplodb:mn_dodáno      , ;
                                                  ncenazakl:cenaMj          , ;
                                                  nhodnslev:slevaZákl       , ;
                                                  nkcsbdobj:celkBDanì       , ;
                                                  nkcszdobj:ceklSDaní       , ;
                                                  ddatDoOdb:datDodání         ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(yx)     

  TYPE(End)

* dle Fakturace
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(13,74) CAPTION(fakturace) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Fakturace objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(FAKVYSIT)                      ;
                                           FIELDS(M->stav_fakvysit:stFak:2.7::2, ;
                                                  M->datvys_fakvysit:datVyst:10, ;
                                                  ncisfak:èísloFak             , ; 
                                                  csklpol:sklPoložka           , ;
                                                  cnazzbo:název zboží:30       , ;
                                                  nfaktmnoz:faktMnož           , ;
                                                  czkratjedn:mj                , ;     
                                                  ncejprkdz:cena/mj            , ;
                                                  ncecprkdz:cenaCelk             ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* dle DodListù
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(25,62) CAPTION(dodListy) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Dodací listy objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(DODLSTIT)                  ;
                                           FIELDS(ndoklad:èísloDol        , ; 
                                                  csklpol:sklPoložka      , ;
                                                  cnazzbo:název zboží:33  , ;
                                                  nfaktmnoz:faktMnož      , ;
                                                  czkratjedn:mj           , ;     
                                                  ncenjedzak:cena/mj      , ;
                                                  ncenzakcel:cenaCelk       ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)

* dle VýrZakázek
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(37,50) CAPTION(výrZakázky) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)  
    TYPE(TEXT) CAPTION(Vyrobené položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(OBJZAK)                               ;
                                           FIELDS(cciszakaz:výrZakázka               , ;
                                                  M->stav_objzak_naz:název zakázky:43, ; 
                                                  nmnpotvyrz:mn_potvrzeno            , ;
                                                  nmnozdodvy:mn_vyrobeno             , ;
                                                  M->stav_objzak_plm:mn_plánováno:9  , ;                         
                                                  dtermpovyr:datDod                  , ;
                                                  cstavvazby:stav                      ) ; 
                                             CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)

  TYPE(End)

* poznámnka z havièky dokladu
  TYPE(TabPage) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(49,37) CAPTION(poznDokladu) TABHEIGHT(.9) RESIZE(yx)
    TYPE(MLE) NAME('objhead->mpoznobj') FPOS( 1, 1.3) SIZE( 107.5,10) RESIZE(yx) READONLY(y)
  TYPE(End)

*** INFO pokud volá SCR z firmy a nemá objednávky nic nevidí, QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.2,1.25) RESIZE(yn)
  TYPE(Text) NAME(firmy->cnazev)            CPOS( 1.5, .5) FONT(5) CLEN(30)

*
   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 
TYPE(END)


