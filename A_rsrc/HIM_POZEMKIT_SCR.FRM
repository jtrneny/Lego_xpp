TYPE(drgForm) DTYPE(10) TITLE(Editace evidence pozemk�) SIZE(105,25) FILE(POZEMKIT);
              OBDOBI(HIM) CARGO(HIM_pozemky_CRD) PRE(preValidate) POST(POSTVALIDATE) ;
              PRINTFILES(pozemky:npozemek=npozemek)

TYPE(Action) CAPTION(~HM_Karta)   EVENT()                     TIPTEXT(Karta hmotn�ho majetku)
TYPE(Action) CAPTION(~P�epCeny)   EVENT(HIM_pozemkit_vypCen)  TIPTEXT(P�epo�et ceny parcel)


* POZEMKY
*
*  TYPE(STATIC) FPOS( .4,.5) SIZE(104.2,14) STYPE(12)  CTYPE(2)

* pozemkyit
*
  TYPE(STATIC) FPOS( .4,0.8) SIZE(104.2,24) STYPE(12)  CTYPE(2)
    TYPE(TEXT) CAPTION(Pohyby - polo�ky evidence pozemk�) CPOS(.2,.1) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(DBrowse) FILE(POZEMKIT) INDEXORD(2)          ;
                  FIELDS(ninvCis:inv��slo:10        , ;
                         cku_Kod:KU:7               , ;
                         nlistVlast:LV:10           , ;
                         cparcCis:��sloParc:15      , ; 
                         cparcCisP:��sloParc_p�v:15 , ;
                         cpodil:pod�l:7             , ;
                         nVymera_m2:v�m�ra_m2:10    , ;
                         npodVym_m2:podV�m_m2:10    , ;
                         ndruhPozem:druhPoz:10      , ;
                         ncenaPoz:cena:11           , ;
                         ndanNabPoz:da�:11          , ;
                         ncenaSDaNa:cenaS_dan�:11   , ;
                         cBPEJ:bonita:6             , ;
                         mpoznamka:p�vVlast:15        ) ;
                   FPOS(-.4,1.1) SIZE(104.2,23) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy)
  TYPE(End)

TYPE(End)
