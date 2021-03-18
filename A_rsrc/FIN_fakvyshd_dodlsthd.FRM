TYPE(drgForm) DTYPE(10) TITLE(Dodací listy vystavené...) SIZE(100,25) ; 
                                                         OBDOBI(SKL) ISREADONLY(Y)  

  TYPE(DBrowse) SIZE(100,8.5) FILE(DODLSTHD)                     ;
                              FIELDS(nCISFIRMY:firma           , ; 
                                     nDOKLAD:èísloDlv          , ;
                                     dVYSTFAK:datVyst          , ; 
                                     cNAZEV:název odbìratele:37, ;
                                     nCENDANCEL:bez danì       , ;
                                     NCENZAKCEL:s daní         , ;
                                     cZKRATmenz:mìna             ) ;
                              CURSORMODE(3) PP(7) INDEXORD(11) SCROLL(ny) RESIZE(x) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)


* položky
   TYPE(TEXT) CAPTION(Položky dodacího listu) CPOS(.2,8.6) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
   TYPE(DBrowse) FPOS(0,9.8) SIZE(99.6,8.6) FILE(DODLSTIT)                  ;
                                            FIELDS( M->cenPol::2.6::2     , ;
                                                    CCISSKLAD:sklad       , ;
                                                    cNAZZBO:název zboží:35, ;
                                                    cSKLPOL:sklPol        , ;
                                                    nFAKTMNOZ:množFak     , ;
                                                    nCeJPrKDZ:cena/mj(d)  , ;
                                                    nCeCPrKDZ:cenaCelk      ) ;
                                            CURSORMODE(3) PP(7) INDEXORD(7) SCROLL(ny) RESIZE(x) POPUPMENU(yn) ITEMMARKED(itemMarked) 


* položky faktury
  TYPE(TABPAGE) FPOS(.5,18.5) SIZE(99,6.4) TTYPE(3) OFFSET(1,86) CAPTION(výdejky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky skladových výdejek) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99,4.3) FILE(PVPITEM)                  ;
                                         FIELDS(nDOKLAD:èísDokl       , ;
                                                CCISSKLAD:sklad       , ;   
                                                cSKLPOL:sklPol        , ;
                                                cNAZZBO:název zboží:30, ;
                                                nMnozPrDOD:množPol    , ; 
                                                nCenNapDod:cena/mj    , ; 
                                                nCenaCelk:cenaCelk      ) ;
                                          CURSORMODE(3) INDEXORD(2) PP(7) Resize(yx) SCROLL(ny) POPUPMENU(yn) ITEMMARKED(itemMarked) 
  TYPE(End)

* pohybové doklady
  TYPE(TABPAGE) FPOS(.5,18.5) SIZE(99.5,6.4) TTYPE(3) OFFSET(13,74) CAPTION(faktury) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Položky faktur vystavených) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99,4.3) FILE(FAKVYSIT)                  ;
                                          FIELDS(nCISFAK:èísFak        , ;
                                                 cNAZZBO:název zboží:35, ;
                                                 cSKLPOL:sklPol        , ;
                                                 nFAKTMNOZ:množFak     , ;
                                                 nCeCPrKDZ:cenaCelk    , ;
                                                 nRADVYKDPH:rvDph        ) ;
                                          CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(ny) RESIZE(x) POPUPMENU(yn) ITEMMARKED(itemMarked) 
  TYPE(End)
