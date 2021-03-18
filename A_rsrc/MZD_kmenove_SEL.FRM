TYPE(drgForm) DTYPE(10) TITLE(Seznam zamìstnancù) SIZE(94.2,25)    ;
              GUILOOK(Action:n,IconBar:y) OBDOBI(MZD)

  TYPE(DBrowse) FPOS(0.5,1.5) SIZE(92.8,23.20) FILE(OSOBY)            ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy)                  ;
                FIELDS( M->is_Stavem_mo::2.4::2                    , ; 
                        mzd_kmenove_sel_moB('cdruPraVzt'):druhPv:8 , ; 
                        ncisOsoby:èísloOsoby                       , ; 
                        nosCisPrac:OsÈísPrac                       , ; 
                        mzd_kmenove_sel_moB('nporPraVzt'):poøPv:4  , ;
                        cosoba:jméno a pøímení:30                  , ;
                        mzd_kmenove_sel_moB('ntypPraVzt'):pv:4     , ;
                        mzd_kmenove_sel_moB('ntypZamVzt'):zamVz:4  , ;
                        mzd_kmenove_sel_moB('dDatNast'):datNástupu , ;  
                        mzd_kmenove_sel_moB('dDatVyst'):datUkoèní  , ;  
                        culicCiPop:bydlištì:35                     , ; 
                        ddatnaroz:datNarození                        ) ;
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(93.05,1.25) RESIZE(yn)
    TYPE(TEXT) NAME( M->caption_contextText)     CPOS(1.5, 0.6) FONT(7)  CLEN(40)
    TYPE(PushButton) POS(57.5,0.6)   SIZE(35,1.2) CAPTION(~Kompletní seznam osob v evidenci) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(END)


