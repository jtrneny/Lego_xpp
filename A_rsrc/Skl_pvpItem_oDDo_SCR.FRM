TYPE(drgForm) DTYPE(10) TITLE(Dodavatelé zboží) SIZE(110,26) FILE(DODZBOZ);
              GUILOOK(Action:y,IconBar:y);
              POST( postVALIDATE)

TYPE(Action) CAPTION(info C~eník) EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

* info skladové položky
  TYPE(Static) STYPE(12) SIZE(109.8, 10) FPOS( .1, .1) CTYPE(2) RESIZE(yn)

*      TYPE(STATIC) STYPE(3) FPOS( -.3, .11) SIZE( 23,45 ) CAPTION(337)
*   1.ø.
    TYPE(Text) CAPTION(Sklad. položka)     CPOS(  1, 0.2) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cSklPol)      CPOS(  1, 1.2) CLEN( 20) BGND( 13) PP(2) FONT( 5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název zboží 2)      CPOS( 22, 0.2) CLEN( 30)
    TYPE(Text) NAME(CENZBOZ->cNazZbo2)     CPOS( 22, 1.2) CLEN( 35) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Kateg.)             CPOS( 58, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nZboziKat)    CPOS( 58, 1.2) CLEN(  6) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) NAME(C_KatZbo->cNazevKat)   CPOS( 64, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Úè.sk.)             CPOS( 83, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nUcetSkup)    CPOS( 83, 1.2) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) NAME(C_UctSkp->CNAZUCTSK)   CPOS( 88, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrGREEN)
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
* 4.ø.
    TYPE(Text) CAPTION(Typ èár.kódu)        CPOS(  1, 6.8) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cZkrCarKod)    CPOS(  1, 7.8) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èárový kód)          CPOS( 22, 6.8) CLEN( 10)
    TYPE(Text) NAME(CENZBOZ->cCarKod)       CPOS( 22, 7.8) CLEN( 85) BGND(13) FONT(5) GROUPS(clrGREY) 
  TYPE(End)

* možnost nastavení pøíjmových dokladù OD-DO
    TYPE(Static) STYPE(12) SIZE( 109.8,2.3) FPOS( .1, 10.3)  RESIZE(yx)
      TYPE(Text) CAPTION(datum_Od :)     CPOS(  10, .5) CLEN(12) FONT(5)
      TYPE(GET)  NAME(M->ddatDO_od)      FPOS(  22, .5) FLEN(12) PUSH(CLICKDATE)
      TYPE(Text) CAPTION(datum_Do :)     CPOS(  38, .5) CLEN(12) FONT(5)
      TYPE(GET)  NAME(M->ddatDO_do)      FPOS(  50, .5) FLEN(12) PUSH(CLICKDATE)

      TYPE(PushButton) POS(72, .5)   SIZE(35.3,1.2) CAPTION(~Komletní seznam pohybù položky) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(End)

* pvpitem   
    TYPE(DBrowse) FILE(PVPITEM) INDEXORD(20)                    ;
                  FIELDS( nDoklad                             , ;
                          dDatPVP:datPohybu:10                , ;
                          cObdPoh:obdPoh                      , ;
                          nCenNapDod:cena_Mj:13               , ;
                          nMnozPrDOD:množDok:13               , ;
                          nCenaCelk:cenaCelk:13               , ;
                          cTypPohybu:typPoh:8                 , ;                        
                          C_TypPoh->cNazTypPoh:název pohybu:30, ;
                          cCisZakaz:zakázka                   , ;
                          cUcetSkup:úèSkup:10                 , ;
                          nZboziKat:katZbo:5                  , ;
                          cNazPol1:výrStøedisko               , ;
                          cNazPol2:výrobek                    , ;
                          cNazPol3:zakázka                    , ;
                          cNazPol4:výrMísto                   , ;
                          cNazPol5:stroj                      , ;
                          cNazPol6:výrOperace                   ) ;
                  FPOS(-.1, 12.7) SIZE(109.6, 12.8) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy);
                  POPUPMENU(yy) FOOTER(y)
TYPE(End)


