TYPE(drgForm) DTYPE(10) TITLE(Prodejní ceny) SIZE(100,25);
              CARGO( SKL_CENZBOZ_CRD)

  TYPE(Action) CAPTION(~Pøepoèet PC_1) EVENT(Cenik_PREPOCET_CEN) TIPTEXT(Pøepoèet prodejních cen dle skl.ceny)
  TYPE(Action) CAPTION(~Pøepoèet PC_2) EVENT(PREPOCET_CEN_bDPH) TIPTEXT(Pøepoèet prodejních cen bez Dph)

  TYPE(DBrowse) SIZE(100,21.5) FILE(CENZBOZ) INDEXORD(3) ;
               FIELDS( CCISSKLAD,;
                       CSKLPOL,;
                       CNAZZBO,;
                       NMNOZSZBO,;
                       NCENASZBO,;
                       NCENACZBO,;
                       CNAZZBO2) ;
               CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(yy)

 TYPE(Static) STYPE(13) SIZE(98, 3) FPOS(1,21.7) RESIZE(yx)
   TYPE(Text) CAPTION(Nákupní cena)       CPOS(  2, .5) CLEN( 13)
   TYPE(Text) NAME(CENZBOZ->nCenaNZBO)    CPOS(  2,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)
   TYPE(Text) CAPTION(Cena bez danì)      CPOS( 15, .5) CLEN( 13)
   TYPE(Text) NAME(CENZBOZ->nCenaPZBO)    CPOS( 15,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)
   TYPE(Text) CAPTION(Cena s daní)        CPOS( 28, .5) CLEN( 13)
   TYPE(Text) NAME(CENZBOZ->nCenaMZBO)    CPOS( 28,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)

   TYPE(Text) CAPTION(Prodejní cena 1)    CPOS( 43, .5) CLEN( 13)
   TYPE(Text) NAME(CENPRODC->nCenaP1ZBO)  CPOS( 43,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)
   TYPE(Text) CAPTION(Prodejní cena 2)    CPOS( 57, .5) CLEN( 13)
   TYPE(Text) NAME(CENPRODC->nCenaP2ZBO)  CPOS( 57,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)
   TYPE(Text) CAPTION(Prodejní cena 3)    CPOS( 71, .5) CLEN( 13)
   TYPE(Text) NAME(CENPRODC->nCenaP3ZBO)  CPOS( 71,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)
   TYPE(Text) CAPTION(Prodejní cena 4)    CPOS( 85, .5) CLEN( 12)
   TYPE(Text) NAME(CENPRODC->nCenaP4ZBO)  CPOS( 85,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2) GROUPS( clrGREY)

 TYPE(End)