TYPE(drgForm) DTYPE(10) TITLE(Místa uložení, pro skladovou položku ...) SIZE(105,25) ;
              POST( PostValidate)                         ;
              GUILOOK(Action:y,Message:y,IconBar:n,Menu:n)


  TYPE(Action) CAPTION(~Položka pøep.)  EVENT(Prepocet_SKLPOL) TIPTEXT( Pøepoèet skladové položky ...)
  TYPE(Action) CAPTION(~Sklad pøep.)    EVENT(Prepocet_SKLAD)  TIPTEXT( Pøepoèet celého skladu ...)
  TYPE(Action) EVENT(SEPARATOR)
  TYPE(Action) CAPTION(~ULOŽIT)          EVENT(DoSave) TIPTEXT( Uložit ...)

TYPE(Static) STYPE(12) SIZE(104.3, 2.5) FPOS(.2,.01) CTYPE(2) RESIZE(yn)
  TYPE(Text) CAPTION(sklad)            CPOS(  3, 0  ) CLEN(  8) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cCisSklad)  CPOS(  3, 1.2) CLEN(  8) FONT(5) BGND(13) PP(2)
  TYPE(Text) NAME(C_SKLADY->cNazSklad) CPOS( 12, 1.2) CLEN( 25) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(sklPoložka)       CPOS( 39, 0  ) CLEN( 15) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cSklPol)    CPOS( 39, 1.2) CLEN( 15) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(Název zboží)      CPOS( 56, 0  ) CLEN( 30) FONT(2)
  TYPE(Text) NAME(CENZBOZ->cNazZbo)    CPOS( 56, 1.2) CLEN( 30) FONT(5) BGND(13) PP(2)
  TYPE(Text) CAPTION(sklMnožství)      CPOS( 88, 0  ) CLEN( 14) FONT(2)
  TYPE(Text) NAME(CENZBOZ->nMnozSZBO)  CPOS( 88, 1.2) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
TYPE(End)

**  TYPE(Text) CAPTION( Místa uložení)  CPOS( 0.5, 3.7) CLEN( 104) FONT(2) BGND(14) CTYPE(4) RESIZE(yn)

  TYPE(EBrowse) FILE(ulozeni) INDEXORD(1);
                FPOS(0, 2.7) SIZE(105, 8.9) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn);
                ITEMMARKED( itemMarked) ITEMSELECTED( itemSelected) FOOTER(y)

    TYPE(GET)  NAME( ULOZENI->culozZbo )    FPOS( 1,0) CLEN(13)  CAPTION(místoUložení )        
    TYPE(TEXT) NAME( M->nazevMist      )    FPOS( 2,0) CLEN(47)  CAPTION(název Místa uložení )
    TYPE(GET)  NAME( ULOZENI->nPocStav )    FPOS( 3,0) FLEN(13)  CAPTION(poèStav)
    TYPE(TEXT) NAME( ULOZENI->nUlozMnoz)    FPOS( 4,0) CLEN(13)  CAPTION(UložMno)
    TYPE(GET)  NAME( ULOZENI->nUlozCelk)    FPOS( 5,0) FLEN(13)  CAPTION(UložCelk)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(104.3,1.2) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(CELKEM)     CPOS( 0, 0) CLEN(  0)
    TYPE(Text) NAME(M->nPocStav)   CPOS( 0, 0) CLEN( 0) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->nUlozMnoz)  CPOS( 0, 0) CLEN( 0) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->nUlozCelk)  CPOS( 0, 0) CLEN( 0) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->cWarning)   CPOS( 0, 0) CLEN( 0) FONT(5) PP(2)
  TYPE(End)

**
  TYPE(Text) CAPTION( Pohyby na místech uložení) CPOS( 0.5, 11.8) CLEN( 104) FONT(2) BGND(14) CTYPE(1) RESIZE(yn)
  TYPE(dBrowse) FPOS(0,12.8) SIZE(105,11.8) FILE(PVPITEM) INDEXORD(1);
                  FIELDS( nDoklad:doklad           , ;
                          ccisSklad:sklad:9        , ;  
                          csklPol:sklPoložka:14    , ;
                          cnazZbo:název zboží:30   , ;
                          nmnozPRdod:množ_Nadokl:12, ;
                          czkratJedn:mj            , ;
                          ncenNAPdod:cena_Zamj     , ;
                          nCenaCelk:cenaCelkem     , ;
                          nCenapZBO:cena_bezDph    , ;
                          nCenapDZBO:cena_sDph       ) ;
                  CURSORMODE(3) PP(7) SCROLL(yy)  RESIZE(yy) POPUPMENU(y) FOOTER(y)  ;
                  ITEMMARKED( ItemMarked)

  TYPE(Static) STYPE(13) SIZE(104.3,1.2) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) NAME(M->nUlozMnozPVP)  CPOS( 0, 0) CLEN(0) FONT(5) BGND(13) PP(2) CTYPE(2)
  TYPE(End)