TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží - VÝBÌR) SIZE(100, 23)      ;
                                                   POST(postValidate) ;
                                                   GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)


  TYPE(Action) CAPTION(info C~eník)    EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

TYPE(Static) STYPE(13) SIZE(100,10.8) FPOS(0,1.2) RESIZE(yy)
  TYPE(DBrowse) FPOS( -.5,-.1) FILE(CENZBOZ) INDEXORD(1)     ;
                              FIELDS(M->cenPol::2.6::2      , ;                                                 
                                     cCISSKLAD:èisSklad     , ;
                                     nZBOZIKAT:katZbo       , ;
                                     cSKLPOL:sklPoložka     , ;
                                     cNAZZBO:název zboží:33 , ;
                                     cJKPOV:jkpov           , ;
                                     nmnozKZbo:množKObj     , ;
                                     nmnozDZbo:množKDisp    , ;
                                     nmnozSZbo:množSkl      , ;
                                     nmnozOZbo:množObj      , ;
                                     nmnozRZbo:množRez      , ; 
                                     nminZbo:množMin        , ; 
                                     nCENAPZBO:prodCena     , ;
                                     CJAKOST:jakost         , ;
                                     CZKRATJEDN:mj            ) ;
                                     CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy) ITEMSELECTED( RecordSelected) ITEMMARKED(itemMarked) POPUPMENU(yy) 
TYPE(END)

*    
TYPE(Static) STYPE(13) SIZE( 99.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(CENÍK ZBOŽÍ) CPOS( 45, 0.1) CLEN( 20) FONT(5)

  TYPE(Static) STYPE(1)       SIZE(23,1.2)  FPOS( 76.5,0.1)  RESIZE(nx)
  TYPE(PushButton) POS(0,0)   SIZE(23,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) TIPTEXT(Volba zobrazení dat) ICON1(101) ICON2(201) ATYPE(3)

  TYPE(End)
TYPE(End)                                    

                   
* košík
  TYPE(Static) STYPE(12) SIZE(99,2.3) FPOS(.5,12) CTYPE(2) RESIZE(yn)
    TYPE(PushButton)                              POS( 93, 1.3) ;
                                                  SIZE( 6, 2.3) EVENT(smallBasket) ICON1(208) ICON2(108) ATYPE(1) ;
                                                  CAPTION(2)

    TYPE(Text)  CAPTION(katalogÈíslo)             CPOS( 3,0) CLEN(12) CTYPE(1)
    TYPE(Get)   NAME(M->smallBasket_katCZbo)      FPOS( 3,1 ) FLEN(12) 

    TYPE(Text)  CAPTION(objednací cena)           CPOS(23,0) CLEN(13) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 
    TYPE(Get)   NAME(M->smallBasket_cenNaoDod)    FPOS(20,1) FLEN(13) PICTURE(@N 99999999.9999)  
    TYPE(Text)  NAME(OBJVYSHDw->czkratmenZ)       CPOS(34,1) CLEN( 5) CTYPE(1) FONT(2)

    TYPE(Text)  CAPTION(objednat na_skl)          CPOS(42,0) CLEN(13)
    TYPE(Get)   NAME(M->smallBasket_mnozObSkl)    FPOS(41,1) FLEN(13) PICTURE(@N 9999999.99)
    TYPE(Text)  NAME(cenZboz->czkratJedn)         CPOS(55,1) CLEN( 6) CTYPE(1) FONT(2)
  TYPE(End) 

    
* info
  TYPE(TABPAGE) FPOS(.5,14.6) SIZE(99,8) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
                                                                                                                                                       
*    TYPE(Static) STYPE(1) SIZE(98, 7.2) FPOS(1,12.7) RESIZE(xy)
*   1.ø.
    TYPE(Text) CAPTION(Sklad. položka)     CPOS(  1, 0.2) CLEN( 15) FONT(5)
    TYPE(Text) NAME(CENZBOZ->cSklPol)      CPOS(  1, 1.2) CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Název zboží 2)      CPOS( 17, 0.2) CLEN( 30)
    TYPE(Text) NAME(CENZBOZ->cNazZbo2)     CPOS( 17, 1.2) CLEN( 30) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Kateg.)             CPOS( 48, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nZboziKat)    CPOS( 48, 1.2) CLEN(  6) BGND( 13) PP(2)
    TYPE(Text) NAME(C_KatZbo->cNazevKat)   CPOS( 54, 1.2) CLEN( 18) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Úè.sk.)             CPOS( 73, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nUcetSkup)    CPOS( 73, 1.2) CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) NAME(C_UctSkp->CNAZUCTSK)   CPOS( 78, 1.2) CLEN( 18) BGND( 13) PP(2)
* 2.ø.
    TYPE(Text) CAPTION(Typ ceny)          CPOS(  1, 2.4) CLEN(  8)
    TYPE(Text) NAME(CENZBOZ->cTypSklCen)  CPOS(  1, 3.4) CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skl. cena)         CPOS( 11, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaSZBO)   CPOS( 11, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) NAME(CENZBOZ->cZkratMeny)  CPOS( 24, 3.4) CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Množ. na skladì)   CPOS( 31, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozSZBO)   CPOS( 31, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) NAME(CENZBOZ->cZkratJedn)  CPOS( 44, 3.4) CLEN(  4) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skl. cena CELK)    CPOS( 50, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaCZBO)   CPOS( 50, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2)
* 3.ø.
    TYPE(Text) CAPTION(Mn. k dispozici)   CPOS(  1, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozDZBO)   CPOS(  1, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Mn. rezervované)   CPOS( 15, 4.6) CLEN( 14)
    TYPE(Text) NAME(CENZBOZ->nMnozRZBO)   CPOS( 15, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Mn. objednané)     CPOS( 29, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozOZBO)   CPOS( 29, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Mn. k objednání)   CPOS( 43, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozKZBO)   CPOS( 43, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Cena bez danì)     CPOS( 64, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaPZBO)   CPOS( 64, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION( DPH )             CPOS( 77, 4.6) CLEN(  5)
    TYPE(Text) NAME(C_DPH->nProcDph)      CPOS( 77, 5.6) CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) CAPTION(%)                 CPOS( 82, 5.6) CLEN(  2)
    TYPE(Text) CAPTION(Cena s daní)       CPOS( 85, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaMZBO)   CPOS( 85, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2)
*    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* dodavatelelé zboží
  TYPE(TABPAGE) FPOS(.5,14.6) SIZE(99,8) TTYPE(3) OFFSET(13,74) CAPTION(dodavatelé) TABHEIGHT(.8) PRE(tabSelect) 
    TYPE(DBrowse) FILE(DODZBOZ) INDEXORD(5);
                    FIELDS( M->hlavniDod::2.6::2       , ; 
                            ncisFirmy:èísloFirmy       , ;
                            cnazev:název dodavatele:30 , ;
                            ncenaNZbo:nákCena          , ;
                            ddatPNak:datNák            , ;
                            ckatcZbo:katOznaèení       , ;
                            nminObMnoz:minK_Obj        , ; 
                            nminExMnoz:minK_Exp        , ; 
                            ncenNakZm:nákCena_zm       , ;
                            ndodLhuta:dodLhuta           ) ; 
                    FPOS(0, 0) SIZE(99,7) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y)
  TYPE(END) 


* kumulativní pohyby
  TYPE(TABPAGE) FPOS(.5,14.6) SIZE(99,8) TTYPE(3) OFFSET(25,62) CAPTION(pohyb) TABHEIGHT(.8) PRE(tabSelect) 
    TYPE(DBrowse) FPOS( 0, 0) SIZE(99,7) FILE(PVPKUMUL) INDEXORD(1)      ;
                                               FIELDS(cOBDPOH:obd            , ;
                                                      nmnozPoc:množPoè:11    , ;
                                                      ncenaPoc:cenaPoè       , ;
                                                      nmnozPrij:množPøij:10  , ;
                                                      ncenaPrij:cenaPøij     , ;
                                                      nmnozVydej:množVyd:10  , ;
                                                      ncenaVydej:cenaVyd     , ;
                                                      nmnozKon:množKon:11    , ;
                                                      ncenaKon:cenaKon         ) ;
                                           CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy) 
  TYPE(End)

* basket
  TYPE(TABPAGE) FPOS(.5,14.6) SIZE(99,8) TTYPE(3) OFFSET(37,50) CAPTION(košík) TABHEIGHT(.8) PRE(tabSelect) 
     TYPE(DBrowse) FPOS(-1.7,.3) SIZE(99.8,7) FILE(OBJVYSITw)                   ;
                                                   FIELDS(ccissklad:sklad          , ; 
                                                          csklpol:sklPol           , ;             
                                                          cjakost:jakost           , ;
                                                          cnazzbo:název zboží:19.5 , ;
                                                          nmnozobdod:mn_objednáno  , ;
                                                          nmnozpodod:mn_potvrzeno  , ;  
                                                          nmnozpldod:mn_dodáno     , ;
                                                          nkczdobj:cenaCelk          ) ;
                                                   CURSORMODE(3) PP(6) INDEXORD(3) SCROLL(ny) RESIZE(x)  
  TYPE(End)

