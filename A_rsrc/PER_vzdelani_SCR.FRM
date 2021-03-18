TYPE(drgForm) DTYPE(10) TITLE(Dosažená vzdìlání (personalistika) ) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_osoby_CRD)

* TYPE(Action) CAPTION(~Dokl_HM ) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
* TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


*TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)
*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
*                VALUES(a,a,a,a,a,a,a,a,a);
*                COMBOINIT(comboBoxInit);
*                ITEMSELECTED(comboItemSelected)
*
*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
*                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
*                ITEMSELECTED(comboItemSelected)
*TYPE(END)


TYPE(DBrowse) FPOS(0,0) SIZE(99,10.2) FILE(OSOBY) ;
                                          FIELDS(M->is_inPersonal:per:2.6::2                   , ;
                                                 M->is_inMsPrc_mo:zam:2.6::2                   , ;
                                                 ncisOsoby:èíslOsoby                           , ;
                                                 cjmenoRozl:Pøíjmení_jméno a rozlišení osoby:35, ;
                                                 cUlicCiPop:Ulice a èp:10                      , ;
                                                 CMISTO:Mìsto:25                               , ;
                                                 CZKRATSTAT:Stát                               , ;
                                                 cosoba:Osoba                                  , ;  
                                                 nosCisPrac:èísloPrac                          , ;
                                                 CTELEFON:Telefon:15                           , ;
                                                 CEMAIL:Email:30                                 ) ;
                                          CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(yy) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)

TYPE(DBrowse) FPOS(0,10.5) SIZE(99,7) FILE(Vzdelani)   ;
                                           FIELDS( nPoradi:poø                    , ;
                                                   cZkrVzdel:typVzdìl             , ;
                                                   M->nazVzdela:název vzdìlání:40 , ;
                                                   dzacStudia:dat_OD              , ; 
                                                   dkonStudia:dat_DO              , ; 
                                                   nPocLetStu:roky                , ;
                                                   cZkrUkoVzd:zpuUkoè             , ;
                                                   dkonStudia:ukonèeno              ) ;
                                     CURSORMODE(3) INDEXORD(5) PP(7) RESIZE(x) SCROLL(yy) ITEMMARKED(ItemMarked)


TYPE(STATIC) STYPE( 2) FPOS(0.50,17.5) CAPTION(Údaje o vzdìlání pracovníka) SIZE(98.75,7.2) RESIZE(YX)
  TYPE(TEXT) NAME(Vzdelani ->czkrVzdel)    CPOS( 2, 1)    CLEN( 8) BGND(13) PP(2) FONT(5)
  TYPE(TEXT) NAME(c_Vzdel->cNazVzdela)     CPOS(17, 1)    CLEN(30) BGND(13) PP(2)
  TYPE(TEXT) CAPTION(od)                   CPOS(48, 1)    CLEN( 3)
  TYPE(TEXT) NAME(vzdelani->dzacStudia)    CPOS(51, 1)    CLEN(10) BGND(13) PP(2)
  TYPE(TEXT) CAPTION(do)                   CPOS(62, 1)    CLEN( 3)
  TYPE(TEXT) NAME(vzdelani->dkonStudia)    CPOS(65, 1)    CLEN(10) BGND(13) PP(2)
  TYPE(TEXT) NAME(vzdelani->npocLetStu)    CPOS(76, 1)    CLEN( 7) BGND(13) PP(2)
  TYPE(TEXT) CAPTION(roky)                 CPOS(83, 1)    CLEN( 4)
   
  TYPE(TEXT) CAPTION(Obor vzdìlání ...)    CPOS( 2, 2.1)  CLEN(15)
  TYPE(TEXT) NAME(Vzdelani->cOborVzdel)    CPOS(17, 2.1)  CLEN(44)  BGND(13) PP(2)

  TYPE(TEXT) CAPTION(Zpùsob ukonèení ...)  CPOS( 2, 3.1)  CLEN(15)
  TYPE(TEXT) NAME(Vzdelani->cZkrUkoVzd)    CPOS(17, 3.1)  CLEN( 8)  BGND(13) PP(2)
  TYPE(TEXT) NAME(C_VzdeUk->cNazUkoVzd)    CPOS(27, 3.1)  CLEN(34)  BGND(13) PP(2)
  TYPE(TEXT) CAPTION(ukonèeno dne)         CPOS(62, 3.1)  CLEN(13)
  TYPE(TEXT) NAME(Vzdelani->dkonStudia)    CPOS(76, 3.1)  CLEN(10)  BGND(13) PP(2)

  TYPE(TEXT) CAPTION(Název školy ...)      CPOS( 2, 4.3)   CLEN(13)
  TYPE(TEXT) NAME(Vzdelani->cNazevSkol)    CPOS(17, 4.3)   CLEN(44)  BGND(13) PP(2)
  TYPE(TEXT) CAPTION(zkrŠkoly)             CPOS(62, 4.3)   CLEN(13)
  TYPE(TEXT) NAME(Vzdelani->cZkratSkol)    CPOS(76, 4.3)   CLEN(10)  BGND(13) PP(2)

  TYPE(TEXT) CAPTION(Adresa školy ...)     CPOS( 2, 5.3)   CLEN(13)
  TYPE(TEXT) NAME(Vzdelani->cUlice)        CPOS(17, 5.3)   CLEN(44)  BGND(13) PP(2)

  TYPE(TEXT) NAME(Vzdelani->cPSC)          CPOS(17, 6.3)   CLEN( 8)  BGND(13) PP(2)
  TYPE(TEXT) NAME(Vzdelani->cMisto)        CPOS(27, 6.3)   CLEN(25)  BGND(13) PP(2)
TYPE(END)