TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží...ROZDÍLY) SIZE(120,25) FILE(ERRSTAV);
                        GUILOOK(Menu:n,Message:y,Action:y,IconBar:y:MyStdIconBar) OBDOBI(SKL)

  TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(Cenik_PREPOCET_stavu) TIPTEXT(Pøepoèet koncových stavù ceníku)
  TYPE(Action) CAPTION(info C~eník)     EVENT(SKL_CENZBOZ_INFO)     TIPTEXT(Informaèní karta skladové položky)
  TYPE(Action) CAPTION(~Opravit ceník)  EVENT(Cenik_OPRAVA_stavu)   TIPTEXT(Oprava koncových stavù ceníku)

  TYPE(DBrowse) SIZE(120,15) FILE(ERRSTAV) INDEXORD(1) ;
               FIELDS( DDATKONTR::10       , ;
                       CCISSKLAD::8        , ;
                       CSKLPOL             , ;
                       CENZBOZ->CNAZZBO::34, ;
                       NMNROZDIL::12       , ;
                       NCEROZDIL::12       , ;
                       M->nmnozSzbo:množSkl, ;
                       M->ncenaCzbo:cenaCelk );
               CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(yy)

 TYPE(Static) STYPE(13) SIZE(118, 9.5) FPOS(1,15.2) RESIZE(yx)
   TYPE(Text) CAPTION( Pøepoèítat koncové stavy ceníku od roku)    CPOS( 3,  .5) CLEN( 35) FONT(2)
   TYPE(GET ) NAME(M->nROK_start)         FPOS( 40, 0.5) FLEN( 6)  POST( Rok_start)

   TYPE(Text) CAPTION( Množství)          CPOS( 46, 2) CLEN( 13)
   TYPE(Text) CAPTION( Cena celkem)       CPOS( 61, 2) CLEN( 13)
   TYPE(Text) CAPTION( Sklad.cena/MJ)     CPOS( 84, 5) CLEN( 13)
   TYPE(Text) CAPTION( (A))               CPOS( 32, 3) CLEN(  5)
   TYPE(Text) CAPTION( (B))               CPOS( 32, 4) CLEN(  5)
   TYPE(Text) CAPTION( (C))               CPOS( 32, 5) CLEN(  5)
   TYPE(Text) CAPTION( (D))               CPOS( 32, 6) CLEN(  5)
   TYPE(Text) CAPTION( (E))               CPOS( 32, 7) CLEN(  5)

   TYPE(Text) CAPTION( Stav ceníku na poèátku roku)  CPOS(  3, 3) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnPocCen)                       CPOS( 40, 3) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCePocCen)                       CPOS( 57, 3) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION( Suma pøíjmù bìhem období)     CPOS(  3, 4) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnPrCMP)                        CPOS( 40, 4) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCePrCMP)                        CPOS( 57, 4) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION( Suma výdejù bìhem období)     CPOS(  3, 5) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnVyCMP)                        CPOS( 40, 5) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCeVyCMP)                        CPOS( 57, 5) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION( Vypoètený stav ceníku A + B - C)  CPOS(  3, 6) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnKonCMP)                           CPOS( 40, 6) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCeKonCMP)                           CPOS( 57, 6) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION( Skuteèný stav ceníku )            CPOS(  3, 7) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnKonCEN)                           CPOS( 40, 7) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCeKonCEN)                           CPOS( 57, 7) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) CAPTION( Zjištìný ROZDÍL  E - D)           CPOS(  3, 8.3) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnRozdil)                           CPOS( 40, 8.3) CLEN( 13) BGND(13) FONT(5) CTYPE(2)
   TYPE(Text) NAME( nCeRozdil)                           CPOS( 57, 8.3) CLEN( 13) BGND(13) FONT(5) CTYPE(2)

   TYPE(Text) CAPTION( Vypoètená)                        CPOS( 72, 6) CLEN( 10) FONT(2)
   TYPE(Text) NAME( M->nCenaSZBO)                        CPOS( 83, 6) CLEN( 13) BGND(13) FONT(5) CTYPE(2) PICTURE @N99 999 999,99
   TYPE(Text) CAPTION( V ceníku)                         CPOS( 72, 7) CLEN( 10) FONT(2)
   TYPE(Text) NAME( CENZBOZ->nCenaSZBO)                  CPOS( 83, 7) CLEN( 13) BGND(13) FONT(5) CTYPE(2)


 TYPE(End)