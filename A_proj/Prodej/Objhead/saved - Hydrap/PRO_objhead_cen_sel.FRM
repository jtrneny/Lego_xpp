TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží - VÝBÌR) SIZE(110, 20);
               GUILOOK(Action:y,Message:n,IconBar:y:drgBrowseIconBar,Menu:n)
*               CARGO(SKL_CENZBOZ_CRD)

*TYPE(Action) CAPTION(~Ceník zboží)  EVENT(Cenik_ZBOZI) TIPTEXT(Založení a opravy skladových položek)
TYPE(Action) CAPTION(info C~eník) EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

* SKLAD
  TYPE(Static) STYPE(1) SIZE(108,1.8) FPOS(1,0.2) RESIZE(xy)
    TYPE(Text) CAPTION(SKLAD)              CPOS(  1, 0.3) CLEN(  8) FONT(2)
    TYPE(Text) NAME(CenZBOZ->cCisSklad)    CPOS( 10, 0.3) CLEN( 10) BGND( 13) FONT(5) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) NAME(C_Sklady->cNazSklad)   CPOS( 22, 0.3) CLEN( 80) BGND( 13) FONT(5) PP(2) GROUPS(clrYELLOW)
  TYPE(End)

  TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(1)                      ;
                FIELDS( CCISSKLAD                            , ;
                        CSKLPOL                              , ;
                        CNAZZBO::30                          , ;
                        nZboziKat:Kat.zboží                  , ;
                        nMnozSZBO                            , ;
                        cZkratJedn:MJ                        , ;
                        nCenaSZBO                            , ;
                        nCenaPZBO                            , ;
                        nCenaNZBO                            , ;
                        M->lastProdCena:Posl.prodejní cena:13, ;
                        M->lasthodnSlev:sleva:13             , ;
                        M->lastprocSlev:% slevy:10             );
                FPOS( 0, 2) SIZE(110,10.5) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy);
                ITEMSELECTED( RecordSelected) POPUPMENU(yy)

  TYPE(Static) STYPE(1) SIZE(108, 7.2) FPOS(1,12.7) RESIZE(xy)
*   1.ø.
    TYPE(Text) CAPTION(Sklad. položka)     CPOS(  1, 0.2) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cSklPol)      CPOS(  1, 1.2) CLEN( 20) BGND( 13) PP(2) FONT( 5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Název zboží 2)      CPOS( 22, 0.2) CLEN( 30)
    TYPE(Text) NAME(CENZBOZ->cNazZbo2)     CPOS( 22, 1.2) CLEN( 35) BGND( 13) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Kateg.)             CPOS( 58, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nZboziKat)    CPOS( 58, 1.2) CLEN(  6) BGND( 13) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) NAME(C_KatZbo->cNazevKat)   CPOS( 64, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Úè.sk.)             CPOS( 83, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nUcetSkup)    CPOS( 83, 1.2) CLEN(  5) BGND( 13) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) NAME(C_UctSkp->CNAZUCTSK)   CPOS( 88, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrYELLOW)
* 2.ø.
    TYPE(Text) CAPTION(Typ ceny)          CPOS(  1, 2.4) CLEN(  8)
    TYPE(Text) NAME(CENZBOZ->cTypSklCen)  CPOS(  1, 3.4) CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skl. cena)         CPOS( 11, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaSZBO)   CPOS( 11, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(CENZBOZ->cZkratMeny)  CPOS( 24, 3.4) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Množ. na skladì)   CPOS( 31, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozSZBO)   CPOS( 31, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(CENZBOZ->cZkratJedn)  CPOS( 44, 3.4) CLEN(  4) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skl. cena CELK)    CPOS( 50, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaCZBO)   CPOS( 50, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Jakost)            CPOS( 70, 2.4) CLEN( 10)
    TYPE(Text) NAME(CENZBOZ->cJakost)     CPOS( 70, 3.4) CLEN( 25) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

* 3.ø.
    TYPE(Text) CAPTION(Mn. k dispozici)   CPOS(  1, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozDZBO)   CPOS(  1, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. rezervované)   CPOS( 15, 4.6) CLEN( 14)
    TYPE(Text) NAME(CENZBOZ->nMnozRZBO)   CPOS( 15, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. objednané)     CPOS( 29, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozOZBO)   CPOS( 29, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. k objednání)   CPOS( 43, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozKZBO)   CPOS( 43, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena bez danì)     CPOS( 64, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaPZBO)   CPOS( 64, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( DPH )             CPOS( 77, 4.6) CLEN(  5)
    TYPE(Text) NAME(C_DPH->nProcDph)      CPOS( 77, 5.6) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(%)                 CPOS( 82, 5.6) CLEN(  2)
    TYPE(Text) CAPTION(Cena s daní)       CPOS( 85, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaMZBO)   CPOS( 85, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

  TYPE(End)