TYPE(drgForm) DTYPE(10) TITLE(Seznam expedièních listù ...) SIZE(110,25) ;                            
                                                            CARGO(PRO_explsthd_IN) OBDOBI(SKL)    ;
                                                            PRINTFILES( explsthd:ndoklad=ndoklad, ;
                                                                        explstit:ndoklad=ndoklad) 
   

  TYPE(Action) CAPTION(tvorba ~DodListù) EVENT(explst_dodlst) TIPTEXT(Vytvoøení dodacích listù z expedièního pøíkazu)
  TYPE(Action) CAPTION(~DodacíList(y))   EVENT(fin_dodlsthd)  TIPTEXT(Pøipojené dodací listy)

  TYPE(DBrowse) SIZE(110,8.7) FILE(EXPLSTHD)                      ;
                              FIELDS(M->isgen_dodList:dl:1::2   , ; 
                                     ndoklad:expList            , ;
                                     dExpedice:datExpedice      , ;
                                     dNakladky:datNakl          , ;
                                     ccasNaklad:èasNakl         , ;
                                     ncisFirDOP:dopravce        , ;
                                     cnazevDOP:název dopravce:55, ;
                                     cZKRATmenz:mìna              ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(ny) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* položky expedièího listu
  TYPE(TEXT) CAPTION(Položky expedièního listu) CPOS(.2,8.8) CLEN(109.5) FONT(5) PP(3) BGND(11) CTYPE(1)
  TYPE(DBrowse) FPOS(0,10) SIZE(109.6,7.7) FILE(EXPLSTIT)                        ;
                                           FIELDS( M->is_vyrZakit:vz:1::2      , ;
                                                   M->is_dodList:dl:1::2       , ;
                                                   ccisZakazI:zakázka:16       , ;
                                                   cnazZbo:název zakázky:30    , ;
                                                   M->firmaODB:odbìratel:33    , ;
                                                   M->firmaDOA:dodací adresa:33, ;
                                                   ncisloDL:dodací list        , ;
                                                   dNakladky:datNakl           , ;
                                                   ccasNaklad:casNakl          , ;
                                                   nFAKTMNOZ:množství          , ;
                                                   nCeJPrKDZ:cena/mj(d)        , ;
                                                   nCeCPrKDZ:cenaCelk            ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)

* položky dodacího listu
   TYPE(TEXT) CAPTION(Položky dodacího listu) CPOS(.2,17.7) CLEN(109.5) FONT(5) PP(3) BGND(11) CTYPE(1)
   TYPE(DBrowse) FPOS(0,18.8) SIZE(109.6,6.1) FILE(DODLSTIT)                 ;
                                              FIELDS( ndoklad:dodList       , ;
                                                      cNAZZBO:název zboží:35, ;
                                                      cSKLPOL:sklPol        , ;
                                                      nFAKTMNOZ:množFak     , ;
                                                      nCeJPrKDZ:cena/mj(d)  , ;
                                                      nCeCPrKDZ:cenaCelk    , ;
                                                     cCISZAKAZI:výrZakázka    ) ;
                                              CURSORMODE(3) PP(7) INDEXORD(5) SCROLL(ny) RESIZE(x)

