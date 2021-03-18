TYPE(drgForm) DTYPE(10) TITLE(Pøedisponování rezervací na skladovou položku) SIZE(100, 25);
               GUILOOK(Action:y,Message:y,IconBar:y:MyIconBar,Menu:n);
               POST( PostValidate) PRE( PreValidate)

TYPE(Action) CAPTION(info C~eník)   EVENT(SKL_CENZBOZ_INFO) TIPTEXT( Informaèní karta skladové položky)
TYPE(Action) CAPTION(info ~Zakázka) EVENT(VYR_VYRZAK_INFO)  TIPTEXT( Informaèní karta výrobní zakázky)

* Skladová položka
  TYPE(Static) STYPE(13) SIZE(99.5,3.6) FPOS(0.2,0.2) CTYPE(2) RESIZE(yn)
    TYPE(Text) CAPTION(Skladová položka)   CPOS(  1, 0.2) CLEN( 20) FONT(2)
    TYPE(GET)  NAME(M->SklPol)             FPOS(  1, 1.4) FLEN(18) FONT(5) PUSH( SKL_CENZBOZ_SEL)

    TYPE(Text) CAPTION(Název zboží)        CPOS( 22, 0.2) CLEN( 14) FONT(2)
    TYPE(Text) NAME(CenZBOZ->cNazZbo)      CPOS( 22, 1.4) CLEN( 35) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Sklad)              CPOS( 58, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(CenZBOZ->cCisSklad)    CPOS( 58, 1.4) CLEN( 10) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název skladu)       CPOS( 70, 0.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(C_Sklady->cNazSklad)   CPOS( 70, 1.4) CLEN( 25) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
  TYPE(End)

    TYPE(EBrowse) FILE( OBJITEMw) INDEXORD(2) ;
                  FPOS( 0.1, 5.2) SIZE(99.8,14.3) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(ny) POPUPMENU(yn);
                  ITEMMARKED(itemMarked)

      TYPE(TEXT) NAME( OBJITEMw->cCislObInt)    FPOS( 1,0) CLEN(17)  CAPTION(È.obj. interní)
      TYPE(TEXT) NAME( OBJITEMw->nMnozObDod)    FPOS( 2,0) CLEN(13)  CAPTION(Objednáno u dod.)
      TYPE(GET)  NAME( OBJITEMw->nMnozEdit)     FPOS( 3,0) FLEN(13)  CAPTION(K obj. u dod. )
      TYPE(TEXT) NAME( OBJITEMw->nMnozObOdb)    FPOS( 4,0) CLEN(13)  CAPTION(Objednáno odb.)
      TYPE(GET)  NAME( OBJITEMw->nMnozReOdb)    FPOS( 5,0) FLEN(13)  CAPTION(Rezervováno )
      TYPE(TEXT) NAME( OBJITEMw->nMnozPlOdb)    FPOS( 6,0) CLEN(13)  CAPTION(Plnìní )

    TYPE(End)

  TYPE(Static) STYPE(12) SIZE(99.6,1.5) FPOS(0.2,3.8) RESIZE(yn)
    TYPE(Text)       CAPTION( Objednávky pøijaté)   CPOS( 1, 0.1) CLEN( 20) SIZE(20, 1.2) FONT(7)
    TYPE(PushButton) CAPTION( Uložit rezervace)     POS(84, 0.2) SIZE(15, 1.1) EVENT('Save_rezerv' ) PRE(2)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Ceník zboží) FPOS(0, 20.3) SIZE(100, 4.7) OFFSET(1,82) RESIZE(yx)

    TYPE(Static) STYPE(2) SIZE( 98,2.9) FPOS( 1,0.1) RESIZE(yy)
      TYPE(Text) CAPTION(Mn. skladové)      CPOS(  3, 0.4) CLEN( 13)
      TYPE(Text) NAME(CENZBOZ->nMnozSZBO)   CPOS(  3, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. k objednání)   CPOS( 18, 0.4) CLEN( 13)
      TYPE(Text) NAME(CENZBOZ->nMnozKZBO)   CPOS( 18, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. objednané)     CPOS( 33, 0.4) CLEN( 13)
      TYPE(Text) NAME(CENZBOZ->nMnozOZBO)   CPOS( 33, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. k dispozici)   CPOS( 48, 0.4) CLEN( 13)
      TYPE(Text) NAME(CENZBOZ->nMnozDZBO)   CPOS( 48, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Mn. rezervované)   CPOS( 63, 0.4) CLEN( 14)
      TYPE(Text) NAME(CENZBOZ->nMnozRZBO)   CPOS( 63, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Rezerv. výroba)    CPOS( 78, 0.4) CLEN( 14)
      TYPE(Text) NAME(CENZBOZ->nMnozRSES)   CPOS( 78, 1.4) CLEN( 13) CTYPE(2) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(End)

  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Výrobní zakázka) FPOS(0,20.3) SIZE(100, 4.7) OFFSET(18,66) RESIZE(yx)

    TYPE(Static) STYPE(2) SIZE( 98,2.9) FPOS( 1,0.1) RESIZE(yy)
      TYPE(Text) CAPTION(Výrobní zakázka)   CPOS(  3, 0.4) CLEN( 15)
      TYPE(Text) NAME(VyrZAK->cCisZakaz)    CPOS(  3, 1.4) CLEN( 35) BGND( 13) FONT(5)  GROUPS(clrGREY)
      TYPE(Text) CAPTION(Název zakázky)     CPOS( 40, 0.4) CLEN( 13)
      TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 40, 1.4) CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Èíslo plánu)       CPOS( 77, 0.4) CLEN( 13)
      TYPE(Text) NAME(VyrZAK->cCisPlan)     CPOS( 77, 1.4) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
      TYPE(Text) CAPTION(Stav)              CPOS( 93, 0.4) CLEN(4.5)
      TYPE(Text) NAME(VyrZAK->cStavZakaz)   CPOS( 93, 1.4) CLEN(  4) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(End)

  TYPE(End)

  TYPE(Text) CAPTION( K dispozici CELKEM :)  CPOS( 60, 19.7) CLEN( 20) SIZE(20, 1.2) FONT(5)
  TYPE(Text) NAME(M->nKDispozCELK)           CPOS( 80, 19.7) CLEN( 15) CTYPE(2) BGND( 13) FONT(5)  GROUPS(clrYELL)