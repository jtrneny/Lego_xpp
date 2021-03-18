TYPE(drgForm) DTYPE(10) TITLE(Editace evidence pozemkù) SIZE(105,25) FILE(POZEMKY);
              OBDOBI(HIM) CARGO(HIM_pozemky_CRD) PRE(preValidate) POST(POSTVALIDATE) ;
              PRINTFILES(pozemky:npozemek=npozemek)

  TYPE(Action) CAPTION(~HM_Karta)   EVENT()                     TIPTEXT(Karta hmotného majetku)
  TYPE(Action) CAPTION(~PøepCeny)   EVENT(HIM_pozemkit_vypCen)  TIPTEXT(Pøepoèet ceny parcel)
*  TYPE(Action) CAPTION(~Web_CUZK)  EVENT()                     TIPTEXT(Odkaz na katastr nemovitostí)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(Pø~evod na LV)  EVENT(HIM_pozemky_prevPoz) TIPTEXT(pøevod na list vlastnictví) 
* ICON1(338) ATYPE(33)



* POZEMKY
*
  TYPE(STATIC) FPOS( .4,.5) SIZE(104.2,14) STYPE(12)  CTYPE(2)
    TYPE(DBrowse) FILE(POZEMKY) INDEXORD(2)           ;
                  FIELDS(cku_Kod:KU:7               , ;
                         cku_Nazev::20              , ;
                         nlistVlast:LV:10           , ;
                         cparcCis:èísloParc:15      , ; 
                         cparcCisP:èísloParc_pùv:15 , ;
                         cpodil:podíl:7             , ;
                         nVymera_m2:výmìra_m2:10    , ;
                         npodVym_m2:podVým_m2:10    , ;
                         ndruhPozem:druhPoz:10      , ;
                         ncenaPoz:cena:11           , ;
                         ndanNabPoz:daò:11          , ;
                         ncenaSDaNa:cenaS_daní:11   , ;
                         cBPEJ:bonita:6             , ;
                         mpoznamka:pùvVlast:15        ) ;
                   FPOS(-.4,.1) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) POPUPMENU(y) ITEMMARKED( ItemMarked)  
  TYPE(End)
  
* pozemkyit
*
  TYPE(STATIC) FPOS( .4,14.8) SIZE(104.2,10) STYPE(12)  CTYPE(2)
    TYPE(TEXT) CAPTION(Položky - pohyby evidence pozemkù) CPOS(.2,.1) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(DBrowse) FILE(POZEMKIT) INDEXORD(2)          ;
                  FIELDS(ninvCis:invÈíslo:10        , ;
                         cku_Kod:KU:7               , ;
                         nlistVlast:LV:10           , ;
                         cparcCis:èísloParc:15      , ; 
                         cparcCisP:èísloParc_pùv:15 , ;
                         cpodil:podíl:7             , ;
                         nVymera_m2:výmìra_m2:10    , ;
                         npodVym_m2:podVým_m2:10    , ;
                         ndruhPozem:druhPoz:10      , ;
                         ncenaPoz:cena:11           , ;
                         ndanNabPoz:daò:11          , ;
                         ncenaSDaNa:cenaS_daní:11   , ;
                         cBPEJ:bonita:6             , ;
                         mpoznamka:pùvVlast:15        ) ;
                   FPOS(-.4,1.1) SIZE(104.2,9) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
  TYPE(End)

TYPE(End)
