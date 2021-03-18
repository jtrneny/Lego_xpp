TYPE(drgForm) DTYPE(10) TITLE(Místa uložení) SIZE(105,25);
              GUILOOK(Action:y,IconBar:y);
              POST( PostValidate)

  TYPE(Action) CAPTION(~Položka pøep.)  EVENT(Prepocet_SKLPOL) TIPTEXT( Pøepoèet skladové položky ...)
  TYPE(Action) CAPTION(~Sklad pøep.)    EVENT(Prepocet_SKLAD)  TIPTEXT( Pøepoèet celého skladu ...)
  TYPE(Action) EVENT(SEPARATOR)
  TYPE(Action) CAPTION(~ULOŽIT)          EVENT(DoSave) TIPTEXT( Uložit ...)

TYPE(Static) STYPE(12) SIZE(104.3,3.5) FPOS(0.5, 0.1) CTYPE(2) RESIZE(yn)
  TYPE(Text) CAPTION(Sklad)            CPOS(  3, 0.5) CLEN(  8) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cCisSklad)  CPOS(  3, 1.5) CLEN(  8) FONT(5) BGND(13) PP(2)
  TYPE(Text) NAME(C_SKLADY->cNazSklad) CPOS( 12, 1.5) CLEN( 25) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(Sklad. položka)   CPOS( 39, 0.5) CLEN( 15) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cSklPol)    CPOS( 39, 1.5) CLEN( 15) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(Název zboží)      CPOS( 56, 0.5) CLEN( 30) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cNazZbo)    CPOS( 56, 1.5) CLEN( 30) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(Mn. na skladì)    CPOS( 88, 0.5) CLEN( 14) FONT(2)
  TYPE(Text) NAME(CENZBOZ->nMnozSZBO)  CPOS( 88, 1.5) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
TYPE(End)

  TYPE(Text) CAPTION( Místa uložení)  CPOS( 0.5, 3.7) CLEN( 104) FONT(2) BGND(14) CTYPE(4) RESIZE(yn)
*  TYPE(EBrowse) FILE(ULOZENIw) INDEXORD(1);
*               FIELDS( cUlozZbo             ,;
*                       NazevMist():Název místa uložení:26 ,;
*                       nPocStav:::::GET     ,;
*                       nUlozMnoz            ,;
*                       nUlozCelk:::::GET)    ;
*               SIZE(104, 5.7) FPOS(0,4.7) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn);
*               ITEMMARKED( itemMarked) ITEMSELECTED( itemSelected)

  TYPE(EBrowse) FILE(ULOZENIw) INDEXORD(1);
               SIZE(104, 5.7) FPOS(0,4.7) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn);
               ITEMMARKED( itemMarked) ITEMSELECTED( itemSelected)

    TYPE(TEXT) NAME( ULOZENIw->cUlozZbo)    FPOS( 1,0) CLEN(13)  CAPTION(Místo uložení )
    TYPE(TEXT) NAME( NazevMist() )          FPOS( 2,0) CLEN(13)  CAPTION(Název místa uložení )
    TYPE(GET)  NAME( ULOZENIw->nPocStav)    FPOS( 3,0) FLEN(13)  CAPTION(Poè.stav )
    TYPE(TEXT) NAME( ULOZENIw->nUlozMnoz)   FPOS( 4,0) CLEN(13)  CAPTION(Ulož.množ.)
    TYPE(GET)  NAME( ULOZENIw->nUlozCelk)   FPOS( 5,0) FLEN(13)  CAPTION(Ulož.celkem)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(104.3,1.2) FPOS(0.5, 10.5) RESIZE(yn)
    TYPE(Text) CAPTION(CELKEM)     CPOS( 28, 0.1) CLEN(  7)
    TYPE(Text) NAME(M->nPocStav)   CPOS( 35, 0.1) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->nUlozMnoz)  CPOS( 47, 0.1) CLEN( 12) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->nUlozCelk)  CPOS( 59, 0.1) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->cWarning)   CPOS( 72, 0.1) CLEN( 25) FONT(5) PP(2)
  TYPE(End)

  TYPE(Text) CAPTION( Pohyby na místech uložení) CPOS( 0.5, 11.8) CLEN( 104) FONT(2) BGND(14) CTYPE(4) RESIZE(yn)
  TYPE(Browse) FILE(PVPUloz) INDEXORD(2);
               FIELDS( nDoklad             ,;
                       nOrdItem            ,;
                       nCislPoh            ,;
                       NazevPoh():Název druhu pohybu:26 ,;
                       nUlozMnoz           ,;
                       M->TypPoh:Typ pohybu:2.7::2)             ;
               SIZE(104, 10.8) FPOS(0, 12.8) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn)

  TYPE(Static) STYPE(13) SIZE(104.3,1.2) FPOS(0.5, 23.7) RESIZE(yn)
    TYPE(Text) NAME(M->nUlozMnozPVP)  CPOS( 49, 0.1) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
  TYPE(End)