TYPE(drgForm) DTYPE(10) TITLE(Seznam objednávek vystavených ...) SIZE(110,26.5) CARGO(NAK_objvyshd_IN)   ;
                                                     PRINTFILES(objvyshd:ndoklad=ndoklad, ;
                                                                       objvysit:ndoklad=ndoklad)

  TYPE(Action) CAPTION(~Ruèní vykrytí) EVENT(nak_objvyshd_vykr) TIPTEXT(Ruèní vykrytí objednávky vystavené)
*  TYPE(Action) CAPTION(~Likvidace) EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)

  TYPE(DBrowse) SIZE(110,13.2) FILE(OBJVYSHD)                        ;
                               FIELDS(M->stav_objvyshd:S:4.2::2    , ;
                                      M->datum_tisku:T:2.7::2      , ; 
                                      M->datum_emailu:E:2.7::2     , ; 
                                      ndoklad:èísloObj             , ; 
                                      ccisobj:èísloObj_int         , ;
                                      ncisfirmy:firma              , ;
                                      cnazev:název firmy:26        , ;
                                      ddatobj:objDne:10            , ;
                                      nmnozobdod:mn_objednáno      , ;
                                      nmnozpodod:mn_potvrzeno      , ;  
                                      nmnozpldod:mn_dodáno         , ;
                                      nkczdobj:cenaCelk            , ;
                                      czkratMenz:mìna              , ;
                                      czakobjInt:ObjZakázka        ) ;
                               CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* položky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(1,83) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(OBJVYSIT)                   ;
                                             FIELDS(M->stav_objvysit:S:4.2::2, ;
                                                    ccissklad:sklad         , ; 
                                                    csklpol:sklPol          , ;             
                                                    cnazzbo:název zboží:31  , ;
                                                    cjakost:jakost          , ;  
                                                    nmnozobdod:mn_objednáno , ;
                                                    nmnozpodod:mn_potvrzeno , ;  
                                                    nmnozpldod:mn_dodáno    , ;
                                                    nkczdobj:cenaCelk         ) ;
                                             CURSORMODE(3) PP(7) INDEXORD(2) SCROLL(ny) RESIZE(x)     
  TYPE(End)

* pøíjemky
  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(16,68) CAPTION(pøíjemky) TABHEIGHT(.9) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Položky skladových pøíjemek k objednávce) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109,10.6) FILE(PVPITEM)                ;
                                           FIELDS(nDOKLAD:èísDokl       , ;
                                                  CCISSKLAD:sklad       , ;   
                                                  cSKLPOL:sklPol        , ;
                                                  cNAZZBO:název zboží:30, ;
                                                  nMnozPrDOD:množPol    , ; 
                                                  nCenNapDod:cena/mj    , ; 
                                                  nCenaCelk:cenaCelk      ) ;
                                            CURSORMODE(3) INDEXORD(2) PP(7) Resize(yx) SCROLL(ny) RESIZE(x)

  TYPE(END)


* dle Fakturace
*  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(16,68) CAPTION(fakturace) TABHEIGHT(.9) PRE(tabSelect)  
*    TYPE(TEXT) CAPTION(Fakturace objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(FAKVYSIT)                  ;
*                                           FIELDS(M->stav_fakvysit::2.7::2, ;
*                                                  ncisfak:èísloFak        , ; 
*                                                  csklpol:sklPoložka      , ;
*                                                  cnazzbo:název zboží:30  , ;
*                                                  nfaktmnoz:faktMnož      , ;
*                                                  czkratjedn:mj           , ;     
*                                                  ncejprkdz:cena/mj       , ;
*                                                  ncecprkdz:cenaCelk        ) ;
*                                           CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)
*  TYPE(End)

* dle DodListù
*  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(31,53) CAPTION(dodListy) TABHEIGHT(.9) PRE(tabSelect)  
*    TYPE(TEXT) CAPTION(Dodací listy objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(DODLSTIT)                  ;
*                                           FIELDS(ncisfak:èísloDol        , ; 
*                                                  csklpol:sklPoložka      , ;
*                                                  cnazzbo:název zboží:33  , ;
*                                                  nfaktmnoz:faktMnož      , ;
*                                                  czkratjedn:mj           , ;     
*                                                  ncenjedzak:cena/mj      , ;
*                                                  ncenzakcel:cenaCelk       ) ;
*                                           CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)
*  TYPE(End)

* dle VýrZakázek
*  TYPE(TABPAGE) FPOS(.5,13.4) SIZE(109.5,12.8) TTYPE(3) OFFSET(46,38) CAPTION(výrZakázky) TABHEIGHT(.9) PRE(tabSelect)  
*    TYPE(TEXT) CAPTION(Vyrobené položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,10.6) FILE(OBJZAK)                               ;
*                                           FIELDS(cciszakaz:výrZakázka               , ;
*                                                  M->stav_objzak_naz:název zakázky:43, ; 
*                                                  nmnpotvyrz:mn_potvrzeno            , ;
*                                                  nmnozdodvy:mn_vyrobeno             , ;
*                                                  M->stav_objzak_plm:mn_plánováno:9  , ;                         
*                                                  dtermpovyr:datDod                  , ;
*                                                  cstavvazby:stav                      ) ; 
*                                             CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny)
*  TYPE(End)