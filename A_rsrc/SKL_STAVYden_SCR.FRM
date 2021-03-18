TYPE(drgForm) DTYPE(10) TITLE(Stavy za období - ke dni) SIZE(115,25);
               GUILOOK(Message:y,Action:y,IconBar:y) OBDOBI(SKL)

TYPE(Action) CAPTION(info C~eník)     EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)
*TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(SKL_KUMUL)        TIPTEXT(Pøepoèet stavù za období pro celý ceník)

  TYPE(DBrowse) FPOS( 0,0.1) SIZE(100,19.5) FILE(CENZBOZ) INDEXORD(3)  ;
                FIELDS( CenZBOZ_isAktivni():akt:2.6::2, ;
                        CCISSKLAD:sklad:6     , ;
                        CSKLPOL:sklPoložka:14 , ;
                        CNAZZBO:název zboží:30, ;
                        nZboziKat:katZbo      , ;
                        nmnozDZbo:množKDisp:11, ;
                        czkratJedn:mjSkl      , ;
                        ncenaMZbo:prodCena:10 , ;
                        ncenaNZbo:nákCena:10    ) ;
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny);
                ITEMMARKED(ItemMarked) POPUPMENU(y)

  TYPE(DBrowse) FPOS( 99, 0.2 ) SIZE(15,18.5) FILE(PVPKUMDENw) INDEXORD(1) ;
                FIELDS( dDatKUM:Datum:10 );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny)

  TYPE(Static) STYPE(13) SIZE( 99.2, 5) FPOS( 0.4,19.8) RESIZE(yx)
   TYPE(Text) CAPTION(Množství:  )           CPOS(  2,1.8)   CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(C e n a :  )           CPOS(  2,3.1)   CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Na poèátku )           CPOS( 22,0.5)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Pøíjem     )           CPOS( 44,0.5)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Výdej      )           CPOS( 64,0.5)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Na konci   )           CPOS( 81,0.5)   CLEN( 12) FONT(2)

   TYPE(Text) NAME(PVPKUMDENw->nMnozPoc)       CPOS( 15,1.7)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaPoc)       CPOS( 15,3.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nMnozPrij)      CPOS( 34,1.7)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaPrij)      CPOS( 34,3.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nMnozVydej)     CPOS( 53,1.7)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaVydej)     CPOS( 53,3.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nMnozKon)       CPOS( 72,1.7)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaKon)       CPOS( 72,3.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)

  TYPE(End)