TYPE(drgForm) DTYPE(10) TITLE(Seznam nabídek odeslaných) SIZE(110,26.5) CARGO(PRO_nabvyshd_IN) ;
                                                         PRINTFILES(nabvyshd:ndoklad=ndoklad,; 
                                                                    nabvysit:ndoklad=ndoklad) 



  TYPE(Action) CAPTION(nabídka_~Kopie)   EVENT(PRO_nabvyshd_new_CPY) TIPTEXT(Vytvoøení kopie nabídky vystavené)

  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(d~Oplòující      ) EVENT(createContext_ex) TIPTEXT(POZOR !!! možnost zmìny stavu dokladu ...  )  ICON1(338) ATYPE(33)
  TYPE(Action) CAPTION(o~Bjednávka      ) EVENT(PRO_objhead_in)   TIPTEXT(Generování objednávky pøijaté z nabídky ...)  ICON1(425) ATYPE(33)




  TYPE(DBrowse) SIZE(110,12.2) FILE(NABVYSHD)                        ;
                               FIELDS( M->nabVyshd_obj::2.7::2     , ;
                                       ndoklad:doklad              , ;
                                       ccisNabOd:èíslo_nabOdb      , ;
                                       ncisFirmy:firma             , ;
                                       cnazev:název firmy:35       , ;
                                       ddatOdes:nabDne:10          , ;
                                       ncenZakCel:cenaCelk         , ;
                                       cintPracov:nabVystavil:25   , ; 
                                       ncisOdes:poøNabGen          , ;
                                       cnazOdes:èíslo_nabOdbìratele  )  ;
                               FPOS(0.5,1.4) CURSORMODE(3) PP(7) INDEXORD(5) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* položky nabídky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(1,83) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky nabídky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(NABVYSIT)                  ;
                                            FIELDS( M->nabVysit_obj::2.7::2     , ;
                                                    nintCount:pol          , ;
                                                    ccisSklad:sklad        , ; 
                                                    csklpol:sklPol         , ;              
                                                    cnazzbo:název zboží:35 , ;
                                                    nCenJedZak:cenaMj      , ;     
                                                    nmnozNOdes:mn_nabízeno , ;
                                                    czkratJedn:mj          , ;
                                                    ncenZakCel:cenCelk     , ;
                                                    ncenZakCed:cenaCelksDPH  ) ;
                                             CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(x)     


  TYPE(End)

* položky objednávky vystavené
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(16,68) CAPTION(Položky objednávky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*    M->stav_fakt:fa:4.2::2 , ; M->stav_Svyd:vy:4.2::2 , ;                                  10.6

    TYPE(DBrowse) FPOS(-.3,1) SIZE(109.6,10.6) FILE(OBJITEM)                   ;
                                               FIELDS(ndoklad:doklad         , ;
                                                      ncislpolob:pol         , ;
                                                      ccisSklad:sklad        , ;
                                                      csklpol:sklPol         , ;              
                                                      cnazzbo:název zboží:34 , ;
                                                      nmnozobodb:mn_objednáno, ;
                                                      nmnozpoodb:mn_potvrzeno, ;  
                                                      nmnozplodb:mn_dodáno   , ;
                                                      ncenazakl:cenaMj       , ;
                                                      nhodnslev:slevaZákl    , ;
                                                      nkcsbdobj:celkBDanì    , ;
                                                      nkcszdobj:ceklSDaní    , ;
                                                      ddatDoOdb:datDodání      ) ;
                                               CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(x)     

  TYPE(End)





* poznámnka z havièky dokladu
  TYPE(TabPage) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(32,54) CAPTION(poznDokladu) TABHEIGHT(.9) 
    TYPE(MLE) NAME('nabvyshd->mpoznamka') FPOS( 1, 0.3) SIZE( 107.5,11) RESIZE(yx) READONLY(y)
  TYPE(End)


*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Nabídky vystavené)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(77, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(223, 23) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 
 TYPE(END)


