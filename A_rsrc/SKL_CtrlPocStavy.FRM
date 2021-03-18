TYPE(drgForm) DTYPE(10) TITLE(Poèáteèní stavy Ceníku zboží...ROZDÍLY) SIZE(105,25) FILE(ERRPOCSTAV);
                        GUILOOK(Menu:n,Message:y,Action:y,IconBar:y:MyStdIconBar) OBDOBI(SKL)

  TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(PREPOCET_PocStavu) TIPTEXT(Pøepoèet poèáteèních stavù ceníku)
  TYPE(Action) CAPTION(info C~eník)       EVENT(SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)
  TYPE(Action) CAPTION(~Opravit stavy)    EVENT(OPRAVA_PocStavu)   TIPTEXT(Oprava poèáteèních stavù ceníku)

  TYPE(DBrowse) SIZE(105,14) FILE(ERRPOCSTAV) INDEXORD(1) ;
               FIELDS( DDATKONTR,;
                       nROK     ,;
                       CCISSKLAD,;
                       CSKLPOL,;
                       CENZBOZ->CNAZZBO::34,;
                       NMNROZDIL,;
                       NCEROZDIL );
               CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(yy)

 TYPE(Static) STYPE(13) SIZE(103, 10.5) FPOS(1,14.2) RESIZE(yx)
   TYPE(Text) CAPTION( Pøepoèítat poèáteèní stavy ceníku pro rok)  CPOS( 3,  .5) CLEN( 35) FONT(2)
   TYPE(GET ) NAME(M->nROK_cmp)           FPOS( 40, 0.5) FLEN( 6)  POST( Rok_cmp)

   TYPE(Text) CAPTION( Množství)          CPOS( 46, 2) CLEN( 13)
   TYPE(Text) CAPTION( Cena celkem)       CPOS( 61, 2) CLEN( 13)
*   TYPE(Text) CAPTION( Sklad.cena/MJ)     CPOS( 84, 5) CLEN( 13)
   TYPE(Text) CAPTION( (A))               CPOS( 35, 3) CLEN(  5) FONT(5)
   TYPE(Text) CAPTION( (B))               CPOS( 35, 4) CLEN(  5) FONT(5)
   TYPE(Text) CAPTION( (C))               CPOS( 35, 5) CLEN(  5) FONT(5)
   TYPE(Text) CAPTION( (D))               CPOS( 35, 6) CLEN(  5) FONT(5)
   TYPE(Text) CAPTION( (E))               CPOS( 35, 7) CLEN(  5) FONT(5)

   TYPE(Text) CAPTION( Poèáteèní stav pøedchozího roku)    CPOS(  3, 3) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnPocCMP)                             CPOS( 40, 3) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCePocCMP)                             CPOS( 57, 3) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) CAPTION( Suma pøíjmù pøedchozího roku)       CPOS(  3, 4) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnPrCMP)                              CPOS( 40, 4) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCePrCMP)                              CPOS( 57, 4) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) CAPTION( Suma výdejù pøedchozího roku)       CPOS(  3, 5) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnVyCMP)                              CPOS( 40, 5) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCeVyCMP)                              CPOS( 57, 5) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) CAPTION( Vypoètený poè.stav roku : A + B - C)CPOS(  3, 6) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnKonCMP)                             CPOS( 40, 6) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCeKonCMP)                             CPOS( 57, 6) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) CAPTION( Poèáteèní stav poèítaného roku )    CPOS(  3, 7) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnKonCEN)                             CPOS( 40, 7) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCeKonCEN)                             CPOS( 57, 7) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) CAPTION( Poèáteèní stav v ceníku zboží)      CPOS(  3, 8) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnPocCEN)                             CPOS( 40, 8) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
   TYPE(Text) NAME( nCePocCEN)                             CPOS( 57, 8) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)

   TYPE(Text) CAPTION( Zjištìný ROZDÍL  E - D)             CPOS(  3, 9.3) CLEN( 30) FONT(2)
   TYPE(Text) NAME( nMnRozdil)                             CPOS( 40, 9.3) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREEN)
   TYPE(Text) NAME( nCeRozdil)                             CPOS( 57, 9.3) CLEN( 13) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREEN)

 TYPE(End)