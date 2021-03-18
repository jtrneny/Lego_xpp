TYPE(drgForm) DTYPE(10) TITLE(Pøedisponování rezervací na objednávku pøijatou) SIZE(110, 25) ;
                        GUILOOK(Action:y,Message:y,IconBar:y:MyIconBar,Menu:n);
                        POST( PostValidate) PRE( PreValidate)

TYPE(Action) CAPTION(info C~eník)   EVENT(SKL_CENZBOZ_INFO) TIPTEXT( Informaèní karta skladové položky)
TYPE(Action) CAPTION(info ~Zakázka) EVENT(VYR_VYRZAK_INFO)  TIPTEXT( Informaèní karta výrobní zakázky)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~K obj. nuluj )  EVENT( EMPTY_KObj ) TIPTEXT( Vynulování sloupce K objednání)
TYPE(Action) CAPTION(~Rezerv. nuluj)  EVENT( EMPTY_Rezer) TIPTEXT( Vynulování sloupce Rezervováno)

* Objednávka pøijatá
  TYPE(Static) STYPE(13) SIZE(109.5,3.6) FPOS(0.2,0.2) CTYPE(2) RESIZE(yn)
    TYPE(Text) CAPTION(Objednávka pøijatá) CPOS(  1, 0.2) CLEN( 17) FONT(2)
    TYPE(GET)  NAME(M->CislObInt)          FPOS(  1, 1.4) FLEN( 35) PUSH( ODB_OBJHEAD_SEL) PICTURE(&30X)

    TYPE(Text) CAPTION(Odbìratel)          CPOS( 39, 0.2) CLEN( 10) FONT(2)
    TYPE(Text) NAME(ObjHead->nCisFirmy)    CPOS( 39, 1.4) CLEN( 10) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)

    TYPE(Text) CAPTION(Název odbìratele)   CPOS( 50, 0.2) CLEN( 20) FONT(2)
    TYPE(Text) NAME(Firmy->cNazev)         CPOS( 50, 1.4) CLEN( 55) BGND( 13) FONT(5) GROUPS( clrGREY)
  TYPE(End)

  TYPE(EBrowse) FILE( OBJITEMw) INDEXORD(3) ;
               FPOS( 0.1, 5.3) SIZE(109.8,14.3) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(ny);
               ITEMMARKED( ItemMarked)

    TYPE(TEXT) NAME( OBJITEMw->cSklPol)    FPOS( 1,0) CLEN(17)  CAPTION(Sklad. položka)
    TYPE(TEXT) NAME( OBJITEMw->cNazZBO)    FPOS( 2,0) CLEN(25)  CAPTION(Název zboží)
    TYPE(TEXT) NAME( OBJITEMw->nMnozObDod) FPOS( 3,0) CLEN(12)  CAPTION(Objednáno u dod.)
    TYPE(GET)  NAME( OBJITEMw->nMnozKoDod) FPOS( 4,0) FLEN(12)  CAPTION(K obj. u dod. )
    TYPE(TEXT) NAME( OBJITEMw->nMnozObOdb) FPOS( 5,0) CLEN(12)  CAPTION(Objednáno odb.)
    TYPE(GET)  NAME( OBJITEMw->nMnozReOdb) FPOS( 6,0) FLEN(12)  CAPTION(Rezervováno )
    TYPE(TEXT) NAME( OBJITEMw->nMnozPlOdb) FPOS( 7,0) CLEN(12)  CAPTION(Plnìní)
  TYPE(End)

*
  TYPE(Static) STYPE(12) SIZE(109.6,1.6) FPOS(0.2,3.8) RESIZE(yn)
    TYPE(Text)       CAPTION( Položky objednávky) CPOS( 1, 0.1) CLEN( 20) SIZE(20, 1.2) FONT(7)
    TYPE(PushButton) CAPTION( ULOŽIT REZERVACE)    POS(90, 0.2) SIZE(18, 1.1) EVENT('Save_rezerv') PRE(2) FONT(5)
*    TYPE(PushButton) CAPTION( Uložit rezervace)    POS(94, 0.2) SIZE(15, 1.1) EVENT() PRE(2) FONT(5)
  TYPE(End)

*
  TYPE(TabPage) TTYPE(4) CAPTION(Ceník zboží) FPOS(0, 20.3) SIZE(110, 4.7) OFFSET(1,82) RESIZE(yx)

    TYPE(Text) CAPTION(Mn. skladové)      CPOS(  3, 0.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozSZBO)   CPOS(  3, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Mn. k objednání)   CPOS( 18, 0.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozKZBO)   CPOS( 18, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Mn. objednané)     CPOS( 33, 0.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozOZBO)   CPOS( 33, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Mn. k dispozici)   CPOS( 48, 0.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozDZBO)   CPOS( 48, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Mn. rezervované)   CPOS( 63, 0.4) CLEN( 14)
    TYPE(Text) NAME(CENZBOZ->nMnozRZBO)   CPOS( 63, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Rezerv. výroba)    CPOS( 78, 0.4) CLEN( 14)
    TYPE(Text) NAME(CENZBOZ->nMnozRSES)   CPOS( 78, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS( clrGREY)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Výrobní zakázka) FPOS(0,20.3) SIZE(110, 4.7) OFFSET(18,66) RESIZE(yx)

    TYPE(Text) CAPTION(Výrobní zakázka)   CPOS(  3, 0.4) CLEN( 15)
    TYPE(Text) NAME(VyrZAK->cCisZakaz)    CPOS(  3, 1.4) CLEN( 35) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Název zakázky)     CPOS( 40, 0.4) CLEN( 13)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 40, 1.4) CLEN( 40) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Èíslo plánu)       CPOS( 82, 0.4) CLEN( 13)
    TYPE(Text) NAME(VyrZAK->cCisPlan)     CPOS( 82, 1.4) CLEN( 15) BGND( 13) FONT(5) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Stav)              CPOS( 99, 0.4) CLEN(  5)
    TYPE(Text) NAME(VyrZAK->cStavZakaz)   CPOS( 99, 1.4) CLEN(  4) BGND( 13) FONT(5) GROUPS( clrGREY)
  TYPE(End)

  TYPE(Text) CAPTION( K dispozici CELKEM :)  CPOS( 60, 19.9) CLEN( 20) SIZE(20, 1.2) FONT(5)
  TYPE(Text) NAME(M->nKDispozCELK)           CPOS( 80, 19.9) CLEN( 15) CTYPE(2) BGND( 13) FONT(5)  GROUPS(clrYELL)