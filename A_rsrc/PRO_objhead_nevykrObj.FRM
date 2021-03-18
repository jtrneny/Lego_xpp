TYPE(drgForm) DTYPE(10) TITLE(Nevykryté objednávky dle odbìratelù... ) SIZE(110,26.5)  ; 
              OBDOBI(FIN)                                                              ;
              POST(postValidate)                                                       ;                      
              PRINTFILES(objitem:ndoklad=ndoklad) 


  TYPE(Action) ATYPE(5)
*  TYPE(Action) CAPTION(    ~Fakturace)     EVENT(objhead_to_fakvyshd_in) TIPTEXT(nabídne poøízení faktury vystavené z položek objednávky) ICON1(171) ATYPE(3)
  TYPE(Action) CAPTION(~HromadnáFak)   EVENT(objhead_to_fakvyshd_in) TIPTEXT(hromadná fakturace nevykrytých objednávek dle oblastí...) 

  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(~PoøízeníFak)   EVENT(objhead_to_fakvyshd_ed) TIPTEXT(návrh poøízení faktury editaèním režimu...) 


  TYPE(EBrowse) FPOS(0,1.3) SIZE(110,12.2) FILE(OBJHEADWW)                                      ;  
                                           CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y) ;
                                           GUILOOK(ins:n)

    TYPE(TEXT) NAME(M->stav_objhead)       CLEN( 3) CAPTION()              BITMAP()
    TYPE(TEXT) NAME(objHeadWW->nklicObl)   CLEN( 6) CAPTION(obl)
    TYPE(TEXT) NAME(objHeadWW->ncisFirmy)  CLEN( 5) CAPTION(firma)  PICTURE(99999)
    TYPE(TEXT) NAME(objHeadWW->cnazev)     CLEN(23) CAPTION(název firmy)
    TYPE(GET)  NAME(objHeadWW->czkrZpuDop) CLEN(10) CAPTION(zpuDop)
    TYPE(TEXT) NAME(objHeadWW->culice)     CLEN(25) CAPTION(ulice firmy)
    TYPE(TEXT) NAME(objHeadWW->csidlo)     CLEN(25) CAPTION(místo firmy)
    TYPE(TEXT) NAME(objHeadWW->ddatobj)    CLEN(10) CAPTION(objDne)
    TYPE(TEXT) NAME(objHeadWW->cintPracov) CLEN(25) CAPTION(objPøijal)
    TYPE(TEXT) NAME(objHeadWW->czkrProdej) CLEN( 5) CAPTION(zkrProd)
    TYPE(TEXT) NAME(objHeadWW->nmnozObOdb) CLEN(13) CAPTION(mn_objednáno)
    TYPE(TEXT) NAME(objHeadWW->nmnozPlOdb) CLEN(13) CAPTION(mn_dodáno)
    TYPE(TEXT) NAME(objHeadWW->nkcsBDobj)  CLEN(13) CAPTION(celkBDanì)
    TYPE(TEXT) NAME(objHeadWW->nkcsZDobj)  CLEN(13) CAPTION(celkDDaní)
  TYPE(End)


*  TYPE(DBrowse) FPOS(0,1.3) SIZE(110,12.2) FILE(OBJHEADWW)       ;
*                              FIELDS(M->stav_objhead::2.7::2   , ;
*                                     nklicObl:obl:6            , ;
*                                     ncisfirmy:firma           , ;
*                                     cnazev:název firmy:23     , ;
*                                     czkrZpuDop:zpuDop:10      , ;   
*                                     culice:ulice firmy        , ;
*                                     csidlo:místo firmy        , ;
*                                     ddatobj:objDne:10         , ;
*                                     cintpracov:objPøijal      , ;
**                                     cnazpracov:kontOsoba      , ;
*                                     czkrprodej:zkrProdejce    , ;
*                                     nmnozobodb:mn_objednáno   , ;
*                                     nmnozplodb:mn_dodáno      , ;
*                                     nkcsbdobj:celkBDanì       , ;
*                                     nkcszdobj:celkSDaní         ) ;
*                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y) 


* položky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(1,82) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(EBrowse) FPOS(-.3,1) SIZE(109.6,10.6) FILE(OBJITEMWW)                                      ;  
                                               CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(yx) POPUPMENU(yn) ;
                                               GUILOOK(ins:n)

      TYPE(TEXT) NAME(M->objitem_is_kFak)    CLEN( 3) CAPTION()              BITMAP()
      TYPE(TEXT) NAME(M->objitem_is_kDis)    CLEN( 3) CAPTION()              BITMAP()
      TYPE(TEXT) NAME(M->stav_fakt)          CLEN( 3) CAPTION()              BITMAP()
      TYPE(TEXT) NAME(M->objitem_pocOdb)     CLEN( 3) CAPTION(odb)           PICTURE(999) 
      TYPE(TEXT) NAME(objitemWW->ccislOBint) CLEN(15) CAPTION(èísloObjed_in)
      TYPE(GET)  NAME(objitemWW->nordItem)   CLEN( 5) CAPTION(poøFak)
      TYPE(TEXT) NAME(objitemWW->crozPoradi) CLEN(10) CAPTION(poøPol)
      TYPE(TEXT) NAME(objitemWW->nzboziKat)  CLEN( 4) CAPTION(katZbo)
      TYPE(TEXT) NAME(objitemWW->csklPol)    CLEN(15) CAPTION(sklPol)
      TYPE(TEXT) NAME(objitemWW->cnazZbo)    CLEN(34) CAPTION(název zboží)
      TYPE(TEXT) NAME(objitemWW->nmnozOBodb) CLEN(13) CAPTION(mn_objednáno)
      TYPE(TEXT) NAME(objitemWW->nmnozPLodb) CLEN(13) CAPTION(mn_dodáno)
      TYPE(GET)  NAME(objitemWW->_nmnozkFak) FLEN(13) FCAPTION(mn_kFak)
      TYPE(TEXT) NAME(M->objitem_sumKFak)    CLEN(13) CAPTION(cek_kFak)
      TYPE(TEXT) NAME(M->cenZboz_kDis)       CLEN(13) CAPTION(cel_sklDisp)
      TYPE(TEXT) NAME(objitemWW->ncenaDLodb) CLEN(13) CAPTION(prodCena)
      TYPE(TEXT) NAME(objitemWW->ddatDoOdb)  CLEN(10) CAPTION(datDodání)
    TYPE(End)
  TYPE(End)


* poznámnka z havièky dokladu
  TYPE(TabPage) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(61,23) CAPTION(poznDokladu) TABHEIGHT(.9) 
    TYPE(MLE) NAME('objheadWW->mpoznobj')  FPOS( 1, 0.3) SIZE( 53,11) RESIZE(yx) READONLY(y)
    TYPE(MLE) NAME('objheadWW->mpoznamka') FPOS(54, 0.3) SIZE( 54,11) RESIZE(yx) READONLY(y)
  TYPE(End)

**** INFO pokud volá SCR z firmy a nemá objednávky nic nevidí, QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.2,1.25) RESIZE(yn)
*  TYPE(Text) NAME(objheadWW->cnazev)            CPOS( 1.5, .5) FONT(5) CLEN(30)

  TYPE(PushButton)                    POS(  1, .5)  SIZE(28,1.1) CAPTION(V rozsahu) EVENT(nevykrObj_createContext) ICON1(338) ATYPE(33)

  TYPE(Get)      NAME(M->DVYSTFAK)    FPOS(49, .5 ) FLEN(11) ;
                                                    FCAPTION(Datum vystavení ___) CPOS(32, .5) CLEN(16) PP(2) PUSH(CLICKDATE) 
  TYPE(ComboBox) NAME(M->cTYPPOHYBU)  FPOS(80, .52) FLEN(28) ; 
                                                    FCAPTION(Typ dokladu  ____)   CPOS(65, .5) CLEN(14) ;
                                                    VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) 

*
*   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
*     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*   TYPE(END) 
TYPE(END)


