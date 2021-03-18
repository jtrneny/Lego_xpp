TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží - CTRL) SIZE(100,25) FILE(CENZBOZ);
                        GUILOOK(Menu:n,Message:y,Action:y,IconBar:y:MyStdIconBar) OBDOBI(SKL)

  TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(Cenik_PREPOCET_stavu) TIPTEXT(Pøepoèet koncových stavù ceníku)
  TYPE(Action) CAPTION(info C~eník)     EVENT(SKL_CENZBOZ_INFO)     TIPTEXT(Informaèní karta skladové položky)

  TYPE(DBrowse) SIZE(100,23) FILE(CENZBOZ) INDEXORD(12) ;
                FIELDS( CCISSKLAD     ,;
                        CSKLPOL       ,;
                        CNAZZBO::35   ,;
                        cPolCen:Pol.  ,;
                        nMnozsZBO     ,;
                        cZkratJedn:MJ ,;
                        nCenasZBO     ,;
                        nCenaCZBO     );
                CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(yy)

  TYPE(Static) STYPE(13) SIZE(99.6, 1.8) FPOS(0.2,23.1) RESIZE(yx)
    TYPE(Text) CAPTION( Pøepoèítat koncové stavy ceníku od roku)    CPOS( 3,  .5) CLEN( 35) FONT(2)
    TYPE(GET ) NAME(M->nROK_start)         FPOS( 40, 0.5) FLEN( 6)  POST( Rok_start)
  TYPE(End)