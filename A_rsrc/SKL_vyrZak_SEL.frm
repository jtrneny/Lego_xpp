TYPE(drgForm) SIZE(110,24) DTYPE(10) TITLE(V�robn� zak�zky - V�B�R) FILE(VYRZAK);
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n)
*              CARGO(VYR_VYRZAK_CRD)

  TYPE(Action) CAPTION( info ~Zak�zky)  EVENT(VYR_VYRZAK_INFO) TIPTEXT( Informa�n� karta v�robn� zak�zky)

  TYPE(Static) STYPE(13) SIZE(110,11.8) FPOS(0,1.2) RESIZE(yy)
    TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1)                   ; 
                  FIELDS( VyrZAKis_U():Uz:2.6::2           , ;
                          VYR_isKusov( 1; 'Vyrzak'):Ku:1::2, ;
                          VYR_isPolOp( 1; 'Vyrzak'):Op:1::2, ;
                          CCISZAKAZ                        , ;
                          CSTAVZAKAZ:Stav                  , ;
                          CNAZEVZAK1::30                   , ;
                          CVYRPOL                          , ;
                          NVARCIS:Var.                     , ;
                          cnazPol3:��etn�Zak               , ;  
                          nMnozPlanO:mn_pl�nZobj           , ;
                          nMnozZadan:mn_doV�roby           , ;
                          nMnozVyrob:mn_vyrobeno           , ;
                          nMnozOdved:mn_odvedeno           , ;
                          dOdvedZaka:Odved.PL                ) ;
                 FPOS( -.2, -.1) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(yy) ITEMMARKED(ItemMarked)
  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(110,10.8) FPOS(0,13.2) RESIZE(yy) CTYPE(2)
    TYPE(DBrowse) FILE(VYRPOL) INDEXORD( 4)                ;
                  FIELDS( ctypPol:typPol                 , ;
                          VYR_isKusov(1;'VyrPol'):Ku:1::2, ;
                          VYR_isPolOp(1;'VyrPol'):Op:1::2, ;
                          cCisZakaz:��sloV�r_zak�zky:30  , ;
                          ccisSklad:sklad                , ;  
                          cVyrPol:��sloVyr_polo�ky:15    , ;
                          cNazev:n�zevVyr:polo�ky:30     , ;
                          nVarCis:var                    , ;
                          M->mn_doDokl:mn_doDokl:12      , ; 
                          cVarPop::20                    , ;
                          cCisVyk::20                      ) ;
                 FPOS( -.2, -.1) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(ny) 
  TYPE(End)



