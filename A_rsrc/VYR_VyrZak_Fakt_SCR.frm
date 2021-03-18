TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky dle fakturace) FILE(VYRZAK);
              SIZE(115,26) GUILOOK(Action:y,IconBar:y) ;
              CARGO(VYR_VyrZak_CRD)

TYPE(Action) CAPTION(~Kontr. fakt.mn.)       EVENT(ZAK_FAKTMNOZ)  TIPTEXT(Pøepoèet fakt.množství na zakázku)

  TYPE(DBrowse) FILE(VyrZak) INDEXORD(1);
                FIELDS( VyrZAKis_U():Uz:2.6::2, ;
                        CCISZAKAZ             , ;
                        CSTAVZAKAZ:Stav       , ;
                        CNAZEVZAK1::30        , ;
                        CVYRPOL               , ;
                        NVARCIS:var           , ;
                        nMnozPlanO:mn_plánVýr , ;
                        nMnozFakt:mn_faktOdb  , ;
                        cnazPol3:úèetníZak    ) ; 
                SIZE(115,11.5) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED(ItemMarked)

  TYPE(Text) CAPTION( Faktury vystavené - bìžné)   CPOS( 0.5,11.6) CLEN( 114) FONT(5) CTYPE(1)

  TYPE(DBrowse) FILE(FakVysIT) INDEXORD(10);
                FIELDS( nCISFAK:èísFak:10     , ;
                        cNAZZBO:název zboží:35, ;
                        M->cenPol:c:2.6::2    , ; 
                        cSKLPOL:sklPol        , ;
                        nCeJPrKBZ:cenaJedKonc , ;
                        nFAKTMNOZ:množFak:13  , ;
                        cZKRATJEDN:jed:3      , ;
                        nCeCPrKBZ:cenaCelk    , ;
                        nCeCPrKDZ:cenaCelksDPH, ;
                        nProcSlev:sleva %     , ;
                        nHodnSlev:sleva       , ;
                        nRADVYKDPH:rvDph      , ;
                        nKODPLNENI:sh         , ;  
                        CCISZAKAZI:výrZakázka , ;                          
                        cUCETSKUP:UèSk          ) ; 
               SIZE(115,6) FPOS(0.1, 12.7) CURSORMODE(3) SCROLL(yy) PP(7) RESIZE(yx)


  TYPE(Text) CAPTION( Faktury vystavené - vnitropodnikové)   CPOS( 0.5,18.8) CLEN( 114) FONT(5) CTYPE(1)

  TYPE(DBrowse) FILE(FakVnpIT) INDEXORD(6);
                FIELDS( nCisFak:èísFak:10              , ;
                        cNAZZBO:název zboží:24         , ;
                        cSKLPOL:sklPoložka             , ;
                        nFAKTMNOZ:faktMnož             , ;
                        czkratjedn:mj                  , ; 
                        nCENAZAKL:cenaZaJedn           , ;
                        nCenZakCel:cenaCelk            , ;
                        CCISZAKAZI:výrZakázka            ) ; 
                SIZE(115,6) FPOS(0.1, 19.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx)
