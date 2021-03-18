TYPE(drgForm) DTYPE(10) TITLE(Stavy za období - ke dni) SIZE(110,25);
               GUILOOK(Message:y,Action:y,IconBar:y) OBDOBI(SKL)

TYPE(Action) CAPTION(info C~eník)      EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)
*TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT(SKL_KUMUL)        TIPTEXT(Pøepoèet stavù za období pro celý ceník)

  TYPE(DBrowse) FPOS( 0.5, 0.2 ) SIZE(16,24) FILE(PVPKUMDENw) INDEXORD(1) ;
                FIELDS( dDatKUM:Datum:15 );
                CURSORMODE(3) RESIZE(xy) PP(7) SCROLL(ny) 
*** POPUPMENU(y)

***
* info skladové položky
    TYPE(Static) STYPE(12) SIZE(91, 7.3) FPOS(18.2,.2) CTYPE(2) RESIZE(yn)

*   1.ø.
      TYPE(Text) CAPTION(Sklad)            CPOS(  3, 0.5) CLEN(  8)
      TYPE(Text) NAME(cenZboz->cCisSklad)  CPOS(  3, 1.5) CLEN(  8) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
      TYPE(Text) CAPTION(Sklad. položka)   CPOS( 13, 0.5) CLEN( 15)
      TYPE(Text) NAME(cenZboz->cSklPol)    CPOS( 13, 1.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
      TYPE(Text) CAPTION(Název zboží)      CPOS( 30, 0.5) CLEN( 30)
      TYPE(Text) NAME(cenZboz->cNazZbo)    CPOS( 30, 1.5) CLEN( 30) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Kateg.)           CPOS( 62, 0.5) CLEN(  6)
      TYPE(Text) NAME(cenZboz->nZboziKat)  CPOS( 62, 1.5) CLEN(  6) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Úè.sk.)           CPOS( 70, 0.5) CLEN(  6)
      TYPE(Text) NAME(cenZboz->nUcetSkup)  CPOS( 70, 1.5) CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Místo uložení)    CPOS( 77, 0.5) CLEN( 15)
      TYPE(Text) NAME(cenZboz->cUlozZbo)   CPOS( 77, 1.5) CLEN( 12) BGND( 13) PP(2) GROUPS(clrGREY)

* 2.ø.
      TYPE(Text) CAPTION(Typ ceny)         CPOS(  3, 2.5) CLEN(  8)
      TYPE(Text) NAME(cenZboz->cTypSklCen) CPOS(  3, 3.5) CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Skl. cena)        CPOS( 13, 2.5) CLEN( 13)
      TYPE(Text) NAME(cenZboz->nCenaSZBO)  CPOS( 13, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) NAME(cenZboz->cZkratMeny) CPOS( 26, 3.5) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Množ. na skladì)  CPOS( 33, 2.5) CLEN( 13)
      TYPE(Text) NAME(cenZboz->nMnozSZBO)  CPOS( 33, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) NAME(cenZboz->cZkratJedn) CPOS( 46, 3.5) CLEN(  4) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Skl. cena CELK)   CPOS( 52, 2.5) CLEN( 13)
      TYPE(Text) NAME(cenZboz->nCenaCZBO)  CPOS( 52, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( Jakost)          CPOS( 67, 2.5) CLEN( 10)
      TYPE(Text) NAME(cenZboz->cJakost)    CPOS( 67, 3.5) CLEN( 22) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)

* 4.ø.
      TYPE(Text) CAPTION(Mn. k dispozici)  CPOS(  3, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nMnozDZBO)  CPOS(  3, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. rezervované)  CPOS( 16, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nMnozRZBO)  CPOS( 16, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. objednané)    CPOS( 29, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nMnozOZBO)  CPOS( 29, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. k objednání)  CPOS( 42, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nMnozKZBO)  CPOS( 42, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Cena bez danì)    CPOS( 55, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nCenaPZBO)  CPOS( 55, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( DPH )            CPOS( 70, 4.5) CLEN(  5)
      TYPE(Text) NAME(C_DPH->nProcDph)     CPOS( 69, 5.5) CLEN(  6) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
      TYPE(Text) CAPTION( % )              CPOS( 75.2, 5.5) CLEN(  3)
      TYPE(Text) CAPTION(Cena s daní)      CPOS( 80, 4.5) CLEN( 12)
      TYPE(Text) NAME(cenZboz->nCenaMZBO)  CPOS( 78, 5.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)

    TYPE(End)


  TYPE(Static) STYPE(14) SIZE( 90, 15.5) FPOS( 18.5,8.2) CTYPE(2) RESIZE(yx)
   TYPE(Text) CAPTION(Množství:  )           CPOS( 15,0.7)   CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(C e n a :  )           CPOS( 34,0.7)   CLEN( 12) FONT(5)
   TYPE(Text) CAPTION(Na poèátku )           CPOS(  1,2.0)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Pøíjem     )           CPOS(  1,4.0)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Výdej      )           CPOS(  1,6.0)   CLEN( 12) FONT(2)
   TYPE(Text) CAPTION(Na konci   )           CPOS(  1,8.0)   CLEN( 12) FONT(2)

   TYPE(Text) NAME(PVPKUMDENw->nMnozPoc)       CPOS( 15,2.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaPoc)       CPOS( 34,2.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)

   TYPE(Text) NAME(PVPKUMDENw->nMnozPrij)      CPOS( 15,4.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaPrij)      CPOS( 34,4.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)

   TYPE(Text) NAME(PVPKUMDENw->nMnozVydej)     CPOS( 15,6.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaVydej)     CPOS( 34,6.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)

   TYPE(Text) NAME(PVPKUMDENw->nMnozKon)       CPOS( 15,8.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)
   TYPE(Text) NAME(PVPKUMDENw->nCenaKon)       CPOS( 34,8.0)   CLEN( 17) BGND(13) CTYPE(2) FONT(7) GROUPS(clrINFO)

  TYPE(End)