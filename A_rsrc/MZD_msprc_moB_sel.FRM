TYPE(drgForm) DTYPE(10) TITLE(Seznam zamìstnancù ve stavu) SIZE(94.2,25)    ;
              GUILOOK(Action:n,IconBar:y:drgStdBrowseIconBar,Menu:n,Message:n) OBDOBI(MZD)

  TYPE(DBrowse) FPOS(0.5,1.5) SIZE(92.8,23.20) FILE(MSPRC_MOB)       ;
                POPUPMENU(y) INDEXORD(2) RESIZE(yy)                  ;
                FIELDS( cdruPraVzt:druhPv:8                        , ; 
                        ncisOsoby:èísloOsoby                       , ; 
                        nosCisPrac:OsÈísPrac                       , ; 
                        nporPraVzt:poøPv:4                         , ;
                        cjmenoRozl:jméno a pøímení:32              , ;
                        ntypPraVzt:pv:4                            , ;
                        ntypZamVzt:zamVz:4                         , ;
                        dDatNast:datNástupu                        , ;  
                        dDatVyst:datUkoèení                          ) ;  
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(93.05,1.25) RESIZE(yn)
    TYPE(TEXT) CAPTION(Seznam zamìstnancù ve stavu) CPOS(1.5, 0.6) FONT(7)  CLEN(40) 
*    TYPE(TEXT) NAME( M->caption_contextText)     CPOS(1.5, 0.6) FONT(7)  CLEN(40)
*    TYPE(PushButton) POS(57.5,0.6)   SIZE(35,1.2) CAPTION(~Kompletní seznam osob v evidenci) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(END)


