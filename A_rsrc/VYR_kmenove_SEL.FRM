TYPE(drgForm) DTYPE(10) TITLE(Seznam zamìstnancù - osob) SIZE(94.2,25)    ;
              GUILOOK(Action:n,IconBar:y) OBDOBI(VYR)

  TYPE(DBrowse) FPOS(0.5,1.5) SIZE(92.8,18.00) FILE(OSOBY)            ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy)                  ;
                FIELDS( M->is_Stavem_mo::2.4::2                    , ; 
                        ncisOsoby:èísloOsoby                       , ; 
                        nosCisPrac:OsÈísPrac                       , ; 
                        cjmenoRozl:jménoSRozliš:35                 , ; 
                        culicCiPop:bydlištì:35                     , ; 
                        cmisto:bydlištì:35                         , ; 
                        ddatnaroz:datNarození                        ) ;
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

  TYPE(DBrowse) FPOS(0.5,19.8) SIZE(92.8,5.00) FILE(PRSMLDOH)        ;
                POPUPMENU(n) INDEXORD(1) RESIZE(yy) SCROLL(ny)       ;
                FIELDS( M->is_Stavem_prSml::2.4::2                 , ; 
                        cdruPraVzt:druhPv:8                        , ; 
                        nosCisPrac:OsÈísPrac                       , ; 
                        nporPraVzt:poøPv:4                         , ;
                        ntypPraVzt:pv:4                            , ;
                        ntypZamVzt:zamVz:4                         , ;
                        dDatNast:datNástupu                        , ;
                        dDatVyst:datVýstupu )                        ;
                CURSORMODE(3) PP(7)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(93.05,1.25) RESIZE(yn)
    TYPE(TEXT) NAME( M->caption_contextText)     CPOS(1.5, 0.6) FONT(7)  CLEN(40)
    TYPE(PushButton) POS(57.5,0.6)   SIZE(35,1.2) CAPTION(~Osoby v evidenci pro výrobu) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(END)


