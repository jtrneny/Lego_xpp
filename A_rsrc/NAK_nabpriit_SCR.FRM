TYPE(drgForm) DTYPE(10) TITLE(Seznam nabídek pøijatých dle položek...) SIZE(110,26.5) CARGO(NAK_nabprihd_IN) ;
                                                                       PRINTFILES(nabpriit:ndoklad=ndoklad) 

  TYPE(DBrowse) SIZE(110,13.2) FILE(NABPRIIT)                        ;
                               FIELDS( ndoklad:doklad              , ;
                                       ncisPrij:èísloNab           , ;
                                       cnazPrij:èíslo_nabInt       , ;
                                       ncisFirmy:firma             , ;
                                       ddatDoDod:datNabídky        , ;
                                       ncenZakCel:cenaCelk           ) ;
                               CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yy) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)

*                                       M->nazFirmy:název firmy:43.8, ;


* položky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(1,82) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Hlavièka nabídky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)

*    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(NABPRIIT)                  ;
*                                           FIELDS( nintCount:pol          , ;
*                                                    ckatCZbo:katÈíslo      , ; 
*                                                    ccisSklad:sklad        , ; 
*                                                    csklpol:sklPol         , ;              
*                                                    cnazzbo:název zboží:35 , ;
*                                                    nmnozNOdes:mn_nabízeno , ;
*                                                    czkratJedn:mj          , ;
*                                                    ncenZakCel:cenCelk     , ;
*                                                    ncenZakCed:cenaCelksDPH  ) ;
*                                             CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) RESIZE(x)     


  TYPE(End)

* poznámnka z havièky dokladu
  TYPE(TabPage) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(16,68) CAPTION(poznDokladu) TABHEIGHT(.9) 
    TYPE(MLE) NAME('nabprihd->mpoznamka') FPOS( 1, 0.3) SIZE( 107.5,11) RESIZE(yx) READONLY(y)
  TYPE(End)
