TYPE(drgForm) DTYPE(10) TITLE(Dodací listy pøijaté...) SIZE(100,25) ;
                                                       CARGO(NAK_dodlstPhd_IN) OBDOBI(SKL) ;
                                                       PRINTFILES( dodlstPhd:ndoklad=ndoklad, ;
                                                                   dodlstPit:ndoklad=ndoklad)

  TYPE(DBrowse) SIZE(100,8.5) FILE(DODLSTPHD)                    ;
                              FIELDS(M->is_taskPro::2.6::2     , ;
                                     nCISFIRMY:firma           , ;
                                     nDOKLAD:èísloDlv          , ;
                                     dVYSTFAK:datVyst          , ;
                                     cNAZEV:název odbìratele:37, ;
                                     NCENZAHCEL:s daní         , ;
                                     cZKRATmenz:mìna           , ;
                                     nosvoddan:osvobozeno      , ; 
                                     nzakldan_1:základ(sd)     , ;
                                     nsazdan_1:sazba(sd)       , ;
                                     nzakldan_2:základ(zd)     , ;
                                     nsazdan_2:sazba(zd)         ) ;
                              CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(ny) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


* položky
   TYPE(TEXT) CAPTION(Položky dodacího listu) CPOS(.2,8.6) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
   TYPE(DBrowse) FPOS(0,9.8) SIZE(99.6,8.6) FILE(DODLSTPIT)                 ;
                                            FIELDS( M->cenPol::2.6::2     , ;
                                                    ndoklad:èísloDl:10    , ; 
                                                    cNAZZBO:název zboží:35, ;
                                                    cSKLPOL:sklPol        , ;
                                                    nFAKTMNOZ:množFak     , ;
                                                    cZKRATJEDN:jed:3      , ;
                                                    nCeCPrKBZ:cenaCelk    , ;
                                                    nCeJPrKDZ:cena/mj(d)  , ;
                                                    nCeCPrKDZ:cenaCelk    , ;
                                                    cCISZAKAZI:výrZakázka   ) ;
                                            CURSORMODE(3) PP(7) INDEXORD(5) SCROLL(ny) RESIZE(x) ITEMMARKED(itemMarked)


* položky faktury
  TYPE(TABPAGE) FPOS(.5,18.5) SIZE(99,6.4) TTYPE(3) OFFSET(1,86) CAPTION(faktury) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky faktur pøijatých) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99,4.3) FILE(FAKPRIIT)                  ;
                                         FIELDS(nCISFAK:èísFak:10     , ;
                                                cNAZZBO:název zboží:35, ;
                                                cSKLPOL:sklPol        , ;
                                                nCeJPrKBz             , ;
                                                nFAKTMNOZ:množFak:13  , ;
                                                cZKRATJEDN:jed:3      , ;
                                                nCeCPrKBZ:cenaCelk    , ;
                                                nCeCPrKDZ:cenaCelksDPH   , ;
                                                nRADVYKDPH:rvDph      , ;
                                                cCISZAKAZI:výrZakázka , ;
                                                cUCETSKUP:UèSk          ) ;
                                          CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(ny) RESIZE(x) 
  TYPE(End)

* pohybové doklady
  TYPE(TABPAGE) FPOS(.5,18.5) SIZE(99.5,6.4) TTYPE(3) OFFSET(13,74) CAPTION(pøíjemky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky skladových pøíjemek) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(99,4.3) FILE(PVPITEM)                  ;
                                         FIELDS(nDOKLAD:èísDokl       , ;
                                                cSKLPOL:sklPol        , ;
                                                cNAZZBO:název zboží:30, ;
                                                nMnozPrDOD:množPol    , ;
                                                nCenNapDod:cena/mj    , ;
                                                nCenaCelk:cenaCelk      ) ;
                                          CURSORMODE(3) INDEXORD(2) PP(7) Resize(yx) SCROLL(ny) 

  TYPE(End)

* expedièní listy
*  TYPE(TABPAGE) FPOS(.5,18.5) SIZE(99.5,6.4) TTYPE(3) OFFSET(25,62) CAPTION(expList) TABHEIGHT(.8) PRE(tabSelect)
*    TYPE(TEXT) CAPTION(Položky expedièních listù) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*    TYPE(DBrowse) FPOS(0,1) SIZE(99,4.3) FILE(EXPLSTIT)                          ;
*                                           FIELDS( M->is_vyrZakit:vz:1::2      , ;
*                                                   M->is_dodList:dl:1::2       , ;
*                                                   ccisZakazI:zakázka:16       , ;
*                                                   cnazZbo:název zakázky:30    , ;
*                                                   M->firmaODB:odbìratel:33    , ;
*                                                   M->firmaDOA:dodací adresa:33, ;
*                                                   ncisloDL:dodací list        , ;
*                                                   dNakladky:datNakl           , ;
*                                                   ccasNaklad:casNakl          , ;
*                                                   nFAKTMNOZ:množství          , ;
*                                                   nCeJPrKDZ:cena/mj(d)        , ;
*                                                   nCeCPrKDZ:cenaCelk            ) ;
*                                           CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(yx) SCROLL(ny) 
*
*  TYPE(End)


